import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/service/auth_repository.dart';
import 'package:singx/core/models/request_response/australia/customer_status/customer_status_response.dart';
import 'package:singx/core/models/request_response/digi_verify_send_step_2/digi_verify_error_response.dart';
import 'package:singx/core/models/request_response/digi_verify_send_step_2/digi_verify_send_request_step_2.dart';
import 'package:singx/core/notifier/common_notifier.dart';
import 'package:singx/core/notifier/register_notifier.dart';
import 'package:singx/generated/l10n.dart';
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

class AustraliaDigitalVerification extends StatelessWidget {
  const AustraliaDigitalVerification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return ChangeNotifierProvider<RegisterNotifier>(
      create: (BuildContext context) => RegisterNotifier(context,from: "digitalVerification"),
      child: Consumer<RegisterNotifier>(
        builder: (context, registerNotifier, _) {
          return Scrollbar(
            controller: registerNotifier.scrollController,
            child: SingleChildScrollView(
              controller: registerNotifier.scrollController,
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: kIsWeb ? getScreenWidth(context) < 450
                          ? getScreenWidth(context) * 0.05
                          : isMobile(context)
                              ? getScreenWidth(context) * 0.15
                              : getScreenWidth(context) * 0.15 :  screenSizeWidth < 450
                          ? screenSizeWidth * 0.05
                          : isMobileSDK(context)
                          ? screenSizeWidth * 0.15
                          : screenSizeWidth * 0.15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        commonSizedBoxHeight50(context),
                        buildCompleteThisApplicationText(context),
                        commonSizedBoxHeight40(context),
                        buildIdentificationDetailsText(context),
                        commonSizedBoxHeight40(context),
                        buildOneOrMoreText(context),
                        commonSizedBoxHeight30(context),
                        Visibility(
                            visible: registerNotifier.isADLNotVerified ||
                                registerNotifier.isMedicareNotVerified ||
                                registerNotifier.isPassportNotVerified || registerNotifier.errorListStep2.isNotEmpty,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildCouldNotVerified(
                                      context, registerNotifier),
                                  commonSizedBoxHeight15(context),
                                ])),
                        Visibility(
                            visible: registerNotifier.isFieldAreEmpty,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildPleaseEnterTheRequiredData(context),
                                commonSizedBoxHeight15(context),
                              ],
                            )),
                        Form(
                            key: registerNotifier
                                .australianDrivingLicenceFormKey,
                            child: buildAustralianListTile(
                                registerNotifier, context)),
                        if(!registerNotifier.isADLOpen)commonSizedBoxHeight10(context),
                        Form(
                            key: registerNotifier.passportFormKey,
                            child: buildPassportListTile(
                                registerNotifier, context)),
                        if(!registerNotifier.isPassportOpen)commonSizedBoxHeight10(context),
                        Form(
                            key: registerNotifier.medicareFormKey,
                            child: buildMedicareListTile(
                                registerNotifier, context)),
                        Visibility(
                            visible: registerNotifier.isADLNotVerifiedRestricted ||
                                registerNotifier.isMedicareNotVerifiedRestricted ||
                                registerNotifier.isPassportNotVerifiedRestricted,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  commonSizedBoxHeight10(context),
                                  buildDocumentNeededListTile(
                                      registerNotifier, context)
                                ])),
                        commonSizedBoxHeight10(context),
                        buildForFasterOnBoardingText(context),
                        commonSizedBoxHeight40(context),
                        buildButtons(context, registerNotifier),
                        commonSizedBoxHeight50(context),
                      ])),
            ),
          );
        },
      ),
    );
  }

  Widget buildButtons(BuildContext context,RegisterNotifier registerNotifier) {
    return commonBackAndContinueButton(context,
        backWidth: kIsWeb
            ? getScreenWidth(context) < 450
                ? getScreenWidth(context) * 0.43
                : getScreenWidth(context) * 0.34
            : screenSizeWidth < 450
                ? screenSizeWidth * 0.43
                : screenSizeWidth * 0.34,
        continueWidth: kIsWeb
            ? getScreenWidth(context) < 450
                ? getScreenWidth(context) * 0.43
                : getScreenWidth(context) * 0.34
            : screenSizeWidth < 450
                ? screenSizeWidth * 0.43
                : screenSizeWidth * 0.34,
        widthBetween : kIsWeb ? getScreenWidth(context) * 0.02 : screenSizeWidth * 0.02,
        onPressedContinue: () async {

          registerNotifier.apiDigitalData.clear();

            if (registerNotifier.licenceNumberControllerADL.text.isNotEmpty ||
                registerNotifier.dateOfExpiryControllerADL.text.isNotEmpty ||
                registerNotifier
                    .issuingAuthorityControllerADL.text.isNotEmpty ||
                (registerNotifier.issuingAuthorityControllerADL.text != "Victoria" &&
                    registerNotifier.cardNumberControllerADL.text.isNotEmpty)) {
              registerNotifier.drivingValidation = true;
              registerNotifier.australianDrivingLicenceFormKey.currentState!
                  .validate();
              if(!registerNotifier.australianDrivingLicenceFormKey.currentState!
                  .validate()) return;
            }

            if (registerNotifier.passportNumberControllerADL.text.isNotEmpty ||
                registerNotifier
                    .dateOfExpiryControllerPassport.text.isNotEmpty ||
                registerNotifier.selectedGender != null) {
              registerNotifier.passportValidation = true;
              registerNotifier.passportFormKey.currentState!.validate();
              if(!registerNotifier.passportFormKey.currentState!
                  .validate()) return;
            }

            if (registerNotifier
                    .medicareNumberControllerMedicare.text.isNotEmpty ||
                registerNotifier.individualReferenceNumberControllerMedicare
                    .text.isNotEmpty ||
                registerNotifier.selectedCardColor != null) {
              registerNotifier.medicareValidation = true;
              registerNotifier.medicareFormKey.currentState!.validate();
              if(!registerNotifier.medicareFormKey.currentState!
                  .validate()) return;
            }


            if (registerNotifier.isADLNotVerifiedRestricted ||
                registerNotifier.isPassportNotVerifiedRestricted ||
                registerNotifier.isMedicareNotVerifiedRestricted) {
              List Path = [];
              List Pathname = [];
              for (int i = 0;
              i < registerNotifier.fileAdditional!.length;
              i++) {
                Path.add(
                    registerNotifier.fileAdditional![i].path);
                Pathname.add(
                    registerNotifier.fileAdditional![i].name);
              }
              if (registerNotifier.isFileUploadedToServer) {
                if (kIsWeb) {
                  AuthRepository().apiNonCRAFileUpload(
                      registerNotifier.fileAdditional,
                      registerNotifier.fileAdditional!,
                      context,
                      navigate: true);
                  SharedPreferencesMobileWeb.instance
                      .setMethodSelectedAUS('methodSelectedAUS',false);
                } else {
                  AuthRepository().apiNonCRAFileUpload(
                      registerNotifier.filesAdditionalMob,
                      registerNotifier.filesAdditionalMob,
                      context,
                      navigate: true);
                  SharedPreferencesMobileWeb.instance
                      .setMethodSelectedAUS('methodSelectedAUS',false);
                }
              } else {
                registerNotifier.isFileUploadedToServer
                    ? registerNotifier.isFileAddedVerification = false
                    : registerNotifier.isFileAddedVerification = true;
              }
            }else{
              registerNotifier.isVerificationADl = false;
              if(registerNotifier.drivingValidation == true)
                registerNotifier.apiDigitalData.add(
                  CustomerDocument(
                    documenttype:
                    "Australian Driving License",
                    referrenceNo: registerNotifier
                        .licenceNumberControllerADL
                        .text,
                    dateOfExpiry: registerNotifier
                        .dateOfExpiryControllerADL
                        .text,
                    stateOfIssue: registerNotifier
                        .selectedIssuingAuthority,
                    cardType: null,
                    indvReferrenceNo: null,
                    mcName: null,
                    dlFName: registerNotifier
                        .firstNameControllerADL
                        .text,
                    dlMName: registerNotifier
                        .middleNameControllerADL
                        .text,
                    dlLName: registerNotifier
                        .lastNameControllerADL
                        .text,
                    ppFName: null,
                    ppMName: null,
                    ppLName: null,
                    gender: null,
                    dlCardNo: registerNotifier
                        .cardNumberControllerADL
                        .text,
                  ),
              );
              if(registerNotifier.passportValidation == true)
                registerNotifier.apiDigitalData.add(
                       CustomerDocument(
                documenttype: "Passport",
                referrenceNo: registerNotifier
                    .passportNumberControllerADL
                    .text,
                dateOfExpiry: registerNotifier
                    .dateOfExpiryControllerPassport
                    .text,
                stateOfIssue: null,
                cardType: null,
                indvReferrenceNo: null,
                mcName: null,
                dlFName: null,
                dlMName: null,
                dlLName: null,
                ppFName: registerNotifier
                    .firstNameControllerPassport
                    .text,
                ppMName: registerNotifier
                    .middleNameControllerPassport
                    .text,
                ppLName: registerNotifier
                    .lastNameControllerPassport
                    .text,
                gender: registerNotifier
                    .selectedGender,
                )
                );
              if(registerNotifier.medicareValidation == true)
                registerNotifier.apiDigitalData.add(
                    CustomerDocument(
                      documenttype: "Medicare Card",
                      referrenceNo: registerNotifier
                          .medicareNumberControllerMedicare
                          .text,
                      dateOfExpiry: registerNotifier
                          .dateOfExpiryControllerMedicare
                          .text,
                      stateOfIssue: null,
                      cardType: registerNotifier
                          .selectedCardColor,
                      indvReferrenceNo: registerNotifier
                          .individualReferenceNumberControllerMedicare
                          .text,
                      mcName: registerNotifier
                          .nameControllerMedicare
                          .text,
                      dlFName: null,
                      dlMName: null,
                      dlLName: null,
                      ppFName: null,
                      ppMName: null,
                      ppLName: null,
                      gender: null,
                    )
                );
              if(
              (registerNotifier.drivingValidation == true && (registerNotifier.licenceNumberControllerADL.text.isNotEmpty &&
                  registerNotifier.dateOfExpiryControllerADL.text.isNotEmpty &&
                  registerNotifier
                      .issuingAuthorityControllerADL.text.isNotEmpty &&
                  ((registerNotifier.issuingAuthorityControllerADL.text != "Victoria" &&
                      registerNotifier.cardNumberControllerADL.text.isNotEmpty) ||
                      registerNotifier.issuingAuthorityControllerADL.text == "Victoria"))) ||

                  (registerNotifier.passportValidation == true && (registerNotifier.passportNumberControllerADL.text.isNotEmpty &&
                      registerNotifier
                          .dateOfExpiryControllerPassport.text.isNotEmpty &&
                      registerNotifier.selectedGender != null)) ||

                  (registerNotifier.medicareValidation == true && (registerNotifier
                      .medicareNumberControllerMedicare.text.isNotEmpty &&
                      registerNotifier.individualReferenceNumberControllerMedicare
                          .text.isNotEmpty &&
                      registerNotifier.selectedCardColor != null))
              )

              await SharedPreferencesMobileWeb.instance
                    .getContactId(apiContactId)
                    .then((value) {
                  AuthRepository()
                      .apiDigitalVerificationSaveData(
                      DigiVerifyStepTwoRequestSendAus(
                        contactId: value,
                        onlyPassport: registerNotifier.drivingValidation == false && registerNotifier.medicareValidation == false ? true : false,
                        documentCount: 0,
                        customerDocuments: registerNotifier.apiDigitalData,
                      ),
                      context)
                      .then((value) {
                    Response response = value as Response;
                    if (response.statusCode == HttpStatus.ok) {
                      GetStepTwoErrorResponse
                      getStepTwoErrorResponse =
                      GetStepTwoErrorResponse.fromJson(
                          response.data);
                      AuthStatus(context);
                      if(getStepTwoErrorResponse.custOnboardDocBeans!.australianDrivingLicense != null) {
                        if (getStepTwoErrorResponse.custOnboardDocBeans!
                            .australianDrivingLicense!.isDocVerified == 0) {
                          registerNotifier.isADLNotVerified = true;
                          if (getStepTwoErrorResponse.custOnboardDocBeans!
                              .australianDrivingLicense!.isDocVerified == 0 &&
                              getStepTwoErrorResponse.attempts! >= 2) {
                            registerNotifier.isADLNotVerifiedRestricted = true;
                          }
                        }else if (getStepTwoErrorResponse.custOnboardDocBeans!
                            .australianDrivingLicense!.isDocVerified == 1) {
                          registerNotifier.isADLVerified = true;
                          registerNotifier.isADLNotVerified = false;
                          registerNotifier.isADLNotVerifiedRestricted = false;
                        }
                      }
                      if(getStepTwoErrorResponse.custOnboardDocBeans!.passport != null) {
                        if (getStepTwoErrorResponse.custOnboardDocBeans!.passport!
                            .isDocVerified == 0) {
                          registerNotifier.isPassportNotVerified = true;
                          if (getStepTwoErrorResponse.custOnboardDocBeans!.passport!
                              .isDocVerified == 0 && getStepTwoErrorResponse
                              .attempts! >= 2) {
                            registerNotifier.isPassportNotVerifiedRestricted = true;
                          }
                        } else if (getStepTwoErrorResponse.custOnboardDocBeans!
                              .australianDrivingLicense!.isDocVerified ==
                          1) {
                        registerNotifier.isPassportVerified = true;
                        registerNotifier.isPassportNotVerified = true;
                        registerNotifier.isPassportNotVerifiedRestricted = false;
                      }
                    }
                      if(getStepTwoErrorResponse.custOnboardDocBeans!.medicareCard != null) {
                        if (getStepTwoErrorResponse.custOnboardDocBeans!
                            .medicareCard!.isDocVerified == 0) {
                          registerNotifier.isMedicareNotVerified = true;
                          if (getStepTwoErrorResponse.custOnboardDocBeans!
                              .medicareCard!.isDocVerified == 0 &&
                              getStepTwoErrorResponse.attempts! >= 2) {
                            registerNotifier.isMedicareNotVerifiedRestricted = true;
                          }
                        }else if (getStepTwoErrorResponse.custOnboardDocBeans!
                            .australianDrivingLicense!.isDocVerified ==
                            1) {
                          registerNotifier.isMedicareVerified = true;
                          registerNotifier.isMedicareNotVerified = false;
                          registerNotifier.isMedicareNotVerifiedRestricted = false;
                        }
                      }
                      getStepTwoErrorResponse
                          .errorList!.isNotEmpty
                          ? registerNotifier.errorListStep2 =
                          getStepTwoErrorResponse
                              .errorList!.first
                          : null;
                      SharedPreferencesMobileWeb.instance
                          .setMethodSelectedAUS('methodSelectedAUS',false);
                    }
                  });
                });
            }

        },
        onPressedBack: () async =>
        await SharedPreferencesMobileWeb.instance
            .getCountry(country)
            .then((value) async {
          Navigator.pushReplacementNamed(
              context, personalDetailsAustraliaRoute);
        }));
  }

  Widget buildIdentificationDetailsText(BuildContext context) {
    return buildText(
      text: S.of(context).identificationDetails,
      fontSize: AppConstants.twenty,
      fontWeight: AppFont.fontWeightBold,
    );
  }

  Widget buildForFasterOnBoardingText(BuildContext context) {
    return buildText(
      text: S
          .of(context)
          .noteForFasterOnBoardingPleaseEnsureThatAllTheInformationEnteredAboveIsAccurateCurrent,
      fontSize: AppConstants.thirteenPointFive,
      fontWeight: AppFont.fontWeightBold,
    );
  }

  Widget buildCompleteThisApplicationText(BuildContext context) {
    return buildText(
        text: S
            .of(context)
            .completeThisApplicationInLessThan5MinutesAndUseYourAccountInstantly,
        fontSize: AppConstants.thirteenPointFive,
        fontWeight: AppFont.fontWeightMedium,
        fontColor: Color(0xff739021));
  }

  Widget buildOneOrMoreText(BuildContext context) {
    return buildText(
      text: S
          .of(context)
          .pleaseProvideDetailsOfOneOrMoreOfTheseDocumentsForEVerification,
      fontSize: AppConstants.sixteen,
      fontWeight: AppFont.fontWeightRegular,
    );
  }

  Widget buildAustralianListTile(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: MouseRegion(
        cursor: registerNotifier.isADLNotVerifiedRestricted ||
                registerNotifier.isMedicareNotVerifiedRestricted ||
                registerNotifier.isPassportNotVerifiedRestricted
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        child: IgnorePointer(
          ignoring: registerNotifier.isADLNotVerifiedRestricted ||
                  registerNotifier.isMedicareNotVerifiedRestricted ||
                  registerNotifier.isPassportNotVerifiedRestricted
              ? true
              : false,
          child: ExpansionTile(
            initiallyExpanded: registerNotifier.isADLNotVerified ||
                    registerNotifier.isMedicareNotVerified ||
                    registerNotifier.isPassportNotVerified
                ? false
                : false,
            maintainState: true,
            onExpansionChanged: (val){
              registerNotifier.isADLOpen = val;
            },
            trailing: kIsWeb
                ? getScreenWidth(context) > 350
                    ? registerNotifier.isADLNotVerified
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.warning,
                                color: error,
                                size: 18,
                              ),
                              Text(
                                ' ' + S.of(context).notVerified,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: error,
                                    fontWeight: AppFont.fontWeightBold),
                              )
                            ],
                          )
                        : registerNotifier.isADLVerified
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    ' ' + "VERIFIED",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.green,
                                        fontWeight: AppFont.fontWeightBold),
                                  )
                                ],
                              )
                            : SizedBox.shrink()
                    : SizedBox.shrink()
                : screenSizeWidth > 350
                    ? registerNotifier.isADLNotVerified
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.warning,
                                color: error,
                                size: 18,
                              ),
                              Text(
                                ' ' + S.of(context).notVerified,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: error,
                                    fontWeight: AppFont.fontWeightBold),
                              )
                            ],
                          )
                        : registerNotifier.isADLVerified
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    ' ' + "VERIFIED",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.green,
                                        fontWeight: AppFont.fontWeightBold),
                                  )
                                ],
                              )
                            : SizedBox.shrink()
                    : SizedBox.shrink(),
            collapsedBackgroundColor: hanBlueshades400,
            controlAffinity: ListTileControlAffinity.leading,
            collapsedIconColor: white,
            collapsedTextColor: white,
            iconColor: white,
            textColor: white,
            backgroundColor: hanBlueshades400,
            title: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).australianDriverLicense,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  kIsWeb
                      ? getScreenWidth(context) <= 350
                          ? registerNotifier.isADLNotVerified
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.warning,
                                      color: error,
                                      size: 18,
                                    ),
                                    Text(
                                      ' ' + S.of(context).notVerified,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: error,
                                          fontWeight: AppFont.fontWeightBold),
                                    )
                                  ],
                                )
                              : registerNotifier.isADLVerified
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          ' ' + "VERIFIED",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.green,
                                              fontWeight: AppFont.fontWeightBold),
                                        )
                                      ],
                                    )
                                  : SizedBox.shrink()
                          : SizedBox.shrink()
                      : screenSizeWidth <= 350
                          ? registerNotifier.isADLNotVerified
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.warning,
                                      color: error,
                                      size: 18,
                                    ),
                                    Text(
                                      ' ' + S.of(context).notVerified,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: error,
                                          fontWeight: AppFont.fontWeightBold),
                                    )
                                  ],
                                )
                              : registerNotifier.isADLVerified
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          ' ' + "VERIFIED",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.green,
                                              fontWeight: AppFont.fontWeightBold),
                                        )
                                      ],
                                    )
                                  :SizedBox.shrink()
                          : SizedBox.shrink()
                ],
              ),
            ),
            children: <Widget>[
              Container(
                padding: px15DimenAll(context),
                color: white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildNoteBlack(context,
                        title: S
                            .of(context)
                            .enterYourNameHereExactlyAsItAppearsOnYourDriverLicence),
                    commonSizedBoxHeight10(context),
                    buildNoteBlack(context,
                        title: S
                            .of(context)
                            .pleaseUseUpperCaseLowerCaseCharactersExactlyAsTheyAppearOnYourLicence),
                    commonSizedBoxHeight40(context),
                    kIsWeb
                        ? getScreenWidth(context) > 810
                            ? buildAUSTileGreaterThan810(
                                context, registerNotifier)
                            : buildAUSTileLessThan810(context, registerNotifier)
                        : screenSizeWidth > 810
                            ? buildAUSTileGreaterThan810(
                                context, registerNotifier)
                            : buildAUSTileLessThan810(context, registerNotifier)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAUSTileGreaterThan810(BuildContext context,RegisterNotifier registerNotifier) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: buildFirstNameADL(
                    context,
                    registerNotifier.firstNameControllerADL,
                    S
                        .of(context)
                        .enterFirstNameAsPerDrivingLicence,
                    S.of(context).asOnDriversLicence)),
            sizedBoxWidth10(context),
            Expanded(
                child: buildMiddleNameADL(
                    context,
                    registerNotifier.middleNameControllerADL,
                    S
                        .of(context)
                        .enterMiddleNameAsPerDrivingLicence,
                    S.of(context).asOnDriversLicence)),
            sizedBoxWidth10(context),
            Expanded(
                child: buildLastNameADL(
                    context,
                    registerNotifier.lastNameControllerADL,
                    S
                        .of(context)
                        .enterLastNameAsPerDrivingLicence,
                    S.of(context).asOnDriversLicence))
          ],
        ),
        commonSizedBoxHeight20(context),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: buildLicenceNumberADL(
                    context, registerNotifier)),
            sizedBoxWidth10(context),
            Expanded(
                child: buildDateOfExpiryADL(
                    context,
                    registerNotifier,
                    registerNotifier
                        .dateOfExpiryControllerADL)),
            sizedBoxWidth10(context),
            Expanded(
                child: buildIssuingAuthorityADL(
                    context, registerNotifier)),
          ],
        ),
        commonSizedBoxHeight20(context),
        Row(
          children: [
            Expanded(
                child: buildCardNumberADL(
                    context, registerNotifier)),
            sizedBoxWidth20(context),
            Expanded(child: Container()),
            Expanded(child: Container()),
          ],
        )
      ],
    );
  }

  Widget buildAUSTileLessThan810(BuildContext context,RegisterNotifier registerNotifier) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildFirstNameADL(
            context,
            registerNotifier.firstNameControllerADL,
            S.of(context).enterFirstNameAsPerDrivingLicence,
            S.of(context).asOnDriversLicence),
        buildValidationSizedBox(context, registerNotifier),
        buildMiddleNameADL(
            context,
            registerNotifier.middleNameControllerADL,
            S
                .of(context)
                .enterMiddleNameAsPerDrivingLicence,
            S.of(context).asOnDriversLicence),
        buildValidationSizedBox(context, registerNotifier),
        buildLastNameADL(
            context,
            registerNotifier.lastNameControllerADL,
            S.of(context).enterLastNameAsPerDrivingLicence,
            S.of(context).asOnDriversLicence),
        buildValidationSizedBox(context, registerNotifier),
        buildLicenceNumberADL(context, registerNotifier),
        buildValidationSizedBox(context, registerNotifier),
        buildDateOfExpiryADL(context, registerNotifier,
            registerNotifier.dateOfExpiryControllerADL),
        buildValidationSizedBox(context, registerNotifier),
        buildIssuingAuthorityADL(context, registerNotifier),
        buildValidationSizedBox(context, registerNotifier),
        sizedBoxHeight20(context),
        buildCardNumberADL(context, registerNotifier),
      ],
    );
  }

  Widget buildValidationSizedBox(
      BuildContext context, RegisterNotifier registerNotifier) {
    return Visibility(
      visible: registerNotifier.isVerificationADl,
      child: sizedBoxHeight10(context),
    );
  }

  Widget buildPassportListTile(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: MouseRegion(
        cursor: registerNotifier.isADLNotVerifiedRestricted ||
                registerNotifier.isMedicareNotVerifiedRestricted ||
                registerNotifier.isPassportNotVerifiedRestricted
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        child: IgnorePointer(
          ignoring: registerNotifier.isADLNotVerifiedRestricted ||
                  registerNotifier.isMedicareNotVerifiedRestricted ||
                  registerNotifier.isPassportNotVerifiedRestricted
              ? true
              : false,
          child: ExpansionTile(
            initiallyExpanded: registerNotifier.isADLNotVerified ||
                    registerNotifier.isMedicareNotVerified ||
                    registerNotifier.isPassportNotVerified
                ? false
                : false,
            maintainState: true,
            trailing: kIsWeb
                ? getScreenWidth(context) > 350
                    ? registerNotifier.isPassportNotVerified
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.warning,
                                color: error,
                                size: 18,
                              ),
                              Text(
                                ' ' + S.of(context).notVerified,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: error,
                                    fontWeight: AppFont.fontWeightBold),
                              )
                            ],
                          )
                        : registerNotifier.isPassportVerified
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    ' ' + "VERIFIED",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.green,
                                        fontWeight: AppFont.fontWeightBold),
                                  )
                                ],
                              )
                            : SizedBox.shrink()
                    : SizedBox.shrink()
                : screenSizeWidth > 350
                    ? registerNotifier.isPassportNotVerified
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.warning,
                                color: error,
                                size: 18,
                              ),
                              Text(
                                ' ' + S.of(context).notVerified,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: error,
                                    fontWeight: AppFont.fontWeightBold),
                              )
                            ],
                          )
                        : registerNotifier.isPassportVerified
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    ' ' + "VERIFIED",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.green,
                                        fontWeight: AppFont.fontWeightBold),
                                  )
                                ],
                              )
                            : SizedBox.shrink()
                    : SizedBox.shrink(),
            collapsedBackgroundColor: hanBlueshades400,
            controlAffinity: ListTileControlAffinity.leading,
            collapsedIconColor: white,
            collapsedTextColor: white,
            iconColor: white,
            textColor: white,
            backgroundColor: hanBlueshades400,
            onExpansionChanged: (val){
              registerNotifier.isPassportOpen = val;
            },
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).passport,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                kIsWeb
                    ? getScreenWidth(context) <= 350
                        ? registerNotifier.isPassportNotVerified
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.warning,
                                    color: error,
                                    size: 18,
                                  ),
                                  Text(
                                    ' ' + S.of(context).notVerified,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: error,
                                        fontWeight: AppFont.fontWeightBold),
                                  )
                                ],
                              )
                            : registerNotifier.isPassportVerified
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        ' ' + "VERIFIED",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.green,
                                            fontWeight: AppFont.fontWeightBold),
                                      )
                                    ],
                                  )
                                : SizedBox.shrink()
                        : SizedBox.shrink()
                    : screenSizeWidth <= 350
                        ? registerNotifier.isPassportNotVerified
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.warning,
                                    color: error,
                                    size: 18,
                                  ),
                                  Text(
                                    ' ' + S.of(context).notVerified,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: error,
                                        fontWeight: AppFont.fontWeightBold),
                                  )
                                ],
                              )
                            : registerNotifier.isPassportVerified
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        ' ' + "VERIFIED",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.green,
                                            fontWeight: AppFont.fontWeightBold),
                                      )
                                    ],
                                  )
                                : SizedBox.shrink()
                        : SizedBox.shrink()
              ],
            ),
            children: <Widget>[
              Container(
                padding: px15DimenAll(context),
                color: white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildNoteBlack(context,
                        title: S
                            .of(context)
                            .enterYourNameHereExactlyAsItAppearsOnYourPassport),
                    commonSizedBoxHeight10(context),
                    buildNoteBlack(context,
                        title: S
                            .of(context)
                            .pleaseUseUpperCaseLowerCaseCharactersExactlyAsTheyAppearOnYourPassport),
                    commonSizedBoxHeight40(context),
                    kIsWeb
                        ? getScreenWidth(context) > 810
                            ? buildPassportTileGreaterThan810(
                                context, registerNotifier)
                            : buildPassportTileLessThan810(
                                context, registerNotifier)
                        : screenSizeWidth > 810
                            ? buildPassportTileGreaterThan810(
                                context, registerNotifier)
                            : buildPassportTileLessThan810(
                                context, registerNotifier)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPassportTileGreaterThan810(BuildContext context,RegisterNotifier registerNotifier) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: buildPassportNumber(
                    context, registerNotifier)),
            sizedBoxWidth10(context),
            Expanded(
                child: buildFirstNameADL(
                    context,
                    registerNotifier
                        .firstNameControllerPassport,
                    S.of(context).enterFirstNameAsPerPassport,
                    S.of(context).asOnPassport)),
            sizedBoxWidth10(context),
            Expanded(
                child: buildMiddleNameADL(
                    context,
                    registerNotifier
                        .middleNameControllerPassport,
                    S.of(context).enterMiddleNameAsPerPassport,
                    S.of(context).asOnPassport))
          ],
        ),
        commonSizedBoxHeight20(context),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: buildLastNameADL(
                    context,
                    registerNotifier.lastNameControllerPassport,
                    S.of(context).enterLastNameAsPerPassport,
                    S.of(context).asOnPassport)),
            sizedBoxWidth10(context),
            Expanded(
                child: buildDateOfExpiryADL(
                    context,
                    registerNotifier,
                    registerNotifier
                        .dateOfExpiryControllerPassport)),
            sizedBoxWidth10(context),
            Expanded(
                child: buildGender(context, registerNotifier)),
          ],
        )
      ],
    );
  }

  Widget buildPassportTileLessThan810(BuildContext context,RegisterNotifier registerNotifier) {
    return Column(
      children: [
        buildPassportNumber(context, registerNotifier),
        buildValidationSizedBox(context, registerNotifier),
        buildFirstNameADL(
            context,
            registerNotifier.firstNameControllerPassport,
            S.of(context).enterFirstNameAsPerPassport,
            S.of(context).asOnPassport),
        buildValidationSizedBox(context, registerNotifier),
        buildMiddleNameADL(
            context,
            registerNotifier.middleNameControllerPassport,
            S.of(context).enterMiddleNameAsPerPassport,
            S.of(context).asOnPassport),
        buildValidationSizedBox(context, registerNotifier),
        buildLastNameADL(
            context,
            registerNotifier.lastNameControllerPassport,
            S.of(context).enterLastNameAsPerPassport,
            S.of(context).asOnPassport),
        buildValidationSizedBox(context, registerNotifier),
        buildDateOfExpiryADL(
            context,
            registerNotifier,
            registerNotifier
                .dateOfExpiryControllerPassport),
        buildValidationSizedBox(context, registerNotifier),
        buildGender(context, registerNotifier),
      ],
    );
  }

  Widget buildMedicareListTile(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: MouseRegion(
        cursor: registerNotifier.isADLNotVerifiedRestricted ||
                registerNotifier.isMedicareNotVerifiedRestricted ||
                registerNotifier.isPassportNotVerifiedRestricted
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        child: IgnorePointer(
          ignoring: registerNotifier.isADLNotVerifiedRestricted ||
                  registerNotifier.isMedicareNotVerifiedRestricted ||
                  registerNotifier.isPassportNotVerifiedRestricted
              ? true
              : false,
          child: ExpansionTile(
            initiallyExpanded: false,
            maintainState: true,
            trailing: kIsWeb ?  getScreenWidth(context) > 350
                ? registerNotifier.isMedicareNotVerified
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.warning,
                            color: error,
                            size: 18,
                          ),
                          Text(
                            ' ' + S.of(context).notVerified,
                            style: TextStyle(
                                fontSize: 15,
                                color: error,
                                fontWeight: AppFont.fontWeightBold),
                          )
                        ],
                      )
                    : registerNotifier.isMedicareVerified
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    ' ' + "VERIFIED",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.green,
                                        fontWeight: AppFont.fontWeightBold),
                                  )
                                ],
                              )
                            : SizedBox.shrink()
                : SizedBox.shrink() :  screenSizeWidth > 350
                ? registerNotifier.isMedicareNotVerified
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.warning,
                                color: error,
                                size: 18,
                              ),
                              Text(
                                ' ' + S.of(context).notVerified,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: error,
                                    fontWeight: AppFont.fontWeightBold),
                              )
                            ],
                          )
                        : registerNotifier.isMedicareVerified
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    ' ' + "VERIFIED",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.green,
                                        fontWeight: AppFont.fontWeightBold),
                                  )
                                ],
                              )
                            : SizedBox.shrink()
                : SizedBox.shrink(),
            collapsedBackgroundColor: hanBlueshades400,
            controlAffinity: ListTileControlAffinity.leading,
            collapsedIconColor: white,
            collapsedTextColor: white,
            iconColor: white,
            textColor: white,
            backgroundColor: hanBlueshades400,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).medicareCardThisCanOnlyBeProvidedAsASecondaryID,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                kIsWeb
                    ? getScreenWidth(context) <= 350
                        ? registerNotifier.isPassportNotVerified
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.warning,
                                    color: error,
                                    size: 18,
                                  ),
                                  Text(
                                    ' ' + S.of(context).notVerified,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: error,
                                        fontWeight: AppFont.fontWeightBold),
                                  )
                                ],
                              )
                            : registerNotifier.isMedicareVerified
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        ' ' + "VERIFIED",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.green,
                                            fontWeight: AppFont.fontWeightBold),
                                      )
                                    ],
                                  )
                                : SizedBox.shrink()
                        : SizedBox.shrink()
                    : screenSizeWidth <= 350
                        ? registerNotifier.isPassportNotVerified
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.warning,
                                    color: error,
                                    size: 18,
                                  ),
                                  Text(
                                    ' ' + S.of(context).notVerified,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: error,
                                        fontWeight: AppFont.fontWeightBold),
                                  )
                                ],
                              )
                            : registerNotifier.isMedicareVerified
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        ' ' + "VERIFIED",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.green,
                                            fontWeight: AppFont.fontWeightBold),
                                      )
                                    ],
                                  )
                                : SizedBox.shrink()
                        : SizedBox.shrink()
              ],
            ),
            children: <Widget>[
              Container(
                color: white,
                padding: px15DimenAll(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildNoteBlack(context,
                        title: S.of(context).noteIfYourMedicareCardIsGreen),
                    commonSizedBoxHeight10(context),
                    buildNoteBlack(context,
                        title: S
                            .of(context)
                            .pleaseUseUpperCaseLowerCaseCharactersExactlyAsTheyAppearOnYourMedicare),
                    commonSizedBoxHeight40(context),
                    kIsWeb ? getScreenWidth(context) > 810
                        ? buildMedicareTileGreaterThan810(context,registerNotifier)
                        : buildMedicareTileLessThan810(context,registerNotifier) :  screenSizeWidth > 810
                        ? buildMedicareTileGreaterThan810(context,registerNotifier)
                        : buildMedicareTileLessThan810(context,registerNotifier)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMedicareTileGreaterThan810(BuildContext context,RegisterNotifier registerNotifier) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: buildNameMedicare(
                    context, registerNotifier)),
            sizedBoxWidth10(context),
            Expanded(
                child: buildNameMedicareNumber(
                    context, registerNotifier)),
            sizedBoxWidth10(context),
            Expanded(
                child: buildDateOfExpiryADL(
                    context,
                    registerNotifier,
                    registerNotifier
                        .dateOfExpiryControllerMedicare))
          ],
        ),
        commonSizedBoxHeight20(context),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: buildNameIndividualReferenceNumber(
                    context, registerNotifier)),
            sizedBoxWidth10(context),
            Expanded(
                child:
                buildCardColor(context, registerNotifier)),
            sizedBoxWidth10(context),
            Expanded(child: Container()),
          ],
        )
      ],
    );
  }

  Widget buildMedicareTileLessThan810(BuildContext context,RegisterNotifier registerNotifier) {
    return Column(
      children: [
        buildNameMedicare(context, registerNotifier),
        buildValidationSizedBox(context, registerNotifier),
        buildNameMedicareNumber(context, registerNotifier),
        buildValidationSizedBox(context, registerNotifier),
        buildDateOfExpiryADL(
            context,
            registerNotifier,
            registerNotifier
                .dateOfExpiryControllerMedicare),
        buildValidationSizedBox(context, registerNotifier),
        buildNameIndividualReferenceNumber(
            context, registerNotifier),
        buildValidationSizedBox(context, registerNotifier),
        buildCardColor(context, registerNotifier),
        SizedBox(),
      ],
    );
  }

  Widget buildDocumentNeededListTile(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: true,
        maintainState: true,
        iconColor: white,
        textColor: white,
        collapsedBackgroundColor: hanBlueshades400,
        controlAffinity: ListTileControlAffinity.leading,
        collapsedIconColor: white,
        collapsedTextColor: white,
        backgroundColor: hanBlueshades400,
        title: Text(
          S.of(context).documentsNeeded,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: <Widget>[
          Container(
            color: white,
            padding: px15DimenAll(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildPassportOrDrivingProofTitle(context),
                commonSizedBoxHeight10(context),
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
                buildPhotoIdOrBillProofTitle(context),
                commonSizedBoxHeight10(context),
                Padding(
                  padding: px16DimenLeftOnly(context),
                  child: Column(
                    children: [
                      buildDocuments(context,
                          text: S.of(context).stateIssuedPhotoIDCard),
                      buildDocuments(context,
                          text: S.of(context).StateIssuedProofOfAgeCard),
                      buildDocuments(context,
                          text: S
                              .of(context)
                              .validVisaApprovalDocumentShowingYourNameDateOfBirth),
                      buildDocuments(context,
                          text: S
                              .of(context)
                              .utilityBillElectricityGasTelephoneWithCurrentAddress),
                      buildDocuments(context,
                          text: S.of(context).bankStatementWithCurrentAddress),
                    ],
                  ),
                ),
                commonSizedBoxHeight30(context),
                kIsWeb
                    ? Row(
                        children: [
                          Expanded(
                              child: buildDragAndDropBox(
                            registerNotifier,
                            context,
                          )),
                        ],
                      )
                    : buildDragAndDropBoxMobile(registerNotifier, context),
                commonSizedBoxHeight15(context),
                Visibility(
                    visible: registerNotifier.isFileAddedVerification,
                    child: Column(
                      children: [
                        commonSizedBoxHeight10(context),
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
                commonSizedBoxHeight20(context),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildHeading(context, {title, fontsize}) {
    return buildText(
        text: title,
        fontSize: fontsize ?? AppConstants.sixteen,
        fontColor: oxfordBlueTint500);
  }

  Widget buildNoteBlack(context, {title, fontsize}) {
    return buildText(
        text: title,
        fontSize: fontsize ?? AppConstants.sixteen,);
  }

  Widget buildFirstNameADL(BuildContext context,
      TextEditingController controller, String message, String hinText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildHeading(context, title: S.of(context).firstName),
        commonSizedBoxHeight10(context),
        CommonTextField(
          maxHeight: 25,
          suffixIcon: Tooltip(
            message: message,
            child: Padding(
              padding: px8RightAndBottom(context),
              child: Icon(Icons.info_outline_rounded),
            ),
          ),
          controller: controller,
          helperText: '',
          errorStyle: TextStyle(color: errorTextField,
              fontSize: 11.5,fontWeight: FontWeight.w500),
          keyboardType: TextInputType.text,
          width: kIsWeb ? getScreenWidth(context) * 0.80 : screenSizeWidth * 0.80,
          hintText: hinText,
          hintStyle: hintStyle(context),
          validatorEmptyErrorText: AppConstants.enterFirstName,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
          ],
        ),
      ],
    );
  }

  Widget buildMiddleNameADL(BuildContext context,
      TextEditingController controller, String message, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeading(context,
            title: S.of(context).middleName,
            fontsize: kIsWeb ?
            getScreenWidth(context) < 835 && getScreenWidth(context) > 810
                ? AppConstants.fourteen
                : AppConstants.sixteen : screenSizeWidth < 835 &&
                screenSizeWidth > 810
                ? AppConstants.fourteen
                : AppConstants.sixteen),
        commonSizedBoxHeight10(context),
        CommonTextField(
          maxHeight: 25,
          suffixIcon: Tooltip(
              message: message,
              child: Padding(
                padding: px8RightAndBottom(context),
                child: Icon(Icons.info_outline_rounded),
              )),
          errorStyle: TextStyle(color: errorTextField,
              fontSize: 11.5,fontWeight: FontWeight.w500),
          controller: controller,
          helperText: '',
          keyboardType: TextInputType.text,
          width: kIsWeb ? getScreenWidth(context) * 0.80 : screenSizeWidth * 0.80,
          hintText: hintText,
          hintStyle: hintStyle(context),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
          ],
        ),
      ],
    );
  }

  Widget buildLastNameADL(BuildContext context,
      TextEditingController controller, String message, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeading(context, title: S.of(context).lastName),
        commonSizedBoxHeight10(context),
        CommonTextField(
          maxHeight: 25,
          suffixIcon: Tooltip(
              message: message,
              child: Padding(
                padding: px8RightAndBottom(context),
                child: Icon(Icons.info_outline_rounded),
              )),
          errorStyle: TextStyle(color: errorTextField,
              fontSize: 11.5,fontWeight: FontWeight.w500),
          controller: controller,
          helperText: '',
          keyboardType: TextInputType.text,
          width: kIsWeb ? getScreenWidth(context) * 0.80 : screenSizeWidth * 0.80,
          hintText: hintText,
          hintStyle: hintStyle(context),
          validatorEmptyErrorText: AppConstants.enterLastName,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
          ],
        ),
      ],
    );
  }

  Widget buildLicenceNumberADL(
      BuildContext context, RegisterNotifier registerNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeading(context, title: S.of(context).licenseNumber),
        commonSizedBoxHeight10(context),
        Selector<RegisterNotifier, TextEditingController>(
            builder: (context, licenceNumberControllerADL, child) {
              return CommonTextField(
                maxHeight: 25,
                suffixIcon: Tooltip(
                    message: S.of(context).drivingLicenseNumberCanNotContain,
                    child: Padding(
                      padding: px8RightAndBottom(context),
                      child: Icon(Icons.info_outline_rounded),
                    )),
                errorStyle: TextStyle(color: errorTextField,
                    fontSize: 11.5,fontWeight: FontWeight.w500),
                controller: licenceNumberControllerADL,
                helperText: '',
                keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
                width:  kIsWeb ? getScreenWidth(context) * 0.80 : screenSizeWidth * 0.80,
                hintText: S.of(context).asOnDriversLicence,
                hintStyle: hintStyle(context),
                validatorEmptyErrorText: AppConstants.licenceIsRequired,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z-0-9]")),
                ],
              );
            },
            selector: (buildContext, registerNotifier) =>
                registerNotifier.licenceNumberControllerADL),
      ],
    );
  }

  Widget buildDateOfExpiryADL(BuildContext context,
      RegisterNotifier registerNotifier, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeading(context, title: S.of(context).dateOfExpiry),
        commonSizedBoxHeight10(context),
        CommonTextField(
          height: 70,
          suffixIcon: Padding(
            padding: px8RightAndBottom(context),
            child: Icon(
              Icons.calendar_today_outlined,
              size: 20,
            ),
          ),
          errorStyle: TextStyle(color: errorTextField,
              fontSize: 11.5,fontWeight: FontWeight.w500),
          controller: controller,
          helperText: '',
          keyboardType: TextInputType.text,
          width: kIsWeb ? getScreenWidth(context) * 0.80 : screenSizeWidth * 0.80,
          readOnly: true,
          onTap: () {
            if (defaultTargetPlatform == TargetPlatform.iOS) {
              iosDatePicker(context, registerNotifier, controller,minimumDate: DateTime.now());
            } else
              androidDatePicker(context, registerNotifier, controller,
                  firstDate: DateTime.now());
          },
          hintText: S.of(context).dateOfExpiry,
          hintStyle: hintStyle(context),
          validatorEmptyErrorText: 'Date of expiry is required',
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
          ],
        ),
      ],
    );
  }

  Widget buildIssuingAuthorityADL(
      BuildContext context, RegisterNotifier registerNotifier) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        buildHeading(context, title: S.of(context).issuingAuthority),
        commonSizedBoxHeight10(context),
        LayoutBuilder(
            builder: (context, constraints) => CustomizeDropdown(
                  context,
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Issuing Authority is required';
                    }
                    return null;
                  },
                  dropdownItems: registerNotifier.issuingAuthority,
                  controller: registerNotifier.issuingAuthorityControllerADL,
                  width: kIsWeb ? getScreenWidth(context) * 0.80 : screenSizeWidth * 0.80,
                  optionsViewBuilder: (context,
                      AutocompleteOnSelected onSelected, Iterable options) {
                    return buildDropDownContainer(
                      context,
                      options: options,
                      onSelected: onSelected,
                      dropdownData: registerNotifier.issuingAuthority,
                      constraints: constraints,
                      dropDownHeight: options.first == 'No Data Found'
                          ? 150
                          :  options.length < 7
                          ? options.length * 50
                          : 250,
                    );
                  },
                  onSelected: (val) {
                    registerNotifier.selectedIssuingAuthority = val;
                  },
                )),
      ]),
    );
  }

  Widget buildCardNumberADL(
      BuildContext context, RegisterNotifier registerNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeading(context, title: S.of(context).cardNumber),
        commonSizedBoxHeight10(context),
        Selector<RegisterNotifier, TextEditingController>(
            builder: (context, cardNumberControllerADL, child) {
              return CommonTextField(
                maxHeight: 25,
                controller: cardNumberControllerADL,
                helperText: '',
                errorStyle: TextStyle(color: errorTextField,
                    fontSize: 11.5,fontWeight: FontWeight.w500),
                keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
                width: kIsWeb ? getScreenWidth(context) * 0.80 : screenSizeWidth * 0.80,
                hintText: S.of(context).asOnDriversLicence,
                hintStyle: hintStyle(context),
                validatorEmptyErrorText: registerNotifier
                    .selectedIssuingAuthority == "Victoria"?null:'Card number is required',
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
              );
            },
            selector: (buildContext, registerNotifier) =>
                registerNotifier.cardNumberControllerADL),
      ],
    );
  }

  Widget buildPassportNumber(
      BuildContext context, RegisterNotifier registerNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeading(context, title: S.of(context).passportNumber),
        commonSizedBoxHeight10(context),
        Selector<RegisterNotifier, TextEditingController>(
            builder: (context, passportNumberControllerADL, child) {
              return CommonTextField(
                maxHeight: 25,
                suffixIcon: Tooltip(
                    message: S.of(context).passportNumberCanContain,
                    child: Padding(
                      padding: px8RightAndBottom(context),
                      child: Icon(Icons.info_outline_rounded),
                    )),
                errorStyle: TextStyle(color: errorTextField,
                    fontSize: 11.5,fontWeight: FontWeight.w500),
                controller: passportNumberControllerADL,
                helperText: '',
                keyboardType: TextInputType.text,
                width:  kIsWeb ? getScreenWidth(context) * 0.80 : screenSizeWidth * 0.80,
                hintText: S.of(context).asOnPassport,
                validator: (fieldText){
                  if (fieldText!.length < 7 || fieldText.length > 9) {
                    return 'Note: Passport number must be 7 - 9 characters';
                  }
                  return null;
                },
                autoValidateMode: AutovalidateMode.disabled,
                hintStyle: hintStyle(context),
                validatorEmptyErrorText: AppConstants.passportIsRequired,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z-0-9]")),
                ],
              );
            },
            selector: (buildContext, registerNotifier) =>
                registerNotifier.passportNumberControllerADL),
      ],
    );
  }

  Widget buildGender(BuildContext context, RegisterNotifier registerNotifier) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeading(context, title: S.of(context).gender),
          commonSizedBoxHeight10(context),
          LayoutBuilder(
            builder: (context, constraints) => CustomizeDropdown(
              context,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Gender is required';
                }
                return null;
              },
              dropdownItems: registerNotifier.genderListData,
              controller: registerNotifier.GenderControllerADL,
              width: kIsWeb ? getScreenWidth(context) * 0.80 : screenSizeWidth * 0.80,
              optionsViewBuilder: (BuildContext context,
                  AutocompleteOnSelected onSelected, Iterable options) {
                return buildDropDownContainer(
                  context,
                  options: options,
                  onSelected: onSelected,
                  dropdownData: registerNotifier.genderListData,
                  constraints: constraints,
                  dropDownHeight: options.first == 'No Data Found'
                      ? 150
                      : options.length * 50,
                );
              },
              onSelected: (val) {
                registerNotifier.selectedGender = val;
              },
              onSubmitted: (val) {
                registerNotifier.selectedGender = val;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNameMedicare(
      BuildContext context, RegisterNotifier registerNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeading(context, title: S.of(context).name),
        commonSizedBoxHeight10(context),
        Selector<RegisterNotifier, TextEditingController>(
            builder: (context, nameControllerMedicare, child) {
              return CommonTextField(
                maxHeight: 25,
                suffixIcon: Tooltip(
                    message: S
                        .of(context)
                        .nameOnYourMedicareCardAndItShouldNotContainMoreThan27characters,
                    child: Padding(
                      padding: px8RightAndBottom(context),
                      child: Icon(Icons.info_outline_rounded),
                    )),
                errorStyle: TextStyle(color: errorTextField,
                    fontSize: 11.5,fontWeight: FontWeight.w500),
                controller: nameControllerMedicare,
                helperText: '',
                keyboardType: TextInputType.text,
                width: getScreenWidth(context) * 0.80,
                hintText: S.of(context).asOnMedicare,
                hintStyle: hintStyle(context),
                validatorEmptyErrorText: AppConstants.nameIsRequired,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                ],
              );
            },
            selector: (buildContext, registerNotifier) =>
                registerNotifier.nameControllerMedicare),
      ],
    );
  }

  Widget buildNameMedicareNumber(
      BuildContext context, RegisterNotifier registerNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeading(context, title: S.of(context).medicareNumber),
        commonSizedBoxHeight10(context),
        Selector<RegisterNotifier, TextEditingController>(
            builder: (context, medicareNumberControllerMedicare, child) {
              return CommonTextField(
                maxHeight: 25,
                suffixIcon: Tooltip(
                    message: S
                        .of(context)
                        .medicareCardNumberMustContainMinimumOf10NumericCharacters,
                    child: Padding(
                      padding: px8RightAndBottom(context),
                      child: Icon(Icons.info_outline_rounded),
                    )),
                errorStyle: TextStyle(color: errorTextField,
                    fontSize: 11.5,fontWeight: FontWeight.w500),
                controller: medicareNumberControllerMedicare,
                helperText: '',
                keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
                width:  kIsWeb ? getScreenWidth(context) * 0.80 : screenSizeWidth * 0.80,


                hintText: S.of(context).asOnMedicare,
                autoValidateMode: AutovalidateMode.disabled,
                hintStyle: hintStyle(context),
                validator: (fieldText){
                  if (fieldText!.length < 10) {
                    return 'Note: Medicare card number must be atleast 10 characters';
                  }
                  return null;
                },
                validatorEmptyErrorText: 'Medicare number is required',
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z-0-9]")),
                ],
              );
            },
            selector: (buildContext, registerNotifier) =>
                registerNotifier.medicareNumberControllerMedicare),
      ],
    );
  }

  Widget buildNameIndividualReferenceNumber(
      BuildContext context, RegisterNotifier registerNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeading(context,
            title: S.of(context).individualReferenceNumber,
            fontsize: kIsWeb ? getScreenWidth(context) > 810 && getScreenWidth(context) < 825 ? 12.5:getScreenWidth(context) < 890 &&
                    getScreenWidth(context) > 810
                ? AppConstants.thirteen
                : getScreenWidth(context) < 998 && getScreenWidth(context) > 810
                    ? AppConstants.fourteen
                    : AppConstants.sixteen :  screenSizeWidth < 890 &&
                screenSizeWidth > 810
                ? AppConstants.thirteen
                : screenSizeWidth < 995 && screenSizeWidth > 810
                ? AppConstants.fourteen
                : AppConstants.sixteen),
        commonSizedBoxHeight10(context),
        Selector<RegisterNotifier, TextEditingController>(
            builder:
                (context, individualReferenceNumberControllerMedicare, child) {
              return CommonTextField(
                maxHeight: 25,
                suffixIcon: Tooltip(
                    message: S
                        .of(context)
                        .theNumberToTheLeftOfYourNameOnTheMedicareCard,
                    child: Padding(
                      padding: px8RightAndBottom(context),
                      child: Icon(Icons.info_outline_rounded),
                    )),
                errorStyle: TextStyle(color: errorTextField,
                    fontSize: 11.5,fontWeight: FontWeight.w500),
                controller: individualReferenceNumberControllerMedicare,
                helperText: '',
                keyboardType: TextInputType.text,
                width:  kIsWeb ? getScreenWidth(context) * 0.80 : screenSizeWidth * 0.80,
                hintText: S.of(context).asOnMedicare,
                hintStyle: hintStyle(context),
                validatorEmptyErrorText: 'Reference number is required',
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z-0-9]")),
                ],
              );
            },
            selector: (buildContext, registerNotifier) =>
                registerNotifier.individualReferenceNumberControllerMedicare),
      ],
    );
  }

  Widget buildCardColor(
      BuildContext context, RegisterNotifier registerNotifier) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeading(context, title: S.of(context).cardColor),
          SizedBox(height: kIsWeb ? getScreenWidth(context) > 997 ? 8 : 5 : screenSizeWidth > 997 ? 8 : 5),
          LayoutBuilder(
            builder: (context, constraints) => CustomizeDropdown(context,
                dropdownItems: registerNotifier.medicareColor,
                controller: registerNotifier.cardColorControllerMedicare,
                width: kIsWeb ? getScreenWidth(context) * 0.80 : screenSizeWidth * 0.80,
                optionsViewBuilder: (BuildContext context,
                    AutocompleteOnSelected onSelected, Iterable options) {
                  return buildDropDownContainer(
                    context,
                    options: options,
                    onSelected: onSelected,
                    dropdownData: registerNotifier.medicareColor,
                    constraints: constraints,
                    dropDownHeight: options.first == 'No Data Found'
                        ? 150
                        : options.length * 50,
                  );
                },
                onSelected: (val) {
                  registerNotifier.selectedCardColor = val;
                },
                validation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Card color is required';
                  }
                  return null;
                },
                onSubmitted: (val) {
                  registerNotifier.selectedCardColor = val;
                }),
          ),
        ],
      ),
    );
  }

  Widget buildPassportOrDrivingProofTitle(BuildContext context) {
    return buildText(
        text: S.of(context).pleaseUploadAnyONEOfTheFollowingDocuments,
        fontWeight: AppFont.fontWeightRegular,
        fontColor: black);
  }

  Widget buildDocuments(BuildContext context, {text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(radius: 3.5, backgroundColor: black),
            SizedBox(
                width: kIsWeb ? getScreenWidth(context) < 800
                    ? getScreenWidth(context) * 0.01
                    : getScreenWidth(context) * 0.007 :  screenSizeWidth < 800
                    ? screenSizeWidth * 0.01
                    : screenSizeWidth * 0.007),
            Flexible(
                child: buildText(
                    text: text,
                    fontWeight: AppFont.fontWeightRegular,
                    fontColor: black))
          ],
        ),
        commonSizedBoxHeight10(context),
      ],
    );
  }

  Widget buildCouldNotVerified(
      BuildContext context, RegisterNotifier registerNotifier) {
    return Visibility(
        visible: registerNotifier.errorListStep2.isNotEmpty,
        child: Container(
          padding: px15DimenAll(context),
          decoration: webAlertContainerStyle(context),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info,
                color: orangeColor.withOpacity(0.8),
                size: 20,
              ),
              sizedBoxWidth10(context),
              Expanded(
                child: Text(
                  registerNotifier.errorListStep2,
                  style: alertbodyTextStyle12(context),
                ),
              ),
              sizedBoxHeight15(context),
            ],
          ),
        ));
  }

  Widget buildPleaseEnterTheRequiredData(BuildContext context) {
    return Container(
      padding: px15DimenAll(context),
      decoration: webAlertContainerStyle(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info,
            color: orangeColor.withOpacity(0.8),
            size: 20,
          ),
          sizedBoxWidth10(context),
          Expanded(
            child: Text(
              S
                  .of(context)
                  .pleaseProvideDetailsOfOneOrMoreOfTheseDocumentsForEVerification,
              style: alertbodyTextStyle12(context),
            ),
          ),
          sizedBoxHeight15(context),
        ],
      ),
    );
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
      isFileAdded: registerNotifier.isFileAdded,
      loading: registerNotifier.isFileLoading,
      progressValue: registerNotifier.progressValue,
      file: registerNotifier.fileAdditional,
      isAllowMultiple: true,
      registerNotifier: registerNotifier,
      onDroppedFile: (file) {
        registerNotifier.fileAdditionalFileAdditionalAdd = file;
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
      file: registerNotifier.platformFileAdditional,
      fileImage: registerNotifier.filesAdditionalMob,
      isAllowMultiple: true,
      registerNotifier: registerNotifier,
      size: registerNotifier.sizeAdditional,
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

  AuthStatus(BuildContext context){
    SharedPreferencesMobileWeb.instance
        .getContactId(apiContactId)
        .then((value) {
      AuthRepository()
          .apiCustomerStatus(value, context)
          .then((value) async {
        CustomerStatusResponse customerStatusResponse =
        value as CustomerStatusResponse;

        if (customerStatusResponse.statusId == 10000003 ||customerStatusResponse.statusId == 10000004 ||
            customerStatusResponse.statusId == 10000005) {
          Provider
              .of<CommonNotifier>(context, listen: false)
              .updateUserVerifiedBool = false;
          SharedPreferencesMobileWeb.instance.setUserVerified(false);
          await SharedPreferencesMobileWeb.instance
              .getCountry(country)
              .then((value) async {
            Navigator.pushNamedAndRemoveUntil(
              context,
              dashBoardRoute,
                  (route) => false,
            );
          });
        } else if (customerStatusResponse.statusId == 10000009 ||
            customerStatusResponse.statusId == 10000010 ||
            customerStatusResponse.statusId == 10000011 || customerStatusResponse.statusId == 10000012) {
          Provider
              .of<CommonNotifier>(context, listen: false)
              .updateUserVerifiedBool = true;
          SharedPreferencesMobileWeb.instance.setUserVerified(true);
          await SharedPreferencesMobileWeb.instance
              .getCountry(country)
              .then((value) async {
            Navigator.pushNamedAndRemoveUntil(
              context,
              dashBoardRoute,
                  (route) => false,
            );
          });
        } else if (customerStatusResponse.statusId == 10000013||customerStatusResponse.statusId == 10000014) {
          Provider
              .of<CommonNotifier>(context, listen: false)
              .updateUserVerifiedBool = false;
          SharedPreferencesMobileWeb.instance.setUserVerified(false);
          await SharedPreferencesMobileWeb.instance
              .getCountry(country)
              .then((value) async {
            Navigator.pushNamedAndRemoveUntil(
              context,
              dashBoardRoute,
                  (route) => false,
            );
          });
        }
      });
    });
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
          registerNotifier.filesAdditionalMobAdd = File(element.path!);
          registerNotifier.sizeAdditionalAdd = size;
          registerNotifier.platformFileAdditionalAdd = element;
          updateProgress(registerNotifier);
          registerNotifier.isFileAdded = true;
        }
      });
    }
  }

  void updateProgress(RegisterNotifier registerNotifier) {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer t) {
      registerNotifier.progressValue += 0.1;
      if(registerNotifier.progressValue <= 1.0) {
        if(!registerNotifier.isFileAdded) {
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
}
