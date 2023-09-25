import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/service/contact_repository.dart';
import 'package:singx/core/models/request_response/personal_details/personal_details_sg_request.dart';
import 'package:singx/core/models/request_response/personal_details/personal_details_sg_response.dart';
import 'package:singx/core/notifier/common_notifier.dart';
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
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

var dropdownWidth;

class PersonalDetailScreen extends StatelessWidget {
  const PersonalDetailScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          RegisterNotifier(context, from: "PersonalDetailScreen"),
      child: Consumer<RegisterNotifier>(
        builder: (context, registerNotifier, _) {
          dropdownWidth = kIsWeb
              ? isMobile(context)
                  ? getScreenWidth(context) * 0.80
                  : isTab(context)
                      ? getScreenWidth(context) * 0.60
                      : getScreenWidth(context) * 0.46
              : isMobileSDK(context)
                  ? screenSizeWidth * 0.80
                  : isTabSDK(context)
                      ? screenSizeWidth * 0.60
                      : screenSizeWidth * 0.46;
          return Scaffold(
            backgroundColor: white,
            body: Scrollbar(
              controller: registerNotifier.scrollController,
              child: SingleChildScrollView(
                controller: registerNotifier.scrollController,
                child: Form(
                  key: registerNotifier.personalDetailFormKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: kIsWeb
                            ? isMobile(context)
                                ? getScreenWidth(context) * 0.10
                                : isTab(context)
                                    ? getScreenWidth(context) * 0.20
                                    : getScreenWidth(context) * 0.25
                            : isMobileSDK(context)
                                ? screenSizeWidth * 0.10
                                : isTabSDK(context)
                                    ? screenSizeWidth * 0.20
                                    : screenSizeWidth * 0.25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        commonSizedBoxHeight60(context),
                        buildHeaderText(context),
                        commonSizedBoxHeight20(context),
                        buildSubHeaderText(context),
                        commonSizedBoxHeight40(context),
                        Visibility(
                          visible: registerNotifier.isRegistrationSelected,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildSalutationText(context),
                              commonSizedBoxHeight10(context),
                              buildSalutationDropDownBox(
                                  context, registerNotifier),
                              commonSizedBoxHeight20(context),
                            ],
                          ),
                        ),
                        buildNameRow(registerNotifier, context),
                        Visibility(
                            child: commonSizedBoxHeight20(context),
                            visible: registerNotifier.isError),
                        buildHeading(context,
                            title: S.of(context).esidenceStatus),
                        commonSizedBoxHeight10(context),
                        buildResidenceDropDownBox(context, registerNotifier),
                        commonSizedBoxHeight10(context),
                        Visibility(
                          visible: !registerNotifier.isJohorAddress,
                          child: buildLinkText(registerNotifier, context),
                        ),
                        commonSizedBoxHeight30(context),
                        !registerNotifier.isRegistrationSelected
                            ? buildMobileTextField(registerNotifier, context)
                            : kIsWeb
                                ? isTab(context) ||
                                        getScreenWidth(context) < 1100
                                    ? buildEmailAndMobileTextFieldTab(
                                        registerNotifier, context)
                                    : buildEmailAndMobileTextField(
                                        registerNotifier, context)
                                : isTabSDK(context) || screenSizeWidth < 1100
                                    ? buildEmailAndMobileTextFieldTab(
                                        registerNotifier, context)
                                    : buildEmailAndMobileTextField(
                                        registerNotifier, context),
                        commonSizedBoxHeight30(context),
                        buildAddressText(context),
                        commonSizedBoxHeight10(context),
                        registerNotifier.isJohorAddress
                            ? buildSingaporeAddressField(
                                registerNotifier, context)
                            : buildJohorAddressField(registerNotifier, context),
                        commonSizedBoxHeight40(context),
                        buildEmployerNameText(context),
                        commonSizedBoxHeight10(context),
                        buildEmployerNameInfo(context),
                        commonSizedBoxHeight15(context),
                        buildEmployerTextField(registerNotifier, context),
                        commonSizedBoxHeight45(context),
                        buildOccupationText(context),
                        commonSizedBoxHeight10(context),
                        buildOccupationInfoText(context),
                        commonSizedBoxHeight12(context),
                        buildOccupationDropdownBox(context, registerNotifier),
                        commonSizedBoxHeight45(context),
                        Visibility(
                          visible:
                              registerNotifier.selectedOccupation == "Others",
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildHeading(context, title: "Others"),
                              commonSizedBoxHeight10(context),
                              buildOccupationOthersField(
                                  registerNotifier, context)
                            ],
                          ),
                        ),
                        Visibility(
                          visible: registerNotifier.isRegistrationSelected,
                          child: Column(
                            children: [
                              commonSizedBoxHeight10(context),
                              buildSingPassNote(context),
                            ],
                          ),
                        ),
                        commonSizedBoxHeight30(context),
                        buildReferralCodeText(context),
                        commonSizedBoxHeight10(context),
                        buildReferralCodeInfoText(context),
                        commonSizedBoxHeight12(context),
                        buildReferralCodeTextField(registerNotifier, context),
                        commonSizedBoxHeight20(context),
                        Visibility(
                          visible: registerNotifier.errorList.isNotEmpty,
                          child: Text(
                            registerNotifier.errorList.isNotEmpty
                                ? registerNotifier.errorList[0]
                                : "",
                            style: errorMessageStyle(context),
                          ),
                        ),
                        commonSizedBoxHeight50(context),
                        buildButtons(registerNotifier, context),
                        commonSizedBoxHeight50(context),
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

  Widget buildSingPassNote(BuildContext context){
    return SizedBox(
      width: dropdownWidth,
      child: Text(
        AppConstants.singPassNote,
        style: policyStyleBlack(context),
      ),
    );
  }

  Widget buildHeaderText(BuildContext context) {
    return buildText(
        text: S.of(context).personalDetailsWeb,
        fontSize: AppConstants.twenty,
        fontColor: oxfordBlue,
        fontWeight: FontWeight.w700);
  }

  Widget buildSubHeaderText(BuildContext context) {
    return buildText(
        text: S.of(context).fillDetailToCreateAccount,
        fontSize: AppConstants.sixteen,
        fontWeight: FontWeight.w400,
        fontColor: oxfordBlueTint400);
  }

  Widget buildSalutationText(BuildContext context) {
    return buildHeading(context, title: S.of(context).salutation);
  }

  Widget buildSalutationDropDownBox(
      BuildContext context, RegisterNotifier registerNotifier) {
    return CustomizeDropdown(
      context,
      dropdownItems: registerNotifier.salutationListData,
      controller: registerNotifier.salutationController,
      width: dropdownWidth,
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected onSelected, Iterable options) {
        return buildDropDownContainer(
          context,
          options: options,
          onSelected: onSelected,
          dropdownData: registerNotifier.salutationListData,
          dropDownWidth: dropdownWidth,
          dropDownHeight: options.first == S.of(context).noDataFound
              ? 150
              : options.length * 50,
        );
      },
    );
  }

  Widget buildNameRow(RegisterNotifier registerNotifier, BuildContext context) {
    return commonRowField(context,
        header1: S.of(context).firstNameWeb,
        header2: S.of(context).lastNameWeb,
        controller1: registerNotifier.firstNameController,
        controller2: registerNotifier.lastNameController,
        hintText1: AppConstants.john,
        hintText2: AppConstants.doe,
        validationRequired1: 'First name is required',
        validationRequired2: 'Last name is required',
        validationLength1: AppConstants.enterFirstName,
        validationLength2: AppConstants.enterLastName);
  }

  Widget buildLinkText(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Container(
      width: dropdownWidth,
      child: Row(
        children: [
          Flexible(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: S.of(context).workInSingaporeAndJohor,
                    style: topupAboutSubHeading(context),
                  ),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        registerNotifier.isJohorAddress = true;
                        registerNotifier.stateController.text = 'Johor';
                      },
                    text: S.of(context).here,
                    style: topupAboutSubHeadingOrange(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildResidenceDropDownBox(
      BuildContext context, RegisterNotifier registerNotifier) {
    registerNotifier.residenceStatus.sort();
    return CustomizeDropdown(
      context,
      validation: (value) {
        if (value == null || value.isEmpty) {
          return 'Residence Status is required';
        }
        return null;
      },
      dropdownItems: registerNotifier.residenceStatus,
      controller: registerNotifier.residenceStatusController,
      width: dropdownWidth,
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected onSelected, Iterable options) {
        return buildDropDownContainer(
          context,
          options: options,
          onSelected: onSelected,
          dropdownData: registerNotifier.salutationListData,
          dropDownWidth: dropdownWidth,
          dropDownHeight: options.first == S.of(context).noDataFound
              ? 150
              : options.length < 5
                  ? options.length * 50
                  : options.length * 30,
        );
      },
      onSelected: (val) {
        registerNotifier.residentStatus = val!;
        registerNotifier.residenceIdStr = val!;
      },
      onSubmitted: (val) {
        registerNotifier.residentStatus = val!;
        registerNotifier.residenceIdStr = val!;
      },
      hintText: 'Choose an option',
    );
  }

  Widget buildEmailAndMobileTextField(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeading(context, title: S.of(context).emailAddressWeb),
            commonSizedBoxHeight10(context),
            Selector<RegisterNotifier, TextEditingController>(
                builder: (context, emailController, child) {
                  return CommonTextField(
                    helperText: '',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    width: kIsWeb ? isTab(context) ? getScreenWidth(context) * 0.29 : getScreenWidth(context) * 0.22 : isTabSDK(context) ? screenSizeWidth * 0.29 : screenSizeWidth * 0.22,
                    hintText: AppConstants.sampleMail,
                    hintStyle: hintStyle(context),
                    validatorEmptyErrorText: AppConstants.emailIsRequired,
                    isEmailValidator: true,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp("[ A-Za-z0-9_@./#&+-]")),
                    ],
                  );
                },
                selector: (buildContext, registerNotifier) =>
                    registerNotifier.emailController)
          ],
        ),
        commonSizedBoxWidth20(context),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeading(context, title: S.of(context).mobileNumberWeb),
            commonSizedBoxHeight10(context),
            Selector<RegisterNotifier, TextEditingController>(
                builder: (context, mobileNumberController, child) {
                  return CommonTextField(
                    helperText: '',
                    controller: mobileNumberController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
                    width: kIsWeb ? isTab(context) ? getScreenWidth(context) * 0.29 : getScreenWidth(context) * 0.22 : isTabSDK(context) ? screenSizeWidth * 0.29 : screenSizeWidth * 0.22,
                    prefixIcon: Wrap(
                      children: [
                        SizedBox(width: AppConstants.one),
                        Container(
                            decoration: const BoxDecoration(
                                color: lightBlueWebColor,
                                borderRadius:
                                    BorderRadius.only(topLeft: Radius.zero)),
                            height: AppConstants.prefixContainerHeight,
                            width: AppConstants.prefixContainerWidth,
                            child: Row(
                              children: [
                                commonSizedBoxWidth7(context),
                                Image.asset(AppImages.singaporeFlag,
                                    width: AppConstants.flagIconWidth,
                                    height: AppConstants.flagIconHeight),
                                commonSizedBoxWidth7(context),
                                buildText(
                                    text: singapore,
                                    fontSize: AppConstants.sixteen),
                              ],
                            )),
                        commonSizedBoxWidth10(context),
                      ],
                    ),
                    validatorEmptyErrorText: mobileRequired,
                    isMobileNumberValidator: true,
                    maxLength: 8,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    ],
                  );
                },
                selector: (buildContext, registerNotifier) =>
                    registerNotifier.mobileNumberController)
          ],
        )
      ],
    );
  }

  Widget buildMobileTextField(RegisterNotifier registerNotifier, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeading(context, title: S.of(context).mobileNumberWeb),
        commonSizedBoxHeight10(context),
        Selector<RegisterNotifier, TextEditingController>(
            builder: (context, mobileNumberController, child) {
              return CommonTextField(
                helperText: '',
                controller: mobileNumberController,
                keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
                width: dropdownWidth,
                prefixIcon: Wrap(
                  children: [
                    SizedBox(width: AppConstants.one),
                    Container(
                        decoration: const BoxDecoration(
                            color: lightBlueWebColor,
                            borderRadius:
                            BorderRadius.only(topLeft: Radius.zero)),
                        height: AppConstants.prefixContainerHeight,
                        width: AppConstants.hundred,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(AppImages.singaporeFlag,
                                width: AppConstants.flagIconWidth,
                                height: AppConstants.flagIconHeight),
                            buildText(
                                text: singapore,
                                fontSize: AppConstants.sixteen),
                          ],
                        )),
                    commonSizedBoxWidth20(context),
                  ],
                ),
                validatorEmptyErrorText: mobileRequired,
                isMobileNumberValidator: true,
                maxLength: 8,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
              );
            },
            selector: (buildContext, registerNotifier) =>
            registerNotifier.mobileNumberController)
      ],
    );
  }

  Widget buildEmailAndMobileTextFieldTab(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeading(context, title: S.of(context).emailAddressWeb),
        commonSizedBoxHeight10(context),
        Selector<RegisterNotifier, TextEditingController>(
            builder: (context, emailController, child) {
              return CommonTextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                width: dropdownWidth,
                hintText: AppConstants.sampleMail,
                hintStyle: hintStyle(context),
                validatorEmptyErrorText: AppConstants.emailIsRequired,
                isEmailValidator: true,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                      RegExp("[ A-Za-z0-9_@./#&+-]")),
                ],
              );
            },
            selector: (buildContext, registerNotifier) =>
                registerNotifier.emailController),
        commonSizedBoxHeight20(context),
        buildHeading(context, title: S.of(context).mobileNumberWeb),
        commonSizedBoxHeight10(context),
        Selector<RegisterNotifier, TextEditingController>(
            builder: (context, mobileNumberController, child) {
              return CommonTextField(
                controller: mobileNumberController,
                keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
                width: dropdownWidth,
                prefixIcon: Wrap(
                  children: [
                    Padding(
                      padding: px1topandLeftDimenIcon(context),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: hanBlueTint100,
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.zero)),
                        height: AppConstants.fortyFive,
                        width: 108,
                        child: Row(
                          children: [
                            commonSizedBoxWidth20(context),
                            Image.asset(AppImages.singaporeFlag,
                                height: kIsWeb ? getScreenHeight(context) * 0.025 : screenSizeHeight * 0.025),
                            commonSizedBoxWidth20(context),
                            buildText(
                                text: singapore,
                                fontSize: AppConstants.sixteen),
                          ],
                        ),
                      ),
                    ),
                    commonSizedBoxWidth40(context),
                  ],
                ),
                validatorEmptyErrorText: mobileRequired,
                isMobileNumberValidator: true,
                maxLength: 8,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
              );
            },
            selector: (buildContext, registerNotifier) =>
                registerNotifier.mobileNumberController)
      ],
    );
  }

  Widget buildAddressText(BuildContext context) {
    return buildText(
        text: S.of(context).address,
        fontSize: AppConstants.sixteen,
        fontWeight: FontWeight.w600);
  }

  Widget buildAddressInfoText(BuildContext context) {
    return Container(
        width: dropdownWidth,
      child: buildText(
          text: S.of(context).simplyenteryourpostalcode,
          fontColor: oxfordBlueTint400,
          fontWeight: AppFont.fontWeightRegular),
    );
  }

  Widget buildPostalCode(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Row(
      children: [
        Selector<RegisterNotifier, TextEditingController>(
            builder: (context, postalCodeController, child) {
              return CommonTextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
                controller: postalCodeController,
                onChanged: (val) {
                  registerNotifier.postCodeMessage = '';
                },
                containerColor: Colors.transparent,
                width: kIsWeb ? isMobile(context)
                    ? getScreenWidth(context) * 0.39
                    : isTab(context)
                        ? getScreenWidth(context) * 0.29
                        : getScreenWidth(context) * 0.22 : isMobileSDK(context)
                    ? screenSizeWidth * 0.39
                    : isTabSDK(context)
                    ? screenSizeWidth * 0.29
                    : screenSizeWidth * 0.22,
                hintText: egAddress,
                helperText: '',
                hintStyle: hintStyle(context),
                validatorEmptyErrorText: postalCodeisRequired,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                    RegExp("[0-9]"),
                  ),
                ],
              );
            },
            selector: (buildContext, registerNotifier) =>
                registerNotifier.postalCodeController),
        commonSizedBoxWidth20(context),
        Column(
          children: [
            buildButton(context,
                width: kIsWeb ? isMobile(context)
                    ? getScreenWidth(context) * 0.39
                    : isTab(context)
                    ? getScreenWidth(context) * 0.29
                    : getScreenWidth(context) * 0.22 : isMobileSDK(context)
                    ? screenSizeWidth * 0.39
                    : isTabSDK(context)
                    ? screenSizeWidth * 0.29
                    : screenSizeWidth * 0.22,
                height: 50, onPressed: () {
                  registerNotifier.postalCodeController.text.isEmpty ? null :
              registerNotifier.getSGPostCodeAddress(
                  registerNotifier.postalCodeController.text);
            },
                color: hanBlueTint200,
                name: S.of(context).getAddressWeb,
                fontSize: AppConstants.sixteen,
                fontWeight: AppFont.fontWeightBold,
                fontColor: hanBlueshades600),
            SizedBox(
              height: AppConstants.twentyTwo,
            )
          ],
        ),
      ],
    );
  }

  Widget buildUnitAndBlockNo(
      RegisterNotifier registerNotifier, BuildContext context) {
    return commonRowField(
      context,
      header1: S.of(context).unitNoWeb,
      header2: S.of(context).blockNoWeb,
      controller1: registerNotifier.unitNoController,
      controller2: registerNotifier.blockNoController,
      hintText1: eg20,
      hintText2: eg20,
      validationRequired1: unitNumberIsRequired,
      validationRequired2: blockNumberIsrequired,
      validationLength1: enterValidNumber,
      validationLength2: enterValidNumber,
      inputFormat: "[ A-Za-z0-9_@./#&+-]",
      keyboardType1: TextInputType.text,
      keyboardType2: TextInputType.text,
      isMinimumLength1: false,
      isMinimumLength2: false,
    );
  }

  Widget buildStreetAndBuildingName(
      RegisterNotifier registerNotifier, BuildContext context) {
    return commonRowField(context,
        header1: S.of(context).streetNameWeb,
        header2: S.of(context).buildingNameWeb,
        controller1: registerNotifier.streetNameController,
        controller2: registerNotifier.buildingNameController,
        hintText1: streetName,
        hintText2: "Enter NA if not applicable",
        validationRequired1: streetNameIsRequired,
        validationRequired2: buildingNameIsRequired,
        isMinimumLength1: false,
        isMinimumLength2: false,inputFormatValid: false,
        validationLength1: AppConstants.enterValidName,
        validationLength2: AppConstants.enterValidName);
  }

  Widget buildEmployerNameText(BuildContext context) {
    return buildText(
        text: S.of(context).employerNameWeb,
        fontSize: AppConstants.sixteen,
        fontWeight: AppFont.fontWeightSemiBold);
  }

  Widget buildEmployerNameInfo(BuildContext context) {
    return Container(
      width: dropdownWidth,
      child: buildText(
          text: S.of(context).employerNameToVerify,
          fontColor: oxfordBlueTint400,
          fontWeight: AppFont.fontWeightRegular),
    );
  }

  Widget buildEmployerTextField(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Selector<RegisterNotifier, TextEditingController>(
        builder: (context, employerNameController, child) {
          return CommonTextField(
              controller: employerNameController,
              hintText: S.of(context).employerName,
              hintStyle: hintStyle(context),
              validatorEmptyErrorText: employerNameIsRequired,
              width: dropdownWidth);
        },
        selector: (buildContext, registerNotifier) =>
            registerNotifier.employerNameController);
  }

  Widget buildOtherOcuupationTextField(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Selector<RegisterNotifier, TextEditingController>(
        builder: (context, occupationOthersController, child) {
          return CommonTextField(
              controller: occupationOthersController,
              hintText: "Enter Other Occupation",
              hintStyle: hintStyle(context),
              validatorEmptyErrorText: otherOccupationIsRequired,
              width: dropdownWidth);
        },
        selector: (buildContext, registerNotifier) =>
            registerNotifier.occupationOthersController);
  }

  Widget buildOccupationText(BuildContext context) {
    return buildText(
        text: S.of(context).occupation,
        fontSize: AppConstants.sixteen,
        fontWeight: AppFont.fontWeightSemiBold);
  }

  Widget buildOccupationInfoText(BuildContext context) {
    return Container(
      width: dropdownWidth,
      child: buildText(
          text: S.of(context).selectTheFieldOrIndustry,
          fontColor: oxfordBlueTint400,
          fontWeight: AppFont.fontWeightRegular),
    );
  }

  Widget buildOccupationDropdownBox(
      BuildContext context, RegisterNotifier registerNotifier) {
    registerNotifier.occupationListData.sort();
    return CustomizeDropdown(
      context,
      validation: (value) {
        if (value == null || value.isEmpty) {
          return 'Occupation field is required';
        }
        return null;
      },
      dropdownItems: registerNotifier.occupationListData,
      controller: registerNotifier.occupationController,
      width: dropdownWidth,
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected onSelected, Iterable options) {
        return buildDropDownContainer(
          context,
          options: options,
          onSelected: onSelected,
          dropdownData: registerNotifier.occupationListData,
          dropDownWidth: dropdownWidth,
          dropDownHeight: options.first == S.of(context).noDataFound
              ? 150
              : options.length < 5
                  ? options.length * 50
                  : 300,
        );
      },
      onSelected: (val) {
        registerNotifier.selectedOccupation = val!;
      },
      onSubmitted: (val) {
        registerNotifier.selectedOccupation = val!;
      },
    );
  }

  Widget buildOccupationOthersField(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Selector<RegisterNotifier, TextEditingController>(
        builder: (context, occupationOthersController, child) {
          return CommonTextField(
            width: dropdownWidth,
            hintStyle: hintStyle(context),
            controller: occupationOthersController,
            keyboardType: TextInputType.text,
          );
        },
        selector: (buildContext, registerNotifier) =>
        registerNotifier.occupationOthersController);
  }

  Widget buildReferralCodeText(BuildContext context) {
    return buildText(
        text: S.of(context).referralCode,
        fontSize: AppConstants.sixteen,
        fontWeight: AppFont.fontWeightSemiBold);
  }

  Widget buildReferralCodeInfoText(BuildContext context) {
    return buildText(
      text: S.of(context).anyReferralcodeFromFriend,
      fontColor: oxfordBlueTint400,
      fontWeight: AppFont.fontWeightRegular,
    );
  }

  Widget buildReferralCodeTextField(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Selector<RegisterNotifier, TextEditingController>(
        builder: (context, enterPromoCodeController, child) {
          return CommonTextField(
            controller: enterPromoCodeController,
            width: dropdownWidth,
            hintText: S.of(context).enterTheCode,
            hintStyle: hintStyle(context),
          );
        },
        selector: (buildContext, registerNotifier) =>
            registerNotifier.enterPromoCodeController);
  }

  Widget buildHeading(BuildContext context, {title}) {
    return buildText(
        text: title,
        fontSize: AppConstants.sixteen,
        fontColor: oxfordBlueTint500);
  }

  Widget buildButtons(RegisterNotifier registerNotifier, BuildContext context) {
    var buttonWidth = kIsWeb ? isMobile(context)
        ? getScreenWidth(context) * 0.39
        : isTab(context)
        ? getScreenWidth(context) * 0.29
        : getScreenWidth(context) * 0.22 : isMobileSDK(context)
        ? screenSizeWidth * 0.39
        : isTabSDK(context)
        ? screenSizeWidth * 0.29
        : screenSizeWidth * 0.22;
    return commonBackAndContinueButton(
      context,
      backWidth: buttonWidth,
      continueWidth: buttonWidth,
      widthBetween: kIsWeb ? getScreenWidth(context) * 0.02 : screenSizeWidth * 0.02,
      onPressedBack: () async {
        await SharedPreferencesMobileWeb.instance
            .getCountry(country)
            .then((value) async {
          Navigator.pushNamed(context, registerMethodRoute);
        });
      },
      onPressedContinue: () async{
        if (registerNotifier.personalDetailFormKey.currentState!.validate()) {
          Provider.of<CommonNotifier>(context, listen: false)
              .updateUserVerifiedBool = false;
          SharedPreferencesMobileWeb.instance.setUserVerified(false);
          ContactRepository()
              .apiPersonalDetailsSG(
                  PersonalDetailsRequestSg(
                      salutation: registerNotifier.isRegistrationSelected ? registerNotifier.salutationController.text : "",
                      firstName: registerNotifier.firstNameController.text,
                      middleName: registerNotifier.middleNameController.text,
                      lastName: registerNotifier.lastNameController.text,
                      city: registerNotifier.cityController.text,
                      employerName:
                          registerNotifier.employerNameController.text,
                      phoneNumber: registerNotifier.mobileNumberController.text,
                      promoCode: registerNotifier.enterPromoCodeController.text,
                      blockNo: registerNotifier.blockNoController.text.isEmpty ? "NA" : registerNotifier.blockNoController.text,
                      buildingName: registerNotifier.isJohorAddress == true ? registerNotifier.buildingNameJohorController.text :
                          registerNotifier.buildingNameController.text,
                      occupationOthers:
                          registerNotifier.occupationOthersController.text,
                      postalCode: registerNotifier.isJohorAddress == true ? registerNotifier.postalCodeJohorController.text : registerNotifier.postalCodeController.text,
                      state: registerNotifier.stateController.text,
                      streetName: registerNotifier.streetNameController.text.isEmpty ? "NA" : registerNotifier.streetNameController.text,
                      unitNo: registerNotifier.isJohorAddress == true ? registerNotifier.noController.text : registerNotifier.unitNoController.text,
                      residentStatus: registerNotifier.residenceIdStr,
                      occupation: registerNotifier.selectedOccupation),
                  context)
              .then((value) async {
            PersonalDetailsResponseSg? personalDetailsResponseSg;
            if (value.runtimeType != String) {
              personalDetailsResponseSg = value as PersonalDetailsResponseSg;
            }
            if (personalDetailsResponseSg?.success == true) {
              await registerNotifier.getAuthStatus(context);
            } else {
              if (value.runtimeType == String) {
                registerNotifier.addErrorList(value as String);
              } else {
                registerNotifier.errorList = value as List;
              }
            }
          });
          SharedPreferencesMobileWeb.instance.setResidentStatus(
              AppConstants.residentStatusSata, registerNotifier.residentStatus!);
        } else {
          registerNotifier.isError = !registerNotifier.isError;
        }
      },
    );
  }

  Widget buildJohorAddressField(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildAddressInfoText(context),
        commonSizedBoxHeight30(context),
        buildHeading(context, title: S.of(context).postalCodeWeb),
        commonSizedBoxHeight10(context),
        buildPostalCode(registerNotifier, context),
        Visibility(
            child: Text(
              registerNotifier.postCodeMessage,
              style: TextStyle(color: errorTextField,
                  fontSize: 11.5,fontWeight: FontWeight.w500),
            ),
            visible: registerNotifier.postCodeMessage != ""),
        Visibility(
            child: sizedBoxHeight10(context),
            visible: registerNotifier.postCodeMessage != ""),
        Visibility(
            child: commonSizedBoxHeight20(context),
            visible: registerNotifier.isError),
        buildUnitAndBlockNo(registerNotifier, context),
        Visibility(
            child: commonSizedBoxHeight20(context),
            visible: registerNotifier.isError),
        buildStreetAndBuildingName(registerNotifier, context),
      ],
    );
  }

  Widget buildSingaporeAddressField(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.only(right: kIsWeb ? getScreenWidth(context) * 0.04 : screenSizeWidth * 0.04),
            child: buildText(
                text: S.of(context).resideInJohorEnterYourAddressBelow,
                fontColor: oxfordBlueTint400,
                fontWeight: FontWeight.w400)),
        commonSizedBoxHeight30(context),
        buildHeading(context, title: No),
        commonSizedBoxHeight10(context),
        Selector<RegisterNotifier, TextEditingController>(
            builder: (context, noController, child) {
              return CommonTextField(
                width: dropdownWidth,
                hintStyle: hintStyle(context),
                hintText: S.of(context).HouseLotNumberFloor,
                controller: noController,
                keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
                validatorEmptyErrorText: houseLotNumberFloorIsRequired,
              );
            },
            selector: (buildContext, registerNotifier) =>
                registerNotifier.noController),
        commonSizedBoxHeight25(context),
        buildHeading(context, title: S.of(context).buildingName),
        commonSizedBoxHeight10(context),
        Selector<RegisterNotifier, TextEditingController>(
            builder: (context, buildingNameJohorController, child) {
              return CommonTextField(
                width: dropdownWidth,
                hintText: S.of(context).buildingName,
                hintStyle: hintStyle(context),
                controller: buildingNameJohorController,
                validatorEmptyErrorText: buildingNameIsRequired,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 ]")),
                ],
              );
            },
            selector: (buildContext, registerNotifier) =>
                registerNotifier.buildingNameJohorController),
        commonSizedBoxHeight25(context),
        buildHeading(context, title: S.of(context).postalCode),
        commonSizedBoxHeight10(context),
        Selector<RegisterNotifier, TextEditingController>(
            builder: (context, postalCodeJohorController, child) {
              return CommonTextField(
                width: dropdownWidth,
                hintText: S.of(context).postalCode,
                hintStyle: hintStyle(context),
                controller: postalCodeJohorController,
                keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
                validatorEmptyErrorText: postalCodeisRequired,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
              );
            },
            selector: (buildContext, registerNotifier) =>
                registerNotifier.postalCodeJohorController),
        Visibility(
            child: Text(
              registerNotifier.postCodeMessage,
              style: errorMessageStyle(context),
            ),
            visible: registerNotifier.postCodeMessage != ""),
        commonSizedBoxHeight25(context),
        buildHeading(context, title: S.of(context).city),
        commonSizedBoxHeight10(context),
        CommonTextField(
          width: dropdownWidth,
          hintText: S.of(context).cityName,
          hintStyle: hintStyle(context),
          controller: registerNotifier.cityController,
          validatorEmptyErrorText: cityIsRequired,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 ]")),
          ],
        ),
        commonSizedBoxHeight25(context),
        buildHeading(context, title: state),
        commonSizedBoxHeight10(context),
        Selector<RegisterNotifier, TextEditingController>(
            builder: (context, stateController, child) {
              return CommonTextField(readOnly: true,
                width: dropdownWidth,
                controller: stateController,
              );
            },
            selector: (buildContext, registerNotifier) =>
                registerNotifier.stateController),
        commonSizedBoxHeight10(context),
        Container(
          width: dropdownWidth,
          child: Text.rich(TextSpan(
            children: [
              TextSpan(
                text: S.of(context).residentialAddressInSingapore,
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w400, color: black),
              ),
              TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      registerNotifier.isJohorAddress = false;
                      registerNotifier.stateController.clear();
                    },
                  text: S.of(context).here,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: orangePantone)),
            ],
          )),
        ),
      ],
    );
  }

  Widget commonRowField(
    BuildContext context, {
    header1,
    header2,
    controller1,
    controller2,
    hintText1,
    hintText2,
    validationRequired1,
    validationLength1,
    validationRequired2,
    validationLength2,
    inputFormat,
    bool? inputFormatValid,
    keyboardType1,
    keyboardType2,
    isMinimumLength1,
    isMinimumLength2,
  }) {
    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: kIsWeb ? getScreenWidth(context) < 570 ? 5 : 0 : screenSizeWidth < 570 ? 5 : 0,
            runSpacing: 5,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeading(context, title: header1),
                  commonSizedBoxHeight10(context),
                  CommonTextField(
                    controller: controller1,
                    helperText: '',
                    keyboardType: keyboardType1 ?? TextInputType.text,
                    width: kIsWeb ?  isMobile(context)
                        ? getScreenWidth(context) * 0.80
                        : isTab(context)
                            ? getScreenWidth(context) * 0.29
                            : getScreenWidth(context) * 0.22 : isMobileSDK(context)
                        ? screenSizeWidth * 0.80
                        : isTabSDK(context)
                        ? screenSizeWidth * 0.29
                        : screenSizeWidth * 0.22,
                    hintText: hintText1,
                    hintStyle: hintStyle(context),
                    validatorEmptyErrorText: validationRequired1,
                    minLengthErrorText: validationLength1,
                    inputFormatters: inputFormatValid == false?null:<TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(inputFormat ?? "[a-zA-Z ]")),
                    ],
                  )
                ],
              ),
              commonSizedBoxWidth20(context),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeading(context, title: header2),
                  commonSizedBoxHeight10(context),
                  CommonTextField(
                    controller: controller2,
                    width: kIsWeb ? isMobile(context)
                        ? getScreenWidth(context) * 0.80
                        : isTab(context)
                            ? getScreenWidth(context) * 0.29
                            : getScreenWidth(context) * 0.22 :  isMobileSDK(context)
                        ? screenSizeWidth * 0.80
                        : isTabSDK(context)
                        ? screenSizeWidth * 0.29
                        : screenSizeWidth * 0.22,
                    hintText: hintText2,
                    helperText: '',
                    keyboardType: keyboardType2 ?? TextInputType.name,
                    hintStyle: hintStyle(context),
                    validatorEmptyErrorText: validationRequired2,
                    minLengthErrorText: validationLength2,
                    inputFormatters: inputFormatValid == false?null:<TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(inputFormat ?? "[a-zA-Z ]")),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
