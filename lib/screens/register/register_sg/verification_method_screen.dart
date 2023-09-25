import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/service/contact_repository.dart';
import 'package:singx/core/models/request_response/jumio_verification/jumio_verification_response.dart';
import 'package:singx/core/notifier/common_notifier.dart';
import 'package:singx/core/notifier/register_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';
import 'package:singx/utils/common/my_mob_fun.dart'
if (dart.library.html) 'package:singx/utils/common/my_web_fun.dart' as html;

class VerificationMethodScreen extends StatelessWidget {
  VerificationMethodScreen({Key? key}) : super(key: key);

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
                    buildVerificationText(context),
                    SizedBoxHeight(context, 0.05),
                    buildVerificationOptionText(context),
                    SizedBoxHeight(context, 0.05),
                    buildVerificationMethods(registerNotifier, context),
                    SizedBoxHeight(context, 0.05),
                    buildButtons(context, registerNotifier),
                    SizedBoxHeight(context, 0.05),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildVerificationText(BuildContext context) {
    return buildText(
      text: S.of(context).verification,
      fontSize: AppConstants.twenty,
      fontWeight: FontWeight.w700,
      fontColor: exchangeRateDatacolor,
    );
  }

  Widget buildVerificationOptionText(BuildContext context) {
    return buildText(
      text: S.of(context).pleaseChooseOneVerifyOptions,
      fontSize: AppConstants.twenty,
      fontWeight: FontWeight.w700,
    );
  }

