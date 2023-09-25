import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/notifier/common_notifier.dart';
import 'package:singx/core/notifier/register_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/screens/register/register_sg/address_verify.dart';
import 'package:singx/screens/register/register_sg/personal_detail.dart';
import 'package:singx/screens/register/register_sg/register_methods.dart';
import 'package:singx/screens/register/register_sg/upload_address.dart';
import 'package:singx/screens/register/register_sg/upload_documents.dart';
import 'package:singx/screens/register/register_sg/upload_mobile_bill.dart';
import 'package:singx/screens/register/register_sg/verification_method_screen.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_images.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class RegisterHomeScreen extends StatelessWidget {
  final selected;
  String? state;
  String? code;
  String? transactionReference;

  RegisterHomeScreen(
      {Key? key,
      required this.selected,
      this.state,
      this.code,
      this.transactionReference})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    checkSingPassVerify(context);
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          RegisterNotifier(context, selected: selected, referenceNumber: transactionReference),
      child: Consumer<RegisterNotifier>(
        builder: (context, registerNotifier, _) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: white,
            appBar: registerNotifier.selected == 7 || state!.isNotEmpty ||  transactionReference!.isNotEmpty
                ?null:PreferredSize(
              preferredSize: Size.fromHeight(AppConstants.sixtyfive),
              child: AppBar(
                leadingWidth:kIsWeb? getScreenWidth(context) < 290
                    ? 80
                    : AppConstants.appBarFlagWidth:registerNotifier.screenSize < 290
                    ? 80:AppConstants.appBarFlagWidth,
                backgroundColor: white,
                elevation: AppConstants.zero,
                leading: Padding(
                  padding: EdgeInsets.only(
                    left:kIsWeb? getScreenWidth(context) * 0.01:10,
                    top: kIsWeb? getScreenHeight(context) * 0.005:5),
                  child: Image.asset(AppImages.singXLogoWeb),
                ),
                actions: [
                  Padding(
                    padding:
                        EdgeInsets.only(right: kIsWeb? (getScreenWidth(context) * 0.01):20),
                    child: CloseButton(
                        onPressed: () async {
                          Provider.of<CommonNotifier>(context, listen: false)
                              .updateUserVerifiedBool = false;
                          SharedPreferencesMobileWeb.instance
                              .setUserVerified(false);
                          Provider.of<CommonNotifier>(context, listen: false)
                              .updateData(1);
                          registerCloseAlert(context);
                        },
                        color: oxfordBlueTint400),
                  )
                ],
                title:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  buildCircle(context,
                      stepNumber: AppConstants.registerStepperOne,
                      registerNotifier: registerNotifier),
                  buildSizedBox(context,registerNotifier),
                  Visibility(
                    visible: kIsWeb? getScreenWidth(context) < 640 ? false : true:false,
                    child: buildHeaderName(context,
                        name: S.of(context).getStartedWeb,
                        stepNumber: AppConstants.registerStepperOne,
                        registerNotifier: registerNotifier),
                  ),
                  buildSizedBox(context,registerNotifier),
                  buildLine(context, AppConstants.registerStepperOne,
                      registerNotifier: registerNotifier),
                  buildSizedBox(context,registerNotifier),
                  buildCircle(context,
                      stepNumber: AppConstants.registerStepperTwo,
                      registerNotifier: registerNotifier),
                  buildSizedBox(context,registerNotifier),
                  Visibility(
                    visible:kIsWeb? getScreenWidth(context) < 640 ? false : true:false,
                    child: buildHeaderName(context,
                        name: S.of(context).personalDetailsWeb,
                        stepNumber: AppConstants.registerStepperTwo,
                        registerNotifier: registerNotifier),
                  ),
                  buildSizedBox(context,registerNotifier),
                  buildLine(context, AppConstants.registerStepperTwo,
                      registerNotifier: registerNotifier),
                  buildSizedBox(context,registerNotifier),
                  buildCircle(context,
                      stepNumber: AppConstants.registerStepperThree,
                      registerNotifier: registerNotifier),
                  buildSizedBox(context,registerNotifier),
                  Visibility(
                    visible: kIsWeb? getScreenWidth(context) < 640 ? false : true:false,
                    child: buildHeaderName(context,
                        name: S.of(context).verification,
                        stepNumber: AppConstants.registerStepperThree,
                        registerNotifier: registerNotifier),
                  ),
                ]),
              ),
            ),
            body: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
                child: Column(
                  children: [
                    registerNotifier.selected == 7 || state!=null ||  transactionReference != null
                        ?SizedBox(): Container(
                      height: 12.5,
                      foregroundDecoration:
                          BoxDecoration(gradient: topBarGradientRegistartion),
                    ),
                    Expanded(
                      child: registerNotifier.selected == 1
                          ? RegisterMethodScreen(
                              state: state ?? "",
                              code: code ?? "",
                            )
                          : registerNotifier.selected == 2
                              ? const PersonalDetailScreen()
                              : registerNotifier.selected == 3
                                  ? AddressVerifyScreen()
                                  : registerNotifier.selected == 4
                                      ? VerificationMethodScreen()
                                      : registerNotifier.selected == 5
                                          ? UploadMobileScreen()
                                          : registerNotifier.selected == 6
                                              ? UploadAddressScreen(
                                                  transactionReference:
                                                      transactionReference??"",
                                                )
                                              : registerNotifier.selected == 7
                                                  ? UploadDocumentScreen()
                                                  : Container(
                                                      color: Colors.white,
                                                    ),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }

  Widget buildHeaderName(BuildContext context,
      {name, stepNumber, required RegisterNotifier registerNotifier}) {
    return GestureDetector(
      onTap: () => checkPaginationData(stepNumber, registerNotifier, context),
      child: buildText(
        text: name,
        fontColor: (registerNotifier.selected == 1 && stepNumber == '1') ||
                (registerNotifier.selected == 2 && stepNumber == '2') ||
                (registerNotifier.selected == 3 && stepNumber == '3') ||
                (registerNotifier.selected == 4 && stepNumber == '3') ||
                (registerNotifier.selected == 5 && stepNumber == '3') ||
                (registerNotifier.selected == 6 && stepNumber == '3') ||
                (registerNotifier.selected == 7 && stepNumber == '3')
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
                        stepNumber == '1' && stepNumber == '2') ||
                    (registerNotifier.selected == 4 ||
                        stepNumber == '1' && stepNumber == '2') ||
                    (registerNotifier.selected == 5 ||
                        stepNumber == '1' && stepNumber == '2') ||
                    (registerNotifier.selected == 6 ||
                        stepNumber == '1' && stepNumber == '2') ||
                    (registerNotifier.selected == 7 ||
                        stepNumber == '1' && stepNumber == '2')
                ? darkBluecc
                : oxfordBlueTint400,
      ),
    );
  }

  Widget buildCircle(BuildContext context,
      {stepNumber, required RegisterNotifier registerNotifier}) {
    return GestureDetector(
      onTap: () => checkPaginationData(stepNumber, registerNotifier, context),
      child: CircleAvatar(
        radius: 15,
        backgroundColor:
            (registerNotifier.selected == 1 && stepNumber == '1') ||
                    (registerNotifier.selected == 2 && stepNumber == '2') ||
                    (registerNotifier.selected == 3 && stepNumber == '3') ||
                    (registerNotifier.selected == 4 && stepNumber == '3') ||
                    (registerNotifier.selected == 5 && stepNumber == '3') ||
                    (registerNotifier.selected == 6 && stepNumber == '3') ||
                    (registerNotifier.selected == 7 && stepNumber == '3')
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
                            stepNumber == '1' && stepNumber == '2') ||
                        (registerNotifier.selected == 4 ||
                            stepNumber == '1' && stepNumber == '2') ||
                        (registerNotifier.selected == 5 ||
                            stepNumber == '1' && stepNumber == '2') ||
                        (registerNotifier.selected == 6 ||
                            stepNumber == '1' && stepNumber == '2') ||
                        (registerNotifier.selected == 7 ||
                            stepNumber == '1' && stepNumber == '2')
                    ? darkBlue99
                    : gray85Color,
        child: Text(
          stepNumber,
          style: TextStyle(
              color: (registerNotifier.selected == 1 && stepNumber == '1') ||
                      (registerNotifier.selected == 2 && stepNumber == '2') ||
                      (registerNotifier.selected == 3 && stepNumber == '3') ||
                      (registerNotifier.selected == 4 && stepNumber == '3') ||
                      (registerNotifier.selected == 5 && stepNumber == '3') ||
                      (registerNotifier.selected == 6 && stepNumber == '3') ||
                      (registerNotifier.selected == 7 && stepNumber == '3') ||
                      (registerNotifier.selected == 2 && stepNumber == '1') ||
                      (registerNotifier.selected == 3 ||
                          stepNumber == '1' && stepNumber == '2') ||
                      (registerNotifier.selected == 4 ||
                          stepNumber == '1' && stepNumber == '2') ||
                      (registerNotifier.selected == 5 ||
                          stepNumber == '1' && stepNumber == '2') ||
                      (registerNotifier.selected == 6 ||
                          stepNumber == '1' && stepNumber == '2') ||
                      ((registerNotifier.selected == 1 ||
                              registerNotifier.selected == 2) &&
                          registerNotifier.isPersonalDetail == true &&
                          registerNotifier.isVerificationFinished == true &&
                          stepNumber == '3') ||
                      (registerNotifier.selected == 1 &&
                          registerNotifier.isPersonalDetail == true &&
                          stepNumber == '2') ||
                      (registerNotifier.selected == 7 ||
                          stepNumber == '1' && stepNumber == '2')
                  ? white
                  : oxfordBlueTint400),
        ),
      ),
    );
  }

  Widget buildLine(BuildContext context, stepNumber,
      {width, required RegisterNotifier registerNotifier}) {
    return Container(
      height: kIsWeb?getScreenHeight(context) * 0.002:2,
      width: kIsWeb?width ??getScreenWidth(context) * 0.03:registerNotifier.screenSize<500?width ??10:width ??30,
      color: (registerNotifier.selected == 1 && stepNumber == '1') ||
              (registerNotifier.selected == 2 && stepNumber == '1') ||
              (registerNotifier.selected == 3 ||
                  stepNumber == '1' && stepNumber == '2') ||
              (registerNotifier.selected == 4 ||
                  stepNumber == '1' && stepNumber == '2') ||
              (registerNotifier.selected == 5 ||
                  stepNumber == '1' && stepNumber == '2') ||
              (registerNotifier.selected == 6 ||
                  stepNumber == '1' && stepNumber == '2') ||
              (registerNotifier.selected == 7 ||
                  stepNumber == '1' && stepNumber == '2') ||
              ((registerNotifier.selected == 1 ||
                      registerNotifier.selected == 2) &&
                  registerNotifier.isPersonalDetail == true &&
                  registerNotifier.isVerificationFinished == true &&
                  stepNumber == '2')
          ? darkBlue99
          : gray85Color,
    );
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

  checkPaginationData(stepNumber, RegisterNotifier registerNotifier, context) async {
    if (stepNumber == "1" &&
        registerNotifier.isMethodSelected == true &&
        registerNotifier.isPersonalDetail == true &&
        registerNotifier.isVerificationFinished == true) {
      Navigator.pushNamed(context, registerMethodRoute);
    } else if (stepNumber == "2" &&
        registerNotifier.isMethodSelected == true &&
        registerNotifier.isPersonalDetail == true &&
        registerNotifier.isVerificationFinished == true) {
      await SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        Navigator.pushNamed(context, personalDetailsRoute);
      });
    } else if (stepNumber == "1" &&
        registerNotifier.isMethodSelected == true &&
        registerNotifier.isPersonalDetail == true) {
      await SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        Navigator.pushNamed(context, registerMethodRoute);
      });
    } else if (stepNumber == "2" &&
        registerNotifier.isMethodSelected == true &&
        registerNotifier.isPersonalDetail == true) {
      await SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        Navigator.pushNamed(context, personalDetailsRoute);
      });
      //2nd page
    } else if (stepNumber == "3" &&
        registerNotifier.isMethodSelected == true &&
        registerNotifier.isPersonalDetail == true) {
      await SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        Navigator.pushNamed(context, addressVerifyRoute);
      });
    } else if (stepNumber == "1" && registerNotifier.isMethodSelected == true) {
      await SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        Navigator.pushNamed(context, registerMethodRoute);
      });
      //1st page
    } else if (stepNumber == "2" && registerNotifier.isMethodSelected == true) {
      await SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        Navigator.pushNamed(context, personalDetailsRoute);
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please finish last Step'),duration: Duration(seconds: 3),));
    }
  }

  checkSingPassVerify(context) async {
    await userCheck(context);
  }

}
