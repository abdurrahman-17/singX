import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/service/sg_bill_pay_repository.dart';
import 'package:singx/core/data/remote/service/sg_wallet_repository.dart';
import 'package:singx/core/models/request_response/common_response.dart';
import 'package:singx/core/models/request_response/login/login_response.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/pricing_request.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/pricing_response.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/sg_bill_operator_list_by_id.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/sg_bill_operator_list_response.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/sg_bill_save_request.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/sg_bill_save_response.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/transaction_history_response.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/view_bill_request.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/view_bill_response.dart';
import 'package:singx/core/models/request_response/sg_wallet/sg_wallet_response.dart';
import 'package:singx/core/models/request_response/sg_wallet/wallet_debit_request.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/main.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_font.dart';
import 'package:singx/utils/common/app_images.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/page_scaffold/page_scaffold.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';
import '../../core/notifier/india_bill_payment_notifier.dart';

class IndiaBillPayment extends StatelessWidget {
  final bool? navigateData;

  IndiaBillPayment({Key? key, this.navigateData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    userCheck(context);
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          IndiaBillPaymentNotifier(context, navigateData!),
      child: Consumer<IndiaBillPaymentNotifier>(
        builder: (context, indiaBillPaymentNotifier, _) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            indiaBillPaymentNotifier.isIndiaBillPayment = navigateData!;
          });
          return indiaBillPaymentNotifier.isIndiaBillPayment

              // Transaction history and billing category
              ? PageScaffold(
                  scrollController: indiaBillPaymentNotifier.scrollController2,
                  color: bankDetailsBackground,
                  appbar: buildAppBarWithDrawer(
                      context,
                      IgnorePointer(
                        ignoring: (getScreenWidth(context) > 500),
                        child: Tooltip(
                          triggerMode: TooltipTriggerMode.tap,
                          message: S.of(context).indiaBillPayment,
                          child: Text(
                            S.of(context).indiaBillPayment,
                            overflow: TextOverflow.clip,
                            style: appBarWelcomeText(context),
                          ),
                        ),
                      ),
                      indiaBillPaymentNotifier),
                  title: S.of(context).indiaBillPayment,
                  body: indiaBillPaymentNotifier.showLoadingIndicator
                      ? Center(
                          child: SingleChildScrollView(
                              controller:
                                  indiaBillPaymentNotifier.scrollController2,
                              child: defaultTargetPlatform == TargetPlatform.iOS
                                  ? CupertinoActivityIndicator(radius: 30)
                                  : CircularProgressIndicator(strokeWidth: 3)),
                        )
                      : SingleChildScrollView(
                          controller:
                              indiaBillPaymentNotifier.scrollController2,
                          child: GestureDetector(
                            onTap: () =>
                                FocusManager.instance.primaryFocus!.unfocus(),
                            child: Padding(
                              padding: px20DimenAll(context),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: px10OnlyRight(context),
                                    child: Text(
                                      S.of(context).selectYourBillingCategory,
                                      style:
                                          appBarWelcomeText(context).copyWith(
                                        fontSize: AppConstants.fourteen,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: px10OnlyTop(context),
                                    padding: px5Top10Right5Bottom(context),
                                    height: kIsWeb
                                        ? getScreenWidth(context) <= 370
                                            ? AppConstants.sixty
                                            : AppConstants.fortyThree
                                        : screenSizeWidth <= 370
                                            ? AppConstants.sixty
                                            : AppConstants.fortyThree,
                                    child: horizontalListBillCategory(
                                        context: context,
                                        isTitle: true,
                                        indiaBillPaymentNotifier:
                                            indiaBillPaymentNotifier,
                                        controller: indiaBillPaymentNotifier
                                            .scrollController),
                                  ),
                                  Container(
                                    padding: px20TopAnd10Right(context),
                                    height: AppConstants.oneHundredAndTen,
                                    child: horizontalListBillCategory(
                                        context: context,
                                        isTitle: false,
                                        indiaBillPaymentNotifier:
                                            indiaBillPaymentNotifier,
                                        controller: indiaBillPaymentNotifier
                                            .scrollController1,
                                        bottom: 12),
                                  ),
                                  sizedBoxHeight10(context),
                                  Container(
                                    padding: px5Top(context),
                                    child: Container(
                                      decoration:
                                          tabBarChildContainerStyle2(context),
                                      padding: px15DimenAll(context),
                                      width: kIsWeb
                                          ? getScreenWidth(context)
                                          : screenSizeWidth,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          kIsWeb
                                              ? getScreenWidth(context) > 800
                                                  ? buildTableGreaterThan800(context,
                                                      indiaBillPaymentNotifier)
                                                  : (getScreenWidth(
                                                                  context) >
                                                              701 &&
                                                          getScreenWidth(
                                                                  context) <=
                                                              800)
                                                      ? buildTableBetween700T0800(
                                                          context,
                                                          indiaBillPaymentNotifier)
                                                      : buildTableLessThan800(context,
                                                          indiaBillPaymentNotifier)
                                              : screenSizeWidth > 800
                                                  ? buildTableGreaterThan800(
                                                      context,
                                                      indiaBillPaymentNotifier)
                                                  : (screenSizeWidth >
                                                              701 &&
                                                          screenSizeWidth <=
                                                              800)
                                                      ? buildTableBetween700T0800(
                                                          context,
                                                          indiaBillPaymentNotifier)
                                                      : buildTableLessThan800(
                                                          context,
                                                          indiaBillPaymentNotifier),
                                          sizedBoxHeight30(context),
                                          Container(
                                              height: kIsWeb
                                                  ? getScreenHeight(context) *
                                                      0.45
                                                  : screenSizeHeight * 0.45,
                                              child: buildPaymentTable(
                                                  indiaBillPaymentNotifier,
                                                  context)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  sizedBoxHeight30(context),
                                ],
                              ),
                            ),
                          ),
                        ),
                )
              // New bill payment screen
              : newBillPaymentView(indiaBillPaymentNotifier, context);
        },
      ),
    );
  }

  // Transaction history Table below 800 width
  Widget buildTableLessThan800(BuildContext context, IndiaBillPaymentNotifier indiaBillPaymentNotifier) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSearchField(indiaBillPaymentNotifier, context),
        sizedBoxHeight15(context),
        buildDateField(indiaBillPaymentNotifier, context),
        sizedBoxHeight15(context),
        buildStatusDropDownBox(context, indiaBillPaymentNotifier),
      ],
    );
  }

  // Transaction history Table between 700 and 800 width
  Widget buildTableBetween700T0800(BuildContext context, IndiaBillPaymentNotifier indiaBillPaymentNotifier) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSearchField(indiaBillPaymentNotifier, context),
        sizedBoxHeight15(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: AppConstants.flexOneData,
              child: buildDateField(indiaBillPaymentNotifier, context),
            ),
            sizedBoxWidth15(context),
            Expanded(
              flex: AppConstants.flexOneData,
              child: buildStatusDropDownBox(context, indiaBillPaymentNotifier),
            ),
          ],
        ),
      ],
    );
  }

  // Transaction history Table above 800 width
  Widget buildTableGreaterThan800(BuildContext context, IndiaBillPaymentNotifier indiaBillPaymentNotifier) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: AppConstants.flexTwoData,
          child: buildSearchField(indiaBillPaymentNotifier, context),
        ),
        kIsWeb ?
        getScreenWidth(context) <= 1210 &&
            getScreenWidth(context) >=
                1060
            ? sizedBoxWidth15(context)
            : Spacer() :
        screenSizeWidth <= 1210 &&
            screenSizeWidth >=
                1060
            ? sizedBoxWidth15(context)
            : Spacer(),
        buildDateField(indiaBillPaymentNotifier, context),
        sizedBoxWidth15(context),
        buildStatusDropDownBox(context, indiaBillPaymentNotifier),
      ],
    );
  }

  // AppBar
  Widget buildAppBarWithDrawer(BuildContext context, Widget frontWidget, IndiaBillPaymentNotifier indiaBillPaymentNotifier) {

    return PreferredSize(
      preferredSize: Size.fromHeight(AppConstants.appBarHeight),
      child: Padding(
        padding: kIsWeb ? isMobile(context) || isTab(context)
            ? px15DimenTop(context)
            : px30DimenTopOnly(context) : isMobileSDK(context) || isTabSDK(context)
            ? px15DimenTop(context)
            : px30DimenTopOnly(context),
        child: buildAppBar(context, frontWidget,
            backCondition: indiaBillPaymentNotifier.isIndiaBillPayment == true
                ? null
                : () {
              MyApp.navigatorKey.currentState!.maybePop();
            }),
      ),
    );
  }

  // Bill Payment Ui Design
  Widget newBillPaymentView(IndiaBillPaymentNotifier indiaBillPaymentNotifier, BuildContext context) {
    var text = kIsWeb ? getScreenWidth(context) > 435 ?  S.of(context).OrNewBillPayment : '\n' + S.of(context).OrNewBillPayment : screenSizeWidth > 435 ?  S.of(context).OrNewBillPayment : '\n' + S.of(context).OrNewBillPayment;
    return PageScaffold(
        color: bankDetailsBackground,
        appbar: buildAppBarWithDrawer(
          context,
               Tooltip(
                 message: S.of(context).indiaBillPaymentOr + text,
                 child: Text.rich(overflow: TextOverflow.clip,
            TextSpan(
              recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    MyApp.navigatorKey.currentState!.maybePop();
                  },
              text: S.of(context).indiaBillPaymentOr,
              style: appBarWelcomeText(context).copyWith(
                    color: oxfordBlueTint400,
                    fontSize: kIsWeb ? isMobile(context) ? getScreenWidth(context)<300?12:getScreenWidth(context)<330?14:16 : 16 : isMobileSDK(context) ? getScreenWidth(context)<300?12:getScreenWidth(context)<330?14:16 : 16),
              children: <TextSpan>[
                  TextSpan(
                    text: text,
                    style: appBarWelcomeText(context).copyWith(
                        color: oxfordBlueTint400,
                        fontSize: kIsWeb ? isMobile(context) ? getScreenWidth(context)<300?12:getScreenWidth(context)<330?14:16 : 16: isMobileSDK(context) ? getScreenWidth(context)<300?12:getScreenWidth(context)<330?14:16 : 16),
                  ),
              ],
            ),
          ),
               ),
          indiaBillPaymentNotifier,
        ),
        title: S.of(context).indiaBillPaymentOrNewBillPayment,
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: Container(
            padding: px20DimenAll(context),
            child: SingleChildScrollView(
              primary: true,
              child: Form(
                key: indiaBillPaymentNotifier.formKey,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            !indiaBillPaymentNotifier.isBillPaymentPreview
                                ? S.of(context).newBillPayment
                                : S.of(context).billPayment,
                            style: appBarWelcomeText(context),
                          ),
                        ],
                      ),
                      sizedBoxHeight15(context),
                      Divider(),
                      Container(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: kIsWeb
                                      ? isMobile(context)
                                          ? getScreenWidth(context) * 0.1
                                          : isTab(context)
                                              ? getScreenWidth(context) * 0.2
                                              : getScreenWidth(context) < 1060
                                                  ? getScreenWidth(context) *
                                                      0.3
                                                  : getScreenWidth(context) *
                                                      0.18
                                      : isMobileSDK(context)
                                          ? screenSizeWidth * 0.1
                                          : isTabSDK(context)
                                              ? screenSizeWidth * 0.2
                                              : screenSizeWidth < 1060
                                                  ? screenSizeWidth * 0.3
                                                  : screenSizeWidth * 0.18),
                            child: indiaBillPaymentNotifier
                                .isBillPaymentPreview ||
                                indiaBillPaymentNotifier
                                    .isIndiaBillPaymentSuccess

                                // Bill Payment Success Ui Design
                                ? buildSuccessUi(context, indiaBillPaymentNotifier)

                                // Bill Payment TextFields
                                : buildBillPaymentTextField(context, indiaBillPaymentNotifier)
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  // Bill Payment Success Ui Design
  Widget buildSuccessUi(BuildContext context, IndiaBillPaymentNotifier indiaBillPaymentNotifier) {
    return Column(
      children: [
        Visibility(
            visible: indiaBillPaymentNotifier.isIndiaBillPaymentSuccess,
            child: Column(
              children: [
                sizedBoxHeight20(context),
                buildText(
                    text: AppConstants.successPaymentWallet,
                    fontColor: lightblack,
                    fontSize: AppConstants.sixteen),
                sizedBoxHeight20(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: buildText(
                        text: S.of(context).paymentAmount,
                        fontColor: black,
                        fontSize: AppConstants.eighteen,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: buildText(
                        text:
                            "SGD ${indiaBillPaymentNotifier.viewBillData.data![0].billAmount}",
                        fontColor: black,
                        fontSize: AppConstants.eighty,
                      ),
                    ),
                  ],
                ),
                sizedBoxHeight10(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: buildText(
                        text: S.of(context).referenceNumber,
                        fontColor: black,
                        fontSize: AppConstants.eighteen,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Flexible(
                            child: buildText(
                              text: indiaBillPaymentNotifier.referenceNumber,
                              fontColor: black,
                              fontSize: AppConstants.eighteen,
                            ),
                          ),
                          sizedBoxWidth5(context),
                          Tooltip(
                            message:
                                indiaBillPaymentNotifier.referenceCopied == true
                                    ? "Copied"
                                    : S.of(context).clickToCopy,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () async {
                                  indiaBillPaymentNotifier.referenceCopied =
                                      true;
                                  await Clipboard.setData(
                                    ClipboardData(
                                        text: indiaBillPaymentNotifier
                                            .referenceNumber),
                                  );
                                },
                                child: Image.asset(
                                  AppImages.documentCopy,
                                  height: AppConstants.fifteen,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            )),
        sizedBoxHeight10(context),
        Container(
          decoration: BoxDecoration(
            color: white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                color: orangePantoneTint200,
                child: buildText(
                  text: S.of(context).reviewBillDetails,
                  fontColor: black,
                  fontWeight: AppFont.fontWeightBold,
                  fontSize: AppConstants.eighteen,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    sizedBoxHeight15(context),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildText(
                          text: S.of(context).billingCategory,
                          fontColor: lightblack,
                          fontSize: AppConstants.fifteen,
                        ),
                        buildText(
                          text: indiaBillPaymentNotifier
                              .billingCategoryController.text,
                          fontColor: lightblack,
                          fontSize: AppConstants.fifteen,
                        ),
                      ],
                    ),
                    sizedBoxHeight10(context),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildText(
                          text: S.of(context).operatorName,
                          fontColor: lightblack,
                          fontSize: AppConstants.fifteen,
                        ),
                        buildText(
                          text: indiaBillPaymentNotifier
                              .billingOperatorController.text,
                          fontColor: lightblack,
                          fontSize: AppConstants.fifteen,
                        ),
                      ],
                    ),
                    sizedBoxHeight10(context),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: buildText(
                            text: S.of(context).consumerNumber,
                            fontColor: lightblack,
                            fontSize: AppConstants.fifteen,
                          ),
                        ),
                        Flexible(
                          child: buildText(
                            text: indiaBillPaymentNotifier
                                .consumerController.text,
                            fontColor: lightblack,
                            fontSize: AppConstants.fifteen,
                          ),
                        ),
                      ],
                    ),
                    indiaBillPaymentNotifier.isIndiaBillPaymentSuccess == true
                        ? SizedBox()
                        : sizedBoxHeight10(context),
                    indiaBillPaymentNotifier.isIndiaBillPaymentSuccess == true
                        ? SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: buildText(
                                  text: S.of(context).amountDue,
                                  fontColor: lightblack,
                                  fontSize: AppConstants.fifteen,
                                ),
                              ),
                              Flexible(
                                child: buildText(
                                  text:
                                      "INR ${indiaBillPaymentNotifier.viewBillData.data![0].billAmount}",
                                  fontColor: lightblack,
                                  fontSize: AppConstants.fifteen,
                                ),
                              ),
                            ],
                          ),
                    sizedBoxHeight10(context),
                    indiaBillPaymentNotifier.viewBillData.data![0].billAmount !=
                            "0.0"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: buildText(
                                  text: indiaBillPaymentNotifier
                                              .isIndiaBillPaymentSuccess ==
                                          true
                                      ? "Total Paid:"
                                      : S.of(context).amountPayable,
                                  fontColor: orangePantone,
                                  fontSize: AppConstants.fifteen,
                                ),
                              ),
                              Flexible(
                                child: buildText(
                                  text:
                                      "SGD ${double.parse(indiaBillPaymentNotifier.pricingData.billForWallet.toString()).toStringAsFixed(3)}",
                                  fontColor: orangePantone,
                                  fontSize: AppConstants.fifteen,
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
              )
            ],
          ),
        ),
        indiaBillPaymentNotifier.viewBillData.data![0].billAmount != "0.0" &&
                !indiaBillPaymentNotifier.isIndiaBillPaymentSuccess
            ? sizedBoxHeight20(context)
            : SizedBox(),
        indiaBillPaymentNotifier.viewBillData.data![0].billAmount != "0.0" &&
                !indiaBillPaymentNotifier.isIndiaBillPaymentSuccess
            ? Container(
                decoration: BoxDecoration(
                  color: white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppConstants.ten),
                      width: double.infinity,
                      color: orangePantoneTint200,
                      child: buildText(
                        text: S.of(context).paymentOptions,
                        fontColor: black,
                        fontWeight: AppFont.fontWeightBold,
                        fontSize: AppConstants.eighteen,
                      ),
                    ),
                    Padding(
                      padding: getScreenWidth(context) < 410
                          ? EdgeInsets.all(AppConstants.zero)
                          : EdgeInsets.all(AppConstants.ten),
                      child: Column(
                        children: [
                          sizedBoxHeight15(context),
                          kIsWeb
                              ? getScreenWidth(context) < 410
                                  ? buildBalanceAndButtonLessThan410(
                                      context, indiaBillPaymentNotifier)
                                  : buildBalanceAndButtonGreaterThan410(
                                      context, indiaBillPaymentNotifier)
                              : screenSizeWidth < 410
                                  ? buildBalanceAndButtonLessThan410(
                                      context, indiaBillPaymentNotifier)
                                  : buildBalanceAndButtonGreaterThan410(
                                      context, indiaBillPaymentNotifier),
                          sizedBoxHeight10(context),
                        ],
                      ),
                    )
                  ],
                ),
              )
            : SizedBox(),
        sizedBoxHeight10(context),
        Visibility(
            visible: indiaBillPaymentNotifier.walletBalanceErrorMsg.isNotEmpty,
            child: buildText(
                text: indiaBillPaymentNotifier.walletBalanceErrorMsg,
                fontColor: error)),
        Align(
            alignment: Alignment.centerLeft,
            child: buildButton(context, onPressed: () {
              MyApp.navigatorKey.currentState!.maybePop();
            },
                name: S.of(context).back,
                color: hanBlueshades600,
                fontColor: white,
                width: AppConstants.eighty))
      ],
    );
  }

  Widget buildBalanceAndButtonLessThan410(BuildContext context, IndiaBillPaymentNotifier indiaBillPaymentNotifier) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: buildText(
            text:
            "${S.of(context).singXWallet} \n(Balance SGD ${indiaBillPaymentNotifier.walletBal})",
            fontColor: lightblack,
            fontSize: AppConstants.fifteen,
          ),
        ),
        sizedBoxHeight10(context),
        Center(
          child: buildProceedButton(context,indiaBillPaymentNotifier)
        )
      ],
    );
  }

  Widget buildBalanceAndButtonGreaterThan410(BuildContext context, IndiaBillPaymentNotifier indiaBillPaymentNotifier) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        buildText(
          text:
          "${S.of(context).singXWallet} \n(Balance SGD ${indiaBillPaymentNotifier.walletBal})",
          fontColor: lightblack,
          fontSize: AppConstants.fifteen,
        ),
        buildProceedButton(context,indiaBillPaymentNotifier)
      ],
    );
  }

  // proceed button for bill payment
  Widget buildProceedButton(BuildContext context, IndiaBillPaymentNotifier indiaBillPaymentNotifier) {
    return buildButton(
      context,
      onPressed: () async {
        SGWalletRepository()
            .SGWalletBalance(context)
            .then((value) async {
          SgWalletBalance sgWalletBalance =
          value as SgWalletBalance;
          if (double.parse(
              sgWalletBalance.balance!) >
              double.parse(
                  indiaBillPaymentNotifier
                      .pricingData
                      .billForWallet!)) {
            await SharedPreferencesMobileWeb
                .instance
                .getUserData(AppConstants.user)
                .then((value) async {
              LoginResponse loginResponse =
              loginResponseFromJson(value);
              await SGBillPayRepository()
                  .SGBillSave(BillSaveRequest(
                adParam1: indiaBillPaymentNotifier
                    .adField1Controller
                    .text
                    .isEmpty
                    ? "NA"
                    : indiaBillPaymentNotifier
                    .adField1Controller
                    .text,
                adParam2: indiaBillPaymentNotifier
                    .adField2Controller
                    .text
                    .isEmpty
                    ? "NA"
                    : indiaBillPaymentNotifier
                    .adField2Controller
                    .text,
                adParam3: indiaBillPaymentNotifier
                    .adField3Controller
                    .text
                    .isEmpty
                    ? "NA"
                    : indiaBillPaymentNotifier
                    .adField3Controller
                    .text,
                paymentType: "wallet",
                billpayresponse: jsonEncode(
                    indiaBillPaymentNotifier
                        .viewBillData),
                consumerno:
                indiaBillPaymentNotifier
                    .consumerController
                    .text,
                corridorId:
                indiaBillPaymentNotifier
                    .pricingData.corridorId,
                countryId: "1000002",
                customerbankId: "0",
                fee: (double.parse(
                    indiaBillPaymentNotifier
                        .pricingData
                        .billForWallet
                        .toString()) -
                    double.parse(
                        indiaBillPaymentNotifier
                            .pricingData
                            .billWithoutFee!))
                    .toString(),
                operatorid:
                indiaBillPaymentNotifier
                    .operatorID,
                receiveamount:
                indiaBillPaymentNotifier
                    .viewBillData
                    .data![0]
                    .billAmount,
                sendamount:
                indiaBillPaymentNotifier
                    .pricingData
                    .billWithoutFee,
                totalPayable:
                indiaBillPaymentNotifier
                    .pricingData
                    .billForWallet,
                userId: loginResponse
                    .userinfo!.contactId,
              ))
                  .then((value) async {
                BillSaveResponse
                billSaveResponse =
                value as BillSaveResponse;
                if (billSaveResponse.status ==
                    "Success") {
                  indiaBillPaymentNotifier
                      .referenceNumber =
                  billSaveResponse
                      .userTxnid!;
                  await SGWalletRepository()
                      .SGWalletDebit(
                      context,
                      WalletDebitRequest(
                          contactId:
                          loginResponse
                              .userinfo!
                              .contactId,
                          countrycode: "sg",
                          currencyCode:
                          "SGD",
                          endbal: double.parse(indiaBillPaymentNotifier.walletBal) -
                              double.parse(indiaBillPaymentNotifier
                                  .pricingData
                                  .billForWallet
                                  .toString()),
                          exchangeRate: 0,
                          paymentType:
                          "Wallet",
                          productTxnId:
                          billSaveResponse
                              .userTxnid,
                          sendAmount: indiaBillPaymentNotifier
                              .pricingData
                              .billWithoutFee,
                          senderId: "0",
                          startbal: double.parse(
                              indiaBillPaymentNotifier
                                  .walletBal),
                          totalPayable:
                          indiaBillPaymentNotifier
                              .pricingData
                              .billForWallet,
                          transactionFee:
                          (double.parse(indiaBillPaymentNotifier.pricingData.billWithoutFee!) - double.parse(indiaBillPaymentNotifier.pricingData.billForWallet.toString()))
                              .toString(),
                          transactionType: "Debit"))
                      .then((value) async {
                    CommonResponse
                    commonResponse =
                    value as CommonResponse;
                    if (commonResponse
                        .success ==
                        true) {
                      indiaBillPaymentNotifier
                          .isIndiaBillPaymentSuccess =
                      true;
                    }
                  });
                }
              });
            });
            indiaBillPaymentNotifier
                .isIndiaBillPaymentSuccess =
            true;
          } else {
            indiaBillPaymentNotifier
                .walletBalanceErrorMsg =
            'Insufficient wallet balance';
          }
        });
      },
      name: S.of(context).proceed,
      color: hanBlueshades600,
      fontColor: white,
      fontSize: getScreenWidth(context) < 940
          ? AppConstants.fourteen
          : null,
      width: AppConstants.hundred,
    );
  }

  // Bill Payment TextFields
  Widget buildBillPaymentTextField(BuildContext context, IndiaBillPaymentNotifier indiaBillPaymentNotifier) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sizedBoxHeight20(context),
        buildRecipientText(context),
        sizedBoxHeight10(context),
        buildRecipientField(context),
        sizedBoxHeight20(context),
        buildBillingCategoryText(context),
        sizedBoxHeight10(context),
        buildBillingCategoryDropDownBox(context, indiaBillPaymentNotifier),
        sizedBoxHeight20(context),
        Visibility(
            visible: indiaBillPaymentNotifier.operatorFieldVisible,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildOperatorNameText(context),
                sizedBoxHeight10(context),
                buildOperatorNameDropDownBox(context,
                    isPopUp: false,
                    indiaBillPaymentNotifier: indiaBillPaymentNotifier),
                Visibility(
                    visible: indiaBillPaymentNotifier.fieldVisible,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sizedBoxHeight20(context),
                        buildConsumerNumberText(
                            context, indiaBillPaymentNotifier),
                        sizedBoxHeight10(context),
                        buildConsumerNumberField(
                            context, indiaBillPaymentNotifier),
                      ],
                    ))
              ],
            )),
        Visibility(
            visible: indiaBillPaymentNotifier.additionalField1.isNotEmpty,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sizedBoxHeight20(context),
                buildAdditionalFieldTitle(context, indiaBillPaymentNotifier,
                    indiaBillPaymentNotifier.additionalField1),
                sizedBoxHeight10(context),
                buildADField(context, indiaBillPaymentNotifier,
                    hintText: indiaBillPaymentNotifier.additionalField1,
                    controller: indiaBillPaymentNotifier.adField1Controller),
                sizedBoxHeight20(context)
              ],
            )),
        Visibility(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAdditionalFieldTitle(context, indiaBillPaymentNotifier,
                    indiaBillPaymentNotifier.additionalField2),
                sizedBoxHeight10(context),
                buildADField(context, indiaBillPaymentNotifier,
                    hintText: indiaBillPaymentNotifier.additionalField2,
                    controller: indiaBillPaymentNotifier.adField2Controller),
                sizedBoxHeight20(context)
              ],
            ),
            visible: indiaBillPaymentNotifier.additionalField2.isNotEmpty),
        Visibility(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAdditionalFieldTitle(context, indiaBillPaymentNotifier,
                    indiaBillPaymentNotifier.additionalField3),
                sizedBoxHeight10(context),
                buildADField(context, indiaBillPaymentNotifier,
                    hintText: indiaBillPaymentNotifier.additionalField3,
                    controller: indiaBillPaymentNotifier.adField3Controller)
              ],
            ),
            visible: indiaBillPaymentNotifier.additionalField3.isNotEmpty),
        sizedBoxHeight10(context),
        indiaBillPaymentNotifier.errorData.isNotEmpty
            ? Text(
                indiaBillPaymentNotifier.errorData,
                style: TextStyle(color: errorTextField,
                    fontSize: 11.5,fontWeight: FontWeight.w500),
              )
            : SizedBox(),
        sizedBoxHeight20(context),
        Row(
          children: [
            Expanded(
              child: buildButton(
                context,
                height: AppConstants.forty,
                color: hanBlueTint200,
                fontColor: hanBlue,
                fontSize: kIsWeb ? getScreenWidth(context) < 300
                    ? AppConstants.ten
                    : getScreenWidth(context) < 335
                        ? AppConstants.fourteen
                        : AppConstants.sixteen :  screenSizeWidth < 300
                    ? AppConstants.ten
                    : screenSizeWidth < 335
                    ? AppConstants.fourteen
                    : AppConstants.sixteen,
                name: S.of(context).cancel,
                onPressed: () {
                  MyApp.navigatorKey.currentState!.maybePop();
                },
              ),
            ),
            commonSizedBoxWidth40(context),
            Expanded(
              child: buildButton(context,
                  height: AppConstants.fortyTwo,
                  color: hanBlue,
                  fontColor: white,
                  fontSize: kIsWeb ? getScreenWidth(context) < 300
                      ? AppConstants.ten
                      : getScreenWidth(context) < 335
                          ? AppConstants.twelve
                          : AppConstants.sixteen :  screenSizeWidth < 300
                      ? AppConstants.ten
                      : screenSizeWidth < 335
                      ? AppConstants.fourteen
                      : AppConstants.sixteen,
                  name: S.of(context).proceed, onPressed: () async {
                if (indiaBillPaymentNotifier.formKey.currentState!.validate()) {
                  await SGBillPayRepository()
                      .SGViewBill(ViewBillRequest(
                    consumerNo:
                        indiaBillPaymentNotifier.consumerController.text,
                    circleId: 0,
                    operatorId: indiaBillPaymentNotifier.selectedOperatorID,
                    adParam1: indiaBillPaymentNotifier
                            .adField1Controller.text.isNotEmpty
                        ? indiaBillPaymentNotifier.adField1Controller.text
                        : "0",
                    adParam2: indiaBillPaymentNotifier
                            .adField2Controller.text.isNotEmpty
                        ? indiaBillPaymentNotifier.adField2Controller.text
                        : "0",
                    adParam3: indiaBillPaymentNotifier
                            .adField3Controller.text.isNotEmpty
                        ? indiaBillPaymentNotifier.adField3Controller.text
                        : "0",
                  ))
                      .then((value) async {
                    if (value.runtimeType == ViewBillErrorResponse) {
                      ViewBillErrorResponse viewBillErrorResponse =
                          value as ViewBillErrorResponse;
                      indiaBillPaymentNotifier.errorData =
                          viewBillErrorResponse.message!.text!;
                    } else {
                      ViewBillResponse viewBillResponse =
                          value as ViewBillResponse;
                      indiaBillPaymentNotifier.viewBillData = viewBillResponse;
                      if (viewBillResponse.success == true) {
                        await SharedPreferencesMobileWeb.instance
                            .getUserData(AppConstants.user)
                            .then((value) async {
                          LoginResponse loginResponse =
                              loginResponseFromJson(value);
                          indiaBillPaymentNotifier.isBillPaymentPreview = true;
                          await SGBillPayRepository()
                              .SGPricing(PricingRequest(
                            sourceCountry: "SG",
                            receiveCountry: "IN",
                            billAmnt: viewBillResponse.data![0].billAmount,
                            customerType:
                                loginResponse.userinfo!.customerTypeName,
                          ))
                              .then((value) {
                            PricingResponse pricingResponse =
                                value as PricingResponse;
                            indiaBillPaymentNotifier.pricingData =
                                pricingResponse;
                          });
                        });
                      }
                    }
                  });
                }
              }),
            ),
          ],
        ),
        SizedBox(height: indiaBillPaymentNotifier.fieldVisible ? AppConstants.seventy : AppConstants.oneHundredAndTen)
      ],
    );
  }

  // Status Dropdown
  Widget buildStatusDropDownBox(BuildContext context, IndiaBillPaymentNotifier notifier) {
    return Container(
        height: AppConstants.fortyTwo,
        width:kIsWeb ? isTab(context)
            ? getScreenWidth(context) * 0.90
            : isMobile(context)
            ? double.infinity
            : getScreenWidth(context) * 0.20 : isTabSDK(context)
            ? screenSizeWidth * 0.90
            : isMobileSDK(context)
            ? double.infinity
            : screenSizeWidth * 0.20,
        child: LayoutBuilder(
            builder: (context, constraints) => CustomizeDropdown(
              context,
              dropdownItems: notifier.statusData,
              hintText: S.of(context).statuswithout,
              width: kIsWeb
                      ? isTab(context)
                          ? getScreenWidth(context) * 0.90
                          : isMobile(context)
                              ? double.infinity
                              : getScreenWidth(context) * 0.20
                      : isTabSDK(context)
                          ? screenSizeWidth * 0.90
                          : isMobileSDK(context)
                              ? double.infinity
                              : screenSizeWidth * 0.20,
              height: AppConstants.fortyTwo,
              validation: (val) {
                return null;
              },
              onSelected: (val) => statusDropDownOnChangedFunc(val,notifier),
              onSubmitted: (val) => statusDropDownOnChangedFunc(val,notifier),
              controller: notifier.statusController,
              optionsViewBuilder: (BuildContext context,
                  AutocompleteOnSelected onSelected, Iterable options) {
                if(notifier.statusData.contains("Status")){

                }else{
                  notifier.statusData.insert(0, "Status");
                }
                return buildDropDownContainer(
                  context,
                  options: options,
                  onSelected: onSelected,
                  dropdownData: notifier.statusData,
                  constraints: constraints,
                  dropDownHeight: options.first == S.of(context).noDataFound
                      ? AppConstants.oneHundredFifty
                      : options.length < 5
                      ? options.length * 50
                      : AppConstants.twoHundred,
                );
              },
            )));
  }


  // Transaction History Table
  buildPaymentTable(
      IndiaBillPaymentNotifier indiaBillPaymentNotifier, BuildContext context) {
    return LayoutBuilder(builder: (BuildContext, constraint) {
      return Column(
        children: [
          SizedBox(
            height: constraint.maxHeight - 50,
            width: constraint.maxWidth,
            child:indiaBillPaymentNotifier.showLoadingIndicatorForList
                ? Center(
                  child: defaultTargetPlatform == TargetPlatform.iOS
                      ? CupertinoActivityIndicator(radius: 30)
                      : CircularProgressIndicator(strokeWidth: 3),
                  )
                : indiaBillPaymentNotifier.billPaymentArr.isEmpty
                    ? Center(child: Text(S.of(context).noDataFound, style: TextStyle(fontSize: 18)))
                    : Scrollbar(
                      thumbVisibility: true,
                      trackVisibility: false,
                      controller: indiaBillPaymentNotifier.listScrollController,
                      child: SingleChildScrollView(
                        controller: indiaBillPaymentNotifier.listScrollController,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: dividercolor,
                         ),
                        child: Scrollbar(
                          thumbVisibility: true,
                          trackVisibility: false,
                          controller: indiaBillPaymentNotifier.horizontalScrollController,
                          child: SingleChildScrollView(
                            scrollDirection: getScreenWidth(context) > 1650 ? Axis.vertical : Axis.horizontal,
                            controller: indiaBillPaymentNotifier.horizontalScrollController,
                            child: DataTable(
                              dataRowHeight: AppConstants.sixty,
                              dividerThickness: 2,
                              headingTextStyle: dataTableHeadingStyle(context),
                              columns: [
                                DataColumn(label: Text(S.of(context).date)),
                                DataColumn(label: Text(S.of(context).country)),
                                DataColumn(label: Text(S.of(context).billingCategory)),
                                DataColumn(label: Text(S.of(context).operatorName)),
                                DataColumn(label: Text(S.of(context).amountPaid)),
                                DataColumn(label: Text(S.of(context).billAmount)),
                                DataColumn(label: Text(S.of(context).transactionID)),
                                DataColumn(label: Text(S.of(context).statuswithout)),
                                // Add more columns here
                              ],
                              rows: List<DataRow>.generate(
                                indiaBillPaymentNotifier.visibleDataCount < indiaBillPaymentNotifier.billPaymentArr.length
                                    ? indiaBillPaymentNotifier.visibleDataCount
                                    : indiaBillPaymentNotifier.billPaymentArr.length,
                                        (index) {
                                      final data = indiaBillPaymentNotifier.billPaymentArr[index];
                                      TextStyle textStyleRow = TextStyle(
                                          fontSize: AppConstants.fourteen,
                                          fontWeight: AppFont.fontWeightMedium,
                                          color: black);
                                      var timeStampDate =
                                      new DateTime.fromMillisecondsSinceEpoch(int.parse(data.transactionDate!));
                                      final formatter = DateFormat('yyy-MM-dd HH:mm:ss');
                                      final dateTime = formatter.parse(timeStampDate.toString());
                                      var outputFormat = DateFormat('MM/dd/yyyy');
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(outputFormat.format(dateTime),style: textStyleRow,)),
                                          DataCell(Text(data.countryName!,style: textStyleRow,)),
                                          DataCell(Text(data.productName!,style: textStyleRow,)),
                                          DataCell(Text(data.operatorName!,style: textStyleRow,)),
                                          DataCell(Text(data.totalPayable!,style: textStyleRow,)),
                                          DataCell(Text(data.receiveAmount!,style: textStyleRow,)),
                                          DataCell(Text(data.userTxnId!,style: textStyleRow,)),
                                          DataCell(Text(data.status!,style: textStyleRow,)),
                                        ],
                                      );
                                    },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
          ),
        ],
      );
    });
  }

  Widget horizontalListBillCategory(
      {required BuildContext context,
        bool? isTitle,
        required IndiaBillPaymentNotifier indiaBillPaymentNotifier,controller,double bottom = 1}) {
    return Container(
      child: Scrollbar(
        thickness: AppConstants.five,
        thumbVisibility: kIsWeb ? getScreenWidth(context) < 1200 : screenSizeWidth < 1200,
        controller:controller,
        child: Selector<IndiaBillPaymentNotifier, List<BillCategoryTitle>>(
            builder: (context, billCategoryTitleArr, child) {
              return Padding(
                padding:  EdgeInsets.only(bottom: bottom),
                child: ListView.builder(
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: isTitle!
                      ? billCategoryTitleArr.length
                      : indiaBillPaymentNotifier.billCategoryItemsArr.length,
                  itemBuilder: (BuildContext context, int index) {
                    return (isTitle)
                        ? buildBillCategoryTitleCurvedBox(context,
                        index: index,
                        billCategoryTitleArr: billCategoryTitleArr,
                        indiaBillPaymentNotifier: indiaBillPaymentNotifier)
                        : buildBillCategoryItemCurvedBoxCurvedBox(context,
                        index: index,
                        billCategoryItemsArr:
                        indiaBillPaymentNotifier.billCategoryItemsArr,
                        indiaBillPaymentNotifier: indiaBillPaymentNotifier);
                  },
                ),
              );
            },
            selector: (buildContext, indiaBillPaymentNotifier) =>
            indiaBillPaymentNotifier.billCategoryTitleArr),
      ),
    );
  }

  // Bill Category Titles
  Widget buildBillCategoryTitleCurvedBox(context,
      {double? height,
        double? width,
        number,
        int? index,
        List<BillCategoryTitle>? billCategoryTitleArr,
        required IndiaBillPaymentNotifier indiaBillPaymentNotifier}) {
    int? selectedIndex = 0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: px2Top2Left8right2Bottom(context),
        child: ElevatedButton(
          child: buildText(
            text: billCategoryTitleArr![index!].title!,
            fontSize: AppConstants.sixteen,
            fontWeight: billCategoryTitleArr[index].isSelected!
                ? FontWeight.w700
                : FontWeight.w400,
            fontColor: billCategoryTitleArr[index].isSelected!
                ? exchangeRateDatacolor
                : greyColor,
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(white),
            elevation: billCategoryTitleArr[index].isSelected!
                ? MaterialStateProperty.all<double?>(15.0)
                : MaterialStateProperty.all<double?>(0.0),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.eighteen),
                side: BorderSide(
                  width: billCategoryTitleArr[index].isSelected! ? 1.0 : 0.5,
                  color: billCategoryTitleArr[index].isSelected!
                      ? orangePantone
                      : greyButtonSingupColor,
                ),
              ),
            ),
          ),
          onPressed: () {
            selectedIndex = index;
            for (int arrIndex = 0;
            arrIndex < billCategoryTitleArr.length;
            arrIndex++) {
              if (arrIndex == selectedIndex) {
                billCategoryTitleArr[arrIndex].isSelected = true;
              } else {
                billCategoryTitleArr[arrIndex].isSelected = false;
              }
            }

            indiaBillPaymentNotifier.billCategoryItemsArr.clear();
            if (selectedIndex == 0) {
              indiaBillPaymentNotifier.billCategoryItemsArr =
                  indiaBillPaymentNotifier.getUtilitiesItems();
            } else if (selectedIndex == 1) {
              indiaBillPaymentNotifier.billCategoryItemsArr =
                  indiaBillPaymentNotifier.getFinanceItems();
            } else {
              indiaBillPaymentNotifier.billCategoryItemsArr =
                  indiaBillPaymentNotifier.getOnTheGoItems();
            }
          },
        ),
      ),
    );
  }

  // DateField Dropdown
  Widget buildDateField(IndiaBillPaymentNotifier indiaBillPaymentNotifier, BuildContext context) {
    return Selector<IndiaBillPaymentNotifier, TextEditingController>(
        builder: (context, dateRangeController, child) {
          return CommonTextField(
            onChanged: (val) {
              handleInteraction(context);
            },
            readOnly: true,
            controller: dateRangeController,
            width: kIsWeb
                ? isTab(context)
                    ? getScreenWidth(context) * 0.90
                    : isMobile(context)
                        ? double.infinity
                        : getScreenWidth(context) * 0.20
                : isTabSDK(context)
                    ? screenSizeWidth * 0.90
                    : isMobileSDK(context)
                        ? double.infinity
                        : screenSizeWidth * 0.20,
            height: AppConstants.fortyTwo,
            contentPadding: px16DimenLeftOnly(context),
            suffixIcon: Row(
              children: [
                Visibility(
                  visible: dateRangeController.text.isNotEmpty,
                  child: Container(
                    width: 40,
                    child: IconButton(onPressed: (){
                      dateRangeController.clear();
                      indiaBillPaymentNotifier.billPaymentArr.clear();
                      indiaBillPaymentNotifier.startDateAPI = '';
                      indiaBillPaymentNotifier.endDateAPI = '';
                      indiaBillPaymentNotifier.initialData();
                      indiaBillPaymentNotifier.notifyListeners();
                    }, icon: Icon(Icons.close,size: AppConstants.fifteen,color: Colors.red,)),
                  ),
                ),
                Visibility(
                    visible: dateRangeController.text.isEmpty,
                    child:Spacer()),
                Padding(
                  padding: EdgeInsets.only(right:dateRangeController.text.isEmpty ? 8.0 : 0),
                  child: Icon(
                    Icons.calendar_month_outlined,
                    color: Color(0xffA1A5AD).withOpacity(0.8),
                  ),
                ),
              ],
            ),
            maxHeight: 50,
            maxWidth: 68,
            hintText: S.of(context).datewithout,
            hintStyle: hintStyle(context),
            onTap: () async {
              DateRangePickerWithYear(context, indiaBillPaymentNotifier.selectedStartDate == null
                  ? DateTime.now()
                  : indiaBillPaymentNotifier.selectedStartDate!, indiaBillPaymentNotifier.selectedEndDate == null
                  ? DateTime.now()
                  : indiaBillPaymentNotifier.selectedEndDate!,).then((CustomRangePickerResponse value)async{
                indiaBillPaymentNotifier.selectedStartDate = value.dateTime;
                indiaBillPaymentNotifier.selectedEndDate =value.dateTime2;
                final rangeStartDate =
                DateFormat('MM/dd/yyyy').format(value.dateTime!).toString();
                final rangeEndDate = DateFormat('MM/dd/yyyy').format(value.dateTime2!).toString();
                indiaBillPaymentNotifier.startDateAPI =
                    DateFormat('yyy-MM-dd HH:mm:ss').format(value.dateTime!).toString();
                indiaBillPaymentNotifier.endDateAPI =
                    DateFormat('yyy-MM-dd HH:mm:ss').format(value.dateTime2!.add(Duration(hours: 23,minutes: 59, seconds: 59))).toString();
                indiaBillPaymentNotifier.dateRangeController.text =
                '$rangeStartDate - $rangeEndDate';
                indiaBillPaymentNotifier.showLoadingIndicatorForList = true;
                await SGBillPayRepository()
                    .SGBillTransactionHistory(
                    indiaBillPaymentNotifier.startDateAPI,
                    indiaBillPaymentNotifier.endDateAPI,
                    indiaBillPaymentNotifier.selectedStatus.isNotEmpty ? indiaBillPaymentNotifier.selectedStatus: null,
                    indiaBillPaymentNotifier.searchController.text.isNotEmpty ? indiaBillPaymentNotifier.searchController.text : null)
                    .then((value) {
                  TransactionHistoryResponse res = value as TransactionHistoryResponse;
                  indiaBillPaymentNotifier.billPaymentArr.clear();
                  indiaBillPaymentNotifier.billPaymentArr.addAll(res.content!);
                  indiaBillPaymentNotifier.showLoadingIndicatorForList = false;
                });
              });
            },
          );
        },
        selector: (buildContext, indiaBillPaymentNotifier) =>
        indiaBillPaymentNotifier.dateRangeController);
  }

  // SearchField Dropdown
  Widget buildSearchField(IndiaBillPaymentNotifier indiaBillPaymentNotifier, BuildContext context) {
    return Selector<IndiaBillPaymentNotifier, TextEditingController>(
        builder: (context, searchController, child) {
          return CommonTextField(
            onChanged: (val) async {
              handleInteraction(context);
              indiaBillPaymentNotifier.showLoadingIndicatorForList = true;
              await SGBillPayRepository()
                  .SGBillTransactionHistory(
                  indiaBillPaymentNotifier.startDateAPI.isNotEmpty ? indiaBillPaymentNotifier.startDateAPI : null,
                  indiaBillPaymentNotifier.endDateAPI.isNotEmpty ? indiaBillPaymentNotifier.endDateAPI : null,
                  indiaBillPaymentNotifier.selectedStatus.isNotEmpty ? indiaBillPaymentNotifier.selectedStatus: null,
                  val.isNotEmpty
                      ? indiaBillPaymentNotifier.searchController.text
                      : null)
                  .then((value) {
                TransactionHistoryResponse res =
                value as TransactionHistoryResponse;
                indiaBillPaymentNotifier.billPaymentArr.clear();
                indiaBillPaymentNotifier.billPaymentArr.addAll(res.content!);
                indiaBillPaymentNotifier.showLoadingIndicatorForList = false;
              });
            },
            width: isMobile(context)
                ? getScreenWidth(context)
                : isTab(context)
                ? getScreenWidth(context)
                : getScreenWidth(context) * 0.22,
            height: AppConstants.fortyTwo,
            contentPadding: px16DimenLeftOnly(context),
            suffixIcon: Padding(
              padding: px16DimenRightOnly(context),
              child: Image.asset(
                AppImages.searchNormal,
                width: AppConstants.twentyTwo,
              ),
            ),
            prefixIconConstraints: BoxConstraints(
              maxHeight: AppConstants.ten,
              maxWidth: AppConstants.ten,
            ),
            hintText:
            S.of(context).search + ' ' + S.of(context).transactionIDTable,
            hintStyle: hintStyle(context),
            controller: searchController,
          );
        },
        selector: (buildContext, indiaBillPaymentNotifier) =>
        indiaBillPaymentNotifier.searchController);
  }

  // Bill Category Items
  Widget buildBillCategoryItemCurvedBoxCurvedBox(context,
      {double? height,
        double? width,
        number,
        int? index,
        List<BillCategoryItems>? billCategoryItemsArr,
        required IndiaBillPaymentNotifier indiaBillPaymentNotifier}) {
    int? selectedIndex = 0;
    return GestureDetector(
      onTap: () async {
        selectedIndex = index;
        for (int arrIndex = 0;
        arrIndex < billCategoryItemsArr!.length;
        arrIndex++) {
          if (arrIndex == selectedIndex) {
            billCategoryItemsArr[arrIndex].isSelected = true;
            indiaBillPaymentNotifier.selectedCategory =
            billCategoryItemsArr[arrIndex].title!;
            await SharedPreferencesMobileWeb.instance.setSelectedCategory(
                AppConstants.selectedCategoryDummy, billCategoryItemsArr[arrIndex].title!);
            await SharedPreferencesMobileWeb.instance
                .getSelectedCategory(AppConstants.selectedCategoryDummy)
                .then((value) {});
            indiaBillPaymentNotifier.billingCategoryController.text =
                indiaBillPaymentNotifier.selectedCategory;
            await SharedPreferencesMobileWeb.instance
                .getCountry(AppConstants.country)
                .then((value) async {
              Navigator.pushNamed(context, newBillPaymentRoute);
            });
          } else {
            billCategoryItemsArr[arrIndex].isSelected = false;
          }
        }
      },
      child: Padding(
        padding: px16DimenRightOnly(context),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            width: billCategoryItemsArr![index!].title! == "Postpaid Datacard"?AppConstants.oneHundredEighty:AppConstants.oneHundredAndThirty,
            height: AppConstants.hundred,
            decoration: BoxDecoration(
              color: white,
              border: Border.all(
                color: dividercolor,
                width: 1,
              ),
              borderRadius: radiusAll5(context),
              boxShadow: billCategoryItemsArr[index].isSelected!
                  ? [
                BoxShadow(
                  color: listTileexpansionColor.withOpacity(0.10),
                  blurRadius: AppConstants.thirty,
                  offset: Offset(0, 15),
                )
              ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: AppConstants.twentyFour,
                  height: AppConstants.twenty,
                  child: ImageIcon(
                    AssetImage(billCategoryItemsArr[index].image!),
                    color: billCategoryItemsArr[index].isSelected!
                        ? orangeALertColor
                        : greyColor,
                  ),
                ),
                sizedBoxHeight12(context),
                buildText(
                  text: billCategoryItemsArr[index].title!,
                  fontSize: AppConstants.fifteen,
                  fontWeight: FontWeight.w400,
                  fontColor: billCategoryItemsArr[index].isSelected!
                      ? orangeALertColor
                      : greyColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Recipient Text label
  Widget buildRecipientText(BuildContext context) {
    return buildText(
        text: S.of(context).recipientCountry,
        fontSize: AppConstants.sixteen,
        fontColor: oxfordBlueTint500,
        fontWeight: FontWeight.w500);
  }

  // Consumer Number label
  Widget buildConsumerNumberText(BuildContext context, IndiaBillPaymentNotifier indiaBillPaymentNotifier) {
    return buildText(
        text: indiaBillPaymentNotifier.consumerTitle.isNotEmpty
            ? indiaBillPaymentNotifier.consumerTitle
            : S.of(context).consumerNumber,
        fontSize: AppConstants.sixteen,
        fontColor: oxfordBlueTint500,
        fontWeight: FontWeight.w500);
  }

  // Additional Field Label
  Widget buildAdditionalFieldTitle(BuildContext context,IndiaBillPaymentNotifier indiaBillPaymentNotifier, String text) {
    return buildText(
        text: text,
        fontSize: AppConstants.sixteen,
        fontColor: oxfordBlueTint500,
        fontWeight: FontWeight.w500);
  }

  // Billing Category Label
  Widget buildBillingCategoryText(BuildContext context) {
    return buildText(
        text: S.of(context).billingCategory,
        fontSize: AppConstants.sixteen,
        fontColor: oxfordBlueTint500,
        fontWeight: FontWeight.w500);
  }

  // Operator Name Label
  Widget buildOperatorNameText(BuildContext context) {
    return buildText(
        text: S.of(context).operatorName,
        fontSize: AppConstants.sixteen,
        fontColor: oxfordBlueTint500,
        fontWeight: FontWeight.w500);
  }

  // ConsumerNumber TextField
  Widget buildConsumerNumberField(BuildContext context, IndiaBillPaymentNotifier indiaBillPaymentNotifier) {
    var encoded =
    base64.encode(utf8.encode(indiaBillPaymentNotifier.regexData));
    var base64Decoder = base64.decoder;
    var base64Bytes = encoded;
    var decodedBytes = base64Decoder.convert(base64Bytes);
    String pattern = utf8.decode(decodedBytes);
    RegExp regExp = new RegExp(pattern);
    return CommonTextField(
      onChanged: (val) {
        handleInteraction(context);
        indiaBillPaymentNotifier.errorData = "";
      },
      hintText: '',
      containerColor: Colors.white10,
      hintStyle: hintStyle(context),
      validator: (String? value) {
        if (value!.length == 0) {
          return 'Please enter ${indiaBillPaymentNotifier.consumerTitle.isNotEmpty?indiaBillPaymentNotifier.consumerTitle:S.of(context).consumerNumber}';
        } else if (!regExp.hasMatch(value)) {
          return 'Please enter valid ${indiaBillPaymentNotifier.consumerTitle}';
        }
        return null;
      },
      controller: indiaBillPaymentNotifier.consumerController,
      width: kIsWeb
          ? isMobile(context)
              ? getScreenWidth(context) * 0.80
              : isTab(context)
                  ? getScreenWidth(context) * 0.60
                  : double.infinity
          : isMobileSDK(context)
              ? screenSizeWidth * 0.80
              : isTabSDK(context)
                  ? screenSizeWidth * 0.60
                  : double.infinity,
    );
  }

  // Additional TextField
  Widget buildADField(BuildContext context, IndiaBillPaymentNotifier indiaBillPaymentNotifier, {hintText, controller}) {
    return CommonTextField(
      onChanged: (val) {
        handleInteraction(context);
      },
      hintText: hintText,
      controller: controller,
      validatorEmptyErrorText: AppConstants.fieldisRequired,
      containerColor: Colors.white10,
      hintStyle: hintStyle(context),
      width: kIsWeb
          ? isMobile(context)
              ? getScreenWidth(context) * 0.80
              : isTab(context)
                  ? getScreenWidth(context) * 0.60
                  : double.infinity
          : isMobileSDK(context)
              ? screenSizeWidth * 0.80
              : isTabSDK(context)
                  ? screenSizeWidth * 0.60
                  : double.infinity,
    );
  }

  // Recipient TextField
  Widget buildRecipientField(BuildContext context) {
    return CommonTextField(
      onChanged: (val) {
        handleInteraction(context);
      },
      hintText: S.of(context).india,
      fillColor: dividercolor,
      hintStyle: hintStyle(context).copyWith(color: exchangeRateHeadingcolor),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
      ],
      width: kIsWeb
          ? isMobile(context)
              ? getScreenWidth(context) * 0.80
              : isTab(context)
                  ? getScreenWidth(context) * 0.60
                  : double.infinity
          : isMobileSDK(context)
              ? screenSizeWidth * 0.80
              : isTabSDK(context)
                  ? screenSizeWidth * 0.60
                  : double.infinity,
      readOnly: true,
      isEnable: false,
    );
  }

  // Operator Name DropDown
  Widget buildOperatorNameDropDownBox(BuildContext context, {isPopUp = false, required IndiaBillPaymentNotifier indiaBillPaymentNotifier}) {
    return LayoutBuilder(
        builder: (context, constraints) => CustomizeDropdown(
          context,
          dropdownItems: indiaBillPaymentNotifier.billingOperatorData,
          onSelected: (val) => operatorNameDropdownOnChangeFunc(context,val,indiaBillPaymentNotifier),
          onSubmitted: (val) => operatorNameDropdownOnChangeFunc(context,val,indiaBillPaymentNotifier),
          validation: (val){
            if(val!.isEmpty){
              return "Operator name is required";
            }
            return null;
          },
          controller: indiaBillPaymentNotifier.billingOperatorController,
          optionsViewBuilder: (BuildContext context,
              AutocompleteOnSelected onSelected, Iterable options) {
            return buildDropDownContainer(
              context,
              options: options,
              onSelected: onSelected,
              dropdownData: indiaBillPaymentNotifier.billingOperatorData,
              constraints: constraints,
              dropDownHeight: options.first == S.of(context).noDataFound
                  ? 150
                  : options.length < 5
                  ? options.length * 50
                  : 200,
            );
          },
        ));
  }

  // Billing Category DropDown
  Widget buildBillingCategoryDropDownBox(BuildContext context, IndiaBillPaymentNotifier indiaBillPaymentNotifier) {
    return LayoutBuilder(
      builder: (context, constraints) => CustomizeDropdown(
        context,
        dropdownItems: indiaBillPaymentNotifier.billingCategoryData,
        onSelected: (val) => billingCategoryOnChangedFunc(context,val,indiaBillPaymentNotifier),
        onSubmitted: (val) => billingCategoryOnChangedFunc(context,val,indiaBillPaymentNotifier),
        controller: indiaBillPaymentNotifier.billingCategoryController,
        optionsViewBuilder: (BuildContext context,
            AutocompleteOnSelected onSelected, Iterable options) {
          return buildDropDownContainer(
            context,
            options: options,
            onSelected: onSelected,
            dropdownData: indiaBillPaymentNotifier.billingCategoryData,
            constraints: constraints,
            dropDownHeight: options.first == S.of(context).noDataFound
                ? 150
                : options.length < 5
                ? options.length * 50
                : 200,
          );
        },
      ),
    );
  }

  // Billing Category OnChange
  void billingCategoryOnChangedFunc(context,val,indiaBillPaymentNotifier) async {
      handleInteraction(context);
      if (indiaBillPaymentNotifier.selectedCategory != val) {
        indiaBillPaymentNotifier.selectedOperator = '';
      }
      indiaBillPaymentNotifier.selectedCategory = val!;
      indiaBillPaymentNotifier.billingOperatorData.clear();
      indiaBillPaymentNotifier.consumerController.clear();
      indiaBillPaymentNotifier.adField1Controller.clear();
      indiaBillPaymentNotifier.adField2Controller.clear();
      indiaBillPaymentNotifier.adField3Controller.clear();
      indiaBillPaymentNotifier.additionalField1 = '';
      indiaBillPaymentNotifier.additionalField2 = '';
      indiaBillPaymentNotifier.additionalField3 = '';
      indiaBillPaymentNotifier.errorData ='';
      indiaBillPaymentNotifier.operatorFieldVisible = false;
      indiaBillPaymentNotifier.fieldVisible = false;
      Timer.periodic(Duration(milliseconds: 40), (timer) { indiaBillPaymentNotifier.operatorFieldVisible = true; timer.cancel();});
      for (int i = 0;
      i < indiaBillPaymentNotifier.billingCategoryList.length;
      i++) {
        if (indiaBillPaymentNotifier.selectedCategory ==
            indiaBillPaymentNotifier.billingCategoryList[i].productName) {
          await SGBillPayRepository().SGBillOperatorList().then((value) {
            indiaBillPaymentNotifier.billingOperatorList =
            value as List<OperatorList>;
            for (int j = 0;
            j < indiaBillPaymentNotifier.billingOperatorList.length;
            j++) {
              if (indiaBillPaymentNotifier.billingCategoryList[i].productId
                  .toString() ==
                  indiaBillPaymentNotifier
                      .billingOperatorList[j].category) {
                indiaBillPaymentNotifier.billingOperatorData.add(
                    indiaBillPaymentNotifier
                        .billingOperatorList[j].operatorName!);
              }
            }
          });
        }
      }
    }

  // Status Dropdown OnChange
  void statusDropDownOnChangedFunc(val,notifier) {
    if(val == "Status"){
      notifier.statusController.clear();
      notifier.notifyListeners();
    }else {
      notifier.selectedStatus = val;
    }
    notifier.showLoadingIndicatorForList = true;
    SGBillPayRepository()
        .SGBillTransactionHistory(
        notifier.startDateAPI.isNotEmpty ? notifier.startDateAPI : null,
        notifier.endDateAPI.isNotEmpty ? notifier.endDateAPI : null,
        val,
        notifier.searchController.text.isNotEmpty ? notifier.searchController.text : null)
        .then((value) {
      TransactionHistoryResponse res =
      value as TransactionHistoryResponse;
      notifier.billPaymentArr.clear();
      notifier.billPaymentArr.addAll(res.content!);
      notifier.billPaymentArr.forEach((element) {});
      notifier.showLoadingIndicatorForList = false;
    });
  }

  // OperatorName dropdown OnChange
  void operatorNameDropdownOnChangeFunc(context,val,indiaBillPaymentNotifier) {
    handleInteraction(context);
    indiaBillPaymentNotifier.selectedOperator = val!;
    indiaBillPaymentNotifier.consumerController.clear();
    indiaBillPaymentNotifier.adField1Controller.clear();
    indiaBillPaymentNotifier.adField2Controller.clear();
    indiaBillPaymentNotifier.adField3Controller.clear();
    indiaBillPaymentNotifier.errorData = '';
    indiaBillPaymentNotifier.fieldVisible = false;
    Timer.periodic(Duration(milliseconds: 40), (timer) {
      indiaBillPaymentNotifier.fieldVisible = true;
      timer.cancel();
    });
    for (int i = 0;
    i < indiaBillPaymentNotifier.billingOperatorList.length;
    i++) {
      if (indiaBillPaymentNotifier.selectedOperator ==
          indiaBillPaymentNotifier
              .billingOperatorList[i].operatorName) {
        indiaBillPaymentNotifier.selectedOperatorID =
        indiaBillPaymentNotifier
            .billingOperatorList[i].viewBillId!;
        indiaBillPaymentNotifier.operatorID =
        indiaBillPaymentNotifier
            .billingOperatorList[i].operatorId!;
        SGBillPayRepository()
            .SGBillOperatorByID(indiaBillPaymentNotifier
            .billingOperatorList[i].operatorId
            .toString())
            .then((value) {
          OperatorById operatorById = value as OperatorById;
          indiaBillPaymentNotifier.additionalField1 =
          operatorById.ad1!;
          indiaBillPaymentNotifier.additionalField2 =
          operatorById.ad2!;
          indiaBillPaymentNotifier.additionalField3 =
          operatorById.ad3!;
          indiaBillPaymentNotifier.viewBillRequired =
          operatorById.viewBill!;
          indiaBillPaymentNotifier.consumerTitle = operatorById.cn!;
          indiaBillPaymentNotifier.regexData = operatorById.regex!;
        });
      }
    }
  }

}

class BillCategoryTitle {
  BillCategoryTitle(this.title, this.isSelected);

  String? title;
  bool? isSelected;
}

class BillCategoryItems {
  BillCategoryItems(this.title, this.image, this.isSelected);

  String? title;
  String? image;
  bool? isSelected;
}

