import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/service/contact_repository.dart';
import 'package:singx/core/notifier/common_notifier.dart';
import 'package:singx/core/notifier/register_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/main.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_font.dart';
import 'package:singx/utils/common/app_images.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/common/drop_zone.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class AddressVerifyScreen extends StatelessWidget {
  AddressVerifyScreen({Key? key}) : super(key: key);

  ContactRepository contactRepository = ContactRepository();

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => RegisterNotifier(context),
      child: Consumer<RegisterNotifier>(
        builder: (context, registerNotifier, _) {
          return Scaffold(
            backgroundColor: white,
            body: Scrollbar(
              controller: registerNotifier.scrollController,
              child: SingleChildScrollView(
                controller: registerNotifier.scrollController,
                child: Form(
                  key: registerNotifier.addressFormKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getScreenWidth(context) < 450
                            ? getScreenWidth(context) * 0.05
                            : isTab(context)
                                ? getScreenWidth(context) * 0.20
                                : isMobile(context)
                                    ? getScreenWidth(context) * 0.10
                                    : getScreenWidth(context) * 0.25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBoxHeight(context, 0.07),
                        buildAddressVerifyText(context),
                        SizedBoxHeight(context, 0.01),
                        buildAddressVerifySubText(context),
                        SizedBoxHeight(context, 0.04),
                        isTab(context) || isMobile(context)
                            ? buildFinNumberTextAndTextFieldTab(
                                registerNotifier, context)
                            : buildFinNumberTextAndTextField(
                                registerNotifier, context),
                        SizedBoxHeight(context, 0.01),
                        buildAddressProofText(context),
                        SizedBoxHeight(context, 0.01),
                        Padding(
                          padding: EdgeInsets.only(
                              right: getScreenWidth(context) * 0.04),
                          child: buildAddressProofConditionText(context),
                        ),
                        SizedBoxHeight(context, 0.04),
                        kIsWeb
                            ? buildDragAndDropBox(registerNotifier, context)
                            : buildDragAndDropBoxMobile(
                                registerNotifier, context),
                        Visibility(
                            visible: registerNotifier.isFileAddedVerification,
                            child: Column(
                              children: [
                                SizedBoxHeight(context, 0.01),
                                buildText(
                                    text:registerNotifier.isFileAdded
                                        ? S.of(context).pleaseWaitUntilTheDocumentIsUploaded : S
                                        .of(context)
                                        .noFilesUploadedPleaseUploadAtLeastOneValidDocument,
                                    fontColor: errorTextField,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.5)
                              ],
                            )),
                        SizedBoxHeight(context, 0.04),
                        buildButtons(registerNotifier, context),
                        SizedBoxHeight(context, 0.05),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildAddressVerifyText(BuildContext context) {
    return buildText(
        text: S.of(context).addressVerify,
        fontSize: AppConstants.twenty,
        fontWeight: AppFont.fontWeightBold);
  }

  Widget buildAddressVerifySubText(BuildContext context) {
    return buildText(
        text: S.of(context).verifyAddressByFillDetail,
        fontSize: AppConstants.sixteen,
        fontWeight: AppFont.fontWeightRegular,
        fontColor: oxfordBlueTint400);
  }

  Widget buildFinNumberTextAndTextField(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildFinNRICNumberText(context),
            SizedBox(height: getScreenHeight(context) * 0.01),
            buildFinNRICNumberTextField(registerNotifier, context)
          ],
        ),
        SizedBox(width: getScreenWidth(context) * 0.02),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildFinNRICExpiryText(context),
            SizedBox(height: getScreenHeight(context) * 0.01),
            buildFinNRICExpiryTextField(registerNotifier, context)
          ],
        )
      ],
    );
  }

  Widget buildFinNumberTextAndTextFieldTab(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildFinNRICNumberText(context),
        SizedBox(height: getScreenHeight(context) * 0.01),
        buildFinNRICNumberTextField(registerNotifier, context),
        SizedBox(height: getScreenHeight(context) * 0.01),
        buildFinNRICExpiryText(context),
        SizedBox(height: getScreenHeight(context) * 0.01),
        buildFinNRICExpiryTextField(registerNotifier, context)
      ],
    );
  }

  Widget buildFinNRICNumberText(BuildContext context) {
    return buildText(
        text: S.of(context).finNRICNumber,
        fontSize: AppConstants.sixteen,
        fontColor: oxfordBlueTint500);
  }

  Widget buildFinNRICNumberTextField(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Selector<RegisterNotifier, TextEditingController>(
        builder: (context, finNumberController, child) {
          return CommonTextField(
            width: getScreenWidth(context) < 450
                ? getScreenWidth(context) * 0.86
                : isTab(context) || isMobile(context)
                    ? getScreenWidth(context) * 0.70
                    : null,
            controller: finNumberController,
            validatorEmptyErrorText: fINNRICnumberIsRequired,
            errorStyle: TextStyle(color: errorTextField,
                fontSize: 11.5,fontWeight: FontWeight.w500),
            maxLength: 9,
            helperText: '',
            keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
            hintText: eg0,
            hintStyle: hintStyle(context),
          );
        },
        selector: (buildContext, registerNotifier) =>
            registerNotifier.finNumberController);
  }

  Widget buildFinNRICExpiryText(BuildContext context) {
    return buildText(
        text: S.of(context).finExpiryDate,
        fontSize: AppConstants.sixteen,
        fontColor: oxfordBlueTint500);
  }

  Widget buildFinNRICExpiryTextField(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Selector<RegisterNotifier, TextEditingController>(
        builder: (context, dobController, child) {
          return CommonTextField(
            helperText: '',
            controller: dobController,
            keyboardType: TextInputType.none,
            readOnly: true,
            width: getScreenWidth(context) < 450
                ? getScreenWidth(context) * 0.86
                : isTab(context) || isMobile(context)
                    ? getScreenWidth(context) * 0.70
                    : null,
            errorStyle: TextStyle(color: errorTextField,
                fontSize: 11.5,fontWeight: FontWeight.w500),
            onTap: () {
              DateTime tomorrowDate = DateTime.now().add(Duration(days: 1));
              if (defaultTargetPlatform == TargetPlatform.iOS) {
                iosDatePicker(context, registerNotifier,
                    registerNotifier.finExpiryDateController, minimumDate: tomorrowDate, maximumDate: DateTime(2100),initialDateTime: tomorrowDate);
              } else
                androidDatePicker(context, registerNotifier,
                    registerNotifier.finExpiryDateController,firstDate: tomorrowDate, lastDate: DateTime(2100), initialDate: tomorrowDate);
            },
            suffixIcon: Padding(
              padding: px15DimenAll(context),
              child: Image.asset(AppImages.calendarIcon),
            ),
            hintText: egdate,
            hintStyle: hintStyle(context),
            validatorEmptyErrorText: fINNRICExpiryDateIsRequired,
          );
        },
        selector: (buildContext, registerNotifier) =>
            registerNotifier.finExpiryDateController);
  }

  Widget buildAddressProofText(BuildContext context) {
    return buildText(
        text: S.of(context).addressProof,
        fontSize: AppConstants.sixteen,
        fontWeight: AppFont.fontWeightSemiBold);
  }

  Widget buildAddressProofConditionText(BuildContext context) {
    return buildText(
        text: S.of(context).addressProofCondition,
        fontColor: oxfordBlueTint400);
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
      registerNotifier: registerNotifier,
      onTap: () => selectFile(registerNotifier,context),
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

  Widget buildButtons(RegisterNotifier registerNotifier, BuildContext context) {
    return commonBackAndContinueButton(
      context,
      onPressedContinue: () async {
        registerNotifier.isFileUploadedToServer
            ? registerNotifier.isFileAddedVerification = false
            : registerNotifier.isFileAddedVerification = true;
        if (registerNotifier.addressFormKey.currentState!.validate()) {
          if (registerNotifier.isFileUploadedToServer == true) {
            Provider.of<CommonNotifier>(context, listen: false)
                .updateVerificationScreenData(true);
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              kIsWeb
                  ? registerNotifier.FileUploadOnVerifySG(
                      registerNotifier.file!.path,
                      context,
                      verificationMethodRoute)
                  : registerNotifier.FileUploadOnVerifySG(
                      registerNotifier.files!.path,
                      context,
                      verificationMethodRoute);
            });
          }
        }
      },
      onPressedBack: () {
        MyApp.navigatorKey.currentState!.maybePop();
      },
      backWidth: getScreenWidth(context) < 450
          ? getScreenWidth(context) * 0.42
          : isTab(context)
              ? getScreenWidth(context) * 0.29
              : isMobile(context)
                  ? getScreenWidth(context) * 0.34
                  : null,
      continueWidth: getScreenWidth(context) < 450
          ? getScreenWidth(context) * 0.42
          : isTab(context)
              ? getScreenWidth(context) * 0.29
              : isMobile(context)
                  ? getScreenWidth(context) * 0.34
                  : null,
    );
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

  updateProgress(RegisterNotifier registerNotifier) {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(
      oneSec,
          (Timer t) {
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
      },
    );
  }
}
