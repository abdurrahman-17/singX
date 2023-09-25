import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/service/fx_repository.dart';
import 'package:singx/core/models/request_response/dashboard_china_transfer_limit/dashboard_china_transfer_limit_request.dart';
import 'package:singx/core/models/request_response/dashboard_china_transfer_limit/dashboard_china_transfer_limit_response.dart';
import 'package:singx/core/models/request_response/get_invoice_transaction/get_invoice_aus_transaction.dart';
import 'package:singx/core/notifier/common_notifier.dart';
import 'package:singx/core/notifier/dashboard_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/utils/common/app_button.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_images.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/common/page_scaffold/page_scaffold.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class Dashboard extends StatelessWidget {
  Dashboard({Key? key}) : super(key: key);


  final snackBar = SnackBar(
    content: Text(AppConstants.referralCodeCopied),
    duration: Duration(seconds: 3),
  );

  @override
  Widget build(BuildContext context) {
    //To check the Screen activity
    startTimer(context);
    userCheck(context);
    return ChangeNotifierProvider(
      create: (BuildContext context) => DashboardNotifier(context),
      child: Consumer<DashboardNotifier>(
        builder: (context, dashboardNotifier, _) {
          return ScaffoldMessenger(
            key: dashboardNotifier.scaffoldKey,
            child: PageScaffold(
              scrollController: dashboardNotifier.scrollController,
              color: bankDetailsBackground,
              appbar: PreferredSize(
                preferredSize: Size.fromHeight(AppConstants.appBarHeight),
                child: Padding(
                  padding: isMobile(context) || isTab(context)
                      ? px15DimenTop(context)
                      : px30DimenTopOnly(context),
                  child: buildAppBar(
                    context,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IgnorePointer(
                          ignoring: (getScreenWidth(context) > 500),
                          child: Tooltip(triggerMode: TooltipTriggerMode.tap,
                            message: dashboardNotifier.name,
                            child:new Text(
                              dashboardNotifier.name != null
                                  ? getScreenWidth(context) < 460 && dashboardNotifier.name!.length > 6 ? '${AppConstants.dashboardWelcome}' : '${AppConstants.dashboardWelcome}, ${dashboardNotifier.name ?? ''}'
                                  : '',
                              style: appBarWelcomeText(context),overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                        Text(
                          dashboardDateFormatter(),
                          style: appBarDateAndTimeText(context),
                        ),
                        sizedBoxHeight10(context)
                      ],
                    ),
                  ),
                ),
              ),
              body: DoubleBackToCloseApp(
                snackBar: SnackBar(content: Text(AppConstants.doubleTapToLogOut),duration: Duration(seconds: 3),),
                child: AppInActiveCheck(
                  context: context,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      controller: dashboardNotifier.scrollController,
                      child: buildBody(context, dashboardNotifier),
                    ),
                  ),
                ),
              ),
              title: AppConstants.dashboard,
            ),
          );
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, DashboardNotifier dashboardNotifier) {
    return Padding(
      padding: EdgeInsets.only(
          left: AppConstants.twenty,
          right: AppConstants.twenty,
          top: AppConstants.eight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: dashboardNotifier.topVerifyValidation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAlertGetVerified(context, dashboardNotifier),
                sizedBoxHeight15(context)
              ],
            ),
          ),
          buildMainBody(context, dashboardNotifier),
          sizedBoxHeight20(context),
          buildRecentActivities(context, dashboardNotifier),
        ],
      ),
    );
  }

  Widget buildMainBody(BuildContext context, DashboardNotifier dashboardNotifier) {
    return getScreenWidth(context) >= 1060
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: buildSendMoney(context, dashboardNotifier),
              ),
              sizedBoxWidth20(context),
              Expanded(
                flex: 1,
                child: buildWalletBalance(context, dashboardNotifier),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSendMoney(context, dashboardNotifier),
              sizedBoxwidth20(context),
              buildWalletBalance(context, dashboardNotifier),
            ],
          );
  }

  Widget buildSendMoney(BuildContext context, DashboardNotifier dashboardNotifier) {
    return sendMoneyCommon(
      context,
      sendController: dashboardNotifier.sendController,
      onChangedSend: (value) async {

        //Sender Text Field Onchange Function

        handleInteraction(context);

        //TextField Value Validation
        final regex = RegExp(r'^0(?!\.|$)');
        if (regex.hasMatch(value)) {
          dashboardNotifier.sendController.text = value.substring(1); // Remove the leading zero
          dashboardNotifier.sendController.selection =
                TextSelection.fromPosition(TextPosition(
                    offset: dashboardNotifier.sendController.text.length));
        } else if (value.isEmpty) {

          dashboardNotifier.sendController.text = '0'; // Set the value to "0" when cleared
          dashboardNotifier.recipientController.text = "0";
          dashboardNotifier.singXData = 0;
          dashboardNotifier.totalPayable = 0;
          dashboardNotifier.sendController.selection =
              TextSelection.fromPosition(TextPosition(
                  offset: dashboardNotifier.sendController.text.length));

        }else {
          dashboardNotifier.sendController.text = value;
          dashboardNotifier.sendController.selection =
              TextSelection.fromPosition(TextPosition(
                  offset: dashboardNotifier.sendController.text.length));
        }

        //exchange API while changing text
        dashboardNotifier.exchangeApi(
            context,
            dashboardNotifier.selectedSender,
            dashboardNotifier.selectedReceiver,
            dashboardNotifier.selectedCountryData == AppConstants.australia
                ? "First"
                : "Send",
            double.parse(value), false,);

        //Storing data of fund transfer flow
        Map<String, dynamic> dashboardData = {
          "receiveAmount": dashboardNotifier.recipientController.text,
          "sendAmount": dashboardNotifier.sendController.text,
          "sendCurrency": dashboardNotifier.selectedSender,
          "receiveCurrency": dashboardNotifier.selectedReceiver,
          "isSwift": dashboardNotifier.isSwift,
          "isCash": dashboardNotifier.isCash,
          "selectedRadioTile": dashboardNotifier.selectedRadioTile,
          "selectedTransferMode": dashboardNotifier.selectedTransferMode,
        };
        await SharedPreferencesMobileWeb.instance.setDashboardCalculatorData(
            dashboardCalc, jsonEncode(dashboardData));

        dashboardNotifier.checkTransferLimit = "";
      },
      recipientController: dashboardNotifier.recipientController,
      onChangedReceive: (value) async {

        //Receiver Text Field onchange function

        handleInteraction(context);

        //TextField Value Validation
        final regex = RegExp(r'^0(?!\.|$)');
        if (regex.hasMatch(value)) {
          dashboardNotifier.recipientController.text = value.substring(1); // Remove the leading zero
          dashboardNotifier.recipientController.selection =
              TextSelection.fromPosition(TextPosition(
                  offset: dashboardNotifier.recipientController.text.length));
        } else if (value.isEmpty) {

          dashboardNotifier.recipientController.text = '0'; // Set the value to "0" when cleared
          dashboardNotifier.sendController.text = "0";
          dashboardNotifier.singXData = 0;
          dashboardNotifier.totalPayable = 0;
          dashboardNotifier.recipientController.selection =
              TextSelection.fromPosition(TextPosition(
                  offset: dashboardNotifier.recipientController.text.length));

        }else {
          dashboardNotifier.recipientController.text = value;
          dashboardNotifier.recipientController.selection =
              TextSelection.fromPosition(TextPosition(
                  offset: dashboardNotifier.recipientController.text.length));
        }

        //Exchange API while changing value
        dashboardNotifier.exchangeApi(
            context,
            dashboardNotifier.selectedSender,
            dashboardNotifier.selectedReceiver,
            dashboardNotifier.selectedCountryData == AppConstants.australia
                ? "Second"
                : "Receive",
            double.parse(value), false,);

        //Storing Data for fund transfer flow
        Map<String, dynamic> dashboardData = {
          "receiveAmount": dashboardNotifier.recipientController.text,
          "sendAmount": dashboardNotifier.sendController.text,
          "sendCurrency": dashboardNotifier.selectedSender,
          "receiveCurrency": dashboardNotifier.selectedReceiver,
          "isSwift": dashboardNotifier.isSwift,
          "isCash": dashboardNotifier.isCash,
          "selectedRadioTile": dashboardNotifier.selectedRadioTile,
          "selectedTransferMode": dashboardNotifier.selectedTransferMode,
        };
        await SharedPreferencesMobileWeb.instance.setDashboardCalculatorData(
            dashboardCalc, jsonEncode(dashboardData));
        dashboardNotifier.checkTransferLimit = "";
      },
      singxFee: dashboardNotifier.singXData.toString(),
      totalAmountPay: dashboardNotifier.totalPayable.toString(),
      title: S.of(context).sendMoney,
      errorMessage: dashboardNotifier.errorExchangeValue,
      sendCountry: dashboardNotifier.selectedSender,
      receiverCountry: dashboardNotifier.selectedReceiver,
      sendCountryList:
          dashboardNotifier.selectedCountryData == AppConstants.australia
              ? dashboardNotifier.senderData
              : dashboardNotifier.senderData,
      receiverCountryList:
          dashboardNotifier.selectedCountryData == AppConstants.australia
              ? dashboardNotifier.ReceiverData
              : dashboardNotifier.ReceiverData,
      sendOnchanged: dashboardNotifier.selectedCountryData ==
                  AppConstants.australia ||
              dashboardNotifier.selectedCountryData == AppConstants.hongKong
          ? null
          : (String? newValue) async {

              //Sender dropdown onChange value

              dashboardNotifier.selectedSender = newValue!;
              dashboardNotifier.isSwift = false;
              dashboardNotifier.isCash = false;
              dashboardNotifier.selectedRadioTile = 1;

              dashboardNotifier.ReceiverData.clear();

              //Controlling the corridor data
              dashboardNotifier.selectedCountryData == AppConstants.australia
                  ? null
                  : FxRepository().corridorResponseData.forEach((key, value) {
                      if (dashboardNotifier.selectedSender == key) {
                        value.forEach((element) {
                          dashboardNotifier.selectedReceiver = value[0].key!;
                        });
                      }
                      if (newValue == key) {
                        value.forEach((element) {
                          dashboardNotifier.ReceiverData.add(element.key!);
                        });
                      }
                    });
              dashboardNotifier.exchangeSelectedSender =
                  dashboardNotifier.selectedSender;
              dashboardNotifier.exchangeSelectedReceiver =
                  dashboardNotifier.selectedReceiver;

              //Checking transfer option
              if (dashboardNotifier.selectedReceiver == "PHP") {
                dashboardNotifier.isSwift = false;
              } else {
                dashboardNotifier.isCash = false;
              }

              //Exchange API while changing corridor
              dashboardNotifier.exchangeApi(
                context,
                dashboardNotifier.selectedSender,
                dashboardNotifier.selectedReceiver,
                dashboardNotifier.selectedCountryData == AppConstants.australia
                    ? "First"
                    : "Send",
                double.parse(dashboardNotifier.sendController.text),
                  true,
              );

              // Storing Data for fund transfer flow
              Map<String, dynamic> dashboardData = {
                "receiveAmount": dashboardNotifier.recipientController.text,
                "sendAmount": dashboardNotifier.sendController.text,
                "sendCurrency": dashboardNotifier.selectedSender,
                "receiveCurrency": dashboardNotifier.selectedReceiver,
                "isSwift": dashboardNotifier.isSwift,
                "isCash": dashboardNotifier.isCash,
                "selectedRadioTile": dashboardNotifier.selectedRadioTile,
                "selectedTransferMode": dashboardNotifier.selectedTransferMode,
              };
              await SharedPreferencesMobileWeb.instance
                  .setDashboardCalculatorData(
                      dashboardCalc, jsonEncode(dashboardData));
              dashboardNotifier.checkTransferLimit = "";
            },
      receiverOnchanged: (String? newValue) async {

        //Receiver dropdown onChange Function

        dashboardNotifier.selectedReceiver = newValue!;
        dashboardNotifier.isSwift = false;
        dashboardNotifier.isCash = false;
        dashboardNotifier.selectedRadioTile = 1;
        dashboardNotifier.exchangeSelectedSender =
            dashboardNotifier.selectedSender;
        dashboardNotifier.exchangeSelectedReceiver =
            dashboardNotifier.selectedReceiver;

        //Checking transfer option function
        if (dashboardNotifier.selectedReceiver == "PHP") {
          dashboardNotifier.isSwift = false;
        } else {
          dashboardNotifier.isCash = false;
        }

        //exchange api while changing receiver corridor data
        dashboardNotifier.exchangeApi(
            context,
            dashboardNotifier.exchangeSelectedSender,
            dashboardNotifier.exchangeSelectedReceiver,
            dashboardNotifier.selectedCountryData == AppConstants.australia
                ? "First"
                : "Send",
            double.parse(dashboardNotifier.sendController.text),true,);

        //Storing data for fund transfer value
        Map<String, dynamic> dashboardData = {
          "receiveAmount": dashboardNotifier.recipientController.text,
          "sendAmount": dashboardNotifier.sendController.text,
          "sendCurrency": dashboardNotifier.selectedSender,
          "receiveCurrency": dashboardNotifier.selectedReceiver,
          "isSwift": dashboardNotifier.isSwift,
          "isCash": dashboardNotifier.isCash,
          "selectedRadioTile": dashboardNotifier.selectedRadioTile,
          "selectedTransferMode": dashboardNotifier.selectedTransferMode,
        };
        await SharedPreferencesMobileWeb.instance.setDashboardCalculatorData(
            dashboardCalc, jsonEncode(dashboardData));
        dashboardNotifier.checkTransferLimit = "";
      },
      buttonFunction: () async {

        if(dashboardNotifier.selectedSender == "USD"){
          transactionModeDialog(context, dashboardNotifier);
        }else{
          sendMoneyButtonFunctionality(context, dashboardNotifier);
        }

      },
      exchangeRateInitialValue: dashboardNotifier.exchagneRateInital,
      exchangeRateConvertedValue: dashboardNotifier.exchagneRateConverted,
      buttonFunctionForExchange: () {

        //This function is for transfer exchange rate

        String temp;
        temp = dashboardNotifier.exchangeSelectedSender;
        dashboardNotifier.exchangeSelectedSender =
            dashboardNotifier.exchangeSelectedReceiver;
        dashboardNotifier.exchangeSelectedReceiver = temp;
        dashboardNotifier.exchagneRateConverted =
            (1 / double.parse(dashboardNotifier.exchagneRateConverted))
                .toString();
      },
      selectedCountry: dashboardNotifier.selectedCountryData,
      dashboardNotifier: dashboardNotifier,
    );
  }

  Widget buildWalletBalance(BuildContext context, DashboardNotifier dashboardNotifier) {
    return Column(
      children: [
        Visibility(
            child: sizedBoxHeight25(context),
            visible: getScreenWidth(context) < 1060),
        Visibility(
            child: walletBalanceCard(context, dashboardNotifier),
            visible: dashboardNotifier.selectedCountryData == SingaporeName),
        dashboardNotifier.selectedCountryData == HongKongName ||
                dashboardNotifier.selectedCountryData == AustraliaName
            ? SizedBox()
            : getScreenWidth(context) >= 1060 && getScreenWidth(context) <= 1260
                ? sizedBoxHeight14(context)
                : getScreenWidth(context) == 1260
                    ? sizedBoxHeight20(context)
                    : getScreenWidth(context) > 1260 &&
                            getScreenWidth(context) <= 1390
                        ? sizedBoxHeight17(context)
                        : getScreenWidth(context) > 1390 &&
                                getScreenWidth(context) <= 1415
                            ? sizedBoxHeight17(context)
                            : getScreenWidth(context) >= 1416 &&
                                    getScreenWidth(context) < 1540
                                ? sizedBoxHeight18(context)
                                : sizedBoxHeight18(context),
        singXWalletCard(context, dashboardNotifier),
        dashboardNotifier.selectedCountryData == HongKongName ||
                dashboardNotifier.selectedCountryData == AustraliaName
            ? SizedBox()
            : getScreenWidth(context) >= 1060 && getScreenWidth(context) < 1260
                ? sizedBoxHeight14(context)
                : getScreenWidth(context) == 1260
                    ? sizedBoxHeight20(context)
                    : getScreenWidth(context) > 1260 &&
                            getScreenWidth(context) <= 1390
                        ? sizedBoxHeight17(context)
                        : getScreenWidth(context) > 1390 &&
                                getScreenWidth(context) <= 1415
                            ? sizedBoxHeight17(context)
                            : getScreenWidth(context) >= 1416 &&
                                    getScreenWidth(context) < 1540
                                ? sizedBoxHeight18(context)
                                : sizedBoxHeight18(context),
        Visibility(
            child: mobileTopUpAndBillPayment(context),
            visible: dashboardNotifier.selectedCountryData == SingaporeName),
      ],
    );
  }

  Widget walletBalanceCard(BuildContext context, DashboardNotifier dashboardNotifier) {
    return Container(
      width: double.infinity,
      decoration: dashboardContainerImageStyle(context),
      child: Padding(
        padding: px25DimenAll(context),
        child: getScreenWidth(context) >= 450
            ? Row(
                children: [
                  Column(
                    crossAxisAlignment: getScreenWidth(context) >= 450
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).walletBalance,
                        style: fairexchangeStyle(context),
                      ),
                      sizedBoxHeight8(context),
                      Text.rich(
                        TextSpan(
                          text: sgd,
                          style: sgdValueText(context),
                          children: <TextSpan>[
                            TextSpan(
                              text: dashboardNotifier.SGWalletBal == ""
                                  ? '0.0'
                                  : dashboardNotifier.SGWalletBal,
                              style: sgdValueTextBold(context),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () async {
                      await SharedPreferencesMobileWeb.instance
                          .getCountry(country)
                          .then((value) async {
                        Navigator.pushNamed(context, manageWalletRoute);
                      });
                    },
                    child: MouseRegion(
                      cursor: MaterialStateMouseCursor.clickable,
                      child: Container(
                        padding: px15Horiz10VertDimen(context),
                        decoration: circleDecoration(context),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_circle_rounded,
                              color: orangePantone,
                            ),
                            sizedBoxWidth8(context),
                            Text(
                              S.of(context).topUpInBetweenDash,
                              style: orangeText16(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: getScreenWidth(context) >= 450
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).walletBalance,
                        style: fairexchangeStyle(context),
                      ),
                      Text.rich(
                        TextSpan(
                          text: sgd,
                          style: sgdValueText(context),
                          children: <TextSpan>[
                            TextSpan(
                              text: dashboardNotifier.SGWalletBal,
                              style: sgdValueTextBold(context),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  sizedBoxHeight10(context),
                  IntrinsicWidth(
                    child: GestureDetector(
                      onTap: () async {
                        await SharedPreferencesMobileWeb.instance
                            .getCountry(country)
                            .then((value) async {
                          Navigator.pushNamed(context, manageWalletRoute);
                        });
                      },
                      child: MouseRegion(
                        cursor: MaterialStateMouseCursor.clickable,
                        child: Container(
                          padding: px15Horiz10VertDimen(context),
                          decoration: circleDecoration(context),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_circle_rounded,
                                color: orangePantone,
                              ),
                              sizedBoxWidth8(context),
                              Text(
                                S.of(context).topUpInBetweenDash,
                                style: orangeText16(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget singXWalletCard(BuildContext context, DashboardNotifier dashboardNotifier) {
    return Container(
      height: dashboardNotifier.selectedCountryData == SingaporeName ||
              getScreenWidth(context) <= 1060
          ? null
          : dashboardNotifier.selectedCountryData == AppConstants.australia &&
                  (dashboardNotifier.selectedReceiver == "BDT" ||
                      dashboardNotifier.selectedReceiver == "KRW" ||
                      dashboardNotifier.selectedReceiver == "MYR" ||
                      dashboardNotifier.selectedReceiver == "PHP" ||
                      dashboardNotifier.selectedReceiver == "USD")
              ? 495
              : 448,
      width: dashboardNotifier.selectedCountryData == SingaporeName ||
              getScreenWidth(context) <= 1060
          ? null
          : double.infinity,
      decoration: dashboardContainerStyle(context),
      child: getScreenWidth(context) >= 450 &&
              (dashboardNotifier.selectedCountryData == SingaporeName ||
                  getScreenWidth(context) <= 1060)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(
                        top: getScreenWidth(context) > 1260 &&
                                getScreenWidth(context) <= 1390
                            ? 10
                            : 25,
                        left: 25,
                        right: 25,
                        bottom: getScreenWidth(context) > 1260 &&
                                getScreenWidth(context) <= 1390
                            ? 0
                            : 10),
                    child: buildReferAFriend(context, dashboardNotifier)),
                singXCardRichText(context, dashboardNotifier),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: px15DimenTop(context),
                  child: Image.asset(
                    AppImages.singXDashboardPeople,
                    height: dashboardNotifier.selectedCountryData ==
                                SingaporeName ||
                            getScreenWidth(context) <= 1060
                        ? AppConstants.oneHundredAndSixty
                        : AppConstants.twoHundred,
                  ),
                ),
                sizedBoxHeight10(context),
                Padding(
                  padding: getScreenWidth(context) >= 1060 &&
                          getScreenWidth(context) <= 1390
                      ? px20DimenAll(context)
                      : px28And25DimenAll(context),
                  child: Column(
                    crossAxisAlignment: getScreenWidth(context) >= 450 &&
                            (dashboardNotifier.selectedCountryData ==
                                    SingaporeName ||
                                getScreenWidth(context) <= 1060)
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: [
                      buildReferAFriend(context, dashboardNotifier),
                      sizedBoxHeight15(context),
                      IntrinsicWidth(
                        child: Container(
                          padding: px5Horiz8VertDimen(context),
                          decoration: referralCodeContainerStyle(context),
                          child: getScreenWidth(context) >= 1415 ||
                                  (getScreenWidth(context) >= 320 &&
                                      getScreenWidth(context) <= 450) ||
                                  dashboardNotifier.referralCodeData == ""
                              ? Row(
                                  children: [
                                    Text(
                                      S.of(context).referralCodeWithColan,
                                      style: greyTextStyle14(context),
                                    ),
                                    sizedBoxWidth5(context),
                                    Flexible(
                                      child: Text(
                                        dashboardNotifier.referralCodeData,
                                        textAlign: TextAlign.center,
                                        style: labels14(context),
                                      ),
                                    ),
                                    sizedBoxWidth10(context),
                                    dashboardNotifier.referralCodeData == ""
                                        ? SizedBox()
                                        : GestureDetector(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(
                                                      text: dashboardNotifier
                                                          .referralCodeData))
                                                  .then(
                                                (value) {
                                                  dashboardNotifier
                                                      .referralCopied = true;
                                                },
                                              );
                                            },
                                            child: Tooltip(
                                              message: dashboardNotifier
                                                          .referralCopied ==
                                                      false
                                                  ? S.of(context).clickToCopy
                                                  : S.of(context).copiedText,
                                              child: MouseRegion(
                                                cursor: MaterialStateMouseCursor
                                                    .clickable,
                                                child: Image.asset(
                                                  AppImages.documentCopy,
                                                  height: AppConstants.fifteen,
                                                ),
                                              ),
                                            ),
                                          ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).referralCodeWithColan,
                                      style: greyTextStyle14(context),
                                    ),
                                    sizedBoxWidth5(context),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            dashboardNotifier.referralCodeData,
                                            style: labels14(context),
                                          ),
                                        ),
                                        sizedBoxWidth10(context),
                                        dashboardNotifier.referralCodeData == ""
                                            ? SizedBox()
                                            : GestureDetector(
                                                onTap: () {
                                                  Clipboard.setData(ClipboardData(
                                                          text: dashboardNotifier
                                                              .referralCodeData))
                                                      .then(
                                                    (value) {
                                                      dashboardNotifier
                                                              .referralCopied =
                                                          true;
                                                    },
                                                  );
                                                },
                                                child: Tooltip(
                                                  message: dashboardNotifier
                                                              .referralCopied ==
                                                          false
                                                      ? S
                                                          .of(context)
                                                          .clickToCopy
                                                      : S
                                                          .of(context)
                                                          .copiedText,
                                                  child: MouseRegion(
                                                    cursor:
                                                        MaterialStateMouseCursor
                                                            .clickable,
                                                    child: Image.asset(
                                                      AppImages.documentCopy,
                                                      height:
                                                          AppConstants.fifteen,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget singXCardRichText(BuildContext context, DashboardNotifier dashboardNotifier) {
    return Padding(
      padding:
          getScreenWidth(context) >= 1060 && getScreenWidth(context) <= 1390
              ? EdgeInsets.only(bottom: 10, left: 20, right: 20)
              : px28And25DimenAll(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntrinsicWidth(
                  child: Container(
                    padding: px5Horiz8VertDimen(context),
                    decoration: referralCodeContainerStyle(context),
                    child: getScreenWidth(context) >= 1415 ||
                            (getScreenWidth(context) >= 320 &&
                                getScreenWidth(context) <= 450) ||
                            dashboardNotifier.referralCodeData == ""
                        ? Row(
                            children: [
                              Text(S.of(context).referralCodeWithColan,
                                  style: greyTextStyle14(context)),
                              sizedBoxWidth5(context),
                              Flexible(
                                child: Text(
                                  dashboardNotifier.referralCodeData,
                                  style: labels14(context),
                                ),
                              ),
                              sizedBoxWidth10(context),
                              Visibility(
                                  child: buildCopyIcon(dashboardNotifier),
                                  visible:
                                      dashboardNotifier.referralCodeData != ""),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).referralCodeWithColan,
                                style: greyTextStyle14(context),
                              ),
                              sizedBoxWidth5(context),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      dashboardNotifier.referralCodeData,
                                      style: labels14(context),
                                    ),
                                  ),
                                  sizedBoxWidth10(context),
                                  Visibility(
                                      child: buildCopyIcon(dashboardNotifier),
                                      visible:
                                          dashboardNotifier.referralCodeData !=
                                              "")
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                AppImages.singXDashboardPeople,
                height: getScreenWidth(context) > 1060 &&
                        getScreenWidth(context) <= 1260
                    ? AppConstants.ninetyTwo
                    : getScreenWidth(context) > 1260 &&
                            getScreenWidth(context) <= 1390
                        ? AppConstants.oneHundredAndTen
                        : getScreenWidth(context) > 1390 &&
                                getScreenWidth(context) <= 1397
                            ? AppConstants.ninetyFive
                            : AppConstants.oneHundredAndTwenty,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget mobileTopUpAndBillPayment(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () async {
              await SharedPreferencesMobileWeb.instance
                  .getCountry(country)
                  .then((value) async {
                Navigator.pushNamed(context, indiaBillPaymentRoute);
              });
              Provider.of<CommonNotifier>(context, listen: false)
                  .updateLeadingData(false);
            },
            child: MouseRegion(
              cursor: MaterialStateMouseCursor.clickable,
              child: commonTopUpBillPayment(
                context,
                AppImages.receipt,
                S.of(context).billPayment,
                orangePantoneTint600,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget commonTopUpBillPayment(BuildContext context, String imageName, String textName, Color containerColor) {
    return Container(
      padding:
          getScreenWidth(context) >= 1060 && getScreenWidth(context) <= 1390
              ? px10DimenAll(context)
              : (getScreenWidth(context) >= 1060 &&
                          getScreenWidth(context) <= 1390) ||
                      getScreenWidth(context) <= 575
                  ? px20DimenAll(context)
                  : px20VertAnd30HorizDimen(context),
      decoration: dashboardContainerStyle(context),
      child: (getScreenWidth(context) >= 1060 &&
                  getScreenWidth(context) <= 1390) ||
              getScreenWidth(context) <= 835
          ? Column(
              children: [
                CircleAvatar(
                  radius: AppConstants.twentyFive,
                  backgroundColor: containerColor.withOpacity(0.10),
                  child: Image.asset(
                    imageName,
                    height: AppConstants.twenty,
                  ),
                ),
                sizedBoxHeight10(context),
                Text(
                  textName,
                  textAlign: TextAlign.center,
                  style: dashboardTopupText(context),
                )
              ],
            )
          : Row(
              children: [
                CircleAvatar(
                  radius: AppConstants.twentyFive,
                  backgroundColor: containerColor.withOpacity(0.10),
                  child: Image.asset(
                    imageName,
                    height: AppConstants.twenty,
                  ),
                ),
                sizedBoxWidth15(context),
                Text(
                  textName,
                  textAlign: TextAlign.center,
                  style: dashboardTopupText(context),
                ),
              ],
            ),
    );
  }

  Widget buildRecentActivities(BuildContext context, DashboardNotifier dashboardNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).recentActivities,
          style: dashboardRecentActivityText(context),
        ),
        sizedBoxHeight15(context),
        getScreenWidth(context) <= 1000
            ? activityListBelow800(context, dashboardNotifier)
            : activityListAbove800(context, dashboardNotifier),
        sizedBoxHeight15(context),
        buildSeeAllActivities(context),
        sizedBoxHeight15(context),
      ],
    );
  }

  Widget buildSeeAllActivities(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await SharedPreferencesMobileWeb.instance
            .getCountry(country)
            .then((value) async {
          Navigator.pushNamed(context, activitiesRoute);
        });
      },
      child: MouseRegion(
        cursor: MaterialStateMouseCursor.clickable,
        child: Text(
          S.of(context).seeAllActivities,
          style: seeAllActivityText(context),
        ),
      ),
    );
  }

  Widget activityListAbove800(BuildContext context, DashboardNotifier dashboardNotifier) {
    return Selector<DashboardNotifier, String>(
        builder: (context, selectedCountryData, child) {
          return ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return sizedBoxHeight15(context);
            },
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount:
                dashboardNotifier.selectedCountryData == AppConstants.australia
                    ? dashboardNotifier.transactionListData.length
                    : dashboardNotifier.transactionSingListData.length,
            itemBuilder: (context, index) {
              String dateSlug;
              if (dashboardNotifier.selectedCountryData ==
                  AppConstants.australia) {
                String formattedDate = DateFormat('MMMM').format(
                    dashboardNotifier
                        .transactionListData[index].transactiondt!);
                dateSlug =
                    "$formattedDate ${dashboardNotifier.transactionListData[index].transactiondt!.day.toString()}th, ${dashboardNotifier.transactionListData[index].transactiondt!.year.toString()}";
              } else {
                var timeStampDate = new DateTime.fromMillisecondsSinceEpoch(
                    int.parse(dashboardNotifier
                        .transactionSingListData[index].date!));
                final formatter = DateFormat('yyy-MM-dd HH:mm:ss');
                final dateTime = formatter.parse(timeStampDate.toString());
                String formattedMonth = DateFormat('MMMM').format(dateTime);
                String formattedDate = DateFormat('dd').format(dateTime);
                String formattedYear = DateFormat('yyy').format(dateTime);
                dateSlug =
                    "$formattedMonth ${formattedDate}th, ${formattedYear}";
              }
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: activitiesContainerStyle(context),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: iconAndText(
                        context,
                        dashboardNotifier.selectedCountryData ==
                                AppConstants.australia
                            ? dashboardNotifier
                                .transactionListData[index].recname!
                            : dashboardNotifier
                                .transactionSingListData[index].receiverName!,
                        dashboardNotifier.selectedCountryData ==
                                AppConstants.australia
                            ? dashboardNotifier
                                .transactionListData[index].usrtxnid!
                            : dashboardNotifier
                                .transactionSingListData[index].txnId!,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        dateSlug,
                        style: dashboardListText(context),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dashboardNotifier.selectedCountryData ==
                                    AppConstants.australia
                                ? dashboardNotifier
                                    .transactionListData[index].totalPayable!
                                : dashboardNotifier
                                    .transactionSingListData[index]
                                    .totalPayable!,
                            style: dashboardActivityNameText(context),
                          ),
                          Text(
                            dashboardNotifier.selectedCountryData ==
                                    AppConstants.australia
                                ? dashboardNotifier
                                    .transactionListData[index].exchngrate!
                                : dashboardNotifier
                                    .transactionSingListData[index]
                                    .exchangeRate!,
                            style: dashboardListText(context),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            statusListActivity(
                              context,
                              dashboardNotifier.selectedCountryData ==
                                      AppConstants.australia
                                  ? dashboardNotifier
                                      .transactionListData[index].txnstatus!
                                  : dashboardNotifier
                                      .transactionSingListData[index].status!,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Tooltip(
                          message: download,
                          child: GestureDetector(
                            onTap: () {
                              dashboardNotifier.selectedCountryData ==
                                      AustraliaName
                                  ? FxRepository().apiGetInvoiceAus(
                                      GetInvoiceRequest(
                                          contactId:
                                              dashboardNotifier.contactId,
                                          userTxnId: dashboardNotifier
                                              .transactionListData[index]
                                              .usrtxnid!),
                                      context)
                                  : FxRepository().apiGetInvoice(
                                      dashboardNotifier
                                          .transactionSingListData[index].id!,
                                      context: context);
                            },
                            child: dashboardNotifier.selectedCountryData ==
                                    AustraliaName
                                ? (dashboardNotifier.transactionListData[index]
                                            .txnstatus! ==
                                        "Fund Transferred"
                                    ? Image.asset(
                                        AppImages.import,
                                        height: AppConstants.twenty,
                                      )
                                    : SizedBox())
                                : (dashboardNotifier
                                            .transactionSingListData[index]
                                            .status ==
                                        "Payment Successful"
                                    ? Image.asset(
                                        AppImages.import,
                                        height: AppConstants.twenty,
                                      )
                                    : SizedBox()),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        selector: (buildContext, dashboardNotifier) =>
            dashboardNotifier.selectedCountryData);
  }

  Widget activityListBelow800(BuildContext context, DashboardNotifier dashboardNotifier) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return sizedBoxHeight15(context);
      },
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: dashboardNotifier.selectedCountryData == AppConstants.australia
          ? dashboardNotifier.transactionListData.length
          : dashboardNotifier.transactionSingListData.length,
      itemBuilder: (context, index) {
        String dateSlug;
        if (dashboardNotifier.selectedCountryData == AppConstants.australia) {
          String formattedDate = DateFormat('MMMM').format(
              dashboardNotifier.transactionListData[index].transactiondt!);
          dateSlug =
              "$formattedDate ${dashboardNotifier.transactionListData[index].transactiondt!.day.toString()}th, ${dashboardNotifier.transactionListData[index].transactiondt!.year.toString()}";
        } else {
          var timeStampDate = new DateTime.fromMillisecondsSinceEpoch(int.parse(
              dashboardNotifier.transactionSingListData[index].date!));
          final formatter = DateFormat('yyy-MM-dd HH:mm:ss');
          final dateTime = formatter.parse(timeStampDate.toString());
          String formattedMonth = DateFormat('MMMM').format(dateTime);
          String formattedDate = DateFormat('dd').format(dateTime);
          String formattedYear = DateFormat('yyy').format(dateTime);
          dateSlug = "$formattedMonth ${formattedDate}th, ${formattedYear}";
        }
        return Padding(
          padding: px15DimenBottom(context),
          child: Container(
            padding: px12Horizontaland14Vertical(context),
            decoration: dashboardContainerStyle(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getScreenWidth(context) > 340
                    ? Row(
                        children: [
                          Text(
                            receiverColan,
                            style: dashboardListTextBold(context),
                          ),
                          Expanded(
                              child: Text(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            dashboardNotifier.selectedCountryData ==
                                    AppConstants.australia
                                ? dashboardNotifier
                                    .transactionListData[index].recname!
                                : dashboardNotifier
                                    .transactionSingListData[index]
                                    .receiverName!,
                            style: dashboardActivityNameText(context),
                          )),
                          Tooltip(
                            message: download,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  dashboardNotifier.selectedCountryData ==
                                          AustraliaName
                                      ? FxRepository().apiGetInvoiceAus(
                                          GetInvoiceRequest(
                                              contactId:
                                                  dashboardNotifier.contactId,
                                              userTxnId: dashboardNotifier
                                                  .transactionListData[index]
                                                  .usrtxnid!),
                                          context)
                                      : FxRepository().apiGetInvoice(
                                          dashboardNotifier
                                              .transactionSingListData[index]
                                              .id!,
                                          context: context);
                                },
                                child: dashboardNotifier.selectedCountryData ==
                                        AustraliaName
                                    ? (dashboardNotifier
                                                .transactionListData[index]
                                                .txnstatus! ==
                                            "Fund Transferred"
                                        ? Image.asset(
                                            AppImages.import,
                                            height: AppConstants.twenty,
                                          )
                                        : SizedBox())
                                    : (dashboardNotifier
                                                .transactionSingListData[index]
                                                .status ==
                                            "Payment Successful"
                                        ? Image.asset(
                                            AppImages.import,
                                            height: AppConstants.twenty,
                                          )
                                        : SizedBox()),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                receiverColan,
                                style: dashboardListTextBold(context),
                              ),
                              sizedBoxHeight5(context),
                              Text(
                                dashboardNotifier.selectedCountryData ==
                                        AppConstants.australia
                                    ? dashboardNotifier
                                        .transactionListData[index].recname!
                                    : dashboardNotifier
                                        .transactionSingListData[index]
                                        .receiverName!,
                                style: dashboardActivityNameText(context),
                              ),
                            ],
                          ),
                          (dashboardNotifier.selectedCountryData ==
                              AustraliaName ? dashboardNotifier
                                      .transactionListData[index].txnstatus ==
                                  "Funds Transferred" : dashboardNotifier
                              .transactionSingListData[index].status ==
                              "Payment Successful")
                              ? Tooltip(
                                  message: download,
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        dashboardNotifier.selectedCountryData ==
                                                AustraliaName
                                            ? FxRepository().apiGetInvoiceAus(
                                                GetInvoiceRequest(
                                                    contactId: dashboardNotifier
                                                        .contactId,
                                                    userTxnId: dashboardNotifier
                                                        .transactionListData[
                                                            index]
                                                        .usrtxnid!),
                                                context)
                                            : FxRepository().apiGetInvoice(
                                                dashboardNotifier
                                                    .transactionSingListData[
                                                        index]
                                                    .id!,
                                                context: context);
                                      },
                                      child: Image.asset(
                                        AppImages.import,
                                        height: AppConstants.twenty,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox()
                        ],
                      ),
                sizedBoxHeight10(context),
                getScreenWidth(context) > 540
                    ? Row(
                        children: [
                          Text(
                            transactionIDColan,
                            style: dashboardListTextBold(context),
                          ),
                          Text(
                            dashboardNotifier.selectedCountryData ==
                                    AppConstants.australia
                                ? dashboardNotifier
                                    .transactionListData[index].usrtxnid!
                                : dashboardNotifier
                                    .transactionSingListData[index].txnId!,
                            style: dashboardListText(context),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transactionIDColan,
                            style: dashboardListTextBold(context),
                          ),
                          sizedBoxHeight5(context),
                          Text(
                            dashboardNotifier.selectedCountryData ==
                                    AppConstants.australia
                                ? dashboardNotifier
                                    .transactionListData[index].usrtxnid!
                                : dashboardNotifier
                                    .transactionSingListData[index].txnId!,
                            style: dashboardListText(context),
                          ),
                        ],
                      ),
                sizedBoxHeight10(context),
                getScreenWidth(context) > 340
                    ? Row(
                        children: [
                          Text(
                            dateColan,
                            style: dashboardListTextBold(context),
                          ),
                          Text(
                            dateSlug,
                            style: dashboardListText(context),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dateColan,
                            style: dashboardListTextBold(context),
                          ),
                          sizedBoxHeight5(context),
                          Text(
                            dateSlug,
                            style: dashboardListText(context),
                          ),
                        ],
                      ),
                sizedBoxHeight10(context),
                getScreenWidth(context) > 340
                    ? Row(
                        children: [
                          Text(
                            amountColan,
                            style: dashboardListTextBold(context),
                          ),
                          Text(
                            dashboardNotifier.selectedCountryData ==
                                    AppConstants.australia
                                ? dashboardNotifier
                                    .transactionListData[index].exchngrate!
                                : dashboardNotifier
                                    .transactionSingListData[index]
                                    .exchangeRate!,
                            style: dashboardListText(context),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            amountColan,
                            style: dashboardListTextBold(context),
                          ),
                          sizedBoxHeight5(context),
                          Text(
                            dashboardNotifier.selectedCountryData ==
                                    AppConstants.australia
                                ? dashboardNotifier
                                    .transactionListData[index].exchngrate!
                                : dashboardNotifier
                                    .transactionSingListData[index]
                                    .exchangeRate!,
                            style: dashboardListText(context),
                          ),
                        ],
                      ),
                sizedBoxHeight10(context),
                getScreenWidth(context) > 340
                    ? Row(
                        children: [
                          Text(
                            totalAmountPayable,
                            style: dashboardListTextBold(context),
                          ),
                          Flexible(
                            child: Text(
                              dashboardNotifier.selectedCountryData ==
                                      AppConstants.australia
                                  ? dashboardNotifier
                                      .transactionListData[index].totalPayable!
                                  : dashboardNotifier
                                      .transactionSingListData[index]
                                      .totalPayable!,
                              style: dashboardListText(context),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            totalAmountPayable,
                            style: dashboardListTextBold(context),
                          ),
                          sizedBoxHeight5(context),
                          Text(
                            dashboardNotifier.selectedCountryData ==
                                    AppConstants.australia
                                ? dashboardNotifier
                                    .transactionListData[index].totalPayable!
                                : dashboardNotifier
                                    .transactionSingListData[index]
                                    .totalPayable!,
                            style: dashboardListText(context),
                          ),
                        ],
                      ),
                sizedBoxHeight10(context),
                getScreenWidth(context) > 340
                    ? Row(
                        children: [
                          Text(
                            status,
                            style: dashboardListTextBold(context),
                          ),
                          statusListActivity(
                            context,
                            dashboardNotifier.selectedCountryData ==
                                    AppConstants.australia
                                ? dashboardNotifier
                                    .transactionListData[index].txnstatus!
                                : dashboardNotifier
                                    .transactionSingListData[index].status!,
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            status,
                            style: dashboardListTextBold(context),
                          ),
                          sizedBoxHeight5(context),
                          statusListActivity(
                            context,
                            dashboardNotifier.selectedCountryData ==
                                    AppConstants.australia
                                ? dashboardNotifier
                                    .transactionListData[index].txnstatus!
                                : dashboardNotifier
                                    .transactionSingListData[index].status!,
                          ),
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget statusListActivity(BuildContext context, String status) {
    return IntrinsicWidth(
      child: Container(
        padding: px8Horizontaland2Vertical(context),
        decoration: statusActivityDecorationColor(
          context,
          status == "Transfer Initiated"
              ? alert
              : status == "Validity Expired"
                  ? error
                  : status == "Processing"
                      ? information
                      : status == "Completed"
                          ? success
                          : information,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: AppConstants.eight,
              width: AppConstants.eight,
              decoration: BoxDecoration(
                color: status == "Transfer Initiated"
                    ? alert
                    : status == "Validity Expired"
                        ? error
                        : status == "Processing"
                            ? information
                            : status == "Completed"
                                ? success
                                : status == "Fund Transferred"
                                ? success
                                : status == "Payment Successful"
                                ? success
                                : information,
                shape: BoxShape.circle,
              ),
            ),
            sizedBoxWidth5(context),
            Text(
              status,
              style: statusActivityStyle(
                context,
                status == "Transfer Initiated"
                    ? alert
                    : status == "Validity Expired"
                        ? error
                        : status == "Processing"
                            ? information
                            : status == "Completed"
                                ? success
                                : status == "Fund Transferred"
                                ? success
                                : status == "Payment Successful"
                                ? success
                                : information,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget iconAndText(BuildContext context, String name, String id) {
    return Row(
      children: [
        CircleAvatar(
          radius: AppConstants.twentyFour,
          backgroundColor: iconArrowColor,
          child: Image.asset(
            AppImages.send,
            color: oxfordBlueTint500,
            height: AppConstants.twenty,
          ),
        ),
        sizedBoxWidth15(context),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                name,
                style: dashboardActivityNameText(context),
              ),
              Text(
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                id,
                style: dashboardListText(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildAlertGetVerified(BuildContext context, DashboardNotifier dashboardNotifier) {
    return ListView.separated(
      separatorBuilder: ((context, index) {
        return sizedBoxHeight10(context);
      }),
      shrinkWrap: true,
      itemCount: dashboardNotifier.notificationData.length,
      itemBuilder: (context, index) {
        return Container(
          padding: px12And15DimenAll(context),
          decoration: webAlertContainerStyle(context),
          child: Row(
            children: [
              sizedBoxHeight15(context),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dashboardNotifier.notificationData[index].title
                          .toString(),
                      style: walletGridTextStyle2(context),
                    ),
                    sizedBoxHeight10(context),
                    Text(
                      dashboardNotifier.notificationData[index].body.toString(),
                      style: alertbodyTextStyle14(context),
                    ),
                  ],
                ),
              ),
              sizedBoxWidth5(context),
              IconButton(
                onPressed: () {
                  dashboardNotifier.topVerifyValidation = false;
                },
                icon: Icon(
                  Icons.clear,
                  color: clearIconColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildReferAFriend(BuildContext context, DashboardNotifier dashboardNotifier) {
    return Text.rich(
      textAlign: getScreenWidth(context) >= 450 &&
              (dashboardNotifier.selectedCountryData == SingaporeName ||
                  getScreenWidth(context) <= 1060)
          ? TextAlign.left
          : TextAlign.center,
      TextSpan(
        text: dashboardNotifier.selectedCountryData == SingaporeName
            ? getColan
            : dashboardNotifier.selectedCountryData == HongKongName
                ? getColan
                : dashboardNotifier.selectedCountryData == AustraliaName
                    ? AppConstants.getAndRefer
                    : getColan,
        style: dashboardSingX500Text(context),
        children: <TextSpan>[
          TextSpan(
            text: dashboardNotifier.selectedCountryData == SingaporeName
                ? tenSingXWallet
                : dashboardNotifier.selectedCountryData == HongKongName
                    ? AppConstants.hkReferText
                    : dashboardNotifier.selectedCountryData == AustraliaName
                        ? AppConstants.ausReferText
                        : tenSingXWallet,
            style: dashboardSingX700Text(context),
          ),
          TextSpan(
            text: dashboardNotifier.selectedCountryData == SingaporeName
                ? creditForEveryFriend
                : dashboardNotifier.selectedCountryData == HongKongName
                    ? AppConstants.hkReferText2
                    : dashboardNotifier.selectedCountryData == AustraliaName
                        ? ""
                        : creditForEveryFriend,
            style: dashboardSingX500Text(context),
          ),
        ],
      ),
    );
  }

  Widget buildCopyIcon(DashboardNotifier dashboardNotifier) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(
                ClipboardData(text: dashboardNotifier.referralCodeData))
            .then(
          (value) {
            dashboardNotifier.scaffoldKey.currentState?.showSnackBar(snackBar,);
          },
        );
      },
      child: MouseRegion(
        cursor: MaterialStateMouseCursor.clickable,
        child: Image.asset(
          AppImages.documentCopy,
          height: AppConstants.fifteen,
        ),
      ),
    );
  }


  checkTransferLimitForCNYAndPHP(BuildContext context, DashboardNotifier dashboardNotifier)async{
    DashboardChinaPayTransferLimitResponse dashboardChinaPayTransferLimitResponse = DashboardChinaPayTransferLimitResponse();
    DashboardPhpTransferLimitResponse dashboardPhpTransferLimitResponse = DashboardPhpTransferLimitResponse();
    if(dashboardNotifier.selectedCountryData == AustraliaName){

      // Checking CNY transfer Limit
      if(dashboardNotifier.selectedReceiver == "CNY"){
        await FxRepository()
            .apiDashboardChinaPayTransferLimit(
            DashboardChinaPayTransferLimitRequest(
                contactId: dashboardNotifier.contactId),
            context)
            .then((value) {
          dashboardChinaPayTransferLimitResponse = value as DashboardChinaPayTransferLimitResponse;
        });
        if(double.parse(dashboardNotifier.sendController.text) > 3700 || ((double.parse(dashboardNotifier.sendController.text) + double.parse(dashboardChinaPayTransferLimitResponse.message!)) > 7600) ){
          dashboardNotifier.errorExchangeValue = "For transfers to China (CNY), there is a maximum transfer limit of AUD 3,700 per transaction and AUD 7,600 per day.";
          return ;
        }
      }

      // Checking PHP transfer Limit
      if(dashboardNotifier.selectedReceiver == "PHP"){
        await FxRepository()
            .apiDashboardPHPTransferLimit(
            DashboardPHPTransferLimitRequest(
                contactId: dashboardNotifier.contactId),
            context)
            .then((value) {
          dashboardPhpTransferLimitResponse = value as DashboardPhpTransferLimitResponse;
        });
        if(double.parse(dashboardNotifier.recipientController.text) > 50000 && dashboardNotifier.isSwift == false){
          dashboardNotifier.errorExchangeValue = "For transfers to Philippines (PHP), there is a maximum transfer limit of PHP 500,000 per transaction";
          return ;
        }else if(dashboardNotifier.isSwift == true && (double.parse(dashboardNotifier.recipientController.text) > 50000 || dashboardPhpTransferLimitResponse.phpCashPickUpLimit! > 5000)){
          dashboardNotifier.errorExchangeValue = "For transfers to Philippines (PHP), there is a maximum transfer limit of PHP 50,000 per transaction";
          return ;
        }else if(dashboardNotifier.isSwift == true && (double.parse(dashboardNotifier.sendController.text) > dashboardPhpTransferLimitResponse.segmentLimit!)){
          dashboardNotifier.errorExchangeValue = "For transfers to Philippines (PHP), there is a maximum transfer limit of PHP ${dashboardPhpTransferLimitResponse.segmentLimit!} on sender amount per transaction.";
          return ;
        }
      }
    }
  }

  transactionModeDialog(BuildContext context, DashboardNotifier dashboardNotifier){
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AppInActiveCheck(
        context: context,
        child: StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              actions: [
                primarywebButton(context, 'Proceed', (){
                  sendMoneyButtonFunctionality(context, dashboardNotifier);
                }),
                primarywebButton(context, 'Back', (){
                  Navigator.pop(context);
                })
              ],
              contentPadding: EdgeInsets.zero,
              content: IntrinsicHeight(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Choose your Mode of Transfer:", style: orangeText18(context),),
                          sizedBoxHeight10(context),
                          ListTileTheme(
                            horizontalTitleGap: 0,
                            child: RadioListTile(
                              contentPadding: EdgeInsets.zero,
                              value: 2,
                              groupValue: dashboardNotifier.selectedTransferMode,
                              activeColor: hanBlue,
                              title: Text("Cheque", style: TextStyle(
                                color: black,
                                fontWeight: FontWeight.w600,
                              ),),
                              onChanged: (int? val) {
                                setState((){
                                  dashboardNotifier.selectedTransferMode = val!;
                                });
                              },
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: transferModeOption(context, 12),
                          ),
                          sizedBoxHeight10(context),
                          ListTileTheme(
                            horizontalTitleGap: 0,
                            child: RadioListTile(
                              contentPadding: EdgeInsets.zero,
                              value: 1,
                              groupValue: dashboardNotifier.selectedTransferMode,
                              activeColor: hanBlue,
                              title: Text("Bank Transfer",style: TextStyle(
                                color: black,
                                fontWeight: FontWeight.w600,
                              ),),
                              onChanged: (int? val) {
                                setState((){
                                  dashboardNotifier.selectedTransferMode = val!;
                                });
                              },
                            ),
                          ),
                          Text("Note: If you have a DBS/POSB Account, you can make the USD transfer to us at no charge via online banking. All other banks may levy their own charges.",style: TextStyle(
                            color: black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),),
                          sizedBoxHeight10(context),
                          Container(
                            width: double.infinity,
                            child: transferModeOption(context, 5),
                          ),
                          sizedBoxHeight20(context),
                          Text.rich(
                            TextSpan(
                              text: "*Refers to transactions submitted on ",
                              style: TextStyle(
                              color: black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "www.singx.co",
                                  style: TextStyle(
                                  color: hanBlue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                ),
                                TextSpan(
                                  text: " and payment amount transferred to SingX bank account.",
                                  style: TextStyle(
                                  color: black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget transferModeOption(BuildContext context, int timing) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(5),
                    decoration: transferModeHeadingBorder(context),
                    child: Text("Day of Transaction",style: transferModeTableHeadingData(context),)),
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: transferModeHeadingBorder(context),
                    child: Text("Transaction Created*",style: transferModeTableHeadingData(context),)),
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: transferModeHeadingBorder(context),
                    child: Text("Cut-off time for SingX to receive the cheque",style: transferModeTableHeadingData(context),)),
              ),
            ],
          ),
        ),
        IntrinsicHeight(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: transferModeBorder(context),
                    child: Text("Weekdays (Monday - Friday)",style: transferModeTableData(context),)),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: transferModeBorder(context),
                                child: Text("Before ${timing}pm",style: transferModeTableData(context),)),
                          ),
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: transferModeBorder(context),
                                child: Text("${timing}pm same day",style: transferModeTableData(context),)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: transferModeBorder(context),
                                child: Text("After ${timing}pm",style: transferModeTableData(context),)),
                          ),
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: transferModeBorder(context),
                                child: Text("${timing}pm on the next working day",style: transferModeTableData(context),)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: transferModeBorder(context),
                    child: Text("Weekends and Public Holidays (Singapore)",style: transferModeTableData(context),)),
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: transferModeBorder(context),
                    child: Text("Anytime",style: transferModeTableData(context),)),
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: transferModeBorder(context),
                    child: Text("${timing}pm on the next working day",style: transferModeTableData(context),)),
              )
            ],
          ),
        )
      ],
    );
  }

  sendMoneyButtonFunctionality(BuildContext context, DashboardNotifier dashboardNotifier) async{
    //send transfer button functionality

    //Checking error while navigation
    if(dashboardNotifier.errorExchangeValue != "") return;

    //Checking transfer limit
    if (dataTransferLimitMessage(context, dashboardNotifier,
        dashboardNotifier.selectedReceiver) ==
        "") {

      //checking if value is zero, it will not navigate
      if(dashboardNotifier.recipientController.text == "0"){
        dashboardNotifier.errorExchangeValue = "Please Enter Valid Amount";
        return;
      }

      // Checking transfer Limit
      await checkTransferLimitForCNYAndPHP(context, dashboardNotifier);
      //checking Roundoff value
      if (dashboardNotifier.selectedCountryData == AustraliaName) {
        if ((dashboardNotifier.selectedReceiver == "JPY") &&
            ((double.parse(dashboardNotifier.recipientController.text) %
                1) !=
                0)) {
          return;
        } else if ((dashboardNotifier.selectedReceiver == "KRW") &&
            ((double.parse(dashboardNotifier.recipientController.text) %
                1) !=
                0)) {
          return;
        } else if ((dashboardNotifier.selectedReceiver == "VND") &&
            ((double.parse(dashboardNotifier.recipientController.text) %
                500) !=
                0)) {
          return;
        } else if ((dashboardNotifier.selectedReceiver == "PHP" && dashboardNotifier.isSwift == true) &&
            ((double.parse(dashboardNotifier.recipientController.text) %
                10) !=
                0) && (dashboardNotifier.recipientController.text.contains('.'))) {
          return;
        }
      } else {
        if ((dashboardNotifier.selectedReceiver == "JPY") &&
            ((double.parse(dashboardNotifier.recipientController.text) %
                1) !=
                0)) {
          return;
        } else if ((dashboardNotifier.selectedReceiver == "KRW") &&
            ((double.parse(dashboardNotifier.recipientController.text) %
                1) !=
                0)) {
          return;
        } else if ((dashboardNotifier.selectedReceiver == "VND") &&
            ((double.parse(dashboardNotifier.recipientController.text) %
                500) !=
                0)) {
          return;
        } else if ((dashboardNotifier.selectedReceiver == "PHP"  && dashboardNotifier.isCash == true) &&
            ((double.parse(dashboardNotifier.recipientController.text) %
                10) !=
                0)) {
          return;
        }
      }

      //Saving fund transfer data
      Provider.of<CommonNotifier>(context, listen: false)
          .updateClassNameNavigationData("Dashboard");
      SharedPreferencesMobileWeb.instance
          .setStepperRoute('Stepper', 'Dashboard');
      Map<String, dynamic> dashboardData = {
        "receiveAmount": dashboardNotifier.recipientController.text,
        "sendAmount": dashboardNotifier.sendController.text,
        "sendCurrency": dashboardNotifier.selectedSender,
        "receiveCurrency": dashboardNotifier.selectedReceiver,
        "isSwift": dashboardNotifier.isSwift,
        "isCash": dashboardNotifier.isCash,
        "selectedRadioTile": dashboardNotifier.selectedRadioTile,
        "selectedTransferMode": dashboardNotifier.selectedTransferMode,
      };
      await SharedPreferencesMobileWeb.instance.setDashboardCalculatorData(
          dashboardCalc, jsonEncode(dashboardData));

      //Checking error while navigation
      if(dashboardNotifier.errorExchangeValue != "") return;

      //Getting country Data
      await SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        Navigator.pushNamed(context, fundTransferSelectAccountRoute,
            arguments: true);
      });
    } else {

      //If gets some error in transfer limit
      if (dashboardNotifier.selectedCountryData == AustraliaName) {
        if (dataTransferLimitMessage(context, dashboardNotifier,
            dashboardNotifier.selectedReceiver) !=
            "") {
          dashboardNotifier.errorExchangeValue = "";
        }
      }

      //transfer limit function
      dataTransferLimitMessage(
          context, dashboardNotifier, dashboardNotifier.selectedReceiver);
    }
  }

}
