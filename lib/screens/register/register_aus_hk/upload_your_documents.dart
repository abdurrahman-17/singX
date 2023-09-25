import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/service/contact_repository.dart';
import 'package:singx/core/models/request_response/common_response.dart';
import 'package:singx/core/models/request_response/otp_verify/otp_verify_response.dart';
import 'package:singx/core/notifier/register_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_font.dart';
import 'package:singx/utils/common/app_images.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/drop_zone.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class UploadYourDocuments extends StatelessWidget {
  const UploadYourDocuments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => RegisterNotifier(context),
      child: Consumer<RegisterNotifier>(
        builder: (context, registerNotifier, _) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            registerNotifier.getAddressVerificationDetailsHK(context);
          });
          return Scaffold(
              backgroundColor: white,
              body: Stack(
                children: [
                  SingleChildScrollView(
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
                        child: Scrollbar(
                          controller: registerNotifier.scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBoxHeight(context, 0.07),
                              buildAddressVerifyText(context),
                              SizedBoxHeight(context, 0.04),
                              isTab(context) || isMobile(context)
                                  ? buildFinNumberTextAndTextFieldTab(
                                      registerNotifier, context)
                                  : buildFinNumberTextAndTextField(
                                      registerNotifier, context),
                              SizedBoxHeight(context, 0.01),
                              buildAddressProofText(context),
                              SizedBoxHeight(context, 0.04),
                              kIsWeb
                                  ? buildDragAndDropBox(
                                      registerNotifier, context)
                                  : buildDragAndDropBoxMobile(
                                      registerNotifier, context),
                              Visibility(
                                  visible:
                                      registerNotifier.isFileAddedVerification,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                              buildButtons(registerNotifier, context),
                              SizedBoxHeight(context, 0.05),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (registerNotifier.showLoadingIndicator)
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        color: Colors.transparent,
                        width: 40,
                        height: 40,
                        child: Align(
                          alignment: Alignment.center,
                          child: defaultTargetPlatform == TargetPlatform.iOS
                              ? CupertinoActivityIndicator(
                                  radius: 30,
                                )
                              : CircularProgressIndicator(
                                  strokeWidth: 3,
                                ),
                        ),
                      ),
                    )
                ],
              ));
        },
      ),
    );
  }

  Widget buildAddressVerifyText(BuildContext context) {
    return buildText(
        text: S.of(context).uploadYourDocument,
        fontSize: AppConstants.twenty,
        fontWeight: AppFont.fontWeightBold);
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
        text: S.of(context).enterHKIDNumber,
        fontSize: AppConstants.sixteen,
        fontColor: oxfordBlueTint500);
  }

  Widget buildFinNRICNumberTextField(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Selector<RegisterNotifier, TextEditingController>(
        builder: (context, hkidNumberController, child) {
          return CommonTextField(
            width: getScreenWidth(context) < 450
                ? getScreenWidth(context) * 0.86
                : isTab(context) || isMobile(context)
                    ? getScreenWidth(context) * 0.70
                    : null,
            controller: hkidNumberController,
            helperText: '',
            errorStyle: TextStyle(color: errorTextField,
                fontSize: 11.5,fontWeight: FontWeight.w500),
            validatorEmptyErrorText: hkidnumberIsRequired,
            keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
            // inputFormatters: <TextInputFormatter>[
            //   FilteringTextInputFormatter.allow(RegExp("[0-9]")),
            // ],
            hintText: eg0,
            hintStyle: hintStyle(context),
          );
        },
        selector: (buildContext, registerNotifier) =>
            registerNotifier.hkidNumberController);
  }

  Widget buildFinNRICExpiryText(BuildContext context) {
    return buildText(
        text: S.of(context).enterHKIDIssueDate,
        fontSize: AppConstants.sixteen,
        fontColor: oxfordBlueTint500);
  }

  Widget buildFinNRICExpiryTextField(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Selector<RegisterNotifier, TextEditingController>(
        builder: (context, hkidDobController, child) {
          return CommonTextField(
            helperText: '',
            controller: hkidDobController,
            keyboardType: TextInputType.none,
            readOnly: true,
              errorStyle: TextStyle(color: errorTextField,
                  fontSize: 11.5,fontWeight: FontWeight.w500),
            width: getScreenWidth(context) < 450
                ? getScreenWidth(context) * 0.86
                : isTab(context) || isMobile(context)
                    ? getScreenWidth(context) * 0.70
                    : null,
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                builder: (context, child) {
                  return child!;
                },
                context: context,
                initialDate: registerNotifier.selectedDate,
                firstDate: DateTime(2015, 8),
                lastDate: DateTime.now(),
              );
              if (picked != null && picked != registerNotifier.selectedDate) {
                registerNotifier.selectedDate = picked;
                final DateFormat formatter = DateFormat('yyyy-MM-dd');
                final String formatted = formatter.format(picked);
                registerNotifier.hkidDobController.text = formatted;
              }
            },
            suffixIcon: Padding(
              padding: px15DimenAll(context),
              child: Image.asset(AppImages.calendarIcon),
            ),
            hintText: egdate,
            hintStyle: hintStyle(context),
            validatorEmptyErrorText: hkidExpiryDateIsRequiredPersonalDetails,
          );
        },
        selector: (buildContext, registerNotifier) =>
            registerNotifier.hkidDobController);
  }

  Widget buildAddressProofText(BuildContext context) {
    return buildText(
        text: S.of(context).uploadFrontOfHKID,
        fontSize: AppConstants.sixteen,
        fontWeight: AppFont.fontWeightSemiBold);
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
      onTap: () => selectFile(registerNotifier),
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

  Widget buildButtons(RegisterNotifier registerNotifier, BuildContext context) {
    return commonBackAndContinueButton(
      context,
      onPressedContinue: () async {
        registerNotifier.isFileUploadedToServer
            ? registerNotifier.isFileAddedVerification = false
            : registerNotifier.isFileAddedVerification = true;
        if(registerNotifier.addressFormKey.currentState!.validate()){
          registerNotifier.isFileUploadedToServer
              ? registerNotifier.isFileAddedVerification = false
              : registerNotifier.isFileAddedVerification = true;
          if(registerNotifier.isFileUploadedToServer == true){
            if (registerNotifier.addressFormKey.currentState!.validate() ) {

              await ContactRepository().apiHKFileUpload(
                  kIsWeb?registerNotifier.file!.path:registerNotifier.files!.path,
                  context,
                  ""
              ).then((value){

                OtpVerifyResponse otpVerifyResponse = value as  OtpVerifyResponse;
                if(otpVerifyResponse.success==true)
                {
                  ContactRepository().apiAddressVerifyHK(context,registerNotifier.hkidNumberController.text,registerNotifier.hkidDobController.text ).then((value)async{

                    registerNotifier.showLoadingIndicator=false;
                    CommonResponse commonResponse = value as CommonResponse;

                    if(commonResponse.success==true)
                    {
                      await registerNotifier.getAuthStatus(context);
                    }
                    else
                    {

                      showMessageDialog(context, commonResponse.message??AppConstants.somethingWentWrongMessage);
                    }
                  });
                }


              });
              registerNotifier.showLoadingIndicator=false;
            }
          }
        }

      },
      onPressedBack: () async {
        await SharedPreferencesMobileWeb.instance
            .getCountry(country)
            .then((value) async {
          Navigator.pushNamed(context, registerHongKongHomeScreen);
        });
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
  selectFile(RegisterNotifier registerNotifier) async {
    final file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);

    if (file != null) {
      registerNotifier.files = File(file.files.single.path!);
      var sizeInBytes = registerNotifier.files!.lengthSync();
      var sizeInKb = sizeInBytes / 1024;
      var sizeInMb = sizeInKb / 1024;

      registerNotifier.size = sizeInMb > 1
          ? '${sizeInMb.toStringAsFixed(2)} MB'
          : '${sizeInKb.toStringAsFixed(2)} KB';
      registerNotifier.platformFile = file.files.first;
      updateProgress(registerNotifier);
      registerNotifier.isFileAdded = true;
    }
  }

  //Uploading data progress value
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
