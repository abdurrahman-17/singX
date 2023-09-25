import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/service/auth_repository.dart';
import 'package:singx/core/models/request_response/login/login_request.dart';
import 'package:singx/core/models/request_response/login/login_request_aus.dart';
import 'package:singx/core/models/request_response/register/register_request.dart';
import 'package:singx/core/models/request_response/register/register_request_aus.dart';
import 'package:singx/core/notifier/common_notifier.dart';
import 'package:singx/core/notifier/login_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/utils/common/app_button.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_images.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/common/app_custom_icon.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:singx/utils/common/my_mob_fun.dart'
    if (dart.library.html) 'package:singx/utils/common/my_web_fun.dart' as html;

class Login extends StatelessWidget {
  bool? isUserLogin;

  Login({Key? key, this.isUserLogin}) : super(key: key);

  //objects
  double width = 0.0, height = 0.0;
  String locale = "en";
  AuthRepository authRepository = AuthRepository();
  AuthRepository registerRepository = AuthRepository();

  @override
  Widget build(BuildContext context) {
    //height and width of screen
    width = getScreenWidth(context);
    height = getScreenHeight(context);
    SharedPreferencesMobileWeb.instance.setScreenSize(AppConstants.screenWidth, width);
    SharedPreferencesMobileWeb.instance.setScreenSize1('height', height);
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Provider.of<CommonNotifier>(context, listen: false)
            .updateLoginData(false);

        return Future.value(true);
      },
      child: ChangeNotifierProvider(
        create: (context) => LoginNotifier(context),
        child: Scaffold(
          backgroundColor: white,
          body: Consumer<LoginNotifier?>(builder: (context, loginNotifier, _) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              loginNotifier!.isUser_Login = isUserLogin;
            });

            return (width <= 570)
                ? Scrollbar(
                    controller: loginNotifier!.scrollController,
                    child: Stack(
                      children: [
                        backgroundBlueContainer(context),
                        formScreen(context, loginNotifier),
                      ],
                    ),
                  )
                : isTab(context)
                    ? Scrollbar(
                        controller: loginNotifier!.scrollController,
                        child: SingleChildScrollView(
                          controller: loginNotifier.scrollController,
                          child: Column(
                            children: [
                              buildImage(context),
                              SizedBoxHeight(context, 0.05),
                              SizedBox(
                                width: width * 0.70,
                                child: Card(
                                  elevation: AppConstants.ten,
                                  child: loginNotifier.isUserLogin == false
                                      ? buildLoginForm(loginNotifier, context)
                                      : buildSignUpForm(loginNotifier, context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildImage(context),
                        (loginNotifier != null &&
                                loginNotifier.isUserLogin == false)
                            ? buildLoginForm(loginNotifier, context)
                            : buildSignUpForm(loginNotifier, context),
                      ],
                    );
          }),
        ),
      ),
    );
  }

  // Image for Tab and Web
  Widget buildImage(BuildContext context) {
    return Container(
      width: isTab(context) ? width : width / 2,
      height: isTab(context) ? getScreenHeight(context) * 0.45 : null,
      color: caryolaBlueTint200,
      child: Column(
        children: [
          SizedBoxHeight(context, 0.05),
          buildSingXLogo(context),
          SizedBoxHeight(context, isTab(context) ? 0.02 : 0.05),
          buildSendMoneyText(context),
          SizedBoxHeight(context, isTab(context) ? 0.02 : 0.10),
          buildGlobalLogo(context)
        ],
      ),
    );
  }

  // Background Container for Mobile
  Widget backgroundBlueContainer(BuildContext context) {
    return Container(
      height: height * 0.5,
      decoration: BoxDecoration(
        borderRadius: bottomRadius20(context),
        color: loginBlueColor,
      ),
    );
  }

  // Mobile Login UI
  Widget formScreen(BuildContext context, LoginNotifier? loginNotifier) {
    return SafeArea(
      child: SingleChildScrollView(
        controller: loginNotifier!.scrollController,
        child: Padding(
          padding: px15DimenHorizontal(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sizedBoxHeight35(context),
              logoImage(context, loginNotifier),
              sizedBoxHeight40(context),
              formContainer(context, loginNotifier),
              Visibility(
                  visible: loginNotifier!.isUserLogin == false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sizedBoxHeight45(context),
                      loginWithFaceId(context, loginNotifier),
                      sizedBoxHeight30(context),
                      dontHaveAC(context),
                      sizedBoxHeight20(context),
                      registerButton(context),
                      sizedBoxHeight40(context)
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  // Mobile login and register
  Widget formContainer(BuildContext context, LoginNotifier? loginNotifier) {
    return Container(
      width: double.infinity,
      decoration: formContainerBoxStyle(context),
      child: loginNotifier!.isUserLogin == false
          ? buildLoginForm(loginNotifier, context)
          : buildSignUpForm(loginNotifier, context),
    );
  }

  // Image for Mobile UI
  Widget logoImage(BuildContext context, LoginNotifier? loginNotifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Visibility(
            child: GestureDetector(
              onTap: () {
                SharedPreferencesMobileWeb.instance.removeParticularKey(AppConstants.apiToken);
                Navigator.pushReplacementNamed(context, loginRoute);
              },
              child: Icon(
                AppCustomIcon.leftArrow,
                color: white,
                size: AppConstants.twenty,
              ),
            ),
             visible: loginNotifier!.isUserLogin == true),
        Center(
          child: Image.asset(
            AppImages.singXLogo,
            height: AppConstants.seventy,
          ),
        ),
        SizedBox()
      ],
    );
  }

  // FaceId for mobile and tab
  Widget loginWithFaceId(BuildContext context, LoginNotifier? loginNotifier) {
    return Visibility(
        child: GestureDetector(
          onTap: loginNotifier!.enableLoginWithFaceId ? () async {
            loginNotifier.localAuth(context);
          }:null,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.faceId,
                  height: AppConstants.twentyFive,
                  width: AppConstants.twentyFive,
                  color: loginNotifier.enableLoginWithFaceId ? null:greyColor,
                ),
                sizedBoxHeight10(context),
                Text(
                  S.of(context).loginwithFaceID,
                  style: loginNotifier.enableLoginWithFaceId ? loginFaceStyle(context):loginFaceGreyStyle(context) ,
                ),
              ],
            ),
          ),
        ),
        visible: loginNotifier!.canCheckBiometrics == true && loginNotifier!.availableBiometrics.isNotEmpty);
  }

