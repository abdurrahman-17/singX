import 'package:flutter/foundation.dart';
import 'package:singx/core/data/remote/service/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/service/australia/auth_repository_aus.dart';
import 'package:singx/core/models/request_response/hongkong/personal_details/SaveAdditionalDetailRequestHk.dart';
import 'package:singx/core/notifier/register_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class AdditionalDetails extends StatelessWidget {
  final isOtp;
   AdditionalDetails({Key? key, this.isOtp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    double commonWidth = kIsWeb
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
    double commonWidthTab = kIsWeb
        ? isTab(context)
            ? getScreenWidth(context) * 0.29
            : getScreenWidth(context) * 0.22
        : isTabSDK(context)
            ? screenSizeWidth * 0.29
            : screenSizeWidth * 0.22;
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          RegisterNotifier(context, from: "additional", isOtp: isOtp ?? false),
      child: Consumer<RegisterNotifier>(
        builder: (context, registerNotifier, _) {
          return Scaffold(
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
                                      : screenSizeWidth * 0.25,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            commonSizedBoxHeight60(context),
                            kIsWeb
                                ? isTab(context) ||
                                        getScreenWidth(context) < 1100
                                    ? industryAndEmployeeName(
                                        context, registerNotifier, commonWidth)
                                    : industryAndEmployeeNameTab(context,
                                        registerNotifier, commonWidthTab)
                                : isTabSDK(context) || screenSizeWidth < 1100
                                    ? industryAndEmployeeName(
                                        context, registerNotifier, commonWidth)
                                    : industryAndEmployeeNameTab(context,
                                        registerNotifier, commonWidthTab),
                            commonSizedBoxHeight20(context),
                            kIsWeb
                                ? isTab(context) ||
                                        getScreenWidth(context) < 1100
                                    ? purposeOfOpeningAndCorridor(
                                        context, registerNotifier, commonWidth)
                                    : purposeOfOpeningAndCorridorTab(context,
                                        registerNotifier, commonWidthTab)
                                : isTabSDK(context) || screenSizeWidth < 1100
                                    ? purposeOfOpeningAndCorridor(
                                        context, registerNotifier, commonWidth)
                                    : purposeOfOpeningAndCorridorTab(context,
                                        registerNotifier, commonWidthTab),
                            commonSizedBoxHeight25(context),
                            kIsWeb
                                ? isTab(context) ||
                                        getScreenWidth(context) < 1100
                                    ? educationQualificationAndGraduationYear(
                                        context, registerNotifier, commonWidth)
                                    : educationQualificationAndGraduationYearTab(
                                        context,
                                        registerNotifier,
                                        commonWidthTab)
                                : isTabSDK(context) || screenSizeWidth < 1100
                                    ? educationQualificationAndGraduationYear(
                                        context, registerNotifier, commonWidth)
                                    : educationQualificationAndGraduationYearTab(
                                        context,
                                        registerNotifier,
                                        commonWidthTab),
                            commonSizedBoxHeight20(context),
                            buildHeading(context, title: S.of(context).gender),
                            commonSizedBoxHeight10(context),
                            genderDropDown(
                                context, registerNotifier, commonWidth),
                            commonSizedBoxHeight25(context),
                            buildHeading(context,
                                title:
                                    S.of(context).estimatedTransactionAmount),
                            commonSizedBoxHeight10(context),
                            estimatedTransactionAmount(
                                context, registerNotifier, commonWidth),
                            commonSizedBoxHeight25(context),
                            buildHeading(context,
                                title: S.of(context).annualIncome),
                            commonSizedBoxHeight10(context),
                            annualIncomeField(
                                context, registerNotifier, commonWidth),
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
                                visible:
                                    registerNotifier.OTPErrorMessage != ''),
                            commonSizedBoxHeight50(context),
                            buildButtons(registerNotifier, context),
                            commonSizedBoxHeight100(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget industryAndEmployeeName(
      BuildContext context, RegisterNotifier registerNotifier, commonWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeading(context, title: S.of(context).industry),
        commonSizedBoxHeight10(context),
        buildIndustryDropdown(context, registerNotifier, commonWidth),
        commonSizedBoxHeight10(context),
        buildHeading(context, title: S.of(context).employerNameWeb),
        commonSizedBoxHeight10(context),
        Selector<RegisterNotifier, TextEditingController>(
            builder: (context, employerNameController, child) {
              return CommonTextField(
                  containerColor: transparent,
                  controller: registerNotifier.employerNameController,
                  hintText: S.of(context).employerName,
                  hintStyle: hintStyle(context),
                  validatorEmptyErrorText: employerNameInAdditionalDetails,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                  ],
                  width: commonWidth);
            },
            selector: (buildContext, registerNotifier) =>
                registerNotifier.employerNameController),
      ],
    );
  }

  Widget industryAndEmployeeNameTab(
      BuildContext context, RegisterNotifier registerNotifier, commonWidthTab) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeading(context, title: S.of(context).industry),
            commonSizedBoxHeight10(context),
            buildIndustryDropdown(context, registerNotifier, commonWidthTab),
          ],
        ),
        commonSizedBoxWidth20(context),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeading(context, title: S.of(context).employerNameWeb),
            commonSizedBoxHeight10(context),
            Selector<RegisterNotifier, TextEditingController>(
                builder: (context, employerNameController, child) {
                  return CommonTextField(
                    containerColor: transparent,
                    helperText: '',
                    controller: employerNameController,
                    hintText: S.of(context).employerName,
                    hintStyle: hintStyle(context),
                    validatorEmptyErrorText: employerNameInAdditionalDetails,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                    ],
                    width: commonWidthTab,
                  );
                },
                selector: (buildContext, registerNotifier) =>
                    registerNotifier.employerNameController),
          ],
        )
      ],
    );
  }

  Widget purposeOfOpeningAndCorridorTab(
      BuildContext context, RegisterNotifier registerNotifier,commonWidthTab) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeading(context,
                title: S.of(context).purposeofOpeningthisAccount),
            commonSizedBoxHeight10(context),
            CommonDropDownField(
              multipleSelection: true,
              containerColor: Colors.transparent,
              items: registerNotifier.registrationPurposeListData,
              hintText: S.of(context).select,
              hintStyle: hintStyle(context),
              multiSelectedItems: registerNotifier.purposeOfOpeningACValue,
              onChangedMultiple: (val) {
                registerNotifier.purposeOfOpeningACValue = val;
                registerNotifier.purposeOfOpeningACValue.isEmpty?registerNotifier.purposeLOfOpening = true:registerNotifier.purposeLOfOpening = false;
              },
              width: commonWidthTab,
              color: white,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color:registerNotifier.purposeLOfOpening?errorTextField: fieldBorderColorNew),
              ),
            ),
            Visibility(
              visible: registerNotifier.purposeLOfOpening,
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0,top: 8.0),
                child: Text("Purpose of account cannot be blank.",style: errorMessageStyle(context).copyWith(fontSize: 12),),
              ),
            )
          ],
        ),
        commonSizedBoxWidth20(context),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeading(context, title: S.of(context).corridorsofInterest),
            commonSizedBoxHeight10(context),
            CommonDropDownField(
              multipleSelection: true,
              containerColor: Colors.transparent,
              items: registerNotifier.corridorOfInterestListData,
              boolValidation: registerNotifier.corridorOfInterestBool,
              multiSelectedItems: registerNotifier.corridorOfInterest,
              onChangedMultiple: (val) {
                registerNotifier.corridorOfInterest = val;
                registerNotifier.corridorOfInterest.isEmpty?registerNotifier.corridorOfInterestBool = true:registerNotifier.corridorOfInterestBool = false;
              },
              hintText: S.of(context).select,
              hintStyle: hintStyle(context),
              width: commonWidthTab,
              color: white,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color:registerNotifier.corridorOfInterestBool?errorTextField: fieldBorderColorNew),
              ),
            ),
            Visibility(
              visible: registerNotifier.corridorOfInterestBool,
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0,top: 8.0),
                child: Text("Corridor Name cannot be blank.",style: errorMessageStyle(context).copyWith(fontSize: 12),),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget purposeOfOpeningAndCorridor(
      BuildContext context, RegisterNotifier registerNotifier,commonWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeading(context, title: S.of(context).purposeofOpeningthisAccount),
        commonSizedBoxHeight10(context),
        CommonDropDownField(
          multipleSelection: true,
          containerColor: Colors.transparent,
          items: registerNotifier.registrationPurposeListData,
          multiSelectedItems: registerNotifier.purposeOfOpeningACValue,
          onChangedMultiple: (val) {
            registerNotifier.purposeOfOpeningACValue = val;
            registerNotifier.purposeOfOpeningACValue.isEmpty?registerNotifier.purposeLOfOpening = true:registerNotifier.purposeLOfOpening = false;
          },
          hintText: S.of(context).select,
          hintStyle: hintStyle(context),
          width: commonWidth,
          color: white,
          enabledBorder:  OutlineInputBorder(
            borderSide: BorderSide(color:registerNotifier.purposeLOfOpening?errorTextField: fieldBorderColorNew),
          ),
        ),
        Visibility(
          visible: registerNotifier.purposeLOfOpening,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0,top: 8.0),
            child: Text("Purpose of account cannot be blank.",style: errorMessageStyle(context).copyWith(fontSize: 12),),
          ),
        ),
        commonSizedBoxHeight20(context),
        buildHeading(context, title: S.of(context).corridorsofInterest),
        commonSizedBoxHeight10(context),
        CommonDropDownField(
          multipleSelection: true,
          containerColor: Colors.transparent,
          items: registerNotifier.corridorOfInterestListData,
          multiSelectedItems: registerNotifier.corridorOfInterest,
          boolValidation: registerNotifier.corridorOfInterestBool,
          onChangedMultiple: (val) {
            registerNotifier.corridorOfInterest = val;
            registerNotifier.corridorOfInterest.isEmpty?registerNotifier.corridorOfInterestBool = true:registerNotifier.corridorOfInterestBool = false;
          },
          hintText: S.of(context).select,
          hintStyle: hintStyle(context),
          width: commonWidth,
          color: white,
          enabledBorder:  OutlineInputBorder(
            borderSide: BorderSide(color:registerNotifier.corridorOfInterestBool?errorTextField: fieldBorderColorNew),
          ),
        ),
        Visibility(
          visible: registerNotifier.corridorOfInterestBool,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0,top: 8.0),
            child: Text("Corridor Name cannot be blank.",style: errorMessageStyle(context).copyWith(fontSize: 12),),
          ),
        )
      ],
    );
  }

  Widget annualIncomeField(
      BuildContext context, RegisterNotifier registerNotifier, commonWidth) {
    return CustomizeDropdown(
      context,
      validation: (value) {
        if (value == null || value.isEmpty) {
          return 'Annual Income is required';
        }
        return null;
      },
      dropdownItems: registerNotifier.annualIncomeListData,
      controller: registerNotifier.annualIncomeController,
      width: commonWidth,
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected onSelected, Iterable options) {
        return buildDropDownContainer(
          context,
          options: options,
          onSelected: onSelected,
          dropdownData: registerNotifier.annualIncomeListData,
          dropDownWidth: commonWidth,
          dropDownHeight: options.first == S.of(context).noDataFound
              ? 150
              : options.length < 4
                  ? options.length * 50
                  : 140,
        );
      },
      onSelected: (val) {
        registerNotifier.annualIncomeValue = val!;
      },
      onSubmitted: (val) {
        registerNotifier.annualIncomeValue = val!;
      },
    );
  }

  Widget estimatedTransactionAmount(
      BuildContext context, RegisterNotifier registerNotifier, commonWidth) {
    return CustomizeDropdown(
      context,
      validation: (value) {
        if (value == null || value.isEmpty) {
          return 'Transaction Amount cannot be blank.';
        }
        return null;
      },
      dropdownItems: registerNotifier.estimatedTransactionAmountListData,
      controller: registerNotifier.estimatedAmountController,
      width: commonWidth,
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected onSelected, Iterable options) {
        return buildDropDownContainer(
          context,
          options: options,
          onSelected: onSelected,
          dropdownData: registerNotifier.estimatedTransactionAmountListData,
          dropDownWidth: commonWidth,
          dropDownHeight: options.first == S.of(context).noDataFound
              ? 150
              : options.length < 5
                  ? options.length * 50
                  : 200,
        );
      },
      onSelected: (val) {
        registerNotifier.estimatedTransactionAmountValue = val!;
      },
      onSubmitted: (val) {
        registerNotifier.estimatedTransactionAmountValue = val!;
      },
    );
  }

  Widget educationQualificationAndGraduationYearTab(
      BuildContext context, RegisterNotifier registerNotifier, commonWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeading(context, title: S.of(context).educationQualification),
            commonSizedBoxHeight10(context),
            buildEducationQualifyDropdown(
                context, registerNotifier, commonWidth),
          ],
        ),
        commonSizedBoxWidth20(context),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeading(context, title: S.of(context).graduationYear),
            commonSizedBoxHeight10(context),
            Selector<RegisterNotifier, TextEditingController>(
                builder: (context, graduationYearController, child) {
                  return CommonTextField(
                    containerColor: transparent,
                    helperText: "",
                    maxLength: 4,
                    controller: graduationYearController,
                    hintText: S.of(context).graduationYearEg,
                    hintStyle: hintStyle(context),
                    validatorEmptyErrorText: 'Please enter your year of graduation',
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    ],
                    width: commonWidth,
                  );
                },
                selector: (buildContext, registerNotifier) =>
                    registerNotifier.graduationYearController),
          ],
        )
      ],
    );
  }

  Widget educationQualificationAndGraduationYear(
      BuildContext context, RegisterNotifier registerNotifier, commonWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeading(context, title: S.of(context).educationQualification),
        commonSizedBoxHeight10(context),
        buildEducationQualifyDropdown(context, registerNotifier, commonWidth),
        commonSizedBoxHeight20(context),
        buildHeading(context, title: S.of(context).graduationYear),
        commonSizedBoxHeight10(context),
        Selector<RegisterNotifier, TextEditingController>(
            builder: (context, graduationYearController, child) {
              return CommonTextField(
                containerColor: transparent,
                maxLength: 4,
                controller: graduationYearController,
                hintText: S.of(context).graduationYearEg,
                hintStyle: hintStyle(context),
                validatorEmptyErrorText: 'Please enter your year of graduation',
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
                width: commonWidth,
              );
            },
            selector: (buildContext, registerNotifier) =>
                registerNotifier.graduationYearController),
      ],
    );
  }

  Widget genderDropDown(
      BuildContext context, RegisterNotifier registerNotifier, commonWidth) {
    return CustomizeDropdown(
      context,
      validation: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your Gender';
        }
        return null;
      },
      dropdownItems: registerNotifier.genderListData,
      controller: registerNotifier.genderController,
      width: commonWidth,
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected onSelected, Iterable options) {
        return buildDropDownContainer(
          context,
          options: options,
          onSelected: onSelected,
          dropdownData: registerNotifier.genderListData,
          dropDownWidth: commonWidth,
          dropDownHeight: options.first == S.of(context).noDataFound
              ? 150
              : options.length * 50,
        );
      },
      onSelected: (val) {
        registerNotifier.genderValue = val!;
      },
      onSubmitted: (val) {
        registerNotifier.genderValue = val!;
      },
    );
  }

  Widget buildButtons(RegisterNotifier registerNotifier, BuildContext context) {
    var buttonWidth = kIsWeb ? isMobile(context)
        ? getScreenWidth(context) * 0.39
        : isTab(context)
        ? getScreenWidth(context) * 0.29
        : null : isMobileSDK(context)
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
          Navigator.pushNamed(context, uploadHKIDProofRoute);
        });
      },
      onPressedContinue: () async {
        registerNotifier.OTPErrorMessage = '';
        registerNotifier.purposeOfOpeningACValue.isEmpty?registerNotifier.purposeLOfOpening = true:registerNotifier.purposeLOfOpening = false;
        registerNotifier.corridorOfInterest.isEmpty?registerNotifier.corridorOfInterestBool = true:registerNotifier.corridorOfInterestBool = false;
        if (registerNotifier.personalDetailFormKey.currentState!.validate() && registerNotifier.purposeLOfOpening != true && registerNotifier.corridorOfInterestBool != true) {
          String corridor = '';
          String purposeOfOpening = '';
          registerNotifier.corridorOfInterest.forEach((element) async {
            corridor = corridor + element + ",";
          });
          registerNotifier.purposeOfOpeningACValue.forEach((element) async {
            purposeOfOpening = purposeOfOpening + element + ",";
          });

          await AuthRepositoryAus()
              .saveCustomerAdditionalDetailsHK(
                  SaveAdditionalDetailRequestHk(
                    industry: registerNotifier.industryValue,
                    employerName: registerNotifier.employerNameController.text,
                    openingPurpose: purposeOfOpening,
                    corridorInterest: corridor,
                    estTransAmt:
                        registerNotifier.estimatedTransactionAmountValue,
                    annualIncome: registerNotifier.annualIncomeValue,
                    industryOthers: "",
                    remitAmountComments: "",
                    educationQualification: registerNotifier.educationValue,
                    yearOfGraduation:
                        registerNotifier.graduationYearController.text,
                    gender: registerNotifier.genderValue,
                    otp: "",
                  ),
                  context)
              .then((value) async {
            if (value == true) {
              await AuthRepository().apiAuthDetail(context).then((value) {
                if (value == AppConstants.status_hk_otp) {
                  //todo
                }
              });
            } else {
              showMessageDialog(
                  context, AppConstants.somethingWentWrongMessage);
            }
          });
        } else {
          registerNotifier.isError = !registerNotifier.isError;
        }
      },
    );
  }

  Widget buildHeading(context, {title}) {
    return buildText(
        text: title,
        fontSize: AppConstants.sixteen,
        fontColor: oxfordBlueTint500);
  }

  Widget buildIndustryDropdown(
      BuildContext context, RegisterNotifier registerNotifier, commonWidth) {
    return CustomizeDropdown(context,
        validation: (value) {
          if (value == null || value.isEmpty) {
            return 'Industry cannot be blank.';
          }
          return null;
        },
        dropdownItems: registerNotifier.industryListData,
        controller: registerNotifier.industryValueController,
        width: commonWidth, optionsViewBuilder: (BuildContext context,
            AutocompleteOnSelected onSelected, Iterable options) {
      return buildDropDownContainer(
        context,
        options: options,
        onSelected: onSelected,
        dropdownData: registerNotifier.industryListData,
        dropDownWidth: commonWidth,
        dropDownHeight: options.first == S.of(context).noDataFound
            ? 150
            : options.length < 8
                ? options.length * 50
                : 250,
      );
    }, onSelected: (val) {
      registerNotifier.industryValue = val!;
    }, onSubmitted: (val) {
      registerNotifier.industryValue = val!;
    },);
  }

  Widget buildEducationQualifyDropdown(
      BuildContext context, RegisterNotifier registerNotifier, commonWidth) {
    return CustomizeDropdown(context,
        validation: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your highest education qualification';
          }
          return null;
        },
        dropdownItems: registerNotifier.educationQualificationListData,
        controller: registerNotifier.educationQualificationController,
        width: commonWidth, optionsViewBuilder: (BuildContext context,
            AutocompleteOnSelected onSelected, Iterable options) {
      return buildDropDownContainer(
        context,
        options: options,
        onSelected: onSelected,
        dropdownData: registerNotifier.educationQualificationListData,
        dropDownWidth: commonWidth,
        dropDownHeight: options.first == S.of(context).noDataFound
            ? 150
            : options.length < 5
                ? options.length * 50
                : 200,
      );
    }, onSelected: (val) {
      registerNotifier.educationValue = val!;
    }, onSubmitted: (val) {
      registerNotifier.educationValue = val!;
    },);
  }
}
