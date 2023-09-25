import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/models/request_response/australia/personal_details/search_address_response.dart';
import 'package:singx/core/notifier/register_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_font.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

var dropdownWidth;

class PersonalDetailHkAusScreen extends StatelessWidget {
  const PersonalDetailHkAusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          RegisterNotifier(context, from: AustraliaName),
      child: Consumer<RegisterNotifier>(
        builder: (context, registerNotifier, _) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) {
              registerNotifier.selectedCountry = value;
            });
          });
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
              body: Stack(
                children: [
                  Scrollbar(
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
                              commonSizedBoxHeight50(context),
                              Visibility(
                                visible: registerNotifier.selectedCountry == AustraliaName,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      buildCompleteThisApplicationText(context),
                                      commonSizedBoxHeight20(context),
                                    ]),
                              ),
                              buildHeaderText(context),
                              commonSizedBoxHeight20(context),
                              buildSubHeaderText(context),
                              commonSizedBoxHeight40(context),
                              buildSalutationText(context),
                              commonSizedBoxHeight10(context),
                              buildSalutationDropDownBox(
                                  context, registerNotifier),
                              commonSizedBoxHeight20(context),
                              buildHeading(context,
                                  title: S.of(context).firstNameWeb),
                              commonSizedBoxHeight10(context),
                              buildFirstName(registerNotifier, context),
                              commonSizedBoxHeight20(context),
                              buildHeading(context,
                                  title: S.of(context).middleName),
                              commonSizedBoxHeight10(context),
                              buildMiddleName(registerNotifier, context),
                              commonSizedBoxHeight20(context),
                              buildHeading(context,
                                  title: S.of(context).lastNameWeb),
                              commonSizedBoxHeight10(context),
                              buildLastName(registerNotifier, context),
                              commonSizedBoxHeight20(context),
                              kIsWeb
                                  ? isTab(context) ||
                                          getScreenWidth(context) < 1100
                                      ? buildDOBAndNationality(
                                          registerNotifier, context)
                                      : buildDOBAndNationalityTab(
                                          registerNotifier, context)
                                  : isTabSDK(context) || screenSizeWidth < 1100
                                      ? buildDOBAndNationality(
                                          registerNotifier, context)
                                      : buildDOBAndNationalityTab(
                                          registerNotifier, context),
                              commonSizedBoxHeight20(context),
                              buildHeading(context,
                                  title: S.of(context).esidenceStatus),
                              commonSizedBoxHeight10(context),
                              buildResidenceDropDownBox(
                                  registerNotifier, context),
                              commonSizedBoxHeight20(context),
                              buildAddressText(context),
                              commonSizedBoxHeight10(context),
                              Visibility(visible: registerNotifier.selectedCountry != AustraliaName,child: flatAndFloorNo(registerNotifier, context)),
                              Visibility(visible: registerNotifier.selectedCountry != AustraliaName,child: commonSizedBoxHeight20(context),),
                              if(registerNotifier.selectedCountry !=AppConstants.australia)buildAddressInfoText(context),
                              Visibility(visible: registerNotifier.selectedCountry != AustraliaName,child: commonSizedBoxHeight30(context)),
                              Visibility(
                                  visible: registerNotifier.selectedCountry ==
                                      AustraliaName,
                                  child: registerNotifier.isManualSearch == true
                                      ? buildManualAddressField(
                                          registerNotifier, context)
                                      : buildAutomaticAddressField(
                                          registerNotifier, context)),
                              Visibility(visible: registerNotifier.selectedCountry == AustraliaName,child: commonSizedBoxHeight10(context),),
                              Visibility(visible: registerNotifier.selectedCountry == AustraliaName,child: buildLinkTextAus(registerNotifier, context)),
                              Visibility(visible: registerNotifier.selectedCountry != AustraliaName,child: buildJohorAddressField(
                                  registerNotifier, context)),
                              commonSizedBoxHeight20(context),
                              Visibility(visible: registerNotifier.selectedCountry != AustraliaName,child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildHeading(context, title: S.of(context).nameOfVillageTown),
                                  commonSizedBoxHeight10(context),
                                  nameOFVillage(registerNotifier, context),
                                  commonSizedBoxHeight20(context),
                                  buildHeading(context, title: "Region"),
                                  commonSizedBoxHeight10(context),
                                  countryDropDown(context, registerNotifier),
                                ],
                              )),
                              commonSizedBoxHeight20(context),
                              buildOccupationText(context),
                              commonSizedBoxHeight10(context),
                              buildOccupationInfoText(context),
                              commonSizedBoxHeight12(context),
                              buildOccupationDropdownBox(
                                  registerNotifier, context),
                              commonSizedBoxHeight20(context),
                              Visibility(
                                visible: registerNotifier.selectedOccupation == "Others",
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      buildHeading(context, title: "Others"),
                                      commonSizedBoxHeight10(context),
                                      buildOccupationOthersField(registerNotifier, context)
                                    ]),
                              ),
                              registerNotifier.selectedCountry ==
                                  AppConstants.australia
                                  ? commonSizedBoxHeight20(context)
                                  : commonSizedBoxHeight45(context),
                              Visibility(
                                visible: registerNotifier.selectedCountry == AustraliaName,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      buildHeading(context, title: S.of(context).employerNameWeb),
                                      commonSizedBoxHeight10(context),
                                      employerNameField(context, registerNotifier),
                                      commonSizedBoxHeight20(context),
                                    ]),
                              ),
                              Visibility(
                                  visible:
                                      registerNotifier.selectedCountry ==
                                          AustraliaName,
                                  child: buildHeading(context,
                                      title: registerNotifier.selectedCountry ==
                                              AppConstants.australia
                                          ? S.of(context).estimatedAnnualIncome
                                          : S
                                              .of(context)
                                              .estimatedTransactionAmount)),
                              Visibility(
                                visible: registerNotifier.selectedCountry == AustraliaName,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      commonSizedBoxHeight10(context),
                                      estimatedAnnualAmount(context, registerNotifier),
                                      commonSizedBoxHeight45(context),
                                    ]),
                              ),
                              buildReferralCodeText(context),
                              commonSizedBoxHeight10(context),
                              buildReferralCodeInfoText(context),
                              commonSizedBoxHeight12(context),
                              buildReferralCodeTextField(
                                  registerNotifier, context),
                              commonSizedBoxHeight50(context),
                              Visibility(visible: registerNotifier.selectedCountry == AustraliaName,child: buildRadioButtons(context, registerNotifier)),
                              Visibility(visible: registerNotifier.selectedCountry == AustraliaName,child: commonSizedBoxHeight20(context),),
                              Visibility(
                                  visible:
                                      registerNotifier.isVerificationRadioTile,
                                  child: buildText(
                                      text: S
                                          .of(context)
                                          .pleaseSelectTheVerificationOption,
                                      fontColor: error,
                                      fontWeight: AppFont.fontWeightMedium,
                                      fontSize: 15)),
                              Visibility(visible: registerNotifier.selectedCountry == AustraliaName,child: commonSizedBoxHeight50(context),),
                              buildButtons(registerNotifier, context),
                              commonSizedBoxHeight100(context),
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

  Widget buildHeaderText(BuildContext context) {
    return buildText(
        text: S.of(context).personalDetailsWeb,
        fontSize: AppConstants.twenty,
        fontColor: oxfordBlue,
        fontWeight: FontWeight.w700);
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

  Widget buildLinkTextAus(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: S.of(context).cantFindYourAddress,
                  style: topupAboutSubHeading(context),
                ),
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => registerNotifier.isManualSearch == true
                        ? registerNotifier.isManualSearch = false
                        : registerNotifier.isManualSearch = true,
                  text: registerNotifier.isManualSearch
                      ? S.of(context).userAutomaticSearch
                      : S.of(context).enterManually,
                  style: topupAboutSubHeadingOrange(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
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
    return CustomizeDropdown(context,
        validation: (value) {
          if (value == null || value.isEmpty) {
            return 'Salutation is required';
          }
          return null;
        },
        dropdownItems: registerNotifier.salutationListData,
        controller: registerNotifier.salutationController,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[A_Z a-z]")),
        ],
        width: dropdownWidth, optionsViewBuilder:
            (BuildContext context, AutocompleteOnSelected onSelected,
                Iterable options) {
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
    }, onSelected: (val) {
      registerNotifier.salutationStr = val!;
    }, onSubmitted: (val) {
      registerNotifier.salutationStr = val!;
    });
  }

  Widget estimatedAnnualAmount(
      BuildContext context, RegisterNotifier registerNotifier) {
    return CustomizeDropdown(
      context,
      dropdownItems: registerNotifier.annualIncomeListData,
      hintText: "Select Income (Optional)",
      controller: registerNotifier.annualIncomeController,
      width: dropdownWidth,
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected onSelected, Iterable options) {
        return buildDropDownContainer(
          context,
          options: options,
          onSelected: onSelected,
          dropdownData: registerNotifier.annualIncomeListData,
          dropDownWidth: dropdownWidth,
          dropDownHeight: options.first == S.of(context).noDataFound
              ? 150
              : options.length < 4
                  ? options.length * 50
                  : 200,
        );
      },
      validation: (val){
        {return null;}
      },
      onSelected: (val) {
        registerNotifier.estimatedTxnAmountStr = val!;
      },
      onSubmitted: (val) {
        registerNotifier.estimatedTxnAmountStr = val!;
      },
    );
  }

  Widget buildManualAddressField(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildUnitAndBlockNo(registerNotifier, context),
        commonSizedBoxHeight20(context),
        buildStreetAndBuildingName(registerNotifier, context),
        commonSizedBoxHeight20(context),
        buildCityAndState(registerNotifier, context),
        commonSizedBoxHeight20(context),
        buildHeading(context, title: S.of(context).postalCodeWeb),
        commonSizedBoxHeight20(context),
        buildPostalCode(registerNotifier, context),
      ],
    );
  }

  Widget buildStreetAndBuildingName(
      RegisterNotifier registerNotifier, BuildContext context) {
    return commonRowField(context,
        header1: S.of(context).streetNameWeb,
        header2: S.of(context).suburb,
        controller1: registerNotifier.streetNameController,
        controller2: registerNotifier.buildingNameController,
        // hintText1: streetName,
        // hintText2: suburbName,
        inputFormat1: "[a-zA-Z 0-9]",
        inputFormat2: "[a-zA-Z 0-9]", 
        //validationRequired1: 'Street Name is required',
      //  validationRequired2: 'Suburb is required',
        validationLength1: AppConstants.enterValidName,
        validationLength2: AppConstants.enterValidName);
  }

  Widget buildUnitAndBlockNo(
      RegisterNotifier registerNotifier, BuildContext context) {
    return commonRowField(context,
        header1: S.of(context).unitNoWeb,
        header2: S.of(context).streetNumber,
        controller1: registerNotifier.unitNoController,
        controller2: registerNotifier.blockNoController,
        hintText1: S.of(context).ifApplicable,
        //validationRequired2: 'Street no is required',
        validationLength1: enterValidNumber,
        validationLength2: enterValidNumber,
        inputFormat1: "[a-zA-Z 0-9]",
        inputFormat2: "[a-zA-Z 0-9]",
        keyboardType1: TextInputType.numberWithOptions(decimal: true,signed: true),
        keyboardType2: TextInputType.numberWithOptions(decimal: true,signed: true));
  }

  Widget buildCityAndState(
      RegisterNotifier registerNotifier, BuildContext context) {
    return kIsWeb ? getScreenWidth(context) > 570
        ? buildCityAndStateGreaterThan570(registerNotifier,context)
        : buildCityAndStateLessThan570(registerNotifier,context) :  screenSizeWidth > 570
        ? buildCityAndStateGreaterThan570(registerNotifier,context)
        : buildCityAndStateLessThan570(registerNotifier,context);
  }

  Widget buildCityAndStateGreaterThan570(RegisterNotifier registerNotifier, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeading(context, title: S.of(context).city),
            commonSizedBoxHeight10(context),
            Selector<RegisterNotifier, TextEditingController>(
                builder: (context, cityController, child) {
                  return CommonTextField(
                    keyboardType: TextInputType.text,
                    controller: cityController,
                    width: kIsWeb ?  isMobile(context)
                        ? getScreenWidth(context) * 0.80
                        : isTab(context)
                        ? getScreenWidth(context) * 0.29
                        : getScreenWidth(context) * 0.22 : isMobileSDK(context)
                        ? screenSizeWidth * 0.80
                        : isTabSDK(context)
                        ? screenSizeWidth * 0.29
                        : screenSizeWidth * 0.22,
                    //hintText: enterCity,
                    helperText: '',
                    hintStyle: hintStyle(context),
                    validatorEmptyErrorText: cityIsRequired,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                        RegExp("[a-zA-Z ]"),
                      ),
                    ],
                  );
                },
                selector: (buildContext, registerNotifier) =>
                registerNotifier.cityController),
          ],
        ),
        commonSizedBoxWidth20(context),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeading(context, title: S.of(context).stateProvince),
            commonSizedBoxHeight10(context),
            buildStateAndProvinceDropdown(context, registerNotifier),
          ],
        )
      ],
    );
  }

  Widget buildCityAndStateLessThan570(RegisterNotifier registerNotifier, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeading(context, title: S.of(context).city),
                commonSizedBoxHeight10(context),
                Selector<RegisterNotifier, TextEditingController>(
                    builder: (context, cityController, child) {
                      return CommonTextField(
                        keyboardType: TextInputType.text,
                        controller: cityController,
                        width: kIsWeb ?  isMobile(context)
                            ? getScreenWidth(context) * 0.80
                            : isTab(context)
                            ? getScreenWidth(context) * 0.29
                            : getScreenWidth(context) * 0.22 : isMobileSDK(context)
                            ? screenSizeWidth * 0.80
                            : isTabSDK(context)
                            ? screenSizeWidth * 0.29
                            : screenSizeWidth * 0.22,
                        //hintText: enterCity,
                        helperText: '',
                        hintStyle: hintStyle(context),
                        validatorEmptyErrorText: cityIsRequired,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                            RegExp("[a-zA-Z ]"),
                          ),
                        ],
                      );
                    },
                    selector: (buildContext, registerNotifier) =>
                    registerNotifier.cityController),
              ],
            ),
          ],
        ),
        commonSizedBoxHeight20(context),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeading(context, title: S.of(context).stateProvince),
            commonSizedBoxHeight10(context),
            buildStateAndProvinceDropdown(context, registerNotifier),
          ],
        )
      ],
    );
  }

  Widget buildAutomaticAddressField(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonSizedBoxHeight10(context),
        Container(
          width: dropdownWidth,

          child: Autocomplete<SearchAddressResponse>(
            optionsBuilder: (TextEditingValue textEditingValue) async {
              if(registerNotifier.searchAddressController.text.isEmpty) return[];
              await registerNotifier.getSuggestedAddress(registerNotifier.searchAddressController.text);
              return registerNotifier.addressSuggestion
                  .where((SearchAddressResponse address) => address.description
                  .toLowerCase()
                  .startsWith(registerNotifier.searchAddressController.text.toLowerCase()))
                  .toList();;
            },
            displayStringForOption: (SearchAddressResponse option) =>
                option.description,
            fieldViewBuilder: (BuildContext context,
                TextEditingController fieldTextEditingController,
                FocusNode fieldFocusNode,
                VoidCallback onFieldSubmitted) {
              return TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Address is required";
                  }
                },
                controller: registerNotifier.searchAddressController,
                focusNode: fieldFocusNode,
                decoration: InputDecoration(
                  hintText: S.of(context).searchAddress,
                  hintStyle: hintStyle(context),errorStyle: TextStyle(color: errorTextField,
                    fontSize: 11.5,fontWeight: FontWeight.w500),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: errorTextField),
                      borderRadius: BorderRadius.circular(5)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: errorTextField),
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: hanBlueTint500),
                      borderRadius: BorderRadius.circular(5)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: fieldBorderColorNew)),
                  fillColor: Colors.white,
                  filled: true,
                  hoverColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) async{
                  handleInteraction(context);
                  fieldTextEditingController.text = val;
                  registerNotifier.getSuggestedAddress(registerNotifier.searchAddressController.text);
                },
                style: const TextStyle(fontWeight: FontWeight.normal),
              );
            },
            onSelected: (SearchAddressResponse selection) {
              registerNotifier.getAddressDetails(selection.placeId);
            },
            optionsViewBuilder: (BuildContext context,
                AutocompleteOnSelected<SearchAddressResponse> onSelected,
                Iterable<SearchAddressResponse> options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  child: Container(
                    width: dropdownWidth,
                    height: 270,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38),
                        color: Colors.white),
                    child: ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final SearchAddressResponse option =
                            options.elementAt(index);

                        return GestureDetector(
                          onTap: () {
                            onSelected(option);
                            registerNotifier.searchAddressController.text =
                                option.description;
                          },
                          child: ListTile(
                            leading: Icon(
                              Icons.location_on_rounded,
                              color: greyColor,
                            ),
                            title: Text(option.description,
                                style: const TextStyle(color: Colors.black)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        commonSizedBoxHeight25(context),
        buildHeading(context, title: S.of(context).unitNo),
        commonSizedBoxHeight10(context),
        Selector<RegisterNotifier, TextEditingController>(
            builder: (context, unitNoController, child) {
              return CommonTextField(
                width: dropdownWidth,
                hintText: S.of(context).ifApplicable,
                hintStyle: hintStyle(context),
                controller: unitNoController,
                keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
                // inputFormatters: <TextInputFormatter>[
                //   FilteringTextInputFormatter.allow(RegExp("[a-zA-Z 0-9]")),
                // ],
              );
            },
            selector: (buildContext, registerNotifier) =>
                registerNotifier.unitNoController),
        commonSizedBoxHeight10(context),
      ],
    );
  }

  Widget employerNameField(
      BuildContext context, RegisterNotifier registerNotifier) {
    return Selector<RegisterNotifier, TextEditingController>(
        builder: (context, employerNameController, child) {
          return CommonTextField(
            controller: employerNameController,
            hintText: "(Optional)",
            hintStyle: hintStyle(context),
            // inputFormatters: <TextInputFormatter>[
            //   FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
            // ],
            width: dropdownWidth,
          );
        },
        selector: (buildContext, registerNotifier) =>
            registerNotifier.employerNameController);
  }

  Widget buildResidenceDropDownBox(
      RegisterNotifier registerNotifier, BuildContext context) {
    return (registerNotifier.selectedCountry == AppConstants.hongKong &&
                registerNotifier.selectedNationality ==
                    AppConstants.hongKong) ||
            registerNotifier.selectedCountry == AppConstants.australia &&
                registerNotifier.selectedNationality == AppConstants.australia
        ? CommonDropDownField(
            items: registerNotifier.selectedCountry == AustraliaName
                ? ((registerNotifier.selectedNationality == "Australia" || registerNotifier.selectedNationality == null) ?registerNotifier.residenceType :registerNotifier.residenceTypeCitizen)
                : AppConstants.residenceStatusData,
            onChanged: (val) {
              registerNotifier.residenceIdStr = val!;
            },
            disable: false,
            selectedItem: "Citizen",

            hintText: S.of(context).chooseAnOption,
            hintStyle: hintStyle(context),
            width: dropdownWidth,
            color:Colors.grey.shade200,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: fieldBorderColorNew),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: fieldBorderColorNew),
            ),
          )
        :  Visibility(
          visible: registerNotifier.isResidenceStatus,
          child: CustomizeDropdown(context,
      validation: (value) {
          if (value == null || value.isEmpty) {
            return 'Residence Status is required';
          }
          return null;
      },isEnable: registerNotifier.nationalityController.text ==   AppConstants.australia && registerNotifier.residenceStatusController.text == "Citizen"? false : true,
      dropdownItems: (registerNotifier.selectedCountry == AppConstants.AustraliaName &&(registerNotifier.selectedNationality == "Australia" || registerNotifier.selectedNationality == null)) ?registerNotifier.residenceTypeCitizen : registerNotifier.residenceStatus,
      fillColor: registerNotifier.nationalityController.text ==   AppConstants.australia && registerNotifier.residenceStatusController.text == "Citizen"?Colors.grey.shade200:null,
      controller: registerNotifier.residenceStatusController,width: dropdownWidth,optionsViewBuilder: (
          BuildContext context,
          AutocompleteOnSelected onSelected,
          Iterable options
          ) {
          return buildDropDownContainer(context,
            options: options,
            onSelected: onSelected,
            dropdownData: registerNotifier.residenceStatus,
            dropDownWidth: dropdownWidth,
            dropDownHeight: options.first == 'No Data Found' ? 150 :  options.length * 50,
          );
    },
      onSelected: (val) {
      registerNotifier.residenceIdStr = val!;
      if(val == "Skilled Migration visa" && registerNotifier.selectedCountry == AppConstants.AustraliaName){
        registerNotifier.selectedRadioTile = 2;
      }
    },onSubmitted: (val) {
      registerNotifier.residenceIdStr = val!;

    },),
        );

  }

  Widget buildDOBAndNationalityTab(
      RegisterNotifier registerNotifier, BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeading(context, title: S.of(context).dateofBirth),
              commonSizedBoxHeight10(context),
              Selector<RegisterNotifier, TextEditingController>(
                  builder: (context, dobController, child) {
                    return CommonTextField(
                      controller: registerNotifier.dobController,
                      hintText: S.of(context).selectDateOfBirth,
                      hintStyle: hintStyle(context),
                      width:
                          isTab(context) ? getScreenWidth(context) * 0.29 : null,
                      readOnly: true,
                      height: 70,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: registerNotifier.selectedDatePicker == null
                              ? DateTime(DateTime.now().year - 30, DateTime.now().month, DateTime.now().day)
                              : registerNotifier.selectedDatePicker!,
                          firstDate: DateTime(1910),
                          lastDate: DateTime.now(),
                        );

                        if (pickedDate != null) {
                          registerNotifier.selectedDatePicker = pickedDate;
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          registerNotifier.dobController.text = formattedDate;
                        }
                      },
                      validatorEmptyErrorText: dobIsRequired,
                   helperText: "", );
                  },
                  selector: (buildContext, registerNotifier) =>
                      registerNotifier.dobController)
            ],
          ),
          commonSizedBoxWidth20(context),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            buildHeading(context, title: S.of(context).nationality),
            commonSizedBoxHeight10(context),
            CustomizeDropdown(context,
                validation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nationality is required';
                  }
                  return null;
                },
                dropdownItems: registerNotifier.nationalityListData,
                controller: registerNotifier.nationalityController,
                width: kIsWeb ? isTab(context)
                    ? getScreenWidth(context) * 0.29
                    : getScreenWidth(context) * 0.22 :  isTabSDK(context)
                    ? screenSizeWidth * 0.29
                    : screenSizeWidth * 0.22,
                optionsViewBuilder: (BuildContext context,
                    AutocompleteOnSelected onSelected, Iterable options) {
              return buildDropDownContainer(
                context,
                options: options,
                onSelected: onSelected,
                dropdownData: registerNotifier.nationalityListData,
                dropDownWidth: kIsWeb ? isTab(context)
                    ? getScreenWidth(context) * 0.29
                    : getScreenWidth(context) * 0.22 :  isTabSDK(context)
                    ? screenSizeWidth * 0.29
                    : screenSizeWidth * 0.22,
                dropDownHeight: options.first == S.of(context).noDataFound
                    ? 150
                    : options.length < 8
                        ? options.length * 50
                        : 300,
              );
            }, onSelected: (val) {
              registerNotifier.selectedNationality = val!;
              if(val == 'Australia') {
                registerNotifier.residenceIdStr = 'Citizen';
              }else{
                registerNotifier.residenceStatusController.clear();
              }
            }, onSubmitted: (val) {
              registerNotifier.selectedNationality = val!;
              if(val == 'Australia') {
                registerNotifier.residenceIdStr = 'Citizen';
              }else{
                registerNotifier.residenceStatusController.clear();
              }
            },)
          ])
        ],
      ),
    );
  }

  Widget buildDOBAndNationality(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeading(context, title: S.of(context).dateofBirth),
        commonSizedBoxHeight10(context),
        Selector<RegisterNotifier, TextEditingController>(
            builder: (context, dobController, child) {
              return CommonTextField(
                  controller: registerNotifier.dobController,
                  hintText: S.of(context).selectDateOfBirth,
                  hintStyle: hintStyle(context),
                  readOnly: true,
                  helperText: "",
                  onTap: () async{
                    if (defaultTargetPlatform == TargetPlatform.iOS) {
                      iosDatePicker(
                        context,
                        registerNotifier,
                        registerNotifier.dobController,
                        initialDateTime:
                        registerNotifier.selectedDatePicker == null
                            ? DateTime(DateTime.now().year - 30, DateTime.now().month, DateTime.now().day)
                            : registerNotifier.selectedDatePicker!,
                        minimumDate:
                            DateTime(1910),
                        maximumDate: DateTime.now(),
                      );
                    } else{
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: registerNotifier.selectedDatePicker == null
                            ? DateTime(DateTime.now().year - 30, DateTime.now().month, DateTime.now().day)
                            : registerNotifier.selectedDatePicker!,
                        firstDate: DateTime(1910),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        registerNotifier.selectedDatePicker = pickedDate;
                        String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                        registerNotifier.dobController.text = formattedDate;
                      }
                    }
                  },
                  validatorEmptyErrorText: dobIsRequired,
                  width: dropdownWidth);
            },
            selector: (buildContext, registerNotifier) =>
                registerNotifier.dobController),
        commonSizedBoxHeight10(context),
        buildHeading(context, title: S.of(context).nationality),
        commonSizedBoxHeight10(context),
        CustomizeDropdown(
          context,
          validation: (value) {
            if (value == null || value.isEmpty) {
              return 'Nationality is required';
            }
            return null;
          },
          dropdownItems: registerNotifier.nationalityListData,
          controller: registerNotifier.nationalityController,
          width: dropdownWidth,
          optionsViewBuilder: (BuildContext context,
              AutocompleteOnSelected onSelected, Iterable options) {
            return buildDropDownContainer(
              context,
              options: options,
              onSelected: onSelected,
              dropdownData: registerNotifier.nationalityListData,
              dropDownWidth: dropdownWidth,
              dropDownHeight: options.first == S.of(context).noDataFound
                  ? 150
                  : options.length < 8
                      ? options.length * 50
                      : 300,
            );
          },
          onSelected: (val) {
            registerNotifier.selectedNationality = val!;
            if(val == 'Australia') {
              registerNotifier.residenceIdStr = 'Citizen';
            }
          },
          onSubmitted: (val) {
            registerNotifier.selectedNationality = val!;
            if(val == 'Australia') {
              registerNotifier.residenceIdStr = 'Citizen';
            }
          },
        ),
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
    return buildText(
        text: S.of(context).enterNAForBuildingName,
        fontColor: oxfordBlueTint400,
        fontWeight: AppFont.fontWeightRegular);
  }

  Widget buildPostalCode(
      RegisterNotifier registerNotifier, BuildContext context) {
    return kIsWeb
        ? getScreenWidth(context) > 570
            ? buildPostalCodeUI(registerNotifier, context)
            : Row(
                children: [
                  Expanded(child: buildPostalCodeUI(registerNotifier, context))
                ],
              )
        : screenSizeWidth > 570
            ? buildPostalCodeUI(registerNotifier, context)
            : Row(
                children: [
                  Expanded(child: buildPostalCodeUI(registerNotifier, context))
                ],
              );
  }

   Widget buildPostalCodeUI(RegisterNotifier registerNotifier, BuildContext context) {
    return Selector<RegisterNotifier, TextEditingController>(
        builder: (context, postalCodeController, child) {
          return CommonTextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
            controller: postalCodeController,
            width: isMobile(context)
                ? getScreenWidth(context) * 0.39
                : isTab(context)
                    ? getScreenWidth(context) * 0.29
                    : null,
            //hintText: egAddress,
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
            registerNotifier.postalCodeController);
  }

  Widget buildingNameAndNumber(
      RegisterNotifier registerNotifier, BuildContext context) {
    return commonRowField(
      context,
      header1: S.of(context).buildingName,
      header2: S.of(context).buildingNumber,
      controller1: registerNotifier.buildingNameController,
      controller2: registerNotifier.buildingNumberControlller,
      validationRequired1: 'Building name  is required',
      validationRequired2: 'Building number is required',
      validationLength1: enterValidNumber,
      validationLength2: enterValidNumber,
      keyboardType1: TextInputType.text,
      keyboardType2: TextInputType.text,
      inputFormatValid: false,
      isMinimumLength2: false,
    );
  }

  Widget nameOFVillage(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Selector<RegisterNotifier, TextEditingController>(
        builder: (context, nameOfVillageController, child) {
          return CommonTextField(
            controller: nameOfVillageController,
            width: dropdownWidth,
            hintStyle: hintStyle(context),
            validatorEmptyErrorText: 'Name of village/town/district is required',
          );
        },
        selector: (buildContext, registerNotifier) =>
            registerNotifier.nameOfVillageController);
  }

  Widget flatAndFloorNo(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Selector<RegisterNotifier, TextEditingController>(
        builder: (context, flatAndFloorNoController, child) {
          return CommonTextField(
            controller: flatAndFloorNoController,
            hintText: S.of(context).flatAndFloorNumber,
            width: dropdownWidth,
            validatorEmptyErrorText: 'Address is required',
            hintStyle: hintStyle(context),
          );
        },
        selector: (buildContext, registerNotifier) =>
            registerNotifier.flatAndFloorNoController);
  }

  Widget buildFirstName(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Selector<RegisterNotifier, TextEditingController>(
        builder: (context, firstNameController, child) {
          return CommonTextField(
            controller: firstNameController,
            keyboardType: TextInputType.text,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z' ']")),
            ],
            width: dropdownWidth,
            validatorEmptyErrorText: 'First name is required',
            hintStyle: hintStyle(context),
          );
        },
        selector: (buildContext, registerNotifier) =>
            registerNotifier.firstNameController);
  }

  Widget buildLastName(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Selector<RegisterNotifier, TextEditingController>(
        builder: (context, lastNameController, child) {
          return CommonTextField(
            controller: lastNameController,
            keyboardType: TextInputType.text,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z' ']")),
            ],
            width: dropdownWidth,
            validatorEmptyErrorText: 'Last name is required',
            hintStyle: hintStyle(context),
          );
        },
        selector: (buildContext, registerNotifier) =>
            registerNotifier.lastNameController);
  }

  Widget buildMiddleName(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Selector<RegisterNotifier, TextEditingController>(
        builder: (context, middleNameController, child) {
          return CommonTextField(
            controller: middleNameController,
            keyboardType: TextInputType.text,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z' ']")),
            ],
            width: dropdownWidth,
            hintText: "Optional",
            hintStyle: hintStyle(context),
          );
        },
        selector: (buildContext, registerNotifier) =>
            registerNotifier.middleNameController);
  }

  Widget countryDropDown(
      BuildContext context, RegisterNotifier registerNotifier) {
    return CustomizeDropdown(
      context,
      validation: (value) {
        if (value == null || value.isEmpty) {
          return 'Region is required';
        }
        return null;
      },
      dropdownItems: registerNotifier.regionListData,
      controller: registerNotifier.regionController,
      width: dropdownWidth,
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected onSelected, Iterable options) {
        return buildDropDownContainer(
          context,
          options: options,
          onSelected: onSelected,
          dropdownData: registerNotifier.regionListData,
          dropDownWidth: dropdownWidth,
          dropDownHeight: options.first == S.of(context).noDataFound
              ? 150
              : options.length * 50,
        );
      },
      onSelected: (val) {
      registerNotifier.selectedRegion = val!;

    },onSubmitted: (val) {
      registerNotifier.selectedRegion = val!;
    },);
  }

  Widget buildEmployerNameText(BuildContext context) {
    return buildText(
        text: S.of(context).employerNameWeb,
        fontSize: AppConstants.sixteen,
        fontWeight: AppFont.fontWeightSemiBold);
  }

  Widget buildEmployerNameInfo(BuildContext context) {
    return buildText(
        text: S.of(context).employerNameToVerify,
        fontColor: oxfordBlueTint400,
        fontWeight: AppFont.fontWeightRegular);
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
              // inputFormatters: <TextInputFormatter>[
              //   FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
              // ],
              width: dropdownWidth);
        },
        selector: (buildContext, registerNotifier) =>
            registerNotifier.employerNameController);
  }

  Widget buildOccupationText(BuildContext context) {
    return buildText(
        text: S.of(context).occupation,
        fontSize: AppConstants.sixteen,
        fontWeight: AppFont.fontWeightSemiBold);
  }

  Widget buildOccupationInfoText(BuildContext context) {
    return buildText(
        text: S.of(context).selectTheFieldOrIndustry,
        fontColor: oxfordBlueTint400,
        fontWeight: AppFont.fontWeightRegular);
  }

  Widget buildOccupationDropdownBox(
      RegisterNotifier registerNotifier, BuildContext context) {
    return CustomizeDropdown(
      context,
      validation: (value) {
        if (value == null || value.isEmpty) {
          return 'Occupation is required';
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
              : options.length < 8
                  ? options.length * 50
                  : 300,
        );
      },
      onSelected: (val) {
      registerNotifier.selectedOccupation = val!;

    },onSubmitted: (val) {
      registerNotifier.selectedOccupation = val!;

    },);

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

  Widget buildRadioButtons(
      BuildContext context, RegisterNotifier registerNotifier) {
    return Container(
      width: dropdownWidth,
      padding: px15DimenAll(context),
      decoration: transactionHistoryContainerStyle(context),
      child: Column(
        children: [
          RadioListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              S
                  .of(context)
                  .forStraightThroughProcessingIWouldLikeToChooseDigitalIDVerification,
              style: walletGridTextStyle14(context),
            ),
            value: 1,
            groupValue: registerNotifier.selectedRadioTile,
            onChanged: (registerNotifier.residenceIdStr == "Skilled Migration visa" && registerNotifier.selectedCountry == AppConstants.AustraliaName) ? null : (int? value) {
              registerNotifier.selectedRadioTile = value!;
            },
          ),
          RadioListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
                S
                    .of(context)
                    .IDoNotWishToDiscloseAnyPersonalInformationToAnyCreditReportingOrGovernmentAgency,
                style: walletGridTextStyle14(context)),
            value: 2,
            groupValue: registerNotifier.selectedRadioTile,
            onChanged: (int? value) {
              registerNotifier.selectedRadioTile = value!;
            },
          ),
        ],
      ),
    );
  }

  Widget buildHeading(context, {title}) {
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
      onPressedBack: () {
        SharedPreferencesMobileWeb.instance
            .setMethodSelectedAUS('methodSelectedAUS',false);
        SharedPreferencesMobileWeb.instance.removeParticularKey(apiToken);
        Navigator.pushReplacementNamed(context, loginRoute);
        SharedPreferencesMobileWeb.instance.removeParticularKey(AppConstants.stepOneData);
      },
      onPressedContinue: () async {
        if (registerNotifier.personalDetailFormKey.currentState!.validate()) {
          if (registerNotifier.selectedCountry == AppConstants.australia) {
            // Map<String, dynamic> stepOneDataStore = {
            //   "salutation": registerNotifier.salutationStr,
            //   "firstName": registerNotifier.firstNameController.text,
            //   "middleName": registerNotifier.middleNameController.text,
            //   "lastName": registerNotifier.lastNameController.text,
            //   "dateOfBirth": registerNotifier.dobController.text,
            //   "nationality": registerNotifier.selectedNationality,
            //   "residentStatus": registerNotifier.residenceIdStr,
            //   "addressSearch": registerNotifier.searchAddressController.text,
            //   "unitNo": registerNotifier.unitNoController.text,
            //   "streetNumber": registerNotifier.blockNoController.text,
            //   "streetName": registerNotifier.streetNameController.text,
            //   "suburb": registerNotifier.buildingNameController.text,
            //   "city": registerNotifier.cityController.text,
            //   "stateOrProvince": registerNotifier.stateOrProvinceValue,
            //   "postalCode": registerNotifier.postalCodeController.text,
            //   "occupation": registerNotifier.selectedOccupation,
            //   "employerName": registerNotifier.employerNameController.text,
            //   "annualIncome": registerNotifier.estimatedTxnAmountStr,
            //   "referralCode": registerNotifier.enterPromoCodeController.text,
            //   "Cra": registerNotifier.selectedRadioTile,
            //   "othersOccupation":
            //       registerNotifier.occupationOthersController.text,
            // };
            // await SharedPreferencesMobileWeb.instance
            //     .setProfileStepOne(stepOneData, jsonEncode(stepOneDataStore));
            registerNotifier.saveCustomerDetails(context);
          } else {
            await registerNotifier.saveCustomerDetailsHK(context);
          }
        } else {}
      },
    );
  }

  Widget buildJohorAddressField(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
            child: commonSizedBoxHeight20(context),
            visible: registerNotifier.isError),
        buildingNameAndNumber(registerNotifier, context),
        Visibility(
            child: commonSizedBoxHeight20(context),
            visible: registerNotifier.isError),
      ],
    );
  }

  Widget commonRowField(BuildContext context,
      {header1,
      header2,
      controller1,
      controller2,
      hintText1,
      hintText2,
      validationRequired1,
      validationLength1,
      validationRequired2,
      validationLength2,
      inputFormat1,
      inputFormat2,
      keyboardType1,
      bool? inputFormatValid,
      keyboardType2,
      isMinimumLength1,
      isMinimumLength2}) {
    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: kIsWeb ? getScreenWidth(context) < 570 ? 5 : 0 : screenSizeWidth < 570 ? 5 : 0,
            runSpacing: 10,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeading(context, title: header1 ?? ""),
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
                    inputFormatters:inputFormatValid == false?null: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(inputFormat1 ?? "[a-zA-Z]")),
                    ],
                  )
                ],
              ),
              commonSizedBoxWidth20(context),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeading(context, title: header2 ?? ""),
                  commonSizedBoxHeight10(context),
                  CommonTextField(
                    controller: controller2,
                    width: kIsWeb ?  isMobile(context)
                        ? getScreenWidth(context) * 0.80
                        : isTab(context)
                        ? getScreenWidth(context) * 0.29
                        : getScreenWidth(context) * 0.22 : isMobileSDK(context)
                        ? screenSizeWidth * 0.80
                        : isTabSDK(context)
                        ? screenSizeWidth * 0.29
                        : screenSizeWidth * 0.22,
                    hintText: hintText2,
                    helperText: '',
                    keyboardType: keyboardType2 ?? TextInputType.name,
                    hintStyle: hintStyle(context),
                    validatorEmptyErrorText: validationRequired2,
                    inputFormatters: inputFormatValid == false?null:<TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(inputFormat2 ?? "[a-zA-Z]")),
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

  Widget buildStateAndProvinceDropdown(
      BuildContext context, RegisterNotifier registerNotifier) {
    return CustomizeDropdown(
      context,
      validation: (value) {
        if (value == null || value.isEmpty) {
          return 'State/Province is required';
        }
        return null;
      },
      dropdownItems: registerNotifier.stateListData,
      controller: registerNotifier.stateAndProvinceController,
      width: kIsWeb ?  isMobile(context)
          ? getScreenWidth(context) * 0.80
          : isTab(context)
          ? getScreenWidth(context) * 0.29
          : getScreenWidth(context) * 0.22 : isMobileSDK(context)
          ? screenSizeWidth * 0.80
          : isTabSDK(context)
          ? screenSizeWidth * 0.29
          : screenSizeWidth * 0.22,
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected onSelected, Iterable options) {
        return buildDropDownContainer(
          context,
          options: options,
          onSelected: onSelected,
          dropdownData: registerNotifier.stateListData,
          dropDownWidth: kIsWeb ?  isMobile(context)
              ? getScreenWidth(context) * 0.80
              : isTab(context)
              ? getScreenWidth(context) * 0.29
              : getScreenWidth(context) * 0.22 : isMobileSDK(context)
              ? screenSizeWidth * 0.80
              : isTabSDK(context)
              ? screenSizeWidth * 0.29
              : screenSizeWidth * 0.22,
          dropDownHeight: options.first == S.of(context).noDataFound
              ? 150
              : options.length < 8
              ? options.length * 50
              : 300,
        );
      },
      onSelected: (val) {
        registerNotifier.stateOrProvinceValue = val!;
      },
      onSubmitted: (val) {
        registerNotifier.stateOrProvinceValue = val!;
      },
    );
  }

}
