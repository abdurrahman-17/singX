import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/service/contact_repository.dart';
import 'package:singx/core/models/request_response/jumio_verification/jumio_verification_response.dart';
import 'package:singx/core/notifier/common_notifier.dart';
import 'package:singx/core/notifier/register_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/main.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_font.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/drop_zone.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/common/my_mob_fun.dart'
    if (dart.library.html) 'package:singx/utils/common/my_web_fun.dart' as html;
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class UploadAddressScreen extends StatelessWidget {
  String? transactionReference;

  UploadAddressScreen({Key? key, this.transactionReference}) : super(key: key);

  ContactRepository contactRepository = ContactRepository();

  @override
  Widget build(BuildContext context) {

    return transactionReference!.isNotEmpty?Container(): ChangeNotifierProvider(
      create: (BuildContext context) => RegisterNotifier(context, selected: 6, referenceNumber: transactionReference),
      child: Consumer<RegisterNotifier>(
        builder: (context, registerNotifier, _) {
          return Scrollbar(
            controller: registerNotifier.scrollController,
            child: SingleChildScrollView(
              controller: registerNotifier.scrollController,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getScreenWidth(context) < 450
                        ? getScreenWidth(context) * 0.05
                        : isMobile(context)
                            ? getScreenWidth(context) * 0.15
                            : getScreenWidth(context) * 0.25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBoxHeight(context, 0.07),
                    buildUploadAddressText(context),
                    SizedBoxHeight(context, 0.02),
                    buildUploadAddressInfoText(context),
                    SizedBoxHeight(context, 0.04),
                    buildDocuments(context, text: S.of(context).phoneBill),
                    buildDocuments(context, text: S.of(context).bankStatement),
                    buildDocuments(context,
                        text: S.of(context).creditCardStatement),
                    buildDocuments(context, text: S.of(context).utilityBill),
                    buildDocuments(context,
                        text: S.of(context).tenancyContract),
                    buildDocuments(context,
                        text: S.of(context).hdbConfirmation),
                    buildDocuments(context,
                        text: S.of(context).finOrWorkPermit, height: 1.55),
                    SizedBoxHeight(context, 0.03),
                    kIsWeb
                        ? buildDragAndDropBox(registerNotifier, context)
                        : buildDragAndDropBoxMobile(registerNotifier, context),
                    Visibility(
                        visible: registerNotifier.isFileAddedVerification,
                        child: Column(
                          children: [
                            SizedBoxHeight(context, 0.01),
                            buildText(
                                text: registerNotifier.isFileAdded
                                    ? S.of(context).pleaseWaitUntilTheDocumentIsUploaded :S
                                    .of(context)
                                    .noFilesUploadedPleaseUploadAtLeastOneValidDocument,
                                fontColor: errorTextField,
                                fontWeight: FontWeight.w500,
                                fontSize: 11.5)
                          ],
                        )),
                    SizedBoxHeight(context, 0.02),
                    registerNotifier.errorList.isEmpty
                        ? SizedBox()
                        : Text(
                            registerNotifier.errorList[0],
                            style: errorMessageStyle(context),
                          ),
                    SizedBoxHeight(context, 0.05),
                    commonBackAndContinueButton(context,
                        backWidth: getScreenWidth(context) < 450
                            ? getScreenWidth(context) * 0.43
                            : isMobile(context)
                                ? getScreenWidth(context) * 0.34
                                : null,
                        continueWidth: getScreenWidth(context) < 450
                            ? getScreenWidth(context) * 0.43
                            : isMobile(context)
                                ? getScreenWidth(context) * 0.34
                                : null,
                        onPressedContinue: () async {
                          Provider.of<CommonNotifier>(context, listen: false)
                              .updateUserVerifiedBool = false;
                          SharedPreferencesMobileWeb.instance.setUserVerified(false);
                          registerNotifier.isFileUploadedToServer
                              ? registerNotifier.isFileAddedVerification = false
                              : registerNotifier.isFileAddedVerification = true;
                          if (registerNotifier.isFileUploadedToServer == true) {
                            kIsWeb
                                      ? await contactRepository
                                          .apiSGFileUpload(
                                          registerNotifier.file!.path,
                                          context,
                                          '',
                                          "PROOF_OF_ADDRESS",
                                          fileName: registerNotifier.file!.name,
                                        )
                                          .then((value) async {
                                    if (value == true) {
                                      await contactRepository
                                          .apiJumioVerification(
                                              true, "00000000", context)
                                          .then((value) async {
                                        JumioVerificationResponse
                                            jumioVerificationResponse =
                                            value as JumioVerificationResponse;
                                        SharedPreferencesMobileWeb.instance.setJumioReference('jumioRefernce',jumioVerificationResponse.transactionReference!);
                                        html.openLink(
                                            '${jumioVerificationResponse.web?.href}');
                                      });
                                    }
                                  })
                                : await contactRepository
                                    .apiSGFileUpload(
                                        registerNotifier.files!.path,
                                        context,
                                        '',
                                        "PROOF_OF_ADDRESS")
                                    .then((value) async {
                                    if (value == true) {
                                      apiLoader(context);
                                      await contactRepository
                                          .apiJumioVerification(
                                              true, "00000000", context)
                                          .then((value) async {
                                        MyApp.navigatorKey.currentState!.maybePop();
                                        JumioVerificationResponse
                                            jumioVerificationResponse =
                                            value as JumioVerificationResponse;
                                        await registerNotifier.callJumioApis(
                                            context,
                                            "${jumioVerificationResponse.transactionReference}",
                                            "${jumioVerificationResponse.sdk?.token}");
                                      });
                                      Navigator.pop(context);
                                      return;
                                    }
                                  });
                          }
                        },
                        onPressedBack: () async =>
                            await SharedPreferencesMobileWeb.instance
                                .getCountry(country)
                                .then((value) async {
                              Navigator.pushNamed(
                                  context, verificationMethodRoute);
                            })),
                    SizedBoxHeight(context, 0.05),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildUploadAddressText(BuildContext context) {
    return buildText(
      text: S.of(context).uploadProofOfAdddress,
      fontSize: AppConstants.twenty,
      fontWeight: AppFont.fontWeightBold,
    );
  }

  Widget buildUploadAddressInfoText(BuildContext context) {
    return buildText(
      text: S.of(context).documentLessThan3Month,
      fontSize: AppConstants.sixteen,
      fontWeight: AppFont.fontWeightRegular,
      fontColor: oxfordBlueTint400,
    );
  }

  Widget buildDragAndDropBox(
      RegisterNotifier registerNotifier, BuildContext context) {
    return buildDropFilesBox(
      context: context,
      isFileAdded: registerNotifier.isFileAdded,
      loading: registerNotifier.isFileLoading,
      progressValue: registerNotifier.progressValue,
      file: registerNotifier.file,
      onDroppedFile: (file) {
        registerNotifier.file = file;
        registerNotifier.isFileAdded = true;
        updateProgress(registerNotifier);
      },
      onIconClosePressUpload: () {
        registerNotifier.isFileUploadedToServer = false;
        registerNotifier.isFileAdded = false;
        registerNotifier.isFileLoading = true;
        registerNotifier.progressValue = 0.0;
      },
      onIconClosePressFinish: () {
        registerNotifier.isFileUploadedToServer = false;
        registerNotifier.isFileAdded = false;
        registerNotifier.isFileLoading = true;
        registerNotifier.progressValue = 0.0;
      },
    );
  }

  Widget buildDragAndDropBoxMobile(
      RegisterNotifier registerNotifier, BuildContext context) {
    return buildDropFilesBoxMobile(
      context: context,
      isFileAdded: registerNotifier.isFileAdded,
      loading: registerNotifier.isFileLoading,
      progressValue: registerNotifier.progressValue,
      file: registerNotifier.platformFile,
      fileImage: registerNotifier.files,
      size: registerNotifier.size,
      onTap: () => selectFile(registerNotifier,context),
      registerNotifier: registerNotifier,
      onIconClosePressUpload: () {
        registerNotifier.isFileUploadedToServer = false;
        registerNotifier.isFileAdded = false;
        registerNotifier.isFileLoading = true;
        registerNotifier.progressValue = 0.0;
      },
      onIconClosePressFinish: () {
        registerNotifier.isFileUploadedToServer = false;
        registerNotifier.isFileAdded = false;
        registerNotifier.isFileLoading = true;
        registerNotifier.progressValue = 0.0;
      },
    );
  }

  Widget buildDocuments(BuildContext context, {text, double? height}) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(1, 1, 16, 1),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\u2022',
                style: TextStyle(
                  fontSize: 30,
                  height: 1,
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Container(
                  child: buildText(
                    text: text,
                    fontSize: 16,
                    fontColor: black,
                    fontWeight: AppFont.fontWeightRegular,
                    height: 1.55,
                  ),
                ),
              ),
            ],
          )
        ]));
  }

  // Picking files from Folder
  selectFile(RegisterNotifier registerNotifier, BuildContext context) async {
    final file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);

    if (file != null) {
      registerNotifier.files = File(file.files.single.path!);
      var sizeInBytes = registerNotifier.files!.lengthSync();
      var sizeInKb = sizeInBytes / 1024;
      var sizeInMb = sizeInKb / 1024;
      final kb = registerNotifier.files!.lengthSync() / 1024;
      var sizeLimit = 5120;
      if (kb > sizeLimit) {
        //SnackBar(content: Text('Upload file less than 5MB'));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Upload file less than 5MB"),
          duration: Duration(seconds: 3),

        ));
      } else {
        registerNotifier.size = sizeInMb > 1
            ? '${sizeInMb.toStringAsFixed(2)} MB'
            : '${sizeInKb.toStringAsFixed(2)} KB';
        registerNotifier.platformFile = file.files.first;
        updateProgress(registerNotifier);
        registerNotifier.isFileAdded = true;
      }
    }
  }

  //Uploading data progress value
  updateProgress(RegisterNotifier registerNotifier) {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer t) {
      registerNotifier.progressValue += 0.3;
      if (!registerNotifier.isFileAdded) {
        registerNotifier.isFileUploadedToServer = false;
        t.cancel();
      }
      if (registerNotifier.progressValue.toStringAsFixed(1) == '0.9') {
        registerNotifier.isFileUploadedToServer = true;
        registerNotifier.isFileAddedVerification = false;
        registerNotifier.isFileLoading = false;
        t.cancel();
        return;
      }
    });
  }


}
