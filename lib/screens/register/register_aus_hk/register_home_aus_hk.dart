import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singx/core/notifier/common_notifier.dart';
import 'package:singx/core/notifier/register_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/screens/register/register_aus_hk/additional_details.dart';
import 'package:singx/screens/register/register_aus_hk/digital_verification.dart';
import 'package:singx/screens/register/register_aus_hk/non_digital_verfication.dart';
import 'package:singx/screens/register/register_aus_hk/personal_detail_aus_hk.dart';
import 'package:singx/screens/register/register_aus_hk/upload_your_documents.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_images.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';

import '../../../utils/shared_preference/shared_preference_mobile_web.dart';

class RegisterHkAusHomeScreen extends StatelessWidget {
  final selected;
  final digitalVerification;
  final isOTP;

  RegisterHkAusHomeScreen({
    Key? key,
    required this.selected,
    this.digitalVerification, this.isOTP,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    checkUser(context);
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => RegisterNotifier(context),
      child: Consumer<RegisterNotifier>(
        builder: (context, registerNotifier, _) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            registerNotifier.selected = selected;
            SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) {
              registerNotifier.selectedCountry = value;
            });
          });

          return Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: white,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(AppConstants.sixtyfive),
                child: AppBar(
                  leadingWidth: AppConstants.appBarFlagWidth,
                  backgroundColor: white,
                  elevation: AppConstants.zero,
                  leading: Padding(
                    padding: EdgeInsets.only(
                        left: kIsWeb? getScreenWidth(context) * 0.01:10,
                        top: kIsWeb? getScreenHeight(context) * 0.005:5),
                    child: Image.asset(AppImages.singXLogoWeb),
                  ),
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(
                          right: kIsWeb? (getScreenWidth(context) * 0.01):20),
                      child: CloseButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            SharedPreferencesMobileWeb.instance
                                .setMethodSelectedAUS('methodSelectedAUS',false);
                            Provider.of<CommonNotifier>(context, listen: false)
                                .updateData(1);
                            await prefs.setBool('logged', false);
                            Provider.of<CommonNotifier>(context, listen: false)
                                .updateUserVerifiedBool = false;
                            await SharedPreferencesMobileWeb.instance
                                .setUserVerified(false);
                            registerCloseAlert(context);
                          },
                          color: oxfordBlueTint400),
                    )
                  ],
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildCircle(context,
                          number: '1',
                          value: 1,
                          registerNotifier: registerNotifier),
                      buildSizedBox(context,registerNotifier),
                      Visibility(
                        visible: kIsWeb? getScreenWidth(context) < 640 ? false : true:false,
                        child: buildHeaderName(context,
                            name: S.of(context).personalDetails,
                            stepNumber: '1',
                            value: 1,
                            registerNotifier: registerNotifier),
                      ),
                      buildSizedBox(context,registerNotifier),
                      buildLine(context, '1',registerNotifier),
                      buildSizedBox(context,registerNotifier),
                      buildCircle(context,
                          number: '2',
                          value: 2,
                          registerNotifier: registerNotifier),
                      buildSizedBox(context,registerNotifier),
                      Visibility(
                        visible:  kIsWeb? getScreenWidth(context) < 640 ? false : true:false,
                        child: buildHeaderName(context,
                            name: registerNotifier.selectedCountry == AppConstants.australia? "Identification Details":"Upload Your Documents",
                            stepNumber: '2',
                            value: 2,
                            registerNotifier: registerNotifier),
                      ),
                      Visibility(
                        visible: registerNotifier.selectedCountry ==
                            AppConstants.hongKong,
                        child: Row(
                          children: [
                            buildSizedBox(context,registerNotifier),
                            buildLine(context, '2',registerNotifier),
                            buildSizedBox(context,registerNotifier),
                            buildCircle(context,
                                number: '3',
                                value: 3,
                                registerNotifier: registerNotifier),
                            buildSizedBox(context,registerNotifier),
                            Visibility(
                              visible:
                              kIsWeb? getScreenWidth(context) < 640 ? false : true:false,
                              child: buildHeaderName(context,
                                  name: "Additional Details",
                                  stepNumber: '3',
                                  value: 3,
                                  registerNotifier: registerNotifier),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
                child: Column(
                  children: [
                    Container(
                      height: 12.5,
                      foregroundDecoration:
                          BoxDecoration(gradient: topBarGradientRegistartion),
                    ),
                    Expanded(
                      child: selected == 1
                          ? PersonalDetailHkAusScreen()
                          : selected == 2
                              ? registerNotifier.selectedCountry ==
                                      AppConstants.hongKong
                                  ? const UploadYourDocuments()
                                  : digitalVerification == true
                                      ? AustraliaDigitalVerification()
                                      : AustraliaNonDigitalVerification()
                              : registerNotifier.selectedCountry ==
                                      AppConstants.hongKong
                                  ? selected == 3
                                      ?  AdditionalDetails(isOtp: isOTP,)
                                      : SizedBox()
                                  : SizedBox(),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }

  Widget buildHeaderName(BuildContext context,
      {name, stepNumber, value, required RegisterNotifier registerNotifier}) {
    return GestureDetector(
      onTap: () => checkPaginationData(stepNumber, registerNotifier, context),
      child: buildText(
        text: name,
        fontColor: (registerNotifier.selected == 1 && stepNumber == '1') ||
                (registerNotifier.selected == 2 && stepNumber == '2')
            ? hanBlueshades400
            : ((registerNotifier.selected == 1 ||
                            registerNotifier.selected == 2) &&
                        registerNotifier.isPersonalDetail == true &&
                        registerNotifier.isVerificationFinished == true &&
                        stepNumber == '3') ||
                    (registerNotifier.selected == 1 &&
                        registerNotifier.isPersonalDetail == true &&
                        stepNumber == '2') ||
                    (registerNotifier.selected == 2 && stepNumber == '1') ||
                    (registerNotifier.selected == 3 ||
                        stepNumber == '1' && stepNumber == '2')
                ? darkBluecc
                : oxfordBlueTint400,
      ),
    );
  }

  Widget buildCircle(BuildContext context,
      {number, value, required RegisterNotifier registerNotifier}) {
    return GestureDetector(
      onTap: () => checkPaginationData(number, registerNotifier, context),
      child: CircleAvatar(
        radius: 15,
        backgroundColor: (registerNotifier.selected == 1 && number == '1') ||
                (registerNotifier.selected == 2 && number == '2') ||
                (registerNotifier.selected == 3 && number == '3')
            ? hanBlueshades400
            : ((registerNotifier.selected == 1 ||
                            registerNotifier.selected == 2) &&
                        registerNotifier.isPersonalDetail == true &&
                        registerNotifier.isVerificationFinished == true) ||
                    (registerNotifier.selected == 1 &&
                        registerNotifier.isPersonalDetail == true &&
                        number == '1') ||
                    (registerNotifier.selected == 2 && number == '1') ||
                    (registerNotifier.selected == 3 ||
                        number == '1' && number == '2')
                ? darkBlue99
                : gray85Color,
        child: Text(
          number,
          style: TextStyle(
              color: (registerNotifier.selected == 1 && number == '1') ||
                      (registerNotifier.selected == 2 && number == '1') ||
                      (registerNotifier.selected == 2 && number == '2') ||
                      (registerNotifier.selected == 3 && number == '1') ||
                      (registerNotifier.selected == 3 && number == '2') ||
                      (registerNotifier.selected == 3 && number == '3') ||
                      (registerNotifier.selected == 1 &&
                          registerNotifier.isPersonalDetail == true &&
                          number == '1') ||
                      (registerNotifier.selected == 1 &&
                          registerNotifier.isPersonalDetail == true &&
                          number == '2') ||
                      (registerNotifier.selected == 1 &&
                          registerNotifier.isPersonalDetail == true &&
                          number == '3')
                  ? white
                  : oxfordBlueTint400),
        ),
      ),
    );
  }

  Widget buildLine(BuildContext context, number, RegisterNotifier registerNotifier, {width}) {
    return Container(
        height: kIsWeb?getScreenHeight(context) * 0.002:2,
        width: kIsWeb?width ??getScreenWidth(context) * 0.03:registerNotifier.screenSize<500?width ??10:width ??30,
        color: darkBlue99);
  }

  Widget buildSizedBox(BuildContext context, RegisterNotifier registerNotifier) {
    return kIsWeb ? SizedBoxWidth(
        context,
        isTab(context)
            ? 0.005
            : isMobile(context)
            ? 0.002
            : 0.02):registerNotifier.screenSize<500?SizedBox():sizedBoxWidth5(context);
  }

  checkPaginationData(stepNumber, RegisterNotifier registerNotifier,
      BuildContext context) async {
    if (stepNumber == "1" && registerNotifier.isMethodSelectedAus == true) {
      await SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        Navigator.pushNamed(context, registerHongKongHomeScreen);
      });
    } else if (stepNumber == "2" &&
        registerNotifier.isMethodSelectedAus == true) {
      await SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        Navigator.pushNamed(context, uploadHKIDProofRoute);
      });
    } else {
      showSnackBar('Please finish last Step', context);
    }
  }

  checkUser(context) async {
    await userCheck(context);
  }
}
