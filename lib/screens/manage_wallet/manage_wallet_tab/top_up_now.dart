import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/service/fund_transfer_repository.dart';
import 'package:singx/core/data/remote/service/sg_wallet_repository.dart';
import 'package:singx/core/models/request_response/fund_transfer/get_sender_account_details_response.dart';
import 'package:singx/core/models/request_response/sg_wallet/sg_wallet_check_limit.dart';
import 'package:singx/core/models/request_response/sg_wallet/wallet_top_up_request.dart';
import 'package:singx/core/models/request_response/sg_wallet/wallet_top_up_response.dart';
import 'package:singx/core/notifier/fund_transfer_notifier.dart';
import 'package:singx/core/notifier/manage_sender_notifier.dart';
import 'package:singx/core/notifier/wallet_top_up_now_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/main.dart';
import 'package:singx/screens/fund_transfer/account.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_custom_icon.dart';
import 'package:singx/utils/common/app_images.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/common/app_widgets.dart';

class TopUpNow extends StatelessWidget {
  TopUpNow({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    userCheck(context);
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => WalletTopUpNowNotifier(),
      child: Consumer<WalletTopUpNowNotifier>(
          builder: (context, walletTopUpNowNotifier, _) {
        return ScaffoldMessenger(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).topUPWithDAsh,
                style: fairexchangeStyle(context),
              ),
              sizedBoxHeight25(context),
              Text(
                S.of(context).enterTopupValue,
                style: topUpFieldTextStyle(context),
              ),
              sizedBoxHeight10(context),
              amountFieldWeb(
                  context,
                  walletTopUpNowNotifier.amountController,
                  text: null,
                  hintText: AppConstants.example500HintText,
                  suffixIcon: Container(
                    margin: EdgeInsets.zero,
                    height: AppConstants.thirtySix,
                    decoration: amountFieldDecorationStyle(context),
                    child: dropdownCountrySelectionWeb(
                      context,
                      walletTopUpNowNotifier.selectedSender,
                      AppConstants.myJson,
                      null,
                    ),
                  ),
                  callBack:  (val) {
                    walletTopUpNowNotifier.walletTopUpErrorMessage = '';
                    walletTopUpNowNotifier.amountIsEmpty = false;
                    handleInteraction(context);
                  },
                  focusChange: (hasFocus){
                      if(!hasFocus) {
                        final formatter = NumberFormat("###0.00");
                        walletTopUpNowNotifier.amountController.text =
                            formatter.format(double.parse(
                                walletTopUpNowNotifier.amountController.text));
                      }
                  },
                  textType: "number",
              ),
              sizedBoxHeight10(context),
              Text(
                S.of(context).youCanHoldAMaximum,
                style: walletGridTextStyle(context),
              ),
              sizedBoxHeight30(context),
              Text(
                S.of(context).selectPaymentMethod,
                style: tabBarTextStyle(context),
              ),
              sizedBoxHeight15(context),
              paymentMethods(context, walletTopUpNowNotifier),
              Visibility(
                  visible: walletTopUpNowNotifier.isAccountSelected,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sizedBoxHeight30(context),
                        buildAddNewAccount(context, walletTopUpNowNotifier),
                        sizedBoxHeight15(context),
                        getScreenWidth(context) >= 710
                            ? gridViewAccountList(context, walletTopUpNowNotifier)
                            : defaultTargetPlatform != TargetPlatform.iOS ? listViewAccountList(context, walletTopUpNowNotifier) : listViewAccountListIOS(context,walletTopUpNowNotifier)
                      ],)),
              sizedBoxHeight20(context),
              Visibility(
                  visible: walletTopUpNowNotifier.walletTopUpErrorMessage.isNotEmpty && walletTopUpNowNotifier.walletTopUpErrorMessage != '',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        walletTopUpNowNotifier.walletTopUpErrorMessage,
                        style: errorMessageStyle(context),
                      ),
                      sizedBoxHeight10(context)
                    ],
                  )),
              Visibility(
                visible: walletTopUpNowNotifier.amountIsEmpty,
                child: Text(
                  walletTopUpNowNotifier
                      .amountController.text.isEmpty ? 'Please Enter the amount' : double.parse(walletTopUpNowNotifier
                      .amountController.text) <= 0 ? "Please Enter Valid Amount" : '',
                  style: errorMessageStyle(context),
                ),
              ),
              sizedBoxHeight10(context),
              buildButton(
                context,
                name: S.of(context).topUPWithDAsh,
                onPressed: () async {
                  if(walletTopUpNowNotifier.isAccountSelected == true && walletTopUpNowNotifier.selectedSenderID.isEmpty){
                    walletTopUpNowNotifier.walletTopUpErrorMessage = "Please Select Bank Account";
                    return;
                  }
                  if (walletTopUpNowNotifier
                      .amountController.text.isNotEmpty && double.parse(walletTopUpNowNotifier
                      .amountController.text) >  0) {
                    walletTopUpNowNotifier.amountIsEmpty = false;
                    await SGWalletRepository()
                        .SGWalletTopUpLimitCheck(context,
                            walletTopUpNowNotifier.amountController.text)
                        .then((value) async {
                      SgWalletTopUpLimitCheck sgWalletTopUpLimitCheck =
                          value as SgWalletTopUpLimitCheck;
                      if (sgWalletTopUpLimitCheck.success == true) {
                        walletTopUpNowNotifier.walletTopUpErrorMessage = "";
                        await SGWalletRepository()
                            .SGWalletTopUpWallet(
                                context,
                                WalletTopUpRequest(
                                    amount: double.parse(walletTopUpNowNotifier
                                        .amountController.text),
                                    currencyCode: "SGD",
                                    paymentType: walletTopUpNowNotifier
                                            .isAccountSelected
                                        ? "Bank"
                                        : "PayNow",
                                    senderId: walletTopUpNowNotifier
                                            .isAccountSelected
                                        ? walletTopUpNowNotifier
                                            .selectedSenderID
                                        : "0"))
                            .then((value) {
                          WalletTopUpResponse walletTopUpResponse = value;
                          walletTopUpNowNotifier.payNowQR =
                              walletTopUpResponse.qrCode!;
                          walletTopUpNowNotifier.referenceNumber =
                              walletTopUpResponse.transactionId!;
                          walletTopUpNowNotifier.bankName =
                              walletTopUpResponse.bankName!;
                          walletTopUpNowNotifier.acName =
                              walletTopUpResponse.accountName!;
                          walletTopUpNowNotifier.acNumber =
                              walletTopUpResponse.accountNumber!;
                        });
                        walletTopUpNowNotifier.copied =false;
                        walletTopUpNowNotifier.isAccountSelected == false
                            ? buildTopUpViaPayNow(
                                context, walletTopUpNowNotifier)
                            : buildTopUpViaBankTransfer(
                                context, walletTopUpNowNotifier);
                      } else {
                        walletTopUpNowNotifier.walletTopUpErrorMessage =
                            sgWalletTopUpLimitCheck.message!;
                      }
                    });
                  } else {
                    walletTopUpNowNotifier.amountIsEmpty = false;
                    Timer.periodic(Duration(milliseconds: 5), (timer) {
                      walletTopUpNowNotifier.amountIsEmpty = true;
                      timer.cancel();
                    });
                  }
                },
                fontColor: white,
                color: hanBlue,
              ),
            ],
          ),
        );
      }),
    );
  }

  // payment methods
  Widget paymentMethods(
      BuildContext context, WalletTopUpNowNotifier walletTopUpNowNotifier) {
    return Column(
      children: [
        payNowMethod(walletTopUpNowNotifier, context),
        sizedBoxHeight15(context),
        bankTransferMethod(walletTopUpNowNotifier, context),
      ],
    );
  }

  // pay now - quick credit
  Widget payNowMethod(
      WalletTopUpNowNotifier walletTopUpNowNotifier, BuildContext context) {
    return GestureDetector(
      onTap: () => walletTopUpNowNotifier.isAccountSelected = false,
      child: buildAccountTypes(
        context,
        walletTopUpNowNotifier: walletTopUpNowNotifier,
        number: 0,
        children: [
          buildRadioButton(
              number: 0, walletTopUpNowNotifier: walletTopUpNowNotifier),
          SizedBoxWidth(context, 0.02),
          Expanded(
            child: buildTextNew(
              text: S.of(context).payNowQuick,
              fontWeight: FontWeight.w600,
              ellipses: true,
              fontSize: AppConstants.sixteen,
              fontColor: black,
            ),
          ),
        ],
      ),
    );
  }

  // bank transfer - credit in few hours
  Widget bankTransferMethod(
      WalletTopUpNowNotifier walletTopUpNowNotifier, BuildContext context) {
    return GestureDetector(
      onTap: () => walletTopUpNowNotifier.isAccountSelected = true,
      child: buildAccountTypes(
        context,
        walletTopUpNowNotifier: walletTopUpNowNotifier,
        number: 1,
        children: [
          buildRadioButton(
              number: 1, walletTopUpNowNotifier: walletTopUpNowNotifier),
          SizedBoxWidth(context, 0.02),
          Expanded(
            child: buildTextNew(
              text: S.of(context).bankTransferCredit,
              fontWeight: FontWeight.w600,
              ellipses: true,
              fontSize: AppConstants.sixteen,
              fontColor: black,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAccountTypes(BuildContext context,
      {required List<Widget> children,
      number,
      required WalletTopUpNowNotifier walletTopUpNowNotifier}) {
    return Container(
      height: AppConstants.fiftyFive,
      decoration: BoxDecoration(
        color: white,
        border: Border.all(
          color: walletTopUpNowNotifier.isAccountSelected == false &&
                  number == 0
              ? orangePantone
              : walletTopUpNowNotifier.isAccountSelected == true && number == 1
                  ? orangePantone
                  : Colors.black.withOpacity(0.1),
        ),
        boxShadow: walletTopUpNowNotifier.isAccountSelected == false &&
                number == 0
            ? [
                BoxShadow(
                  offset: Offset(0, 15),
                  color: listTileexpansionColor.withOpacity(0.10),
                  blurRadius: 30,
                ),
              ]
            : walletTopUpNowNotifier.isAccountSelected == true && number == 1
                ? [
                    BoxShadow(
                      offset: Offset(0, 15),
                      color: listTileexpansionColor.withOpacity(0.10),
                      blurRadius: 30,
                    ),
                  ]
                : null,
        borderRadius: radiusAll10(context),
      ),
      child: Padding(
        padding: px12DimenAll(context),
        child: Row(children: children),
      ),
    );
  }

  // Gridview for tab and web
  Widget gridViewAccountList(
      BuildContext context, WalletTopUpNowNotifier walletTopUpNowNotifier) {
    return Selector<WalletTopUpNowNotifier, List<GetSenderAccountDetails>>(
        builder: (context, textEditControl, child) {
          return Container(
            height: walletTopUpNowNotifier.itemCountData.length.isEven
                ? 130 *
                    walletTopUpNowNotifier.itemCountData.length.toDouble() /
                    2
                : 130 *
                    (walletTopUpNowNotifier.itemCountData.length.toDouble() +
                        1) /
                    2,
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: walletTopUpNowNotifier.itemCountData.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppConstants.fifteen,
                mainAxisSpacing: AppConstants.fifteen,
                childAspectRatio: 1 / 0.3333,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    walletTopUpNowNotifier.selectedSenderID =
                        walletTopUpNowNotifier.itemCountData[index].id
                            .toString();
                    walletTopUpNowNotifier.gridAccountSelected = index;
                    if(walletTopUpNowNotifier.walletTopUpErrorMessage == "Please Select Bank Account"){
                      walletTopUpNowNotifier.walletTopUpErrorMessage = "";
                    }
                  },
                  child: Container(
                    padding: px16DimenAll(context),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            walletTopUpNowNotifier.gridAccountSelected == index
                                ? orangePantone
                                : containerBorderColor,
                        width: AppConstants.one,
                      ),
                      borderRadius: radiusAll10(context),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                walletTopUpNowNotifier
                                    .itemCountData[index].name!,
                                style: tabBarTextStyle(context),
                              ),
                              Text(
                                walletTopUpNowNotifier
                                    .itemCountData[index].accountNumber!,
                                style: gridViewTextStyle(context),
                              ),
                              Text(
                                walletTopUpNowNotifier
                                    .itemCountData[index].bankName!,
                                style: gridViewTextStyle(context),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: AppConstants.twenty,
                          width: AppConstants.twenty,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                walletTopUpNowNotifier.gridAccountSelected ==
                                        index
                                    ? null
                                    : Border.all(
                                        color: containerBorderColor,
                                        width: AppConstants.one,
                                      ),
                            color: walletTopUpNowNotifier.gridAccountSelected ==
                                    index
                                ? orangePantone
                                : white,
                          ),
                          child: Center(
                            child: Container(
                              height: AppConstants.twelve,
                              width: AppConstants.twelve,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        selector: (buildContext, walletTopUpNowNotifier) =>
            walletTopUpNowNotifier.itemCountData);
  }

  // Listview for mobile
  Widget listViewAccountList(
      BuildContext context, WalletTopUpNowNotifier walletTopUpNowNotifier) {
    return Selector<WalletTopUpNowNotifier, List<GetSenderAccountDetails>>(
        builder: (context, textEditControl, child) {
          return LayoutBuilder(
            builder: (context, constraints) =>
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.minHeight),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: walletTopUpNowNotifier.itemCountData.length,
                  physics: NeverScrollableScrollPhysics(),scrollDirection: Axis.vertical,
                  separatorBuilder: (context, index) => sizedBoxHeight15(context),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        walletTopUpNowNotifier.selectedSenderID =
                        walletTopUpNowNotifier.itemCountData[index].id!;
                        walletTopUpNowNotifier.gridAccountSelected = index;
                        if(walletTopUpNowNotifier.walletTopUpErrorMessage == "Please Select Bank Account"){
                          walletTopUpNowNotifier.walletTopUpErrorMessage = "";
                        }

                      },
                      child: Container(
                        padding: px16DimenAll(context),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                            walletTopUpNowNotifier.gridAccountSelected == index
                                ? orangePantone
                                : containerBorderColor,
                            width: AppConstants.one,
                          ),
                          borderRadius: radiusAll10(context),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    walletTopUpNowNotifier
                                        .itemCountData[index].name!,
                                    style: tabBarTextStyle(context),
                                  ),
                                  Visibility(
                                      visible: getScreenWidth(context) < 710,
                                      child: sizedBoxHeight5(context)),
                                  Text(
                                    walletTopUpNowNotifier
                                        .itemCountData[index].accountNumber!,
                                    style: gridViewTextStyle(context),
                                  ),
                                  Visibility(
                                      visible: getScreenWidth(context) < 710,
                                      child: sizedBoxHeight5(context)),
                                  Text(
                                    walletTopUpNowNotifier
                                        .itemCountData[index].bankName!,
                                    style: gridViewTextStyle(context),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: AppConstants.twenty,
                              width: AppConstants.twenty,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                walletTopUpNowNotifier.gridAccountSelected ==
                                    index
                                    ? null
                                    : Border.all(
                                  color: containerBorderColor,
                                  width: AppConstants.one,
                                ),
                                color: walletTopUpNowNotifier.gridAccountSelected ==
                                    index
                                    ? orangePantone
                                    : white,
                              ),
                              child: Center(
                                child: Container(
                                  height: AppConstants.twelve,
                                  width: AppConstants.twelve,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          );
        },
        selector: (buildContext, loginNotifier) => loginNotifier.itemCountData);
  }

  // Listview for iOS
  Widget listViewAccountListIOS(
      BuildContext context, WalletTopUpNowNotifier walletTopUpNowNotifier) {
    return Selector<WalletTopUpNowNotifier, List<GetSenderAccountDetails>>(
        builder: (context, textEditControl, child) {
          return Container(
            height: 400,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: walletTopUpNowNotifier.itemCountData.length,
              scrollDirection: Axis.vertical,
              separatorBuilder: (context, index) => sizedBoxHeight15(context),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    walletTopUpNowNotifier.selectedSenderID =
                    walletTopUpNowNotifier.itemCountData[index].id!;
                    walletTopUpNowNotifier.gridAccountSelected = index;
                    if(walletTopUpNowNotifier.walletTopUpErrorMessage == "Please Select Bank Account"){
                      walletTopUpNowNotifier.walletTopUpErrorMessage = "";
                    }

                  },
                  child: Container(
                    padding: px16DimenAll(context),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                        walletTopUpNowNotifier.gridAccountSelected == index
                            ? orangePantone
                            : containerBorderColor,
                        width: AppConstants.one,
                      ),
                      borderRadius: radiusAll10(context),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                walletTopUpNowNotifier
                                    .itemCountData[index].name!,
                                style: tabBarTextStyle(context),
                              ),
                              Visibility(
                                  visible: getScreenWidth(context) < 710,
                                  child: sizedBoxHeight5(context)),
                              Text(
                                walletTopUpNowNotifier
                                    .itemCountData[index].accountNumber!,
                                style: gridViewTextStyle(context),
                              ),
                              Visibility(
                                  visible: getScreenWidth(context) < 710,
                                  child: sizedBoxHeight5(context)),
                              Text(
                                walletTopUpNowNotifier
                                    .itemCountData[index].bankName!,
                                style: gridViewTextStyle(context),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: AppConstants.twenty,
                          width: AppConstants.twenty,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                            walletTopUpNowNotifier.gridAccountSelected ==
                                index
                                ? null
                                : Border.all(
                              color: containerBorderColor,
                              width: AppConstants.one,
                            ),
                            color: walletTopUpNowNotifier.gridAccountSelected ==
                                index
                                ? orangePantone
                                : white,
                          ),
                          child: Center(
                            child: Container(
                              height: AppConstants.twelve,
                              width: AppConstants.twelve,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        selector: (buildContext, loginNotifier) => loginNotifier.itemCountData);
  }

  // Radio buttons container
  Widget buildRadioButton(
      {number, required WalletTopUpNowNotifier walletTopUpNowNotifier}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: (walletTopUpNowNotifier.isAccountSelected == false &&
                    number == 0) ||
                (walletTopUpNowNotifier.isAccountSelected == true &&
                    number == 1)
            ? Border.all(
                color: Colors.transparent,
                width: AppConstants.twoDouble,
              )
            : Border.all(
                color: containerBorderColor,
                width: AppConstants.twoDouble,
              ),
      ),
      child: CircleAvatar(
        radius: AppConstants.ten,
        backgroundColor: (walletTopUpNowNotifier.isAccountSelected == false &&
                    number == 0) ||
                (walletTopUpNowNotifier.isAccountSelected == true &&
                    number == 1)
            ? orangePantone
            : white24,
        child: CircleAvatar(
          radius: AppConstants.six,
          backgroundColor: white,
        ),
      ),
    );
  }

  // topUp now button
  Widget buildButton(context,
      {name, fontSize, fontWeight, fontColor, color, onPressed}) {
    return SizedBox(
      height: AppConstants.fortyTwo,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: radiusAll5(context),
            ),
          ),
        ),
        child: buildTextNew(
          text: name ?? '',
          fontWeight: FontWeight.w700,
          fontColor: fontColor,
        ),
        onPressed: onPressed ?? () {},
      ),
    );
  }

  // adding a new sender account
  Widget buildAddNewAccount(
      BuildContext context, WalletTopUpNowNotifier walletTopUpNowNotifier) {
    FundTransferNotifier fundNotifier =
        FundTransferNotifier(context, fundCountValue: 1, from: 'Wallet');
    ManageSenderNotifier notifier =
        ManageSenderNotifier(context, from: 'Wallet');
    bool isWalletPopUp = true;

    return GestureDetector(
      onTap: () async {
        await openBankNewAccountPopUp(context, fundNotifier, notifier,
            isWalletPopUp: isWalletPopUp);
        String sendCurrencyId = '59C3BBD2-5D26-4A47-8FC1-2EFA628049CE';

        await FundTransferRepository()
            .apiSenderAccountDetails(sendCurrencyId)
            .then((value) {
          List<GetSenderAccountDetails> response =
              value as List<GetSenderAccountDetails>;
          walletTopUpNowNotifier.itemCountData = response;
        });
      },
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: getScreenWidth(context) < 400
                    ? AppConstants.flexTwoData
                    : getScreenWidth(context) < 330
                        ? AppConstants.flexFiveData
                        : AppConstants.flexOneData,
                child: Container(
                  padding: px16DimenAll(context),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: containerBorderColor,
                      width: AppConstants.one,
                    ),
                    borderRadius: radiusAll10(context),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          S.of(context).addNewAccountNoBank,
                          style: tabBarTextStyle(context),
                        ),
                      ),
                      Icon(
                        AppCustomIcon.addRounded,
                        size: AppConstants.twentyFour,
                      ),
                    ],
                  ),
                ),
              ),
              getScreenWidth(context) < 540
                  ? SizedBox()
                  : sizedBoxWidth15(context),
              getScreenWidth(context) < 540
                  ? SizedBox()
                  : Expanded(
                      flex: AppConstants.flexOneData,
                      child: SizedBox(),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  // TopUp payNow function method
  buildTopUpViaPayNow(
      BuildContext context, WalletTopUpNowNotifier walletTopUpNowNotifier) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AppInActiveCheck(
        context: context,
        child: AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                width: getScreenWidth(context) < 750
                    ? getScreenWidth(context) * 0.8
                    : getScreenWidth(context) <= 1280
                        ? getScreenWidth(context) * 0.6
                        : getScreenWidth(context) * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: SingleChildScrollView(
                  controller: walletTopUpNowNotifier.scrollController,
                  child: Padding(
                    padding: px24DimenAll(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildTextNew(
                              text: S.of(context).topUpViaPayNow,
                              fontSize: getScreenWidth(context) <= 300
                                  ? AppConstants.fourteen
                                  : getScreenWidth(context) <= 345
                                      ? AppConstants.sixteen
                                      : getScreenWidth(context) <= 375
                                          ? AppConstants.twenty
                                          : AppConstants.twentyFour,
                              fontWeight: FontWeight.w700,
                              fontColor: oxfordBluelight,
                            ),
                            CloseButton(
                              onPressed: () {
                                MyApp.navigatorKey.currentState!.maybePop();
                              },
                            ),
                          ],
                        ),
                        sizedBoxHeight25(context),
                        buildTransactionCard(
                            context, walletTopUpNowNotifier, setState),
                        sizedBoxHeight25(context),
                        buildPayNowOption1Card(
                            context, walletTopUpNowNotifier, setState),
                        sizedBoxHeight25(context),
                        buildPayNowOption2Card(context),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // TopUp bank transfer method
  buildTopUpViaBankTransfer(
      BuildContext context, WalletTopUpNowNotifier walletTopUpNowNotifier) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AppInActiveCheck(
        context: context,
        child: AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                width: getScreenWidth(context) < 700
                    ? getScreenWidth(context) * 0.8
                    : getScreenWidth(context) < 1000
                        ? getScreenWidth(context) * 0.6
                        : getScreenWidth(context) * 0.48,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: SingleChildScrollView(
                  controller: walletTopUpNowNotifier.scrollController,
                  child: Padding(
                    padding: getScreenWidth(context) <= 300
                        ? px15HorizAnd24VertDimenAll(context)
                        : px24DimenAll(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                S.of(context).topUpViaBankTransfer,
                                style: TextStyle(
                                  fontSize: getScreenWidth(context) <= 400
                                      ? AppConstants.sixteen
                                      : getScreenWidth(context) <= 450
                                          ? AppConstants.twenty
                                          : AppConstants.twentyFour,
                                  fontWeight: FontWeight.w700,
                                  color: oxfordBluelight,
                                ),
                              ),
                            ),
                            CloseButton(
                              onPressed: () {
                                MyApp.navigatorKey.currentState!.maybePop();
                              },
                            )
                          ],
                        ),
                        sizedBoxHeight25(context),
                        Text.rich(
                          TextSpan(
                            text:
                                "Complete your Wallet Top up by transferring the Payment Amount to us now. Don’t forget to include the ",
                            style: TextStyle(
                              fontSize: AppConstants.sixteen,
                              color: exchangeRateHeadingcolor,
                            ),
                            children: [
                              TextSpan(
                                text: "reference number",
                                style: TextStyle(
                                  fontSize: AppConstants.sixteen,
                                  fontWeight: FontWeight.w700,
                                  color: exchangeRateHeadingcolor,
                                ),
                              ),
                              TextSpan(
                                text: " to avoid any delays!",
                                style: TextStyle(
                                  fontSize: AppConstants.sixteen,
                                  color: exchangeRateHeadingcolor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        sizedBoxHeight25(context),
                        buildTransactionCard(
                            context, walletTopUpNowNotifier, setState),
                        sizedBoxHeight25(context),
                        buildBankDetails(
                            context, walletTopUpNowNotifier, setState),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // bank transfer - bank details
  Widget buildBankDetails(BuildContext context,
      WalletTopUpNowNotifier walletTopUpNowNotifier, setState) {
    return Container(
      padding: getScreenWidth(context) <= 300
          ? px15HorizAnd24VertDimenAll(context)
          : px24DimenAll(context),
      decoration: tabBarChildContainerStyle2WithoutShadow(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: AppConstants.flexOneData,
                child: Text(
                  S.of(context).bankName,
                  style: TextStyle(
                    fontSize: AppConstants.sixteen,
                    color: oxfordBlueTint400,
                  ),
                ),
              ),
              Expanded(
                flex: getScreenWidth(context) < 1000
                    ? AppConstants.flexOneData
                    : getScreenWidth(context) < 1300
                        ? AppConstants.flexTwoData
                        : AppConstants.flexThreeData,
                child: Text(
                  walletTopUpNowNotifier.bankName,
                  style: TextStyle(
                    fontSize: AppConstants.sixteen,
                    color: black,
                  ),
                ),
              ),
            ],
          ),
          sizedBoxHeight15(context),
          Row(
            children: [
              Expanded(
                flex: AppConstants.flexOneData,
                child: Text(
                  S.of(context).accountName,
                  style: TextStyle(
                    fontSize: AppConstants.sixteen,
                    color: oxfordBlueTint400,
                  ),
                ),
              ),
              Expanded(
                flex: getScreenWidth(context) < 1000
                    ? AppConstants.flexOneData
                    : getScreenWidth(context) < 1300
                        ? AppConstants.flexTwoData
                        : AppConstants.flexThreeData,
                child: Text(
                  walletTopUpNowNotifier.acName,
                  style: TextStyle(
                    fontSize: AppConstants.sixteen,
                    color: black,
                  ),
                ),
              ),
            ],
          ),
          sizedBoxHeight15(context),
          Row(
            children: [
              Expanded(
                flex: AppConstants.flexOneData,
                child: Text(
                  S.of(context).accountNumber,
                  style: TextStyle(
                    fontSize: AppConstants.sixteen,
                    color: oxfordBlueTint400,
                  ),
                ),
              ),
              Expanded(
                flex: getScreenWidth(context) < 1000
                    ? AppConstants.flexOneData
                    : getScreenWidth(context) < 1300
                        ? AppConstants.flexTwoData
                        : AppConstants.flexThreeData,
                child: Text(
                  walletTopUpNowNotifier.acNumber,
                  style: TextStyle(
                    fontSize: AppConstants.sixteen,
                    color: black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // payment amount and transfer number card
  Widget buildTransactionCard(BuildContext context,
      WalletTopUpNowNotifier walletTopUpNowNotifier, setState) {
    return Container(
      padding: getScreenWidth(context) <= 300
          ? px15HorizAnd24VertDimenAll(context)
          : px24DimenAll(context),
      decoration: tabBarChildContainerStyle2(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getScreenWidth(context) <= 520
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).paymentAmountWeb,
                      style: TextStyle(
                        fontSize: AppConstants.sixteen,
                        color: oxfordBlueTint400,
                      ),
                    ),
                    Text(
                      "SGD ${walletTopUpNowNotifier.amountController.text}",
                      style: TextStyle(
                        fontSize: AppConstants.sixteen,
                        color: black,
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: AppConstants.flexOneData,
                      child: Text(
                        S.of(context).paymentAmountWeb,
                        style: TextStyle(
                          fontSize: AppConstants.sixteen,
                          color: oxfordBlueTint400,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: getScreenWidth(context) < 950
                          ? AppConstants.flexOneData
                          : getScreenWidth(context) < 1500
                              ? AppConstants.flexTwoData
                              : AppConstants.flexThreeData,
                      child: Text(
                        "SGD ${walletTopUpNowNotifier.amountController.text}",
                        style: TextStyle(
                          fontSize: AppConstants.sixteen,
                          color: black,
                        ),
                      ),
                    ),
                  ],
                ),
          sizedBoxHeight15(context),
          getScreenWidth(context) <= 520
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextNew(
                      text: S.of(context).referenceNumber,
                      fontSize: AppConstants.sixteen,
                      fontColor: oxfordBlueTint400,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            walletTopUpNowNotifier.referenceNumber,
                            style: TextStyle(
                              fontSize: AppConstants.sixteen,
                              color: black,
                            ),
                          ),
                        ),
                        sizedBoxWidth15(context),
                        Tooltip(
                          triggerMode: TooltipTriggerMode.tap,
                          key: walletTopUpNowNotifier.toolTipKey,
                          message: walletTopUpNowNotifier.copied == false
                              ? S.of(context).clickToCopy
                              : S.of(context).copiedText,
                          child: GestureDetector(
                            onTap: () {
                              setState(()  {
                                walletTopUpNowNotifier.copied = true;
                                 Clipboard.setData(
                                  ClipboardData(
                                      text: walletTopUpNowNotifier
                                          .referenceNumber),
                                );
                                final dynamic _toolTip = walletTopUpNowNotifier.toolTipKey.currentState;
                                _toolTip.ensureTooltipVisible();
                              });
                            },
                            child: MouseRegion(
                              cursor: MaterialStateMouseCursor.clickable,
                              child: Image.asset(
                                AppImages.copyImage,
                                height: AppConstants.sixteen,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: AppConstants.flexOneData,
                      child: buildTextNew(
                        text: S.of(context).referenceNumber,
                        fontSize: AppConstants.sixteen,
                        fontColor: oxfordBlueTint400,
                      ),
                    ),
                    Expanded(
                      flex: getScreenWidth(context) < 950
                          ? AppConstants.flexOneData
                          : getScreenWidth(context) < 1500
                              ? AppConstants.flexTwoData
                              : AppConstants.flexThreeData,
                      child: Row(
                        children: [
                          Text(
                            walletTopUpNowNotifier.referenceNumber,
                            style: TextStyle(
                              fontSize: AppConstants.sixteen,
                              color: black,
                            ),
                          ),
                          sizedBoxWidth15(context),
                          Tooltip(
                            triggerMode: TooltipTriggerMode.tap,
                            key: walletTopUpNowNotifier.toolTipKey,
                            message: walletTopUpNowNotifier.copied == false
                                ? S.of(context).clickToCopy
                                : S.of(context).copiedText,
                            child: GestureDetector(
                              onTap: () {
                                setState(()  {
                                  walletTopUpNowNotifier.copied = true;
                                  Clipboard.setData(
                                    ClipboardData(
                                        text: walletTopUpNowNotifier
                                            .referenceNumber),
                                  );
                                  final dynamic _toolTip = walletTopUpNowNotifier.toolTipKey.currentState;
                                  _toolTip.ensureTooltipVisible();
                                });
                              },
                              child: MouseRegion(
                                cursor: MaterialStateMouseCursor.clickable,
                                child: Image.asset(
                                  AppImages.copyImage,
                                  height: AppConstants.sixteen,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  // payNow option 1 QR code
  Widget buildPayNowOption1Card(BuildContext context,
      WalletTopUpNowNotifier walletTopUpNowNotifier, setState) {
    return Container(
      padding: getScreenWidth(context) <= 300
          ? px15HorizAnd24VertDimenAll(context)
          : px24DimenAll(context),
      decoration: tabBarChildContainerStyle2WithoutShadow(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTextNew(
            text: S.of(context).option1,
            fontWeight: FontWeight.w700,
            fontSize: AppConstants.sixteen,
            fontColor: orangePantone,
          ),
          sizedBoxHeight10(context),
          buildTextNew(
            text: S.of(context).PayNowQRCodeWithDash,
            fontWeight: FontWeight.w700,
            fontSize: AppConstants.twenty,
            fontColor: oxfordBlue,
          ),
          sizedBoxHeight25(context),
          getScreenWidth(context) > 700
              ? qrCodeRow(context, walletTopUpNowNotifier)
              : qrCodeColumn(context, walletTopUpNowNotifier),
        ],
      ),
    );
  }

  // qr code for web
  Widget qrCodeRow(
      BuildContext context, WalletTopUpNowNotifier walletTopUpNowNotifier) {
    return Row(
      children: [
        Container(
          height: AppConstants.oneHundredFifty,
          width: AppConstants.oneHundredFifty,
          decoration: BoxDecoration(
            color: dividercolor,
            borderRadius: radiusAll5(context),
          ),
          child: Center(
              child: Image.memory(
            base64.decode(walletTopUpNowNotifier.payNowQR),
            fit: BoxFit.fill,
          )),
        ),
        sizedBoxWidth15(context),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).openYourMobileBanking,
                style: TextStyle(
                  fontSize: AppConstants.sixteen,
                ),
              ),
              sizedBoxHeight15(context),
              Text(
                S.of(context).allTransferDetails,
                style: TextStyle(
                  fontSize: AppConstants.sixteen,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // qr code for mobile
  Widget qrCodeColumn(
      BuildContext context, WalletTopUpNowNotifier walletTopUpNowNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: AppConstants.oneHundredFifty,
          width: AppConstants.oneHundredFifty,
          padding: px23HorizontalDimen(context),
          decoration: BoxDecoration(
            color: dividercolor,
            borderRadius: radiusAll5(context),
          ),
          child: Center(
            child: Image.memory(base64.decode(walletTopUpNowNotifier.payNowQR)),
          ),
        ),
        sizedBoxHeight25(context),
        Text(
          S.of(context).openYourMobileBanking,
          style: TextStyle(
            fontSize: AppConstants.sixteen,
          ),
        ),
        sizedBoxHeight15(context),
        Text(
          S.of(context).allTransferDetails,
          style: TextStyle(
            fontSize: AppConstants.sixteen,
          ),
        ),
      ],
    );
  }

  // payNow option 2 UEN number
  Widget buildPayNowOption2Card(BuildContext context) {
    return Container(
      padding: getScreenWidth(context) <= 300
          ? px15HorizAnd24VertDimenAll(context)
          : px24DimenAll(context),
      decoration: tabBarChildContainerStyle2WithoutShadow(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTextNew(
            text: S.of(context).option2,
            fontWeight: FontWeight.w700,
            fontSize: AppConstants.sixteen,
            fontColor: orangePantone,
          ),
          sizedBoxHeight10(context),
          buildTextNew(
            text: S.of(context).PayNowUEN,
            fontWeight: FontWeight.w700,
            fontSize: AppConstants.twenty,
            fontColor: oxfordBlue,
          ),
          sizedBoxHeight25(context),
          Text.rich(
            TextSpan(
              text: "Login to your online banking app to use ",
              style: TextStyle(
                fontSize: AppConstants.sixteen,
                color: exchangeRateHeadingcolor,
              ),
              children: [
                TextSpan(
                  text: "PayNow",
                  style: TextStyle(
                    fontSize: AppConstants.sixteen,
                    fontWeight: FontWeight.w700,
                    color: exchangeRateHeadingcolor,
                  ),
                ),
                TextSpan(
                  text: ". Don't forget to include your ",
                  style: TextStyle(
                    fontSize: AppConstants.sixteen,
                    color: exchangeRateHeadingcolor,
                  ),
                ),
                TextSpan(
                  text: "reference number",
                  style: TextStyle(
                    fontSize: AppConstants.sixteen,
                    fontWeight: FontWeight.w700,
                    color: exchangeRateHeadingcolor,
                  ),
                ),
                TextSpan(
                  text: " or your top up may be delayed.",
                  style: TextStyle(
                    fontSize: AppConstants.sixteen,
                    color: exchangeRateHeadingcolor,
                  ),
                ),
              ],
            ),
          ),
          sizedBoxHeight15(context),
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: px24DimenHorizontaland16Vertical(context),
              decoration: BoxDecoration(
                borderRadius: radiusAll5(context),
                border: Border.all(
                  color: dividercolor,
                  width: AppConstants.one,
                ),
              ),
              child: getScreenWidth(context) <= 520
                  ? Column(
                      children: [
                        buildUENNumber(context),
                        sizedBoxHeight10(context),
                        buildWalletCode(context)
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: buildUENNumber(context),
                        ),
                        Expanded(
                            flex: getScreenWidth(context) < 1000 ? 1 : 3,
                            child: buildWalletCode(context)),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // UEN number
  Widget buildUENNumber(BuildContext context) {
    return buildTextNew(
      text: S.of(context).uenNumber,
      fontSize: AppConstants.sixteen,
      fontColor: oxfordBlueTint400,
    );
  }

  // wallet number
  Widget buildWalletCode(BuildContext context) {
    return buildTextNew(
      text: AppConstants.walletCode,
      fontSize: AppConstants.sixteen,
      fontColor: black,
    );
  }

  buildTextNew(
      {text,
      double fontSize = 14,
      fontWeight = FontWeight.w500,
      fontColor,
      maxLines,
      ellipses,
      decoration}) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: ellipses == true ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: fontColor ?? black,
        decoration: decoration,
      ),
    );
  }
}
