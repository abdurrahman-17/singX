import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/service/contact_repository.dart';
import 'package:singx/core/models/request_response/sing_pass_url/sing_pass_url_response.dart';
import 'package:singx/core/models/request_response/singpass_code/singpass_code_request.dart';
import 'package:singx/core/notifier/common_notifier.dart';
import 'package:singx/core/notifier/register_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/main.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_images.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/common/my_mob_fun.dart'
    if (dart.library.html) 'package:singx/utils/common/my_web_fun.dart' as html;
import 'package:singx/utils/common/web_view.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class RegisterMethodScreen extends StatelessWidget {
  String? state;
  String? code;

  RegisterMethodScreen({Key? key, this.state, this.code}) : super(key: key);

  ContactRepository contactRepository = ContactRepository();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => checkSingPassVerify(context));
    return buildBody(context);}

  Widget buildBody(BuildContext context) {
    return state!.isNotEmpty?Container(): ChangeNotifierProvider(
      create: (BuildContext context) => RegisterNotifier(context),
      child: Consumer<RegisterNotifier>(
        builder: (context, registerNotifier, _) {
          return Scrollbar(
            thumbVisibility: true,
            controller: registerNotifier.scrollController,
            child: SingleChildScrollView(
              controller: registerNotifier.scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBoxHeight(context, 0.05),
                  buildHeaderText(context),
                  SizedBoxHeight(context, 0.02),
                  buildSubHeaderText(context),
                  SizedBoxHeight(context, 0.06),
                  buildRegistrationMethod(registerNotifier, context),
                  SizedBoxHeight(context, 0.06),
                  buildButtons(context, registerNotifier),
                  SizedBoxHeight(context, 0.06),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildHeaderText(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 8),
        child: buildText(
            text: S.of(context).selectYourRegistrationMethod,
            fontSize: 24,
            fontColor: oxfordBlue,
            fontWeight: FontWeight.w700));
  }

  Widget buildSubHeaderText(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 14),
        child: buildText(
            text: S.of(context).registationMethods,
            fontSize: 16,
            fontColor: oxfordBlueTint400,
            fontWeight: FontWeight.w400));
  }

  Widget buildRegistrationMethod(RegisterNotifier registerNotifier, context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: getScreenWidth(context) < 450
              ? getScreenWidth(context) * 0.05
              : isMobile(context)
                  ? getScreenWidth(context) * 0.15
                  : getScreenWidth(context) * 0.26),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Wrap(
              runSpacing: 10,
              children: [
                GestureDetector(
                  onTap: () {
                    SharedPreferencesMobileWeb.instance.setIsManualVerification(false);
                    registerNotifier.isRegistrationSelected = false;},
                  child: buildVerifyMethod(
                    context,
                    number: 0,
                    height: getScreenHeight(context) < 700 ? 160 : 180,
                    width: getScreenWidth(context) < 450
                        ? getScreenWidth(context) * 0.86
                        : isTab(context) || isMobile(context)
                            ? getScreenWidth(context) * 0.60
                            : getScreenWidth(context) > 799 &&
                                    getScreenWidth(context) < 1120
                                ? getScreenWidth(context) * 0.35
                                : getScreenWidth(context) * 0.22,
                    values: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildText(
                            text: S.of(context).manualVerification,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: InkWell(
                              onTap: () {
                                SharedPreferencesMobileWeb.instance.setIsManualVerification(false);
                                registerNotifier.isRegistrationSelected = false;
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: const Color(0xffEEEEEE),
                                        width: 2)),
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor:
                                      registerNotifier.isRegistrationSelected ==
                                              false
                                          ? orangePantone
                                          : Colors.white24,
                                  child: CircleAvatar(
                                    radius: 6,
                                    backgroundColor: white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: getScreenHeight(context) * 0.02),
                      Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: buildText(
                              text: S.of(context).mobileDetailAndAddress,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                    ],
                    registerNotifier: registerNotifier,
                  ),
                ),
                SizedBox(width: getScreenWidth(context) * 0.02),
                GestureDetector(
                  onTap: () {
                    SharedPreferencesMobileWeb.instance.setIsManualVerification(true);
                    registerNotifier.isRegistrationSelected = true;
                  },
                  child: buildVerifyMethod(
                    context,
                    number: 1,
                    height: getScreenHeight(context) < 700 ? 160 : 180,
                    width: getScreenWidth(context) < 450
                        ? getScreenWidth(context) * 0.86
                        : isTab(context) || isMobile(context)
                            ? getScreenWidth(context) * 0.60
                            : getScreenWidth(context) > 799 &&
                                    getScreenWidth(context) < 1120
                                ? getScreenWidth(context) * 0.35
                                : getScreenWidth(context) * 0.22,
                    values: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildText(
                            text: S.of(context).verifyVia,
                            fontWeight: FontWeight.w600,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                SharedPreferencesMobileWeb.instance.setIsManualVerification(true);
                                registerNotifier.isRegistrationSelected = true;
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: const Color(0xffEEEEEE),
                                        width: 2)),
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor:
                                      registerNotifier.isRegistrationSelected ==
                                              true
                                          ? orangePantone
                                          : white,
                                  child: CircleAvatar(
                                    radius: 6,
                                    backgroundColor: white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: getScreenHeight(context) * 0.005),
                      Image.asset(AppImages.singpassImage,
                          height: 20, width: 120),
                      SizedBox(height: getScreenHeight(context) * 0.01),
                      buildText(
                          text: S.of(context).fastestWayToGetAccount,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                      SizedBox(height: getScreenHeight(context) * 0.02),
                      buildButton(context,
                          height: 21,
                          width: 130,
                          name: S.of(context).recommended,
                          color: orangePantoneShade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          fontColor: white),
                    ],
                    registerNotifier: registerNotifier,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildButtons(BuildContext context, RegisterNotifier registerNotifier) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getScreenWidth(context) < 450
                ? getScreenWidth(context) * 0.05
                : isMobile(context)
                    ? getScreenWidth(context) * 0.15
                    : getScreenWidth(context) * 0.26),
        child: commonBackAndContinueButton(context,
            backWidth: getScreenWidth(context) < 450
                ? getScreenWidth(context) * 0.48
                : isMobile(context)
                    ? getScreenWidth(context) * 0.295
                    : getScreenWidth(context) > 570 &&
                            getScreenWidth(context) <= 600
                        ? getScreenWidth(context) * 0.24
                        : null, onPressedContinue: () async {
          Provider.of<CommonNotifier>(context, listen: false)
              .updateRegisterMethodScreenData(true);
          Provider.of<CommonNotifier>(context, listen: false)
              .updateUserVerifiedBool = false;
          SharedPreferencesMobileWeb.instance.setUserVerified(false);
          registerNotifier.isRegistrationSelected == true
              ? contactRepository.singPassUrl(context).then((value) {
                  SingPassUrl singPassUrl = value as SingPassUrl;
                  if (kIsWeb) {
                    html.openLink('${singPassUrl.url}');
                  } else {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    WebViewMobile(
                                      SingXUrl: singPassUrl.url,
                                      AppId: singPassUrl.id,
                                      from: AppConstants.singpass,
                                    )));
                  }
                })
              : await SharedPreferencesMobileWeb.instance
                  .getCountry(country)
                  .then((value) async {
                  Navigator.pushNamed(context, personalDetailsRoute);
                });
        }, onPressedBack: () {
              SharedPreferencesMobileWeb.instance.removeParticularKey(apiToken);
          Navigator.pushNamed(context, loginRoute);
        },
            continueWidth: getScreenWidth(context) < 450
                ? getScreenWidth(context) * 0.38
                : isMobile(context)
                    ? getScreenWidth(context) * 0.29
                    : null,
            name: S.of(context).backToLogin));
  }

  Widget buildVerifyMethod(BuildContext context,
      {required List<Widget> values,
      double? height,
      double? width,
      number,
      required RegisterNotifier registerNotifier}) {
    return InkWell(
      child: Container(
        height: height,
        width: width ?? getScreenWidth(context) * 0.23,
        decoration: BoxDecoration(
            border: Border.all(
                color: registerNotifier.isRegistrationSelected == false &&
                        number == 0
                    ? orangePantone
                    : registerNotifier.isRegistrationSelected == true &&
                            number == 1
                        ? orangePantone
                        : Colors.black.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(10),
            color: white),
        child: Padding(
          padding:
              EdgeInsets.only(left: 8, top: getScreenHeight(context) * 0.02),
          child: SingleChildScrollView(
            primary: true,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: values),
          ),
        ),
      ),
    );
  }

  checkSingPassVerify(context) async {
    if (state!.length > 2 && code!.length > 2) {
      apiLoader(context, from: "web");
      await contactRepository
          .apiSingPassVerify(
          SingPassCodeRequest(
            code: code,
            state: state!,
          ),
          context)
          .then((value) async {
        MyApp.navigatorKey.currentState!.maybePop();
        if (value == true) {
          await RegisterNotifier(context).getAuthStatus(context, from: "web");
        }
      });
    }
  }
}
