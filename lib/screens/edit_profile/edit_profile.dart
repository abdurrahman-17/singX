import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/service/australia/auth_repository_aus.dart';
import 'package:singx/core/data/remote/service/contact_repository.dart';
import 'package:singx/core/models/request_response/australia/personal_details/SaveCustomerRequest.dart';
import 'package:singx/core/models/request_response/australia/personal_details/search_address_response.dart';
import 'package:singx/core/models/request_response/dropdown/dropdown_response.dart';
import 'package:singx/core/models/request_response/hongkong/personal_details/SaveCustomerRequestHk.dart';
import 'package:singx/core/models/request_response/personal_details/personal_details_sg_request.dart';
import 'package:singx/core/notifier/common_notifier.dart';
import 'package:singx/core/notifier/edit_profile_notifier.dart';
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
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/common/page_scaffold/page_scaffold.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import '../../utils/shared_preference/shared_preference_mobile_web.dart';

class EditProfile extends StatelessWidget {
  EditProfile({Key? key, this.navigateData}) : super(key: key);

  //To Navigate between user profile page and view profile page
  bool? navigateData;

  RegisterNotifier? notifier;
  var dropdownWidth;

  @override
  Widget build(BuildContext context) {
    userCheck(context);
    notifier = RegisterNotifier(context, from: AppConstants.viewProfile);
    return ChangeNotifierProvider(
      create: (BuildContext context) => EditProfileNotifier(context),
      child: Consumer<EditProfileNotifier>(
          builder: (context, editProfileNotifier, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if(editProfileNotifier.countryData == SingaporeName)editProfileNotifier.cityController.text = AppConstants.johor;
          editProfileNotifier.stateController.text = AppConstants.johor;
          editProfileNotifier.editNavigation = navigateData!;
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
        return buildBody(context, editProfileNotifier);
      }),
    );
  }

  Widget buildBody(
      BuildContext context, EditProfileNotifier editProfileNotifier) {
    return editProfileNotifier.editNavigation == false
        ? userProfile(context, editProfileNotifier)
        : editProfile(context, editProfileNotifier);
  }

