import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/notifier/common_notifier.dart';
import 'package:singx/core/notifier/fund_transfer_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/screens/fund_transfer/account.dart';
import 'package:singx/screens/fund_transfer/receiver.dart';
import 'package:singx/screens/fund_transfer/review.dart';
import 'package:singx/screens/fund_transfer/transaction.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_images.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class FundTransferLandingScreen extends StatelessWidget {
  final int selected;

  FundTransferLandingScreen({Key? key, required this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    userCheck(context);
    startTimer(context);
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          FundTransferNotifier(context, fundCountValue: selected),
      child: Consumer<FundTransferNotifier>(
          builder: (context, fundTransferNotifier, _) {
        return AppInActiveCheck(
            context: context,
            child: AppInActiveCheck(
              context: context,
              child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  backgroundColor: white,
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(AppConstants.sixtyfive),
                    child: AppBar(
                      leadingWidth:kIsWeb? getScreenWidth(context) < 350
                          ? AppConstants.sixty
                          : getScreenWidth(context) > 350 &&
                                  getScreenWidth(context) < 380
                              ? AppConstants.hundred
                              : getScreenWidth(context) >= 870 &&
                                      getScreenWidth(context) < 910
                                  ? AppConstants.oneHundredAndTen
                                  : AppConstants.appBarFlagWidth:fundTransferNotifier.screenSize < 350 ? AppConstants.sixty :fundTransferNotifier.screenSize > 350 &&
                          fundTransferNotifier.screenSize < 380
                          ? AppConstants.hundred
                          : AppConstants.appBarFlagWidth,
                      backgroundColor: white,
                      elevation: AppConstants.zero,
                      leading: Padding(
                          padding: EdgeInsets.only(
                              left:kIsWeb? getScreenWidth(context) * 0.01 : screenSizeWidth * 0.01,
                              top: kIsWeb? getScreenWidth(context) * 0.005 : screenSizeWidth * 0.005),
                          child: Image.asset(AppImages.singXLogoWeb)),
                      actions: [
                        Padding(
                            padding: EdgeInsets.only(
                                right:kIsWeb? (getScreenWidth(context) * 0.01) : screenSizeWidth * 0.01),
                            child: CloseButton(
                                onPressed: () async {
                                  fundTransferCloseAlert(context,
                                      navigation: () {
                                    String data = '';
                                    SharedPreferencesMobileWeb.instance
                                        .getStepperRoute('Stepper')
                                        .then((value) async {
                                      data = value;

                                  if (data == "Dashboard") {
                                    await SharedPreferencesMobileWeb
                                        .instance
                                        .getCountry(AppConstants.country)
                                        .then((value) async {
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          dashBoardRoute,
                                          (route) => false);
                                    });
                                  } else if (data == "Manage receivers") {
                                    await SharedPreferencesMobileWeb
                                        .instance
                                        .getCountry(AppConstants.country)
                                        .then((value) async {
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          manageReceiverRoute,
                                          (route) => false);
                                    });
                                  } else {}
                                });
                              });
                              Provider.of<CommonNotifier>(context,
                                      listen: false)
                                  .updateDataFund(1);
                              await SharedPreferencesMobileWeb.instance
                                  .removeParticularKey(AppConstants.accountScreenData);
                              await SharedPreferencesMobileWeb.instance
                                  .removeParticularKey(AppConstants.receiverScreenData);
                              await SharedPreferencesMobileWeb.instance
                                  .removeParticularKey(AppConstants.reviewScreenData);
                              SharedPreferencesMobileWeb.instance
                                  .setAccountSelectedScreenData(
                                  AppConstants.accountPage, false);
                              SharedPreferencesMobileWeb.instance
                                  .setReceiverSelectedScreenData(
                                  AppConstants.receiverPage, false);
                              SharedPreferencesMobileWeb.instance
                                  .setReviewSelectedScreenData(
                                  AppConstants.reviewPage, false);
                            },
                            color: oxfordBlueTint400))
                      ],
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildCircle(context,
                                stepNumber: AppConstants.fundTransferStepperOne,
                                fundTransferNotifier: fundTransferNotifier),
                            buildSizedBox(context,fundTransferNotifier),
                            Visibility(
                                visible:kIsWeb? getScreenWidth(context) < 870
                                    ? false
                                    : true:false,
                                child: buildHeaderName(context,
                                    name: S.of(context).selectAccount,
                                    stepNumber:
                                        AppConstants.fundTransferStepperOne,
                                    fundTransferNotifier:
                                        fundTransferNotifier)),
                            buildSizedBox(context,fundTransferNotifier),
                            buildLine(AppConstants.fundTransferStepperOne,
                                fundTransferNotifier, context),
                            buildSizedBox(context,fundTransferNotifier),
                            buildCircle(context,
                                stepNumber: AppConstants.fundTransferStepperTwo,
                                fundTransferNotifier: fundTransferNotifier),
                            buildSizedBox(context,fundTransferNotifier),
                            Visibility(
                                visible:kIsWeb? getScreenWidth(context) < 870
                                    ? false
                                    : true:false,
                                child: buildHeaderName(context,
                                    name: S.of(context).selectReceiver,
                                    stepNumber:
                                        AppConstants.fundTransferStepperTwo,
                                    fundTransferNotifier:
                                        fundTransferNotifier)),
                            buildSizedBox(context,fundTransferNotifier),
                            buildLine(AppConstants.fundTransferStepperTwo,
                                fundTransferNotifier, context),
                            buildSizedBox(context,fundTransferNotifier),
                            buildCircle(context,
                                stepNumber:
                                    AppConstants.fundTransferStepperThree,
                                fundTransferNotifier: fundTransferNotifier),
                            buildSizedBox(
                              context,fundTransferNotifier
                            ),
                            Visibility(
                                visible:kIsWeb? getScreenWidth(context) < 870
                                    ? false
                                    : true:false,
                                child: buildHeaderName(context,
                                    name: S.of(context).reviewWeb,
                                    stepNumber:
                                        AppConstants.fundTransferStepperThree,
                                    fundTransferNotifier:
                                        fundTransferNotifier)),
                            buildSizedBox(context,fundTransferNotifier),
                            buildLine(
                              AppConstants.fundTransferStepperThree,
                              fundTransferNotifier,
                              context,
                            ),
                            buildSizedBox(context,fundTransferNotifier),
                            buildCircle(context,
                                stepNumber:
                                    AppConstants.fundTransferStepperFour,
                                fundTransferNotifier: fundTransferNotifier),
                            buildSizedBox(context,fundTransferNotifier),
                            Visibility(
                                visible:kIsWeb? getScreenWidth(context) < 870
                                    ? false
                                    : true:false,
                                child: buildHeaderName(context,
                                    name: S.of(context).transferWeb,
                                    stepNumber:
                                        AppConstants.fundTransferStepperFour,
                                    fundTransferNotifier:
                                        fundTransferNotifier)),
                          ]),
                    ),
                  ),
                  body: GestureDetector(
                    onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
                    child: Scrollbar(
                      controller: fundTransferNotifier.scrollController,
                      child: Column(children: [
                        Container(
                            height: AppConstants.twelvePointFive,
                            foregroundDecoration: BoxDecoration(
                                gradient: topBarGradientRegistartion)),
                        Expanded(
                            child: fundTransferNotifier.fundCount == 1
                                ? Account(accountPageNotifier: fundTransferNotifier)
                                : fundTransferNotifier.fundCount == 2
                                    ? Receiver(receiverPageNotifier: fundTransferNotifier)
                                    : fundTransferNotifier.fundCount == 3
                                        ? Review(reviewPageNotifier: fundTransferNotifier)
                                        : Transaction(transactionPageNotifier: fundTransferNotifier))
                      ]),
                    ),
                  )),
            ));
      }),
    );
  }

  // AppBar Stepper Header Name
  Widget buildHeaderName(BuildContext context, {name, stepNumber, required FundTransferNotifier fundTransferNotifier}) {
    return GestureDetector(
        onTap: () => checkData(stepNumber, fundTransferNotifier, context),
        child: buildText(
            text: name,
            fontColor: (fundTransferNotifier.fundCount == 1 &&
                        stepNumber == '1') ||
                    (fundTransferNotifier.fundCount == 2 &&
                        stepNumber == '2') ||
                    (fundTransferNotifier.fundCount == 3 &&
                        stepNumber == '3') ||
                    (fundTransferNotifier.fundCount == 4 && stepNumber == '4')
                ? hanBlueshades400
                : ((fundTransferNotifier.fundCount == 1 ||
                                fundTransferNotifier.fundCount == 2) &&
                            fundTransferNotifier.isReceiverSelected == true &&
                            fundTransferNotifier.isReviewSelected == true &&
                            stepNumber == '3') ||
                        (fundTransferNotifier.fundCount == 1 &&
                            fundTransferNotifier.isReceiverSelected == true &&
                            stepNumber == '2') ||
                        (fundTransferNotifier.fundCount == 2 &&
                            stepNumber == '1') ||
                        (fundTransferNotifier.fundCount == 3 &&
                                stepNumber == '1' ||
                            fundTransferNotifier.fundCount == 3 &&
                                stepNumber == '2') ||
                        (fundTransferNotifier.fundCount == 4 ||
                            stepNumber == '1' &&
                                stepNumber == '2' &&
                                stepNumber == '3')
                    ? darkBluecc
                    : oxfordBlueTint400));
  }

  // AppBar Number circle
  Widget buildCircle(BuildContext context, {stepNumber, required FundTransferNotifier fundTransferNotifier}) {
    return GestureDetector(
      onTap: () => checkData(stepNumber, fundTransferNotifier, context),
      child: CircleAvatar(
        radius: AppConstants.fifteen,
        backgroundColor: (fundTransferNotifier.fundCount == 1 &&
                    stepNumber == '1') ||
                (fundTransferNotifier.fundCount == 2 && stepNumber == '2') ||
                (fundTransferNotifier.fundCount == 3 && stepNumber == '3') ||
                (fundTransferNotifier.fundCount == 4 && stepNumber == '4')
            ? hanBlueshades400
            : ((fundTransferNotifier.fundCount == 1 ||
                            fundTransferNotifier.fundCount == 2) &&
                        fundTransferNotifier.isReceiverSelected == true &&
                        fundTransferNotifier.isReviewSelected == true &&
                        stepNumber == '3') ||
                    (fundTransferNotifier.fundCount == 1 &&
                        fundTransferNotifier.isReceiverSelected == true &&
                        stepNumber == '2') ||
                    (fundTransferNotifier.fundCount == 2 &&
                        stepNumber == '1') ||
                    (fundTransferNotifier.fundCount == 3 &&
                        stepNumber == '1') ||
                    (fundTransferNotifier.fundCount == 3 &&
                        stepNumber == '2') ||
                    (fundTransferNotifier.fundCount == 4 &&
                        stepNumber == '1') ||
                    (fundTransferNotifier.fundCount == 4 &&
                        stepNumber == '2') ||
                    (fundTransferNotifier.fundCount == 4 && stepNumber == '3')
                ? darkBlue99
                : gray85Color,
        child: Text(
          stepNumber,
          style: TextStyle(
              color:
                  (fundTransferNotifier.fundCount == 1 && stepNumber == '1') ||
                          (fundTransferNotifier.fundCount == 2 &&
                              stepNumber == '2') ||
                          (fundTransferNotifier.fundCount == 3 &&
                              stepNumber == '3') ||
                          (fundTransferNotifier.fundCount == 4 &&
                              stepNumber == '4') ||
                          (fundTransferNotifier.fundCount == 2 &&
                              stepNumber == '1') ||
                          (fundTransferNotifier.fundCount == 3 &&
                              stepNumber == '1') ||
                          (fundTransferNotifier.fundCount == 3 &&
                              stepNumber == '2') ||
                          (fundTransferNotifier.fundCount == 4 &&
                              stepNumber == '1') ||
                          (fundTransferNotifier.fundCount == 4 &&
                              stepNumber == '2') ||
                          (fundTransferNotifier.fundCount == 4 &&
                              stepNumber == '3') ||
                          ((fundTransferNotifier.fundCount == 1 ||
                                  fundTransferNotifier.fundCount == 2) &&
                              fundTransferNotifier.isReceiverSelected == true &&
                              fundTransferNotifier.isReviewSelected == true &&
                              stepNumber == '3') ||
                          (fundTransferNotifier.fundCount == 1 &&
                              fundTransferNotifier.isReceiverSelected == true &&
                              stepNumber == '2')
                      ? white
                      : oxfordBlueTint400),
        ),
      ),
    );
  }

  // Line between numbers
  Widget buildLine(stepNumber, FundTransferNotifier fundTransferNotifier, BuildContext context) {
    return Container(
        height: kIsWeb ? getScreenHeight(context) * 0.002 : screenSizeWidth * 0.002,
        width: kIsWeb?getScreenWidth(context) * 0.03 : screenSizeWidth * 0.03,
        color: (fundTransferNotifier.fundCount == 1 && stepNumber == '1') ||
                (fundTransferNotifier.fundCount == 2 && stepNumber == '1') ||
                (fundTransferNotifier.fundCount == 3 && stepNumber == '1') ||
                (fundTransferNotifier.fundCount == 3 && stepNumber == '2') ||
                (fundTransferNotifier.fundCount == 4 && stepNumber == '1') ||
                (fundTransferNotifier.fundCount == 4 && stepNumber == '2') ||
                (fundTransferNotifier.fundCount == 4 && stepNumber == '3') ||
                ((fundTransferNotifier.fundCount == 1 ||
                        fundTransferNotifier.fundCount == 2) &&
                    fundTransferNotifier.isReceiverSelected == true &&
                    fundTransferNotifier.isReviewSelected == true &&
                    stepNumber == '2')
            ? darkBlue99
            : gray85Color);
  }

  // Common width
  Widget buildSizedBox(BuildContext context, FundTransferNotifier fundTransferNotifier) {
    return kIsWeb ? SizedBoxWidth(
        context,
        isTab(context)
            ? 0.005
            : isMobile(context)
                ? 0.002
                : 0.02):fundTransferNotifier.screenSize<500?SizedBox():sizedBoxWidth5(context);
  }

  checkData(
      stepNumber, FundTransferNotifier fundTransferNotifier, context) async {
    if (stepNumber == "1" &&
        fundTransferNotifier.isAccountSelected == true &&
        fundTransferNotifier.isReceiverSelected == true &&
        fundTransferNotifier.isReviewSelected == true) {
      await SharedPreferencesMobileWeb.instance
          .getCountry(AppConstants.country)
          .then((value) async {
        Navigator.pushNamed(context, fundTransferSelectAccountRoute);
      });
    } else if (stepNumber == "2" &&
        fundTransferNotifier.isAccountSelected == true &&
        fundTransferNotifier.isReceiverSelected == true &&
        fundTransferNotifier.isReviewSelected == true) {
      await SharedPreferencesMobileWeb.instance
          .getCountry(AppConstants.country)
          .then((value) async {
        Navigator.pushNamed(context, fundTransferSelectReceiverRoute);
      });
    } else if (stepNumber == "4" &&
        fundTransferNotifier.isAccountSelected == true &&
        fundTransferNotifier.isReceiverSelected == true &&
        fundTransferNotifier.isReviewSelected == true) {
      await SharedPreferencesMobileWeb.instance
          .getCountry(AppConstants.country)
          .then((value) async {
        Navigator.pushNamed(context, fundTransferTransferRoute);
      });
    } else if (stepNumber == "1" &&
        fundTransferNotifier.isAccountSelected == true &&
        fundTransferNotifier.isReceiverSelected == true) {
      await SharedPreferencesMobileWeb.instance
          .getCountry(AppConstants.country)
          .then((value) async {
        Navigator.pushNamed(context, fundTransferSelectAccountRoute);
      });
    } else if (stepNumber == "2" &&
        fundTransferNotifier.isAccountSelected == true &&
        fundTransferNotifier.isReceiverSelected == true) {
      await SharedPreferencesMobileWeb.instance
          .getCountry(AppConstants.country)
          .then((value) async {
        Navigator.pushNamed(context, fundTransferSelectReceiverRoute);
      });
      //2nd page
    } else if (stepNumber == "3" &&
        fundTransferNotifier.isAccountSelected == true &&
        fundTransferNotifier.isReceiverSelected == true) {
      await SharedPreferencesMobileWeb.instance
          .getCountry(AppConstants.country)
          .then((value) async {
        Navigator.pushNamed(context, fundTransferReviewRoute);
      });
    } else if (stepNumber == "1" &&
        fundTransferNotifier.isAccountSelected == true) {
      await SharedPreferencesMobileWeb.instance
          .getCountry(AppConstants.country)
          .then((value) async {
        Navigator.pushNamed(context, fundTransferSelectAccountRoute);
      });
      //1st page
    } else if (stepNumber == "2" &&
        fundTransferNotifier.isAccountSelected == true) {
      await SharedPreferencesMobileWeb.instance
          .getCountry(AppConstants.country)
          .then((value) async {
        Navigator.pushNamed(context, fundTransferSelectReceiverRoute);
      });
    } else {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(AppConstants.pleaseFinishLastStep),duration: Duration(seconds: 3),));
    }
  }

}