  Widget dontHaveAC(BuildContext context) {
    return Center(
      child: Text(
        S.of(context).donthaveanaccount,
        style: dontHaveAccuntStyle(context),
      ),
    );
  }

  // Register button for mobile
  Widget registerButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: secondaryMobileButton(
        context,
        S.of(context).registerNow,
        () {
          Provider.of<CommonNotifier>(context, listen: false)
              .updateLoginData(true);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Login(isUserLogin: true,),
            ),
          );
        },
      ),
    );
  }

  // Login Form Fields
  Widget buildLoginForm(LoginNotifier? loginNotifier, BuildContext context) {
    localAuthCheck() async {
      if (!kIsWeb) {
        loginNotifier!.canCheckBiometrics =
            await LocalAuthentication().canCheckBiometrics;
        loginNotifier!.availableBiometrics =
            await LocalAuthentication().getAvailableBiometrics();

      }
    }

    localAuthCheck();
    return Scrollbar(
        controller: loginNotifier!.scrollController2,
        child: SingleChildScrollView(
          controller: loginNotifier!.scrollController2,
          child: SizedBox(
            width: isMobile(context) ? double.infinity : width * 0.50,
            child: Padding(
              padding: isMobile(context)
                  ? px20DimenTop(context)
                  : px60DimenTop(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: width > 980 ? AppConstants.hundred : AppConstants.zero),
                      child: buildWelcomeBackText(context)),
                  SizedBoxHeight(context, 0.04),
                  Padding(
                    padding: isMobile(context)
                        ? px20DimenHorizontal(context)
                        : EdgeInsets.only(
                            left: isTab(context) ? AppConstants.twenty : width * 0.08, right: AppConstants.twenty),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildCountryOfResidenceText(context),
                        isMobile(context)
                            ? sizedBoxHeight2(context)
                            : SizedBoxHeight(context, 0.01),
                        buildCountryDropDown(loginNotifier, "login", context),
                        SizedBoxHeight(context, 0.02),
                        buildEmailAddressText(context),
                        isMobile(context)
                            ? sizedBoxHeight2(context)
                            : SizedBoxHeight(context, 0.01),
                        buildEmailAddressTextField(context, loginNotifier,
                            from: "login"),
                        SizedBoxHeight(context, 0.02),
                        buildPasswordText(context),
                        isMobile(context)
                            ? sizedBoxHeight2(context)
                            : SizedBoxHeight(context, 0.01),
                        buildPasswordTextField(context,
                            loginNotifier: loginNotifier, from: "login"),
                        loginNotifier.loginErrorMessage == "" ||
                                loginNotifier.loginErrorMessage == "null"
                            ? SizedBox()
                            : Text(
                                loginNotifier.loginErrorMessage,
                                style: errorMessageStyle(context),
                              ),
                        SizedBoxHeight(context, 0.02),
                        (width >= 800 && width < 960) || width < 410
                            ? buildRememberEmailTab(loginNotifier, context)
                            : buildRememberEmailRow(loginNotifier, context),
                        SizedBoxHeight(context, 0.02),
                        isMobile(context)
                            ? loginButton(context, loginNotifier)
                            : buildLoginButton(loginNotifier, context),
                        SizedBoxHeight(context, 0.015),
                        isMobile(context)
                            ? SizedBox()
                            : Container(width: isTab(context)
                                ? width * 0.60
                                : isMobile(context)
                                ? double.infinity
                                : getScreenWidth(context) > 800 && getScreenWidth(context) < 850 ? width * 0.37 : width * 0.32,
                                child: loginWithFaceId(context, loginNotifier)),
                          ],
                    ),
                  ),
                  isMobile(context) ? SizedBox() : SizedBoxHeight(context, 0.02),
                  isMobile(context)
                      ? SizedBox()
                      : buildCreateAccountText(loginNotifier, context),
                  isMobile(context)
                      ? sizedBoxHeight20(context)
                      : SizedBoxHeight(context, 0.03),
                ],
              )),
            ),
      ),
    );
  }

  // Login button for mobile
  Widget loginButton(BuildContext context, LoginNotifier loginNotifier) {
    return SizedBox(
      width: double.infinity,
      child: primaryMobileButton(
        context,
        S.of(context).login,
        () async {
          loginSubmitForm(loginNotifier, context);
        },
      ),
    );
  }

  // Sign up form fields
  Widget buildSignUpForm(LoginNotifier? loginNotifier, BuildContext context) {
    return Scrollbar(
      controller: loginNotifier!.scrollController3,
      child: SingleChildScrollView(
        controller: loginNotifier!.scrollController3,
        child: SizedBox(
          width: width * 0.50,
          child: Padding(
            padding: isMobile(context)
                ? px20DimenTop(context)
                : px60DimenTop(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildSignUpText(context),
                Padding(
                  padding: isMobile(context)
                      ? EdgeInsets.symmetric(horizontal: AppConstants.twenty)
                      : EdgeInsets.only(
                          left: isTab(context) ? AppConstants.thirtyFive : width * 0.08, right: AppConstants.twenty),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildCountryOfResidenceText(context),
                      isMobile(context)
                          ? sizedBoxHeight2(context)
                          : SizedBoxHeight(context, 0.01),
                      buildCountryDropDown(loginNotifier, "register", context),
                      SizedBoxHeight(context, 0.02),
                      buildEmailAddressText(context),
                      isMobile(context)
                          ? sizedBoxHeight2(context)
                          : SizedBoxHeight(context, 0.01),
                      buildEmailAddressTextField(context, loginNotifier,
                          from: "register"),
                      SizedBoxHeight(context, 0.02),
                      buildMobileNumberText(context),
                      isMobile(context)
                          ? sizedBoxHeight2(context)
                          : SizedBoxHeight(context, 0.01),
                      mobileTextField(context,
                          mobileController:
                              loginNotifier.registerMobileController,
                          loginNotifier: loginNotifier),
                      SizedBoxHeight(context, 0.02),
                      buildPasswordText(context),
                      isMobile(context)
                          ? sizedBoxHeight2(context)
                          : SizedBoxHeight(context, 0.01),
                      buildPasswordTextField(
                          loginNotifier: loginNotifier,
                          context,
                          from: "register"),
                      sizedBoxHeight20(context),
                      buildAgreeConditionText(loginNotifier, context),
                      sizedBoxHeight15(context),
                      buildAgreePolicyText(loginNotifier, context),
                      SizedBoxHeight(context, 0.01),
                      buildCheckBoxErrorText(loginNotifier, context),
                      SizedBoxHeight(context, 0.01),
                      loginNotifier.registerErrorMessage == "" ||
                              loginNotifier.registerErrorMessage == "null"
                          ? SizedBox()
                          : Text(
                              loginNotifier.registerErrorMessage,
                              style: TextStyle(color: errorTextField,
                            fontSize: AppConstants.elevenPointFive,fontWeight: FontWeight.w500),
                            ),
                      SizedBoxHeight(context, 0.01),
                      isMobile(context)
                          ? loginNotifier.registerDropdown ==
                                      AppConstants.australia ||
                                  loginNotifier.registerDropdown ==
                                      AppConstants.hongKong ||
                                  loginNotifier.registerDropdown ==
                                      AppConstants.singapore
                              ? SizedBox()
                              : signInWithSingX(context)
                          : buildRegisterButton(loginNotifier, context),
                      SizedBoxHeight(context, 0.03),
                      isMobile(context)
                          ? signInManually(context, loginNotifier)
                          : loginNotifier.registerDropdown ==
                                      AppConstants.australia ||
                                  loginNotifier.registerDropdown ==
                                      AppConstants.hongKong ||
                                  loginNotifier.registerDropdown ==
                                      AppConstants.singapore
                              ? SizedBox()
                              : buildRegisterWithSignPassButton(
                                  loginNotifier, context),
                    ],
                  ),
                ),
                SizedBoxHeight(context, 0.03),
                isMobile(context)
                    ? SizedBox()
                    : Padding(
                        padding: isMobile(context)
                            ? px20DimenHorizontal(context)
                            : EdgeInsets.only(
                                left: isTab(context) ? AppConstants.twenty : width * 0.08,
                                right: getScreenWidth(context) > 570 &&
                                        getScreenWidth(context) < 800
                                    ? AppConstants.four
                                    : getScreenWidth(context) > 800 &&
                                            getScreenWidth(context) < 960
                                        ? getScreenHeight(context) * 0.02
                                        : AppConstants.twenty),
                        child: Container(
                            width: isTab(context)
                                ? width * 0.60
                                : isMobile(context)
                                    ? double.infinity
                                    : getScreenWidth(context) > 800 &&
                                            getScreenWidth(context) < 850
                                        ? width * 0.37
                                        : width * 0.32,
                            child: buildLoginAccountText(
                                loginNotifier, context))),
                isMobile(context)
                    ? sizedBoxHeight10(context)
                    : SizedBoxHeight(context, 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // sign with singpass button
  Widget signInWithSingX(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: primaryMobilewithSingXIconButton(context, "Sign up using", () {}),
    );
  }

  // sign in manually without singpass
  Widget signInManually(BuildContext context, LoginNotifier loginNotifier) {
    return SizedBox(
      width: double.infinity,
      child: secondaryMobileButton(
        context,
        "Sign up",
        () async {
          registerSubmitForm(context, loginNotifier);
          // if (loginNotifier.validateKey.currentState!.validate()) {
          //   if (loginNotifier.isAgreePolicy) {
          //     Provider.of<CommonNotifier>(context, listen: false)
          //         .updateLoginData(false);
          //
          //     await SharedPreferencesMobileWeb.instance
          //         .setCountry(AppConstants.country, loginNotifier.registerDropdown);
          //     await SharedPreferencesMobileWeb.instance.setPhoneNumber(
          //         AppConstants.phoneNumber, loginNotifier.registerMobileController.text);
          //     await SharedPreferencesMobileWeb.instance.setCountryCode(
          //       AppConstants.countryCode,
          //       loginNotifier.registerDropdown == AppConstants.singapore
          //           ? AppConstants.singaporeCountryCode
          //           : loginNotifier.registerDropdown == AppConstants.australia
          //               ? AppConstants.australiaCountryCode
          //               : AppConstants.hongKongCountryCode,
          //     );
          //
          //     loginNotifier.RegisterErrorMessageGet = "";
          //     loginNotifier.errorCheck = false;
          //     if (loginNotifier.registerDropdown == AppConstants.singapore ||
          //         loginNotifier.registerDropdown == AppConstants.hongKong) {
          //       registerRepository
          //           .apiUserRegister(
          //               RegisterRequest(
          //                 email: loginNotifier.registerEmailController.text,
          //                 password:
          //                     loginNotifier.registerPasswordController.text,
          //                 mobile: loginNotifier.registerMobileController.text,
          //                 termsFlag: loginNotifier.isAgreePolicy,
          //                 marketingFlag: loginNotifier.isAgreeCondition,
          //                 source: loginNotifier.registerDropdown ==
          //                         AppConstants.singapore
          //                     ? AppConstants.sg
          //                     : AppConstants.hk,
          //                 entrySource: '',
          //                 promoCode: '',
          //                 utmCampaign: '',
          //                 utmContent: '',
          //                 utmMedium: '',
          //                 utmSource: '',
          //                 utmTerm: '',
          //               ),
          //               context,
          //               loginNotifier.registerDropdown == AppConstants.singapore
          //                   ? AppConstants.sg
          //                   : AppConstants.hk)
          //           .then((value) {
          //         loginNotifier.RegisterErrorMessageGet = value.toString();
          //       });
          //     } else if (loginNotifier.registerDropdown ==
          //         AppConstants.australia) {
          //       await SharedPreferencesMobileWeb.instance.setEmail(
          //           AppConstants.email, loginNotifier.registerEmailController.text);
          //       registerRepository
          //           .apiUserRegisterAus(
          //               RegisterAustraliaRequest(
          //                 channelCode: "MOBILE",
          //                 countryCode: "61",
          //                 emailId: loginNotifier.registerEmailController.text,
          //                 password:
          //                     loginNotifier.registerPasswordController.text,
          //                 mobileNumber: int.parse(
          //                     loginNotifier.registerMobileController.text),
          //                 marketCommunications: loginNotifier.isAgreeCondition,
          //                 termCondition: loginNotifier.isAgreePolicy,
          //                 registeredCountry: AppConstants.australia ,
          //                 utmTerm: "",
          //                 utmSource: "",
          //                 utmMedium: "",
          //                 utmContent: "",
          //                 utmCampaign: "",
          //               ),
          //               context)
          //           .then((value) {
          //         loginNotifier.RegisterErrorMessageGet = value.toString();
          //       });
          //     }
          //   } else {
          //     loginNotifier.errorCheck = true;
          //   }
          // } else {
          //   if (loginNotifier.isAgreePolicy == false)
          //     loginNotifier.errorCheck = true;
          // }
        },
      ),
    );
  }

  // sign up button
  Widget singUpButton(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        secondaryMobileSignupButton(context, S.of(context).individual, () {}),
        sizedBoxWidth12(context),
        greyMobileSignUpButton(context, S.of(context).business, () {
          launchUrlString(AppConstants.businessPageUrl);
        }),
      ],
    );
  }

  // singX image logo
  Widget buildSingXLogo(BuildContext context) {
    return Image.asset(
      AppImages.singXLogoWeb,
      height: getScreenHeight(context) * 0.08,
      width: width * 0.15,
    );
  }

  Widget buildSendMoneyText(BuildContext context) {
    return Padding(
      padding: px20DimenOnlyLeft(context),
      child: buildText(
        text: S.of(context).theSmartestWaytoSendMoneyOverseas,
        fontSize: AppConstants.twentyTwo,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // GlobalWorld image
  Widget buildGlobalLogo(BuildContext context) {
    return Image.asset(
      AppImages.globalWorldWeb,
      height: isTab(context)
          ? getScreenHeight(context) * 0.20
          : getScreenHeight(context) * 0.50,
      width: isTab(context) ? width * 0.30 : width * 0.48,
    );
  }

  // welcome back label
  Widget buildWelcomeBackText(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: buildText(
            text: isMobile(context)
                ? S.of(context).welcomeBack
                : S.of(context).welcomeBackWeb,
            fontSize: AppConstants.twentyFour,
            fontWeight: FontWeight.w700,
          ),
        ),
        Visibility(
            visible: isMobile(context),
            child: Column(
              children: [
                sizedBoxHeight5(context),
                Center(
                    child: Text(
                  S.of(context).hellothere,
                  textAlign: TextAlign.center,
                  style: greyTextStyle(context),
                ))
              ],
            )),
      ],
    );
  }

  // regsiter label
  Widget buildSignUpText(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: buildText(
            text: isMobile(context)
                ? S.of(context).createYourAccount
                : S.of(context).createMyAccountWeb,
            fontSize: AppConstants.twentyFour,
            fontWeight: FontWeight.w700,
          ),
        ),
        Visibility(
            visible: isMobile(context),
            child: Column(children: [
              sizedBoxHeight5(context),
              Text(
                S.of(context).signupinjustafewminutes,
                style: greyTextStyle(context),
              ),
              sizedBoxHeight30(context),
              singUpButton(context)
            ])),
        isMobile(context)
            ? sizedBoxHeight25(context)
            : SizedBoxHeight(context, 0.04),
      ],
    );
  }

  // Country of residence label
  Widget buildCountryOfResidenceText(BuildContext context) {
    return buildText(
      text: S.of(context).countryofResidenceWeb,
      fontSize: AppConstants.sixteen,
      fontColor: oxfordBlueTint500,
    );
  }

  // Country Dropdown
  Widget buildCountryDropDown(
      LoginNotifier? loginNotifier, from, BuildContext context) {
    return CommonDropDownField(
      items: AppConstants.countryNames,
      maxHeight: AppConstants.oneHundredFifty,
      showSearchBox: false,
      selectedItem:
          from == "register" ? AppConstants.singapore : loginNotifier!.loginDropdown.isNotEmpty? loginNotifier.loginDropdown: AppConstants.singapore,
      hintText: '${S.of(context).select} ${S.of(context).countryofResidence}',
      onChanged: (val) {
        Provider.of<CommonNotifier>(context, listen: false)
            .updateCountryOfRes(val!);

        from == "register"
            ? loginNotifier?.registerDropdown = val
            : loginNotifier?.loginDropdown = val;
      },
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: fieldBorderColorNew),
      ),
      border: const OutlineInputBorder(),
      hintStyle: hintStyle(context),
      width: isTab(context)
          ? width * 0.60
          : isMobile(context)
              ? double.infinity
              : getScreenWidth(context) > 800 && getScreenWidth(context) < 850 ? width * 0.37 : width * 0.32,
      color: Colors.transparent,
    );
  }

  // email address Label
  Widget buildEmailAddressText(BuildContext context) {
    return buildText(
      text: S.of(context).emailAddressWeb,
      fontSize: AppConstants.sixteen,
      fontColor: oxfordBlueTint500,
    );
  }

  // email address textField
  Widget buildEmailAddressTextField(
      BuildContext context, LoginNotifier loginNotifier,
      {TextEditingController? emailController, String? from}) {
    return Selector<LoginNotifier, TextEditingController>(
        builder: (context, textEditControl, child) {
          return Form(
            key: loginNotifier.emailKey,
            child: CommonTextField(
              autoValidateMode: AutovalidateMode.disabled,
              onFieldSubmitted: (val) {
                isUserLogin == true
                    ? registerSubmitForm(context, loginNotifier)
                    : loginSubmitForm(loginNotifier, context);
              },
              onChanged: (val){
                if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(val)){
                  loginNotifier.emailKey.currentState!.validate();
                }
              },
              errorStyle: TextStyle(color: errorTextField,
                  fontSize: AppConstants.elevenPointFive ,fontWeight: FontWeight.w500),
              controller: textEditControl,
              validatorEmptyErrorText: AppConstants.emailRequired,
              isEmailValidator: true,
              hintStyle: hintStyle(context),
              keyboardType: TextInputType.emailAddress,
              inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(
                  RegExp("[ A-Za-z0-9_@./#&+-]")),
            ],
              width: isTab(context)
                  ? width * 0.60
                  : isMobile(context)
                      ? double.infinity
                      : getScreenWidth(context) > 800 && getScreenWidth(context) < 850 ? width * 0.37: width * 0.32,
            ),
          );
        },
        selector: (buildContext, loginNotifier) => from == "login"
            ? loginNotifier.loginEmailController
            : loginNotifier.registerEmailController);
  }

  // mobile number Label
  Widget buildMobileNumberText(BuildContext context) {
    return buildText(
      text: S.of(context).mobileNumberWeb,
      fontSize: AppConstants.sixteen,
      fontColor: oxfordBlueTint500,
    );
  }

  // mobile number textField
  Widget mobileTextField(BuildContext context,
      {TextEditingController? mobileController, required LoginNotifier loginNotifier}) {
    return Selector<LoginNotifier, TextEditingController>(
        builder: (context, textEditControl, child) {
          return Form(
            key: loginNotifier.mobileKey,
            child: CommonTextField(
              autoValidateMode: AutovalidateMode.disabled,
              onFieldSubmitted: (val) {
                registerSubmitForm(context, loginNotifier);
                SharedPreferencesMobileWeb.instance
                    .removeParticularKey(AppConstants.stepOneData);
              },
              onChanged: (val){
                if(val.length >= 8){
                  loginNotifier.mobileKey.currentState!.validate();
                }
              },
              keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
              controller: mobileController,
              width: isTab(context)
                  ? width * 0.60
                  : isMobile(context)
                      ? double.infinity
                      : getScreenWidth(context) > 800 && getScreenWidth(context) < 850 ? width * 0.37 : width * 0.32,
              prefixIcon: Wrap(
                children: [
                  Padding(
                    padding: (!kIsWeb)
                        ? EdgeInsets.only(top: 1.5, left: AppConstants.one)
                        : isMobile(context)
                            ?  EdgeInsets.only(top: AppConstants.one, left: AppConstants.one)
                            : EdgeInsets.only(left: AppConstants.one),
                    child: Container(
                      decoration: mobileFieldPrefixContainerStyle(context),
                      height: AppConstants.fortyFive,
                      width: AppConstants.hundred,
                      child: Row(
                        children: [
                          SizedBoxWidth(context, isMobile(context) || getScreenWidth(context) < 700 ? 0.025 : 0.01),
                          Image.asset(
                              loginNotifier.registerDropdown ==
                                      AppConstants.singapore
                                  ? AppImages.singaporeFlag
                                  : loginNotifier.registerDropdown ==
                                          AppConstants.australia
                                      ? AppImages.australiaFlag
                                      : AppImages.hongkongFlag,
                              height: getScreenHeight(context) * 0.025),
                          SizedBoxWidth(context, isMobile(context) || getScreenWidth(context) < 700 ? 0.025 : 0.01),
                          buildText(
                            text: loginNotifier.registerDropdown ==
                                    AppConstants.singapore
                                ? AppConstants.singaporeCountryCode
                                : loginNotifier.registerDropdown ==
                                        AppConstants.hongKong
                                    ? AppConstants.hongKongCountryCode
                                    : AppConstants.australiaCountryCode,
                            fontSize: AppConstants.sixteen,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.01),
                ],
              ),
              validatorEmptyErrorText: AppConstants.mobileRequired,
              isMobileNumberValidator: true,
              errorStyle: TextStyle(color: errorTextField,
                  fontSize: AppConstants.elevenPointFive,fontWeight: FontWeight.w500),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
              ],
            ),
          );
        },
        selector: (buildContext, loginNotifier) =>
            loginNotifier.registerMobileController);
  }

  // password label
  Widget buildPasswordText(BuildContext context) {
    return buildText(
        text: S.of(context).password,
        fontSize: AppConstants.sixteen,
        fontColor: oxfordBlueTint500);
  }

  // password textField
  Widget buildPasswordTextField(BuildContext context,
      {TextEditingController? passwordController,
      required LoginNotifier loginNotifier,
      String? from}) {
    return Selector<LoginNotifier, TextEditingController>(
        builder: (context, textEditControl, child) {
          return Form(
            key: loginNotifier.passwordKey,
            child: CommonTextField(
              autoValidateMode: AutovalidateMode.disabled,
              onFieldSubmitted: (val) {
                isUserLogin == true
                    ? registerSubmitForm(context, loginNotifier)
                    : loginSubmitForm(loginNotifier, context);
              },
              controller: textEditControl,
              hintStyle: hintStyle(context),
              maxHeight: AppConstants.fifty,
              onChanged: (value) {
                if (isUserLogin == false &&value.length >= 1) {
                  loginNotifier.passwordKey.currentState!.validate();
                } else if (isUserLogin == true &&
                    (RegExp(".*[0-9].*").hasMatch(value) &&
                        value.length >= 8 &&
                        RegExp('.*[a-z].*').hasMatch(value) &&
                        RegExp('.*[A-Z].*').hasMatch(value) &&
                        RegExp('.*?[!@#\$&*~]').hasMatch(value))) {
                  loginNotifier.passwordKey.currentState!.validate();
                }
                loginNotifier.ErrorMessageGet = "";
                html.eyeIssue(loginNotifier.passwordFocusNode);
              },
              focusNode: loginNotifier.passwordFocusNode,
              suffixIcon: Theme(
                data: Theme.of(context).copyWith(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                ),
                child: Theme(
                  data: ThemeData(
                      hoverColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent),
                  child: Selector<LoginNotifier, bool>(
                      builder: (context, isPasswordVisible, child) {
                        return IconButton(
                          icon: isPasswordVisible
                              ? Image.asset(
                                  AppImages.eye,
                                  height: AppConstants.twentyTwo,
                                  width: AppConstants.twentyTwo,
                                )
                              : Icon(
                                  AppCustomIcon.visibilityOff,
                                  size: AppConstants.eighteen,
                                ),
                          onPressed: () {
                            loginNotifier.isPasswordVisible =
                                !loginNotifier.isPasswordVisible;
                          },
                        );
                      },
                      selector: (buildContext, loginNotifier) =>
                          loginNotifier.isPasswordVisible),
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(AppConstants.regexToRemoveEmoji))
              ],
              validator: (v) {
                String? message;

                if (v!.length < 1) {
                  message = S.of(context).pleaseEnterAPassword;
                } else if (isUserLogin == true &&
                       ( !RegExp(".*[0-9].*").hasMatch(v ) ||
                    v.length < 8 ||
                    !RegExp('.*[a-z].*').hasMatch(v) ||
                    !RegExp('.*[A-Z].*').hasMatch(v) ||
                    !RegExp('.*?[!@#\$&*~]').hasMatch(v))) {
                  message ??= '';
                  message += S.of(context).yourpasswordmustcontain;
                }
                return message;
              },
              errorStyle: TextStyle(color: errorTextField,
                              fontSize: AppConstants.elevenPointFive,fontWeight: FontWeight.w500),
              isPasswordVisible: !loginNotifier.isPasswordVisible,
              width: isTab(context)
                  ? width * 0.60
                  : isMobile(context)
                      ? double.infinity
                      : getScreenWidth(context) > 800 && getScreenWidth(context) < 850 ? width * 0.37 : width * 0.32,
            ),
          );
        },
        selector: (buildContext, loginNotifier) => from == "login"
            ? loginNotifier.loginPasswordController
            : loginNotifier.registerPasswordController);
  }

  // Agree to receive marketing communication checkbox
  Widget buildAgreeConditionText(
      LoginNotifier loginNotifier, BuildContext context) {
    return Container(
      width: isTab(context)
          ? width * 0.60
          : isMobile(context)
          ? double.infinity
          : getScreenWidth(context) > 800 && getScreenWidth(context) < 850 ? width * 0.37 : width * 0.32,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: px15DimenRight(context),
            child: SizedBox(
              height: AppConstants.twentyTwo,
              width: AppConstants.eighteen,
              child: Theme(
                data: ThemeData(
                  checkboxTheme: CheckboxThemeData(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.five),
                    ),
                  ),
                ),
                child: Checkbox(
                  side: BorderSide(width: AppConstants.one, color: checkBoxBorderColor),
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  value: loginNotifier.isAgreeCondition,
                  onChanged: (bool? value) {
                    loginNotifier.isAgreeCondition =
                        !loginNotifier.isAgreeCondition;
                  },
                ),
              ),
            ),
          ),
          Flexible(
            child: GestureDetector(
              onTap: () => loginNotifier.isAgreeCondition =
                  !loginNotifier.isAgreeCondition,
              child: buildText(
                text: S.of(context).iagreeWeb,
                fontColor: black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Agree to policy and conditions checkBox
  Widget buildAgreePolicyText(
      LoginNotifier loginNotifier, BuildContext context) {
    return Container(
      width: isTab(context)
          ? width * 0.60
          : isMobile(context)
          ? double.infinity
          : getScreenWidth(context) > 800 && getScreenWidth(context) < 850 ? width * 0.37 : width * 0.32,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: px15DimenRight(context),
            child: SizedBox(
              height: AppConstants.twentyTwo,
              width: AppConstants.eighteen,
              child: Theme(
                data: ThemeData(
                  checkboxTheme: CheckboxThemeData(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                child: Checkbox(
                  side: BorderSide(width: 1, color: checkBoxBorderColor),
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  value: loginNotifier.isAgreePolicy,
                  onChanged: (bool? value) {
                    loginNotifier.isAgreePolicy = !loginNotifier.isAgreePolicy;
                    loginNotifier.isAgreePolicy == false
                        ? loginNotifier.errorCheck = true
                        : loginNotifier.errorCheck = false;
                  },
                ),
              ),
            ),
          ),
          Flexible(
            child: GestureDetector(
              onTap: () {
                loginNotifier.isAgreePolicy = !loginNotifier.isAgreePolicy;
                loginNotifier.isAgreePolicy == false
                    ? loginNotifier.errorCheck = true
                    : loginNotifier.errorCheck = false;
              },
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: S.of(context).iAgreePolicyWeb,
                      style: policyStyleBlack(context),
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchUrlString(AppConstants.authorizationUrl);
                        },
                      text: S.of(context).authorization,
                      style: policyStyleHanBlue(context),
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchUrlString(AppConstants.privacyPolicyUrl);
                        },
                      text: S.of(context).privacyPolicy,
                      style: policyStyleHanBlue(context),
                    ),
                    TextSpan(
                      text: S.of(context).and,
                      style: policyStyleBlack(context),
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () =>
                            launchUrlString(AppConstants.termsAndConditionUrl),
                      text: S.of(context).termsAndCondition,
                      style: policyStyleHanBlue(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ErrorMessage for checkbox
  Widget buildCheckBoxErrorText(
      LoginNotifier loginNotifier, BuildContext context) {
    return Container(
      width: isMobile(context)
          ? width * 1
          : isTab(context)
              ? width * 0.60
              : width * 0.32,
      child: Visibility(
        visible: loginNotifier.errorCheck,
        child: Column(
          children: [
            SizedBox(height: getScreenHeight(context) * 0.02),
            Text(S.of(context).pleaseClickOnTheCheckboxAboveToConfirm,style: TextStyle(color: errorTextField,
                fontSize: AppConstants.elevenPointFive,fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  // remember my mail for tab
  Widget buildRememberEmailTab(
      LoginNotifier loginNotifier, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            buildEmailCheckBox(loginNotifier, context),
            buildRememberEmailText(loginNotifier, context),
          ],
        ),
        sizedBoxHeight10(context),
        buildForgotPassword(context, loginNotifier),
      ],
    );
  }

  // remember my mail label
  Widget buildRememberEmailText(
      LoginNotifier loginNotifier, BuildContext context) {
    return GestureDetector(
      onTap: () => loginNotifier.isEmailChecked = !loginNotifier.isEmailChecked,
      child: buildText(text: S.of(context).remembermyemail),
    );
  }

  // forgot password label
  Widget buildForgotPassword(
      BuildContext context, LoginNotifier loginNotifier) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: white,
      ),
      child: buildText(
        text: S.of(context).forgotPasswordWeb,
        fontColor: hanBlue,
      ),
      onPressed: () async {
        await SharedPreferencesMobileWeb.instance
            .setCountry(AppConstants.country, loginNotifier.loginDropdown);
        await SharedPreferencesMobileWeb.instance
            .getCountry(AppConstants.country)
            .then((value) async {
          Navigator.pushNamed(context, forgetPasswordRoute);
        });
      },
    );
  }

  // remember my mail checkbox
  Widget buildEmailCheckBox(LoginNotifier loginNotifier, BuildContext context) {
    return Padding(
      padding: px15DimenRight(context),
      child: SizedBox(
        height: AppConstants.twentyTwo,
        width: AppConstants.eighteen,
        child: Theme(
          data: ThemeData(
            checkboxTheme: CheckboxThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.five),
              ),
            ),
          ),
          child: Checkbox(
            side: BorderSide(width: AppConstants.one, color: checkBoxBorderColor),
            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
            value: loginNotifier.isEmailChecked,
            onChanged: (bool? value) {
              loginNotifier.isEmailChecked = value;
            },
          ),
        ),
      ),
    );
  }

  Widget buildRememberEmailRow(
      LoginNotifier loginNotifier, BuildContext context) {
    return SizedBox(
      width: isTab(context)
          ? width * 0.60
          : isMobile(context)
              ? double.infinity
              : width * 0.32,
      child: Row(
        children: [
          buildEmailCheckBox(loginNotifier, context),
          buildRememberEmailText(loginNotifier, context),
          const Spacer(),
          buildForgotPassword(context, loginNotifier),
        ],
      ),
    );
  }

  // login button function
  loginSubmitForm(LoginNotifier loginNotifier, BuildContext context) async {
    //validation functionality
    loginNotifier.emailKey.currentState!.validate();
    loginNotifier.passwordKey.currentState!.validate();
    if (loginNotifier.emailKey.currentState!.validate() && loginNotifier.passwordKey.currentState!.validate()) {
      //Api calling for future use
        await SharedPreferencesMobileWeb.instance
            .setCountry(AppConstants.country, loginNotifier.loginDropdown);
        await SharedPreferencesMobileWeb.instance
            .setEmail(AppConstants.email, loginNotifier.loginEmailController.text);
      if (loginNotifier.loginDropdown == AppConstants.australia) {
        _handleRememberMe(loginNotifier);
        await authRepository
            .apiUserLoginAustralia(
                LoginAustraliaRequest(
                  username: loginNotifier.loginEmailController.text,
                  password: loginNotifier.loginPasswordController.text,
                ),
                context)
            .then((value) {
          loginNotifier.ErrorMessageGet = value.toString();
        });
      } else {
        _handleRememberMe(loginNotifier);
        authRepository
            .apiUserLogin(
                LoginRequest(
                    username: loginNotifier.loginEmailController.text,
                    password: loginNotifier.loginPasswordController.text,
                    source:
                        loginNotifier.loginDropdown == AppConstants.singapore
                            ? AppConstants.sg
                            : AppConstants.hk),
                context)
            .then((value) {
          loginNotifier.ErrorMessageGet = value.toString();
        });
      }
    }
  }

  // login button tab and web
  Widget buildLoginButton(LoginNotifier loginNotifier, BuildContext context) {
    return buildButton(
      context,
      onPressed: () async {
        loginSubmitForm(loginNotifier, context);
        SharedPreferencesMobileWeb.instance.removeParticularKey(AppConstants.stepOneData);
      },
      height: isMobile(context) ? AppConstants.fiftyFive : null,
      width: isTab(context)
          ? width * 0.60
          : isMobile(context)
              ? double.infinity
              : getScreenWidth(context) > 800 && getScreenWidth(context) < 850 ? width * 0.37 : width * 0.32,
      color: hanBlue,
      name: S.of(context).login,
      fontSize: AppConstants.sixteen,
      fontWeight: FontWeight.w700,
      fontColor: white,
    );
  }

  void _handleRememberMe(LoginNotifier loginNotifier) {
    if (loginNotifier.isEmailChecked == true) {
      SharedPreferencesMobileWeb.instance.setEmailAddress(
          AppConstants.emailAddress, loginNotifier.loginEmailController.text);
      SharedPreferencesMobileWeb.instance.setPasswordAddress(
          AppConstants.passwordAddress, loginNotifier.loginPasswordController.text);
      SharedPreferencesMobileWeb.instance.setSelectedCountry(
          AppConstants.selectedCountryAddress, loginNotifier.loginDropdown);
    }else if(loginNotifier.isEmailChecked == false){
      SharedPreferencesMobileWeb.instance.removeParticularKey(AppConstants.emailAddress);
      SharedPreferencesMobileWeb.instance.removeParticularKey(AppConstants.passwordAddress);
      SharedPreferencesMobileWeb.instance.removeParticularKey(AppConstants.selectedCountryAddress);
    }
  }

  registerSubmitForm(BuildContext context, LoginNotifier loginNotifier) async {
    //validation functionality
    loginNotifier.emailKey.currentState!.validate();
    loginNotifier.mobileKey.currentState!.validate();
    loginNotifier.passwordKey.currentState!.validate();
    if (loginNotifier.emailKey.currentState!.validate() && loginNotifier.mobileKey.currentState!.validate() && loginNotifier.passwordKey.currentState!.validate()) {
      //checkbox validation(Policy)
      if (loginNotifier.isAgreePolicy) {
        Provider.of<CommonNotifier>(context, listen: false)
            .updateLoginData(false);

        await SharedPreferencesMobileWeb.instance
            .setCountry(AppConstants.country, loginNotifier.registerDropdown);
        await SharedPreferencesMobileWeb.instance.setPhoneNumber(
            AppConstants.phoneNumber, loginNotifier.registerMobileController.text);
        await SharedPreferencesMobileWeb.instance.setCountryCode(
          AppConstants.countryCode,
          loginNotifier.registerDropdown == AppConstants.singapore
              ? AppConstants.singaporeCountryCode
              : loginNotifier.registerDropdown == AppConstants.australia
                  ? AppConstants.australiaCountryCode
                  : AppConstants.hongKongCountryCode,
        );
        SharedPreferencesMobileWeb.instance.setIsManualVerification(true);
        loginNotifier.RegisterErrorMessageGet = "";
        loginNotifier.errorCheck = false;
        if (loginNotifier.registerDropdown == AppConstants.singapore ||
            loginNotifier.registerDropdown == AppConstants.hongKong) {
          registerRepository
              .apiUserRegister(
                  RegisterRequest(
                    email: loginNotifier.registerEmailController.text,
                    password: loginNotifier.registerPasswordController.text,
                    mobile: loginNotifier.registerMobileController.text,
                    termsFlag: loginNotifier.isAgreePolicy,
                    marketingFlag: loginNotifier.isAgreeCondition,
                    source:
                        loginNotifier.registerDropdown == AppConstants.singapore
                            ? AppConstants.sg
                            : AppConstants.hk,
                    entrySource: '',
                    promoCode: '',
                    utmCampaign: '',
                    utmContent: '',
                    utmMedium: '',
                    utmSource: '',
                    utmTerm: '',
                  ),
                  context,
                  loginNotifier.registerDropdown == AppConstants.singapore
                      ? AppConstants.sg
                      : AppConstants.hk)
              .then((value) {
            loginNotifier.RegisterErrorMessageGet = value.toString();
          });
        } else if (loginNotifier.registerDropdown == AppConstants.australia) {
          await SharedPreferencesMobileWeb.instance
              .setEmail(AppConstants.email, loginNotifier.registerEmailController.text);
          registerRepository
              .apiUserRegisterAus(
                  RegisterAustraliaRequest(
                    channelCode: "WEB",
                    countryCode: "61",
                    emailId: loginNotifier.registerEmailController.text,
                    password: loginNotifier.registerPasswordController.text,
                    mobileNumber:
                        int.parse(loginNotifier.registerMobileController.text),
                    marketCommunications: loginNotifier.isAgreeCondition,
                    termCondition: loginNotifier.isAgreePolicy,
                    registeredCountry: AppConstants.australia,
                    utmTerm: "",
                    utmSource: "",
                    utmMedium: "",
                    utmContent: "",
                    utmCampaign: "",
                  ),
                  context)
              .then((value) {
            loginNotifier.RegisterErrorMessageGet = value.toString();
          });
        }
      } else {
        loginNotifier.errorCheck = true;
      }
    } else {
      if (loginNotifier.isAgreePolicy == false) loginNotifier.errorCheck = true;
    }
  }

  // register button
  Widget buildRegisterButton(
      LoginNotifier loginNotifier, BuildContext context) {
    return buildButton(
      context,
      onPressed: () async {
        registerSubmitForm(context, loginNotifier);
        SharedPreferencesMobileWeb.instance.removeParticularKey(AppConstants.stepOneData);
      },
      width: isTab(context) ? width * 0.60 : getScreenWidth(context) > 800 && getScreenWidth(context) < 850 ? width * 0.37 : width * 0.32,
      color: hanBlue,
      name: S.of(context).register,
      fontSize: AppConstants.sixteen,
      fontWeight: FontWeight.w700,
      fontColor: white,
    );
  }

  // register button with singpass for mobile and tab
  Widget buildRegisterWithSignPassButton(
      LoginNotifier loginNotifier, BuildContext context) {
    return buildButton(
      context,
      onPressed: () async {},
      width: isTab(context) ? width * 0.60 : width * 0.32,
      color: hanBlueTint200,
      name: S.of(context).registerWithSingPassWeb,
      fontSize: AppConstants.sixteen,
      fontWeight: FontWeight.w700,
      fontColor: hanBlue,
    );
  }

  // create a new account label
  Widget buildCreateAccountText(
      LoginNotifier? loginNotifier, BuildContext context) {
    return Padding(
      padding: isMobile(context)
          ? px20DimenHorizontal(context)
          : EdgeInsets.only(
              left: isTab(context) ? AppConstants.twenty : width * 0.08,
              right: getScreenWidth(context) > 800 && getScreenWidth(context) < 850
                  ? getScreenHeight(context) * 0.05
                  : getScreenWidth(context) > 850 && getScreenWidth(context) < 960
                      ? getScreenHeight(context) * 0.1
                      : AppConstants.twenty),
      child: Container(
          width: isTab(context)
              ? width * 0.60
              : isMobile(context)
                  ? double.infinity
                  : getScreenWidth(context) > 800 &&
                          getScreenWidth(context) < 850
                      ? width * 0.37
                      : width * 0.32,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildText(
                text: S.of(context).newToSingx + " ",
                fontWeight: FontWeight.w400,
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, registerRoute);
                  },
                  child: buildText(
                    text: S.of(context).createAnAccount,
                    fontWeight: FontWeight.w700,
                    fontColor: hanBlue,
                  ),
                ),
              )
            ],
          )),
    );
  }

  // already signed up label
  Widget buildLoginAccountText(
      LoginNotifier? loginNotifier, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildText(
          text: S.of(context).alreadySignUpWeb + " ",
          fontWeight: FontWeight.w400,
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              SharedPreferencesMobileWeb.instance.removeParticularKey(AppConstants.apiToken);
              Navigator.pushReplacementNamed(context, loginRoute);
            },
            child: buildText(
              text: S.of(context).logInHereWeb,
              fontWeight: FontWeight.w700,
              fontColor: hanBlue,
            ),
          ),
        ),
      ],
    );
  }
}