  //User Profile View Data
  Widget userProfile(
      BuildContext context, EditProfileNotifier editProfileNotifier) {
    return PageScaffold(
      color: bankDetailsBackground,
      appbar: PreferredSize(
        preferredSize: Size.fromHeight(AppConstants.appBarHeight),
        child: Padding(
          padding: kIsWeb ? isMobile(context) || isTab(context)
              ? px15DimenTop(context)
              : px30DimenTopOnly(context) : isMobileSDK(context) || isTabSDK(context)
              ? px15DimenTop(context)
              : px30DimenTopOnly(context),
          child: buildAppBar(
            context,
            Text(
              S.of(context).userProfile,
              style: appBarWelcomeText(context),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            primary: true,
            child: buildUserBody(context, editProfileNotifier),
          ),
          if (editProfileNotifier.showLoadingIndicator)
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
      ),
      title: S.of(context).editProfile,
    );
  }

  Widget buildUserBody(
      BuildContext context, EditProfileNotifier editProfileNotifier) {
    return Padding(
      padding: px24DimenAll(context),
      child: kIsWeb
          ? getScreenWidth(context) >= 850
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: userDetails(context, editProfileNotifier),
                    ),
                    sizedBoxWidth20(context),
                    Expanded(
                      flex: 1,
                      child: documentsUploaded(context, editProfileNotifier),
                    ),
                  ],
                )
              : Column(
                  children: [
                    userDetails(context, editProfileNotifier),
                    sizedBoxHeight20(context),
                    documentsUploaded(context, editProfileNotifier),
                  ],
                )
          : screenSizeWidth >= 850
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: userDetails(context, editProfileNotifier),
                    ),
                    sizedBoxWidth20(context),
                    Expanded(
                      flex: 1,
                      child: documentsUploaded(context, editProfileNotifier),
                    ),
                  ],
                )
              : Column(
                  children: [
                    userDetails(context, editProfileNotifier),
                    sizedBoxHeight20(context),
                    documentsUploaded(context, editProfileNotifier),
                  ],
                ),
    );
  }

  Widget userDetails(
      BuildContext context, EditProfileNotifier editProfileNotifier) {
    return Container(
      padding: px24DimenAll(context),
      decoration: tabBarChildContainerStyle2(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageProfile(context),
          sizedBoxHeight30(context),
          sizedBoxHeight2(context),
          kIsWeb
              ? getScreenWidth(context) >= 400
                  ? profileDataGreaterThan400(context, editProfileNotifier)
                  : profileDataLessThan400(context, editProfileNotifier)
              : screenSizeWidth >= 400
                  ? profileDataGreaterThan400(context, editProfileNotifier)
                  : profileDataLessThan400(context, editProfileNotifier),
          sizedBoxHeight45(context),
          sizedBoxHeight13(context),
          editProfileNotifier.authStatus == AppConstants.status_profile ||
              editProfileNotifier.authStatus ==
                  AppConstants.status_hk_step2 ||
              editProfileNotifier.authStatus ==
                  AppConstants.status_hk_step3 ||
              editProfileNotifier.authStatus ==
                  AppConstants.status_hk_otp ||
              editProfileNotifier.authStatus ==
                  AppConstants.status_profile||
              editProfileNotifier.authStatus ==
                  AppConstants.status_address||
              editProfileNotifier.authStatus ==
                  AppConstants.status_kyc
              ? SizedBox()
              : buildButton(
            context,
            name: S.of(context).viewProfile,
            color: hanBlue,
            fontColor: white,
            width: double.infinity,
            onPressed: () async {
              await SharedPreferencesMobileWeb.instance
                  .getCountry(country)
                  .then((value) async {
                Navigator.pushNamed(context, editProfileDataRoute);
              });
            },
          ),
          Visibility(
              visible: Provider.of<CommonNotifier>(context, listen: false)
                      .updateUserVerifiedBool ==
                  false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sizedBoxHeight20(context),
                  buildButton(
                    context,
                    name: S.of(context).back,
                    color: hanBlue,
                    fontColor: white,
                    width: double.infinity,
                    onPressed: () async {
                      await SharedPreferencesMobileWeb.instance
                          .getCountry(country)
                          .then((value) async {
                        Navigator.pushNamedAndRemoveUntil(
                            context, dashBoardRoute, (route) => false);
                      });
                    },
                  )
                ],
              )),
        ],
      ),
    );
  }

  //Profile Data For Above the Screen Size Of 400
  Widget profileDataGreaterThan400(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            buildHeadingAndText(context, S.of(context).firstName,
                editProfileNotifier.firstName),
            sizedBoxWidth15(context),
            buildHeadingAndText(context, S.of(context).lastName,
                editProfileNotifier.lastName),
          ],
        ),
        sizedBoxHeight24(context),
        Row(
          children: [
            buildHeadingAndText(context, S.of(context).nationality,
                editProfileNotifier.nationality),
            sizedBoxWidth15(context),
            buildHeadingAndText(
                context,
                S.of(context).residenceCountry,
                editProfileNotifier.residenseCountry),
          ],
        ),
        sizedBoxHeight24(context),
        Row(
          children: [
            buildHeadingAndText(context, S.of(context).emailAddress,
                editProfileNotifier.emailAddress),
            sizedBoxWidth15(context),
            buildHeadingAndText(context, S.of(context).mobileNumber,
                editProfileNotifier.mobileNumber),
          ],
        ),
        sizedBoxHeight24(context),
        Row(
          children: [
            buildHeadingAndText(context, S.of(context).address,
                editProfileNotifier.address),
          ],
        ),
        sizedBoxHeight24(context),
        Row(
          children: [
            buildHeadingAndText(context, S.of(context).employer,
                editProfileNotifier.employer),
            sizedBoxWidth15(context),
            buildHeadingAndText(context, S.of(context).occupation,
                editProfileNotifier.occupation),
          ],
        )
      ],
    );
  }

  //Profile Data For Below the Screen Size Of 400
  Widget profileDataLessThan400(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeadingAndText(context, S.of(context).firstName,
            editProfileNotifier.firstName),
        sizedBoxHeight24(context),
        buildHeadingAndText(context, S.of(context).lastName,
            editProfileNotifier.lastName),
        sizedBoxHeight24(context),
        buildHeadingAndText(context, S.of(context).nationality,
            editProfileNotifier.nationality),
        sizedBoxHeight24(context),
        buildHeadingAndText(
            context,
            S.of(context).residenceCountry,
            editProfileNotifier.residenseCountry),
        sizedBoxHeight24(context),
        buildHeadingAndText(context, S.of(context).emailAddress,
            editProfileNotifier.emailAddress),
        sizedBoxHeight24(context),
        buildHeadingAndText(context, S.of(context).mobileNumber,
            editProfileNotifier.mobileNumber),
        sizedBoxHeight24(context),
        buildHeadingAndText(context, S.of(context).address,
            editProfileNotifier.address),
        sizedBoxHeight24(context),
        buildHeadingAndText(context, S.of(context).employer,
            editProfileNotifier.employer),
        sizedBoxHeight24(context),
        buildHeadingAndText(context, S.of(context).occupation,
            editProfileNotifier.occupation),
      ],
    );
  }

  //User Profile
  Widget imageProfile(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.asset(
          AppImages.profile,
          height: 150,
          width: 150,
        ),
      ),
    );
  }

  //User Uploaded Document View
  Widget documentsUploaded(
      BuildContext context, EditProfileNotifier editProfileNotifier) {
    return Visibility(
        visible: !((editProfileNotifier.countryData == AppConstants.singapore ||
            editProfileNotifier.countryData == AppConstants.hongKong) &&
            (editProfileNotifier.documentErrorMessage ==
                AppConstants.notAllowedForCurrentStatus ||
                editProfileNotifier.documentListData.isEmpty)),
        child: Container(
          padding: px24DimenAll(context),
          decoration: tabBarChildContainerStyle2(context),
          child: Row(
            children: [
              Expanded(
                child: editProfileNotifier.countryData == AppConstants.australia
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).identificationDetails,
                        style: fairexchangeStyle(context)),
                    Visibility(
                      visible:
                      editProfileNotifier.licenseNumber.isEmpty &&
                          editProfileNotifier
                              .medicareCardNumber.isEmpty &&
                          editProfileNotifier.passportNumber.isEmpty,
                      child: Container(
                          height: 100,
                          child: Center(
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 0.0),
                                child: Text(
                                    AppConstants.noIdentificationDetailsAreUploaded),
                              ))),
                    ),
                    Visibility(
                        visible:
                        editProfileNotifier.licenseNumber.isNotEmpty,
                        child: Column(
                          children: [
                            sizedBoxHeight24(context),
                            buildDrivingLicenceData(
                                context, editProfileNotifier),
                          ],
                        )),
                    Visibility(
                        visible: editProfileNotifier
                            .medicareCardNumber.isNotEmpty,
                        child: Column(
                          children: [
                            sizedBoxHeight15(context),
                            buildMedicareData(
                                context, editProfileNotifier),
                          ],
                        )),
                    Visibility(
                        visible:
                        editProfileNotifier.passportNumber.isNotEmpty,
                        child: Column(
                          children: [
                            sizedBoxHeight15(context),
                            buildPassportData(
                                context, editProfileNotifier),
                          ],
                        ))
                  ],
                )
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).documentsUploaded,
                      style: fairexchangeStyle(context),
                    ),
                    sizedBoxHeight24(context),
                    ListView.separated(
                      primary: true,
                      separatorBuilder:
                          (BuildContext context, int index) {
                        return sizedBoxHeight10(context);
                      },
                      shrinkWrap: true,
                      itemCount:
                      editProfileNotifier.documentListData.length,
                      itemBuilder: (context, index) {
                        return checkProofData(context,
                            heading: editProfileNotifier
                                .documentListData[index]
                                .documentType, onTap: () async {
                              await editProfileNotifier.viewDocumentData(
                                  editProfileNotifier
                                      .documentListData[index].documentId!,
                                  context);
                              showImageProof(
                                editProfileNotifier
                                    .documentListData[index].documentType!,
                                context,
                                editProfileNotifier,
                                editProfileNotifier.dataPNGType,
                              );
                            });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  //Edit Profile View Or View Profile Data
  Widget editProfile(
      BuildContext context, EditProfileNotifier editProfileNotifier) {
    return PageScaffold(
      title: S.of(context).editProfile,
      appbar: PreferredSize(
        preferredSize: Size.fromHeight(AppConstants.appBarHeight),
        child: Padding(
          padding: kIsWeb ? isMobile(context) || isTab(context)
              ? px15DimenTop(context)
              : px30DimenTopOnly(context) : isMobileSDK(context) || isTabSDK(context)
              ? px15DimenTop(context)
              : px30DimenTopOnly(context),
          child: buildAppBar(
              context,
              Text.rich(
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      MyApp.navigatorKey.currentState!.maybePop();
                    },
                  text: S.of(context).userProfile,
                  style: appBarWelcomeText(context).copyWith(
                      color: oxfordBlueTint400,
                      fontSize: kIsWeb ? isMobile(context) ? getScreenWidth(context)<300?13:getScreenWidth(context)<330?14:16 : 16 :  isMobileSDK(context) ? getScreenWidth(context)<300?13:getScreenWidth(context)<330?14:16 : 16),
                  children: <TextSpan>[
                    TextSpan(
                      text: kIsWeb
                          ? getScreenWidth(context) > 400
                          ? !editProfileNotifier.isUserNotVerified ? "/ " + S.of(context).viewProfile : "/ " + S.of(context).editProfile
                          : !editProfileNotifier.isUserNotVerified ? '\n' + "/ " + S.of(context).viewProfile : '\n' + "/ " + S.of(context).editProfile
                          :  screenSizeWidth > 400
                          ? !editProfileNotifier.isUserNotVerified ? "/ " + S.of(context).viewProfile : "/ " + S.of(context).editProfile
                          : !editProfileNotifier.isUserNotVerified ? '\n' + "/ " + S.of(context).viewProfile : '\n' + "/ " + S.of(context).editProfile,
                      style: appBarWelcomeText(context).copyWith(
                          color: oxfordBlueTint400,
                          fontSize: kIsWeb ? isMobile(context) ? getScreenWidth(context)<300?13:getScreenWidth(context)<330?14:16 : 16 :  isMobileSDK(context) ? getScreenWidth(context)<300?13:getScreenWidth(context)<330?14:16 : 16),
                    ),
                  ],
                ),
              ),
              backCondition: editProfileNotifier.editNavigation == false
                  ? null
                  : () {
                MyApp.navigatorKey.currentState!.maybePop();
              }),
        ),
      ),
      color: bankDetailsBackground,
      body: SingleChildScrollView(
        primary: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonSizedBoxHeight20(context),
            Padding(
              padding: px24HorizontalSymmetric(context),
              child: buildHeaderText(context,editProfileNotifier),
            ),
            commonSizedBoxHeight20(context),
            Padding(
              padding: px24HorizontalSymmetric(context),
              child: Divider(
                thickness: 1,
              ),
            ),
            Form(
              key: editProfileNotifier.formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: kIsWeb
                        ? isMobile(context)
                        ? getScreenWidth(context) * 0.10
                        : getScreenWidth(context) < 1060
                        ? getScreenWidth(context) * 0.20
                        : getScreenWidth(context) * 0.15
                        : isMobileSDK(context)
                        ? screenSizeWidth * 0.10
                        : screenSizeWidth < 1060
                        ? screenSizeWidth * 0.20
                        : screenSizeWidth * 0.15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible:
                      editProfileNotifier.countryData == AustraliaName  ||  editProfileNotifier.countryData == AppConstants.hongKong || editProfileNotifier.isDigitalKyc,
                      child: buildSalutationText(context),),
                    commonSizedBoxHeight10(context),
                    Visibility(
                      visible:
                      editProfileNotifier.countryData == AustraliaName  ||  editProfileNotifier.countryData == AppConstants.hongKong || editProfileNotifier.isDigitalKyc,
                      child: buildSalutationDropDownBox(context, editProfileNotifier),),
                    commonSizedBoxHeight20(context),
                    Visibility(
                        visible:
                        editProfileNotifier.countryData == SingaporeName,
                        child: buildNameRow(editProfileNotifier, context)),
                    Visibility(
                        visible:
                        editProfileNotifier.countryData != SingaporeName,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildHeading(context,
                                title: S.of(context).firstNameWeb),
                            commonSizedBoxHeight10(context),
                            buildFirstName(editProfileNotifier, context),
                            commonSizedBoxHeight20(context),
                            buildHeading(context,
                                title: S.of(context).middleName),
                            commonSizedBoxHeight10(context),
                            buildMiddleName(editProfileNotifier, context),
                            commonSizedBoxHeight20(context),
                            buildHeading(context,
                                title: S.of(context).lastNameWeb),
                            commonSizedBoxHeight10(context),
                            buildLastName(editProfileNotifier, context),
                            commonSizedBoxHeight20(context),
                          ],
                        )),
                    Visibility(
                        visible:
                        editProfileNotifier.countryData != SingaporeName,
                        child: kIsWeb
                            ? isTab(context) || getScreenWidth(context) < 1100
                            ? buildDOBAndNationality(
                            editProfileNotifier, notifier!, context)
                            : buildDOBAndNationalityTab(
                            editProfileNotifier, context)
                            : isTabSDK(context) || screenSizeWidth < 1100
                            ? buildDOBAndNationality(
                            editProfileNotifier, notifier!, context)
                            : buildDOBAndNationalityTab(
                            editProfileNotifier, context)),
                    Visibility(
                      visible:
                      editProfileNotifier.countryData ==AustraliaName,
                      child: commonSizedBoxHeight20(context),),
                    Visibility(
                      visible:
                      editProfileNotifier.countryData !=AustraliaName,
                      child: commonSizedBoxHeight20(context),),
                    buildHeading(context, title: S.of(context).esidenceStatus),
                    commonSizedBoxHeight10(context),
                    buildResidenceDropDownBox(editProfileNotifier, context),
                    commonSizedBoxHeight30(context),
                    Visibility(
                        visible:
                        editProfileNotifier.countryData == SingaporeName,
                        child: kIsWeb ? isTab(context) || getScreenWidth(context) < 1100
                            ? buildEmailAndMobileTextFieldTab(
                            editProfileNotifier, context)
                            : buildEmailAndMobileTextField(
                            editProfileNotifier, context) :  isTabSDK(context) || screenSizeWidth < 1100
                            ? buildEmailAndMobileTextFieldTab(
                            editProfileNotifier, context)
                            : buildEmailAndMobileTextField(
                            editProfileNotifier, context)),
                    commonSizedBoxHeight30(context),
                    buildAddressText(context),
                    commonSizedBoxHeight10(context),
                    Visibility(
                        visible:
                        editProfileNotifier.countryData == HongKongName,
                        child: flatAndFloorNo(editProfileNotifier, context)),
                    Visibility(
                        visible:
                        editProfileNotifier.countryData == SingaporeName,
                        child:
                        editProfileNotifier.isJohorAddress
                            ? buildSingaporeAddressField(
                            editProfileNotifier, context)
                            : buildJohorAddressField(
                            editProfileNotifier, context)
                    ),
                    Visibility(
                        visible:
                        editProfileNotifier.countryData == AustraliaName,
                        child: !editProfileNotifier.isManualSearch
                            ? buildAutomaticAddressField(
                            editProfileNotifier, context)
                            : buildManualAddressField(
                            editProfileNotifier, context)),
                    Visibility(
                        visible:
                        editProfileNotifier.countryData == HongKongName,
                        child: buildJohorAddressFieldHk(
                            editProfileNotifier, context)),
                    Visibility(
                        visible:
                        editProfileNotifier.countryData == HongKongName,
                        child: kIsWeb
                            ? isTab(context) || getScreenWidth(context) < 1100
                            ? nameOFVillageAndCountryColumn(
                            editProfileNotifier, context)
                            : nameOFVillageAndCountryRow(
                            editProfileNotifier, context)
                            : isTabSDK(context) || screenSizeWidth < 1100
                            ? nameOFVillageAndCountryColumn(
                            editProfileNotifier, context)
                            : nameOFVillageAndCountryRow(
                            editProfileNotifier, context)),
                    Visibility(
                        visible:
                        editProfileNotifier.countryData != HongKongName,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            commonSizedBoxHeight40(context),
                            buildEmployerNameText(context),
                            commonSizedBoxHeight15(context),
                            buildEmployerTextField(
                                editProfileNotifier, context),
                          ],
                        )),
                    commonSizedBoxHeight20(context),
                    buildOccupationText(context),
                    commonSizedBoxHeight12(context),
                    buildOccupationDropdownBox(editProfileNotifier, context),
                    commonSizedBoxHeight20(context),
                    Visibility(
                        visible:
                        editProfileNotifier.selectedOccupation == "Others",
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildHeading(context, title: "Others"),
                            commonSizedBoxHeight10(context),
                            buildOccupationOthersField(
                                editProfileNotifier, context),
                            commonSizedBoxHeight10(context),
                          ],
                        )),
                    Visibility(
                        visible:
                        editProfileNotifier.countryData == AustraliaName,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildAnnualIncomeText(context),
                            commonSizedBoxHeight12(context),
                            buildEstimatedAnnualIncomeDropdownBox(
                                context, editProfileNotifier),
                            commonSizedBoxHeight45(context),
                          ],
                        )),
                    commonSizedBoxHeight50(context),
                    Visibility(
                        visible:
                        editProfileNotifier.countryData == AustraliaName,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            commonSizedBoxHeight12(context),
                            buildRadioButtons(context, editProfileNotifier),
                            commonSizedBoxHeight50(context),
                          ],
                        )),
                    editProfileNotifier.isUserNotVerified == false
                        ? Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: kIsWeb
                              ? getScreenWidth(context) < 320
                              ? getScreenWidth(context) * 0.20
                              : getScreenWidth(context) < 350
                              ? getScreenWidth(context) * 0.24
                              : isMobile(context)
                              ? getScreenWidth(context) * 0.3
                              : isTab(context)
                              ? getScreenWidth(context) *
                              0.2
                              : getScreenWidth(context) *
                              0.12
                              : screenSizeWidth < 320
                              ? screenSizeWidth * 0.20
                              : screenSizeWidth < 350
                              ? screenSizeWidth * 0.24
                              : isMobileSDK(context)
                              ? screenSizeWidth * 0.3
                              : isTabSDK(context)
                              ? screenSizeWidth * 0.2
                              : screenSizeWidth * 0.12),
                      child: buildButton(context,
                          name: S.of(context).back, onPressed: () async {
                            await SharedPreferencesMobileWeb.instance
                                .getCountry(country)
                                .then((value) async {
                              Navigator.pushNamed(context, editProfileRoute);
                            });
                          }, fontColor: hanBlue, color: hanBlueTint200),
                    )
                        : buildButtons(editProfileNotifier, context),
                    commonSizedBoxHeight100(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //First Name
  Widget buildFirstName(EditProfileNotifier editProfileNotifier, context) {
    return Selector<EditProfileNotifier, TextEditingController>(
        builder: (context, firstNameController, child) {
          return CommonTextField(
            containerColor: transparent,
            onChanged: (val) {
              handleInteraction(context);
            },
            controller: firstNameController,
            fillColor: editProfileNotifier.isUserNotVerified
                ? null
                : Colors.grey.shade200,
            isEnable:
                editProfileNotifier.isUserNotVerified == false ? false : true,
            width: dropdownWidth,
            validatorEmptyErrorText: 'Enter first name',
            hintStyle: hintStyle(context),
          );
        },
        selector: (buildContext, editProfileNotifier) =>
            editProfileNotifier.firstNameController);
  }

  //Last Name
  Widget buildLastName(EditProfileNotifier editProfileNotifier, context) {
    return Selector<EditProfileNotifier, TextEditingController>(
        builder: (context, lastNameController, child) {
          return CommonTextField(
            containerColor: transparent,
            onChanged: (val) {
              handleInteraction(context);
            },
            controller: lastNameController,
            fillColor: editProfileNotifier.isUserNotVerified
                ? null
                : Colors.grey.shade200,
            isEnable:

                editProfileNotifier.isUserNotVerified == false ? false : true,
            width: dropdownWidth,
            validatorEmptyErrorText: 'Enter last name',
            hintStyle: hintStyle(context),
          );
        },
        selector: (buildContext, editProfileNotifier) =>
            editProfileNotifier.lastNameController);
  }

  //Middel Name
  Widget buildMiddleName(
    EditProfileNotifier editProfileNotifier,
    BuildContext context,
  ) {
    return Selector<EditProfileNotifier, TextEditingController>(
        builder: (context, middleNameController, child) {
          return CommonTextField(
            onChanged: (val) {
              handleInteraction(context);
            },
            fillColor: editProfileNotifier.isUserNotVerified
                ? null
                : Colors.grey.shade200,
            isEnable:
                editProfileNotifier.isUserNotVerified == false ? false : true,
            controller: middleNameController,
            width: dropdownWidth,
            hintStyle: hintStyle(context),
          );
        },
        selector: (buildContext, editProfileNotifier) =>
            editProfileNotifier.middleNameController);
  }

  //Driving Licence Data
  Widget buildDrivingLicenceData(
      BuildContext context, EditProfileNotifier editProfileNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppConstants.drivingLicense,
          style: fairexchangeStyle(context),
        ),
        sizedBoxHeight15(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(
              S.of(context).licenseNumber + ":",
              style: textSpan1(context),
            )),
            Spacer(),
            Expanded(
                child: Text(
              editProfileNotifier.licenseNumber,
              style: blackTextStyle16(context),
            )),
          ],
        ),
        sizedBoxHeight10(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(
              S.of(context).dateOfExpiry + ":",
              style: textSpan1(context),
            )),
            Spacer(),
            Expanded(
                child: Text(
              editProfileNotifier.dateOfExpiryLicence,
              style: blackTextStyle16(context),
            )),
          ],
        ),
        sizedBoxHeight10(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(
              S.of(context).issuingAuthority + ":",
              style: textSpan1(context),
            )),
            Spacer(),
            Expanded(
                child: Text(
              editProfileNotifier.selectedIssuingAuthority,
              style: blackTextStyle16(context),
            )),
          ],
        ),
      ],
    );
  }

  //Medicare Data
  Widget buildMedicareData(
      BuildContext context, EditProfileNotifier editProfileNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppConstants.medicareDetails,
          style: fairexchangeStyle(context),
        ),
        sizedBoxHeight15(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(
              S.of(context).cardNumber + ":",
              style: textSpan1(context),
            )),
            Spacer(),
            Expanded(
                child: Text(
              editProfileNotifier.medicareCardNumber,
              style: blackTextStyle16(context),
            )),
          ],
        ),
        sizedBoxHeight10(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(
              S.of(context).dateOfExpiry + ":",
              style: textSpan1(context),
            )),
            Spacer(),
            Expanded(
                child: Text(
              editProfileNotifier.dateOfExpiryMedicare,
              style: blackTextStyle16(context),
            )),
          ],
        ),
        sizedBoxHeight10(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(
              AppConstants.cardType,
              style: textSpan1(context),
            )),
            Spacer(),
            Expanded(
                child: Text(
              editProfileNotifier.medicareCardType,
              style: blackTextStyle16(context),
            )),
          ],
        ),
        sizedBoxHeight10(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(
              S.of(context).individualReferenceNumber + ":",
              style: textSpan1(context),
            )),
            Spacer(),
            Expanded(
                child: Text(
              editProfileNotifier.medicareIndividualReferenceNumber,
              style: blackTextStyle16(context),
            )),
          ],
        ),
      ],
    );
  }

  //Passport Data
  Widget buildPassportData(
      BuildContext context, EditProfileNotifier editProfileNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppConstants.passportDetails,
          style: fairexchangeStyle(context),
        ),
        sizedBoxHeight15(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(
              S.of(context).passportNumber + ":",
              style: textSpan1(context),
            )),
            Spacer(),
            Expanded(
                child: Text(
              editProfileNotifier.passportNumber,
              style: blackTextStyle16(context),
            )),
          ],
        ),
        sizedBoxHeight10(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(
              S.of(context).dateOfExpiry + ":",
              style: textSpan1(context),
            )),
            Spacer(),
            Expanded(
                child: Text(
              editProfileNotifier.dateOfExpiryPassport,
              style: blackTextStyle16(context),
            )),
          ],
        ),
        sizedBoxHeight10(context),
      ],
    );
  }

  //View Button To Show User Uploaded Data
  Widget checkProofData(BuildContext context, {String? heading, onTap}) {
    return isMobile(context)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 3.5),
                child: Row(
                  children: [
                    Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        color: success,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.done,
                          size: 12,
                          color: white,
                        ),
                      ),
                    ),
                    sizedBoxWidth5(context),
                    Expanded(
                      child: Text(
                        heading!,
                        style: blackTextStyle16(context),
                      ),
                    )
                  ],
                ),
              ),
              sizedBoxHeight8(context),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  S.of(context).view,
                  style: seeAllActivityText(context),
                ),
              ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 3.5),
                child: Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    color: success,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.done,
                      size: 12,
                      color: white,
                    ),
                  ),
                ),
              ),
              sizedBoxWidth8(context),
              Expanded(
                child: Text(
                  heading!,
                  style: blackTextStyle16(context),
                ),
              ),
              sizedBoxWidth8(context),
              Expanded(
                child: GestureDetector(
                  onTap: onTap,
                  child: Text(
                    S.of(context).view,
                    style: seeAllActivityText(context),
                  ),
                ),
              ),
            ],
          );
  }

  //Heading Text
  Widget buildHeadingAndText(
      BuildContext context, String heading, String text) {
    return kIsWeb
        ? getScreenWidth(context) >= 400
            ? Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        heading,
                        style: textSpan1(context),
                      ),
                      sizedBoxHeight8(context),
                      Text(
                        text,
                        style: blackTextStyle16(context),
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    heading,
                    style: textSpan1(context),
                  ),
                  sizedBoxHeight8(context),
                  Text(
                    text,
                    style: blackTextStyle16(context),
                  ),
                ],
              )
        : screenSizeWidth >= 400
            ? Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      heading,
                      style: textSpan1(context),
                    ),
                    sizedBoxHeight8(context),
                    Text(
                      text,
                      style: blackTextStyle16(context),
                    ),
                  ],
                ),
              ),
            )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    heading,
                    style: textSpan1(context),
                  ),
                  sizedBoxHeight8(context),
                  Text(
                    text,
                    style: blackTextStyle16(context),
                  ),
                ],
              );
  }

  Widget buildHeaderText(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return buildText(
        text: !editProfileNotifier.isUserNotVerified ? S.of(context).viewProfile : S.of(context).editProfile,
        fontSize: AppConstants.twenty,
        fontColor: oxfordBlue,
        fontWeight: FontWeight.w700);
  }

  //Salutation Data
  Widget buildSalutationText(BuildContext context) {
    return buildHeading(context, title: S.of(context).salutation);
  }

  //Salutation DropDown
  Widget buildSalutationDropDownBox(
      BuildContext context, EditProfileNotifier editProfileNotifier) {
    return CustomizeDropdown(context,
        validation: (value) {
          if (value == null || value.isEmpty) {
            return 'Salutation is required';
          }
          return null;
        },
        dropdownItems: editProfileNotifier.salutationListData,
        controller: editProfileNotifier.salutationController,
        optionsViewBuilder: (BuildContext context,
            AutocompleteOnSelected onSelected, Iterable options) {
      return buildDropDownContainer(
        context,
        options: options,
        onSelected: onSelected,
        dropdownData: editProfileNotifier.salutationListData,
        dropDownWidth: dropdownWidth,
        dropDownHeight:
            options.first == AppConstants.noDataFound ? 150 : options.length * 50,
      );
    },
        width: dropdownWidth,
        fillColor:
            editProfileNotifier.isUserNotVerified ? null : Colors.grey.shade200,
        isEnable: editProfileNotifier.isUserNotVerified != false);
  }

  //Name
  Widget buildNameRow(
      EditProfileNotifier editProfileNotifier, BuildContext context) {
    return commonRowField(
      context,
      editProfileNotifier,
      header1: S.of(context).firstNameWeb,
      header2: S.of(context).lastNameWeb,
      controller1: editProfileNotifier.firstNameController,
      controller2: editProfileNotifier.lastNameController,
      keyboardType1: TextInputType.text,
      keyboardType2: TextInputType.text,
      hintText1: AppConstants.john,
      hintText2: AppConstants.doe,
      validationRequired1: AppConstants.enterFirstName,
      validationRequired2: AppConstants.enterLastName,
    );
  }

  //Residence DropDown
  Widget buildResidenceDropDownBox(
      EditProfileNotifier editProfileNotifier, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => CustomizeDropdown(context,
          validation: (value) {
            if (value == null || value.isEmpty) {
              return 'Residence Status is required';
            }
            return null;
          },
          dropdownItems: editProfileNotifier.residenceStatus,
          controller: editProfileNotifier.residenceController,
          optionsViewBuilder: (BuildContext context,
              AutocompleteOnSelected onSelected, Iterable options) {
            return buildDropDownContainer(
              context,
              options: options,
              onSelected: onSelected,
              dropdownData: editProfileNotifier.residenceStatus,
              dropDownWidth: dropdownWidth,
              dropDownHeight: options.first == AppConstants.noDataFound
                  ? 150
                  : options.length < 5
                      ? options.length * 50
                      : options.length * 30,
            );
          },
          width: dropdownWidth,
          onSelected: (value) {
            handleInteraction(context);
            DropdownResponseResidence data = value as DropdownResponseResidence;
            editProfileNotifier.selectedResidence = data.value!;
          },
          onSubmitted: (value) {
            handleInteraction(context);
            DropdownResponseResidence data = value as DropdownResponseResidence;
            editProfileNotifier.selectedResidence = data.value!;
          },
          fillColor: editProfileNotifier.isUserNotVerified
              ? null
              : Colors.grey.shade200,
          isEnable: editProfileNotifier.isUserNotVerified != false),
    );
  }

  //Email and Mobile TextField
  Widget buildEmailAndMobileTextField(
      EditProfileNotifier editProfileNotifier, BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeading(context, title: S.of(context).emailAddressWeb),
            commonSizedBoxHeight10(context),
            Selector<EditProfileNotifier, TextEditingController>(
                builder: (context, emailController, child) {
                  return CommonTextField(
                    onChanged: (val) {
                      handleInteraction(context);
                    },
                    fillColor: editProfileNotifier.isUserNotVerified
                        ? null
                        : Colors.grey.shade200,
                    isEnable: editProfileNotifier.isUserNotVerified == false
                        ? false
                        : true,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp("[ A-Za-z0-9_@./#&+-]")),
                    ],
                    containerColor: Colors.transparent,
                    helperText: '',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    width: kIsWeb ? isTab(context) ? getScreenWidth(context) * 0.29 : getScreenWidth(context) * 0.22 : isTabSDK(context) ? screenSizeWidth * 0.29 : screenSizeWidth * 0.22,
                    hintText: AppConstants.sampleMail,
                    hintStyle: hintStyle(context),
                    validatorEmptyErrorText: AppConstants.emailIsRequired,
                    isEmailValidator: true,
                  );
                },
                selector: (buildContext, editProfileNotifier) =>
                    editProfileNotifier.emailController)
          ],
        ),
        commonSizedBoxWidth20(context),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeading(context, title: S.of(context).mobileNumberWeb),
            commonSizedBoxHeight10(context),
            Selector<EditProfileNotifier, TextEditingController>(
                builder: (context, mobileNumberController, child) {
                  return CommonTextField(
                    onChanged: (val) {
                      handleInteraction(context);
                    },
                    containerColor: Colors.transparent,
                    fillColor: editProfileNotifier.isUserNotVerified
                        ? null
                        : Colors.grey.shade200,
                    isEnable: editProfileNotifier.isUserNotVerified == false
                        ? false
                        : true,
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
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    ],
                  );
                },
                selector: (buildContext, editProfileNotifier) =>
                    editProfileNotifier.mobileNumberController)
          ],
        )
      ],
    );
  }

  //Flat and Floor No TextField
  Widget flatAndFloorNo(
      EditProfileNotifier editProfileNotifier, BuildContext context) {
    return Selector<EditProfileNotifier, TextEditingController>(
        builder: (context, flatAndFloorNoController, child) {
          return CommonTextField(
            containerColor: transparent,
            onChanged: (val) {
              handleInteraction(context);
            },
            controller: flatAndFloorNoController,
            fillColor: editProfileNotifier.isUserNotVerified
                ? null
                : Colors.grey.shade200,
            isEnable:
                editProfileNotifier.isUserNotVerified == false ? false : true,
            hintText: S.of(context).flatAndFloorNumber,
            width: dropdownWidth,
            validatorEmptyErrorText: AppConstants.FlatAndFloorNumberIsRequires,
            hintStyle: hintStyle(context),
          );
        },
        selector: (buildContext, editProfileNotifier) =>
            editProfileNotifier.flatAndFloorNoController);
  }

  //Email and Mobile TextField For Tab
  Widget buildEmailAndMobileTextFieldTab(
      EditProfileNotifier editProfileNotifier, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeading(context, title: S.of(context).emailAddressWeb),
        commonSizedBoxHeight10(context),
        Selector<EditProfileNotifier, TextEditingController>(
            builder: (context, emailController, child) {
              return CommonTextField(
                onChanged: (val) {
                  handleInteraction(context);
                },
                controller: emailController,
                fillColor: editProfileNotifier.isUserNotVerified
                    ? null
                    : Colors.grey.shade200,
                isEnable: editProfileNotifier.isUserNotVerified == false
                    ? false
                    : true,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                      RegExp("[ A-Za-z0-9_@./#&+-]")),
                ],
                keyboardType: TextInputType.emailAddress,
                width: dropdownWidth,
                hintText: AppConstants.sampleMail,
                hintStyle: hintStyle(context),
                validatorEmptyErrorText: AppConstants.emailIsRequired,
                isEmailValidator: true,
              );
            },
            selector: (buildContext, editProfileNotifier) =>
                editProfileNotifier.emailController),
        commonSizedBoxHeight20(context),
        buildHeading(context, title: S.of(context).mobileNumberWeb),
        commonSizedBoxHeight10(context),
        Selector<EditProfileNotifier, TextEditingController>(
            builder: (context, mobileNumberController, child) {
              return CommonTextField(
                onChanged: (val) {
                  handleInteraction(context);
                },
                controller: mobileNumberController,
                fillColor: editProfileNotifier.isUserNotVerified
                    ? null
                    : Colors.grey.shade200,
                isEnable: editProfileNotifier.isUserNotVerified == false
                    ? false
                    : true,
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
                        width: 105,
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
                    commonSizedBoxWidth10(context),
                  ],
                ),
                validatorEmptyErrorText: mobileRequired,
                isMobileNumberValidator: true,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
              );
            },
            selector: (buildContext, editProfileNotifier) =>
                editProfileNotifier.mobileNumberController)
      ],
    );
  }

  //Auto Search TextField
  Widget buildAutomaticAddressField(
      EditProfileNotifier editProfileNotifier, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonSizedBoxHeight10(context),
        Container(
            width: dropdownWidth,
            child: Autocomplete<SearchAddressResponse>(
              optionsBuilder: (TextEditingValue textEditingValue) async {
                await editProfileNotifier
                    .getSuggestedAddress(textEditingValue.text);
                return editProfileNotifier.addressSuggestion
                    .where((SearchAddressResponse address) => address
                        .description
                        .toLowerCase()
                        .startsWith(textEditingValue.text.toLowerCase()))
                    .toList();
              },
              displayStringForOption: (SearchAddressResponse option) =>
                  option.description,
              fieldViewBuilder: (BuildContext context,
                  TextEditingController fieldTextEditingController,
                  FocusNode fieldFocusNode,
                  VoidCallback onFieldSubmitted) {
                return TextField(
                  controller: editProfileNotifier.searchAddressController,
                  focusNode: fieldFocusNode,
                  enabled: editProfileNotifier.isUserNotVerified == false
                      ? false
                      : true,
                  decoration: InputDecoration(
                    fillColor: editProfileNotifier.isUserNotVerified
                        ? Colors.white
                        : Colors.grey.shade200,
                    hintText: S.of(context).searchAddress,
                    hintStyle: hintStyle(context),
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
                    filled: true,
                    hoverColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    handleInteraction(context);
                    fieldTextEditingController.text = val;
                  },
                  style: const TextStyle(fontWeight: FontWeight.normal),
                );
              },
              onSelected: (SearchAddressResponse selection) {},
              optionsViewBuilder: (BuildContext context,
                  AutocompleteOnSelected<SearchAddressResponse> onSelected,
                  Iterable<SearchAddressResponse> options) {
                return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                        child: Container(
                            width: dropdownWidth,
                            color: Colors.white,
                            child: ListView.builder(
                                primary: true,
                                padding: EdgeInsets.all(10.0),
                                itemCount: options.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final SearchAddressResponse option =
                                      options.elementAt(index);

                                  return GestureDetector(
                                    onTap: () {
                                      onSelected(option);
                                      editProfileNotifier
                                          .searchAddressController
                                          .text = option.description;
                                    },
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.location_on_rounded,
                                        color: greyColor,
                                      ),
                                      title: Text(option.description,
                                          style: const TextStyle(
                                              color: Colors.black)),
                                    ),
                                  );
                                }))));
              },
            )),
        commonSizedBoxHeight25(context),
        buildHeading(context, title: S.of(context).unitNo),
        commonSizedBoxHeight10(context),
        CommonTextField(
          containerColor: transparent,
          width: dropdownWidth,
          hintText: S.of(context).ifApplicable,
          hintStyle: hintStyle(context),
          fillColor: editProfileNotifier.isUserNotVerified
              ? null
              : Colors.grey.shade200,
          isEnable:
              editProfileNotifier.isUserNotVerified == false ? false : true,
          controller: editProfileNotifier.unitNoController,
          keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
          ],
        ),
        commonSizedBoxHeight10(context),
      ],
    );
  }

  //Manual Address TextField
  Widget buildManualAddressField(
      EditProfileNotifier editProfileNotifier, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
            child: commonSizedBoxHeight20(context),
            visible: editProfileNotifier.isError),
        buildUnitAndBlockNo(editProfileNotifier, context),
        Visibility(
            child: commonSizedBoxHeight20(context),
            visible: editProfileNotifier.isError),
        buildStreetAndBuildingName(editProfileNotifier, context),
        commonSizedBoxHeight10(context),
        buildCityAndState(
          editProfileNotifier,
          context,
        ),
        commonSizedBoxHeight10(context),
        buildHeading(context, title: S.of(context).postalCodeWeb),
        commonSizedBoxHeight10(context),
        buildPostalCodeAus(editProfileNotifier, context),
      ],
    );
  }

  //Postal Code TextField
  Widget buildPostalCodeAus(
      EditProfileNotifier editProfileNotifier, BuildContext context) {
    return Selector<EditProfileNotifier, TextEditingController>(
        builder: (context, postalCodeController, child) {
          return getScreenWidth(context) > 570
              ? CommonTextField(
                  onChanged: (val) {
                    handleInteraction(context);
                  },
                  fillColor: editProfileNotifier.isUserNotVerified
                      ? null
                      : Colors.grey.shade200,
                  containerColor: Colors.white10,
                  isEnable: editProfileNotifier.isUserNotVerified == false
                      ? false
                      : true,
                  keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
                  controller: postalCodeController,
                  width: isMobile(context)
                      ? getScreenWidth(context) * 0.39
                      : isTab(context)
                          ? getScreenWidth(context) * 0.29
                          : null,
                  hintText: egAddress,
                  helperText: '',
                  hintStyle: hintStyle(context),
                  validatorEmptyErrorText: postalCodeisRequired,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                      RegExp("[0-9]"),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: CommonTextField(
                        onChanged: (val) {
                          handleInteraction(context);
                        },
                        fillColor: editProfileNotifier.isUserNotVerified
                            ? null
                            : Colors.grey.shade200,
                        containerColor: Colors.white10,
                        isEnable: editProfileNotifier.isUserNotVerified == false
                            ? false
                            : true,
                        keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
                        controller: postalCodeController,
                        width: isMobile(context)
                            ? getScreenWidth(context) * 0.39
                            : isTab(context)
                                ? getScreenWidth(context) * 0.29
                                : null,
                        hintText: egAddress,
                        helperText: '',
                        hintStyle: hintStyle(context),
                        validatorEmptyErrorText: postalCodeisRequired,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                            RegExp("[0-9]"),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
        },
        selector: (buildContext, editProfileNotifier) =>
            editProfileNotifier.postalCodeController);
  }

  Widget buildCityAndState(
      EditProfileNotifier editProfileNotifier, BuildContext context) {
    return getScreenWidth(context) > 570
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeading(context, title: S.of(context).city),
                  SizedBoxHeight(context, 0.01),
                  Selector<EditProfileNotifier, TextEditingController>(
                      builder: (context, cityController, child) {
                        return CommonTextField(
                          onChanged: (val) {
                            handleInteraction(context);
                          },
                          fillColor: editProfileNotifier.isUserNotVerified
                              ? null
                              : Colors.grey.shade200,
                          containerColor: Colors.white10,
                          isEnable:
                              editProfileNotifier.isUserNotVerified == false
                                  ? false
                                  : true,
                          keyboardType: TextInputType.text,
                          controller: cityController,
                          width: isMobile(context)
                              ? getScreenWidth(context) * 0.80
                              : isTab(context)
                                  ? getScreenWidth(context) * 0.29
                                  : null,
                          hintText: enterCity,
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
                      selector: (buildContext, editProfileNotifier) =>
                          editProfileNotifier.cityController),
                ],
              ),
              SizedBox(width: getScreenWidth(context) * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeading(context, title: S.of(context).stateProvince),
                  SizedBoxHeight(context, 0.01),
                  buildStateDropDown(context, editProfileNotifier),
                ],
              )
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildHeading(context, title: S.of(context).city),
                      SizedBoxHeight(context, 0.01),
                      Selector<EditProfileNotifier, TextEditingController>(
                          builder: (context, cityController, child) {
                            return CommonTextField(
                              onChanged: (val) {
                                handleInteraction(context);
                              },
                              fillColor: editProfileNotifier.isUserNotVerified
                                  ? null
                                  : Colors.grey.shade200,
                              containerColor: Colors.white10,
                              isEnable:
                                  editProfileNotifier.isUserNotVerified == false
                                      ? false
                                      : true,
                              keyboardType: TextInputType.text,
                              controller: cityController,
                              width: isMobile(context)
                                  ? getScreenWidth(context) * 0.80
                                  : isTab(context)
                                      ? getScreenWidth(context) * 0.29
                                      : null,
                              hintText: enterCity,
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
                          selector: (buildContext, editProfileNotifier) =>
                              editProfileNotifier.cityController),
                    ],
                  ),
                ],
              ),
              SizedBox(width: getScreenWidth(context) * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeading(context, title: S.of(context).stateProvince),
                  SizedBoxHeight(context, 0.01),
                  buildStateDropDown(context, editProfileNotifier),
                ],
              )
            ],
          );
  }

  //Address Heading
  Widget buildAddressText(BuildContext context) {
    return buildText(
        text: S.of(context).address,
        fontSize: AppConstants.sixteen,
        fontWeight: FontWeight.w600);
  }

  //Address Info
  Widget buildAddressInfoText(BuildContext context) {
    return buildText(
        text: S.of(context).simplyenteryourpostalcode,
        fontColor: oxfordBlueTint400,
        fontWeight: AppFont.fontWeightRegular);
  }

  //Postal Code Field
  Widget buildPostalCode(
      EditProfileNotifier editProfileNotifier, BuildContext context) {
    return editProfileNotifier.isUserNotVerified == false
        ?         Selector<EditProfileNotifier, TextEditingController>(
        builder: (context, postalCodeController, child) {
          return CommonTextField(
            onChanged: (val) {
              handleInteraction(context);
            },
            fillColor: editProfileNotifier.isUserNotVerified
                ? null
                : Colors.grey.shade200,
            isEnable: editProfileNotifier.isUserNotVerified == false
                ? false
                : true,
            keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
            controller: postalCodeController,
            containerColor: Colors.transparent,
            width:dropdownWidth,
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
        selector: (buildContext, editProfileNotifier) =>
        editProfileNotifier.postalCodeController) : Row(
      children: [
        Selector<EditProfileNotifier, TextEditingController>(
            builder: (context, postalCodeController, child) {
              return CommonTextField(
                onChanged: (val) {
                  handleInteraction(context);
                },
                fillColor: editProfileNotifier.isUserNotVerified
                    ? null
                    : Colors.grey.shade200,
                isEnable: editProfileNotifier.isUserNotVerified == false
                    ? false
                    : true,
                keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
                controller: postalCodeController,
                containerColor: Colors.transparent,
                width:kIsWeb ? isMobile(context)
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
            selector: (buildContext, editProfileNotifier) =>
                editProfileNotifier.postalCodeController),
        commonSizedBoxWidth20(context),
        Column(
          children: [
            buildButton(context,
                width: kIsWeb
                    ? isMobile(context)
                        ? getScreenWidth(context) * 0.39
                        : isTab(context)
                            ? getScreenWidth(context) * 0.29
                            : getScreenWidth(context) * 0.22
                    : isMobileSDK(context)
                        ? screenSizeWidth * 0.39
                        : isTabSDK(context)
                            ? screenSizeWidth * 0.29
                            : screenSizeWidth * 0.22,
                height: 50,
                onPressed: editProfileNotifier.isUserNotVerified
                    ? () {
                        editProfileNotifier.getSGPostCodeAddress(
                            editProfileNotifier.postalCodeController.text);
                      }
                    : null,
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

  //Unit No and Block No TextField
  Widget buildUnitAndBlockNo(
      EditProfileNotifier editProfileNotifier, BuildContext context) {
    return commonRowField(
      context,
      editProfileNotifier,
      header1: S.of(context).unitNoWeb,
      header2: S.of(context).streetNumber,
      controller1: editProfileNotifier.unitNoController,
      controller2: editProfileNotifier.streetNumberController,
      hintText1: eg20,
      hintText2: eg20,
      validationRequired1: unitNumberIsRequired,
      validationRequired2: streetNumberIsrequired,
      inputFormat1: "[ A-Za-z0-9_@./#&+-]",
      inputFormat2: "[ A-Za-z0-9_@./#&+-]",
      keyboardType1: TextInputType.numberWithOptions(decimal: true,signed: true),
      keyboardType2: TextInputType.numberWithOptions(decimal: true,signed: true),
    );
  }

  // Name Village and Country TextField
  Widget nameOFVillageAndCountryColumn(
      EditProfileNotifier editProfileNotifier, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeading(context, title: S.of(context).nameOfVillageTown),
        commonSizedBoxHeight10(context),
        Selector<EditProfileNotifier, TextEditingController>(
            builder: (context, nameOfVillageController, child) {
              return CommonTextField(
                containerColor: transparent,
                onChanged: (val) {
                  handleInteraction(context);
                },
                  fillColor:
                  editProfileNotifier.isUserNotVerified ? null : Colors.grey.shade200,
                  isEnable: editProfileNotifier.isUserNotVerified != false,
                controller: nameOfVillageController,
                keyboardType: TextInputType.text,
                width: dropdownWidth,
                hintStyle: hintStyle(context),
                validatorEmptyErrorText: buildingNameIsRequired,
              );
            },
            selector: (buildContext, editProfileNotifier) =>
                editProfileNotifier.nameOfVillageController),
        commonSizedBoxHeight20(context),
        buildHeading(context, title: AppConstants.region),
        commonSizedBoxHeight10(context),
        buildRegionDropDown(context, editProfileNotifier,
            width: dropdownWidth,
            dropdownWidth: dropdownWidth),
      ],
    );
  }

  // Name Village and Country TextField
  Widget nameOFVillageAndCountryRow(
      EditProfileNotifier editProfileNotifier, BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeading(context, title: S.of(context).nameOfVillageTown),
            commonSizedBoxHeight10(context),
            Selector<EditProfileNotifier, TextEditingController>(
                builder: (context, nameOfVillageController, child) {
                  return CommonTextField(
                    containerColor: transparent,
                    onChanged: (val) {
                      handleInteraction(context);
                    },
                    controller: nameOfVillageController,
                    fillColor: editProfileNotifier.isUserNotVerified
                        ? null
                        : Colors.grey.shade200,
                    isEnable: editProfileNotifier.isUserNotVerified == false
                        ? false
                        : true,
                    keyboardType: TextInputType.text,
                    width: kIsWeb ? isTab(context) ? getScreenWidth(context) * 0.29 : getScreenWidth(context) * 0.22 : isTabSDK(context) ? screenSizeWidth * 0.29 : screenSizeWidth * 0.22,
                    hintStyle: hintStyle(context),
                    validatorEmptyErrorText: buildingNameIsRequired,
                  );
                },
                selector: (buildContext, editProfileNotifier) =>
                    editProfileNotifier.nameOfVillageController),
          ],
        ),
        commonSizedBoxWidth20(context),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeading(context, title: AppConstants.region),
            commonSizedBoxHeight10(context),
            buildRegionDropDown(
              context,
              editProfileNotifier,
              width: kIsWeb ? isTab(context) ? getScreenWidth(context) * 0.29 : getScreenWidth(context) * 0.22 : isTabSDK(context) ? screenSizeWidth * 0.29 : screenSizeWidth * 0.22,
              dropdownWidth: kIsWeb ? isTab(context) ? getScreenWidth(context) * 0.29 : getScreenWidth(context) * 0.22 : isTabSDK(context) ? screenSizeWidth * 0.29 : screenSizeWidth * 0.22,
            ),
          ],
        )
      ],
    );
  }

  //Address Info Text HK Flow
  Widget buildAddressInfoTextHK(
      EditProfileNotifier editProfileNotifier, BuildContext context) {
    return buildText(
        text: S.of(context).enterNAForBuildingName,
        fontColor: oxfordBlueTint400,
        fontWeight: AppFont.fontWeightRegular);
  }

  //Address Field
  Widget buildJohorAddressFieldHk(
      EditProfileNotifier editProfileNotifier, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sizedBoxHeight10(context),
        commonSizedBoxHeight20(context),
        Visibility(
            child: commonSizedBoxHeight20(context),
            visible: editProfileNotifier.isError),
        buildUnitAndBlockNoHK(
          editProfileNotifier,
          context,
        ),
        Visibility(
            child: commonSizedBoxHeight20(context),
            visible: editProfileNotifier.isError),
      ],
    );
  }

  //Unit and Block No HK Flow
  Widget buildUnitAndBlockNoHK(
      EditProfileNotifier editProfileNotifier, BuildContext context) {
    return commonRowField(
      context,
      editProfileNotifier,
      header1: S.of(context).buildingName,
      header2: S.of(context).buildingNumber,
      controller1: editProfileNotifier.buildingNameController,
      controller2: editProfileNotifier.buildingNumberControlller,
      validationRequired1: buildingNameIsRequired,
      validationRequired2: buildingNumberIsrequired,
      inputFormat2: "[0-9]",
      keyboardType1: TextInputType.text,
      keyboardType2: TextInputType.text,
    );
  }

  //Street and Building Name
  Widget buildStreetAndBuildingName(
      EditProfileNotifier editProfileNotifier, BuildContext context) {
    return commonRowField(
      context,
      editProfileNotifier,
      header1: S.of(context).streetNameWeb,
      header2: S.of(context).suburb,
      controller1: editProfileNotifier.streetNameController,
      controller2: editProfileNotifier.suburbController,
      hintText1: streetName,
      hintText2: suburbName,
      validationRequired1: streetNameIsRequired,
      validationRequired2: suburbIsRequired,
    );
  }

  //Employer Name TextField
  Widget buildEmployerNameText(BuildContext context) {
    return buildText(
        text: S.of(context).employerNameWeb,
        fontSize: AppConstants.sixteen,
        fontWeight: AppFont.fontWeightSemiBold);
  }

  //Employer Name Info
  Widget buildEmployerNameInfo(BuildContext context) {
    return buildText(
        text: S.of(context).employerNameToVerify,
        fontColor: oxfordBlueTint400,
        fontWeight: AppFont.fontWeightRegular);
  }

  //Employer TextField
  Widget buildEmployerTextField(
      EditProfileNotifier editProfileNotifier, BuildContext context) {
    return Selector<EditProfileNotifier, TextEditingController>(
        builder: (context, employerNameController, child) {
          return CommonTextField(
              containerColor: transparent,
              onChanged: (val) {
                handleInteraction(context);
              },
              fillColor: editProfileNotifier.isUserNotVerified
                  ? null
                  : Colors.grey.shade200,
              isEnable:
                  editProfileNotifier.isUserNotVerified == false ? false : true,
              controller: employerNameController,
              hintText: S.of(context).employerName,
              hintStyle: hintStyle(context),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
              ],
              width: dropdownWidth);
        },
        selector: (buildContext, editProfileNotifier) =>
            editProfileNotifier.employerNameController);
  }

  //Annual Income Dropdown
  Widget buildEstimatedAnnualIncomeDropdownBox(
      BuildContext context, EditProfileNotifier editProfileNotifier) {
    return CustomizeDropdown(context,
        validation: (value) {
          if (value == null || value.isEmpty) {
            return 'Estimate Income is required';
          }
          return null;
        },
        dropdownItems: editProfileNotifier.annualIncomeListData,
        controller: editProfileNotifier.estimatedIncomeController,
        optionsViewBuilder: (BuildContext context,
            AutocompleteOnSelected onSelected, Iterable options) {
          return buildDropDownContainer(
            context,
            options: options,
            onSelected: onSelected,
            dropdownData: editProfileNotifier.annualIncomeListData,
            dropDownWidth: dropdownWidth,
            dropDownHeight: options.first == AppConstants.noDataFound
                ? 150
                : options.length < 4
                    ? options.length * 50
                    : 200,
          );
        },
        width: dropdownWidth,
        onSelected: (value) {
          handleInteraction(context);
          editProfileNotifier.selectedEstimatedIncome = value!;
        },
        onSubmitted: (value) {
          handleInteraction(context);
          editProfileNotifier.selectedEstimatedIncome = value!;
        },
        fillColor:
            editProfileNotifier.isUserNotVerified ? null : Colors.grey.shade200,
        isEnable: editProfileNotifier.isUserNotVerified != false);
  }

  //Occupation Text
  Widget buildOccupationText(BuildContext context) {
    return buildText(
        text: S.of(context).occupation,
        fontSize: AppConstants.sixteen,
        fontWeight: AppFont.fontWeightSemiBold);
  }

  //Occupation Info Text
  Widget buildOccupationInfoText(BuildContext context) {
    return buildText(
        text: S.of(context).selectTheFieldOrIndustry,
        fontColor: oxfordBlueTint400,
        fontWeight: AppFont.fontWeightRegular);
  }

  //Annual Income Heading
  Widget buildAnnualIncomeText(BuildContext context) {
    return buildText(
        text: S.of(context).estimatedAnnualIncome,
        fontSize: AppConstants.sixteen,
        fontWeight: AppFont.fontWeightSemiBold);
  }

  //Occupation Dropdown
  Widget buildOccupationDropdownBox(
      EditProfileNotifier editProfileNotifier, BuildContext context) {
    return CustomizeDropdown(context,
        validation: (value) {
          if (value == null || value.isEmpty) {
            return 'Occupation is required';
          }
          return null;
        },
        dropdownItems: editProfileNotifier.occupationListData,
        controller: editProfileNotifier.occupationController,
        width: dropdownWidth, optionsViewBuilder:
            (BuildContext context, AutocompleteOnSelected onSelected,
                Iterable options) {
      return buildDropDownContainer(
        context,
        options: options,
        onSelected: onSelected,
        dropdownData: editProfileNotifier.occupationListData,
        dropDownWidth: dropdownWidth,
        dropDownHeight: options.first == AppConstants.noDataFound
            ? 150
            : options.length < 5
                ? options.length * 50
                : 300,
      );
    }, onSelected: (value) {
      handleInteraction(context);
      editProfileNotifier.selectedOccupation = value!;
    }, onSubmitted: (value) {
      handleInteraction(context);
      editProfileNotifier.selectedOccupation = value!;
    },
        fillColor:
            editProfileNotifier.isUserNotVerified ? null : Colors.grey.shade200,
        isEnable: editProfileNotifier.isUserNotVerified != false);
  }

  //Occupation Others Text Field
  Widget buildOccupationOthersField(
      EditProfileNotifier editProfileNotifier, BuildContext context) {
    return Selector<EditProfileNotifier, TextEditingController>(
        builder: (context, occupationOthersController, child) {
          return CommonTextField(
            onChanged: (val) {
              handleInteraction(context);
            },
            width: dropdownWidth,
            hintStyle: hintStyle(context),
            controller: occupationOthersController,
            keyboardType: TextInputType.text,
            validatorEmptyErrorText: fieldIsRequired,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
            ],
              fillColor:
              editProfileNotifier.isUserNotVerified ? null : Colors.grey.shade200,
              isEnable: editProfileNotifier.isUserNotVerified != false
          );
        },
        selector: (buildContext, editProfileNotifier) =>
            editProfileNotifier.occupationOthersController);
  }

  Widget buildReferralCodeInfoText(BuildContext context) {
    return buildText(
      text: S.of(context).anyReferralcodeFromFriend,
      fontColor: oxfordBlueTint400,
      fontWeight: AppFont.fontWeightRegular,
    );
  }

  Widget buildHeading(context, {title}) {
    return buildText(
        text: title,
        fontSize: AppConstants.sixteen,
        fontColor: oxfordBlueTint500);
  }
  //Edit Profile Save Button
  Widget buildButtons(
      EditProfileNotifier editProfileNotifier, BuildContext context) {
    var buttonWidth = kIsWeb
        ? isMobile(context)
            ? getScreenWidth(context) * 0.39
            : isTab(context)
                ? getScreenWidth(context) * 0.29
                : screenSizeWidth * 0.22
        : isMobileSDK(context)
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
        MyApp.navigatorKey.currentState!.maybePop();
      },
      onPressedContinue: () async {
        if (editProfileNotifier.formKey.currentState!.validate()) {
          await SharedPreferencesMobileWeb.instance
              .getContactId(apiContactId)
              .then((value) async {
            if (editProfileNotifier.countryData == AustraliaName) {
              await AuthRepositoryAus().updateCustomerDetails(
                  SaveCustomerRequest(
                    contactId: value,
                    countryCode: "+61",
                    state: editProfileNotifier.selectedCountry,
                    occupation: editProfileNotifier.selectedOccupation,
                    postalCode: editProfileNotifier.postalCodeController.text,
                    promoCode:
                        editProfileNotifier.enterPromoCodeController.text,
                    phoneNumber:
                        editProfileNotifier.mobileNumberController.text,
                    employerName:
                        editProfileNotifier.employerNameController.text,
                    lastName: editProfileNotifier.lastNameController.text,
                    middleName: editProfileNotifier.middleNameController.text,
                    firstName: editProfileNotifier.firstNameController.text,
                    address: editProfileNotifier.searchAddressController.text,
                    addressLine1: editProfileNotifier.unitNoController.text,
                    addressLine2: editProfileNotifier.streetNumberController.text,
                    addressLine3: editProfileNotifier.streetNameController.text,
                    addressLine4:
                        editProfileNotifier.suburbController.text,
                    addressLine5: editProfileNotifier.cityController.text,
                    annualIncome: "",
                    country: editProfileNotifier.selectedResidence,
                    cra: editProfileNotifier.selectedRadioTile == 1
                        ? true
                        : false,
                    dateOfBirth: editProfileNotifier.dobController.text,
                    estimatedTxnamount:
                        editProfileNotifier.selectedEstimatedIncome,
                    nationality: editProfileNotifier.selectedNationality,
                    otherOccupation:
                        editProfileNotifier.occupationOthersController.text,
                    residenceId: editProfileNotifier.selectedResidence,
                    tittle: editProfileNotifier.selectedSalutation,
                  ),
                  context);
            } else if (editProfileNotifier.countryData == SingaporeName) {
              await ContactRepository()
                  .apiPersonalDetailsSG(
                      PersonalDetailsRequestSg(
                          firstName:
                              editProfileNotifier.firstNameController.text,
                          middleName:
                              editProfileNotifier.middleNameController.text,
                          lastName: editProfileNotifier.lastNameController.text,
                          city: editProfileNotifier.cityController.text,
                          employerName:
                              editProfileNotifier.employerNameController.text,
                          phoneNumber:
                              editProfileNotifier.mobileNumberController.text,
                          promoCode:
                              editProfileNotifier.enterPromoCodeController.text,
                          blockNo: editProfileNotifier.blockNoController.text,
                          buildingName:
                              editProfileNotifier.buildingNameController.text,
                          occupationOthers: editProfileNotifier
                              .occupationOthersController.text,
                          postalCode:
                              editProfileNotifier.postalCodeController.text,
                          state: editProfileNotifier.stateController.text,
                          streetName:
                              editProfileNotifier.streetNameController.text,
                          unitNo: editProfileNotifier.unitNoController.text,
                          residentStatus: editProfileNotifier.selectedResidence,
                          occupation: "Lawyer"),
                      context)
                  .then((value) {
                MyApp.navigatorKey.currentState!.maybePop();
              });
            } else {
              await AuthRepositoryAus()
                  .saveCustomerDetailsHK(
                      SaveCustomerRequestHk(
                        salutation: "7c502d84-3e4e-11e9-b210-d663bd873d934",
                        firstName: editProfileNotifier.firstNameController.text,
                        middleName:
                            editProfileNotifier.middleNameController.text,
                        lastName: editProfileNotifier.lastNameController.text,
                        dateOfBirth: editProfileNotifier.dobController.text,
                        nationality:
                            "${editProfileNotifier.selectedNationality}",
                        occupation: "${editProfileNotifier.selectedOccupation}",
                        address:
                            editProfileNotifier.flatAndFloorNoController.text,
                        promoCode:
                            editProfileNotifier.enterPromoCodeController.text,
                        residentStatus: editProfileNotifier.selectedResidence,
                        occupationOthers:
                            editProfileNotifier.occupationOthersController.text,
                        streetName: editProfileNotifier
                                .streetNameController.text.isEmpty
                            ? "NA"
                            : editProfileNotifier.streetNameController.text,
                        buildingName: editProfileNotifier
                                .buildingNameController.text.isEmpty
                            ? "NA"
                            : editProfileNotifier.buildingNameController.text,
                        district: editProfileNotifier
                                .nameOfVillageController.text.isEmpty
                            ? "NA"
                            : editProfileNotifier.nameOfVillageController.text,
                        state: "NA",
                      ),
                      context)
                  .then((value) {
                MyApp.navigatorKey.currentState!.maybePop();
              });
            }
          });
        } else {
          editProfileNotifier.isError = !editProfileNotifier.isError;
        }
      },
    );
  }

  //Johor State Address Text Fields
  Widget buildJohorAddressField(
      EditProfileNotifier editProfileNotifier, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeading(context, title: S.of(context).postalCodeWeb),
        commonSizedBoxHeight10(context),
        buildPostalCode(editProfileNotifier, context),
        Visibility(
            visible: editProfileNotifier.postCodeMessage != "",
            child: Column(children: [
              Text(
                editProfileNotifier.postCodeMessage,
                style: errorMessageStyle(context),
              ),
              sizedBoxHeight10(context),
            ])),
        Visibility(
            child: commonSizedBoxHeight20(context),
            visible: editProfileNotifier.isError),
        buildUnitAndBlockNo(editProfileNotifier, context),
        Visibility(
            child: commonSizedBoxHeight20(context),
            visible: editProfileNotifier.isError),
        buildStreetAndBuildingName(editProfileNotifier, context),
      ],
    );
  }

  //SG Address Field
  Widget buildSingaporeAddressField(
      EditProfileNotifier editProfileNotifier, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeading(context, title: No),
        commonSizedBoxHeight10(context),
        Selector<EditProfileNotifier, TextEditingController>(
            builder: (context, noController, child) {
              return CommonTextField(
                onChanged: (val) {
                  handleInteraction(context);
                },
                width: dropdownWidth,
                hintStyle: hintStyle(context),
                hintText: S.of(context).HouseLotNumberFloor,
                controller: noController,
                keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
                validatorEmptyErrorText: houseLotNumberFloorIsRequired,
                fillColor: editProfileNotifier.isUserNotVerified
                    ? null
                    : Colors.grey.shade200,
                isEnable: editProfileNotifier.isUserNotVerified == false
                    ? false
                    : true,
              );
            },
            selector: (buildContext, editProfileNotifier) =>
                editProfileNotifier.noController),
        commonSizedBoxHeight25(context),
        buildHeading(context, title: S.of(context).buildingName),
        commonSizedBoxHeight10(context),
        Selector<EditProfileNotifier, TextEditingController>(
            builder: (context, buildingNameJohorController, child) {
              return CommonTextField(
                onChanged: (val) {
                  handleInteraction(context);
                },
                width: dropdownWidth,
                hintText: S.of(context).buildingName,
                hintStyle: hintStyle(context),
                controller: buildingNameJohorController,
                validatorEmptyErrorText: buildingNameIsRequired,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                ],
                fillColor: editProfileNotifier.isUserNotVerified
                    ? null
                    : Colors.grey.shade200,
                isEnable: editProfileNotifier.isUserNotVerified == false
                    ? false
                    : true,
              );
            },
            selector: (buildContext, editProfileNotifier) =>
                editProfileNotifier.buildingNameJohorController),
        commonSizedBoxHeight25(context),
        buildHeading(context, title: S.of(context).postalCode),
        commonSizedBoxHeight10(context),
        Selector<EditProfileNotifier, TextEditingController>(
            builder: (context, postalCodeJohorController, child) {
              return CommonTextField(
                onChanged: (val) {
                  handleInteraction(context);
                },
                containerColor: Colors.transparent,
                width: dropdownWidth,
                hintText: S.of(context).postalCode,
                hintStyle: hintStyle(context),
                controller: postalCodeJohorController,
                keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
                validatorEmptyErrorText: postalCodeisRequired,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
                fillColor: editProfileNotifier.isUserNotVerified
                    ? null
                    : Colors.grey.shade200,
                isEnable: editProfileNotifier.isUserNotVerified == false
                    ? false
                    : true,
              );
            },
            selector: (buildContext, editProfileNotifier) =>
                editProfileNotifier.postalCodeJohorController),
        commonSizedBoxHeight25(context),
        buildHeading(context, title: S.of(context).city),
        commonSizedBoxHeight10(context),
        Selector<EditProfileNotifier, TextEditingController>(
            builder: (context, cityController, child) {
              return CommonTextField(
                onChanged: (val) {
                  handleInteraction(context);
                },
                width: dropdownWidth,
                hintText: S.of(context).cityName,
                hintStyle: hintStyle(context),
                controller: cityController,
                validatorEmptyErrorText: cityIsRequired,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                ],
                fillColor: editProfileNotifier.isUserNotVerified
                    ? null
                    : Colors.grey.shade200,
                isEnable: editProfileNotifier.isUserNotVerified == false
                    ? false
                    : true,
              );
            },
            selector: (buildContext, editProfileNotifier) =>
                editProfileNotifier.cityController),
        commonSizedBoxHeight25(context),
        buildHeading(context, title: state),
        commonSizedBoxHeight10(context),
        Selector<EditProfileNotifier, TextEditingController>(
            builder: (context, stateController, child) {
              return CommonTextField(
                onChanged: (val) {
                  handleInteraction(context);
                },
                width: dropdownWidth,
                readOnly: true,
                controller: stateController,
                fillColor: editProfileNotifier.isUserNotVerified
                    ? null
                    : Colors.grey.shade200,
                isEnable: editProfileNotifier.isUserNotVerified == false
                    ? false
                    : true,
              );
            },
            selector: (buildContext, editProfileNotifier) =>
                editProfileNotifier.stateController),
        commonSizedBoxHeight10(context),
      ],
    );
  }

  //Radio Buttons For AUS Flow
  Widget buildRadioButtons(
      BuildContext context, EditProfileNotifier editProfileNotifier) {
    return Container(
      width: dropdownWidth,
      padding: px15DimenAll(context),
      decoration: transactionHistoryContainerStyle(context,
          isDisabled: editProfileNotifier.isUserNotVerified ? false : true),
      child: Column(
        children: [
          RadioListTile(
            title: Text(S
                .of(context)
                .forStraightThroughProcessingIWouldLikeToChooseDigitalIDVerification),
            value: 1,
            groupValue: editProfileNotifier.selectedRadioTile,
            onChanged: editProfileNotifier.isUserNotVerified == false
                ? null
                : (int? value) {
                    editProfileNotifier.selectedRadioTile = value!;
                  },
          ),
          RadioListTile(
            title: Text(S
                .of(context)
                .IDoNotWishToDiscloseAnyPersonalInformationToAnyCreditReportingOrGovernmentAgency),
            value: 2,
            groupValue: editProfileNotifier.selectedRadioTile,
            onChanged: editProfileNotifier.isUserNotVerified == false
                ? null
                : (int? value) {
                    editProfileNotifier.selectedRadioTile = value!;
                  },
          ),
        ],
      ),
    );
  }

  //DOB and Nationality Tab View
  Widget buildDOBAndNationalityTab(
      EditProfileNotifier editProfileNotifier, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeading(context, title: S.of(context).dateofBirth),
            commonSizedBoxHeight10(context),
            Selector<EditProfileNotifier, TextEditingController>(
                builder: (context, dobController, child) {
                  return CommonTextField(
                    onChanged: (val) {
                      handleInteraction(context);
                    },
                    height: 70,
                    fillColor: editProfileNotifier.isUserNotVerified
                        ? null
                        : Colors.grey.shade200,
                    containerColor: Colors.white10,
                    isEnable: editProfileNotifier.isUserNotVerified == false
                        ? false
                        : true,
                    controller: dobController,
                    hintText: S.of(context).selectDateOfBirth,
                    hintStyle: hintStyle(context),
                    width: kIsWeb ? isTab(context) ? getScreenWidth(context) * 0.29 : getScreenWidth(context) * 0.22 : isTabSDK(context) ? screenSizeWidth * 0.29 : screenSizeWidth * 0.22,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime(DateTime.now().year - 30,
                            DateTime.now().month, DateTime.now().day),
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        editProfileNotifier.dobController.text = formattedDate;
                      }
                    },
                    validatorEmptyErrorText: AppConstants.fieldisRequired,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                    ],
                  );
                },
                selector: (buildContext, editProfileNotifier) =>
                    editProfileNotifier.dobController)
          ],
        ),
        commonSizedBoxWidth20(context),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeading(context, title: S.of(context).nationality),
            SizedBox(height: getScreenHeight(context) * 0.01),
            buildNationalityDropDown(context, editProfileNotifier,
              width: kIsWeb ? isTab(context) ? getScreenWidth(context) * 0.29 : getScreenWidth(context) * 0.22 : isTabSDK(context) ? screenSizeWidth * 0.29 : screenSizeWidth * 0.22,
                dropdownWidth: kIsWeb ? isMobile(context)
                    ? getScreenWidth(context) * 0.80
                    : isTab(context)
                        ? getScreenWidth(context) * 0.29
                        : getScreenWidth(context) * 0.22 :  isMobileSDK(context)
                    ? screenSizeWidth * 0.80
                    : isTabSDK(context)
                    ? screenSizeWidth * 0.29
                    : screenSizeWidth * 0.22,
            ),
          ],
        )
      ],
    );
  }

  //DOB and Nationality
  Widget buildDOBAndNationality(EditProfileNotifier editProfileNotifier,
      RegisterNotifier registerNotifier, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeading(context, title: S.of(context).dateofBirth),
        commonSizedBoxHeight10(context),
        Selector<EditProfileNotifier, TextEditingController>(
            builder: (context, dobController, child) {
              return CommonTextField(
                  onChanged: (val) {
                    handleInteraction(context);
                  },
                  controller: dobController,
                  fillColor: editProfileNotifier.isUserNotVerified
                      ? null
                      : Colors.grey.shade200,
                  containerColor: Colors.white10,
                  isEnable: editProfileNotifier.isUserNotVerified == false
                      ? false
                      : true,
                  hintText: S.of(context).selectDateOfBirth,
                  hintStyle: hintStyle(context),
                  readOnly: true,
                  onTap: () {
                    if (defaultTargetPlatform == TargetPlatform.iOS) {
                      iosDatePicker(context, registerNotifier,
                          editProfileNotifier.dobController,
                          initialDateTime: DateTime(1950),maximumDate: DateTime(2100), minimumDate: DateTime(1950));
                    } else
                      androidDatePicker(context, registerNotifier,
                          editProfileNotifier.dobController);
                  },
                  validatorEmptyErrorText: employerNameIsRequired,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                  ],
                  width: dropdownWidth);
            },
            selector: (buildContext, editProfileNotifier) =>
                editProfileNotifier.dobController),
        commonSizedBoxHeight20(context),
        buildHeading(context, title: S.of(context).nationality),
        commonSizedBoxHeight10(context),
        buildNationalityDropDown(
          context,
          editProfileNotifier,
          width: dropdownWidth,
          dropdownWidth: dropdownWidth,
        ),
      ],
    );
  }

  //Common Row Field
  Widget commonRowField(
    BuildContext context,
    EditProfileNotifier editProfileNotifier, {
    header1,
    header2,
    controller1,
    controller2,
    hintText1,
    hintText2,
    validationRequired1,
    validationRequired2,
    inputFormat1,
    inputFormat2,
    keyboardType1,
    keyboardType2,
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
                    containerColor: Colors.white10,
                    onChanged: (val) {
                      handleInteraction(context);
                    },
                    controller: controller1,
                    helperText: '',
                    fillColor: editProfileNotifier.isUserNotVerified
                        ? null
                        : Colors.grey.shade200,
                    isEnable: editProfileNotifier.isUserNotVerified == false
                        ? false
                        : true,
                    keyboardType: keyboardType1 ?? TextInputType.text,
                    width: kIsWeb ? isMobile(context)
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
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(inputFormat1 ?? "[a-zA-Z ]")),
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
                    containerColor: Colors.white10,
                    onChanged: (val) {
                      handleInteraction(context);
                    },
                    controller: controller2,
                    fillColor: editProfileNotifier.isUserNotVerified
                        ? null
                        : Colors.grey.shade200,
                    isEnable: editProfileNotifier.isUserNotVerified == false
                        ? false
                        : true,
                    width: kIsWeb ? isMobile(context)
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
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(inputFormat2 ?? "[a-zA-Z ]")),
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

  //State Dropdown List
  Widget buildStateDropDown(
      BuildContext context, EditProfileNotifier notifier) {
    return CustomizeDropdown(context,
        validation: (value) {
          if (value == null || value.isEmpty) {
            return 'State is required';
          }
          return null;
        },
        dropdownItems: notifier.nationalityDatas,
        width: isMobile(context)
            ? getScreenWidth(context) * 0.80
            : isTab(context)
                ? getScreenWidth(context) * 0.29
                : getScreenWidth(context) * 0.22,
        onSelected: (val) {
          handleInteraction(context);
          notifier.selectedNationality = val!;
        },
        controller: notifier.stateAndProvinceController,
        optionsViewBuilder: (BuildContext context,
            AutocompleteOnSelected onSelected, Iterable options) {
          return buildDropDownContainer(
            context,
            options: options,
            onSelected: onSelected,
            dropdownData: notifier.nationalityDatas,
            dropDownWidth: isMobile(context)
                ? getScreenWidth(context) * 0.80
                : isTab(context)
                    ? getScreenWidth(context) * 0.29
                    : getScreenWidth(context) * 0.22,
            dropDownHeight:
                options.first == 'No Data Found' ? 150 : options.length * 50,
          );
        },
        fillColor: notifier.isUserNotVerified ? null : Colors.grey.shade200,
        isEnable: notifier.isUserNotVerified != false);
  }

  //Nationality Dropdown List
  Widget buildNationalityDropDown(
      BuildContext context, EditProfileNotifier editProfileNotifier,
      {double? width, double? dropdownWidth, String? helperText}) {
    return LayoutBuilder(
      builder: (context, constraints) => CustomizeDropdown(context,
          validation: (value) {
            if (value == null || value.isEmpty) {
              return 'Nationality is required';
            }
            return null;
          },
          dropdownItems: editProfileNotifier.nationalityDatas,
          controller: editProfileNotifier.nationalityController,
          width: width,
          optionsViewBuilder: (BuildContext context,
              AutocompleteOnSelected onSelected, Iterable options) {
            return buildDropDownContainer(
              context,
              options: options,
              onSelected: onSelected,
              dropdownData: editProfileNotifier.nationalityDatas,
              dropDownWidth: dropdownWidth,
              dropDownHeight:
                  options.first == AppConstants.noDataFound ? 150 : options.length * 60,
            );
          },
          fillColor: editProfileNotifier.isUserNotVerified
              ? null
              : Colors.grey.shade200,
          isEnable: editProfileNotifier.isUserNotVerified != false,
          onSelected: (value) {
            handleInteraction(context);
            editProfileNotifier.selectedNationality = value!;
          },
          onSubmitted: (value) {
            handleInteraction(context);
            editProfileNotifier.selectedNationality = value!;
          },
          helperText: helperText),
    );
  }

  //Region Dropdown List
  Widget buildRegionDropDown(
      BuildContext context, EditProfileNotifier editProfileNotifier,
      {double? width, double? dropdownWidth}) {
    return CustomizeDropdown(context,
        validation: (value) {
          if (value == null || value.isEmpty) {
            return 'Region is required';
          }
          return null;
        },
        dropdownItems: editProfileNotifier.regionListData,
        width: width,
        controller: editProfileNotifier.regionController,
        optionsViewBuilder: (BuildContext context,
            AutocompleteOnSelected onSelected, Iterable options) {
          return buildDropDownContainer(
            context,
            options: options,
            onSelected: onSelected,
            dropdownData: editProfileNotifier.regionListData,
            dropDownWidth: dropdownWidth,
            dropDownHeight: options.first == S.of(context).noDataFound
                ? 150
                : options.length * 50,
          );
        },
        onSelected: (value) {
          handleInteraction(context);
          editProfileNotifier.selectedCountry = value!;
        },
        onSubmitted: (value) {
          handleInteraction(context);
          editProfileNotifier.selectedCountry = value!;
        },
        fillColor:
            editProfileNotifier.isUserNotVerified ? null : Colors.grey.shade200,
        isEnable: editProfileNotifier.isUserNotVerified != false);
  }


  //Pop-Up Dialog To View User Uploaded Document's
  showImageProof(String title, BuildContext context,
      EditProfileNotifier editProfileNotifier, Uint8List dataPNGType) {
    return ContactRepository().documentType == AppConstants.pdf
        ? showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => AppInActiveCheck(
            context: context,
            child: StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                  actions: [
                    TextButton(
                      child: Text(AppConstants.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                  contentPadding: EdgeInsets.zero,
                  content: IntrinsicHeight(
                    child: Container(
                      width: getScreenWidth(context) < 340
                          ? 270
                          : getScreenWidth(context) < 450
                          ? 300
                          : getScreenWidth(context) < 600
                          ? 400
                          : 450,
                      height: getScreenWidth(context) < 340
                          ? 300
                          : getScreenWidth(context) < 450
                          ? 400
                          : getScreenWidth(context) < 600
                          ? 550
                          : 630,
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: PdfViewer.openData(dataPNGType),
                    ),
                  ));
            })))
        : showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => AppInActiveCheck(
            context: context,
            child: StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                actions: [
                  TextButton(
                    child: Text(AppConstants.close),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .pop('dialog');
                    },
                  )
                ],
                content: IntrinsicHeight(
                    child: Container(
                      width: getScreenWidth(context) < 750
                          ? getScreenWidth(context) * 0.8
                          : getScreenWidth(context) <= 1280
                          ? getScreenWidth(context) * 0.6
                          : getScreenWidth(context) * 0.5,
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: SingleChildScrollView(
                        primary: true,
                        child: Padding(
                          padding: px24DimenAll(context),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: fairexchangeStyle(context),
                              ),
                              sizedBoxHeight24(context),
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                        Color(0xff7b7b7b).withOpacity(0.10),
                                        blurRadius: 30,
                                        offset: Offset(0, 15)),
                                  ],
                                ),
                                child: Image.memory(dataPNGType),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              );
            })));
  }
}
