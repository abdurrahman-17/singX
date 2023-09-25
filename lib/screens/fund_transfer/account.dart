import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/service/fx_repository.dart';
import 'package:singx/core/models/request_response/dashboard_china_transfer_limit/dashboard_china_transfer_limit_request.dart';
import 'package:singx/core/models/request_response/dashboard_china_transfer_limit/dashboard_china_transfer_limit_response.dart';
import 'package:singx/core/notifier/common_notifier.dart';
import 'package:singx/core/notifier/fund_transfer_notifier.dart';
import 'package:singx/core/notifier/manage_sender_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/screens/manage_sender/manage_sender.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_custom_icon.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/justToolTip/src/just_the_tooltip.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Account extends StatelessWidget {
  Account({Key? key, required this.accountPageNotifier}) : super(key: key);
  final FundTransferNotifier accountPageNotifier;

  @override
  Widget build(BuildContext context) {
    userCheck(context);
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    ManageSenderNotifier notifier2 =
        ManageSenderNotifier(context, isFundTransferPage: true);
    return WillPopScope(
      onWillPop: () async {
        await SharedPreferencesMobileWeb.instance
            .removeParticularKey(AppConstants.accountScreenData);
        await SharedPreferencesMobileWeb.instance
            .removeParticularKey(AppConstants.receiverScreenData);
        await SharedPreferencesMobileWeb.instance
            .removeParticularKey(AppConstants.reviewScreenData);
        SharedPreferencesMobileWeb.instance
            .setAccountSelectedScreenData(AppConstants.accountPage, false);
        SharedPreferencesMobileWeb.instance
            .setReceiverSelectedScreenData(AppConstants.receiverPage, false);
        SharedPreferencesMobileWeb.instance
            .setReceiverSelectedScreenData(AppConstants.reviewPage, false);
        String data = '';
        SharedPreferencesMobileWeb.instance
            .getStepperRoute('Stepper')
            .then((value) async {
          data = value;

          if (data == "Dashboard") {
            await SharedPreferencesMobileWeb.instance
                .getCountry(AppConstants.country)
                .then((value) async {
              Navigator.pushNamedAndRemoveUntil(
                  context, dashBoardRoute, (route) => false);
            });
          } else if (data == "Manage receivers") {
            await SharedPreferencesMobileWeb.instance
                .getCountry(AppConstants.country)
                .then((value) async {
              Navigator.pushNamedAndRemoveUntil(
                  context, manageReceiverRoute, (route) => false);
            });
          } else {}
        });
        return Future.value(true);
      },
      child: Scrollbar(
        controller: accountPageNotifier.scrollController,
        child: SingleChildScrollView(
          controller: accountPageNotifier.scrollController,
          child: Form(
            key: accountPageNotifier.accountPageKey,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: kIsWeb ? getScreenWidth(context) >= 361 &&
                          getScreenWidth(context) <= 1150
                      ? getScreenWidth(context) * 0.05
                      : getScreenWidth(context) <= 360
                          ? getScreenWidth(context) * 0.03
                          : getScreenWidth(context) * 0.25 : screenSizeWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  commonSizedBoxHeight30(context),
                  buildAccountTransferBox(accountPageNotifier, context),
                  commonSizedBoxHeight20(context),
                  buildAccountText(accountPageNotifier, context),
                  Visibility(
                      visible: accountPageNotifier.countryData ==
                          AppConstants.singapore,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          commonSizedBoxHeight10(context),
                          buildSelectAccountText(context),
                          commonSizedBoxHeight30(context),
                          buildAccountType1(accountPageNotifier, context),
                        ],
                      )),
                  Visibility(
                      visible: kIsWeb
                          ? getScreenWidth(context) < 450 &&
                              accountPageNotifier.countryData ==
                                  AppConstants.singapore &&
                              accountPageNotifier.isTopUpVisible &&
                              accountPageNotifier.selectedSender == 'SGD'
                          : screenSizeWidth < 450 &&
                              accountPageNotifier.countryData ==
                                  AppConstants.singapore &&
                              accountPageNotifier.isTopUpVisible &&
                              accountPageNotifier.selectedSender == 'SGD',
                      child: Column(
                        children: [
                          commonSizedBoxHeight20(context),
                          Row(children: [
                            buildBalanceText(context),
                            buildTopUpText(context, accountPageNotifier)
                          ]),
                        ],
                      )),
                  Visibility(
                      visible: accountPageNotifier.countryData ==
                          AppConstants.singapore,
                      child: commonSizedBoxHeight20(context),),
                  Visibility(
                      visible: accountPageNotifier.countryData ==
                          AppConstants.singapore,
                      child: buildAccountType2(accountPageNotifier, context)),
                  Visibility(
                      visible: accountPageNotifier.isAccountTypeSelected,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          commonSizedBoxHeight30(context),
                          buildSelectYourBankText(context),
                          commonSizedBoxHeight20(context),
                          buildBankAccountDropDownField(),
                          commonSizedBoxHeight20(context),
                          buildAddNewAccount(
                              accountPageNotifier, notifier2, context),
                        ],
                      )),
                  commonSizedBoxHeight50(context),
                  buildButtons(accountPageNotifier, context),
                  commonSizedBoxHeight80(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Checking wallet balance function
  checkWalletBalance(context, FundTransferNotifier notifier) {
    if (notifier.walletBalance != '0.0' && double.parse(notifier.sendController.text) < double.parse(notifier.walletBalance) && notifier.selectedSender == 'SGD') {
      notifier.isAccountTypeSelected = false;
      notifier.isTopUpVisible = false;
    } else {
      notifier.isAccountTypeSelected = true;
      notifier.isTopUpVisible = true;
    }
  }

  // Sender and Receiver TextField
  Widget buildAccountTransferBox(FundTransferNotifier notifier, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withOpacity(0.05)),
          borderRadius: BorderRadius.circular(AppConstants.eight)),
      width: kIsWeb ? getScreenWidth(context) : screenSizeWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          kIsWeb
              ? getScreenWidth(context) > 1150
                  ? buildFieldGreaterThan1150(context, notifier)
                  : buildFieldLessThan1150(context, notifier)
              : screenSizeWidth > 1150
                  ? buildFieldGreaterThan1150(context, notifier)
                  : buildFieldLessThan1150(context, notifier),
          (notifier.selectedReceiver == "BDT" ||
                  notifier.selectedReceiver == "KRW" ||
                  (notifier.selectedReceiver == "MYR" && notifier.countryData == AppConstants.AustraliaName) ||
                  notifier.selectedReceiver == "PHP" ||
                  notifier.selectedReceiver == "USD")
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.twenty),
                  child: kIsWeb
                      ? getScreenWidth(context) > 550
                          ? buildRadioButtonGreaterThan550(context, notifier)
                          : buildRadioButtonLessThan550(context, notifier)
                      : screenSizeWidth > 550
                          ? buildRadioButtonGreaterThan550(context, notifier)
                          : buildRadioButtonLessThan550(context, notifier),
                )
              : SizedBox(),
          Visibility(
            visible: notifier.errorExchangeValue == "" ||
                    notifier.errorExchangeValue == "null"
                ? false
                : true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: AppConstants.twenty),
                    child: Text(
                      notifier.errorExchangeValue,
                      style: errorMessageStyle(context),
                    ),
                  ),
                ),
                sizedBoxHeight10(context),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: kIsWeb ? getScreenWidth(context) * 0.01 : screenSizeWidth * 0.01),
            child: Container(
              decoration: BoxDecoration(
                  color: oxfordBlue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(AppConstants.five)),
              padding: px15DimenHorizontalandpx12vertical(context),
              child: Column(
                children: [
                  kIsWeb
                      ? getScreenWidth(context) > 375
                          ? buildExchangeRateGreaterThan375(context, notifier)
                          : buildExchangeRateLessThan375(context, notifier)
                      : screenSizeWidth > 375
                          ? buildExchangeRateGreaterThan375(context, notifier)
                          : buildExchangeRateLessThan375(context, notifier),
                  kIsWeb
                      ? getScreenWidth(context) > 340
                          ? buildFeeAndTotalGreaterThan340(context, notifier)
                          : buildFeeAndTotalLessThan340(context, notifier)
                      : screenSizeWidth > 340
                          ? buildFeeAndTotalGreaterThan340(context, notifier)
                          : buildFeeAndTotalLessThan340(context, notifier),
                ],
              ),
            ),
          ),
          sizedBoxHeight10(context),
          if(notifier.countryData == AppConstants.AustraliaName) Padding(
            padding: EdgeInsets.symmetric(
                horizontal: kIsWeb ? getScreenWidth(context) * 0.01 : screenSizeWidth * 0.01),
            child: notifier.checkTransferLimit == ""
                ? SizedBox()
                : Text(
                    notifier.checkTransferLimit,
                    style: errorMessageStyle(context),
                  ),
          ),
          if(notifier.countryData == AppConstants.AustraliaName) notifier.checkTransferLimit == ""
              ? SizedBox()
              : sizedBoxHeight5(context),
            if(notifier.selectedReceiver == 'JPY')
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: kIsWeb ? getScreenWidth(context) * 0.01 : screenSizeWidth * 0.01),
                child: countryDataMessage(context, notifier,
                    notifier.selectedReceiver) ==
                    ""
                    ? SizedBox()
                    : Text(
                  countryDataMessage(context, notifier,
                      notifier.selectedReceiver),
                  style: errorMessageStyle(context),
                ),
              ),
         if(notifier.selectedReceiver == 'JPY')sizedBoxHeight5(context),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: kIsWeb ? getScreenWidth(context) * 0.01 : screenSizeWidth * 0.01),
            child: notifier.selectedReceiver == 'KRW' ||
                    notifier.selectedReceiver == 'VND' ||
                    notifier.selectedReceiver == 'JPY' ||
                    notifier.selectedReceiver == 'PHP'
                ? countryRoundOff(context, notifier)
                : countryDataMessage(
                            context, notifier, notifier.selectedReceiver) ==
                        ""
                    ? SizedBox()
                    : Text(
                        countryDataMessage(
                            context, notifier, notifier.selectedReceiver,
                        ),
              style: errorMessageStyle(context),
                      ),
          ),
         sizedBoxHeight10(context),
        ],
      ),
    );
  }

  Widget buildFieldLessThan1150(BuildContext context, FundTransferNotifier notifier) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kIsWeb ? getScreenWidth(context) * 0.02 : screenSizeWidth * 0.02),
      child: Column(
        children: [
          buildSendMoneyField(context, notifier),
          buildReceiveMoneyField(context, notifier)
        ],
      ),
    );
  }

  Widget buildFieldGreaterThan1150(BuildContext context, FundTransferNotifier notifier) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: kIsWeb ? getScreenWidth(context) * 0.01 : screenSizeWidth * 0.01,
          vertical: kIsWeb ? getScreenHeight(context) * 0.015 : screenSizeHeight * 0.015),
      child: Row(
        children: [
          buildSendMoneyField(context, notifier),
          commonSizedBoxWidth20(context),
          buildReceiveMoneyField(context, notifier)
        ],
      ),
    );
  }

  Widget buildRadioButtonLessThan550(BuildContext context, FundTransferNotifier notifier) {
    return Column(
      children: [
        Text(
          "Transfer ${notifier.selectedReceiver} ${notifier.selectedReceiver == "BDT" || notifier.selectedReceiver == "PHP" ? "via:" : "to:"}",
          style: topUpTextDataTextStyle(context),
        ),
        kIsWeb
            ? getScreenWidth(context) > 375
                ? buildRadioTileGreaterThan375(context, notifier)
                : buildRadioTileLessThan375(context, notifier)
            : screenSizeWidth > 375
                ? buildRadioTileGreaterThan375(context, notifier)
                : buildRadioTileLessThan375(context, notifier)
      ],
    );
  }

  Widget buildRadioTileLessThan375(BuildContext context, FundTransferNotifier notifier) {
    return Column(
      children: [
        RadioListTile(
          value: 1,
          groupValue: notifier.selectedRadioTile,
          title: Text(
            notifier.selectedReceiver == "BDT"
                ? "Bank Transfer"
                : notifier.selectedReceiver ==
                "KRW" ||
                notifier.selectedReceiver ==
                    "MYR"
                ? "Individual"
                : notifier.selectedReceiver ==
                "PHP"
                ? "Bank Transfer"
                : notifier.selectedReceiver ==
                "USD"
                ? "USA"
                : "Radio1",
          ),
          onChanged: (int? val) {
            notifier.setSelectedRadioTile(val!);
            if(notifier.selectedReceiver == "PHP" && notifier.countryData != AppConstants.AustraliaName){
              notifier.isCash = false;
              notifier.isSwift = false;
              notifier.isWallet = false;
            }else{
              notifier.isSwift = false;
              notifier.isCash = false;
              notifier.isWallet = false;
            }                                          notifier.exchangeApi(
              context,
              notifier.selectedSender,
              notifier.selectedReceiver,
              notifier.countryData == AppConstants.australia
                  ? AppConstants.secondText
                  : AppConstants.receiveText,
              double.parse(notifier.recipientController.text),
              false,
            );
          },
          activeColor: orangePantone,
        ),
        RadioListTile(
          value: 2,
          groupValue: notifier.selectedRadioTile,
          title: Text(
            notifier.selectedReceiver == "BDT"
                ? "E-Wallet"
                : notifier.selectedReceiver ==
                "KRW" ||
                notifier.selectedReceiver ==
                    "MYR"
                ? "Business"
                : notifier.selectedReceiver ==
                "PHP"
                ? "Cash"
                : notifier.selectedReceiver ==
                "USD"
                ? "Country Outside USA"
                : "Radio2",
          ),
          onChanged: (int? val) {
            notifier.setSelectedRadioTile(val!);

            if(notifier.selectedReceiver == "BDT" && notifier.countryData != AppConstants.AustraliaName){
              notifier.isCash = false;
              notifier.isSwift = false;
              notifier.isWallet = true;
            }else if(notifier.selectedReceiver == "PHP" && notifier.countryData != AppConstants.AustraliaName){
              notifier.isCash = true;
              notifier.isSwift = false;
              notifier.isWallet = false;
            }else if(notifier.selectedReceiver == "USD" || (notifier.selectedReceiver == "PHP" && notifier.countryData == AppConstants.AustraliaName)){
              notifier.isSwift = true;
              notifier.isCash = false;
              notifier.isWallet = false;
            }else{
              notifier.isSwift = false;
              notifier.isCash = false;
              notifier.isWallet = false;
            }

            notifier.exchangeApi(
              context,
              notifier.selectedSender,
              notifier.selectedReceiver,
              notifier.countryData == AppConstants.australia
                  ? AppConstants.secondText
                  : AppConstants.receiveText,
              double.parse(notifier.recipientController.text),
              false,
            );
          },
          activeColor: orangePantone,
        ),
      ],
    );
  }

  Widget buildRadioTileGreaterThan375(BuildContext context, FundTransferNotifier notifier) {
    return Row(
      children: [
        Expanded(
          child: ListTileTheme(
            horizontalTitleGap: 0,
            child: RadioListTile(
              value: 1,
              groupValue:
              notifier.selectedRadioTile,
              title: Text(
                notifier.selectedReceiver == "BDT"
                    ? "Bank Transfer"
                    : notifier.selectedReceiver ==
                    "KRW" ||
                    notifier.selectedReceiver ==
                        "MYR"
                    ? "Individual"
                    : notifier.selectedReceiver ==
                    "PHP"
                    ? "Bank Transfer"
                    : notifier.selectedReceiver ==
                    "USD"
                    ? "USA"
                    : "Radio1",
              ),
              onChanged: (int? val) {
                notifier.setSelectedRadioTile(val!);
                if(notifier.selectedReceiver == "PHP" && notifier.countryData != AppConstants.AustraliaName){
                  notifier.isCash = false;
                  notifier.isSwift = false;
                  notifier.isWallet = false;
                }else{
                  notifier.isSwift = false;
                  notifier.isCash = false;
                  notifier.isWallet = false;
                }
                notifier.exchangeApi(
                  context,
                  notifier.selectedSender,
                  notifier.selectedReceiver,
                  notifier.countryData == AppConstants.australia
                      ? AppConstants.secondText
                      : AppConstants.receiveText,
                  double.parse(notifier.recipientController.text),
                  false,
                );
              },
              activeColor: orangePantone,
            ),
          ),
        ),
        Expanded(
          child: ListTileTheme(
            horizontalTitleGap: 0,
            child: RadioListTile(
              value: 2,
              groupValue:
              notifier.selectedRadioTile,
              title: Text(
                notifier.selectedReceiver == "BDT"
                    ? "E-Wallet"
                    : notifier.selectedReceiver ==
                    "KRW" ||
                    notifier.selectedReceiver ==
                        "MYR"
                    ? "Business"
                    : notifier.selectedReceiver ==
                    "PHP"
                    ? "Cash"
                    : notifier.selectedReceiver ==
                    "USD"
                    ? "Country Outside USA"
                    : "Radio2",
              ),
              onChanged: (int? val) {
                notifier.setSelectedRadioTile(val!);

                if(notifier.selectedReceiver == "BDT" && notifier.countryData != AppConstants.AustraliaName){
                  notifier.isCash = false;
                  notifier.isSwift = false;
                  notifier.isWallet = true;
                }else if(notifier.selectedReceiver == "PHP" && notifier.countryData != AppConstants.AustraliaName){
                  notifier.isCash = true;
                  notifier.isSwift = false;
                  notifier.isWallet = false;
                }else if(notifier.selectedReceiver == "USD" || (notifier.selectedReceiver == "PHP" && notifier.countryData == AppConstants.AustraliaName)){
                  notifier.isSwift = true;
                  notifier.isCash = false;
                  notifier.isWallet = false;
                }else{
                  notifier.isSwift = false;
                  notifier.isCash = false;
                  notifier.isWallet = false;
                }

                notifier.exchangeApi(
                  context,
                  notifier.selectedSender,
                  notifier.selectedReceiver,
                  notifier.countryData == AppConstants.australia
                      ? AppConstants.secondText
                      : AppConstants.receiveText,
                  double.parse(notifier.recipientController.text),
                  false,
                );
              },
              activeColor: orangePantone,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildRadioButtonGreaterThan550(BuildContext context, FundTransferNotifier notifier) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "Transfer ${notifier.selectedReceiver} ${notifier.selectedReceiver == "BDT" || notifier.selectedReceiver == "PHP" ? "via:" : "to:"}",
            style: topUpTextDataTextStyle(context),
          ),
        ),
        Expanded(
          child: RadioListTile(
            value: 1,
            groupValue: notifier.selectedRadioTile,
            title: Text(
              notifier.selectedReceiver == "BDT"
                  ? "Bank Transfer"
                  : notifier.selectedReceiver == "KRW" ||
                  notifier.selectedReceiver == "MYR"
                  ? "Individual"
                  : notifier.selectedReceiver == "PHP"
                  ? "Bank Transfer"
                  : notifier.selectedReceiver ==
                  "USD"
                  ? "USA"
                  : "Radio1",
            ),
            onChanged: (int? val) {
              notifier.setSelectedRadioTile(val!);
              if(notifier.selectedReceiver == "PHP" && notifier.countryData != AppConstants.AustraliaName){
                notifier.isCash = false;
                notifier.isSwift = false;
                notifier.isWallet = false;
              }else{
                notifier.isSwift = false;
                notifier.isCash = false;
                notifier.isWallet = false;
              }                                  notifier.exchangeApi(
                context,
                notifier.selectedSender,
                notifier.selectedReceiver,
                notifier.countryData == AppConstants.australia
                    ? AppConstants.secondText
                    : AppConstants.receiveText,
                double.parse(notifier.recipientController.text),
                false,
              );
            },
            activeColor: orangePantone,
          ),
        ),
        Expanded(
          child: RadioListTile(
            value: 2,
            groupValue: notifier.selectedRadioTile,
            title: Text(
              notifier.selectedReceiver == "BDT"
                  ? "E-Wallet"
                  : notifier.selectedReceiver == "KRW" ||
                  notifier.selectedReceiver == "MYR"
                  ? "Business"
                  : notifier.selectedReceiver == "PHP"
                  ? "Cash"
                  : notifier.selectedReceiver ==
                  "USD"
                  ? "Country Outside USA"
                  : "Radio2",
            ),
            onChanged: (int? val) {
              notifier.setSelectedRadioTile(val!);

              if(notifier.selectedReceiver == "BDT" && notifier.countryData != AppConstants.AustraliaName){
                notifier.isCash = false;
                notifier.isSwift = false;
                notifier.isWallet = true;
              }else if(notifier.selectedReceiver == "PHP" && notifier.countryData != AppConstants.AustraliaName){
                notifier.isCash = true;
                notifier.isSwift = false;
                notifier.isWallet = false;
              }else if(notifier.selectedReceiver == "USD" || (notifier.selectedReceiver == "PHP" && notifier.countryData == AppConstants.AustraliaName)){
                notifier.isSwift = true;
                notifier.isCash = false;
                notifier.isWallet = false;
              }else{
                notifier.isSwift = false;
                notifier.isCash = false;
                notifier.isWallet = false;
              }

              notifier.exchangeApi(
                context,
                notifier.selectedSender,
                notifier.selectedReceiver,
                notifier.countryData == AppConstants.australia
                    ? AppConstants.secondText
                    : AppConstants.receiveText,
                double.parse(notifier.recipientController.text),
                false,
              );
            },
            activeColor: orangePantone,
          ),
        )
      ],
    );
  }

  Widget buildExchangeRateLessThan375(BuildContext context, FundTransferNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          S.of(context).exchangeRate,
          style: exchangeRateHeadingTextStyle(context),
        ),
        sizedBoxHeight5(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${notifier.exchangeRateInitial} ${notifier.exchangeSelectedSender}",
              style: exchangeRateDataTextStyle(context),
            ),
            sizedBoxWidth10(context),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  String temp;
                  temp = notifier.exchangeSelectedSender;
                  notifier.exchangeSelectedSender =
                      notifier.exchangeSelectedReceiver;
                  notifier.exchangeSelectedReceiver = temp;
                  notifier.exchangeRateConverted = (1 /
                      double.parse(notifier
                          .exchangeRateConverted))
                      .toString();
                },
                child: Icon(
                  AppCustomIcon.transferIndicator,
                  size: 15,
                  color: orangeColor,
                ),
              ),
            ),
            sizedBoxWidth10(context),
            Text(
              "${double.parse(notifier.exchangeRateConverted) ==0?"0":getNumber(double.parse(notifier.exchangeRateConverted),)} ${notifier.exchangeSelectedReceiver}",
              style: exchangeRateDataTextStyle(context),
            ),
            sizedBoxWidth3(context),
            questionToolTip(context, notifier),
          ],
        ),
      ],
    );
  }

  Widget buildExchangeRateGreaterThan375(BuildContext context, FundTransferNotifier notifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          S.of(context).exchangeRate,
          style: exchangeRateHeadingTextStyle(context),
        ),
        Row(
          children: [
            Text(
              "${notifier.exchangeRateInitial} ${notifier.exchangeSelectedSender}",
              style: exchangeRateDataTextStyle(context),
            ),
            sizedBoxWidth10(context),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  String temp;
                  temp = notifier.exchangeSelectedSender;
                  notifier.exchangeSelectedSender =
                      notifier.exchangeSelectedReceiver;
                  notifier.exchangeSelectedReceiver = temp;
                  notifier.exchangeRateConverted = (1 /
                      double.parse(notifier
                          .exchangeRateConverted))
                      .toString();
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Icon(
                    AppCustomIcon.transferIndicator,
                    size: 15,
                    color: orangeColor,
                  ),
                ),
              ),
            ),
            sizedBoxWidth10(context),
            Text(
              "${double.parse(notifier.exchangeRateConverted) ==0?"0":getNumber(double.parse(notifier.exchangeRateConverted),)} ${notifier.exchangeSelectedReceiver}",
              style: exchangeRateDataTextStyle(context),
            ),
            sizedBoxWidth3(context),
            questionToolTip(context, notifier),
          ],
        ),
      ],
    );
  }

  Widget buildFeeAndTotalLessThan340(BuildContext context, FundTransferNotifier notifier) {
    return Column(
      children: [
        sizedBoxHeight15(context),
        Column(
          children: [
            Text(
              S.of(context).singXFee,
              style: exchangeRateHeadingTextStyle(context),
            ),
            sizedBoxHeight5(context),
            Text(
              "${notifier.selectedSender} ${double.parse(notifier.singXData.toString()).toStringAsFixed(2)}",
              style: exchangeRateDataTextStyle(context),
            )
          ],
        ),
        sizedBoxHeight15(context),
        Column(
          children: [
            Text(
              notifier.selectedFrom == '1'
                  ? S.of(context).totalAmount
                  : getScreenWidth(context) < 420
                  ? S
                  .of(context)
                  .totalPayableAmountMobile
                  : S.of(context).totalPayableAmountWeb,
              style: totalAmountTextStyleStyleWeb(context),
            ),
            sizedBoxHeight5(context),
            Text(
              double.parse(notifier.totalPayable.toString())
                  .toStringAsFixed(2),
              style: totalAmountTextStyleStyleWeb(context),
            )
          ],
        ),
      ],
    );
  }

  Widget buildFeeAndTotalGreaterThan340(BuildContext context, FundTransferNotifier notifier) {
    return Column(
      children: [
        sizedBoxHeight8(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).singXFee,
              style: exchangeRateHeadingTextStyle(context),
            ),
            Text(
              "${notifier.selectedSender} ${double.parse(notifier.singXData.toString()).toStringAsFixed(2)}",
              style: exchangeRateDataTextStyle(context),
            )
          ],
        ),
        sizedBoxHeight8(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              kIsWeb
                  ? notifier.countryData == 'SGD'
                      ? S.of(context).totalPayableAmountWeb
                      : getScreenWidth(context) < 420
                          ? S.of(context).totalPayableAmountMobile
                          : S.of(context).totalPayableAmountWeb
                  : notifier.countryData == 'SGD'
                      ? S.of(context).totalPayableAmountWeb
                      : screenSizeWidth < 420
                          ? S.of(context).totalPayableAmountMobile
                          : S.of(context).totalPayableAmountWeb,
              style: totalAmountTextStyleStyleWeb(context),
            ),
            Text(
              "${notifier.selectedSender} ${double.parse(notifier.totalPayable.toString()).toStringAsFixed(2)}",
              style: totalAmountTextStyleStyleWeb(context),
            )
          ],
        )
      ],
    );
  }

  Widget questionToolTip(BuildContext context, FundTransferNotifier notifier) {
    return InkWell(
      onTap: (){
        notifier.tooltipController.showTooltip();
      },
      child: IgnorePointer(
        ignoring: true,
        child: JustTheTooltip(
          controller: notifier.tooltipController,
          showDuration: Duration(seconds: 5),
          content: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text.rich(TextSpan(
              mouseCursor: SystemMouseCursors.click,
              text:
              'This is the real mid-market exchange rate at \nwhich banks transact with each other. The \nretail rates you get with other providers will be \nsignificantly higher.',
              style: TextStyle(
                color: black,
              ),
              children: [
                if(notifier.countryData != AppConstants.AustraliaName) TextSpan(
                  text: '\nLearn more.',
                  style: TextStyle(
                    color: hanBlue,
                  ),
                  mouseCursor: SystemMouseCursors.click,
                  recognizer: TapGestureRecognizer()..onTap = (){
                    SharedPreferencesMobileWeb.instance
                        .getCountry(AppConstants.country)
                        .then((value) {
                      if (Uri.base.toString().contains(AppConstants.singxLink)) {
                        launchUrlString(
                            AppConstants.faqLink);
                      } else if (value == AppConstants.singapore) {
                        launchUrlString(
                            AppConstants.faqLinkUAT);
                      } else if (value == AppConstants.hongKong) {
                        launchUrlString(
                            AppConstants.faqLinkHK);
                      } else if (value == AppConstants.australia) {
                        launchUrlString(
                            AppConstants.faqLinkAUS);
                      }
                    });
                  },
                ),
              ],
            )),
          ),
          child: Icon(
            AppCustomIcon.questionMark,
            size: 13,
            color: orangePantone,
          ),
        ),
      ),
    );
  }

  // Country RoundOff Message
  Widget countryRoundOff(BuildContext context, FundTransferNotifier dashboardNotifier) {
    Widget richData = SizedBox();

    if (dashboardNotifier.selectedReceiver == 'KRW') {
      richData = Text.rich(
        TextSpan(
          text:
              AppConstants.KRWNote,
          style: policyStyleBlack(context),
          children: <TextSpan>[
            TextSpan(
              text: AppConstants.clickHereToRoundOff,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  dashboardNotifier.recipientController.text =
                      double.parse(dashboardNotifier.recipientController.text)
                          .toStringAsFixed(0);
                  dashboardNotifier.exchangeApi(
                    context,
                    dashboardNotifier.selectedSender,
                    dashboardNotifier.selectedReceiver,
                    dashboardNotifier.countryData == AppConstants.australia
                        ? AppConstants.secondText
                        : AppConstants.receiveText,
                    double.parse(dashboardNotifier.recipientController.text),
                    false,
                  );
                  dashboardNotifier.errorExchangeValue = '';
                },
              style: policyStyleHanBlue(context),
            ),
          ],
        ),
      );
    } else if (dashboardNotifier.selectedReceiver == 'VND') {
      richData = Text.rich(
        TextSpan(
          text:
              AppConstants.VNDNote,
          style: policyStyleBlack(context),
          children: <TextSpan>[
            TextSpan(
              text: AppConstants.clickHereToRoundOff,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  dashboardNotifier.recipientController.text =
                      double.parse(dashboardNotifier.recipientController.text)
                          .toStringAsFixed(0);
                  dashboardNotifier.recipientController
                      .text = double.parse(dashboardNotifier.recipientController.text.substring(dashboardNotifier.recipientController.text.length - 3)) <
                          500
                      ? dashboardNotifier.recipientController.text.replaceAll(
                          dashboardNotifier.recipientController.text.substring(
                              dashboardNotifier.recipientController.text.length -
                                  3),
                          '000')
                      : dashboardNotifier.recipientController.text.replaceAll(
                          dashboardNotifier.recipientController.text.substring(
                              dashboardNotifier.recipientController.text.length - 3),
                          '500');
                  dashboardNotifier.exchangeApi(
                    context,
                    dashboardNotifier.selectedSender,
                    dashboardNotifier.selectedReceiver,
                    dashboardNotifier.countryData == AppConstants.australia
                        ? AppConstants.secondText
                        : AppConstants.receiveText,
                    double.parse(dashboardNotifier.recipientController.text),
                    false,
                  );
                  dashboardNotifier.errorExchangeValue = '';
                },
              style: policyStyleHanBlue(context),
            ),
          ],
        ),
      );
    }else if (dashboardNotifier.selectedReceiver == 'JPY') {
      richData = Text.rich(
        TextSpan(
          text:
            AppConstants.JPYNote,
          style: policyStyleBlack(context),
          children: <TextSpan>[
            TextSpan(
              text: AppConstants.clickHereToRoundOff,
              recognizer: TapGestureRecognizer()
                ..onTap = () async{
                  dashboardNotifier.recipientController.text =
                      double.parse(dashboardNotifier.recipientController.text)
                          .toStringAsFixed(0);
                  await dashboardNotifier.exchangeApi(context,
                    dashboardNotifier.selectedSender,
                    dashboardNotifier.selectedReceiver,
                    dashboardNotifier.countryData == AppConstants.australia
                        ? AppConstants.secondText
                        : AppConstants.receiveText,
                    double.parse(dashboardNotifier.recipientController.text), false,);
                  if(dashboardNotifier.countryData == AppConstants.AustraliaName) dashboardNotifier.errorExchangeValue = '';
                },
              style: policyStyleHanBlue(context),
            ),
          ],
        ),
      );
    } else if (dashboardNotifier.selectedReceiver == 'PHP' && (dashboardNotifier.isSwift == true || dashboardNotifier.isCash == true)) {
      richData = Text.rich(
        TextSpan(
          text:
              AppConstants.PHPNote,
          style: policyStyleBlack(context),
          children: <TextSpan>[
            TextSpan(
              text: AppConstants.clickHereToRoundOff,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  dashboardNotifier.recipientController.text =
                      double.parse(dashboardNotifier.recipientController.text)
                          .toStringAsFixed(0);
                  dashboardNotifier.recipientController.text = double.parse(
                              dashboardNotifier.recipientController.text
                                  .substring(dashboardNotifier
                                          .recipientController.text.length -
                                      1)) ==
                          0
                      ? dashboardNotifier.recipientController.text
                      : dashboardNotifier.recipientController.text.replaceAll(
                          dashboardNotifier.recipientController.text.substring(
                              dashboardNotifier
                                      .recipientController.text.length -
                                  1),
                          '0');
                  dashboardNotifier.exchangeApi(
                    context,
                    dashboardNotifier.selectedSender,
                    dashboardNotifier.selectedReceiver,
                    dashboardNotifier.countryData == AppConstants.australia
                        ? AppConstants.secondText
                        : AppConstants.receiveText,
                    double.parse(dashboardNotifier.recipientController.text),
                    false,
                  );
                  dashboardNotifier.errorExchangeValue = '';
                },
              style: policyStyleHanBlue(context),
            ),
          ],
        ),
      );
    }


    return richData;
  }

  String countryDataMessage(context, FundTransferNotifier dashboardNotifier, country) {
    String message = '';
    if (dashboardNotifier.countryData == AppConstants.SingaporeName) {
      if (country == 'USD') {
        if (dashboardNotifier.isSwift == false) {
          message =
              "To send USD to someone outside of USA, please select \"Country Outside USA\".";
        } else {
          message =
              'Please note for USD transfers outside the USA, there may be additional charges incurred depending on the receiver bank as this is a SWIFT payment. To send USD to someone within USA, please select "USA".';
        }
      } else if (country == 'CAD') {
        message =
            'Please note for CAD transfers, there may be additional charges incurred depending on the receiver bank.';
      } else if (country == 'IDR') {
        message = 'Note: You can book upto 2 transactions in a day';
      } else if (country == 'JPY') {
        message =
            'Please note for JPY transfers, there may be additional charges incurred depending on the receiver bank.';
      } else if (country == 'KRW') {
        message =
            'Note:- Please round off the receive amount to the nearest whole number (no decimals) to proceed with the transaction. Click here to round off now';
      } else if (country == 'NZD') {
        message =
            'Please note for NZD transfers, there may be additional charges incurred depending on the receiver bank as this is a SWIFT payment.';
      } else if (country == 'VND') {
        message =
            'Note:- Please round off the receive amount to the nearest multiple of 500 to proceed with the transaction. Click here to round off now';
      } else if (country == 'CNY') {
        message =
            'Note - Exchange rate shown is indicative only, actual rate will be confirmed when receiver accepts payment via his/her wallet. Receiver has to be a Chinese national.';
      }
    } else if (dashboardNotifier.countryData == AppConstants.HongKongName) {
      if (country == 'USD') {
        if (dashboardNotifier.isSwift == false) {
          message =
              "To send USD to someone outside of USA, please select \"Country Outside USA\".";
        } else {
          message =
              'Please note for USD transfers outside the USA, there may be additional charges incurred depending on the receiver bank as this is a SWIFT payment. To send USD to someone within USA, please select "USA".';
        }
      } else if (country == 'CAD') {
        message =
            'Please note for CAD transfers, there may be additional charges incurred depending on the receiver bank.';
      } else if (country == 'JPY') {
        message =
            'Please note for JPY transfers, there may be additional charges incurred depending on the receiver bank.';
      } else if (country == 'KRW') {
        message =
            'Note:- Please round off the receive amount to the nearest whole number (no decimals) to proceed with the transaction. Click here to round off now';
      } else if (country == 'NZD') {
        message =
            'Please note for NZD transfers, there may be additional charges incurred depending on the receiver bank as this is a SWIFT payment.';
      } else if (country == 'VND') {
        message =
            'Note:- Please round off the receive amount to the nearest multiple of 500 to proceed with the transaction. Click here to round off now';
      } else if (country == 'CNY') {
        message =
            'Note - Exchange rate shown is indicative only, actual rate will be confirmed when receiver accepts payment via his/her wallet. Receiver has to be a Chinese national.';
      }
    } else if (dashboardNotifier.countryData == AppConstants.AustraliaName) {
      if (country == 'JPY') {
        message =
            'Please note for JPY transfers, there may be additional charges incurred depending on the receiver bank.';
      } else if (country == 'KRW') {
        message =
            'Note:- Please round off the receive amount to the nearest whole number (no decimals) to proceed with the transaction. Click here to round off now';
      } else if (country == 'NZD') {
        message =
            'Please note for NZD transfers, there may be additional charges incurred depending on the receiver bank as this is a SWIFT payment.';
      } else if (country == 'PHP') {
        message =
            'Note:- Please round off the receive amount to the nearest multiple of 10 to proceed with the transaction. Click here to round off now';
      } else if (country == 'USD') {
        if (dashboardNotifier.isSwift == false) {
          message =
              "To send USD to someone outside of USA, please select \"Country Outside USA\".";
        } else {
          message =
              'Please note for USD transfers outside the USA, there may be additional charges incurred depending on the receiver bank as this is a SWIFT payment. To send USD to someone within USA, please select "USA".';
        }
      } else if (country == 'VND') {
        message =
            'Note:- Please round off the receive amount to the nearest multiple of 500 to proceed with the transaction. Click here to round off now';
      }
    }
    return message;
  }

  // Transfer Limit Message
  String dataTransferLimitMessage(context, FundTransferNotifier dashboardNotifier, country) {
    dashboardNotifier.checkTransferLimit = '';
    // if (dashboardNotifier.countryData == SingaporeName || dashboardNotifier.countryData == HongKongName) {
    //   if(country == 'AED'){
    //     if(double.parse(dashboardNotifier.recipientController.text) >= 35000) dashboardNotifier.checkTransferLimit = 'Note: The transaction limit for individual receivers is AED 35,000.';
    //   }else if(country == 'ZAR'){
    //     if(double.parse(dashboardNotifier.recipientController.text) >= 80000) dashboardNotifier.checkTransferLimit = 'Note: The transaction limit for individual receivers is ZAR 80,000.';
    //   }else if(country == 'MYR'){
    //     if(double.parse(dashboardNotifier.recipientController.text) >= 999999) dashboardNotifier.checkTransferLimit = 'Note: The transaction limit for individual receivers is MYR 999,999.';
    //   }else if(country == 'MYR'){
    //     if(double.parse(dashboardNotifier.recipientController.text) >= 999999) dashboardNotifier.checkTransferLimit = 'Note: The transaction limit for individual receivers is MYR 999,999.';
    //   }else if(country == 'VND'){
    //     if(double.parse(dashboardNotifier.recipientController.text) >= 300000000) dashboardNotifier.checkTransferLimit = 'For transfers to Vietnam (VND), there is a maximum transfer limit of VND 300,000,000 per transaction.';
    //     else if(double.parse(dashboardNotifier.recipientController.text) <= 10000) dashboardNotifier.checkTransferLimit = 'For transfers to Vietnam (VND), there is a minimum transfer limit of VND 10,000 per transaction.';
    //   }else if(country == 'LKR'){
    //     if(double.parse(dashboardNotifier.recipientController.text) >= 1000000) dashboardNotifier.checkTransferLimit = 'For transfers to Sri Lanka (LKR), there is a maximum transfer limit of LKR  1,000,000 per transaction.';
    //     else if(double.parse(dashboardNotifier.recipientController.text) <= 100) dashboardNotifier.checkTransferLimit = 'For transfers to Sri Lanka (LKR), there is a minimum transfer limit of LKR 100 per transaction.';
    //   }else if(country == 'PKR'){
    //     if(double.parse(dashboardNotifier.recipientController.text) >= 1000000) dashboardNotifier.checkTransferLimit = 'For transfers to Pakistan (PKR), there is a maximum transfer limit of PKR  1,000,000 per transaction.';
    //     else if(double.parse(dashboardNotifier.recipientController.text) <= 100) dashboardNotifier.checkTransferLimit = 'For transfers to Pakistan (PKR), there is a minimum transfer limit of PKR 100 per transaction.';
    //   }else if(country == 'NPR'){
    //     if(double.parse(dashboardNotifier.recipientController.text) >= 1000000) dashboardNotifier.checkTransferLimit = 'For transfers to Nepal (NPR), there is a maximum transfer limit of NPR  1,000,000 per transaction.';
    //     else if(double.parse(dashboardNotifier.recipientController.text) <= 100) dashboardNotifier.checkTransferLimit = 'For transfers to Nepal (NPR), there is a minimum transfer limit of NPR 100 per transaction.';
    //   }else if(country == 'KRW'){
    //     if(double.parse(dashboardNotifier.recipientController.text) <= 10000) dashboardNotifier.checkTransferLimit = 'For transfers to South Korea (KRW), there is a minimum transfer limit of KRW 10,000 per transaction for businesses.';
    //   }else if(country == 'JPY'){
    //     if(double.parse(dashboardNotifier.recipientController.text) >= 1000000) dashboardNotifier.checkTransferLimit = 'For transfers to Japan (JPY), there is a maximum transfer limit of SGD 1,000,000 per transaction.';
    //   }else if(country == 'PHP'){
    //     if(dashboardNotifier.isCash == false){
    //       if(dashboardNotifier.countryData == SingaporeName) if(double.parse(dashboardNotifier.recipientController.text) >= 500000) dashboardNotifier.checkTransferLimit = 'For transfers to Philippines (PHP), there is a maximum transfer limit of PHP 500,000 per transaction.';
    //       if(dashboardNotifier.countryData == HongKongName) if(double.parse(dashboardNotifier.recipientController.text) >= 490000) dashboardNotifier.checkTransferLimit = 'For transfers to Philippines (PHP), there is a maximum transfer limit of PHP 490,000 per transaction.';
    //     }else{
    //       if(double.parse(dashboardNotifier.recipientController.text) >= 500000) dashboardNotifier.checkTransferLimit = 'For transfers to Philippines (PHP), there is a maximum transfer limit of PHP 500,000 per transaction.';
    //       else if(double.parse(dashboardNotifier.recipientController.text) <= 5000) dashboardNotifier.checkTransferLimit = 'For cash transfers to Philippines (PHP), there is a minimum transfer limit of PHP 5,000 per transaction.';
    //     }
    //   }else if(country == 'THB'){
    //     if(double.parse(dashboardNotifier.recipientController.text) >= 49999) dashboardNotifier.checkTransferLimit = 'For transfers to Thailand (THB), there is a maximum transfer limit of THB 49,999 per transaction.';
    //   }else if(country == 'GBP'){
    //     if(double.parse(dashboardNotifier.recipientController.text) >= 550000) dashboardNotifier.checkTransferLimit = 'For transfers to United Kingdom (GBP), there is a maximum transfer limit of GBP 550,000 per transaction';
    //   }else if(country == 'CNY'){
    //     if(dashboardNotifier.countryData == SingaporeName) if(double.parse(dashboardNotifier.sendController.text) >= 3800) dashboardNotifier.checkTransferLimit = 'For transfers to China (CNY), there is a maximum transfer limit of SGD 3,800 per transaction and SGD 7,600 per day.';
    //     if(dashboardNotifier.countryData == HongKongName) if(double.parse(dashboardNotifier.sendController.text) >= 23000) dashboardNotifier.checkTransferLimit = 'For transfers to China (CNY), there is a maximum transfer limit of HKD 23,000 per transaction and HKD 45,000 per day.';
    //   }else if(country == 'USD'){
    //     if(dashboardNotifier.isSwift == false){
    //       if(double.parse(dashboardNotifier.recipientController.text) >= 700000) dashboardNotifier.checkTransferLimit = 'For transfers to United States of America (USD), there is a maximum transfer limit of USD 700,000 per transaction. To send amount greater than USD 700,000, set up this receiver with SWIFT details.';
    //     }
    //   }else if(country == 'BDT'){
    //     if(dashboardNotifier.isSwift == false){
    //       if(double.parse(dashboardNotifier.recipientController.text) >= 200000) dashboardNotifier.checkTransferLimit = 'For transfers to Bangladesh (BDT) Bank Account, there is a maximum transfer limit of BDT 200,000 per transaction.';
    //       else if(double.parse(dashboardNotifier.recipientController.text) <= 50) dashboardNotifier.checkTransferLimit = 'For transfers to Bangladesh (BDT), there is a minimum transfer limit of BDT 50 per transaction.';
    //     }else{
    //       if(double.parse(dashboardNotifier.recipientController.text) >= 125000) dashboardNotifier.checkTransferLimit = 'For transfers to Bangladesh (BDT) E-Wallet, there is a maximum transfer limit of BDT 125,000 per transaction.';
    //       else if(double.parse(dashboardNotifier.recipientController.text) <= 50) dashboardNotifier.checkTransferLimit = 'For transfers to Bangladesh (BDT), there is a minimum transfer limit of BDT 50 per transaction.';
    //     }
    //   }
    // } else
      if(dashboardNotifier.countryData == AppConstants.AustraliaName){
      if(country == 'AED'){
        if(double.parse(dashboardNotifier.recipientController.text) > 35000) dashboardNotifier.checkTransferLimit = 'For transfers to United Arab Emirates (USD), there is a maximum transfer limit of AED 35,000 per transaction.';
      }else if(country == 'ZAR'){
        if(double.parse(dashboardNotifier.recipientController.text) > 80000) dashboardNotifier.checkTransferLimit = 'Note: The transaction limit for individual receivers is ZAR 80,000.';
      }else if(country == 'MYR'){
        if(double.parse(dashboardNotifier.recipientController.text) > 999999) dashboardNotifier.checkTransferLimit = 'Note - The transaction limit for individual receivers is MYR 999,999.';
      }else if(country == 'VND'){
        if(double.parse(dashboardNotifier.recipientController.text) > 300000000) dashboardNotifier.checkTransferLimit = 'For transfers to Vietnam (VND), there is a maximum transfer limit of VND 300,000,000 per transaction.';
        else if(double.parse(dashboardNotifier.recipientController.text) < 10000) dashboardNotifier.checkTransferLimit = 'For transfers to Vietnam (VND), there is a minimum transfer limit of VND 10,000 per transaction.';
      }else if(country == 'LKR'){
        if(double.parse(dashboardNotifier.recipientController.text) > 1000000) dashboardNotifier.checkTransferLimit = 'For transfers to Sri Lanka (LKR), there is a maximum transfer limit of LKR 1,000,000 per transaction.';
        else if(double.parse(dashboardNotifier.recipientController.text) <= 100) dashboardNotifier.checkTransferLimit = 'For transfers to Sri Lanka (LKR), there is a minimum transfer limit of LKR 100 per transaction.';
      }else if(country == 'PKR'){
        if(double.parse(dashboardNotifier.recipientController.text) > 1000000) dashboardNotifier.checkTransferLimit = 'For transfers to Pakistan (PKR), there is a maximum transfer limit of PKR  1,000,000 per transaction.';
        else if(double.parse(dashboardNotifier.recipientController.text) < 100) dashboardNotifier.checkTransferLimit = 'For transfers to Pakistan (PKR), there is a minimum transfer limit of PKR 100 per transaction.';
      }else if(country == 'NPR'){
        if(double.parse(dashboardNotifier.recipientController.text) > 1000000) dashboardNotifier.checkTransferLimit = 'For transfers to Nepal (NPR), there is a maximum transfer limit of NPR 1,000,000 per transaction for businesses.';
        else if(double.parse(dashboardNotifier.recipientController.text) < 10) dashboardNotifier.checkTransferLimit = 'For transfers to Nepal (NPR), there is a minimum transfer limit of NPR 10 per transaction for individuals.';
      }else if(country == 'KRW'){
        if(dashboardNotifier.isSwift == false) {
          if (double.parse(dashboardNotifier.recipientController.text) < 0)
            dashboardNotifier.checkTransferLimit =
            'For transfers to South Korea (KRW), there is a minimum transfer limit of KRW 0 per transaction for individuals.';
        }else{
          if (double.parse(dashboardNotifier.recipientController.text) < 10000)
            dashboardNotifier.checkTransferLimit =
            'For transfers to South Korea (KRW), there is a minimum transfer limit of KRW 10,000 per transaction for businesses.';
        }
      }else if(country == 'JPY'){
        if(double.parse(dashboardNotifier.recipientController.text) > 1000000) dashboardNotifier.checkTransferLimit = 'For transfers to Japan (JPY), there is a maximum transfer limit of JPY 1,000,000 per transaction.';
      }else if(country == 'THB'){
        if(double.parse(dashboardNotifier.recipientController.text) > 49999) dashboardNotifier.checkTransferLimit = 'For transfers to Thailand (THB), there is a maximum transfer limit of THB 49,999 per transaction.';
      }else if(country == 'GBP'){
        if(double.parse(dashboardNotifier.recipientController.text) > 550000) dashboardNotifier.checkTransferLimit = 'For transfers to United Kingdom (GBP), there is a maximum transfer limit of GBP 550,000 per transaction.';
      }else if(country == 'CNY'){
        if(double.parse(dashboardNotifier.sendController.text) > 3700) dashboardNotifier.checkTransferLimit = 'For transfers to China (CNY), there is a maximum transfer limit of AUD 3,700 per transaction and AUD 7,600 per day.';
      }else if(country == 'USD'){
        if(dashboardNotifier.isSwift == false){
          if(double.parse(dashboardNotifier.recipientController.text) > 700000) dashboardNotifier.checkTransferLimit = 'For transfers to United States of America (USD), there is a maximum transfer limit of USD 700,000 per transaction.';
        }else{
          if(double.parse(dashboardNotifier.recipientController.text) > 700000) dashboardNotifier.checkTransferLimit = 'For transfers to United States of America (USD), there is a maximum transfer limit of USD 700,000 per transaction.';
        }
      }else if(country == 'BDT'){
        if(dashboardNotifier.isSwift == false){
          if(double.parse(dashboardNotifier.recipientController.text) > 200000) dashboardNotifier.checkTransferLimit = 'For transfers to Bangladesh (BDT) Bank Account, there is a maximum transfer limit of BDT 200,000 per transaction.';
        }else{
          if(double.parse(dashboardNotifier.recipientController.text) > 125000) dashboardNotifier.checkTransferLimit = 'For transfers to Bangladesh (BDT) E-Wallet, there is a maximum transfer limit of BDT 125,000 per transaction.';
        }
      }

    }
    return dashboardNotifier.checkTransferLimit;
  }

  // Account Label
  Widget buildAccountText(FundTransferNotifier notifier, BuildContext context) {
    return notifier.countryData == AppConstants.singapore
        ? buildText(
            text: S.of(context).selectAccount,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            fontColor: oxfordBlue)
        : buildText(
            text: S.of(context).selectBankAccount,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            fontColor: oxfordBlue);
  }

  // Select Account Info
  Widget buildSelectAccountText(BuildContext context) {
    return buildText(
        text: S.of(context).selectAccountYouWishToSend,
        fontWeight: FontWeight.w400,
        fontSize: 16,
        fontColor: oxfordBlueTint400);
  }

  // SG Wallet Transfer Radio button
  Widget buildAccountType1(FundTransferNotifier notifier, BuildContext context) {
    return GestureDetector(
      onTap: () {
        checkWalletBalance(context, notifier);
      },
      child: buildAccountTypes(
        notifier,
        number: 0,
        children: [
          buildRadioButton(notifier, number: 0),
          commonSizedBoxWidth20(context),
          Expanded(
              child: buildText(
                  text: 'My SingX wallet (SGD ${notifier.walletBalance})',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontColor: black)),
          Visibility(
              visible: kIsWeb ? getScreenWidth(context) > 450 && notifier.isTopUpVisible && notifier.selectedSender == 'SGD' : screenSizeWidth > 450 && notifier.isTopUpVisible && notifier.selectedSender == 'SGD',
              child: kIsWeb ? getScreenWidth(context) < 600
                  ? Column(children: [
                      buildBalanceText(context),
                      buildTopUpText(context, notifier)
                    ])
                  : Row(children: [
                      buildBalanceText(context),
                      buildTopUpText(context, notifier)
                    ],) : screenSizeWidth < 600 ? Column(children: [
                buildBalanceText(context),
                buildTopUpText(context, notifier)
              ])
                  : Row(children: [
                buildBalanceText(context),
                buildTopUpText(context, notifier)
              ],)),
        ],
      ),
    );
  }

  // Balance Label
  Widget buildBalanceText(BuildContext context) {
    return buildText(
        text: S.of(context).insufficientBalance,
        fontColor: errorTextField,
        fontSize: 14,
        fontWeight: FontWeight.w400);
  }

  //TopUp Label
  Widget buildTopUpText(BuildContext context, FundTransferNotifier notifier) {
    return InkWell(
      onTap: () async {
        notifier.selectedBank = null;
        await SharedPreferencesMobileWeb.instance
            .getCountry(AppConstants.country)
            .then((value) async {
          Navigator.pushNamed(context, manageWalletRoute);
        });
      },
      child: buildText(
          text: S.of(context).topupNow,
          fontColor: errorTextField,
          fontSize: 14,
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.w700),
    );
  }

  // SG Bank Transfer Radio button
  Widget buildAccountType2(FundTransferNotifier notifier, BuildContext context) {
    return GestureDetector(
      onTap: () => notifier.isAccountTypeSelected = true,
      child: buildAccountTypes(notifier, number: 1, children: [
        buildRadioButton(notifier, number: 1),
        commonSizedBoxWidth20(context),
        buildText(
            text: S.of(context).bankTransfer,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            fontColor: black),
      ]),
    );
  }

  // Select the bank Label
  Widget buildSelectYourBankText(BuildContext context) {
    return buildText(
        text: S.of(context).selectBankAccount,
        fontSize: 16,
        fontColor: oxfordBlueTint500);
  }

  // Adding a new receiver account
  Widget buildAddNewAccount(FundTransferNotifier notifier, ManageSenderNotifier notifier2, BuildContext context) {
    return Row(
      children: [
        IconButton(
            hoverColor: Colors.transparent,
            icon: Icon(Icons.add),
            color: hanBlue,
            onPressed: () => openBankNewAccountPopUp(
                  context,
                  notifier,
                  notifier2,
                )),
        commonSizedBoxWidth10(context),
        InkWell(
          onTap: () => openBankNewAccountPopUp(
            context,
            notifier,
            notifier2,
          ),
          child: buildText(
              text: S.of(context).addNewAccount,
              fontColor: hanBlue,
              fontWeight: FontWeight.w700),
        )
      ],
    );
  }

  Widget buildAccountTypes(FundTransferNotifier notifier, {required List<Widget> children, number}) {
    return Container(
      height: AppConstants.sixtyfive,
      decoration: BoxDecoration(
          border: Border.all(
              color: notifier.isAccountTypeSelected == false && number == 0
                  ? orangePantone
                  : notifier.isAccountTypeSelected == true && number == 1
                      ? orangePantone
                      : Colors.black.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(AppConstants.twelve)),
      child: Padding(
        padding: EdgeInsets.all(AppConstants.twelve),
        child: Row(children: children),
      ),
    );
  }

  // SG Wallet Or bank account radioButton
  Widget buildRadioButton(FundTransferNotifier notifier, {number}) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xffEEEEEE), width: 2)),
      child: CircleAvatar(
        radius: 10,
        backgroundColor:
            (notifier.isAccountTypeSelected == false && number == 0) ||
                    (notifier.isAccountTypeSelected == true && number == 1)
                ? orangePantone
                : Colors.white24,
        child: CircleAvatar(radius: 6, backgroundColor: white),
      ),
    );
  }

  // Back and Continue button
  Widget buildButtons(FundTransferNotifier notifier, BuildContext context) {
    return commonBackAndContinueButton(
      context,
      widthBetween: kIsWeb ? getScreenWidth(context) * 0.02 : screenSizeWidth * 0.02,
      onPressedContinue: () async {
        if(notifier.errorExchangeValue != "") return;
        if(notifier.selectedSender != notifier.exchangeSelectedSender){
          String temp;
          temp = notifier.exchangeSelectedSender;
          notifier.exchangeSelectedSender =
              notifier.exchangeSelectedReceiver;
          notifier.exchangeSelectedReceiver = temp;
          notifier.exchangeRateConverted = (1 /
              double.parse(notifier
                  .exchangeRateConverted))
              .toString();
        }
        if (dataTransferLimitMessage(
                context, notifier, notifier.selectedReceiver) ==
            "") {
          if(notifier.recipientController.text == "0"){
            notifier.errorExchangeValue = "Please Enter Valid Amount";
            return;
          }
          DashboardChinaPayTransferLimitResponse dashboardChinaPayTransferLimitResponse = DashboardChinaPayTransferLimitResponse();
          DashboardPhpTransferLimitResponse dashboardPhpTransferLimitResponse = DashboardPhpTransferLimitResponse();
          if(notifier.countryData == AppConstants.AustraliaName){
            if(notifier.selectedReceiver == "CNY"){
              await FxRepository()
                  .apiDashboardChinaPayTransferLimit(
                  DashboardChinaPayTransferLimitRequest(
                      contactId: notifier.contactId),
                  context)
                  .then((value) {
                dashboardChinaPayTransferLimitResponse = value as DashboardChinaPayTransferLimitResponse;
              });
              if(double.parse(notifier.sendController.text) >= 3700 || ((double.parse(notifier.sendController.text) + double.parse(dashboardChinaPayTransferLimitResponse.message!)) >= 7600) ){
                notifier.checkTransferLimit = "For transfers to China (CNY), there is a maximum transfer limit of AUD 3,700 per transaction and AUD 7,600 per day.";
                return ;
              }
            }
            if(notifier.selectedReceiver == "PHP"){
              await FxRepository()
                  .apiDashboardPHPTransferLimit(
                  DashboardPHPTransferLimitRequest(
                      contactId: notifier.contactId),
                  context)
                  .then((value) {
                dashboardPhpTransferLimitResponse = value as DashboardPhpTransferLimitResponse;
              });
              if(double.parse(notifier.recipientController.text) > 50000 && notifier.isSwift == false){
                notifier.checkTransferLimit = "For transfers to Philippines (PHP), there is a maximum transfer limit of PHP 500,000 per transaction";
                return ;
              }else if(notifier.isSwift == true && (double.parse(notifier.recipientController.text) > 50000 || dashboardPhpTransferLimitResponse.phpCashPickUpLimit! > 5000)){
                notifier.checkTransferLimit = "For transfers to Philippines (PHP), there is a maximum transfer limit of PHP 50,000 per transaction";
                return ;
              }else if(notifier.isSwift == true && (double.parse(notifier.sendController.text) > dashboardPhpTransferLimitResponse.segmentLimit!)){
                notifier.checkTransferLimit = "For transfers to Philippines (PHP), there is a maximum transfer limit of PHP ${dashboardPhpTransferLimitResponse.segmentLimit!} on sender amount per transaction.";
                return ;
              }
            }
          }
          if(notifier.countryData == AppConstants.AustraliaName){
            if((notifier.selectedReceiver == "JPY") && ((double.parse(notifier.recipientController.text) % 1) != 0)){
              return;
            }else if((notifier.selectedReceiver == "KRW") && ((double.parse(notifier.recipientController.text) % 1) != 0)){
              return;
            }else if((notifier.selectedReceiver == "VND") && ((double.parse(notifier.recipientController.text) % 500) != 0)){
              return;
            } else if ((notifier.selectedReceiver == "PHP" && notifier.isSwift == true) &&
                ((double.parse(notifier.recipientController.text) %
                    10) !=
                    0)) {
              return;
            }
          }else{
            if((notifier.selectedReceiver == "JPY") && ((double.parse(notifier.recipientController.text) % 1) != 0)){
              return;
            }else if((notifier.selectedReceiver == "KRW") && ((double.parse(notifier.recipientController.text) % 1) != 0)){
              return;
            }else if((notifier.selectedReceiver == "VND") && ((double.parse(notifier.recipientController.text) % 500) != 0)){
              return;
            }else if((notifier.selectedReceiver == "PHP"  && notifier.isCash == true) && ((double.parse(notifier.recipientController.text)  % 10) != 0)){
              return;
            }
          }          notifier.countryData == AppConstants.AustraliaName
              ? null
              : await notifier.getSendCountryApi(context);
          notifier.countryData == AppConstants.AustraliaName
              ? null
              : await notifier.getReceiverCountryApi(context);
          if (notifier.accountPageKey.currentState!.validate()) {
            Map<String, dynamic> dashboardData = {
              "receiveAmount": notifier.recipientController.text,
              "sendAmount": notifier.sendController.text,
              "sendCurrency": notifier.selectedSender,
              "receiveCurrency": notifier.selectedReceiver,
              "isSwift": notifier.isSwift,
              "isCash": notifier.isCash,
              "selectedRadioTile": notifier.selectedRadioTile,
              "selectedTransferMode": notifier.selectedTransferMode,
            };
            await SharedPreferencesMobileWeb.instance
                .setDashboardCalculatorData(
                AppConstants.dashboardCalc, jsonEncode(dashboardData));
            Map<String, dynamic> accountData = {
              "exchangeRate": getNumber(double.parse(notifier.exchangeRateConverted),).toString(),
              "receiveAmount": notifier.recipientController.text,
              "sendAmount": notifier.sendController.text,
              "sendCurrency": notifier.selectedSender,
              "corridorID": notifier.corridorID,
              "receiveCurrency": notifier.selectedReceiver,
              "senderId": notifier.countryData == AppConstants.AustraliaName
                  ? notifier.selectedBankId
                  : notifier.isAccountTypeSelected
                      ? notifier.selectedBankId
                      : "",
              "singXFee": notifier.singXData,
              "totalPayable": double.parse(notifier.totalPayable.toStringAsFixed(2)),
              "selectedBankAccount": notifier.selectedBank == null
                  ? notifier.selectedSenderBankController.text
                  : notifier.selectedBank,
              "selectedAccountType": notifier.isAccountTypeSelected && notifier.selectedTransferMode == 2 ?  "2" : notifier.isAccountTypeSelected ? '1' : '4',
              "isAccountTypeSelected": notifier.isAccountTypeSelected,
              "senderCountryId": notifier.senderCountryId,
              "receiverCountryId": notifier.receiverCountryId,
            };
            await SharedPreferencesMobileWeb.instance
                .setFundTransferAccountData(
                AppConstants.accountScreenData, jsonEncode(accountData));
            Provider.of<CommonNotifier>(context, listen: false)
                .incrementCounterFund();
            await SharedPreferencesMobileWeb.instance
                .getCountry(AppConstants.country)
                .then((value) async {
              Navigator.pushNamed(context, fundTransferSelectReceiverRoute);
            });
            SharedPreferencesMobileWeb.instance
                .setAccountSelectedScreenData(AppConstants.accountPage, true);
          }
        } else {
          if(notifier.countryData == AppConstants.AustraliaName){
            if (dataTransferLimitMessage(context, notifier,
                notifier.selectedReceiver) !=
                "") {
              notifier.errorExchangeValue = "";
            }
          }
          dataTransferLimitMessage(
              context, notifier, notifier.selectedReceiver);
        }
      },
      onPressedBack: () async {
        Map<String, dynamic> dashboardData = {
          "receiveAmount": notifier.recipientController.text,
          "sendAmount": notifier.sendController.text,
          "sendCurrency": notifier.selectedSender,
          "receiveCurrency": notifier.selectedReceiver,
          "isSwift": notifier.isSwift,
          "isCash": notifier.isCash,
          "selectedRadioTile": notifier.selectedRadioTile,
          "selectedTransferMode": notifier.selectedTransferMode,
        };
        await SharedPreferencesMobileWeb.instance
            .setDashboardCalculatorData(
            AppConstants.dashboardCalc, jsonEncode(dashboardData));
        await SharedPreferencesMobileWeb.instance
            .removeParticularKey(AppConstants.accountScreenData);
        await SharedPreferencesMobileWeb.instance
            .removeParticularKey(AppConstants.receiverScreenData);
        await SharedPreferencesMobileWeb.instance
            .removeParticularKey(AppConstants.reviewScreenData);
        SharedPreferencesMobileWeb.instance
            .setAccountSelectedScreenData(AppConstants.accountPage, false);
        SharedPreferencesMobileWeb.instance
            .setReceiverSelectedScreenData(AppConstants.receiverPage, false);
        SharedPreferencesMobileWeb.instance
            .setReceiverSelectedScreenData(AppConstants.reviewPage, false);
        String data = '';
        SharedPreferencesMobileWeb.instance
            .getStepperRoute('Stepper')
            .then((value) async {
          data = value;

          if (data == "Dashboard") {
            await SharedPreferencesMobileWeb.instance
                .getCountry(AppConstants.country)
                .then((value) async {
              Navigator.pushNamedAndRemoveUntil(
                  context, dashBoardRoute, (route) => false);
            });
          } else if (data == "Manage receivers") {
            await SharedPreferencesMobileWeb.instance
                .getCountry(AppConstants.country)
                .then((value) async {
              Navigator.pushNamedAndRemoveUntil(
                  context, manageReceiverRoute, (route) => false);
            });
          } else {}
        });
      },
      backWidth: kIsWeb
          ? getScreenWidth(context) <= 1150
              ? getScreenWidth(context) * 0.44
              : getScreenWidth(context) * 0.24
          : screenSizeWidth <= 1150
              ? screenSizeWidth * 0.44
              : screenSizeWidth * 0.24,
      continueWidth: kIsWeb
          ? getScreenWidth(context) <= 1150
              ? getScreenWidth(context) * 0.44
              : getScreenWidth(context) * 0.24
          : screenSizeWidth <= 1150
              ? screenSizeWidth * 0.44
              : screenSizeWidth * 0.24,
    );
  }

  Widget buildMoneyTextField(BuildContext context,
      FundTransferNotifier notifier, buttonFunction, selected,
      {text, controller, List<String>? dropDownData, onChangedData}) {
    return SizedBox(
      width: kIsWeb ? getScreenWidth(context) <= 1150
              ? null
              : getScreenWidth(context) * 0.225 : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sizedBoxHeight15(context),
          buildText(text: text, fontSize: AppConstants.sixteen, fontColor: oxfordBlueTint400),
          sizedBoxHeight10(context),
          Visibility(
              visible: kIsWeb ? getScreenWidth(context) < 340 : screenSizeWidth < 340,
              child: Container(
                width: AppConstants.oneHundredAndThirty,
                height: AppConstants.fortyFive,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppConstants.ten),
                    color: const Color(0xffdae3f3)),
                child: dropdownCountrySelectionDashboard(
                    context, selected, dropDownData, buttonFunction),
              )),
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Selector<FundTransferNotifier, TextEditingController>(
                      builder: (context, textEditControl, child) {
                        return TextField(
                          keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                          ],
                          style: transferAmountTextStyle(context),
                          controller: textEditControl,
                          onChanged: onChangedData,
                          decoration: const InputDecoration(
                              border: InputBorder.none, counterText: ""),
                        );
                      },
                      selector: (buildContext, dashboardNotifier) => controller,
                    ),
                  ],
                ),
              ),
              Visibility(
                  visible: kIsWeb ? getScreenWidth(context) > 340 : screenSizeWidth > 340,
                  child: Container(
                    width: AppConstants.oneHundredAndThirty,
                    height: AppConstants.fortyFive,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppConstants.ten),
                        color: const Color(0xffdae3f3)),
                    child: dropdownCountrySelectionDashboard(
                        context, selected, dropDownData, buttonFunction),
                  )),
            ],
          ),
          const Divider(
            thickness: 1,
          ),
        ],
      ),
    );
  }

  // Bank Account Dropdown Field
  Widget buildBankAccountDropDownField() {
    return LayoutBuilder(
        builder: (context, constraints) => CustomizeDropdown(context,
                dropdownItems: accountPageNotifier.senderBankAccounts,
                optionsViewBuilder: (BuildContext context,
                    AutocompleteOnSelected onSelected, Iterable options) {
              return buildDropDownContainer(context,
                  options: options,
                  onSelected: onSelected,
                  dropdownData: accountPageNotifier.senderBankAccounts,
                  dropDownWidth: kIsWeb
                      ? getScreenWidth(context) >= 1150
                          ? constraints.biggest.width
                          : getScreenWidth(context) * 0.90
                      : screenSizeWidth >= 1150
                          ? constraints.biggest.width
                          : screenSizeWidth * 0.90,
                  dropDownHeight: options.first == S.of(context).noDataFound
                      ? AppConstants.oneHundredFifty
                      : options.length < 5
                          ? options.length * 50
                          : accountPageNotifier.countryData != AppConstants.SingaporeName
                              ? AppConstants.twoHundred
                              : AppConstants.oneHundredFifty);
            }, onSelected: (selection) {
              if (accountPageNotifier.countryData == AppConstants.AustraliaName) {
                handleInteraction(context);
                accountPageNotifier.selectedBank = selection;
                var value =
                    accountPageNotifier.senderBankAccounts.indexOf(selection);
                accountPageNotifier.selectedBankId =
                    accountPageNotifier.senderBankId[value].toString();
              } else {
                handleInteraction(context);
                accountPageNotifier.selectedBank = selection;
                var value =
                    accountPageNotifier.senderBankAccounts.indexOf(selection);
                accountPageNotifier.selectedBankId =
                    accountPageNotifier.senderBankId[value].toString();
              }
            }, onSubmitted: (selection) {
              if (accountPageNotifier.countryData == AppConstants.AustraliaName) {
                handleInteraction(context);
                accountPageNotifier.selectedBank = selection;
                var value =
                    accountPageNotifier.senderBankAccounts.indexOf(selection);

                accountPageNotifier.selectedBankId =
                    accountPageNotifier.senderBankId[value].toString();
              } else {
                handleInteraction(context);
                accountPageNotifier.selectedBank = selection;
                var value =
                    accountPageNotifier.senderBankAccounts.indexOf(selection);

                accountPageNotifier.selectedBankId =
                    accountPageNotifier.senderBankId[value].toString();
              }
            },
                hintText: S.of(context).select,
                controller: accountPageNotifier.selectedSenderBankController,
          validation: (value) {
            if (value == null || value.isEmpty) {
              return 'Select bank account';
            }
            return null;
          },
        ));
  }

  // Send Amount TextField
  Widget buildSendMoneyField(BuildContext context, FundTransferNotifier notifier) {
    return buildMoneyTextField(
      context,
      notifier,
      //SGD/USD drop down start
      notifier.countryData == AppConstants.australia ||
              notifier.countryData == AppConstants.hongKong
          ? null
          : (String? val) async {
              handleInteraction(context);
              notifier.selectedSenderBankController.clear();
              notifier.selectedSender = val!;
              notifier.exchangeSelectedSender = notifier.selectedSender;
              notifier.exchangeSelectedReceiver = notifier.selectedReceiver;
              notifier.isSwift = false;
              notifier.isCash = false;
              notifier.selectedRadioTile = 1;
              await notifier.getSendCountryApi(context);

              notifier.selectedBank = null;
              notifier.receiverData.clear();
              notifier.countryData == AppConstants.australia
                  ? null
                  : FxRepository().corridorResponseData.forEach((key, value) {
                      if (notifier.selectedSender == key) {
                        value.forEach((element) {
                          notifier.selectedReceiver = value[0].key!;
                        });
                      }
                      if (val == key) {
                        value.forEach((element) {
                          notifier.receiverData.add(element.key!);
                        });
                      }
                    });
              notifier.exchangeSelectedSender = notifier.selectedSender;
              notifier.exchangeApi(
                context,
                notifier.selectedSender,
                notifier.selectedReceiver,
                notifier.countryData == AppConstants.australia
                    ? AppConstants.firstText
                    : AppConstants.secondText,
                double.parse(notifier.sendController.text),
                false,
              );
              notifier.selectedReceiverBank = "";
              Map<String, dynamic> accountData = {
                "selectedReceiverBank": notifier.selectedReceiverBank,
                "receiverId": notifier.selectedBankReceiverId,
                "receiverName": notifier.receiverNameData,
                "receiverBankName": notifier.receiverBankNameData,
                "receiverAccountNumber": notifier.receiverAccountNumberData,
                "receiverCountry": notifier.receiverCountryData,
              };
              SharedPreferencesMobileWeb.instance.setFundTransferReceiverData(
                  AppConstants.receiverScreenData, jsonEncode(accountData));
              Map<String, dynamic> dashboardData = {
                "receiveAmount": notifier.recipientController.text,
                "sendAmount": notifier.sendController.text,
                "sendCurrency": notifier.selectedSender,
                "receiveCurrency": notifier.selectedReceiver,
                "isSwift": notifier.isSwift,
                "isCash": notifier.isCash,
                "selectedRadioTile": notifier.selectedRadioTile,
                "selectedTransferMode": notifier.selectedTransferMode,
              };
              await SharedPreferencesMobileWeb.instance
                  .setDashboardCalculatorData(
                  AppConstants.dashboardCalc, jsonEncode(dashboardData));
            },
      //SGD/USD drop down end

      notifier.selectedSender,
      onChangedData: (value) async {
        //TextField Value Validation
        final regex = RegExp(r'^0(?!\.|$)');
        if (regex.hasMatch(value)) {
          notifier.sendController.text = value.substring(1); // Remove the leading zero
          notifier.sendController.selection =
              TextSelection.fromPosition(TextPosition(
                  offset: notifier.sendController.text.length));
        } else if (value.isEmpty) {

          notifier.sendController.text = '0'; // Set the value to "0" when cleared
          notifier.recipientController.text = "0";
          notifier.singXData = 0;
          notifier.totalPayable = 0;
          notifier.sendController.selection =
              TextSelection.fromPosition(TextPosition(
                  offset: notifier.sendController.text.length));

        }else {
          notifier.sendController.text = value;
          notifier.sendController.selection =
              TextSelection.fromPosition(TextPosition(
                  offset: notifier.sendController.text.length));
        }

        notifier.exchangeApi(
          context,
          notifier.selectedSender,
          notifier.selectedReceiver,
          notifier.countryData == AppConstants.australia ? AppConstants.firstText : AppConstants.sendText,
          double.parse(notifier.sendController.text),
          false,
        );
        checkWalletBalance(context, notifier);
        Map<String, dynamic> dashboardData = {
          "receiveAmount": notifier.recipientController.text,
          "sendAmount": notifier.sendController.text,
          "sendCurrency": notifier.selectedSender,
          "receiveCurrency": notifier.selectedReceiver,
          "isSwift": notifier.isSwift,
          "isCash": notifier.isCash,
          "selectedRadioTile": notifier.selectedRadioTile,
          "selectedTransferMode": notifier.selectedTransferMode,
        };
        await SharedPreferencesMobileWeb.instance.setDashboardCalculatorData(
            AppConstants.dashboardCalc, jsonEncode(dashboardData));
      },
      text: S.of(context).youSend,
      controller: notifier.sendController,
      dropDownData: notifier.senderData,
    );
  }

  // Receive Amount TextField
  Widget buildReceiveMoneyField(BuildContext context, FundTransferNotifier notifier) {
    return buildMoneyTextField(
      context,
      notifier,
      (String? val) async {
        handleInteraction(context);
        notifier.selectedReceiverBankController.clear();
        notifier.selectedReceiver = val!;
        notifier.exchangeSelectedReceiver = notifier.selectedReceiver;
        notifier.exchangeSelectedSender = notifier.selectedSender;
        notifier.isSwift = false;
        notifier.isCash = false;
        notifier.selectedRadioTile = 1;
        notifier.countryData == AppConstants.australia
            ? null
            : await notifier.getReceiverCountryApi(context);
        notifier.exchangeSelectedReceiver = notifier.selectedReceiver;
        if (notifier.countryData == AppConstants.AustraliaName)
          notifier.selectedReceiverCountryID = notifier.receiverCountryIDData[
              notifier.receiverData.indexOf(val) == -1
                  ? 1
                  : notifier.receiverData.indexOf(val)];
        if (notifier.countryData == AppConstants.AustraliaName)
          await SharedPreferencesMobileWeb.instance
              .setCountryId(notifier.selectedReceiverCountryID);

        if (notifier.countryData == AppConstants.AustraliaName)
          notifier.getReceiverBankAccounts(
              context, notifier.selectedReceiverCountryID);

        notifier.exchangeApi(
            context,
            notifier.selectedSender,
            notifier.selectedReceiver,
            notifier.countryData == AppConstants.australia ? AppConstants.firstText : AppConstants.sendText,
            double.parse(notifier.sendController.text), true,);
        notifier.selectedReceiverBank = "";
        Map<String, dynamic> accountData = {
          "selectedReceiverBank": notifier.selectedReceiverBank,
          "receiverId": notifier.selectedBankReceiverId,
          "receiverName": notifier.receiverNameData,
          "receiverBankName": notifier.receiverBankNameData,
          "receiverAccountNumber": notifier.receiverAccountNumberData,
          "receiverCountry": notifier.receiverCountryData,
        };
        SharedPreferencesMobileWeb.instance.setFundTransferReceiverData(
            AppConstants.receiverScreenData, jsonEncode(accountData));
        Map<String, dynamic> dashboardData = {
          "receiveAmount": notifier.recipientController.text,
          "sendAmount": notifier.sendController.text,
          "sendCurrency": notifier.selectedSender,
          "receiveCurrency": notifier.selectedReceiver,
          "isSwift": notifier.isSwift,
          "isCash": notifier.isCash,
          "selectedRadioTile": notifier.selectedRadioTile,
          "selectedTransferMode": notifier.selectedTransferMode,
        };
        await SharedPreferencesMobileWeb.instance.setDashboardCalculatorData(
            AppConstants.dashboardCalc, jsonEncode(dashboardData));
      },
      notifier.selectedReceiver,
      onChangedData: (value) async {
        //TextField Value Validation
        final regex = RegExp(r'^0(?!\.|$)');
        if (regex.hasMatch(value)) {
          notifier.recipientController.text = value.substring(1); // Remove the leading zero
          notifier.recipientController.selection =
              TextSelection.fromPosition(TextPosition(
                  offset: notifier.recipientController.text.length));
        } else if (value.isEmpty) {

          notifier.recipientController.text = '0'; // Set the value to "0" when cleared
          notifier.sendController.text = "0";
          notifier.singXData = 0;
          notifier.totalPayable = 0;
          notifier.recipientController.selection =
              TextSelection.fromPosition(TextPosition(
                  offset: notifier.recipientController.text.length));

        }else {
          notifier.recipientController.text = value;
          notifier.recipientController.selection =
              TextSelection.fromPosition(TextPosition(
                  offset: notifier.recipientController.text.length));
        }

        notifier.selectedReceiverBank = "";
        Map<String, dynamic> dashboardData = {
          "receiveAmount": notifier.recipientController.text,
          "sendAmount": notifier.sendController.text,
          "sendCurrency": notifier.selectedSender,
          "receiveCurrency": notifier.selectedReceiver,
          "isSwift": notifier.isSwift,
          "isCash": notifier.isCash,
          "selectedRadioTile": notifier.selectedRadioTile,
          "selectedTransferMode": notifier.selectedTransferMode,
        };

        await SharedPreferencesMobileWeb.instance.setDashboardCalculatorData(
            AppConstants.dashboardCalc, jsonEncode(dashboardData));

        await notifier.exchangeApi(
          context,
          notifier.selectedSender,
          notifier.selectedReceiver,
          notifier.countryData == AppConstants.australia ? AppConstants.secondText : AppConstants.receiveText,
          double.parse(notifier.recipientController.text),
          true,
        );
        checkWalletBalance(context, notifier);
      },
      text: S.of(context).recipientGets,
      controller: notifier.recipientController,
      dropDownData: notifier.receiverData,
    );
  }
}

// Adding a new sender popUp dialog
openBankNewAccountPopUp(BuildContext context1,
    FundTransferNotifier fundNotifier, ManageSenderNotifier notifier,
    {bool? isWalletPopUp}) {
  notifier.senderRepository!.senderBankNames(context1, AppConstants.australiaCode);
  return showDialog(
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AppInActiveCheck(
            context: context,
            child: AlertDialog(
              content: Container(
                  height: 650,
                  width: 550,
                  child: isWalletPopUp == true
                      ? ManageSender(
                              navigateData: true, isWalletPopUpEnabled: true)
                          .build(context)
                      : ManageSender(
                              navigateData: true, isSenderPopUpEnabled: true)
                          .build(context)),
            ),
          );
        });
      },
      context: context1);
}