  Widget buildVerificationMethods(
      RegisterNotifier registerNotifier, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Wrap(
            runSpacing: AppConstants.ten,
            children: [
              GestureDetector(
                onTap: () {
                  registerNotifier.isVerificationSelected = false;
                },
                child: buildVerifyMethod(
                  context,
                  number: 0,
                  width: getScreenWidth(context) < 450
                      ? getScreenWidth(context) * 0.86
                      : isTab(context) || isMobile(context)
                          ? getScreenWidth(context) * 0.60
                          : getScreenWidth(context) > 799 &&
                                  getScreenWidth(context) < 1150
                              ? getScreenWidth(context) * 0.35
                              : getScreenWidth(context) * 0.22,
                  height: getScreenWidth(context) < 285
                      ? 210
                      : getScreenHeight(context) < 700
                          ? 150
                          : 210,
                  values: [
                    SizedBoxHeight(context, 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildText(
                          text: S.of(context).selfieBasedVerification,
                          fontSize: AppConstants.sixteen,
                          fontWeight: FontWeight.w700,
                          fontColor: orangePantone,
                        ),
                        Padding(
                          padding: px8Right(context),
                          child: InkWell(
                            onTap: () {
                              registerNotifier.isVerificationSelected = false;
                            },
                            child: Container(
                              decoration: circleBoxDecorationStyle(context),
                              child: CircleAvatar(
                                radius: AppConstants.ten,
                                backgroundColor:
                                    registerNotifier.isVerificationSelected ==
                                            false
                                        ? orangePantone
                                        : Colors.white24,
                                child: CircleAvatar(
                                  radius: AppConstants.six,
                                  backgroundColor: white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: getScreenHeight(context) * 0.01),
                    buildText(
                      text: S.of(context).needToProvide,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: getScreenHeight(context) * 0.02),
                    registerNotifier.residentStatus == "Citizen" ||
                            registerNotifier.residentStatus ==
                                "Permanent Resident"
                        ? SizedBox()
                        : buildVerificationDocument(
                            context, S.of(context).proofofAddressWeb),
                    registerNotifier.residentStatus == "Citizen" ||
                            registerNotifier.residentStatus ==
                                "Permanent Resident"
                        ? SizedBox()
                        : SizedBox(height: getScreenHeight(context) * 0.01),
                    buildVerificationDocument(
                        context, S.of(context).singaporeIDCardFrontAndBackWeb),
                    SizedBox(height: getScreenHeight(context) * 0.01),
                    buildVerificationDocument(context, S.of(context).selfie),
                  ],
                  registerNotifier: registerNotifier,
                ),
              ),
              SizedBox(width: getScreenWidth(context) * 0.02),
              GestureDetector(
                onTap: () {
                  registerNotifier.isVerificationSelected = true;
                },
                child: buildVerifyMethod(
                  context,
                  number: 1,
                  width: getScreenWidth(context) < 450
                      ? getScreenWidth(context) * 0.86
                      : isTab(context) || isMobile(context)
                          ? getScreenWidth(context) * 0.60
                          : getScreenWidth(context) > 799 &&
                                  getScreenWidth(context) < 1150
                              ? getScreenWidth(context) * 0.35
                              : getScreenWidth(context) * 0.22,
                  height: getScreenHeight(context) < 700 ? 150 : 210,
                  values: [
                    SizedBoxHeight(context, 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildText(
                          text: S.of(context).eVerification,
                          fontSize: AppConstants.sixteen,
                          fontWeight: FontWeight.w700,
                          fontColor: orangePantone,
                        ),
                        Padding(
                          padding: px8Right(context),
                          child: GestureDetector(
                            onTap: () {
                              registerNotifier.isVerificationSelected = true;
                            },
                            child: Container(
                              decoration: circleBoxDecorationStyle(context),
                              child: CircleAvatar(
                                radius: AppConstants.ten,
                                backgroundColor:
                                    registerNotifier.isVerificationSelected ==
                                            true
                                        ? orangePantone
                                        : Colors.white24,
                                child: CircleAvatar(
                                  radius: AppConstants.six,
                                  backgroundColor: white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: getScreenHeight(context) * 0.01),
                    buildText(
                      text: S.of(context).needToProvide,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: getScreenHeight(context) * 0.02),
                    buildVerificationDocument(
                        context, S.of(context).postPaidMobileBillWeb),
                    SizedBox(height: getScreenHeight(context) * 0.01),
                    buildVerificationDocument(
                        context, S.of(context).singaporeIDCardFrontAndBackWeb),
                  ],
                  registerNotifier: registerNotifier,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildVerificationDocument(BuildContext context, title) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: oxfordBlueTint300,
          radius: AppConstants.seven,
          child: Center(
            child: Icon(
              Icons.check,
              size: AppConstants.ten,
              color: white,
            ),
          ),
        ),
        sizedBoxWidth5(context),
        Flexible(
          child: buildText(
            text: title,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget buildVerifyMethod(
    BuildContext context, {
    required List<Widget> values,
    double? height,
    double? width,
    number,
    required RegisterNotifier registerNotifier,
  }) {
    return Container(
      width: width ?? getScreenWidth(context) * 0.23,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: registerNotifier.isVerificationSelected == false && number == 0
              ? orangePantone
              : registerNotifier.isVerificationSelected == true && number == 1
                  ? orangePantone
                  : Colors.black.withOpacity(0.1),
        ),
        borderRadius: BorderRadius.circular(AppConstants.ten),
        color: white,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: isMobile(context) ? 8 : getScreenWidth(context) * 0.01,
          right: isMobile(context) ? 8 : 0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: values,
        ),
      ),
    );
  }

  apiJumioVerification(
      RegisterNotifier registerNotifier, BuildContext context) async {
    kIsWeb
        ?
    await contactRepository
        .apiJumioVerification(
        true, "00000000", context)
        .then((value) async {
      JumioVerificationResponse
      jumioVerificationResponse =
      value as JumioVerificationResponse;
      SharedPreferencesMobileWeb.instance.setJumioReference('jumioRefernce',jumioVerificationResponse.transactionReference!);
      html.openLink(
          '${jumioVerificationResponse.web?.href}');
    })
        : null;
    await contactRepository
        .apiJumioVerification(
    true, "00000000", context)
        .then((value) async {
    Navigator.pop(context);
    JumioVerificationResponse
    jumioVerificationResponse =
    value as JumioVerificationResponse;
    await registerNotifier.callJumioApis(
    context,
    "${jumioVerificationResponse.transactionReference}",
    "${jumioVerificationResponse.sdk?.token}");

    });
  }


  Widget buildButtons(BuildContext context, RegisterNotifier registerNotifier) {
    return commonBackAndContinueButton(
      context,
      backWidth: getScreenWidth(context) < 450
          ? getScreenWidth(context) * 0.43
          : isMobile(context)
              ? getScreenWidth(context) * 0.29
              : null,
      onPressedContinue: () async {
        Provider.of<CommonNotifier>(context, listen: false)
            .updateUserVerifiedBool = false;
        SharedPreferencesMobileWeb.instance.setUserVerified(false);
        if (registerNotifier.isVerificationSelected == true) {
          await SharedPreferencesMobileWeb.instance
              .getCountry(country)
              .then((value) async {
            Navigator.pushNamed(context, uploadMobileBillRoute);
          });
        } else {
          await SharedPreferencesMobileWeb.instance
              .getCountry(country)
              .then((value) async {
            registerNotifier.residentStatus == "Citizen" ||
                registerNotifier.residentStatus ==
                    "Permanent Resident" ? apiJumioVerification(registerNotifier, context) :
            Navigator.pushNamed(context, uploadAddressProofRoute);
          });
        }
      },
      onPressedBack: () async {
        await SharedPreferencesMobileWeb.instance
            .getCountry(country)
            .then((value) async {
          Navigator.pushNamed(context, personalDetailsRoute);
        });
      },
      continueWidth: getScreenWidth(context) < 450
          ? getScreenWidth(context) * 0.43
          : isMobile(context)
              ? getScreenWidth(context) * 0.29
              : null,
    );
  }
}
