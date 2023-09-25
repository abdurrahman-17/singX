import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/service/contact_repository.dart';
import 'package:singx/core/models/request_response/common_response.dart';
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
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';
import 'package:singx/utils/common/my_mob_fun.dart'
if (dart.library.html) 'package:singx/utils/common/my_web_fun.dart' as html;

class UploadMobileScreen extends StatelessWidget {
  UploadMobileScreen({Key? key}) : super(key: key);

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
          return Scrollbar(
            controller: registerNotifier.scrollController,
            child: SingleChildScrollView(
              controller: registerNotifier.scrollController,
              child: Form(
                key: registerNotifier.uploadMobileBillKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getScreenWidth(context) < 450
                        ? getScreenWidth(context) * 0.05
                        : isMobile(context)
                            ? getScreenWidth(context) * 0.15
                            : getScreenWidth(context) * 0.26,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBoxHeight(context, 0.07),
                      buildMobileBillText(context),
                      SizedBoxHeight(context, 0.01),
                      buildDocumentInfoText(context),
                      SizedBoxHeight(context, 0.04),
                      buildCheckBoxDoc(
                        context,
                        S.of(context).mobileNumberAndAddressBill,
                        registerNotifier.isChecked1,
                        registerNotifier,
                      ),
                      buildCheckBoxDoc(
                        context,
                        S.of(context).mobillBillInPDF,
                        registerNotifier.isChecked2,
                        registerNotifier,
                      ),
                      buildCheckBoxDoc(
                        context,
                        S.of(context).uploadDocumnetIsMobileBill,
                        registerNotifier.isChecked3,
                        registerNotifier,
                      ),
                      SizedBoxHeight(context, 0.05),
                      SizedBoxHeight(context, 0.05),
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
                                  text: registerNotifier.isFileAdded ? S.of(context).pleaseWaitUntilTheDocumentIsUploaded :S
                                      .of(context)
                                      .noFilesUploadedPleaseUploadAtLeastOneValidDocument,
                                  fontColor: errorTextField,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11.5)
                            ],
                          )),
                      Visibility(
                          visible: registerNotifier.isCheckBoxValidated,
                          child: Column(
                            children: [
                              SizedBoxHeight(context, 0.01),
                              buildText(
                                  text: 'Please Select all the checkbox',
                                  fontColor: errorTextField,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11.5)
                            ],
                          )),
                      Visibility(
                          child: Column(
                            children: [
                              commonSizedBoxHeight20(context),
                              buildText(
                                  text: registerNotifier.OTPErrorMessage,
                                  fontColor: errorTextField,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11.5),
                              commonSizedBoxHeight20(context),
                            ],
                          ),
                          visible: registerNotifier.OTPErrorMessage != ''),
                      SizedBoxHeight(context, 0.05),
                      buildButtons(registerNotifier, context),
                      SizedBoxHeight(context, 0.05),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildMobileBillText(BuildContext context) {
    return buildText(
        text: S.of(context).uploadMobileBill,
        fontSize: AppConstants.twenty,
        fontColor: oxfordBlue,
        fontWeight: FontWeight.w700);
  }

  Widget buildDocumentInfoText(BuildContext context) {
    return buildText(
        text: S.of(context).pleaseCheckDocument,
        fontSize: AppConstants.sixteen,
        fontWeight: AppFont.fontWeightRegular,
        fontColor: oxfordBlueTint400);
  }

  Widget buildCheckBoxDoc(BuildContext context, name, bool boolValue,
      RegisterNotifier registerNotifier) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
            side: BorderSide(
              color: fieldBorderColorNew,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: radiusAll5(context),
            ),
            value: boolValue,
            onChanged: (val) {
              if (name == S.of(context).mobileNumberAndAddressBill) {
                registerNotifier.isChecked1 = val!;
              } else if (name == S.of(context).mobillBillInPDF) {
                registerNotifier.isChecked2 = val!;
              } else if (name == S.of(context).uploadDocumnetIsMobileBill) {
                registerNotifier.isChecked3 = val!;
              }
              registerNotifier.isChecked1 &&
                      registerNotifier.isChecked2 &&
                      registerNotifier.isChecked3
                  ? registerNotifier.isCheckBoxValidated = false
                  : registerNotifier.isCheckBoxValidated = true;
            }),
        Flexible(
          child: GestureDetector(
            onTap: () {
              if (name == S.of(context).mobileNumberAndAddressBill) {
                registerNotifier.isChecked1 = !registerNotifier.isChecked1;
              } else if (name == S.of(context).mobillBillInPDF) {
                registerNotifier.isChecked2 = !registerNotifier.isChecked2;
              } else if (name == S.of(context).uploadDocumnetIsMobileBill) {
                registerNotifier.isChecked3 = !registerNotifier.isChecked3;
              }
            },
            child: Padding(
              padding: px7DimenTop(context),
              child: buildText(
                text: name,
                fontColor: black,
                fontWeight: AppFont.fontWeightRegular,
              ),
            ),
          ),
        )
      ],
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

  openPopUpDialog(RegisterNotifier registerNotifier, BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: AppConstants.four, sigmaY: AppConstants.four),
            child: StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                content: SizedBox(
                  width: AppConstants.fourHundredTwenty,
                  height: getScreenWidth(context) < 340
                      ? 340
                      : getScreenHeight(context) < 700
                          ? AppConstants.twoHundredSixty
                          : 310,
                  child: SingleChildScrollView(
                    controller: registerNotifier.scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildText(
                                text: S.of(context).otpVerification,
                                fontWeight: FontWeight.w700,
                                fontSize: getScreenWidth(context) < 340
                                    ? 14
                                    : AppConstants.twentyTwo),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                size: AppConstants.twenty,
                                color: oxfordBlueTint400,
                              ),
                              onPressed: () {
                                MyApp.navigatorKey.currentState!.maybePop();
                                registerNotifier.otpController.clear();
                                registerNotifier.isError = false;
                                registerNotifier.errorMessage = '';
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: getScreenHeight(context) * 0.02),
                        buildText(
                            text: S.of(context).enterTheOtpSendtoMobile,
                            fontSize: AppConstants.sixteen,
                            fontColor: oxfordBlueTint400),
                        SizedBox(height: getScreenHeight(context) * 0.04),
                        Form(
                          key: registerNotifier.uploadAddressFormKey,
                          child: CommonTextField(
                              controller: registerNotifier.otpController,
                              maxLength: 6,
                              keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
                              validatorEmptyErrorText: otpIsRequired,
                              isOTPNumberValidator: true,
                              errorStyle: TextStyle(color: errorTextField,
                                  fontSize: 11.5,fontWeight: FontWeight.w500),
                              onChanged: (data){
                                setState((){
                                  registerNotifier.errorMessage = '';
                                  registerNotifier.isError = false;
                                });
                              },
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]")),
                              ],
                              hintText: S.of(context).enterOtpHere,
                              hintStyle: hintStyle(context),
                              maxWidth: AppConstants.oneHundredAndSixty,
                              width: getScreenWidth(context),
                              maxHeight: 50,
                              suffixIcon: getScreenWidth(context) < 340
                                  ? null
                                  : registerNotifier.isTimer == false
                                      ? Padding(
                                          padding: px8DimenAll(context),
                                          child: TweenAnimationBuilder<
                                                  Duration>(
                                              duration: Duration(seconds: 120),
                                              tween: Tween(
                                                  begin: Duration(seconds: 120),
                                                  end: Duration.zero),
                                              onEnd: () {
                                                setState(() {
                                                  registerNotifier.isTimer =
                                                      true;
                                                });
                                              },
                                              builder: (BuildContext context,
                                                  Duration value,
                                                  Widget? child) {
                                                final minutes = value.inMinutes;
                                                final seconds =
                                                    value.inSeconds % 60;
                                                var sec = seconds < 10 ? 0 : '';
                                                return Padding(
                                                  padding: px5DimenVerticale(
                                                      context),
                                                  child: buildText(
                                                      text:
                                                          '${S.of(context).resendIn} 0$minutes: $sec$seconds ',
                                                      fontWeight: AppFont
                                                          .fontWeightRegular,
                                                      fontColor: black),
                                                );
                                              }),
                                        )
                                      : TextButton(
                                          onPressed: () {
                                            contactRepository.apiOtpGenerate();
                                            setState(() {
                                              registerNotifier.isTimer = false;
                                            });
                                          },
                                          child: buildText(
                                              text: S.of(context).resendOtp,
                                              fontWeight:
                                                  AppFont.fontWeightSemiBold,
                                              fontColor: orangePantone),
                                        )),
                        ),
                        getScreenWidth(context) > 340
                            ? Text('')
                            : registerNotifier.isTimer == false
                                ? Padding(
                                    padding: px8DimenAll(context),
                                    child: TweenAnimationBuilder<Duration>(
                                        duration: Duration(seconds: 120),
                                        tween: Tween(
                                            begin: Duration(seconds: 120),
                                            end: Duration.zero),
                                        onEnd: () {
                                          registerNotifier.isTimer = true;
                                        },
                                        builder: (BuildContext context,
                                            Duration value, Widget? child) {
                                          final minutes = value.inMinutes;
                                          final seconds = value.inSeconds % 60;
                                          var sec = seconds < 10 ? 0 : '';
                                          return Padding(
                                            padding: px5DimenVerticale(context),
                                            child: buildText(
                                                text:
                                                    '${S.of(context).resendIn} 0$minutes: $sec$seconds ',
                                                fontWeight:
                                                    AppFont.fontWeightRegular,
                                                fontColor: black),
                                          );
                                        }),
                                  )
                                : TextButton(
                                    onPressed: () {
                                      contactRepository.apiOtpGenerate();
                                      registerNotifier.isTimer = false;
                                    },
                                    child: buildText(
                                        text: S.of(context).resendOtp,
                                        fontWeight: AppFont.fontWeightSemiBold,
                                        fontColor: orangePantone)),
                        registerNotifier.isError == true
                            ? buildText(text: invalidOTP, fontColor: error)
                            : Text(''),
                        Visibility(visible: registerNotifier.errorMessage != '',child: buildText(text:registerNotifier.errorMessage,fontColor: error)),
                        SizedBoxHeight(context,
                            getScreenWidth(context) > 380 ? 0.02 : 0.0),
                        buildButton(context, onPressed: () async {
                          if (registerNotifier
                              .uploadAddressFormKey.currentState!
                              .validate()) {
                              registerNotifier.isError = false;
                                  if(kIsWeb){
                                       await contactRepository
                                        .apiJumioVerification(
                                        false, "${registerNotifier.otpController.text}", context)
                                        .then((value) async {
                                      JumioVerificationResponse
                                      jumioVerificationResponse =
                                      value as JumioVerificationResponse;
                                      if(value.success == false) {
                                        registerNotifier.errorMessage = value.message!;
                                      } else {
                                        SharedPreferencesMobileWeb.instance.setJumioReference('jumioRefernce',jumioVerificationResponse.transactionReference!);
                                        html.openLink(
                                            '${jumioVerificationResponse.web?.href}');
                                      }
                                    });
                                  }else {
                                    apiLoader(context);
                                    await contactRepository
                                        .apiJumioVerification(
                                        false, "${registerNotifier.otpController.text}", context)
                                        .then((value) async {
                                      MyApp.navigatorKey.currentState!.maybePop();
                                      JumioVerificationResponse
                                      jumioVerificationResponse =
                                      value as JumioVerificationResponse;
                                      if (value.success == false) {
                                        registerNotifier.errorMessage = value.message!;
                                      } else {
                                        await registerNotifier.callJumioApis(
                                            context,
                                            "${jumioVerificationResponse.transactionReference}",
                                            "${jumioVerificationResponse.sdk?.token}");
                                      }
                                    });
                                    Navigator.pop(context);
                                    return;
                                  }
                                  MyApp.navigatorKey.currentState!.maybePop();
                                  setState(() {
                                    registerNotifier.isError = false;
                                  });
                          }
                        },
                            width: getScreenWidth(context),
                            height: AppConstants.fortyFive,
                            name: S.of(context).verify,
                            fontColor: white,
                            color: hanBlue),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        },
        context: context);
  }

  apiJumioVerification(
      RegisterNotifier registerNotifier, BuildContext context) async {
    await contactRepository
        .apiJumioVerification(
            false, "${registerNotifier.otpController.text}", context)
        .then((value) async {
      JumioVerificationResponse jumioVerificationResponse =
          value as JumioVerificationResponse;
      await contactRepository
          .jumioCallBack(
              jumioVerificationResponse.transactionReference ?? "", context)
          .then((value) async {
        if (value == true) {
          await registerNotifier.getAuthStatus(context);
        }
      });
    });
  }

  Widget buildButtons(RegisterNotifier registerNotifier, BuildContext context) {
    return commonBackAndContinueButton(context,
        backWidth: getScreenWidth(context) < 450
            ? getScreenWidth(context) * 0.43
            : isMobile(context)
                ? getScreenWidth(context) * 0.34
                : null, onPressedContinue: () async {
          Provider.of<CommonNotifier>(context, listen: false)
              .updateUserVerifiedBool = false;
          SharedPreferencesMobileWeb.instance.setUserVerified(false);
      registerNotifier.isFileUploadedToServer
          ? registerNotifier.isFileAddedVerification = false
          : registerNotifier.isFileAddedVerification = true;
      registerNotifier.isChecked1 &&
              registerNotifier.isChecked2 &&
              registerNotifier.isChecked3
          ? registerNotifier.isCheckBoxValidated = false
          : registerNotifier.isCheckBoxValidated = true;
      if (registerNotifier.uploadMobileBillKey.currentState!.validate()) {
        if (registerNotifier.isFileUploadedToServer == true &&
            registerNotifier.isCheckBoxValidated == false) {
          registerNotifier.OTPErrorMessage = '';
          kIsWeb
              ? await contactRepository
                  .apiSGFileUpload(
                      registerNotifier.file!.path, context, "", "MOBILE_BILL", fileName: registerNotifier.file!.name)
                  .then((value) {
                  contactRepository.apiOtpGenerate().then((value) {
                    CommonResponse res = value as CommonResponse;
                    if (res.success == true) {
                      openPopUpDialog(registerNotifier, context);
                      registerNotifier.OTPErrorMessage = '';
                    } else {
                      registerNotifier.OTPErrorMessage = 'Unable to send OTP.';
                    }
                  });
                })
              : await contactRepository
                  .apiSGFileUpload(
                      registerNotifier.files!.path, context, "", "MOBILE_BILL")
                  .then((value) {
                  contactRepository.apiOtpGenerate().then((value) {
                    CommonResponse res = value as CommonResponse;
                    if (res.success == true) {
                      openPopUpDialog(registerNotifier, context);
                      registerNotifier.OTPErrorMessage = '';
                    } else {
                      registerNotifier.OTPErrorMessage = 'Unable to send OTP.';
                    }
                  });
                });
        }
      }
    }, onPressedBack: () async {
      await SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        Navigator.pushNamed(context, verificationMethodRoute);
      });
    },
        continueWidth: getScreenWidth(context) < 450
            ? getScreenWidth(context) * 0.43
            : isMobile(context)
                ? getScreenWidth(context) * 0.34
                : null);
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

  //To Update Progress value
  updateProgress(RegisterNotifier registerNotifier) {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer t) {
      registerNotifier.progressValue += 0.3;
      if (registerNotifier.progressValue <= 0.9) {
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
      } else {
        t.cancel();
      }
    });
  }
}
