import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/service/auth_repository.dart';
import 'package:singx/core/models/request_response/forget_password/forget_password_request.dart';
import 'package:singx/core/models/request_response/forget_password/forget_password_step2_request.dart';
import 'package:singx/core/notifier/forget_password_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/main.dart';
import 'package:singx/utils/common/app_button.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_custom_icon.dart';
import 'package:singx/utils/common/app_font.dart';
import 'package:singx/utils/common/app_images.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({Key? key}) : super(key: key);

  final AuthRepository forgetPasswordRepository = AuthRepository();
  final double width = 0.0, height = 0.0;

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return ChangeNotifierProvider<ForgetPasswordNotifier>(
      create: (context) => ForgetPasswordNotifier(),
      child: Consumer<ForgetPasswordNotifier>(
        builder: (context, forgetPasswordNotifier, _) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: white,
            body: (kIsWeb && getScreenWidth(context) <= 570) || !kIsWeb
                ? Scrollbar(
              controller: forgetPasswordNotifier.scrollController,
                    child: Stack(
                      children: [
                        backgroundBlueContainer(context),
                        formScreen(context, forgetPasswordNotifier),
                      ],
                    ),
                  )
                : isTab(context)
                    ? Scrollbar(
              controller: forgetPasswordNotifier.scrollController,
                        child: SingleChildScrollView(
                          controller: forgetPasswordNotifier.scrollController,
                          child: Column(
                            children: [
                              buildImage(context),
                              SizedBoxHeight(context, 0.05),
                              SizedBox(
                                width: getScreenWidth(context) * 0.70,
                                child: Card(
                                  elevation: AppConstants.ten,
                                  child: buildForgetPasswordForm(
                                      forgetPasswordNotifier, context),
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
                          buildForgetPasswordForm(forgetPasswordNotifier, context),
                        ],
                      ),
          );
        },
      ),
    );
  }

  // for mobile background
  Widget backgroundBlueContainer(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        borderRadius: bottomRadius20(context),
        color: loginBlueColor,
      ),
    );
  }

  // Image for tab and web
  Widget buildImage(BuildContext context) {
    return Container(
      width: isTab(context)
          ? getScreenWidth(context)
          : getScreenWidth(context) / 2,
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

  // SingX logo for mobile
  Widget buildSingXLogo(BuildContext context) {
    return Image.asset(
      AppImages.singXLogoWeb,
      height: getScreenHeight(context) * 0.08,
      width: getScreenWidth(context) * 0.15,
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

  // Logo for tab and web
  Widget buildGlobalLogo(BuildContext context) {
    return Image.asset(
      AppImages.globalWorldWeb,
      height: isTab(context)
          ? getScreenHeight(context) * 0.20
          : getScreenHeight(context) * 0.50,
      width: isTab(context)
          ? getScreenWidth(context) * 0.30
          : getScreenWidth(context) * 0.48,
    );
  }

  // forget password form for mobile
  Widget formScreen(
      BuildContext context, ForgetPasswordNotifier forgetPasswordNotifier) {
    return SafeArea(
      child: SingleChildScrollView(
        controller: forgetPasswordNotifier.scrollController,
        child: Padding(
          padding: px15DimenHorizontal(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sizedBoxHeight35(context),
              logoImage(context),
              sizedBoxHeight40(context),
              sizedBoxHeight40(context),
              sizedBoxHeight40(context),
              formContainer(context, forgetPasswordNotifier),
              sizedBoxHeight40(context),
            ],
          ),
        ),
      ),
    );
  }

  // Logo for mobile
  Widget logoImage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            MyApp.navigatorKey.currentState!.maybePop();
          },
          child: Icon(
            AppCustomIcon.leftArrow,
            color: white,
            size: AppConstants.fifteen,
          ),
        ),
        sizedBoxHeight40(context),
        sizedBoxHeight30(context),
        Center(
          child: Image.asset(
            AppImages.singXLogo,
            height: AppConstants.ninety,
          ),
        ),
      ],
    );
  }

  Widget formContainer(
      BuildContext context, ForgetPasswordNotifier forgetPasswordNotifier) {
    return Container(
      width: double.infinity,
      decoration: formContainerBoxStyle(context),
      child: buildForgetPasswordForm(forgetPasswordNotifier, context),
    );
  }

  // Forget password form
  Widget buildForgetPasswordForm(
      ForgetPasswordNotifier forgetPasswordNotifier, BuildContext context) {
    return SingleChildScrollView(
      controller: forgetPasswordNotifier.scrollController1,
      child: Form(
        key: forgetPasswordNotifier.loginKey,
        child: SizedBox(
          width: isMobile(context)
              ? double.infinity
              : getScreenWidth(context) * 0.50,
          child: Padding(
            padding: isMobile(context)
                ? px20DimenTop(context)
                : px60DimenTop(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: getScreenWidth(context) > 980 ? AppConstants.hundred : AppConstants.zero,
                  ),
                  child: buildWelcomeBackText(context),
                ),
                SizedBoxHeight(context, 0.04),
                Padding(
                  padding: isMobile(context)
                      ? px20DimenHorizontal(context)
                      : EdgeInsets.only(
                          left: isTab(context)
                              ? AppConstants.twenty
                              : getScreenWidth(context) * 0.08,
                          right: AppConstants.twenty,
                        ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildCountryOfResidenceText(context),
                      isMobile(context)
                          ? sizedBoxHeight2(context)
                          : SizedBoxHeight(context, 0.01),
                      buildCountryDropDown(forgetPasswordNotifier, context),
                      SizedBoxHeight(context, 0.02),
                      buildEmailAddressText(context),
                      isMobile(context)
                          ? sizedBoxHeight2(context)
                          : SizedBoxHeight(context, 0.01),
                      buildEmailAddressTextField(
                        context,
                        emailController: forgetPasswordNotifier.emailController,
                          forgetPasswordNotifier : forgetPasswordNotifier
                      ),
                      SizedBoxHeight(context, 0.03),
                      Visibility(
                          visible:
                              forgetPasswordNotifier.loginErrorMessage != "",
                          child: Text(
                            forgetPasswordNotifier.loginErrorMessage == "null" ? "" : forgetPasswordNotifier.loginErrorMessage,
                            style: errorMessageStyle(context),
                          )),
                      SizedBoxHeight(context, 0.02),
                      isMobile(context)
                          ? loginButton(context, forgetPasswordNotifier)
                          : buildLoginButton(forgetPasswordNotifier, context),
                    ],
                  ),
                ),
                isMobile(context)
                    ? sizedBoxHeight20(context)
                    : SizedBoxHeight(context, 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Country DropDown field
  Widget buildCountryDropDown(
      ForgetPasswordNotifier forgetPasswordNotifier, BuildContext context) {
    return CommonDropDownField(
      items: AppConstants.countryNames,
      maxHeight: AppConstants.oneHundredFifty,
      showSearchBox: false,
      selectedItem: AppConstants.singapore,
      hintText: '${S.of(context).select} ${S.of(context).countryofResidence}',
      onChanged: (val) {
        forgetPasswordNotifier.selectedCountryDropdown = val!;
      },
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: fieldBorderColorNew),
      ),
      border: const OutlineInputBorder(),
      hintStyle: hintStyle(context),
      width: isTab(context)
          ? getScreenWidth(context) * 0.60
          : isMobile(context)
              ? double.infinity
              : getScreenWidth(context) * 0.32,
      color: Colors.transparent,
    );
  }

  // Welcome back label
  Widget buildWelcomeBackText(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Text(
          isMobile(context)
              ? S.of(context).recoverYourPassword
              : S.of(context).recoverYourPassword,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppConstants.manrope,
            fontSize: AppConstants.twentyFour,
            fontWeight: FontWeight.w700,
            color: black,
          ),
        ));
  }

  // country of residence label
  Widget buildCountryOfResidenceText(BuildContext context) {
    return buildText(
      text: S.of(context).countryofResidenceWeb,
      fontSize: AppConstants.sixteen,
      fontColor: oxfordBlueTint500,
    );
  }

  // Email address label
  Widget buildEmailAddressText(BuildContext context) {
    return buildText(
      text: S.of(context).emailAddressWeb,
      fontSize: AppConstants.sixteen,
      fontColor: oxfordBlueTint500,
    );
  }

  // Email address TextField
  Widget buildEmailAddressTextField(
    BuildContext context, {
    TextEditingController? emailController,ForgetPasswordNotifier? forgetPasswordNotifier
  }) {
    return CommonTextField(
      controller: emailController,
      autoValidateMode: AutovalidateMode.disabled,
      validatorEmptyErrorText: AppConstants.emailRequired,
      isEmailValidator: true,
      hintStyle: hintStyle(context),
      width: isTab(context)
          ? getScreenWidth(context) * 0.60
          : isMobile(context)
              ? double.infinity
              : getScreenWidth(context) * 0.32,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(
            RegExp("[ A-Za-z0-9_@./#&+-]")),
      ],
      onChanged: (val) {
        forgetPasswordNotifier!.loginErrorMessage = '';
        if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(val)){
          forgetPasswordNotifier.loginKey.currentState!.validate();
        }
      },
    );
  }

  // Login button for mobile
  Widget loginButton(
      BuildContext context, ForgetPasswordNotifier forgetPasswordNotifier) {
    return SizedBox(
      width: double.infinity,
      child: primaryMobileButton(
        context,
        S.of(context).sendMeEmail,
        () async {
          if (forgetPasswordNotifier.loginKey.currentState!.validate() &&
              forgetPasswordNotifier.selectedCountryDropdown == AppConstants.AustraliaName) {
            await forgetPasswordRepository
                .apiForgetPasswordAus(
              forgetPasswordNotifier.emailController.text,
              context,
            )
                .then((value) {
              forgetPasswordNotifier.loginErrorMessage = value.toString();
              value == S.of(context).invalidAccountDetails ||
                  value == S.of(context).pleaseRetryAfterFewMinutes  || value == "Please check your Email"|| value == "Internal Server Error"
                  ? null
                  : successAlertDialog(context);
            });
          } else if (forgetPasswordNotifier.loginKey.currentState!.validate()) {
            await forgetPasswordRepository
                .apiForgetPassword(
              ForgetPasswordRequest(
                email: forgetPasswordNotifier.emailController.text,
                source: forgetPasswordNotifier.selectedCountryDropdown == AppConstants.hongKong?AppConstants.hk:AppConstants.sg,
              ),
              context,
            )
                .then((value) {
              forgetPasswordNotifier.loginErrorMessage = value.toString();
              value == S.of(context).invalidAccountDetails ||
                      value == S.of(context).pleaseRetryAfterFewMinutes
                  ? null
                  : openForgetDialog(context, forgetPasswordNotifier);
            });
          }
        },
      ),
    );
  }

  // Login button for tab and web
  Widget buildLoginButton(
      ForgetPasswordNotifier forgetPasswordNotifier, BuildContext context) {
    return buildButton(
      context,
      onPressed: () async {
        if (forgetPasswordNotifier.loginKey.currentState!.validate() &&
            forgetPasswordNotifier.selectedCountryDropdown == AppConstants.AustraliaName) {
          await forgetPasswordRepository
              .apiForgetPasswordAus(
            forgetPasswordNotifier.emailController.text,
            context,
          )
              .then((value) {
            forgetPasswordNotifier.loginErrorMessage = value.toString();
            value == S.of(context).invalidAccountDetails ||
                    value == S.of(context).pleaseRetryAfterFewMinutes || value == "Please check your Email" || value == "Internal Server Error"
                ? null
                : successAlertDialog(context);
          });
        } else if (forgetPasswordNotifier.loginKey.currentState!.validate()) {
          await forgetPasswordRepository
              .apiForgetPassword(
            ForgetPasswordRequest(
              email: forgetPasswordNotifier.emailController.text,
              source: forgetPasswordNotifier.selectedCountryDropdown == AppConstants.hongKong?AppConstants.hk:AppConstants.sg,
            ),
            context,
          )
              .then((value) {
            forgetPasswordNotifier.loginErrorMessage = value.toString();
            value == S.of(context).invalidAccountDetails ||
                    value == S.of(context).pleaseRetryAfterFewMinutes
                ? null
                : openForgetDialog(context, forgetPasswordNotifier);
          });
        }
      },
      height: isMobile(context) ? AppConstants.fiftyFive : null,
      width: isTab(context)
          ? getScreenWidth(context) * 0.60
          : isMobile(context)
              ? double.infinity
              : getScreenWidth(context) * 0.32,
      color: hanBlue,
      name: S.of(context).sendMeEmail,
      fontSize: AppConstants.sixteen,
      fontWeight: FontWeight.w700,
      fontColor: white,
    );
  }

  // password TextField
  Widget buildNewPasswordTextField(
      context, ForgetPasswordNotifier forgetPasswordNotifier, setState,
      {TextEditingController? passwordController}) {
    bool isHover = false;
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: () {},
      onHover: (val) {
        setState(() {
          isHover = !isHover;
        });
      },
      child: TextFormField(
          readOnly: false,
          autovalidateMode: AutovalidateMode.disabled,
          validator: (value) {
            String? message;
            if(!(RegExp(".*[0-9].*").hasMatch(value!) &&
                value.length >= 8 &&
                RegExp('.*[a-z].*').hasMatch(value) &&
                RegExp('.*[A-Z].*').hasMatch(value) &&
                RegExp('.*?[!@#\$&*~]').hasMatch(value))){
              message = "Your password must contain at least 8 characters with at least one number, one lowercase letter and one uppercase letter.";
            }
            return message;
          },
          controller: forgetPasswordNotifier.newPasswordController,
          obscureText: forgetPasswordNotifier.isNewPasswordVisible,
          decoration: InputDecoration(errorMaxLines: 4,
            fillColor: white,
            errorStyle: TextStyle(color: errorTextField,
                fontSize: AppConstants.elevenPointFive,fontWeight: FontWeight.w500),
            filled: true,
            hoverColor: white,
            counterText: '',
            hintText: S.of(context).newPassword,
            hintStyle: hintStyle(context),
            helperText: '',
            contentPadding: EdgeInsets.fromLTRB(AppConstants.sixteen, AppConstants.twelve, AppConstants.twelve, AppConstants.twelve),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: errorTextField),
                borderRadius: BorderRadius.circular(AppConstants.five)),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: errorTextField),
                borderRadius: BorderRadius.circular(AppConstants.five)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: hanBlueTint500),
                borderRadius: BorderRadius.circular(AppConstants.five)),
            enabledBorder: isHover == true
                ? OutlineInputBorder(
                    borderSide: BorderSide(color: hanBlueTint300))
                : OutlineInputBorder(
                    borderSide: BorderSide(color: fieldBorderColorNew),
                    borderRadius: BorderRadius.circular(AppConstants.five)),
            border: const OutlineInputBorder(),
            suffixIcon: Theme(
                data: Theme.of(context).copyWith(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent),
                child: IconButton(
                  icon: forgetPasswordNotifier.isNewPasswordVisible == true
                      ? Icon(
                          AppCustomIcon.visibilityOff,
                          size: AppConstants.eighteen,
                        )
                      : Image.asset(
                          AppImages.eye,
                          height: AppConstants.twentyTwo,
                          width: AppConstants.twentyTwo,
                        ),
                  onPressed: () {
                    setState(() {
                      forgetPasswordNotifier.isNewPasswordVisible =
                          !forgetPasswordNotifier.isNewPasswordVisible;
                    });
                  },
                )),
          )),
    );
  }

  // Success Popup Dialog
  successAlertDialog(context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(S.of(context).passwordResetSuccessful),
        content: Text(
            S.of(context).requestForPasswordResetSuccessfulPleaseCheckEmail),
        actions: [
          buildButtonMobile(
            context,
            name: S.of(context).oK,
            onPressed: () {
              SharedPreferencesMobileWeb.instance.removeParticularKey(AppConstants.apiToken);
              Navigator.pushNamed(context, loginRoute);
            },
            style: TextStyle(
              fontSize: AppConstants.sixteen,
              fontWeight: AppFont.fontWeightBold,
              color: white,
            ),
            width: AppConstants.sixty,
            height: AppConstants.fortyTwo,
            fontColor: white,
            color: hanBlue,
          ),
        ],
      ),
    );
  }

  // Forget password alert dialog
  openForgetDialog(
      BuildContext context, ForgetPasswordNotifier forgetPasswordNotifier) {
    return showDialog(
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: AppConstants.four, sigmaY: AppConstants.four),
            child: StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                scrollable: true,
                content: IntrinsicHeight(
                  child: SizedBox(
                    width: AppConstants.fourHundredTwenty,
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
                                    ? AppConstants.fourteen
                                    : AppConstants.twentyTwo),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                size: AppConstants.twenty,
                                color: oxfordBlueTint400,
                              ),
                              onPressed: () {
                                MyApp.navigatorKey.currentState!.maybePop();
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
                          key: forgetPasswordNotifier.uploadAddressFormKey,
                          child: Column(
                            children: [
                              buildText(
                                  text: S.of(context).forgotPassword,
                                  fontSize: AppConstants.twentyFour,
                                  fontWeight: FontWeight.w700,
                                  fontColor: oxfordBluelight),
                              sizedBoxHeight30(context),
                              buildNewPasswordTextField(
                                  ctx, forgetPasswordNotifier, setState),
                              sizedBoxHeight10(context),
                              CommonTextField(
                                controller:
                                    forgetPasswordNotifier.otpController,
                                maxLength: 6,
                                autoValidateMode: AutovalidateMode.disabled,
                                keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
                                validatorEmptyErrorText: AppConstants.otpIsRequired,
                                isOTPNumberValidator: true,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[0-9]")),
                                ],
                                hintText: S.of(context).enterOtpHere,
                                hintStyle: hintStyle(context),
                                maxWidth: AppConstants.oneHundredAndSixty,
                                width: getScreenWidth(context),
                                maxHeight: AppConstants.fifty,
                                suffixIcon: getScreenWidth(context) < 340
                                    ? null
                                    : forgetPasswordNotifier.isTimer == false
                                        ? Padding(
                                            padding: px8DimenAll(context),
                                            child: TweenAnimationBuilder<
                                                    Duration>(
                                                duration: Duration(seconds: 120),
                                                tween: Tween(
                                                    begin:
                                                        Duration(seconds: 120),
                                                    end: Duration.zero),
                                                onEnd: () {
                                                  setState(() {
                                                    forgetPasswordNotifier
                                                        .isTimer = true;
                                                  });
                                                },
                                                builder: (BuildContext context,
                                                    Duration value,
                                                    Widget? child) {
                                                  final minutes =
                                                      value.inMinutes;
                                                  final seconds =
                                                      value.inSeconds % 60;
                                                  var sec =
                                                      seconds < 10 ? 0 : '';
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
                                            onPressed: () async {
                                              setState(() {
                                                forgetPasswordNotifier.isTimer =
                                                    false;
                                              });
                                              await forgetPasswordRepository
                                                  .apiForgetPassword(
                                                ForgetPasswordRequest(
                                                  email: forgetPasswordNotifier
                                                      .emailController.text,
                                                  source: forgetPasswordNotifier.selectedCountryDropdown == AppConstants.hongKong?AppConstants.hk:AppConstants.sg,
                                                ),
                                                context,
                                              )
                                                  .then((value) {
                                                setState(() {
                                                  forgetPasswordNotifier
                                                          .loginErrorMessage =
                                                      value.toString();
                                                });
                                              });
                                            },
                                            child: buildText(
                                                text: S.of(context).resendOtp,
                                                fontWeight:
                                                    AppFont.fontWeightSemiBold,
                                                fontColor: orangePantone),
                                          ),
                              ),
                            ],
                          ),
                        ),
                        getScreenWidth(context) > 340
                            ? Text('')
                            : forgetPasswordNotifier.isTimer == false
                                ? Padding(
                                    padding: px8DimenAll(context),
                                    child: TweenAnimationBuilder<Duration>(
                                        duration: Duration(seconds: 120),
                                        tween: Tween(
                                            begin: Duration(seconds: 120),
                                            end: Duration.zero),
                                        onEnd: () async {
                                          setState(() {
                                            forgetPasswordNotifier.isTimer =
                                                true;
                                          });
                                          await forgetPasswordRepository
                                              .apiForgetPassword(
                                            ForgetPasswordRequest(
                                              email: forgetPasswordNotifier
                                                  .emailController.text,
                                              source: forgetPasswordNotifier.selectedCountryDropdown == AppConstants.hongKong?AppConstants.hk:AppConstants.sg,
                                            ),
                                            context,
                                          );
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
                                      setState(() {
                                        forgetPasswordNotifier.isTimer = false;
                                      });
                                    },
                                    child: buildText(
                                        text: S.of(context).resendOtp,
                                        fontWeight: AppFont.fontWeightSemiBold,
                                        fontColor: orangePantone)),
                        Visibility(
                            child:
                                buildText(text: AppConstants.invalidOTP, fontColor: error),
                            visible: forgetPasswordNotifier.isError == true),
                        Visibility(
                            child: Text(
                                forgetPasswordRepository.loginErrorMessage,
                                style: TextStyle(color: errorTextField,
                                    fontSize: AppConstants.elevenPointFive,fontWeight: FontWeight.w500)),
                            visible:
                                forgetPasswordRepository.loginErrorMessage !=
                                    ""),
                        SizedBoxHeight(context,
                            getScreenWidth(context) > 380 ? 0.03 : 0.0),
                        buildButton(ctx, onPressed: () {
                          if (forgetPasswordNotifier
                              .uploadAddressFormKey.currentState!
                              .validate()) {
                              forgetPasswordRepository
                                  .apiForgetPasswordStep2(
                                      ForgetPasswordStep2Request(
                                        email: forgetPasswordNotifier
                                            .emailController.text,
                                        password: forgetPasswordNotifier
                                            .newPasswordController.text,
                                        source: forgetPasswordNotifier.selectedCountryDropdown == AppConstants.hongKong?AppConstants.hk:AppConstants.sg,
                                        token: forgetPasswordNotifier
                                            .otpController.text,
                                      ),
                                      context)
                                  .then((value) {
                                setState(() {
                                  forgetPasswordRepository.ErrorMessageGet =
                                      value.toString();
                                });
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
}
