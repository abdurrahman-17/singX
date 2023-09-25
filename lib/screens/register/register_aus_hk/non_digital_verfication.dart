import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/service/auth_repository.dart';
import 'package:singx/core/notifier/register_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_font.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/drop_zone.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class AustraliaNonDigitalVerification extends StatelessWidget {
  const AustraliaNonDigitalVerification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => RegisterNotifier(context),
      child: Consumer<RegisterNotifier>(
        builder: (context, registerNotifier, _) {
          return Scaffold(
            body: buildBody(context, registerNotifier),
          );
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, RegisterNotifier registerNotifier) {
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                sizedBoxHeight20(context),
                Container(
                  padding: px15DimenHorizontal(context),
                  decoration: BoxDecoration(
                    borderRadius: radiusAll15(context),
                    color: fieldBackWhitegroundColor,
                    boxShadow: [
                      BoxShadow(
                          color: black.withOpacity(0.08),
                          blurRadius: 1,
                          offset: Offset(0, 2))
                    ],
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBoxHeight(context, 0.02),
                        buildIdentificationDetailsText(context),
                        SizedBoxHeight(context, 0.04),
                        buildPassportOrDrivingProofTitle(context),
                        SizedBoxHeight(context, 0.01),
                        Padding(
                          padding: px16DimenLeftOnly(context),
                          child: Column(
                            children: [
                              buildDocuments(context,
                                  text: S.of(context).passportPhotoPage),
                              buildDocuments(context,
                                  text: S.of(context).driverLicenseFrontBack),
                            ],
                          ),
                        ),
                        SizedBoxHeight(context, 0.03),
                        kIsWeb
                            ? buildDragAndDropBox(registerNotifier, context)
                            : buildDragAndDropBoxMobile(
                                registerNotifier, context),
                        Visibility(
                            visible: registerNotifier.isFileAddedVerification,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                        SizedBoxHeight(context, 0.04),
                        buildPhotoIdOrBillProofTitle(context),
                        SizedBoxHeight(context, 0.01),
                        Padding(
                          padding: px16DimenLeftOnly(context),
                          child: Column(
                            children: [
                              buildDocuments(context,
                                  text: S.of(context).stateIssuedPhotoIDCard),
                              buildDocuments(context,
                                  text:
                                      S.of(context).StateIssuedProofOfAgeCard),
                              buildDocuments(context,
                                  text: S
                                      .of(context)
                                      .validVisaApprovalDocumentShowingYourNameDateOfBirth),
                              buildDocuments(context,
                                  text: S
                                      .of(context)
                                      .utilityBillElectricityGasTelephoneWithCurrentAddress),
                              buildDocuments(context,
                                  text: S
                                      .of(context)
                                      .bankStatementWithCurrentAddress),
                            ],
                          ),
                        ),
                        SizedBoxHeight(context, 0.03),
                        kIsWeb
                            ? buildDragAndDropBoxOption2(
                                registerNotifier, context)
                            : buildDragAndDropBoxMobileOption2(
                                registerNotifier,
                                context,
                              ),
                        Visibility(
                            visible: registerNotifier
                                .isFileAddedAdditionalVerification,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBoxHeight(context, 0.01),
                                buildText(
                                    text: registerNotifier.isFileAddedAdditional
                                        ? S.of(context).pleaseWaitUntilTheDocumentIsUploaded : S
                                        .of(context)
                                        .noFilesUploadedPleaseUploadAtLeastOneValidDocument,
                                    fontColor: errorTextField,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.5)
                              ],
                            )),
                        SizedBoxHeight(context, 0.04),
                      ]),
                ),
                SizedBoxHeight(context, 0.04),
                Row(
                  children: [
                    Expanded(child: Container()),
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
                          registerNotifier.isFileUploadedToServer
                              ? registerNotifier.isFileAddedVerification = false
                              : registerNotifier.isFileAddedVerification = true;
                          registerNotifier.isFileUploadedToServer2
                              ? registerNotifier.isFileAddedAdditionalVerification = false
                              : registerNotifier
                                  .isFileAddedAdditionalVerification = true;
                          if (registerNotifier.isFileUploadedToServer &&
                              registerNotifier.isFileUploadedToServer2) {
                            await kIsWeb
                                ? AuthRepository().apiNonCRAFileUpload(
                                    registerNotifier.fileNonDigital1,
                                    registerNotifier.fileNonDigital1,
                                    context)
                                : AuthRepository().apiNonCRAFileUpload(
                                    registerNotifier.filesAdditionalMob1,
                                    registerNotifier.filesAdditionalMob1,
                                    context);
                            await kIsWeb
                                ? AuthRepository().apiNonCRAFileUpload(
                                    registerNotifier.fileNonDigital2,
                                    registerNotifier.fileNonDigital2,
                                    context,
                                    navigate: true)
                                : AuthRepository().apiNonCRAFileUpload(
                                    registerNotifier.filesAdditionalMob2,
                                    registerNotifier.filesAdditionalMob2,
                                    context,
                                    navigate: true);
                            SharedPreferencesMobileWeb.instance
                                .setMethodSelectedAUS('methodSelectedAUS',false);
                          } else {}
                        },
                        onPressedBack: () async =>
                            await SharedPreferencesMobileWeb.instance
                                .getCountry(country)
                                .then((value) async {
                              Navigator.pushReplacementNamed(
                                  context, personalDetailsAustraliaRoute);
                            })),
                    Expanded(child: Container()),
                  ],
                ),
                SizedBoxHeight(context, 0.04),
              ],
            )),
      ),
    );
  }

  Widget buildIdentificationDetailsText(BuildContext context) {
    return buildText(
      text: S.of(context).identificationDetails,
      fontSize: AppConstants.twenty,
      fontWeight: AppFont.fontWeightBold,
    );
  }

  Widget buildPassportOrDrivingProofTitle(BuildContext context) {
    return buildText(
        text: S.of(context).pleaseUploadAnyONEOfTheFollowingDocuments,
        fontWeight: AppFont.fontWeightRegular,
        fontColor: black);
  }

  Widget buildPhotoIdOrBillProofTitle(BuildContext context) {
    return buildText(
        text: S.of(context).pleaseAlsoUploadAnyONEOfTheseAdditionalDocuments,
        fontWeight: AppFont.fontWeightRegular,
        fontColor: black);
  }

  Widget buildDragAndDropBox(
      RegisterNotifier registerNotifier, BuildContext context) {
    return buildDropFilesBox(
      context: context,
      dropBox: 1,
      isFileAdded: registerNotifier.isFileAdded,
      loading: registerNotifier.isFileLoading,
      progressValue: registerNotifier.progressValue,
      file: registerNotifier.fileNonDigital1,
      isAllowMultiple: true,
      registerNotifier: registerNotifier,
      onDroppedFile: (file) {
        registerNotifier.fileNonDigital1 = file;
        registerNotifier.isFileAdded = true;
        updateProgress(registerNotifier);
      },
      onIconClosePressUpload: () {
        registerNotifier.isFileAdded = false;
        registerNotifier.isFileLoading = true;
        registerNotifier.progressValue = 0.0;
      },
      onIconClosePressFinish: () {
        registerNotifier.isFileAdded = false;
        registerNotifier.isFileLoading = true;
        registerNotifier.progressValue = 0.0;
      },
    );
  }

  Widget buildDragAndDropBoxOption2(
      RegisterNotifier registerNotifier, BuildContext context) {
    return buildDropFilesBox(
      context: context,
      dropBox: 2,
      isAllowMultiple: true,
      registerNotifier: registerNotifier,
      isFileAdded: registerNotifier.isFileAddedAdditional,
      loading: registerNotifier.isFileLoadingAdditional,
      progressValue: registerNotifier.extraprogressValue,
      file: registerNotifier.fileNonDigital2,
      onDroppedFile: (file) {
        registerNotifier.fileNonDigital2 = file;
        registerNotifier.isFileAddedAdditional = true;
        updateProgressOption2(registerNotifier);
      },
      onIconClosePressUpload: () {
        registerNotifier.isFileAddedAdditional = false;
        registerNotifier.isFileLoadingAdditional = true;
        registerNotifier.extraprogressValue = 0.0;
      },
      onIconClosePressFinish: () {
        registerNotifier.isFileAddedAdditional = false;
        registerNotifier.isFileLoadingAdditional = true;
        registerNotifier.extraprogressValue = 0.0;
      },
    );
  }

  Widget buildDragAndDropBoxMobile(
      RegisterNotifier registerNotifier, BuildContext context) {
    return buildDropFilesBoxMobile(
      context: context,
      isFileAdded: registerNotifier.isFileAdded,
      loading: registerNotifier.isFileLoading,
      isAllowMultiple: true,
      dropbox: 1,
      progressValue: registerNotifier.progressValue,
      registerNotifier: registerNotifier,
      file: registerNotifier.platformFileAdditional1,
      fileImage: registerNotifier.filesAdditionalMob1,
      size: registerNotifier.sizeAdditional1,
      onTap: () => selectFile(registerNotifier,context),
      onIconClosePressUpload: () {
        registerNotifier.isFileAdded = false;
        registerNotifier.isFileLoading = true;
        registerNotifier.progressValue = 0.0;
      },
      onIconClosePressFinish: () {
        registerNotifier.isFileAdded = false;
        registerNotifier.isFileLoading = true;
        registerNotifier.progressValue = 0.0;
      },
    );
  }

  Widget buildDragAndDropBoxMobileOption2(
      RegisterNotifier registerNotifier, BuildContext context) {
    return buildDropFilesBoxMobile(
      context: context,
      isAllowMultiple: true,
      registerNotifier: registerNotifier,
      dropbox: 2,
      isFileAdded: registerNotifier.isFileAddedAdditional,
      loading: registerNotifier.isFileLoadingAdditional,
      progressValue: registerNotifier.extraprogressValue,
      file: registerNotifier.platformFileAdditional2,
      fileImage: registerNotifier.filesAdditionalMob2,
      size: registerNotifier.sizeAdditional2,
      onTap: () => selectFileOption2(registerNotifier,context),
      onIconClosePressUpload: () {
        registerNotifier.isFileAddedAdditional = false;
        registerNotifier.isFileLoadingAdditional = true;
        registerNotifier.extraprogressValue = 0.0;
      },
      onIconClosePressFinish: () {
        registerNotifier.isFileAddedAdditional = false;
        registerNotifier.isFileLoadingAdditional = true;
        registerNotifier.extraprogressValue = 0.0;
      },
    );
  }

  Widget buildDocuments(BuildContext context, {text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(radius: 3.5, backgroundColor: black),
            SizedBox(
                width: getScreenWidth(context) < 800
                    ? getScreenWidth(context) * 0.01
                    : getScreenWidth(context) * 0.007),
            Flexible(
                child: buildText(
                    text: text,
                    fontWeight: AppFont.fontWeightRegular,
                    fontColor: black))
          ],
        ),
        SizedBox(height: getScreenHeight(context) * 0.01),
      ],
    );
  }

  selectFile(RegisterNotifier registerNotifier, BuildContext context) async {
    final file = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);

    if (file != null) {
      file.files.forEach((element) {
        var sizeInBytes = File(element.path!).lengthSync();
        var sizeInKb = sizeInBytes / 1024;
        var sizeInMb = sizeInKb / 1024;
        final kb = File(element.path!).lengthSync() / 1024;
        var sizeLimit = 5120;
        if (kb > sizeLimit) {
          //SnackBar(content: Text('Upload file less than 5MB'));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Upload file less than 5MB"),
            duration: Duration(seconds: 3),
          ));
        } else {
          String size = sizeInMb > 1
              ? '${sizeInMb.toStringAsFixed(2)} MB'
              : '${sizeInKb.toStringAsFixed(2)} KB';
          registerNotifier.filesAdditionalMob1.add(File(element.path!));
          registerNotifier.sizeAdditional1.add(size);
          registerNotifier.platformFileAdditional1.add(element);
          updateProgress(registerNotifier);
          registerNotifier.isFileAdded = true;
        }
      });
    }
  }

  selectFileOption2(RegisterNotifier registerNotifier, BuildContext context) async {
    final file = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);

    if (file != null) {
      file.files.forEach((element) {
        var sizeInBytes = File(element.path!).lengthSync();
        var sizeInKb = sizeInBytes / 1024;
        var sizeInMb = sizeInKb / 1024;
        final kb = File(element.path!).lengthSync() / 1024;
        var sizeLimit = 5120;
        if (kb > sizeLimit) {
          //SnackBar(content: Text('Upload file less than 5MB'));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Upload file less than 5MB"),
            duration: Duration(seconds: 3),
          ));
        } else {
          String size = sizeInMb > 1
              ? '${sizeInMb.toStringAsFixed(2)} MB'
              : '${sizeInKb.toStringAsFixed(2)} KB';
          registerNotifier.filesAdditionalMob2.add(File(element.path!));
          registerNotifier.sizeAdditional2.add(size);
          registerNotifier.platformFileAdditional2.add(element);
          updateProgressOption2(registerNotifier);
          registerNotifier.isFileAddedAdditional = true;
        }
      });
    }
  }

  void updateProgress(RegisterNotifier registerNotifier) {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer t) {
      registerNotifier.progressValue += 0.1;
      if (registerNotifier.progressValue <= 1.0) {
        if (!registerNotifier.isFileAdded) {
          registerNotifier.isFileUploadedToServer = false;
          t.cancel();
        }
        if (registerNotifier.progressValue.toStringAsFixed(1) == '1.0') {
          registerNotifier.isFileUploadedToServer = true;
          registerNotifier.isFileAddedVerification = false;
          registerNotifier.isFileLoading = false;
          t.cancel();
          return;
        }
      } else {
        t.cancel();
      }
    });
  }

  void updateProgressOption2(RegisterNotifier registerNotifier) {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer t) {
      registerNotifier.extraprogressValue += 0.1;
      if (registerNotifier.extraprogressValue <= 1.0) {
        if (!registerNotifier.isFileAddedAdditional) {
          registerNotifier.isFileUploadedToServer2 = false;
          t.cancel();
        }
        if (registerNotifier.extraprogressValue.toStringAsFixed(1) == '1.0') {
          registerNotifier.isFileUploadedToServer2 = true;
          registerNotifier.isFileAddedAdditionalVerification = false;
          registerNotifier.isFileLoadingAdditional = false;
          t.cancel();
          return;
        }
      } else {
        t.cancel();
      }
    });
  }
}
