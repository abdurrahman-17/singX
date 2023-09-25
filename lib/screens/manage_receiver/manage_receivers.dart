import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/service/contact_repository.dart';
import 'package:singx/core/data/remote/service/fund_transfer_repository.dart';
import 'package:singx/core/data/remote/service/receiver_repository.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/verify_otp/verify_otp_response.dart';
import 'package:singx/core/notifier/manage_receiver_notifier.dart';
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
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../core/models/request_response/australia/fund_transfer/generate_otp/generate_otp_response.dart';

ReceiverRepository receiverRepository = ReceiverRepository();
ContactRepository contactRepository = ContactRepository();

class ManageReceivers extends StatelessWidget {
  bool? isReceiverPopUpEnabled;
  bool? navigateData;

  ManageReceivers(
      {Key? key, this.navigateData, this.isReceiverPopUpEnabled = false})
      : super(key: key);

  //responsive Data check
  late double commonWidth;

  @override
  Widget build(BuildContext context) {
    userCheck(context);
    //Checks Responsive Ui
    commonWidth = kIsWeb
        ? isMobile(context) ||
                isTab(context) ||
                getScreenWidth(context) > 800 && getScreenWidth(context) < 1100
            ? getScreenWidth(context)
            : getScreenWidth(context) / 3
        : isMobileSDK(context) ||
                isTabSDK(context) ||
                screenSizeWidth > 800 && screenSizeWidth < 1100
            ? screenSizeWidth
            : screenSizeWidth / 3;

    return ChangeNotifierProvider(
      create: (context) => ManageReceiverNotifier(context,
          isReceiverPopUp: isReceiverPopUpEnabled, navigateData: navigateData),
      child: Consumer<ManageReceiverNotifier>(
        builder: (context, manageReceiverNotifier, _) {
          return AppInActiveCheck(
            context: context,
            child: Scaffold(
              backgroundColor: white,
              appBar: isReceiverPopUpEnabled!
                  ? null
                  : PreferredSize(
                      preferredSize: Size.fromHeight(AppConstants.appBarHeight),
                      child: Container(
                        color: Colors.grey.shade50,
                        child:
                            buildCustomAppBar(context, manageReceiverNotifier),
                      ),
                    ),
              // This is to check manage Receiver Details or Adding new Receiver Screen
              body: manageReceiverNotifier.isAddReceiver
                  ? GestureDetector(
                      onTap: () =>
                          FocusManager.instance.primaryFocus!.unfocus(),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          scrollbarTheme: ScrollbarThemeData(
                            thumbColor:
                                MaterialStateProperty.all(Colors.grey.shade400),
                            thumbVisibility: MaterialStateProperty.all(true),
                          ),
                        ),
                        child: Listener(
                          onPointerSignal: (pointerSignal) {
                            if (pointerSignal is PointerScrollEvent) {
                              FocusManager.instance.primaryFocus!.unfocus();
                            }
                          },
                          child: Scrollbar(
                            controller: manageReceiverNotifier.commonController,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: kIsWeb
                                      ? getScreenWidth(context) < 400
                                          ? 0
                                          : 5
                                      : screenSizeWidth < 400
                                          ? 0
                                          : 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  commonSizedBoxHeight20(context),
                                  isReceiverPopUpEnabled!
                                      ? Row(
                                          children: [
                                            Expanded(
                                              child: buildAddNewReceiverText(
                                                  context),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: CloseButton(
                                                onPressed: () {
                                                  MyApp.navigatorKey
                                                      .currentState!
                                                      .maybePop();
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                      : buildAddNewReceiverText(context),
                                  commonSizedBoxHeight20(context),
                                  Padding(
                                    padding: px16DimenHorizontal(context),
                                    child: Divider(),
                                  ),
                                  //All Dynamic Fields
                                  buildReceiverTextFields(
                                    manageReceiverNotifier.childrens,
                                    manageReceiverNotifier,
                                    context,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                  : Padding(
                      padding: EdgeInsets.only(
                          left: getScreenWidth(context) < 400 ? 0 : 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBoxHeight(context, 0.02),
                          buildSearchAndButtonRow(
                              manageReceiverNotifier, context),
                          SizedBoxHeight(context, 0.02),
                          Expanded(
                            child: buildExpansionList(
                              manageReceiverNotifier,
                              context,
                            ),
                          )
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget buildCustomAppBar(
      context, ManageReceiverNotifier manageReceiverNotifier) {
    var text = kIsWeb
        ? getScreenWidth(context) > 470
            ? S.of(context).OrAddNewReceiverMobile
            : '\n' + S.of(context).OrAddNewReceiverMobile
        : screenSizeWidth > 470
            ? S.of(context).OrAddNewReceiverMobile
            : '\n' + S.of(context).OrAddNewReceiverMobile;
    return Padding(
      padding: kIsWeb
          ? isMobile(context) || isTab(context)
              ? px15DimenTop(context)
              : px30DimenTopOnly(context)
          : isMobileSDK(context) || isTabSDK(context)
              ? px15DimenTop(context)
              : px30DimenTopOnly(context),
      child: buildAppBar(
        context,
        manageReceiverNotifier.isAddReceiver == false
            ? IgnorePointer(
                ignoring: (getScreenWidth(context) > 500),
                child: Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  message: S.of(context).manageReceivers,
                  child: Text(S.of(context).manageReceivers,
                      overflow: TextOverflow.clip,
                      style: appBarWelcomeText(context)),
                ))
            : kIsWeb
                ? getScreenWidth(context) > 470
                    ? Text.rich(
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              MyApp.navigatorKey.currentState!.maybePop();
                            },
                          text: S.of(context).manageReceiversOr,
                          style: appBarWelcomeText(context).copyWith(
                              color: oxfordBlueTint400,
                              fontSize: kIsWeb
                                  ? isMobile(context)
                                      ? 14.5
                                      : 16
                                  : isMobileSDK(context)
                                      ? 14.5
                                      : 16),
                          children: <TextSpan>[
                            TextSpan(
                              text: text,
                              style: appBarWelcomeText(context).copyWith(
                                  color: oxfordBlueTint400,
                                  fontSize: kIsWeb
                                      ? isMobile(context)
                                          ? 14.5
                                          : 16
                                      : isMobileSDK(context)
                                          ? 14.5
                                          : 16),
                            ),
                          ],
                        ),
                      )
                    : Tooltip(
                        message: S.of(context).manageReceiversOr + text,
                        child: Text.rich(
                          overflow: TextOverflow.clip,
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pop(context);
                              },
                            text: S.of(context).manageReceiversOr,
                            style: appBarWelcomeText(context).copyWith(
                                overflow: TextOverflow.clip,
                                color: oxfordBlueTint400,
                                fontSize: kIsWeb
                                    ? isMobile(context)
                                        ? 13
                                        : 16
                                    : screenSizeWidth <= 570
                                        ? 13
                                        : 16),
                            children: <TextSpan>[
                              TextSpan(
                                text: text,
                                style: appBarWelcomeText(context).copyWith(
                                    overflow: TextOverflow.clip,
                                    color: oxfordBlueTint400,
                                    fontSize: kIsWeb
                                        ? isMobile(context)
                                            ? 13
                                            : 16
                                        : screenSizeWidth <= 570
                                            ? 13
                                            : 16),
                              ),
                            ],
                          ),
                        ),
                      )
                : screenSizeWidth > 470
                    ? Text.rich(
                        overflow: TextOverflow.clip,
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                            },
                          text: S.of(context).manageReceiversOr,
                          style: appBarWelcomeText(context).copyWith(
                              color: oxfordBlueTint400,
                              overflow: TextOverflow.clip,
                              fontSize: kIsWeb
                                  ? isMobile(context)
                                      ? 13
                                      : 16
                                  : screenSizeWidth <= 570
                                      ? 13
                                      : 16),
                          children: <TextSpan>[
                            TextSpan(
                              text: text,
                              style: appBarWelcomeText(context).copyWith(
                                  overflow: TextOverflow.clip,
                                  color: oxfordBlueTint400,
                                  fontSize: kIsWeb
                                      ? isMobile(context)
                                          ? 13
                                          : 16
                                      : screenSizeWidth <= 570
                                          ? 13
                                          : 16),
                            ),
                          ],
                        ),
                      )
                    : Tooltip(
                        message: S.of(context).manageReceiversOr + text,
                        child: Text.rich(
                          overflow: TextOverflow.clip,
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pop(context);
                              },
                            text: S.of(context).manageReceiversOr,
                            style: appBarWelcomeText(context).copyWith(
                                color: oxfordBlueTint400,
                                overflow: TextOverflow.clip,
                                fontSize: kIsWeb
                                    ? isMobile(context)
                                        ? 13
                                        : 16
                                    : screenSizeWidth <= 570
                                        ? 13
                                        : 16),
                            children: <TextSpan>[
                              TextSpan(
                                text: text,
                                style: appBarWelcomeText(context).copyWith(
                                    color: oxfordBlueTint400,
                                    overflow: TextOverflow.clip,
                                    fontSize: kIsWeb
                                        ? isMobile(context)
                                            ? 13
                                            : 16
                                        : screenSizeWidth <= 570
                                            ? 13
                                            : 16),
                              ),
                            ],
                          ),
                        ),
                      ),
        isVisible: kIsWeb
            ? manageReceiverNotifier.isAddReceiver &&
                getScreenWidth(context) < 360
            : manageReceiverNotifier.isAddReceiver && screenSizeWidth < 360,
        backCondition: manageReceiverNotifier.isAddReceiver == false
            ? null
            : () {
                MyApp.navigatorKey.currentState!.maybePop();
              },
        from: "receiver",
        userNames: manageReceiverNotifier.userName,
      ),
    );
  }

  Widget buildAddNewReceiverText(context) {
    return Padding(
      padding: px16DimenHorizontal(context),
      child: buildText(
        text: S.of(context).addNewReceiverWeb,
        fontSize: AppConstants.twenty,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget buildSearchAndButtonRow(
      ManageReceiverNotifier manageReceiverNotifier, context) {
    return Padding(
      padding: px16DimenHorizontal(context),
      child: getScreenWidth(context) < 450
          ? Column(
              children: [
                SizedBoxHeight(context, 0.02),
                buildAddReceiverButton(manageReceiverNotifier, context),
              ],
            )
          : Row(
              children: [
                Spacer(),
                buildAddReceiverButton(manageReceiverNotifier, context),
              ],
            ),
    );
  }

  Widget buildAddReceiverButton(
      ManageReceiverNotifier manageReceiverNotifier, context) {
    return buildButton(
      context,
      width: getScreenWidth(context) < 450
          ? getScreenWidth(context) * 0.90
          : isMobile(context) || isTab(context)
              ? AppConstants.oneHundredEighty
              : 270,
      name: S.of(context).addNewReceiverWeb,
      color: hanBlue,
      fontColor: white,
      onPressed: () async {
        await SharedPreferencesMobileWeb.instance
            .getCountry(country)
            .then((value) async {
          Navigator.pushNamed(context, manageReceiverNewRoute);
        });
      },
    );
  }

  Widget buildReceiverTextFields(List<Widget> children,
      ManageReceiverNotifier manageReceiverNotifier, context,
      {setState, isReceiverPopUp = false}) {
    commonWidth = kIsWeb
        ? isReceiverPopUpEnabled!
            ? getScreenWidth(context)
            : isMobile(context) ||
                    isTab(context) ||
                    getScreenWidth(context) > 800 &&
                        getScreenWidth(context) < 1100
                ? getScreenWidth(context)
                : getScreenWidth(context) / 3
        : isReceiverPopUpEnabled!
            ? screenSizeWidth
            : isMobileSDK(context) ||
                    isTabSDK(context) ||
                    screenSizeWidth > 800 && screenSizeWidth < 1100
                ? screenSizeWidth
                : screenSizeWidth / 3;
    if (manageReceiverNotifier.showLoadingIndicator && isReceiverPopUp) {
      Timer.periodic(const Duration(seconds: 2), (timer) {
        setState(() {
          manageReceiverNotifier.showLoadingIndicator = false;
        });
        timer.cancel();
      });
    }

    return isReceiverPopUp
        //If you are adding data from fund transfer page
        ? buildFields(
            context,
            manageReceiverNotifier,
            isReceiverPopUp: true,
            setState: setState,
          )
        //Default Screen
        : Expanded(
            child: buildFields(
              context,
              manageReceiverNotifier,
              isReceiverPopUp: false,
            ),
          );
  }

  Widget buildFields(
      BuildContext context, ManageReceiverNotifier manageReceiverNotifier,
      {isReceiverPopUp, setState}) {
    // This function is to build Dynamic Fields
    return Stack(
      children: [
        ListView(
          controller: manageReceiverNotifier.commonController,
          children: [
            kIsWeb
                ? (getScreenWidth(context) > 1060 &&
                            isReceiverPopUpEnabled == false) &&
                        manageReceiverNotifier.countryData == AustraliaName
                    ? buildDynamicFieldsWithSideNote(
                        context, manageReceiverNotifier)
                    : buildDynamicFieldsWithOutSideNote(
                        context, manageReceiverNotifier)
                : (screenSizeWidth > 1060 && isReceiverPopUpEnabled == false) &&
                        manageReceiverNotifier.countryData == AustraliaName
                    ? buildDynamicFieldsWithSideNote(
                        context, manageReceiverNotifier)
                    : buildDynamicFieldsWithOutSideNote(
                        context, manageReceiverNotifier),
          ],
        ),
        // If data is empty
        if (manageReceiverNotifier.showLoadingIndicator)
          Center(
            child: Container(
              color: Colors.transparent,
              width: 40,
              height: 40,
              child: Align(
                alignment: Alignment.center,
                child: defaultTargetPlatform == TargetPlatform.iOS
                    ? CupertinoActivityIndicator(
                        radius: 30,
                      )
                    : CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
              ),
            ),
          )
      ],
    );
  }

  Widget buildDynamicFieldsWithSideNote(
      BuildContext context, ManageReceiverNotifier manageReceiverNotifier) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: Form(
            key: manageReceiverNotifier.manageReceiverKey,
            child: Padding(
              padding: EdgeInsets.only(
                left: kIsWeb
                    ? isMobile(context) || isTab(context)
                        ? getScreenWidth(context) / 10
                        : getScreenWidth(context) < 1100
                            ? getScreenWidth(context) / 9
                            : getScreenWidth(context) < 1350
                                ? getScreenWidth(context) / 8
                                : getScreenWidth(context) / 6
                    : isMobileSDK(context) || isTabSDK(context)
                        ? screenSizeWidth / 10
                        : screenSizeWidth < 1100
                            ? screenSizeWidth / 9
                            : screenSizeWidth < 1350
                                ? screenSizeWidth / 8
                                : screenSizeWidth / 6,
                right: kIsWeb
                    ? getScreenWidth(context) < 1100 &&
                            getScreenWidth(context) > 1060
                        ? 50
                        : 0
                    : screenSizeWidth < 1100 && screenSizeWidth > 1060
                        ? 50
                        : 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  isReceiverPopUpEnabled!
                      ? commonSizedBoxHeight20(context)
                      : commonSizedBoxHeight50(context),
                  buildText(
                      text: manageReceiverNotifier.countryData == AustraliaName
                          ? "Receiver Currency"
                          : 'Select Currency'),
                  commonSizedBoxHeight20(context),
                  buildSelectCurrencyDropDown(manageReceiverNotifier),
                  commonSizedBoxHeight20(context),
                  Consumer<ManageReceiverNotifier>(
                      builder: (context, notifier, child) {
                    return Visibility(
                      visible: notifier.isCountryFieldVisible,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildText(
                              text: manageReceiverNotifier.countryData ==
                                      AustraliaName
                                  ? "Receiver Country"
                                  : 'Select Country'),
                          commonSizedBoxHeight20(context),
                          buildSelectCountryDropDown(manageReceiverNotifier),
                        ],
                      ),
                    );
                  }),
                  commonSizedBoxHeight20(context),
                  // Dynamic Fields
                  //Inside children dynamic fields is added
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: manageReceiverNotifier.childrens,
                  ),
                  commonSizedBoxHeight20(context),
                  Visibility(
                      child: Column(
                        children: [
                          buildText(
                              text: manageReceiverNotifier.overallErrorMessage,
                              fontColor: error),
                          commonSizedBoxHeight20(context),
                        ],
                      ),
                      visible:
                          manageReceiverNotifier.overallErrorMessage != ''),
                  Visibility(
                      child: Column(
                        children: [
                          buildText(
                              text: manageReceiverNotifier.OTPErrorMessage,
                              fontColor: error),
                          commonSizedBoxHeight20(context),
                        ],
                      ),
                      visible: manageReceiverNotifier.OTPErrorMessage != ''),
                  SizedBox(
                    width: commonWidth,
                    child: Text(
                      "Before you hit save, please check that all details are correct, especially the account number. Any inaccuracy could result in your money reaching a wrong person’s account!",
                      style: blackTextStyle16(context),
                    ),
                  ),
                  commonSizedBoxHeight40(context),
                  buildButtons(manageReceiverNotifier, context),
                  commonSizedBoxHeight60(context)
                ],
              ),
            ),
          ),
        ),
        //Side Note For Australia
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.only(
                right: kIsWeb
                    ? getScreenWidth(context) < 1200
                        ? 30
                        : getScreenWidth(context) < 1400
                            ? 100
                            : 200
                    : screenSizeWidth < 1200
                        ? 30
                        : screenSizeWidth < 1400
                            ? 100
                            : 200,
                top: 50),
            child: manageReceiverNotifier.sideNoteList.length < 1
                ? SizedBox()
                : Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Color(0xffF8E0D1),
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Please keep the following receiver details handy:",
                          style: blackTextStyle14(context),
                        ),
                        sizedBoxHeight5(context),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: manageReceiverNotifier.sideNoteList.length,
                          itemBuilder: (context, index) {
                            return Text(
                              " • ${manageReceiverNotifier.selectedCurrency== "USD" && manageReceiverNotifier.selectedCountry == "United States" && manageReceiverNotifier.sideNoteList[index] ==
                                  "BIC/SWIFT code"?"ACH code":manageReceiverNotifier.sideNoteList[index]}",
                              style: blackTextStyle14(context),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget buildDynamicFieldsWithOutSideNote(
      BuildContext context, ManageReceiverNotifier manageReceiverNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: isReceiverPopUpEnabled!
              ? EdgeInsets.all(8)
              : EdgeInsets.symmetric(
                  horizontal: kIsWeb
                      ? isMobile(context) || isTab(context)
                          ? getScreenWidth(context) / 10
                          : getScreenWidth(context) / 4.5
                      : isMobileSDK(context) || isTabSDK(context)
                          ? screenSizeWidth / 10
                          : screenSizeWidth / 4.5,
                ),
          child: manageReceiverNotifier.sideNoteList.length < 1
              ? SizedBox()
              : Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Color(0xffF8E0D1),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Please keep the following receiver details handy:",
                        style: blackTextStyle14(context),
                      ),
                      sizedBoxHeight5(context),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: manageReceiverNotifier.sideNoteList.length,
                        itemBuilder: (context, index) {
                          return Text(
                            " • ${manageReceiverNotifier.selectedCurrency== "USD" && manageReceiverNotifier.selectedCountry == "United States" && manageReceiverNotifier.sideNoteList[index] ==
                                "BIC/SWIFT code"?"ACH code":manageReceiverNotifier.sideNoteList[index]}",
                            style: blackTextStyle14(context),
                          );
                        },
                      ),
                    ],
                  ),
                ),
        ),
        Form(
          key: manageReceiverNotifier.manageReceiverKey,
          child: Padding(
            padding: kIsWeb
                ? isReceiverPopUpEnabled!
                    ? isMobile(context)
                        ? EdgeInsets.all(1)
                        : EdgeInsets.all(17)
                    : EdgeInsets.symmetric(
                        horizontal: isMobile(context) || isTab(context)
                            ? getScreenWidth(context) / 10
                            : getScreenWidth(context) / 4.5)
                : isReceiverPopUpEnabled!
                    ? isMobileSDK(context)
                        ? EdgeInsets.all(1)
                        : EdgeInsets.all(17)
                    : EdgeInsets.symmetric(
                        horizontal: isMobileSDK(context) || isTabSDK(context)
                            ? screenSizeWidth / 10
                            : screenSizeWidth / 4.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                isReceiverPopUpEnabled!
                    ? kIsWeb
                        ? SizedBoxHeight(context, 0.00)
                        : SizedBox(height: 0)
                    : commonSizedBoxHeight50(context),
                buildText(
                    text: manageReceiverNotifier.countryData == AustraliaName
                        ? "Receiver Currency"
                        : 'Select Currency'),
                commonSizedBoxHeight20(context),
                buildSelectCurrencyDropDown(manageReceiverNotifier),
                commonSizedBoxHeight20(context),
                Consumer<ManageReceiverNotifier>(
                    builder: (context, notifier, child) {
                  return Visibility(
                    visible: notifier.isCountryFieldVisible,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildText(
                            text: manageReceiverNotifier.countryData ==
                                    AustraliaName
                                ? "Receiver Country"
                                : 'Select Country'),
                        commonSizedBoxHeight20(context),
                        buildSelectCountryDropDown(manageReceiverNotifier),
                      ],
                    ),
                  );
                }),
                commonSizedBoxHeight20(context),
                //Dynamic Fields
                //In children Dynamic fields added
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: manageReceiverNotifier.childrens,
                ),
                commonSizedBoxHeight20(context),
                SizedBox(
                  width: commonWidth,
                  child: Text(
                    "Before you hit save, please check that all details are correct, especially the account number. Any inaccuracy could result in your money reaching a wrong person’s account!",
                    style: blackTextStyle16(context),
                  ),
                ),
                commonSizedBoxHeight20(context),
                Visibility(
                    child: Column(
                      children: [
                        SizedBox(
                          width: commonWidth,
                          child: buildText(
                            text: manageReceiverNotifier.overallErrorMessage,
                            fontColor: error,
                            fontSize: 15,
                          ),
                        ),
                        commonSizedBoxHeight20(context),
                      ],
                    ),
                    visible: manageReceiverNotifier.overallErrorMessage != ''),
                Visibility(
                    child: Column(
                      children: [
                        buildText(
                            text: manageReceiverNotifier.OTPErrorMessage,
                            fontColor: error),
                        commonSizedBoxHeight20(context),
                      ],
                    ),
                    visible: manageReceiverNotifier.OTPErrorMessage != ''),
                commonSizedBoxHeight40(context),
                //button functionality
                buildButtons(manageReceiverNotifier, context),
                commonSizedBoxHeight20(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildButtons(ManageReceiverNotifier manageReceiverNotifier, context) {
    return Container(
      width: commonWidth,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: buildButton(
              context,
              name: S.of(context).cancel,
              fontColor: hanBlue,
              color: hanBlueTint200,
              onPressed: () {
                MyApp.navigatorKey.currentState!.maybePop();
              },
            ),
          ),
          commonSizedBoxWidth20(context),
          Expanded(
            flex: 1,
            child: buildButton(
              context,
              name: S.of(context).save,
              fontColor: white,
              color: hanBlue,
              onPressed: () async {
                buttonFunctionality(context, manageReceiverNotifier);
              },
            ),
          ),
        ],
      ),
    );
  }

  buttonFunctionality(BuildContext context,
      ManageReceiverNotifier manageReceiverNotifier) async {
    if (manageReceiverNotifier.manageReceiverKey.currentState!.validate()) {
      manageReceiverNotifier.overallErrorMessage = "";
      if (manageReceiverNotifier.countryData == AustraliaName) {
        if ((manageReceiverNotifier.selectedCurrency == "CAD" ||
                manageReceiverNotifier.selectedCurrency == "EUR" ||
                manageReceiverNotifier.selectedCurrency == "GBP" ||
                manageReceiverNotifier.selectedCurrency == "INR" ||
                manageReceiverNotifier.selectedCurrency == "HKD" ||
                manageReceiverNotifier.selectedCurrency == "JPY" ||
                manageReceiverNotifier.selectedCurrency == "NZD" ||
                manageReceiverNotifier.selectedCurrency == "USD") &&
            manageReceiverNotifier.showIFSCData == false) {
          manageReceiverNotifier.overallErrorMessage =
              "Click on Search to verify.";
          return;
        }
        FundTransferRepository().generateOtp(context, 'receiver');
        openPopUpDialog(manageReceiverNotifier, context);
      } else {
        manageReceiverNotifier.OTPErrorMessage = '';
        if ((manageReceiverNotifier.selectedCurrency == "AUD" ||
                manageReceiverNotifier.selectedCurrency == "CAD" ||
                manageReceiverNotifier.selectedCurrency == "EUR" ||
                manageReceiverNotifier.selectedCurrency == "GBP" ||
                manageReceiverNotifier.selectedCurrency == "INR" ||
                manageReceiverNotifier.selectedCurrency == "JPY" ||
                manageReceiverNotifier.selectedCurrency == "NZD" ||
                manageReceiverNotifier.selectedCurrency == "USD") &&
            manageReceiverNotifier.showIFSCData == false) {
          manageReceiverNotifier.receiverDynamicFields
              .asMap()
              .forEach((i, element) {
            if (manageReceiverNotifier.receiverDynamicFields[i].fieldLabel ==
                "IFSC Code") {
              manageReceiverNotifier.getBankDetailByBranchCode(
                  context,
                  manageReceiverNotifier.receiverDynamicFields[i].fieldLabel,
                  "ifsc",
                  manageReceiverNotifier.receiverIFSCCode);
            } else if (manageReceiverNotifier
                    .receiverDynamicFields[i].fieldLabel ==
                "Bank code") {
              manageReceiverNotifier.getBankDetailByBranchCode(
                  context,
                  manageReceiverNotifier.receiverDynamicFields[i].fieldLabel,
                  "Bank code",
                  manageReceiverNotifier.receiverBankCode +
                      manageReceiverNotifier.receiverBranchCode);
            } else if ((manageReceiverNotifier
                        .receiverDynamicFields[i].fieldLabel ==
                    "Branch Transit Number" &&
                manageReceiverNotifier.selectedCountry == "Canada")) {
              manageReceiverNotifier.getBankDetailByBranchCode(
                  context,
                  manageReceiverNotifier.receiverDynamicFields[i].fieldLabel,
                  "Branch Transit Number",
                  manageReceiverNotifier.receiverBranchTransitCode +
                      "-" +
                      manageReceiverNotifier.receiverFinancialInstitutionCode);
            } else if (manageReceiverNotifier
                        .receiverDynamicFields[i].fieldLabel ==
                    "BIC/Swift" ||
                manageReceiverNotifier.receiverDynamicFields[i].fieldLabel ==
                    "BSB Code" ||
                manageReceiverNotifier.receiverDynamicFields[i].fieldLabel ==
                    "ACH Number" ||
                manageReceiverNotifier.receiverDynamicFields[i].fieldLabel ==
                    "Sort code") {
              manageReceiverNotifier.getBankDetailByBranchCode(
                  context,
                  manageReceiverNotifier.receiverDynamicFields[i].fieldLabel,
                  manageReceiverNotifier.receiverDynamicFields[i].fieldLabel ==
                          "BIC/Swift"
                      ? "swift"
                      : manageReceiverNotifier
                                      .receiverDynamicFields[i].fieldLabel ==
                                  "BSB Code"
                          ? "bsb"
                          : manageReceiverNotifier
                      .receiverDynamicFields[i].fieldLabel ==
                      "ACH Number"
                          ? "ach"
                          : manageReceiverNotifier
                                      .receiverDynamicFields[i].fieldLabel ==
                                  "Sort code"
                              ? "bsb"
                              : "ifsc",
                  manageReceiverNotifier.receiverDynamicFields[i].fieldLabel ==
                          "BIC/Swift"
                      ? manageReceiverNotifier.receiverSwiftCode
                      : manageReceiverNotifier
                                  .receiverDynamicFields[i].fieldLabel ==
                              "BSB Code"
                          ? manageReceiverNotifier.receiverBSBCode
                          : manageReceiverNotifier
                                      .receiverDynamicFields[i].fieldLabel ==
                                  "ACH Number"
                              ? manageReceiverNotifier.receiverACHNumber
                              : manageReceiverNotifier.receiverDynamicFields[i]
                                          .fieldLabel ==
                                      "Sort code"
                                  ? manageReceiverNotifier.receiverBSBCode
                                  : manageReceiverNotifier.receiverIFSCCode);
            }
          });
        }
        if (manageReceiverNotifier.receiverIFSCCode != '') {
          manageReceiverNotifier.isIFSCCodeValid =
              (await manageReceiverNotifier.getBranchAPICall(
                  context,
                  manageReceiverNotifier,
                  "ifsc",
                  manageReceiverNotifier.receiverIFSCCode))!;
        }

        if (manageReceiverNotifier.receiverIBANCode != '' && !(manageReceiverNotifier.selectedCurrency == "USD")) {
          manageReceiverNotifier.isIBANValid =
              await manageReceiverNotifier.getBranchAPICall(
                  context,
                  manageReceiverNotifier,
                  "iBan",
                  manageReceiverNotifier.receiverIBANCode);
        }

        if (manageReceiverNotifier.receiverBSBCode != '') {
          manageReceiverNotifier.isBSBCodeValid =
              await manageReceiverNotifier.getBranchAPICall(
                  context,
                  manageReceiverNotifier,
                  "bsb",
                  manageReceiverNotifier.receiverBSBCode);
        }

        if (manageReceiverNotifier.receiverACHNumber != '') {
          manageReceiverNotifier.isBSBCodeValid =
              await manageReceiverNotifier.getBranchAPICall(
                  context,
                  manageReceiverNotifier,
                  "ach",
                  manageReceiverNotifier.receiverACHNumber);
        }

        if (manageReceiverNotifier.receiverSwiftCode != '') {
          manageReceiverNotifier.isSwiftCodeValid =
              await manageReceiverNotifier.getBranchAPICall(
                  context,
                  manageReceiverNotifier,
                  "swift",
                  manageReceiverNotifier.receiverSwiftCode);
        }

        generateOTP(context, manageReceiverNotifier);
      }
    }
  }

  Widget loadReceiverDataList(
      BuildContext context, ManageReceiverNotifier manageReceiverNotifier) {
    List<Widget> _getChildren() {
      final List<Widget> stackChildren = [];

      if (manageReceiverNotifier.countryData == AustraliaName
          ? manageReceiverNotifier.contentAusList.isNotEmpty
          : manageReceiverNotifier.contentList.isNotEmpty) {
        stackChildren.add(
          Scrollbar(
            controller: manageReceiverNotifier.commonController3,
            thumbVisibility: true,
            child: (ListView.custom(
              controller: manageReceiverNotifier.commonController3,
              childrenDelegate:
                  CustomSliverChildBuilderDelegateReceiver(indexBuilder),
            )),
          ),
        );
      }

      if (manageReceiverNotifier.showLoadingIndicator) {
        stackChildren.add(Center(
          child: Container(
            color: Colors.transparent,
            width: 40,
            height: 40,
            child: Align(
              alignment: Alignment.center,
              child: defaultTargetPlatform == TargetPlatform.iOS
                  ? CupertinoActivityIndicator(
                      radius: 30,
                    )
                  : CircularProgressIndicator(
                      strokeWidth: 3,
                    ),
            ),
          ),
        ));
      }
      return stackChildren;
    }

    return Stack(
      children: _getChildren(),
    );
  }

  Widget indexBuilder(BuildContext context, int index) {
    return Consumer<ManageReceiverNotifier>(
        builder: (context, manageReceiverNotifier, _) {
      return Padding(
        padding: px8DimenAll(context),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: manageReceiverNotifier.isExpanded[index]
                ? [
                    BoxShadow(
                      color: listTileexpansionColor.withOpacity(0.10),
                      blurRadius: AppConstants.thirty,
                      offset: Offset(AppConstants.zero, AppConstants.fifteen),
                    ),
                  ]
                : [],
            borderRadius: radiusAll8(context),
            color: white,
            border: Border.all(color: dividercolor, width: AppConstants.one),
          ),
          child: expansionTileContainer(
            context,
            isReceiver: true,
            dltOnPressed: () async {
              manageReceiverNotifier.deleteReceiverAlert(context, index);
            },
            name: manageReceiverNotifier.countryData == AustraliaName
                ? "${manageReceiverNotifier.contentListPaginatedAus[index].firstName} ${manageReceiverNotifier.contentListPaginatedAus[index].middleName} ${manageReceiverNotifier.contentListPaginatedAus[index].lastName}"
                : manageReceiverNotifier.contentList[index].name,
            bankDetails: manageReceiverNotifier.countryData == AustraliaName
                ? "${manageReceiverNotifier.contentListPaginatedAus[index].currency} account ending with ${manageReceiverNotifier.contentListPaginatedAus[index].accountNumber!.length <= 4 ? manageReceiverNotifier.contentListPaginatedAus[index].accountNumber : manageReceiverNotifier.contentListPaginatedAus[index].accountNumber != '' ? manageReceiverNotifier.contentListPaginatedAus[index].accountNumber!.lastChars(4) : '0000'}"
                : "${manageReceiverNotifier.contentList[index].country} account ending with ${manageReceiverNotifier.contentList[index].accountNumber!.length <= 4 ? manageReceiverNotifier.contentList[index].accountNumber : manageReceiverNotifier.contentList[index].accountNumber != '' ? manageReceiverNotifier.contentList[index].accountNumber!.lastChars(4) : '0000'}",
            onExpansionChanged: (val) {
              manageReceiverNotifier.isExpanded[index] = val;
            },
            accountHolderName: manageReceiverNotifier.countryData ==
                    AustraliaName
                ? "${manageReceiverNotifier.contentListPaginatedAus[index].firstName}  ${manageReceiverNotifier.contentListPaginatedAus[index].lastName}"
                : manageReceiverNotifier.contentList[index].name,
            Country: manageReceiverNotifier.countryData == AustraliaName
                ? manageReceiverNotifier.contentListPaginatedAus[index].country
                : manageReceiverNotifier.contentList[index].country,
            bankName: manageReceiverNotifier.countryData == AustraliaName
                ? manageReceiverNotifier.contentListPaginatedAus[index].bankName
                : manageReceiverNotifier.contentList[index].bankName,
            accountNumber: manageReceiverNotifier.countryData == AustraliaName
                ? manageReceiverNotifier
                    .contentListPaginatedAus[index].accountNumber
                : manageReceiverNotifier.contentList[index].accountNumber,
            trailing: AnimatedRotation(
              turns: manageReceiverNotifier.isExpanded[index] ? 0.5 : 0.0,
              duration: Duration(milliseconds: AppConstants.twoHundredInt),
              child: Padding(
                padding: const EdgeInsets.only(right: 2.0, top: 10),
                child: Image.asset(AppImages.dropDownImage,
                    height: AppConstants.twentyFour,
                    width: AppConstants.twentyFour),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget buildSelectCurrencyDropDown(
      ManageReceiverNotifier manageReceiverNotifier) {
    return LayoutBuilder(builder: (context, constraints) {
      List<String> dropdownData =
          manageReceiverNotifier.countryData == AustraliaName
              ? manageReceiverNotifier.currencyAusDataStr
              : manageReceiverNotifier.currencyDataApi;
      dropdownData.sort();
      return CustomizeDropdown(
        manageReceiverNotifier: manageReceiverNotifier,
        context,
        dropdownItems: dropdownData,
        controller: manageReceiverNotifier.selectedCurrencyController,
        optionsViewBuilder: (BuildContext context,
            AutocompleteOnSelected onSelected, Iterable options) {
          return buildDropDownContainer(
            context,
            options: options,
            onSelected: onSelected,
            dropdownData: dropdownData,
            dropDownWidth: kIsWeb
                ? getScreenWidth(context) > 1100 && !isReceiverPopUpEnabled!
                    ? commonWidth
                    : constraints.biggest.width
                : screenSizeWidth > 1100 && !isReceiverPopUpEnabled!
                    ? commonWidth
                    : constraints.biggest.width,
            dropDownHeight: options.first == 'No Data Found'
                ? 150
                : options.length < 5
                    ? options.length * 50
                    : 170,
          );
        },
        width: commonWidth,
        onSelected: (val) {
          apiLoader(context);
          currencyOnChanged(val, manageReceiverNotifier, context);
          manageReceiverNotifier.dateOfExpiryController.clear();
          manageReceiverNotifier.selectedReceiverType = "Individual";
          manageReceiverNotifier.getSideNoteList(context);
          Future.delayed(Duration(seconds: 3))
              .then((value) => Navigator.pop(context));
        },
        onSubmitted: (val) {
          apiLoader(context);
          manageReceiverNotifier.selectedCurrencyController.text = val;
          currencyOnChanged(val, manageReceiverNotifier, context);
          manageReceiverNotifier.dateOfExpiryController.clear();
          manageReceiverNotifier.selectedReceiverType = "Individual";
          manageReceiverNotifier.getSideNoteList(context);
          Future.delayed(Duration(seconds: 3))
              .then((value) => Navigator.pop(context));
        },
        validation: (value) {
          if (value == null || value.isEmpty) {
            return 'Select Currency';
          }
          return null;
        },
      );
    });
  }

  Widget buildSelectCountryDropDown(
      ManageReceiverNotifier manageReceiverNotifier) {
    return LayoutBuilder(builder: (context, constraints) {
      List<String> dropdownItems = [];
      if (manageReceiverNotifier.countryData == AustraliaName &&
          manageReceiverNotifier.selectedIndex == "EUR") {
        dropdownItems = manageReceiverNotifier.euroCountryAusDataStr;
        // manageReceiverNotifier.countryAusList = manageReceiverNotifier.euroCountryAusDataStr;
      } else if (manageReceiverNotifier.countryData == AustraliaName &&
          manageReceiverNotifier.selectedIndex == "USD") {
        dropdownItems = manageReceiverNotifier.swiftCountryDataStr;
      } else {
        dropdownItems = manageReceiverNotifier.countryDataStr;
      }
      return CustomizeDropdown(
        context,
        manageReceiverNotifier: manageReceiverNotifier,
        dropdownItems: dropdownItems,
        controller: manageReceiverNotifier.selectedCountryController,
        optionsViewBuilder: (BuildContext context,
            AutocompleteOnSelected onSelected, Iterable options) {
          return buildDropDownContainer(
            context,
            options: options,
            onSelected: onSelected,
            dropdownData: dropdownItems,
            dropDownWidth: kIsWeb
                ? getScreenWidth(context) > 1100 && !isReceiverPopUpEnabled!
                    ? commonWidth
                    : constraints.biggest.width
                : screenSizeWidth > 1100 && !isReceiverPopUpEnabled!
                    ? commonWidth
                    : constraints.biggest.width,
            dropDownHeight: options.first == 'No Data Found'
                ? 150
                : options.length < 5
                    ? options.length * 50
                    : 170,
          );
        },
        width: commonWidth,
        onSelected: (val) {
          apiLoader(context);
          countryOnChanged(context, manageReceiverNotifier, val);
          Future.delayed(Duration(seconds: 3))
              .then((value) => Navigator.pop(context));
        },
        onSubmitted: (val) {
          apiLoader(context);
          countryOnChanged(context, manageReceiverNotifier, val);
          Future.delayed(Duration(seconds: 3))
              .then((value) => Navigator.pop(context));
        },
        validation: (value) {
          if (value == null || value.isEmpty) {
            return 'Select Country';
          }
          return null;
        },
      );
    });
  }

  Widget branchValidationMessage(BuildContext context, String text) {
    return Visibility(
        visible: text != "",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sizedBoxHeight5(context),
            buildText(text: text, fontColor: error),
          ],
        ));
  }

  Widget buildExpansionList(
      ManageReceiverNotifier manageReceiverNotifier, context) {
    //Manage Receiver data list
    return Padding(
      padding: EdgeInsets.all(getScreenWidth(context) < 400
          ? AppConstants.zero
          : AppConstants.eight),
      child: Column(
        children: [
          Expanded(
              child: Stack(
            children: [
              (manageReceiverNotifier.countryData == AustraliaName
                          ? manageReceiverNotifier.contentAusList.length
                          : manageReceiverNotifier.contentList.length) >
                      0

                  ? loadReceiverDataList(context, manageReceiverNotifier)
                  : Center(
                      child: Text(
                      "No Data Found",
                      style: TextStyle(fontSize: 18),
                    )),
              //Initial Loader for API
              if (manageReceiverNotifier.showLoadingIndicator)
                Center(
                  child: Container(
                    color: Colors.transparent,
                    width: 40,
                    height: 40,
                    child: Align(
                      alignment: Alignment.center,
                      child: defaultTargetPlatform == TargetPlatform.iOS
                          ? CupertinoActivityIndicator(
                              radius: 30,
                            )
                          : CircularProgressIndicator(
                              strokeWidth: 3,
                            ),
                    ),
                  ),
                )
            ],
          ),),
          //Pagination
          Visibility(
            visible: manageReceiverNotifier.pageCount !=0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      buildPagination(
                          context: context,
                          iconData: Icons.first_page,
                          isIcon: true,
                          buttonFunction: () {
                            if (manageReceiverNotifier.pageIndex == 1) return;
                            manageReceiverNotifier.pageIndex = 1;
                            manageReceiverNotifier
                                .paginationScrollController.position
                                .animateTo(
                                    manageReceiverNotifier
                                        .paginationScrollController
                                        .position
                                        .minScrollExtent,
                                    duration: Duration(seconds: 1),
                                    curve: Curves.easeOut);
                            onPaginated(context, manageReceiverNotifier);
                          }),
                      sizedBoxWidth5(context),
                      buildPagination(
                          context: context,
                          iconData: Icons.keyboard_arrow_left,
                          isIcon: true,
                          buttonFunction: () {
                            if (manageReceiverNotifier.pageIndex! <= 1) return;
                            manageReceiverNotifier.pageIndex =
                                (manageReceiverNotifier.pageIndex! - 1);
                            manageReceiverNotifier
                                .paginationScrollController.position
                                .jumpTo(manageReceiverNotifier
                                        .paginationScrollController.offset -
                                    AppConstants.forty);
                            onPaginated(context, manageReceiverNotifier);
                          }),
                      SizedBox(
                        height: AppConstants.thirtyFive,
                        width: (getScreenWidth(context) < 310 ||
                                manageReceiverNotifier.pageCount <= 1)
                            ? AppConstants.forty
                            : (getScreenWidth(context) < 350 ||
                                    manageReceiverNotifier.pageCount <= 2)
                                ? AppConstants.eighty
                                : AppConstants.oneHundredAndTwenty,
                        child: Center(
                          child: ListView.builder(
                              controller: manageReceiverNotifier
                                  .paginationScrollController,
                              scrollDirection: Axis.horizontal,
                              itemCount: manageReceiverNotifier.pageCount,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: buildPagination(
                                      context: context,
                                      isIcon: false,
                                      selectedPageCount:
                                          manageReceiverNotifier.pageIndex,
                                      pageCount: (index + 1).toString(),
                                      buttonFunction: () {
                                        manageReceiverNotifier.pageIndex =
                                            index + 1;
                                        onPaginated(
                                            context, manageReceiverNotifier);
                                      }),
                                );
                              }),
                        ),
                      ),
                      sizedBoxWidth5(context),
                      buildPagination(
                          context: context,
                          iconData: Icons.keyboard_arrow_right,
                          isIcon: true,
                          buttonFunction: () {
                            if (manageReceiverNotifier.pageIndex! >=
                                manageReceiverNotifier.pageCount) return;
                            manageReceiverNotifier.pageIndex =
                                (manageReceiverNotifier.pageIndex! + 1);
                            manageReceiverNotifier
                                .paginationScrollController.position
                                .jumpTo(manageReceiverNotifier
                                        .paginationScrollController.offset +
                                    AppConstants.forty);
                            onPaginated(context, manageReceiverNotifier);
                          }),
                      sizedBoxWidth5(context),
                      buildPagination(
                          context: context,
                          iconData: Icons.last_page,
                          isIcon: true,
                          buttonFunction: () {
                            if (manageReceiverNotifier.pageIndex ==
                                manageReceiverNotifier.pageCount) return;
                            manageReceiverNotifier.pageIndex =
                                manageReceiverNotifier.pageCount;
                            manageReceiverNotifier
                                .paginationScrollController.position
                                .animateTo(
                                    manageReceiverNotifier
                                        .paginationScrollController
                                        .position
                                        .maxScrollExtent,
                                    duration: Duration(seconds: 1),
                                    curve: Curves.easeIn);
                            onPaginated(context, manageReceiverNotifier);
                          }),
                    ],
                  ),
                  if (getScreenWidth(context) > 500)
                    Text(
                        '${manageReceiverNotifier.pageIndex!} ${"of"} ${manageReceiverNotifier.pageCount} '
                        '${"pages"}',
                        style: blackTextStyle16(context)
                          ..copyWith(
                            fontSize: manageReceiverNotifier.pageIndex! > 9 ||
                                    manageReceiverNotifier.pageCount > 100
                                ? 13
                                : 16,
                          ))
                ],
              ),
            ),
          ),
          sizedBoxHeight10(context),
          if (getScreenWidth(context) < 500)
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                  '${manageReceiverNotifier.pageIndex!} ${"of"} ${manageReceiverNotifier.pageCount} '
                  '${"pages"}',
                  style: blackTextStyle16(context)
                    ..copyWith(
                      fontSize: manageReceiverNotifier.pageIndex! > 9 ||
                              manageReceiverNotifier.pageCount > 100
                          ? 13
                          : 16,
                    )),
            )
        ],
      ),
    );
  }

  void generateOTP(BuildContext context, ManageReceiverNotifier notifier) {
    //Generating OTP while Adding Receiver
    FundTransferRepository().generateOtpSG(context, 'Receiver').then((value) {
      GenerateOtpResponse res = value as GenerateOtpResponse;
      if (res.response!.success == true) {
        notifier.OTPErrorMessage = '';
        verifyAndOpenPopUpDialog(context, notifier);
      } else {
        notifier.OTPErrorMessage = res.response!.message ?? '';
      }
    });
  }

  verifyAndOpenPopUpDialog(
      BuildContext context, ManageReceiverNotifier manageReceiverNotifier) {
    if ((manageReceiverNotifier.selectedCurrency ==
                "USD") ||
        ((manageReceiverNotifier.selectedCurrency == 'EUR') &&
        (manageReceiverNotifier.isSwiftCodeValid &&
            manageReceiverNotifier.isIBANValid))) {
      openPopUpDialog(manageReceiverNotifier, context);
    }
    if (manageReceiverNotifier.selectedCurrency == 'AUD' &&
        manageReceiverNotifier.isBSBCodeValid &&
        manageReceiverNotifier.isSwiftCodeValid) {
      openPopUpDialog(manageReceiverNotifier, context);
    }
    if (manageReceiverNotifier.selectedCurrency == 'EUR' ||
        manageReceiverNotifier.selectedCurrency == 'USD' ||
        manageReceiverNotifier.selectedCurrency == 'AUD') {
    } else if (manageReceiverNotifier.isBSBCodeValid ||
        manageReceiverNotifier.isSwiftCodeValid ||
        manageReceiverNotifier.isIBANValid ||
        manageReceiverNotifier.isIFSCCodeValid) {
      openPopUpDialog(manageReceiverNotifier, context);
    } else if (!manageReceiverNotifier.isBSBCodeValid &&
        !manageReceiverNotifier.isSwiftCodeValid &&
        !manageReceiverNotifier.isIBANValid &&
        !manageReceiverNotifier.isIFSCCodeValid &&
        manageReceiverNotifier.receiverSwiftCode == '' &&
        manageReceiverNotifier.receiverIBANCode == '' &&
        manageReceiverNotifier.receiverBSBCode == '' &&
        manageReceiverNotifier.receiverIFSCCode == '') {
      openPopUpDialog(manageReceiverNotifier, context);
    }
  }

  openPopUpDialog(
      ManageReceiverNotifier manageReceiverNotifier, BuildContext context) {
    //OTP popup dialog for Adding a Receiver
    manageReceiverNotifier.otpController.clear();
    return showDialog(
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: AppConstants.four, sigmaY: AppConstants.four),
            child: StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                content: SizedBox(
                  width: AppConstants.fourHundredTwenty,
                  height: getScreenWidth(context) < 340
                      ? 340
                      : getScreenHeight(context) < 700
                          ? AppConstants.twoHundredSixty
                          : 310,
                  child: SingleChildScrollView(
                    controller: manageReceiverNotifier.commonController1,
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
                                    ? 14
                                    : AppConstants.twentyTwo),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                size: AppConstants.twenty,
                                color: oxfordBlueTint400,
                              ),
                              onPressed: () {
                                setState(() {
                                  manageReceiverNotifier.isError = false;
                                });
                                MyApp.navigatorKey.currentState!.maybePop();
                                manageReceiverNotifier.otpController.clear();
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: getScreenHeight(context) * 0.02),
                        buildText(
                            text: S.of(context).enterTheOtpSendtoMobile,
                            fontSize: AppConstants.sixteen,
                            fontColor: oxfordBlueTint400),
                        SizedBox(
                            height: isWeb(context)
                                ? getScreenHeight(context) * 0.04
                                : getScreenHeight(context) * 0.02),
                        Form(
                          key: manageReceiverNotifier.addReceiverFormKey,
                          child: CommonTextField(
                              controller: manageReceiverNotifier.otpController,
                              maxLength: 6,
                              keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
                              validatorEmptyErrorText: otpIsRequired,
                              onChanged: (val) {
                                handleInteraction(context);
                                setState(() {
                                  manageReceiverNotifier.isError = false;
                                });
                              },
                              errorStyle: TextStyle(
                                  color: errorTextField,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]")),
                              ],
                              hintText: S.of(context).enterOtpHere,
                              hintStyle: hintStyle(context),
                              maxWidth: AppConstants.oneHundredAndSixty,
                              width: getScreenWidth(context),
                              maxHeight: 50,
                              suffixIcon: getScreenWidth(context) < 340
                                  ? null
                                  : manageReceiverNotifier.isTimer == false
                                      ? Padding(
                                          padding: px8DimenAll(context),
                                          child: TweenAnimationBuilder<
                                                  Duration>(
                                              duration: Duration(seconds: 120),
                                              tween: Tween(
                                                  begin: Duration(seconds: 120),
                                                  end: Duration.zero),
                                              onEnd: () {
                                                setState(() {
                                                  manageReceiverNotifier
                                                      .isTimer = true;
                                                });
                                              },
                                              builder: (BuildContext context,
                                                  Duration value,
                                                  Widget? child) {
                                                final minutes = value.inMinutes;
                                                final seconds =
                                                    value.inSeconds % 60;
                                                var sec = seconds < 10 ? 0 : '';
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
                                          onPressed: () {
                                            manageReceiverNotifier
                                                        .countryData ==
                                                    AustraliaName
                                                ? FundTransferRepository()
                                                    .generateOtp(
                                                        context, 'receiver')
                                                : FundTransferRepository()
                                                    .generateOtpSG(
                                                        context, 'Receiver');
                                            setState(() {
                                              manageReceiverNotifier.isTimer =
                                                  false;
                                            });
                                          },
                                          child: buildText(
                                              text: S.of(context).resendOtp,
                                              fontWeight:
                                                  AppFont.fontWeightSemiBold,
                                              fontColor: orangePantone),
                                        )),
                        ),
                        getScreenWidth(context) > 340
                            ? SizedBox()
                            : manageReceiverNotifier.isTimer == false
                                ? Padding(
                                    padding: px8DimenAll(context),
                                    child: TweenAnimationBuilder<Duration>(
                                        duration: Duration(seconds: 120),
                                        tween: Tween(
                                            begin: Duration(seconds: 120),
                                            end: Duration.zero),
                                        onEnd: () {
                                          manageReceiverNotifier.isTimer = true;
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
                                      manageReceiverNotifier.countryData ==
                                              AustraliaName
                                          ? FundTransferRepository()
                                              .generateOtp(context, 'receiver')
                                          : FundTransferRepository()
                                              .generateOtpSG(
                                                  context, 'Receiver');
                                      manageReceiverNotifier.isTimer = false;
                                    },
                                    child: buildText(
                                        text: S.of(context).resendOtp,
                                        fontWeight: AppFont.fontWeightSemiBold,
                                        fontColor: orangePantone)),
                        sizedBoxHeight5(context),
                        manageReceiverNotifier.isError == true
                            ? buildText(
                                text: invalidOTP,
                                fontColor: error,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                              )
                            : isWeb(context)
                                ? Text('')
                                : SizedBox(),
                        sizedBoxHeight20(context),
                        buildButton(context, onPressed: () async {
                          if (manageReceiverNotifier
                              .addReceiverFormKey.currentState!
                              .validate()) {
                            manageReceiverNotifier.isError = false;
                            if (manageReceiverNotifier.countryData ==
                                AustraliaName) {
                              //OTP Verify and Save for Australia
                              FundTransferRepository()
                                  .verifyOtp(context, manageReceiverNotifier.selectedMobileNumber,
                                      manageReceiverNotifier.otpController.text)
                                  .then((value) async {
                                VerifyOtpResponse response =
                                    value as VerifyOtpResponse;
                                if (response.message == 'OTP verified') {
                                  await manageReceiverNotifier.saveReceiver(
                                      context, isReceiverPopUpEnabled!);
                                } else {
                                  setState(() {
                                    manageReceiverNotifier.isError = true;
                                  });
                                }
                              });
                            } else {
                              //OTP Verify and Save for SG and HK
                              manageReceiverNotifier.isError = false;
                              contactRepository
                                  .apiOtpVerify(
                                      manageReceiverNotifier.otpController.text,
                                      context)
                                  .then((value) async {
                                if (value! == false) {
                                  setState(() {
                                    manageReceiverNotifier.isError = true;
                                  });
                                } else {
                                  if (value == true) {
                                    await manageReceiverNotifier.addReceiverSG(
                                        context, isReceiverPopUpEnabled!);
                                    setState(() {
                                      manageReceiverNotifier.isError = false;
                                    });
                                  }
                                }
                              });
                            }
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


  Future<void> currencyOnChanged(String val,
      ManageReceiverNotifier manageReceiverNotifier, context) async {
    //This is dropdown function of Select Currency TextField while selecting Data
    manageReceiverNotifier.overallErrorMessage = "";
    manageReceiverNotifier.OTPErrorMessage = "";

    if (val.length <= 1) {
      manageReceiverNotifier.childrens.clear();
      manageReceiverNotifier.isCountryFieldVisible = false;
    } else {
      handleInteraction(context);

      //Currency Onchange function
      if (manageReceiverNotifier.countryData == AustraliaName) {
        manageReceiverNotifier.selectedCurrencyForAus = val;
        manageReceiverNotifier.selectedIndex = manageReceiverNotifier
                .countryAusList[
                    manageReceiverNotifier.currencyAusDataStr.indexOf(val) ?? 0]
                .currencyCode ??
            val.substring(0, 3);
        manageReceiverNotifier.countryID = manageReceiverNotifier
                .countryAusList[
                    manageReceiverNotifier.currencyAusDataStr.indexOf(val) ?? 0]
                .countryId ??
            1;
      } else {
        manageReceiverNotifier.makeChildrenEmpty();
        manageReceiverNotifier.selectedIndex = val;
      }

      //Loading Country Data in Receiver Country Field.
      await manageReceiverNotifier.loadCountryDataStr();

      manageReceiverNotifier.selectedCurrency = val.substring(0, 3);

      //To clear down the textField according to country field changes
      if (manageReceiverNotifier.countryData == AustraliaName &&
          (manageReceiverNotifier.selectedIndex == "EUR" ||
              manageReceiverNotifier.selectedIndex == "USD")) {
        manageReceiverNotifier.isCountryFieldVisible = false;
        manageReceiverNotifier.selectedCountryController.text = '';
      } else if (manageReceiverNotifier.countryData == SingaporeName &&
          (manageReceiverNotifier.selectedIndex == "BDT - Bangladeshi Taka" ||
              manageReceiverNotifier.selectedIndex == "EUR - Euro" ||
              manageReceiverNotifier.selectedIndex == "USD - US Dollar" ||
              manageReceiverNotifier.selectedIndex ==
                  "PHP - Philippine Piso")) {
        manageReceiverNotifier.isCountryFieldVisible = false;
        manageReceiverNotifier.selectedCountryController.text = '';
      } else if (manageReceiverNotifier.countryData == HongKongName &&
          (manageReceiverNotifier.selectedIndex == "BDT - Bangladeshi Taka" ||
              manageReceiverNotifier.selectedIndex == "EUR - Euro" ||
              manageReceiverNotifier.selectedIndex == "USD - US Dollar" ||
              manageReceiverNotifier.selectedIndex ==
                  "PHP - Philippine Piso")) {
        manageReceiverNotifier.isCountryFieldVisible = false;
        manageReceiverNotifier.selectedCountryController.text = '';
      } else {
        manageReceiverNotifier.countryDataStr.length == 1
            ? manageReceiverNotifier.selectedCountryController.text =
                manageReceiverNotifier.countryDataStr[0]
            : null;
        manageReceiverNotifier.countryDataStr.length == 1
            ? countryOnChanged(context, manageReceiverNotifier,
                manageReceiverNotifier.countryDataStr[0])
            : null;
      }


      if (manageReceiverNotifier.countryData == AustraliaName &&
          manageReceiverNotifier.selectedIndex == "EUR") {
        if (manageReceiverNotifier.euroCountryAusDataStr.isEmpty) {
          manageReceiverNotifier.isCountryFieldVisible = false;
        } else
          Timer.periodic(Duration(milliseconds: 80), (timer) {
            manageReceiverNotifier.isCountryFieldVisible = true;
            timer.cancel();
          });
      }

      if (manageReceiverNotifier.countryData == AustraliaName &&
          manageReceiverNotifier.selectedIndex == "USD") {
        if (manageReceiverNotifier.swiftCountryDataStr.isEmpty) {
          manageReceiverNotifier.isCountryFieldVisible = false;
        } else
          Timer.periodic(Duration(milliseconds: 80), (timer) {
            manageReceiverNotifier.isCountryFieldVisible = true;
            timer.cancel();
          });
      }

      if (manageReceiverNotifier.countryDataStr.isEmpty) {
        manageReceiverNotifier.isCountryFieldVisible = false;
      } else {
        Timer.periodic(Duration(milliseconds: 80), (timer) {
          manageReceiverNotifier.isCountryFieldVisible = true;
          timer.cancel();
        });
      }

      manageReceiverNotifier.childrens.clear();
    }
  }

  void countryOnChanged(
      context, ManageReceiverNotifier manageReceiverNotifier, val) async {
    //This is dropdown function of Select Country TextField while selecting Data
    handleInteraction(context);
    manageReceiverNotifier.overallErrorMessage = "";
    manageReceiverNotifier.OTPErrorMessage = "";
    manageReceiverNotifier.isVisible = true;
    manageReceiverNotifier.selectedCountry = val ?? '';
    manageReceiverNotifier.childrens = [];

    manageReceiverNotifier.makeAusValueEmpty();


    if (manageReceiverNotifier.countryData == AustraliaName) {

      //Getting Australia data from json file
      await manageReceiverNotifier.getAusFields(context);

      //Getting Side Note for Australia data from json file
      await manageReceiverNotifier.getSideNoteList(context);

      //Adding Dynamic Fields for Philippines
      if (manageReceiverNotifier.selectedIndex == "PHP") {
        loadPHPOptions(manageReceiverNotifier, context);
        Timer.periodic(Duration(milliseconds: 5), (timer) {
          loadReceiverTypeAus(manageReceiverNotifier, context,
              isReceiverPopUp: false,
              isReceiverPopUpEnabled: isReceiverPopUpEnabled);
          manageReceiverNotifier.notifyListenersData();
          timer.cancel();
        });
      } else {

        manageReceiverNotifier.selectedIndex == "EUR" ||
                manageReceiverNotifier.selectedIndex == "USD"

        //Adding Dynamic Fields for Europe and USD
            ? Timer.periodic(Duration(milliseconds: 5), (timer) {
                manageReceiverNotifier.allCountryAusList.forEach((element) {
                  if (val == element.country) {
                    manageReceiverNotifier.countryID = element.countryId!;
                  }
                });
                loadReceiverTypeAus(manageReceiverNotifier, context,
                    isReceiverPopUp: false,
                    isReceiverPopUpEnabled: isReceiverPopUpEnabled);
                manageReceiverNotifier.notifyListenersData();
                timer.cancel();
              })

        //Adding Dynamic Fields for Other Countries
            : Timer.periodic(Duration(milliseconds: 5), (timer) {
          loadReceiverTypeAus(manageReceiverNotifier, context,
                    isReceiverPopUp: false,
                    isReceiverPopUpEnabled: isReceiverPopUpEnabled);
                manageReceiverNotifier.notifyListenersData();
                timer.cancel();
              });
      }
    } else {

      //Getting Singapore and HongKong data from API
      await manageReceiverNotifier.getData(
          context,
          manageReceiverNotifier.selectedCountry,
          manageReceiverNotifier.selectedCurrency);
      // if (manageReceiverNotifier.countryData == HongKongName &&
      //     manageReceiverNotifier.selectedCurrency == "EUR") {
      //   manageReceiverNotifier.selectedCountry = "Europe";
      // } else
        if (manageReceiverNotifier.countryData == HongKongName &&
          manageReceiverNotifier.selectedCurrency == "USD" &&
          manageReceiverNotifier.selectedCountry ==
              "United States - Local Payments") {
        manageReceiverNotifier.selectedCountry = "United States of America";
      } else if (manageReceiverNotifier.countryData == HongKongName &&
          manageReceiverNotifier.selectedCurrency == "USD") {
        manageReceiverNotifier.selectedCountry = "USSWIFT";
      }

      //Checking Receiver type for Sg and Hk
      loadReceiverTypeForSgAndHk(manageReceiverNotifier, context);
    }
  }

  loadReceiverTypeForSgAndHk(ManageReceiverNotifier manageReceiverNotifier, context) {
    manageReceiverNotifier.receiverDynamicFields.asMap().forEach(
      (index, element) async {

        //Checking Receiver type in Country
        if (element.field == "receiverType") {
          if (manageReceiverNotifier
                  .receiverDynamicFields[index].options!.length ==
              1) {
            manageReceiverNotifier.selectedReceiverTypeController.text =
                manageReceiverNotifier.receiverDynamicFields[index].options![0];
            manageReceiverNotifier.selectedReceiverType =
                manageReceiverNotifier.receiverDynamicFields[index].options![0];
            await manageReceiverNotifier.makeChildrenEmpty();
            Timer.periodic(Duration(milliseconds: 5), (timer) {

              //Load Dynamic Field Data
              loadSgHkDynamicFields(
                  manageReceiverNotifier,
                  manageReceiverNotifier
                      .receiverDynamicFields[index].options![0],
                  context);
              manageReceiverNotifier.notifyListenersData();
              timer.cancel();
            });
          } else {
            manageReceiverNotifier.selectedReceiverTypeController.text = '';
          }
          manageReceiverNotifier.finalData
              .add(manageReceiverNotifier.receiverDynamicFields[index].field);

          //Adding Dynamic data in children
          manageReceiverNotifier.childrens.add(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sizedBoxHeight10(context),
                buildText(
                    text: manageReceiverNotifier
                        .receiverDynamicFields[index].fieldLabel),
                sizedBoxHeight10(context),
                Visibility(
                  visible: manageReceiverNotifier
                      .receiverDynamicFields[index].visible!,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return CustomizeDropdown(
                        manageReceiverNotifier: manageReceiverNotifier,
                        context,
                        dropdownItems: manageReceiverNotifier
                            .receiverDynamicFields[index].options!,
                        controller: manageReceiverNotifier
                            .selectedReceiverTypeController,
                        optionsViewBuilder: (BuildContext context,
                            AutocompleteOnSelected onSelected,
                            Iterable options) {
                          return buildDropDownContainer(
                            context,
                            options: options,
                            onSelected: onSelected,
                            dropdownData: manageReceiverNotifier
                                .receiverDynamicFields[index].options!,
                            dropDownWidth: getScreenWidth(context) > 1100 &&
                                    !isReceiverPopUpEnabled!
                                ? commonWidth
                                : constraints.biggest.width,
                            dropDownHeight: options.first == 'No Data Found'
                                ? 150
                                : options.length < 5
                                    ? options.length * 50
                                    : 170,
                          );
                        },
                        width: commonWidth,
                        onChanged: (val) async {
                          handleInteraction(context);
                          manageReceiverNotifier.overallErrorMessage = "";
                          manageReceiverNotifier.OTPErrorMessage = "";
                          manageReceiverNotifier.selectedReceiverType = val!;
                          await manageReceiverNotifier.makeChildrenEmpty();
                          Timer.periodic(Duration(milliseconds: 5), (timer) {

                            //Load Dynamic Field Data
                            loadSgHkDynamicFields(
                                manageReceiverNotifier, val, context);
                            manageReceiverNotifier.notifyListenersData();
                            timer.cancel();
                          });
                        },
                        onSelected: (val) async {
                          handleInteraction(context);
                          manageReceiverNotifier.overallErrorMessage = "";
                          manageReceiverNotifier.OTPErrorMessage = "";
                          manageReceiverNotifier.selectedReceiverType = val!;
                          await manageReceiverNotifier.makeChildrenEmpty();
                          Timer.periodic(Duration(milliseconds: 5), (timer) {

                            //Load Dynamic Field Data
                            loadSgHkDynamicFields(
                                manageReceiverNotifier, val, context);
                            manageReceiverNotifier.notifyListenersData();
                            timer.cancel();
                          });
                        },
                        onSubmitted: (val) async {
                          handleInteraction(context);
                          manageReceiverNotifier.overallErrorMessage = "";
                          manageReceiverNotifier.OTPErrorMessage = "";
                          manageReceiverNotifier.selectedReceiverType = val!;
                          await manageReceiverNotifier.makeChildrenEmpty();
                          Timer.periodic(Duration(milliseconds: 5), (timer) {
                            loadSgHkDynamicFields(
                                manageReceiverNotifier, val, context);
                            manageReceiverNotifier.notifyListenersData();
                            timer.cancel();
                          });
                        },
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return '${manageReceiverNotifier.receiverDynamicFields[index].fieldLabel} is required';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                ),
                sizedBoxHeight10(context)
              ],
            ),
          );
        }
      },
    );
  }

  loadSgHkDynamicFields(ManageReceiverNotifier manageReceiverNotifier,
      String? receiverType, context) {
    manageReceiverNotifier.receiverDynamicFields.asMap().forEach(
      (i, element) {
        if (manageReceiverNotifier.receiverDynamicFields[i].fieldType ==
                "string" ||
            manageReceiverNotifier.receiverDynamicFields[i].fieldType ==
                "bankbranch") {
          //Checking Field Type. If String it is Text Field
          if (receiverType != null) {
            if ((manageReceiverNotifier.receiverDynamicFields[i].field !=
                    "Receiver Type") &&
                (manageReceiverNotifier.receiverDynamicFields[i].type ==
                        receiverType ||
                    manageReceiverNotifier.receiverDynamicFields[i].type ==
                        "Any")) {
              manageReceiverNotifier.finalData
                  .add(manageReceiverNotifier.receiverDynamicFields[i].field);

              //Adding Data in children
              manageReceiverNotifier.childrens.add(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: manageReceiverNotifier
                          .receiverDynamicFields[i].visible!,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sizedBoxHeight10(context),
                          buildText(
                            text: manageReceiverNotifier
                                            .receiverDynamicFields[i]
                                            .fieldLabel ==
                                        'IBAN' &&
                                    manageReceiverNotifier.selectedIndex ==
                                        "USD - US Dollar"
                                ? 'Account number / IBAN'
                                : manageReceiverNotifier
                                                .receiverDynamicFields[i]
                                                .fieldLabel ==
                                            'IBAN' &&
                                        manageReceiverNotifier.selectedIndex ==
                                            "USD - US Dollar"
                                    ? 'Account number / IBAN'
                                    : manageReceiverNotifier
                                        .receiverDynamicFields[i].fieldLabel,
                          ),
                          sizedBoxHeight10(context),
                          LayoutBuilder(
                            builder: (BuildContext, BoxConstraints) =>
                                CommonTextField(
                              width: commonWidth,
                              controller: manageReceiverNotifier
                                          .receiverDynamicFields[i]
                                          .fieldLabel ==
                                      "Receiver Name"
                                  ? manageReceiverNotifier.firstNameController
                                  : null,
                              onChanged: (val) {
                                handleInteraction(context);
                                if (manageReceiverNotifier
                                        .receiverDynamicFields[i].fieldLabel ==
                                    "IFSC Code") {
                                  manageReceiverNotifier.receiverIFSCCode = val;
                                  manageReceiverNotifier.errorIFSCCode = '';
                                  manageReceiverNotifier.isIFSCCodeValid =
                                      false;
                                } else if (manageReceiverNotifier
                                            .receiverDynamicFields[i]
                                            .fieldLabel ==
                                        "IBAN" ||
                                    manageReceiverNotifier
                                            .receiverDynamicFields[i]
                                            .fieldLabel ==
                                        "Account number / IBAN") {
                                  manageReceiverNotifier.receiverIBANCode = val;
                                  manageReceiverNotifier.errorIBANCode = '';
                                  manageReceiverNotifier.isIBANValid = false;
                                } else if (manageReceiverNotifier
                                        .receiverDynamicFields[i].fieldLabel ==
                                    "BIC/Swift") {
                                  manageReceiverNotifier.receiverSwiftCode =
                                      val;
                                  manageReceiverNotifier.errorSwiftCode = '';
                                  manageReceiverNotifier.isSwiftCodeValid =
                                      false;
                                } else if (manageReceiverNotifier
                                        .receiverDynamicFields[i].fieldLabel ==
                                    "ACH Number") {
                                  manageReceiverNotifier.receiverACHNumber =
                                      val;
                                  manageReceiverNotifier.errorBSBCode = '';
                                  manageReceiverNotifier.isBSBCodeValid = false;
                                } else if (manageReceiverNotifier
                                            .receiverDynamicFields[i]
                                            .fieldLabel ==
                                        "BSB Code" ||
                                    manageReceiverNotifier
                                            .receiverDynamicFields[i]
                                            .fieldLabel ==
                                        "Sort code") {
                                  manageReceiverNotifier.receiverBSBCode = val;
                                  manageReceiverNotifier.errorBSBCode = '';
                                  manageReceiverNotifier.isBSBCodeValid = false;
                                } else if (manageReceiverNotifier
                                        .receiverDynamicFields[i].fieldLabel ==
                                    "Bank Account Number") {
                                  manageReceiverNotifier.receiverAcNo = val;
                                } else if (manageReceiverNotifier
                                        .receiverDynamicFields[i].fieldLabel ==
                                    "Bank code") {
                                  manageReceiverNotifier.receiverBankCode = val;
                                } else if (manageReceiverNotifier
                                        .receiverDynamicFields[i].fieldLabel ==
                                    "Branch code") {
                                  manageReceiverNotifier.receiverBranchCode =
                                      val;
                                } else if (manageReceiverNotifier
                                        .receiverDynamicFields[i].fieldLabel ==
                                    "Financial Institution Number") {
                                  manageReceiverNotifier
                                      .receiverFinancialInstitutionCode = val;
                                } else if (manageReceiverNotifier
                                        .receiverDynamicFields[i].fieldLabel ==
                                    "Branch Transit Number") {
                                  manageReceiverNotifier
                                      .receiverBranchTransitCode = val;
                                } else if (manageReceiverNotifier
                                        .receiverDynamicFields[i].fieldLabel ==
                                    "Address") {
                                  manageReceiverNotifier.receiverResAddress =
                                      val;
                                }
                                manageReceiverNotifier
                                    .receiverDynamicFields[i].fieldLabel ==
                                    "Branch code" && manageReceiverNotifier.countryData == SingaporeName ? manageReceiverNotifier.receiverMap[
                                "branchCode"] = manageReceiverNotifier.receiverBankCode + manageReceiverNotifier.receiverBranchCode
                                    :manageReceiverNotifier.receiverMap[
                                        "${manageReceiverNotifier.receiverDynamicFields[i].field}"] =
                                    val;
                              },
                              maxLength: (manageReceiverNotifier
                                              .receiverDynamicFields[i].max !=
                                          null &&
                                      manageReceiverNotifier
                                              .receiverDynamicFields[i].max !=
                                          "" &&
                                      int.parse(manageReceiverNotifier
                                              .receiverDynamicFields[i].max
                                              .toString()) !=
                                          0)
                                  ? int.parse(manageReceiverNotifier
                                      .receiverDynamicFields[i].max
                                      .toString())
                                  : 50,
                              validatorEmptyErrorText: manageReceiverNotifier
                                          .receiverDynamicFields[i].required ==
                                      true
                                  ? manageReceiverNotifier
                                                  .receiverDynamicFields[i]
                                                  .fieldLabel ==
                                              'IBAN' &&
                                          manageReceiverNotifier
                                                  .selectedIndex ==
                                              "USD - US Dollar"
                                      ? 'Account number / IBAN is required'
                                      : '${manageReceiverNotifier.receiverDynamicFields[i].fieldLabel} is required'
                                  : null,
                              maxHeight: 50,
                              suffixIcon: manageReceiverNotifier.receiverDynamicFields[i].fieldLabel == "IFSC Code" ||
                                      manageReceiverNotifier.receiverDynamicFields[i].fieldLabel == "BIC/Swift" &&
                                          (manageReceiverNotifier.selectedCountry != "Australia" &&
                                              manageReceiverNotifier.selectedCountry !=
                                                  "Canada") ||
                                      (manageReceiverNotifier.receiverDynamicFields[i].fieldLabel == "Bank code" &&
                                          manageReceiverNotifier.selectedCountry ==
                                              "Hong Kong") ||
                                      (manageReceiverNotifier
                                                  .receiverDynamicFields[i]
                                                  .fieldLabel ==
                                              "Branch Transit Number" &&
                                          manageReceiverNotifier.selectedCountry ==
                                              "Canada") ||
                                      (manageReceiverNotifier.receiverDynamicFields[i].fieldLabel == "BSB Code" ||
                                          manageReceiverNotifier
                                                  .receiverDynamicFields[i]
                                                  .fieldLabel ==
                                              "ACH Number") ||
                                      manageReceiverNotifier
                                              .receiverDynamicFields[i]
                                              .fieldLabel ==
                                          "Sort code"
                                  ? GestureDetector(
                                      onTap: () {
                                        if (manageReceiverNotifier
                                                .receiverDynamicFields[i]
                                                .fieldLabel ==
                                            "IFSC Code") {
                                          manageReceiverNotifier
                                              .getBankDetailByBranchCode(
                                                  context,
                                                  manageReceiverNotifier
                                                      .receiverDynamicFields[i]
                                                      .fieldLabel,
                                                  "ifsc",
                                                  manageReceiverNotifier
                                                      .receiverIFSCCode);
                                        } else if (manageReceiverNotifier
                                                .receiverDynamicFields[i]
                                                .fieldLabel ==
                                            "Bank code") {
                                          manageReceiverNotifier
                                              .getBankDetailByBranchCode(
                                                  context,
                                                  manageReceiverNotifier
                                                      .receiverDynamicFields[i]
                                                      .fieldLabel,
                                                  "Bank code",
                                                  manageReceiverNotifier
                                                          .receiverBankCode +
                                                      manageReceiverNotifier
                                                          .receiverBranchCode);
                                        } else if ((manageReceiverNotifier
                                                    .receiverDynamicFields[i]
                                                    .fieldLabel ==
                                                "Branch Transit Number" &&
                                            manageReceiverNotifier
                                                    .selectedCountry ==
                                                "Canada")) {
                                          manageReceiverNotifier
                                              .getBankDetailByBranchCode(
                                            context,
                                            manageReceiverNotifier
                                                .receiverDynamicFields[i]
                                                .fieldLabel,
                                            "Branch Transit Number",
                                            manageReceiverNotifier
                                                    .receiverBranchTransitCode +
                                                "-" +
                                                manageReceiverNotifier
                                                    .receiverFinancialInstitutionCode,
                                          );
                                        } else {
                                          manageReceiverNotifier
                                              .getBankDetailByBranchCode(
                                            context,
                                            manageReceiverNotifier
                                                .receiverDynamicFields[i]
                                                .fieldLabel,
                                            manageReceiverNotifier
                                                        .receiverDynamicFields[
                                                            i]
                                                        .fieldLabel ==
                                                    "BIC/Swift"
                                                ? "swift"
                                                : (manageReceiverNotifier
                                                                .receiverDynamicFields[
                                                                    i]
                                                                .fieldLabel ==
                                                            "BSB Code" ||
                                                        manageReceiverNotifier
                                                                .receiverDynamicFields[
                                                                    i]
                                                                .fieldLabel ==
                                                            "ACH Number")
                                                    ? "ach"
                                                    : manageReceiverNotifier
                                                                .receiverDynamicFields[
                                                                    i]
                                                                .fieldLabel ==
                                                            "Sort code"
                                                        ? "bsb"
                                                        : "ifsc",
                                            manageReceiverNotifier
                                                        .receiverDynamicFields[
                                                            i]
                                                        .fieldLabel ==
                                                    "BIC/Swift"
                                                ? manageReceiverNotifier
                                                    .receiverSwiftCode
                                                : manageReceiverNotifier
                                                            .receiverDynamicFields[
                                                                i]
                                                            .fieldLabel ==
                                                        "BSB Code"
                                                    ? manageReceiverNotifier
                                                        .receiverBSBCode
                                                    : manageReceiverNotifier
                                                                .receiverDynamicFields[
                                                                    i]
                                                                .fieldLabel ==
                                                            "ACH Number"
                                                        ? manageReceiverNotifier
                                                            .receiverACHNumber
                                                        : manageReceiverNotifier
                                                                    .receiverDynamicFields[
                                                                        i]
                                                                    .fieldLabel ==
                                                                "Sort code"
                                                            ? manageReceiverNotifier
                                                                .receiverBSBCode
                                                            : manageReceiverNotifier
                                                                .receiverIFSCCode,
                                          );
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 8, 16, 8),
                                        child: Tooltip(
                                          message: manageReceiverNotifier
                                                  .receiverDynamicFields[i]
                                                  .helpText ??
                                              "",
                                          child: MouseRegion(
                                            cursor: MaterialStateMouseCursor
                                                .clickable,
                                            child: Icon(
                                              Icons.search_sharp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : ((manageReceiverNotifier.countryData == SingaporeName &&
                                          (manageReceiverNotifier.receiverDynamicFields[i].fieldLabel == "Address" &&
                                              (manageReceiverNotifier.selectedCurrency == "INR" ||
                                                  manageReceiverNotifier.selectedCurrency == "JPY" ||
                                                  manageReceiverNotifier.selectedCurrency == "LKR" ||
                                                  manageReceiverNotifier.selectedCurrency == "MYR" ||
                                                  manageReceiverNotifier.selectedCurrency == "NPR" ||
                                                  manageReceiverNotifier.selectedCurrency == "NZD" ||
                                                  manageReceiverNotifier.selectedCurrency == "PHP" ||
                                                  manageReceiverNotifier.selectedCurrency == "PKR"))))
                                      ? null
                                      : manageReceiverNotifier.receiverDynamicFields[i].helpText != null
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 8, 16, 8),
                                              child: Tooltip(
                                                message: manageReceiverNotifier
                                                    .receiverDynamicFields[i]
                                                    .helpText,
                                                child: Icon(
                                                  Icons.info,
                                                ),
                                              ),
                                            )
                                          : null,
                            ),
                          ),
                          if (manageReceiverNotifier
                                      .receiverDynamicFields[i].fieldLabel ==
                                  "Phone number" &&
                              manageReceiverNotifier.selectedCurrency == "KRW")
                            Column(
                              children: [
                                sizedBoxHeight10(context),
                                SizedBox(
                                  width: commonWidth,
                                  child: Text(
                                    "Note: Please enter the receiver's valid mobile number in Korea as they will receive an SMS with a KYC link which is required to be completed (first time receivers only).",
                                    style: noteMessageStyle(context),
                                  ),
                                ),
                              ],
                            ),
                          if (manageReceiverNotifier
                                      .receiverDynamicFields[i].fieldLabel ==
                                  "Phone number" &&
                              manageReceiverNotifier.selectedCurrency ==
                                  "CNY" &&
                              manageReceiverNotifier.countryData ==
                                  SingaporeName)
                            Column(
                              children: [
                                sizedBoxHeight10(context),
                                SizedBox(
                                  width: commonWidth,
                                  child: Text(
                                    "Note – Please enter the mobile number linked to your receiver’s debit card. This is important for the receiver to complete the verification process successfully.",
                                    style: blackTextStyle16(context),
                                  ),
                                ),
                                sizedBoxHeight10(context),
                                Container(
                                  width: commonWidth,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: orangePantone.withOpacity(0.1)),
                                  child: Text.rich(
                                    TextSpan(
                                      text:
                                          "Receiver has to be an individual who is a Chinese national. They will receive a link on their mobile to complete a verification by China Pay before they can receive the funds. ",
                                      style: blackTextStyle16(context),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "More details",
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              launchUrlString(
                                                  'https://www.singx.co/quicktransfer');
                                            },
                                          style: hanBlueTextStyle16(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (manageReceiverNotifier
                                      .receiverDynamicFields[i].fieldLabel ==
                                  "Phone number" &&
                              manageReceiverNotifier.selectedCurrency ==
                                  "CNY" &&
                              manageReceiverNotifier.countryData ==
                                  HongKongName)
                            Column(
                              children: [
                                sizedBoxHeight10(context),
                                SizedBox(
                                  width: commonWidth,
                                  child: Text(
                                    "Note: Please enter the mobile number linked to your receiver's debit card. This is important for the receiver to complete the verification process successfully.",
                                    style: blackTextStyle16(context),
                                  ),
                                ),
                              ],
                            ),
                          if (manageReceiverNotifier
                                      .receiverDynamicFields[i].fieldLabel ==
                                  "IFSC Code" ||
                              manageReceiverNotifier
                                      .receiverDynamicFields[i].fieldLabel ==
                                  "BSB Code" ||
                              manageReceiverNotifier
                                      .receiverDynamicFields[i].fieldLabel ==
                                  "ACH Number" ||
                              manageReceiverNotifier
                                      .receiverDynamicFields[i].fieldLabel ==
                                  "BIC/Swift" ||
                              manageReceiverNotifier
                                      .receiverDynamicFields[i].fieldLabel ==
                                  "Sort code" ||
                              manageReceiverNotifier
                                      .receiverDynamicFields[i].fieldLabel ==
                                  "IBAN" ||
                              manageReceiverNotifier
                                      .receiverDynamicFields[i].fieldLabel ==
                                  "Account number / IBAN")
                            Consumer<ManageReceiverNotifier>(builder:
                                (context, manageReceiverNotifier, child) {
                              if (manageReceiverNotifier
                                          .receiverDynamicFields[i]
                                          .fieldLabel ==
                                      "IFSC Code" &&
                                  manageReceiverNotifier.receiverIFSCCode != '')
                                return branchValidationMessage(context,
                                    manageReceiverNotifier.errorIFSCCode);

                              if (manageReceiverNotifier
                                          .receiverDynamicFields[i]
                                          .fieldLabel ==
                                      "BSB Code" &&
                                  manageReceiverNotifier.receiverBSBCode != '')
                                return branchValidationMessage(context,
                                    manageReceiverNotifier.errorBSBCode);

                              if (manageReceiverNotifier
                                          .receiverDynamicFields[i]
                                          .fieldLabel ==
                                      "ACH Number" &&
                                  manageReceiverNotifier.receiverACHNumber !=
                                      '')
                                return branchValidationMessage(context,
                                    manageReceiverNotifier.errorBSBCode);

                              if (manageReceiverNotifier
                                          .receiverDynamicFields[i]
                                          .fieldLabel ==
                                      "BIC/Swift" &&
                                  manageReceiverNotifier.receiverSwiftCode !=
                                      '')
                                return branchValidationMessage(context,
                                    manageReceiverNotifier.errorSwiftCode);

                              if ((manageReceiverNotifier
                                              .receiverDynamicFields[i]
                                              .fieldLabel ==
                                          "IBAN" ||
                                      manageReceiverNotifier
                                              .receiverDynamicFields[i]
                                              .fieldLabel ==
                                          "Account number / IBAN") &&
                                  manageReceiverNotifier.receiverIBANCode != '')
                                return branchValidationMessage(
                                  context,
                                  manageReceiverNotifier.errorIBANCode,
                                );

                              return SizedBox();
                            })
                        ],
                      ),
                    ),
                    sizedBoxHeight10(context),
                    if (manageReceiverNotifier
                                .receiverDynamicFields[i].fieldLabel ==
                            "IFSC Code" ||
                        manageReceiverNotifier
                                .receiverDynamicFields[i].fieldLabel ==
                            "BSB Code" ||
                        manageReceiverNotifier
                                .receiverDynamicFields[i].fieldLabel ==
                            "ACH Number" ||
                        (manageReceiverNotifier
                                    .receiverDynamicFields[i].fieldLabel ==
                                "BIC/Swift" &&
                            (manageReceiverNotifier.selectedCountry !=
                                    "Australia" &&
                                manageReceiverNotifier.selectedCountry !=
                                    "Canada")) ||
                        (manageReceiverNotifier
                                    .receiverDynamicFields[i].fieldLabel ==
                                "Bank code" &&
                            manageReceiverNotifier.selectedCountry ==
                                "Hong Kong") ||
                        (manageReceiverNotifier
                                    .receiverDynamicFields[i].fieldLabel ==
                                "Branch Transit Number" &&
                            manageReceiverNotifier.selectedCountry ==
                                "Canada") ||
                        manageReceiverNotifier
                                .receiverDynamicFields[i].fieldLabel ==
                            "Sort code")
                      Consumer<ManageReceiverNotifier>(
                        builder: (context, manageReceiverNotifier, child) {
                          return Visibility(
                            visible: manageReceiverNotifier.showIFSCData,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                sizedBoxHeight10(context),
                                buildText(text: "Bank Name"),
                                sizedBoxHeight10(context),
                                LayoutBuilder(
                                  builder: (BuildContext, BoxConstraints) =>
                                      CommonTextField(
                                    width: commonWidth,
                                    readOnly: true,
                                    controller: manageReceiverNotifier
                                        .bankNameController,
                                    onChanged: (val) {
                                      handleInteraction(context);
                                    },
                                    maxHeight: 50,
                                  ),
                                ),
                                sizedBoxHeight10(context),
                                if (manageReceiverNotifier
                                            .receiverDynamicFields[i]
                                            .fieldLabel ==
                                        "IFSC Code" ||
                                    (manageReceiverNotifier
                                                .receiverDynamicFields[i]
                                                .fieldLabel ==
                                            "Bank code" &&
                                        manageReceiverNotifier
                                                .selectedCountry ==
                                            "Hong Kong"))
                                  buildText(text: "Branch Name"),
                                if (manageReceiverNotifier
                                            .receiverDynamicFields[i]
                                            .fieldLabel ==
                                        "IFSC Code" ||
                                    (manageReceiverNotifier
                                                .receiverDynamicFields[i]
                                                .fieldLabel ==
                                            "Bank code" &&
                                        manageReceiverNotifier
                                                .selectedCountry ==
                                            "Hong Kong"))
                                  sizedBoxHeight10(context),
                                if (manageReceiverNotifier
                                            .receiverDynamicFields[i]
                                            .fieldLabel ==
                                        "IFSC Code" ||
                                    (manageReceiverNotifier
                                                .receiverDynamicFields[i]
                                                .fieldLabel ==
                                            "Bank code" &&
                                        manageReceiverNotifier
                                                .selectedCountry ==
                                            "Hong Kong"))
                                  LayoutBuilder(
                                      builder: (BuildContext, BoxConstraints) =>
                                          CommonTextField(
                                            width: commonWidth,
                                            readOnly: true,
                                            controller: manageReceiverNotifier
                                                .branchNameController,
                                            onChanged: (val) {
                                              handleInteraction(context);
                                            },
                                            maxHeight: 50,
                                          )),
                                sizedBoxHeight10(context),
                                ((manageReceiverNotifier
                                                .receiverDynamicFields[i]
                                                .fieldLabel ==
                                            "Bank code" &&
                                        manageReceiverNotifier
                                                .selectedCountry ==
                                            "Hong Kong"))
                                    ? SizedBox()
                                    : buildText(text: "Bank Address"),
                                ((manageReceiverNotifier
                                                .receiverDynamicFields[i]
                                                .fieldLabel ==
                                            "Bank code" &&
                                        manageReceiverNotifier
                                                .selectedCountry ==
                                            "Hong Kong"))
                                    ? SizedBox()
                                    : sizedBoxHeight10(context),
                                ((manageReceiverNotifier
                                                .receiverDynamicFields[i]
                                                .fieldLabel ==
                                            "Bank code" &&
                                        manageReceiverNotifier
                                                .selectedCountry ==
                                            "Hong Kong"))
                                    ? SizedBox()
                                    : LayoutBuilder(
                                        builder:
                                            (BuildContext, BoxConstraints) =>
                                                CommonTextField(
                                          width: commonWidth,
                                          readOnly: true,
                                          controller: manageReceiverNotifier
                                              .branchAddressController,
                                          onChanged: (val) {
                                            handleInteraction(context);
                                          },
                                          maxHeight: 50,
                                        ),
                                      ),
                                sizedBoxHeight10(context),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              );
            }
          } else {
            //If there is no receiver type
            manageReceiverNotifier.finalData
                .add(manageReceiverNotifier.receiverDynamicFields[i].field);
            manageReceiverNotifier.childrens.add(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: manageReceiverNotifier
                        .receiverDynamicFields[i].visible!,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sizedBoxHeight10(context),
                        buildText(
                            text: manageReceiverNotifier
                                .receiverDynamicFields[i].fieldLabel),
                        sizedBoxHeight10(context),
                        LayoutBuilder(
                          builder: (BuildContext, BoxConstraints) =>
                              CommonTextField(
                            width: commonWidth,
                            onChanged: (val) {
                              handleInteraction(context);
                              manageReceiverNotifier.finalData[i] = val;
                              manageReceiverNotifier.receiverMap[
                                      "${manageReceiverNotifier.receiverDynamicFields[i].field}"] =
                                  val;
                            },
                            maxLength: (manageReceiverNotifier
                                            .receiverDynamicFields[i].max !=
                                        null &&
                                    manageReceiverNotifier
                                            .receiverDynamicFields[i].max !=
                                        "" &&
                                    int.parse(manageReceiverNotifier
                                            .receiverDynamicFields[i].max
                                            .toString()) !=
                                        0)
                                ? int.parse(manageReceiverNotifier
                                    .receiverDynamicFields[i].max
                                    .toString())
                                : 50,
                            validatorEmptyErrorText: manageReceiverNotifier
                                        .receiverDynamicFields[i].required ==
                                    true
                                ? '${manageReceiverNotifier.receiverDynamicFields[i].fieldLabel} is required'
                                : null,
                            maxHeight: 50,
                            suffixIcon: manageReceiverNotifier
                                        .receiverDynamicFields[i].helpText !=
                                    null
                                ? Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 8, 16, 8),
                                    child: Tooltip(
                                        message: manageReceiverNotifier
                                            .receiverDynamicFields[i].helpText,
                                        child: Icon(Icons.info)),
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  sizedBoxHeight10(context),
                ],
              ),
            );
          }
        } else if (manageReceiverNotifier.receiverDynamicFields[i].fieldType ==
            'select') {
          //Checking Field Type. If Select it is Dropdown
          if (receiverType != null) {
            if ((manageReceiverNotifier.receiverDynamicFields[i].field !=
                    "receiverType") &&
                (manageReceiverNotifier.receiverDynamicFields[i].type ==
                        receiverType ||
                    manageReceiverNotifier.receiverDynamicFields[i].type ==
                        "Any")) {
              List<String>? bankName = [];
              List<String>? bankID = [];
              if (manageReceiverNotifier.receiverDynamicFields[i].field ==
                  "bank") {
                bankName = manageReceiverNotifier
                    .receiverDynamicFields[i].mapValue!
                    .map((e) => e.name ?? "")
                    .toList();
                bankID = manageReceiverNotifier
                    .receiverDynamicFields[i].mapValue!
                    .map((e) => e.id ?? "")
                    .toList();
              }
              manageReceiverNotifier.finalData.add(
                  manageReceiverNotifier.receiverDynamicFields[i].fieldLabel);
              manageReceiverNotifier.childrens.add(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: manageReceiverNotifier
                          .receiverDynamicFields[i].visible!,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sizedBoxHeight10(context),
                          buildText(
                              text: manageReceiverNotifier
                                  .receiverDynamicFields[i].fieldLabel),
                          sizedBoxHeight10(context),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              List<String>? dropDownData =
                                  manageReceiverNotifier
                                              .receiverDynamicFields[i].field ==
                                          "bank"
                                      ? bankName
                                      : manageReceiverNotifier
                                          .receiverDynamicFields[i].options;
                              return CustomizeDropdown(
                                manageReceiverNotifier: manageReceiverNotifier,
                                context,
                                dropdownItems: dropDownData,
                                controller: manageReceiverNotifier
                                    .selectedBankController,
                                optionsViewBuilder: (BuildContext context,
                                    AutocompleteOnSelected onSelected,
                                    Iterable options) {
                                  return buildDropDownContainer(
                                    context,
                                    options: options,
                                    onSelected: onSelected,
                                    dropdownData: dropDownData!,
                                    dropDownWidth:
                                        getScreenWidth(context) > 1100 &&
                                                !isReceiverPopUpEnabled!
                                            ? commonWidth
                                            : constraints.biggest.width,
                                    dropDownHeight:
                                        options.first == 'No Data Found'
                                            ? 150
                                            : options.length < 5
                                                ? options.length * 50
                                                : 170,
                                  );
                                },
                                width: commonWidth,
                                onChanged: (val) async {
                                  handleInteraction(context);
                                  if (manageReceiverNotifier
                                          .receiverDynamicFields[i].field ==
                                      "bank") {
                                    String selectedBankID = bankID![
                                            bankName?.indexOf(val ?? "") ??
                                                0] ??
                                        "";
                                    manageReceiverNotifier.receiverBankIDSG =
                                        selectedBankID;
                                    manageReceiverNotifier
                                        .getBranchListByBankID(
                                            context, selectedBankID);
                                  } else if (manageReceiverNotifier
                                          .receiverDynamicFields[i]
                                          .fieldLabel ==
                                      "Account type") {
                                    manageReceiverNotifier.receiverACType =
                                        val!;
                                  }
                                  manageReceiverNotifier.receiverMap[
                                          "${manageReceiverNotifier.receiverDynamicFields[i].field}"] =
                                      val;
                                },
                                onSelected: (val) async {
                                  handleInteraction(context);

                                  if (manageReceiverNotifier
                                          .receiverDynamicFields[i].field ==
                                      "bank") {
                                    String selectedBankID = bankID![
                                            bankName?.indexOf(val ?? "") ??
                                                0] ??
                                        "";
                                    manageReceiverNotifier.receiverBankIDSG =
                                        selectedBankID;

                                    manageReceiverNotifier
                                        .getBranchListByBankID(
                                            context, selectedBankID);
                                    manageReceiverNotifier.showBranchField =
                                        false;
                                    Timer.periodic(Duration(milliseconds: 5),
                                        (timer) {
                                      manageReceiverNotifier.showBranchField =
                                          true;
                                      timer.cancel();
                                    });
                                  } else if (manageReceiverNotifier
                                          .receiverDynamicFields[i]
                                          .fieldLabel ==
                                      "Account type") {
                                    manageReceiverNotifier.receiverACType =
                                        val!;
                                  }
                                  manageReceiverNotifier.receiverMap[
                                          "${manageReceiverNotifier.receiverDynamicFields[i].field}"] =
                                      val;
                                },
                                onSubmitted: (val) async {
                                  handleInteraction(context);

                                  if (manageReceiverNotifier
                                          .receiverDynamicFields[i].field ==
                                      "bank") {
                                    String selectedBankID = bankID![
                                            bankName?.indexOf(val ?? "") ??
                                                0] ??
                                        "";
                                    manageReceiverNotifier.receiverBankIDSG =
                                        selectedBankID;

                                    manageReceiverNotifier
                                        .getBranchListByBankID(
                                            context, selectedBankID);
                                  } else if (manageReceiverNotifier
                                          .receiverDynamicFields[i]
                                          .fieldLabel ==
                                      "Account type") {
                                    manageReceiverNotifier.receiverACType =
                                        val!;
                                  }
                                  manageReceiverNotifier.receiverMap[
                                          "${manageReceiverNotifier.receiverDynamicFields[i].field}"] =
                                      val;
                                },
                                validation: (value) {
                                  if (value!.isEmpty || value == ' ') {
                                    return manageReceiverNotifier
                                                .receiverDynamicFields[i]
                                                .required ==
                                            true
                                        ? '${manageReceiverNotifier.receiverDynamicFields[i].fieldLabel} is required'
                                        : '';
                                  }
                                  return null;
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    sizedBoxHeight10(context),
                    if (manageReceiverNotifier.receiverDynamicFields[i].field ==
                        "bank")
                      Consumer<ManageReceiverNotifier>(
                        builder: (context, manageReceiverNotifier, child) {
                          return Visibility(
                            visible: manageReceiverNotifier.showBranchData &&
                                manageReceiverNotifier.showBranchField,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildText(text: "Receiver Branch Name"),
                                sizedBoxHeight10(context),
                                LayoutBuilder(
                                  builder: (context, constraints) =>
                                      CustomizeDropdown(context,
                                          manageReceiverNotifier:
                                              manageReceiverNotifier,
                                          dropdownItems: manageReceiverNotifier
                                              .branchNameListAus,
                                          controller: manageReceiverNotifier
                                              .selectedBranchController,
                                          optionsViewBuilder: (BuildContext
                                                  context,
                                              AutocompleteOnSelected onSelected,
                                              Iterable options) {
                                            return buildDropDownContainer(
                                              context,
                                              options: options,
                                              onSelected: onSelected,
                                              dropdownData:
                                                  manageReceiverNotifier
                                                      .branchNameListAus,
                                              dropDownWidth: getScreenWidth(
                                                              context) >
                                                          1100 &&
                                                      !isReceiverPopUpEnabled!
                                                  ? commonWidth
                                                  : constraints.biggest.width,
                                              dropDownHeight: options.first ==
                                                      'No Data Found'
                                                  ? 150
                                                  : options.length < 5
                                                      ? options.length * 50
                                                      : 170,
                                            );
                                          },
                                          width: commonWidth,
                                          onChanged: (val) async {
                                            handleInteraction(context);
                                            manageReceiverNotifier
                                                .receiverBranchIDSG = val;

                                            manageReceiverNotifier
                                                .receiverMap["branch"] = val;
                                          },
                                          onSelected: (val) async {
                                            handleInteraction(context);
                                            manageReceiverNotifier
                                                .receiverBranchIDSG = val;
                                            manageReceiverNotifier
                                                .receiverMap["branch"] = val;
                                          },
                                          onSubmitted: (val) async {
                                            handleInteraction(context);
                                            manageReceiverNotifier
                                                .receiverBranchIDSG = val;
                                            manageReceiverNotifier
                                                .receiverMap["branch"] = val;
                                          },
                                          validation: (value) {
                                            if (value!.isEmpty ||
                                                value == ' ') {
                                              return manageReceiverNotifier
                                                          .receiverDynamicFields[
                                                              i]
                                                          .required ==
                                                      true
                                                  ? '${manageReceiverNotifier.receiverDynamicFields[i].fieldLabel} is required'
                                                  : '';
                                            }
                                            return null;
                                          },),
                                ),
                                sizedBoxHeight10(context),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              );
            }
          }
          else {
            //If receiver type is null
            manageReceiverNotifier.finalData
                .add(manageReceiverNotifier.receiverDynamicFields[i].field);
            manageReceiverNotifier.childrens.add(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: manageReceiverNotifier
                        .receiverDynamicFields[i].visible!,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sizedBoxHeight10(context),
                        buildText(
                            text: manageReceiverNotifier
                                .receiverDynamicFields[i].fieldLabel),
                        sizedBoxHeight10(context),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            List<String> dropdownData = manageReceiverNotifier
                                .receiverDynamicFields[i].options!;
                            return CustomizeDropdown(
                              manageReceiverNotifier: manageReceiverNotifier,
                              context,
                              dropdownItems: dropdownData,
                              controller:
                                  manageReceiverNotifier.selectedDataController,
                              optionsViewBuilder: (BuildContext context,
                                  AutocompleteOnSelected onSelected,
                                  Iterable options) {
                                return buildDropDownContainer(
                                  context,
                                  options: options,
                                  onSelected: onSelected,
                                  dropdownData: dropdownData,
                                  dropDownWidth:
                                      getScreenWidth(context) > 1100 &&
                                              !isReceiverPopUpEnabled!
                                          ? commonWidth
                                          : constraints.biggest.width,
                                  dropDownHeight:
                                      options.first == 'No Data Found'
                                          ? 150
                                          : options.length < 5
                                              ? options.length * 50
                                              : 170,
                                );
                              },
                              width: commonWidth,
                              onChanged: (val) async {
                                handleInteraction(context);
                                manageReceiverNotifier.finalData[i] = val;
                                manageReceiverNotifier.receiverMap[
                                        "${manageReceiverNotifier.receiverDynamicFields[i].field}"] =
                                    val;
                              },
                              onSelected: (val) async {
                                handleInteraction(context);
                                manageReceiverNotifier.finalData[i] = val;
                                manageReceiverNotifier.receiverMap[
                                        "${manageReceiverNotifier.receiverDynamicFields[i].field}"] =
                                    val;
                              },
                              onSubmitted: (val) async {
                                handleInteraction(context);
                                manageReceiverNotifier.finalData[i] = val;
                                manageReceiverNotifier.receiverMap[
                                        "${manageReceiverNotifier.receiverDynamicFields[i].field}"] =
                                    val;
                              },
                              validation: (value) {
                                if (value!.isEmpty || value == ' ') {
                                  return manageReceiverNotifier
                                              .receiverDynamicFields[i]
                                              .required ==
                                          true
                                      ? '${manageReceiverNotifier.receiverDynamicFields[i].fieldLabel} is required'
                                      : '';
                                }
                                return null;
                              },
                            );
                          },
                        ),
                        sizedBoxHeight10(context),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        }
        else if (manageReceiverNotifier.receiverDynamicFields[i].fieldType ==
            'date') {
          //Checking Field Type. If Date it is Date Field
          manageReceiverNotifier.finalData
              .add(manageReceiverNotifier.receiverDynamicFields[i].field);
          manageReceiverNotifier.childrens.add(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sizedBoxHeight10(context),
                buildText(
                    text: manageReceiverNotifier
                        .receiverDynamicFields[i].fieldLabel),
                sizedBoxHeight10(context),
                LayoutBuilder(
                  builder: (BuildContext, BoxConstraints) => CommonTextField(
                    helperText: '',
                    controller: manageReceiverNotifier.dateIdController,
                    keyboardType: TextInputType.none,
                    readOnly: true,
                    width: commonWidth,
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        builder: (context, child) {
                          return child!;
                        },
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null &&
                          picked != manageReceiverNotifier.dateExpiryId) {
                        manageReceiverNotifier.dateExpiryId = picked;
                        final DateFormat formatter = DateFormat('yyyy-MM-dd');
                        final String formatted = formatter.format(picked);
                        manageReceiverNotifier.dateIdController.text =
                            formatted;
                        manageReceiverNotifier.receiverMap[
                                "${manageReceiverNotifier.receiverDynamicFields[i].field}"] =
                            manageReceiverNotifier.dateIdController.text;
                      }
                    },
                    suffixIcon: Padding(
                      padding: px15DimenAll(context),
                      child: Image.asset(AppImages.calendarIcon),
                    ),
                    hintText: datePickerDynamic,
                    hintStyle: hintStyle(context),
                    validatorEmptyErrorText: "ID expiry date is required",
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  onPaginated(BuildContext context,
      ManageReceiverNotifier manageReceiverNotifier) async {
    if (manageReceiverNotifier.countryData == AustraliaName) {
      manageReceiverNotifier.pageCount =
          (manageReceiverNotifier.contentAusList.length / 10).ceil();
      int start = (manageReceiverNotifier.pageIndex! - 1) * 10;
      int end = start + 10;
      if (end > manageReceiverNotifier.contentAusList.length) {
        end = manageReceiverNotifier.contentAusList.length;
      }
      manageReceiverNotifier.contentListPaginatedAus =
          manageReceiverNotifier.contentAusList.sublist(start, end);
      ReceiverRepository receiverRepository = ReceiverRepository();
      receiverRepository.contentCount = manageReceiverNotifier.contentListPaginatedAus.length;
    } else {
      manageReceiverNotifier.url =
          '?page=${manageReceiverNotifier.pageIndex! - 1}&size=10&filter=';
      manageReceiverNotifier.getApi(context);
      manageReceiverNotifier.showLoadingIndicator = true;
    }
  }

  loadReceiverTypeAus(ManageReceiverNotifier manageReceiverNotifier, context,
      {isReceiverPopUp = false, setState, isReceiverPopUpEnabled}) async {

    //Checking Receiver type, it will load according to receiver type
    for (int i = 0; i < manageReceiverNotifier.AEDAusList.length; i++) {
      if (manageReceiverNotifier.AEDAusList[i].fieldLabel == "Receiver Type") {
        if (manageReceiverNotifier.AEDAusList[i].options!.length == 1) {
          manageReceiverNotifier.selectedReceiverTypeAUSController.text =
              manageReceiverNotifier.AEDAusList[i].options![0];
          manageReceiverNotifier.selectedReceiverType =
              manageReceiverNotifier.AEDAusList[i].options![0];

          //Getting Side note Data
          manageReceiverNotifier.getSideNoteList(context);
          await manageReceiverNotifier.makeChildrenEmpty();
          Timer.periodic(Duration(milliseconds: 5), (timer) {

            //Loading Dynamic Fields form json file
            loadAustraliaDynamicFields(manageReceiverNotifier,
                manageReceiverNotifier.AEDAusList[i].options![0], context,
                isReceiverPopUpEnabled: isReceiverPopUpEnabled);
            manageReceiverNotifier.notifyListenersData();
            timer.cancel();
          });
        } else {
          manageReceiverNotifier.selectedReceiverTypeAUSController.text = '';
        }
        manageReceiverNotifier.finalData
            .add(manageReceiverNotifier.AEDAusList[i].fieldLabel);

        //Adding data in children
        manageReceiverNotifier.childrens.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              buildText(text: manageReceiverNotifier.AEDAusList[i].fieldLabel),
              SizedBox(height: 10),
              LayoutBuilder(builder: (context, constraints) {
                List<String> dropdownData =
                    manageReceiverNotifier.AEDAusList[i].options!;
                return CustomizeDropdown(
                  manageReceiverNotifier: manageReceiverNotifier,
                  context,
                  dropdownItems: dropdownData,
                  controller:
                      manageReceiverNotifier.selectedReceiverTypeAUSController,
                  optionsViewBuilder: (BuildContext context,
                      AutocompleteOnSelected onSelected, Iterable options) {
                    return buildDropDownContainer(
                      context,
                      options: options,
                      onSelected: onSelected,
                      dropdownData: dropdownData,
                      dropDownWidth: getScreenWidth(context) > 1100 &&
                              !isReceiverPopUpEnabled!
                          ? commonWidth
                          : constraints.biggest.width,
                      dropDownHeight: options.first == 'No Data Found'
                          ? 150
                          : options.length < 5
                              ? options.length * 50
                              : 170,
                    );
                  },
                  width: commonWidth,
                  onChanged: (val) async {},
                  onSelected: (val) async {
                    handleInteraction(context);
                    manageReceiverNotifier.selectedReceiverType = val!;

                    //Getting Side note Data
                    manageReceiverNotifier.getSideNoteList(context);
                    await manageReceiverNotifier.makeChildrenEmpty();
                    Timer.periodic(Duration(milliseconds: 5), (timer) {

                      //Loading Dynamic Fields form json file
                      loadAustraliaDynamicFields(
                          manageReceiverNotifier, val, context,
                          isReceiverPopUpEnabled: isReceiverPopUpEnabled);
                      manageReceiverNotifier.notifyListenersData();
                      timer.cancel();
                    });
                  },
                  onSubmitted: (val) async {
                    handleInteraction(context);
                    manageReceiverNotifier.selectedReceiverType = val!;

                    //Getting Side Note Data
                    manageReceiverNotifier.getSideNoteList(context);
                    await manageReceiverNotifier.makeChildrenEmpty();
                    Timer.periodic(Duration(milliseconds: 5), (timer) {

                      //Loading Dynamic Fields form json file
                      loadAustraliaDynamicFields(
                          manageReceiverNotifier, val, context,
                          isReceiverPopUpEnabled: isReceiverPopUpEnabled);
                      manageReceiverNotifier.notifyListenersData();
                      timer.cancel();
                    });
                  },
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return manageReceiverNotifier.AEDAusList[i].errorLabel;
                    }
                    return null;
                  },
                );
              }),
              SizedBox(height: 10)
            ],
          ),
        );
        return;
      } else {

        //If receiver type is null

        //Loading Dynamic Fields form json file
        loadAustraliaDynamicFields(manageReceiverNotifier, null, context,
            isReceiverPopUpEnabled: isReceiverPopUpEnabled);
        return;
      }
    }
  }

  loadAustraliaDynamicFields(ManageReceiverNotifier manageReceiverNotifier,
      String? receiverType, context,
      {isReceiverPopUp = false, setState, isReceiverPopUpEnabled}) {
    manageReceiverNotifier.AEDAusList.asMap().forEach((i, element) {

      if (manageReceiverNotifier.AEDAusList[i].fieldType == "string") {

        //Checking field type if it is String, Field will be TextField
        if (receiverType != null) {

          //Checking Receiver type is not null
          if ((manageReceiverNotifier.AEDAusList[i].fieldLabel !=
                  "Receiver Type") &&
              (manageReceiverNotifier.AEDAusList[i].type == receiverType ||
                  manageReceiverNotifier.AEDAusList[i].type == "Any")) {
            if (manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                "Receiver Name") {

              //Adding Data inside children
              manageReceiverNotifier.childrens.add(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  buildText(
                      text: manageReceiverNotifier.AEDAusList[i].fieldLabel),
                  SizedBox(height: 10),
                  LayoutBuilder(
                    builder: (BuildContext, BoxConstraints) => CommonTextField(
                      width: commonWidth,
                      controller: manageReceiverNotifier.firstNameController,
                      onChanged: (val) {
                        handleInteraction(context);
                      },
                      validatorEmptyErrorText: manageReceiverNotifier
                                  .AEDAusList[i].options?.length ==
                              1
                          ? manageReceiverNotifier.AEDAusList[i].errorLabel
                          : 'First name is required',
                      hintText: manageReceiverNotifier
                                  .AEDAusList[i].options?.length ==
                              1
                          ? "Name"
                          : "First Name",
                      maxHeight: 50,
                      suffixIcon:
                          manageReceiverNotifier.AEDAusList[i].helpText != null
                              ? Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 8, 16, 8),
                                  child: Tooltip(
                                      message: manageReceiverNotifier
                                          .AEDAusList[i].helpText,
                                      child: Icon(Icons.info)),
                                )
                              : null,
                    ),
                  ),
                  SizedBox(height: 10),
                  if (manageReceiverNotifier.AEDAusList[i].options?.length == 3)
                    LayoutBuilder(
                      builder: (BuildContext, BoxConstraints) =>
                          CommonTextField(
                        width: commonWidth,
                        controller: manageReceiverNotifier.middleNameController,
                        onChanged: (val) {
                          handleInteraction(context);
                        },
                        hintText: "Middle Name (optional)",
                        maxHeight: 50,
                        suffixIcon: manageReceiverNotifier
                                    .AEDAusList[i].helpText !=
                                null
                            ? Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                                child: Tooltip(
                                    message: manageReceiverNotifier
                                        .AEDAusList[i].helpText,
                                    child: Icon(Icons.info)),
                              )
                            : null,
                      ),
                    ),
                  if (manageReceiverNotifier.AEDAusList[i].options?.length == 3)
                    SizedBox(height: 10),
                  if (manageReceiverNotifier.AEDAusList[i].options?.length ==
                          2 ||
                      manageReceiverNotifier.AEDAusList[i].options?.length == 3)
                    LayoutBuilder(
                      builder: (BuildContext, BoxConstraints) =>
                          CommonTextField(
                        width: commonWidth,
                        controller: manageReceiverNotifier.lastNameController,
                        onChanged: (val) {
                          handleInteraction(context);
                        },
                        hintText: "Last Name",
                        validatorEmptyErrorText: 'Last name is required',
                        maxHeight: 50,
                        suffixIcon: manageReceiverNotifier
                                    .AEDAusList[i].helpText !=
                                null
                            ? Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                                child: Tooltip(
                                    message: manageReceiverNotifier
                                        .AEDAusList[i].helpText,
                                    child: Icon(Icons.info)),
                              )
                            : null,
                      ),
                    ),
                  if (manageReceiverNotifier.AEDAusList[i].options?.length ==
                          2 ||
                      manageReceiverNotifier.AEDAusList[i].options?.length == 3)
                    SizedBox(height: 10),
                ],
              ));
            }
            else if(manageReceiverNotifier.AEDAusList[i].fieldLabel == "Receiver Company Name"){
              manageReceiverNotifier.childrens.add(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      buildText(
                          text: manageReceiverNotifier.AEDAusList[i].fieldLabel),
                      SizedBox(height: 10),
                      LayoutBuilder(
                        builder: (BuildContext, BoxConstraints) => CommonTextField(
                          width: commonWidth,
                          controller:
                          manageReceiverNotifier.firstNameController,
                          onChanged: (val) {
                            handleInteraction(context);
                          },
                          validatorEmptyErrorText: manageReceiverNotifier
                              .AEDAusList[i].options?.length ==
                              1
                              ? manageReceiverNotifier.AEDAusList[i].errorLabel
                              : 'Receiver Company Name is required',
                          maxHeight: 50,
                          suffixIcon: manageReceiverNotifier
                              .AEDAusList[i].helpText !=
                              null
                              ? Padding(
                            padding:
                            const EdgeInsets.fromLTRB(8, 8, 16, 8),
                            child: Tooltip(
                              message: manageReceiverNotifier
                                  .AEDAusList[i].helpText,
                              child: Icon(Icons.info,),),
                          )
                              : null,
                        ),),
                    ],
                  )
              );
            }
            else if (manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                    "Bank IFSC Code" ||
                manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                    "Receiver Sort Code" ||
                manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                    "Receiver BIC/SWIFT" ||
                manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                    "Bank Code") {
              if (manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                  "Bank Code") {
              }
              else {
                manageReceiverNotifier.childrens.add(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      buildText(
                          text:
                          (manageReceiverNotifier.selectedCurrency== "USD" && manageReceiverNotifier.selectedCountry == "United States" && manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                              "Receiver BIC/SWIFT") ? "Receiver ACH number":manageReceiverNotifier.AEDAusList[i].fieldLabel),
                      SizedBox(height: 10),
                      LayoutBuilder(
                        builder: (BuildContext, BoxConstraints) =>
                            CommonTextField(
                          width: commonWidth,
                          onChanged: (val) {
                            handleInteraction(context);
                            if (manageReceiverNotifier
                                    .AEDAusList[i].fieldLabel ==
                                "Bank IFSC Code") {
                              manageReceiverNotifier.receiverIFSCCode = val;
                            } else if (manageReceiverNotifier
                                    .AEDAusList[i].fieldLabel ==
                                "Receiver Sort Code") {
                              manageReceiverNotifier.receiverSortCode = val;
                            } else if (manageReceiverNotifier
                                    .AEDAusList[i].fieldLabel ==
                                "Receiver BIC/SWIFT") {
                              manageReceiverNotifier.receiverBicORSwift = val;
                            } else if (manageReceiverNotifier
                                    .AEDAusList[i].fieldLabel ==
                                "Branch Code") {
                              manageReceiverNotifier.receiverBranchCode = val;
                            }
                          },
                          validatorEmptyErrorText:manageReceiverNotifier.selectedCurrency== "USD" && manageReceiverNotifier.selectedCountry == "United States" && manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                              "Receiver BIC/SWIFT"?"Receiver ACH Number is required":
                        manageReceiverNotifier.AEDAusList[i].errorLabel,
                          maxHeight: 50,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              if (manageReceiverNotifier
                                      .AEDAusList[i].fieldLabel ==
                                  "Bank IFSC Code") {
                                manageReceiverNotifier.getIFSCDetails(context,
                                    isReceiverPopUp: isReceiverPopUp,
                                    setState: setState);
                              } else if (manageReceiverNotifier
                                      .AEDAusList[i].fieldLabel ==
                                  "Receiver Sort Code") {
                                manageReceiverNotifier
                                    .getSortCodeDetails(context);
                              }else if (manageReceiverNotifier
                                      .AEDAusList[i].fieldLabel ==
                                  "Receiver BIC/SWIFT" && (manageReceiverNotifier.selectedCountry == "United States" && manageReceiverNotifier.selectedCurrency == "USD")) {
                                manageReceiverNotifier
                                    .getFindByRoutingNumber(context);
                              } else if (manageReceiverNotifier
                                      .AEDAusList[i].fieldLabel ==
                                  "Receiver BIC/SWIFT") {
                                manageReceiverNotifier
                                            .receiverBicORSwift.length >
                                        1
                                    ? manageReceiverNotifier.selectedIndex ==
                                            "CAD"
                                        ? manageReceiverNotifier
                                            .getCADCodeDetails(context)
                                        : manageReceiverNotifier
                                            .getSwiftCodeDetails(context)
                                    : null;
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                              child: Tooltip(
                                message: manageReceiverNotifier
                                            .AEDAusList[i].helpText !=
                                        null
                                    ? manageReceiverNotifier.selectedCurrency== "USD" && manageReceiverNotifier.selectedCountry == "United States" && manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                                    "Receiver BIC/SWIFT" ?"Please note that we require the ACH routing number for electronic payments (not for wire payments). In most cases, the ACH number will be the same as the 9 digit ABA routing number, which can be found through the receiver's online banking portal or on their check book. Most ACH numbers are also found on bank websites. However, if you are unsure, please check directly with the receivers bank branch to ensure funds are credited to the correct account.":manageReceiverNotifier
                                        .AEDAusList[i].helpText
                                    : null,
                                child: MouseRegion(
                                    cursor: MaterialStateMouseCursor.clickable,
                                    child: Icon(Icons.search_sharp)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Consumer<ManageReceiverNotifier>(
                        builder: (context, manageReceiverNotifier, child) {
                          return Visibility(
                            visible: isReceiverPopUp
                                ? manageReceiverNotifier.showIFSCData
                                : manageReceiverNotifier.showIFSCData,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                buildText(text: "Bank Name"),
                                SizedBox(height: 10),
                                LayoutBuilder(
                                  builder: (BuildContext, BoxConstraints) =>
                                      CommonTextField(
                                    width: commonWidth,
                                    readOnly: true,
                                    controller: manageReceiverNotifier
                                        .bankNameController,
                                    onChanged: (val) {
                                      handleInteraction(context);
                                    },
                                    maxHeight: 50,
                                    validatorEmptyErrorText:
                                        manageReceiverNotifier
                                            .AEDAusList[i].errorLabel,
                                  ),
                                ),
                                SizedBox(height: 10),
                                  !(manageReceiverNotifier.selectedCountry ==
                                              "United States" &&
                                          manageReceiverNotifier
                                                  .selectedCurrency ==
                                              "USD")
                                      ? buildText(text: "Branch Name")
                                      : SizedBox(),
                                  !(manageReceiverNotifier.selectedCountry ==
                                              "United States" &&
                                          manageReceiverNotifier
                                                  .selectedCurrency ==
                                              "USD")
                                      ? SizedBox(height: 10)
                                      : SizedBox(),
                                  !(manageReceiverNotifier.selectedCountry ==
                                              "United States" &&
                                          manageReceiverNotifier
                                                  .selectedCurrency ==
                                              "USD")
                                      ? LayoutBuilder(
                                          builder: (BuildContext, BoxConstraints) =>
                                      CommonTextField(
                                    width: commonWidth,
                                    readOnly: true,
                                    controller: manageReceiverNotifier
                                        .branchNameController,
                                    onChanged: (val) {
                                      handleInteraction(context);
                                      val;
                                    },
                                    maxHeight: 50,
                                    validatorEmptyErrorText:
                                        manageReceiverNotifier
                                            .AEDAusList[i].errorLabel,
                                  ),
                                ):SizedBox(),
                                SizedBox(height: 10),
                                buildText(text: "Branch Address"),
                                SizedBox(height: 10),
                                LayoutBuilder(
                                  builder: (BuildContext, BoxConstraints) =>
                                      CommonTextField(
                                    width: commonWidth,
                                    readOnly: true,
                                    maxLines: 3,
                                    controller: manageReceiverNotifier
                                        .branchAddressController,
                                    onChanged: (val) {
                                      handleInteraction(context);
                                    },
                                    maxHeight: 50,
                                    validatorEmptyErrorText:
                                        manageReceiverNotifier
                                            .AEDAusList[i].errorLabel,
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
            }
            else {
              if (manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                  "PhoneNumber") {
                manageReceiverNotifier.phoneNumberData.forEach((key, value) {
                  if (value.contains(manageReceiverNotifier.selectedCountry) ==
                      true) {
                    manageReceiverNotifier.selectedPhoneNumberCode = key;
                  }
                  ;
                });
              }
              manageReceiverNotifier.childrens.add(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: (manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                        "Receiver Account Number / IBAN" && manageReceiverNotifier.selectedCurrency == "USD"),
                    child: SizedBox(height: 10),),
                  Visibility(
                      visible: (manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                          "Receiver Account Number / IBAN" && manageReceiverNotifier.selectedCurrency == "USD"),
                      child:                                 Container(
                        width: commonWidth,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xffCECFD5),
                              width: 1,
                            ),
                            color: white),
                        child: Text(
                          "IBAN is needed instead of account number: countries in Europe, Mauritius, Jordan, Israel, Saudi, Kuwait & UAE",
                          style: blackTextStyle16(context),
                        ),
                      ),),
                  SizedBox(height: 10),
                  buildText(
                      text: (manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                                  "Receiver Account Number / IBAN" &&
                              manageReceiverNotifier.selectedCurrency == "EUR")
                          ? "Receiver IBAN"
                          : manageReceiverNotifier.AEDAusList[i].fieldLabel),
                  SizedBox(height: 10),
                  manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                          "PhoneNumber"
                      ? LayoutBuilder(builder: (context, boxConstraint) {
                          return SizedBox(
                            width: commonWidth,
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                        height: 48,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(0xffCECFD5),
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white,
                                        ),
                                        child: Consumer<ManageReceiverNotifier>(
                                          builder: (context,
                                              manageReceiverNotifier, child) {
                                            return dropdownReceiverDynamic(
                                              context: context,
                                              selected: manageReceiverNotifier
                                                  .selectedPhoneNumberCode,
                                              myJson: manageReceiverNotifier
                                                  .phoneNumberData,
                                              onChanged: (value) {
                                                manageReceiverNotifier
                                                        .selectedPhoneNumberCode =
                                                    value;
                                              },
                                            );
                                          },
                                        )),
                                    SizedBox(
                                      height: 22,
                                    )
                                  ],
                                ),
                                getScreenWidth(context) < 345
                                    ? sizedBoxWidth5(context)
                                    : sizedBoxWidth15(context),
                                Expanded(
                                  child: CommonTextField(
                                    helperText: "",
                                    controller: manageReceiverNotifier
                                                .AEDAusList[i].fieldLabel ==
                                            "Receiver Expiry Date"
                                        ? manageReceiverNotifier
                                            .dateOfExpiryController
                                        : null,
                                    readOnly: manageReceiverNotifier
                                                .AEDAusList[i].fieldLabel ==
                                            "Receiver Expiry Date"
                                        ? true
                                        : false,
                                    maxLines: manageReceiverNotifier
                                                .AEDAusList[i].fieldLabel ==
                                            "Residence Address"
                                        ? 3
                                        : null,
                                    onTap: () async {
                                      if (manageReceiverNotifier
                                              .AEDAusList[i].fieldLabel ==
                                          "Receiver Expiry Date") {
                                        if (defaultTargetPlatform ==
                                            TargetPlatform.iOS) {
                                          iosDatePicker(
                                              context,
                                              null,
                                              manageReceiverNotifier
                                                  .dateOfExpiryController,
                                              manageReceiverNotifier:
                                                  manageReceiverNotifier);
                                        } else {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: manageReceiverNotifier
                                                        .selectedDatePicker ==
                                                    null
                                                ? DateTime.now()
                                                : manageReceiverNotifier
                                                    .selectedDatePicker!,
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2101),
                                          );
                                          if (pickedDate != null) {
                                            manageReceiverNotifier
                                                    .selectedDatePicker =
                                                pickedDate;
                                            String formattedDate =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(pickedDate);
                                            manageReceiverNotifier
                                                .dateOfExpiryController
                                                .text = formattedDate;
                                          }
                                        }
                                      }
                                    },
                                    onChanged: (val) {
                                      handleInteraction(context);
                                      if (manageReceiverNotifier
                                              .AEDAusList[i].fieldLabel ==
                                          "PhoneNumber") {
                                        manageReceiverNotifier
                                            .receiverPhoneNumber = val;
                                      } else if (manageReceiverNotifier
                                              .AEDAusList[i].fieldLabel ==
                                          "Receiver City") {
                                        manageReceiverNotifier.receiverCity =
                                            val;
                                      } else if (manageReceiverNotifier
                                              .AEDAusList[i].fieldLabel ==
                                          "Residence Address") {
                                        manageReceiverNotifier
                                            .receiverResAddress = val;
                                      } else if (manageReceiverNotifier
                                              .AEDAusList[i].fieldLabel ==
                                          "Residence Postal Code") {
                                        manageReceiverNotifier
                                            .receiverPostalCode = val;
                                      } else if (manageReceiverNotifier
                                              .AEDAusList[i].fieldLabel ==
                                          "Financial Institution Number") {
                                        manageReceiverNotifier
                                            .receiverInstitutionNumber = val;
                                      } else if (manageReceiverNotifier
                                              .AEDAusList[i].fieldLabel ==
                                          "Branch Transit Number") {
                                        manageReceiverNotifier
                                            .receiverTransitNumber = val;
                                      } else if (manageReceiverNotifier
                                              .AEDAusList[i].fieldLabel ==
                                          "Receiver Debit Card Number") {
                                        manageReceiverNotifier
                                            .receiverDebitCardNumber = val;
                                      } else if (manageReceiverNotifier
                                              .AEDAusList[i].fieldLabel ==
                                          "Bank Code") {
                                        manageReceiverNotifier
                                            .receiverBankCode = val;
                                      } else if (manageReceiverNotifier
                                              .AEDAusList[i].fieldLabel ==
                                          "Branch Code") {
                                        manageReceiverNotifier
                                            .receiverBranchCode = val;
                                      } else if (manageReceiverNotifier
                                              .AEDAusList[i].fieldLabel ==
                                          "Receiver Account Number / IBAN") {
                                        manageReceiverNotifier.receiverIBAN =
                                            val;
                                      }
                                    },
                                    validatorEmptyErrorText:
                                        manageReceiverNotifier
                                            .AEDAusList[i].errorLabel,
                                    maxHeight: 50,
                                    suffixIcon: manageReceiverNotifier
                                                .AEDAusList[i].helpText !=
                                            null
                                        ? Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 8, 16, 8),
                                            child: Tooltip(
                                                message: manageReceiverNotifier
                                                    .AEDAusList[i].helpText,
                                                child: Icon(Icons.info)),
                                          )
                                        : (manageReceiverNotifier.AEDAusList[i]
                                                        .fieldLabel ==
                                                    "Bank IFSC Code" ||
                                                manageReceiverNotifier
                                                        .AEDAusList[i]
                                                        .fieldLabel ==
                                                    "Bank Code" ||
                                                manageReceiverNotifier
                                                        .AEDAusList[i]
                                                        .fieldLabel ==
                                                    "Branch Code" ||
                                                manageReceiverNotifier
                                                        .AEDAusList[i]
                                                        .fieldLabel ==
                                                    "Receiver Sort Code" ||
                                                manageReceiverNotifier
                                                        .AEDAusList[i]
                                                        .fieldLabel ==
                                                    "Receiver BIC/SWIFT")
                                            ? GestureDetector(
                                                onTap: () {},
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 8, 16, 8),
                                                  child: Tooltip(
                                                    message:
                                                        manageReceiverNotifier
                                                            .AEDAusList[i]
                                                            .helpText,
                                                    child: MouseRegion(
                                                        cursor:
                                                            MaterialStateMouseCursor
                                                                .clickable,
                                                        child: Icon(Icons
                                                            .search_sharp)),
                                                  ),
                                                ),
                                              )
                                            : null,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },)
                      : LayoutBuilder(
                          builder: (BuildContext, BoxConstraints) =>
                              CommonTextField(
                                width: commonWidth,
                                controller: manageReceiverNotifier
                                            .AEDAusList[i].fieldLabel ==
                                        "Receiver Expiry Date"
                                    ? manageReceiverNotifier
                                        .dateOfExpiryController
                                    : null,
                                readOnly: manageReceiverNotifier
                                            .AEDAusList[i].fieldLabel ==
                                        "Receiver Expiry Date"
                                    ? true
                                    : false,
                                maxLines: manageReceiverNotifier
                                            .AEDAusList[i].fieldLabel ==
                                        "Residence Address"
                                    ? 3
                                    : null,
                                onTap: () async {
                                  if (manageReceiverNotifier
                                          .AEDAusList[i].fieldLabel ==
                                      "Receiver Expiry Date") {
                                    if (defaultTargetPlatform ==
                                        TargetPlatform.iOS) {
                                      iosDatePicker(
                                          context,
                                          null,
                                          manageReceiverNotifier
                                              .dateOfExpiryController,
                                          manageReceiverNotifier:
                                              manageReceiverNotifier);
                                    } else {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: manageReceiverNotifier
                                                    .selectedDatePicker ==
                                                null
                                            ? DateTime.now()
                                            : manageReceiverNotifier
                                                .selectedDatePicker!,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2101),
                                      );
                                      if (pickedDate != null) {
                                        manageReceiverNotifier
                                            .selectedDatePicker = pickedDate;
                                        String formattedDate =
                                            DateFormat('yyyy-MM-dd')
                                                .format(pickedDate);
                                        manageReceiverNotifier
                                            .dateOfExpiryController
                                            .text = formattedDate;
                                      }
                                    }
                                  }
                                },
                                onChanged: (val) {
                                  handleInteraction(context);
                                  if (manageReceiverNotifier
                                          .AEDAusList[i].fieldLabel ==
                                      "PhoneNumber") {
                                    manageReceiverNotifier.receiverPhoneNumber =
                                        val;
                                  } else if (manageReceiverNotifier
                                          .AEDAusList[i].fieldLabel ==
                                      "Receiver City") {
                                    manageReceiverNotifier.receiverCity = val;
                                  } else if (manageReceiverNotifier
                                          .AEDAusList[i].fieldLabel ==
                                      "Residence Address") {
                                    manageReceiverNotifier.receiverResAddress =
                                        val;
                                  } else if (manageReceiverNotifier
                                          .AEDAusList[i].fieldLabel ==
                                      "Residence Postal Code") {
                                    manageReceiverNotifier.receiverPostalCode =
                                        val;
                                  } else if (manageReceiverNotifier
                                          .AEDAusList[i].fieldLabel ==
                                      "Financial Institution Number") {
                                    manageReceiverNotifier
                                        .receiverInstitutionNumber = val;
                                  } else if (manageReceiverNotifier
                                          .AEDAusList[i].fieldLabel ==
                                      "Branch Transit Number") {
                                    manageReceiverNotifier
                                        .receiverTransitNumber = val;
                                  } else if (manageReceiverNotifier
                                          .AEDAusList[i].fieldLabel ==
                                      "Receiver Debit Card Number") {
                                    manageReceiverNotifier.receiverIBAN = val;
                                  } else if (manageReceiverNotifier
                                          .AEDAusList[i].fieldLabel ==
                                      "Bank Code") {
                                    manageReceiverNotifier.receiverBankCode =
                                        val;
                                  } else if (manageReceiverNotifier
                                          .AEDAusList[i].fieldLabel ==
                                      "Branch Code") {
                                    manageReceiverNotifier.receiverBranchCode =
                                        val;
                                  } else if (manageReceiverNotifier
                                          .AEDAusList[i].fieldLabel ==
                                      "Receiver Account Number / IBAN") {
                                    manageReceiverNotifier.receiverIBAN = val;
                                  }
                                },
                                validatorEmptyErrorText: manageReceiverNotifier
                                    .AEDAusList[i].errorLabel,
                                maxHeight: 50,
                                suffixIcon: manageReceiverNotifier
                                            .AEDAusList[i].helpText !=
                                        null
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 8, 16, 8),
                                        child: Tooltip(
                                            message: manageReceiverNotifier
                                                .AEDAusList[i].helpText,
                                            child: Icon(Icons.info)),
                                      )
                                    : (manageReceiverNotifier
                                                    .AEDAusList[i].fieldLabel ==
                                                "Bank IFSC Code" ||
                                            manageReceiverNotifier
                                                    .AEDAusList[i].fieldLabel ==
                                                "Bank Code" ||
                                            manageReceiverNotifier
                                                    .AEDAusList[i].fieldLabel ==
                                                "Branch Code" ||
                                            manageReceiverNotifier
                                                    .AEDAusList[i].fieldLabel ==
                                                "Receiver Sort Code" ||
                                            manageReceiverNotifier
                                                    .AEDAusList[i].fieldLabel ==
                                                "Receiver BIC/SWIFT")
                                        ? GestureDetector(
                                            onTap: () {},
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 8, 16, 8),
                                              child: Tooltip(
                                                message: manageReceiverNotifier
                                                    .AEDAusList[i].helpText,
                                                child: MouseRegion(
                                                    cursor:
                                                        MaterialStateMouseCursor
                                                            .clickable,
                                                    child: Icon(
                                                        Icons.search_sharp)),
                                              ),
                                            ),
                                          )
                                        : null,
                              ),),
                  SizedBox(height: 5),
                ],
              ),);
            }
          }
        }
        else {
          if (manageReceiverNotifier.AEDAusList[i].fieldLabel ==
              "Receiver Name") {
            manageReceiverNotifier.childrens.add(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                buildText(
                    text: manageReceiverNotifier.AEDAusList[i].fieldLabel),
                SizedBox(height: 10),
                LayoutBuilder(
                    builder: (BuildContext, BoxConstraints) => CommonTextField(
                          width: commonWidth,
                          controller:
                              manageReceiverNotifier.firstNameController,
                          onChanged: (val) {
                            handleInteraction(context);
                          },
                          validatorEmptyErrorText: manageReceiverNotifier
                                      .AEDAusList[i].options?.length ==
                                  1
                              ? manageReceiverNotifier.AEDAusList[i].errorLabel
                              : 'First name is required',
                          hintText: manageReceiverNotifier
                                      .AEDAusList[i].options?.length ==
                                  1
                              ? "Name"
                              : "First Name",
                          maxHeight: 50,
                          suffixIcon: manageReceiverNotifier
                                      .AEDAusList[i].helpText !=
                                  null
                              ? Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 8, 16, 8),
                                  child: Tooltip(
                                      message: manageReceiverNotifier
                                          .AEDAusList[i].helpText,
                                      child: Icon(Icons.info,),),
                                )
                              : null,
                        ),),
                SizedBox(height: 10),
                if (manageReceiverNotifier.AEDAusList[i].options?.length == 3)
                  LayoutBuilder(
                      builder: (BuildContext, BoxConstraints) =>
                          CommonTextField(
                            width: commonWidth,
                            controller:
                                manageReceiverNotifier.middleNameController,
                            onChanged: (val) {
                              handleInteraction(context);
                            },
                            hintText: "Middle Name (optional)",
                            maxHeight: 50,
                            suffixIcon: manageReceiverNotifier
                                        .AEDAusList[i].helpText !=
                                    null
                                ? Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 8, 16, 8),
                                    child: Tooltip(
                                        message: manageReceiverNotifier
                                            .AEDAusList[i].helpText,
                                        child: Icon(Icons.info)),
                                  )
                                : null,
                          )),
                if (manageReceiverNotifier.AEDAusList[i].options?.length == 3)
                  SizedBox(height: 10),
                if (manageReceiverNotifier.AEDAusList[i].options?.length == 2 ||
                    manageReceiverNotifier.AEDAusList[i].options?.length == 3)
                  LayoutBuilder(
                      builder: (BuildContext, BoxConstraints) =>
                          CommonTextField(
                            width: commonWidth,
                            controller:
                                manageReceiverNotifier.lastNameController,
                            onChanged: (val) {
                              handleInteraction(context);
                            },
                            hintText: "Last Name",
                            validatorEmptyErrorText: 'Last name is required',
                            maxHeight: 50,
                            suffixIcon: manageReceiverNotifier
                                        .AEDAusList[i].helpText !=
                                    null
                                ? Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 8, 16, 8),
                                    child: Tooltip(
                                        message: manageReceiverNotifier
                                            .AEDAusList[i].helpText,
                                        child: Icon(Icons.info)),
                                  )
                                : null,
                          ),),
                if (manageReceiverNotifier.AEDAusList[i].options?.length == 2 ||
                    manageReceiverNotifier.AEDAusList[i].options?.length == 3)
                  SizedBox(height: 10),
              ],
            ),);
          } else if (manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                  "Bank IFSC Code" ||
              manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                  "Receiver Sort Code" ||
              manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                  "Receiver BIC/SWIFT" ||
              manageReceiverNotifier.AEDAusList[i].fieldLabel == "Bank Code") {
            GlobalKey<FormState> bankCode = GlobalKey<FormState>();
            if (manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                "Bank Code") {
              manageReceiverNotifier.childrens.add(getScreenWidth(context) > 500
                  ? Form(
                      key: bankCode,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LayoutBuilder(
                            builder: (BuildContext, BoxConstraints) => SizedBox(
                              width: commonWidth,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10),
                                        buildText(
                                            text: manageReceiverNotifier
                                                        .AEDAusList[i]
                                                        .fieldLabel ==
                                                    'Branch Code'
                                                ? 'Bank Code'
                                                : manageReceiverNotifier
                                                    .AEDAusList[i].fieldLabel),
                                        SizedBox(height: 10),
                                        LayoutBuilder(
                                            builder: (BuildContext,
                                                    BoxConstraints) =>
                                                CommonTextField(
                                                  helperText: "",
                                                  width: commonWidth,
                                                  onChanged: (val) {
                                                    handleInteraction(context);
                                                    manageReceiverNotifier
                                                        .bankCode = val;
                                                  },
                                                  validatorEmptyErrorText:
                                                      manageReceiverNotifier
                                                                  .AEDAusList[i]
                                                                  .fieldLabel ==
                                                              'Branch Code'
                                                          ? 'Bank Code is required'
                                                          : manageReceiverNotifier
                                                              .AEDAusList[i]
                                                              .errorLabel,
                                                  maxHeight: 50,
                                                  suffixIcon:
                                                      manageReceiverNotifier
                                                                  .AEDAusList[i]
                                                                  .helpText !=
                                                              null
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      8,
                                                                      8,
                                                                      16,
                                                                      8),
                                                              child: Tooltip(
                                                                  message: manageReceiverNotifier
                                                                              .AEDAusList[
                                                                                  i]
                                                                              .fieldLabel ==
                                                                          'Branch Code'
                                                                      ? manageReceiverNotifier
                                                                          .AEDAusList[
                                                                              2]
                                                                          .helpText
                                                                      : manageReceiverNotifier
                                                                          .AEDAusList[
                                                                              i]
                                                                          .helpText,
                                                                  child: Icon(
                                                                      Icons
                                                                          .info)),
                                                            )
                                                          : null,
                                                ),),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                  sizedBoxWidth10(context),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10),
                                        buildText(text: "Branch Code"),
                                        SizedBox(height: 10),
                                        LayoutBuilder(
                                            builder: (BuildContext,
                                                    BoxConstraints) =>
                                                CommonTextField(
                                                  helperText: "",
                                                  width: commonWidth,
                                                  onChanged: (val) {
                                                    handleInteraction(context);
                                                    manageReceiverNotifier
                                                        .branchCode = val;
                                                  },
                                                  validatorEmptyErrorText:
                                                      manageReceiverNotifier
                                                          .AEDAusList[i]
                                                          .errorLabel,
                                                  maxHeight: 50,
                                                  suffixIcon: MouseRegion(
                                                    cursor: SystemMouseCursors
                                                        .click,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (bankCode
                                                            .currentState!
                                                            .validate()) {
                                                          manageReceiverNotifier
                                                              .getHKCodeDetails(
                                                                  context);
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                8, 8, 16, 8),
                                                        child: Tooltip(
                                                          message: manageReceiverNotifier
                                                                      .AEDAusList[
                                                                          i]
                                                                      .helpText !=
                                                                  null
                                                              ? manageReceiverNotifier
                                                                  .AEDAusList[i]
                                                                  .helpText
                                                              : "",
                                                          child: MouseRegion(
                                                              cursor:
                                                                  MaterialStateMouseCursor
                                                                      .clickable,
                                                              child: Icon(Icons
                                                                  .search_sharp)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Consumer<ManageReceiverNotifier>(
                            builder: (context, manageReceiverNotifier, child) {
                              return Visibility(
                                  visible: manageReceiverNotifier.showIFSCData,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      buildText(text: "Bank Name"),
                                      SizedBox(height: 10),
                                      LayoutBuilder(
                                          builder: (BuildContext,
                                                  BoxConstraints) =>
                                              CommonTextField(
                                                width: commonWidth,
                                                readOnly: true,
                                                controller:
                                                    manageReceiverNotifier
                                                        .bankNameController,
                                                onChanged: (val) {
                                                  handleInteraction(context);
                                                },
                                                maxHeight: 50,
                                                validatorEmptyErrorText:
                                                    manageReceiverNotifier
                                                        .AEDAusList[i]
                                                        .errorLabel,
                                              ),),
                                      SizedBox(height: 10),
                                      buildText(text: "Branch Name"),
                                      SizedBox(height: 10),
                                      LayoutBuilder(
                                          builder: (BuildContext,
                                                  BoxConstraints) =>
                                              CommonTextField(
                                                width: commonWidth,
                                                readOnly: true,
                                                controller:
                                                    manageReceiverNotifier
                                                        .branchNameController,
                                                onChanged: (val) {
                                                  handleInteraction(context);
                                                },
                                                maxHeight: 50,
                                                validatorEmptyErrorText:
                                                    manageReceiverNotifier
                                                        .AEDAusList[i]
                                                        .errorLabel,
                                              ),),
                                      SizedBox(height: 10),
                                      buildText(text: "Branch Address"),
                                      SizedBox(height: 10),
                                      LayoutBuilder(
                                          builder: (BuildContext,
                                                  BoxConstraints) =>
                                              CommonTextField(
                                                width: commonWidth,
                                                readOnly: true,
                                                controller:
                                                    manageReceiverNotifier
                                                        .branchAddressController,
                                                onChanged: (val) {
                                                  handleInteraction(context);
                                                },
                                                maxHeight: 50,
                                                validatorEmptyErrorText:
                                                    manageReceiverNotifier
                                                        .AEDAusList[i]
                                                        .errorLabel,
                                              ),),
                                      SizedBox(height: 10),
                                    ],
                                  ),);
                            },
                          )
                        ],
                      ),
                    )
                  : Form(
                      key: bankCode,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          buildText(
                              text: manageReceiverNotifier
                                          .AEDAusList[i].fieldLabel ==
                                      'Branch Code'
                                  ? 'Bank Code'
                                  : manageReceiverNotifier
                                      .AEDAusList[i].fieldLabel),
                          SizedBox(height: 10),
                          LayoutBuilder(
                              builder: (BuildContext, BoxConstraints) =>
                                  CommonTextField(
                                    width: commonWidth,
                                    onChanged: (val) {
                                      handleInteraction(context);
                                      manageReceiverNotifier.bankCode = val;
                                    },
                                    validatorEmptyErrorText:
                                        manageReceiverNotifier
                                            .AEDAusList[i].errorLabel,
                                    maxHeight: 50,
                                    suffixIcon: manageReceiverNotifier
                                                .AEDAusList[i].helpText !=
                                            null
                                        ? Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 8, 16, 8),
                                            child: Tooltip(
                                                message: manageReceiverNotifier
                                                            .AEDAusList[i]
                                                            .fieldLabel ==
                                                        'Branch Code'
                                                    ? manageReceiverNotifier
                                                        .AEDAusList[2].helpText
                                                    : manageReceiverNotifier
                                                        .AEDAusList[i].helpText,
                                                child: Icon(Icons.info)),
                                          )
                                        : null,
                                  ),),
                          SizedBox(height: 10),
                          sizedBoxWidth10(context),
                          SizedBox(height: 10),
                          buildText(text: "Branch Code"),
                          SizedBox(height: 10),
                          LayoutBuilder(
                              builder: (BuildContext, BoxConstraints) =>
                                  CommonTextField(
                                    width: commonWidth,
                                    onChanged: (val) {
                                      handleInteraction(context);
                                      manageReceiverNotifier.branchCode = val;
                                    },
                                    validatorEmptyErrorText:
                                        manageReceiverNotifier
                                            .AEDAusList[i].errorLabel,
                                    maxHeight: 50,
                                    suffixIcon: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (bankCode.currentState!
                                              .validate()) {
                                            manageReceiverNotifier
                                                .getHKCodeDetails(context);
                                          }
                                        },
                                        child: manageReceiverNotifier
                                                    .AEDAusList[i].helpText !=
                                                null
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 8, 16, 8),
                                                child: Tooltip(
                                                  message:
                                                      manageReceiverNotifier
                                                          .AEDAusList[i]
                                                          .helpText,
                                                  child: MouseRegion(
                                                      cursor:
                                                          MaterialStateMouseCursor
                                                              .clickable,
                                                      child: Icon(
                                                          Icons.search_sharp)),
                                                ),
                                              )
                                            : null,
                                      ),
                                    ),
                                  ),),
                          SizedBox(height: 10),
                          Consumer<ManageReceiverNotifier>(
                            builder: (context, manageReceiverNotifier, child) {
                              return Visibility(
                                visible: manageReceiverNotifier.showIFSCData,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    buildText(text: "Bank Name"),
                                    SizedBox(height: 10),
                                    LayoutBuilder(
                                        builder: (BuildContext,
                                                BoxConstraints) =>
                                            CommonTextField(
                                              width: commonWidth,
                                              readOnly: true,
                                              controller: manageReceiverNotifier
                                                  .bankNameController,
                                              onChanged: (val) {
                                                handleInteraction(context);
                                              },
                                              maxHeight: 50,
                                              validatorEmptyErrorText:
                                                  manageReceiverNotifier
                                                      .AEDAusList[i].errorLabel,
                                            )),
                                    SizedBox(height: 10),
                                    buildText(text: "Branch Name"),
                                    SizedBox(height: 10),
                                    LayoutBuilder(
                                        builder: (BuildContext,
                                                BoxConstraints) =>
                                            CommonTextField(
                                              width: commonWidth,
                                              readOnly: true,
                                              controller: manageReceiverNotifier
                                                  .branchNameController,
                                              onChanged: (val) {
                                                handleInteraction(context);
                                              },
                                              maxHeight: 50,
                                              validatorEmptyErrorText:
                                                  manageReceiverNotifier
                                                      .AEDAusList[i].errorLabel,
                                            ),),
                                    SizedBox(height: 10),
                                    buildText(text: "Branch Address"),
                                    SizedBox(height: 10),
                                    LayoutBuilder(
                                        builder: (BuildContext,
                                                BoxConstraints) =>
                                            CommonTextField(
                                              width: commonWidth,
                                              readOnly: true,
                                              controller: manageReceiverNotifier
                                                  .branchAddressController,
                                              maxLines: 3,
                                              onChanged: (val) {
                                                handleInteraction(context);
                                              },
                                              maxHeight: 50,
                                              validatorEmptyErrorText:
                                                  manageReceiverNotifier
                                                      .AEDAusList[i].errorLabel,
                                            ),),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),);
              i++;
            } else {

              //If ther is no receiver type

              //Adding Data inside Children
              manageReceiverNotifier.childrens.add(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    buildText(
                        text: manageReceiverNotifier.AEDAusList[i].fieldLabel),
                    SizedBox(height: 10),
                    LayoutBuilder(
                        builder: (BuildContext, BoxConstraints) =>
                            CommonTextField(
                              width: commonWidth,
                              onChanged: (val) {
                                handleInteraction(context);
                                if (manageReceiverNotifier
                                        .AEDAusList[i].fieldLabel ==
                                    "Bank IFSC Code") {
                                  manageReceiverNotifier.receiverIFSCCode = val;
                                } else if (manageReceiverNotifier
                                        .AEDAusList[i].fieldLabel ==
                                    "Receiver Sort Code") {
                                  manageReceiverNotifier.receiverSortCode = val;
                                } else if (manageReceiverNotifier
                                        .AEDAusList[i].fieldLabel ==
                                    "Receiver BIC/SWIFT") {
                                  manageReceiverNotifier.receiverBicORSwift =
                                      val;
                                } else if (manageReceiverNotifier
                                        .AEDAusList[i].fieldLabel ==
                                    "Branch Code") {
                                  manageReceiverNotifier.receiverBranchCode =
                                      val;
                                }
                              },
                              validatorEmptyErrorText: manageReceiverNotifier
                                  .AEDAusList[i].errorLabel,
                              maxHeight: 50,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  if (manageReceiverNotifier
                                          .AEDAusList[i].fieldLabel ==
                                      "Bank IFSC Code") {
                                    manageReceiverNotifier.getIFSCDetails(
                                        context,
                                        isReceiverPopUp: isReceiverPopUp,
                                        setState: setState);
                                  } else if (manageReceiverNotifier
                                          .AEDAusList[i].fieldLabel ==
                                      "Receiver Sort Code") {
                                    manageReceiverNotifier
                                        .getSortCodeDetails(context);
                                  } else if (manageReceiverNotifier
                                          .AEDAusList[i].fieldLabel ==
                                      "Receiver BIC/SWIFT") {
                                    manageReceiverNotifier
                                                .receiverBicORSwift.length >
                                            1
                                        ? manageReceiverNotifier
                                                    .selectedIndex ==
                                                "CAD"
                                            ? manageReceiverNotifier
                                                .getCADCodeDetails(context)
                                            : manageReceiverNotifier
                                                .getSwiftCodeDetails(context)
                                        : null;
                                  }
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 8, 16, 8),
                                  child: Tooltip(
                                    message: manageReceiverNotifier
                                                .AEDAusList[i].helpText !=
                                            null
                                        ? manageReceiverNotifier
                                            .AEDAusList[i].helpText
                                        : "",
                                    child: MouseRegion(
                                        cursor:
                                            MaterialStateMouseCursor.clickable,
                                        child: Icon(Icons.search_sharp)),
                                  ),
                                ),
                              ),
                            ),),
                    Consumer<ManageReceiverNotifier>(
                      builder: (context, manageReceiverNotifier, child) {
                        return Visibility(
                          visible: isReceiverPopUp
                              ? manageReceiverNotifier.showIFSCData
                              : manageReceiverNotifier.showIFSCData,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              buildText(text: "Bank Name"),
                              SizedBox(height: 10),
                              LayoutBuilder(
                                  builder: (BuildContext, BoxConstraints) =>
                                      CommonTextField(
                                        width: commonWidth,
                                        readOnly: true,
                                        controller: manageReceiverNotifier
                                            .bankNameController,
                                        onChanged: (val) {
                                          handleInteraction(context);
                                        },
                                        maxHeight: 50,
                                        validatorEmptyErrorText:
                                            manageReceiverNotifier
                                                .AEDAusList[i].errorLabel,
                                      ),),
                              SizedBox(height: 10),
                              buildText(text: "Branch Name"),
                              SizedBox(height: 10),
                              LayoutBuilder(
                                  builder: (BuildContext, BoxConstraints) =>
                                      CommonTextField(
                                        width: commonWidth,
                                        readOnly: true,
                                        controller: manageReceiverNotifier
                                            .branchNameController,
                                        onChanged: (val) {
                                          handleInteraction(context);
                                        },
                                        maxHeight: 50,
                                        validatorEmptyErrorText:
                                            manageReceiverNotifier
                                                .AEDAusList[i].errorLabel,
                                      ),),
                              SizedBox(height: 10),
                              buildText(text: "Branch Address"),
                              SizedBox(height: 10),
                              LayoutBuilder(
                                  builder: (BuildContext, BoxConstraints) =>
                                      CommonTextField(
                                        width: commonWidth,
                                        readOnly: true,
                                        maxLines: 3,
                                        controller: manageReceiverNotifier
                                            .branchAddressController,
                                        onChanged: (val) {
                                          handleInteraction(context);
                                        },
                                        maxHeight: 50,
                                        validatorEmptyErrorText:
                                            manageReceiverNotifier
                                                .AEDAusList[i].errorLabel,
                                      ),),
                              SizedBox(height: 10),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
          } else {
            if (manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                "PhoneNumber") {
              manageReceiverNotifier.phoneNumberData.forEach((key, value) {
                if (value.contains(manageReceiverNotifier.selectedCountry) ==
                    true) {
                  manageReceiverNotifier.selectedPhoneNumberCode = key;
                }
                ;
              });
            }
            if (manageReceiverNotifier.AEDAusList[i].fieldLabel !=
                "Branch Code") {
              manageReceiverNotifier.childrens.add(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  buildText(
                      text: manageReceiverNotifier.AEDAusList[i].fieldLabel),
                  SizedBox(height: 10),
                  manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                          "PhoneNumber"
                      ? LayoutBuilder(builder: (context, boxConstraints) {
                          return SizedBox(
                            width: commonWidth,
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 48,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color(0xffCECFD5),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                      ),
                                      child: Consumer<ManageReceiverNotifier>(
                                        builder: (context,
                                            manageReceiverNotifier, child) {
                                          return dropdownReceiverDynamic(
                                            context: context,
                                            selected: manageReceiverNotifier
                                                .selectedPhoneNumberCode,
                                            myJson: manageReceiverNotifier
                                                .phoneNumberData,
                                            onChanged: (value) {
                                              manageReceiverNotifier
                                                      .selectedPhoneNumberCode =
                                                  value;
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 22,
                                    ),
                                  ],
                                ),
                                getScreenWidth(context) < 345
                                    ? sizedBoxWidth5(context)
                                    : sizedBoxWidth15(context),
                                Expanded(
                                  child: CommonTextField(
                                    helperText: "",
                                    controller: manageReceiverNotifier
                                                .AEDAusList[i].fieldLabel ==
                                            "Receiver Expiry Date"
                                        ? manageReceiverNotifier
                                            .dateOfExpiryController
                                        : null,
                                    readOnly: manageReceiverNotifier
                                                .AEDAusList[i].fieldLabel ==
                                            "Receiver Expiry Date"
                                        ? true
                                        : false,
                                    maxLines: manageReceiverNotifier
                                                .AEDAusList[i].fieldLabel ==
                                            "Residence Address"
                                        ? 3
                                        : null,
                                    onTap: () async {
                                      if (manageReceiverNotifier
                                              .AEDAusList[i].fieldLabel ==
                                          "Receiver Expiry Date") {
                                        if (defaultTargetPlatform ==
                                            TargetPlatform.iOS) {
                                          iosDatePicker(
                                              context,
                                              null,
                                              manageReceiverNotifier
                                                  .dateOfExpiryController,
                                              manageReceiverNotifier:
                                                  manageReceiverNotifier);
                                        } else {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: manageReceiverNotifier
                                                        .selectedDatePicker ==
                                                    null
                                                ? DateTime.now()
                                                : manageReceiverNotifier
                                                    .selectedDatePicker!,
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2101),
                                          );
                                          if (pickedDate != null) {
                                            manageReceiverNotifier
                                                    .selectedDatePicker =
                                                pickedDate;
                                            String formattedDate =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(pickedDate);
                                            manageReceiverNotifier
                                                .dateOfExpiryController
                                                .text = formattedDate;
                                          }
                                        }
                                      }
                                    },
                                    onChanged: (val) {
                                      handleInteraction(context);
                                      if (manageReceiverNotifier
                                              .AEDAusList[i].fieldLabel ==
                                          "PhoneNumber") {
                                        manageReceiverNotifier
                                            .receiverPhoneNumber = val;
                                      } else if (manageReceiverNotifier
                                              .AEDAusList[i].fieldLabel ==
                                          "Receiver City") {
                                        manageReceiverNotifier.receiverCity =
                                            val;
                                      } else if (manageReceiverNotifier
                                              .AEDAusList[i].fieldLabel ==
                                          "Residence Address") {
                                        manageReceiverNotifier
                                            .receiverResAddress = val;
                                      } else if (manageReceiverNotifier
                                              .AEDAusList[i].fieldLabel ==
                                          "Residence Postal Code") {
                                        manageReceiverNotifier
                                            .receiverPostalCode = val;
                                      } else if (manageReceiverNotifier
                                              .AEDAusList[i].fieldLabel ==
                                          "Financial Institution Number") {
                                        manageReceiverNotifier
                                            .receiverInstitutionNumber = val;
                                      } else if (manageReceiverNotifier
                                              .AEDAusList[i].fieldLabel ==
                                          "Branch Transit Number") {
                                        manageReceiverNotifier
                                            .receiverTransitNumber = val;
                                      } else if (manageReceiverNotifier
                                              .AEDAusList[i].fieldLabel ==
                                          "Receiver Debit Card Number") {
                                        manageReceiverNotifier
                                            .receiverDebitCardNumber = val;
                                      } else if (manageReceiverNotifier
                                              .AEDAusList[i].fieldLabel ==
                                          "Bank Code") {
                                        manageReceiverNotifier
                                            .receiverBankCode = val;
                                      } else if (manageReceiverNotifier
                                              .AEDAusList[i].fieldLabel ==
                                          "Branch Code") {
                                        manageReceiverNotifier
                                            .receiverBranchCode = val;
                                      } else if (manageReceiverNotifier
                                              .AEDAusList[i].fieldLabel ==
                                          "Receiver Account Number / IBAN") {
                                        manageReceiverNotifier.receiverIBAN =
                                            val;
                                      }
                                    },
                                    validatorEmptyErrorText:
                                        manageReceiverNotifier
                                            .AEDAusList[i].errorLabel,
                                    maxHeight: 50,
                                    suffixIcon: manageReceiverNotifier
                                                .AEDAusList[i].helpText !=
                                            null
                                        ? Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 8, 16, 8),
                                            child: Tooltip(
                                                message: manageReceiverNotifier
                                                    .AEDAusList[i].helpText,
                                                child: Icon(Icons.info)),
                                          )
                                        : (manageReceiverNotifier.AEDAusList[i]
                                                        .fieldLabel ==
                                                    "Bank IFSC Code" ||
                                                manageReceiverNotifier
                                                        .AEDAusList[i]
                                                        .fieldLabel ==
                                                    "Bank Code" ||
                                                manageReceiverNotifier
                                                        .AEDAusList[i]
                                                        .fieldLabel ==
                                                    "Branch Code" ||
                                                manageReceiverNotifier
                                                        .AEDAusList[i]
                                                        .fieldLabel ==
                                                    "Receiver Sort Code" ||
                                                manageReceiverNotifier
                                                        .AEDAusList[i]
                                                        .fieldLabel ==
                                                    "Receiver BIC/SWIFT")
                                            ? GestureDetector(
                                                onTap: () {},
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 8, 16, 8),
                                                  child: Tooltip(
                                                    message:
                                                        manageReceiverNotifier
                                                            .AEDAusList[i]
                                                            .helpText,
                                                    child: MouseRegion(
                                                        cursor:
                                                            MaterialStateMouseCursor
                                                                .clickable,
                                                        child: Icon(Icons
                                                            .search_sharp)),
                                                  ),
                                                ),
                                              )
                                            : null,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },)
                      : LayoutBuilder(
                          builder: (BuildContext, BoxConstraints) =>
                              CommonTextField(
                                width: commonWidth,
                                controller: manageReceiverNotifier
                                            .AEDAusList[i].fieldLabel ==
                                        "Receiver Expiry Date"
                                    ? manageReceiverNotifier
                                        .dateOfExpiryController
                                    : null,
                                readOnly: manageReceiverNotifier
                                            .AEDAusList[i].fieldLabel ==
                                        "Receiver Expiry Date"
                                    ? true
                                    : false,
                                maxLines: manageReceiverNotifier
                                            .AEDAusList[i].fieldLabel ==
                                        "Residence Address"
                                    ? 3
                                    : null,
                                onTap: () async {
                                  if (manageReceiverNotifier
                                          .AEDAusList[i].fieldLabel ==
                                      "Receiver Expiry Date") {
                                    if (defaultTargetPlatform ==
                                        TargetPlatform.iOS) {
                                      iosDatePicker(
                                          context,
                                          null,
                                          manageReceiverNotifier
                                              .dateOfExpiryController,
                                          manageReceiverNotifier:
                                              manageReceiverNotifier);
                                    } else {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: manageReceiverNotifier
                                                    .selectedDatePicker ==
                                                null
                                            ? DateTime.now()
                                            : manageReceiverNotifier
                                                .selectedDatePicker!,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2101),
                                      );
                                      if (pickedDate != null) {
                                        manageReceiverNotifier
                                            .selectedDatePicker = pickedDate;
                                        String formattedDate =
                                            DateFormat('yyyy-MM-dd')
                                                .format(pickedDate);
                                        manageReceiverNotifier
                                            .dateOfExpiryController
                                            .text = formattedDate;
                                      }
                                    }
                                  }
                                },
                                onChanged: (val) {
                                  handleInteraction(context);
                                  if (manageReceiverNotifier
                                          .AEDAusList[i].fieldLabel ==
                                      "PhoneNumber") {
                                    manageReceiverNotifier.receiverPhoneNumber =
                                        val;
                                  } else if (manageReceiverNotifier
                                          .AEDAusList[i].fieldLabel ==
                                      "Receiver City") {
                                    manageReceiverNotifier.receiverCity = val;
                                  } else if (manageReceiverNotifier
                                          .AEDAusList[i].fieldLabel ==
                                      "Residence Address") {
                                    manageReceiverNotifier.receiverResAddress =
                                        val;
                                  } else if (manageReceiverNotifier
                                          .AEDAusList[i].fieldLabel ==
                                      "Residence Postal Code") {
                                    manageReceiverNotifier.receiverPostalCode =
                                        val;
                                  } else if (manageReceiverNotifier
                                          .AEDAusList[i].fieldLabel ==
                                      "Financial Institution Number") {
                                    manageReceiverNotifier
                                        .receiverInstitutionNumber = val;
                                  } else if (manageReceiverNotifier
                                          .AEDAusList[i].fieldLabel ==
                                      "Branch Transit Number") {
                                    manageReceiverNotifier
                                        .receiverTransitNumber = val;
                                  } else if (manageReceiverNotifier
                                          .AEDAusList[i].fieldLabel ==
                                      "Receiver Debit Card Number") {
                                    manageReceiverNotifier.receiverIBAN = val;
                                  } else if (manageReceiverNotifier
                                          .AEDAusList[i].fieldLabel ==
                                      "Bank Code") {
                                    manageReceiverNotifier.receiverBankCode =
                                        val;
                                  } else if (manageReceiverNotifier
                                          .AEDAusList[i].fieldLabel ==
                                      "Branch Code") {
                                    manageReceiverNotifier.receiverBranchCode =
                                        val;
                                  } else if (manageReceiverNotifier
                                          .AEDAusList[i].fieldLabel ==
                                      "Receiver Account Number / IBAN") {
                                    manageReceiverNotifier.receiverIBAN = val;
                                  }
                                },
                                validatorEmptyErrorText: manageReceiverNotifier
                                    .AEDAusList[i].errorLabel,
                                maxHeight: 50,
                                suffixIcon: manageReceiverNotifier
                                            .AEDAusList[i].helpText !=
                                        null
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 8, 16, 8),
                                        child: Tooltip(
                                            message: manageReceiverNotifier
                                                .AEDAusList[i].helpText,
                                            child: Icon(Icons.info)),
                                      )
                                    : (manageReceiverNotifier
                                                    .AEDAusList[i].fieldLabel ==
                                                "Bank IFSC Code" ||
                                            manageReceiverNotifier
                                                    .AEDAusList[i].fieldLabel ==
                                                "Bank Code" ||
                                            manageReceiverNotifier
                                                    .AEDAusList[i].fieldLabel ==
                                                "Branch Code" ||
                                            manageReceiverNotifier
                                                    .AEDAusList[i].fieldLabel ==
                                                "Receiver Sort Code" ||
                                            manageReceiverNotifier
                                                    .AEDAusList[i].fieldLabel ==
                                                "Receiver BIC/SWIFT")
                                        ? GestureDetector(
                                            onTap: () {},
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 8, 16, 8),
                                              child: Tooltip(
                                                message: manageReceiverNotifier
                                                    .AEDAusList[i].helpText,
                                                child: MouseRegion(
                                                    cursor:
                                                        MaterialStateMouseCursor
                                                            .clickable,
                                                    child: Icon(
                                                        Icons.search_sharp)),
                                              ),
                                            ),
                                          )
                                        : null,
                              ),),
                  SizedBox(height: 5),
                ],
              ),);
            }
            if (manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                    "PhoneNumber" &&
                manageReceiverNotifier.selectedCurrency == "CNY") {
              manageReceiverNotifier.childrens.add(Container(
                width: commonWidth,
                padding: EdgeInsets.all(10),
                decoration:
                    BoxDecoration(color: orangePantone.withOpacity(0.1)),
                child: Text.rich(
                  TextSpan(
                    text:
                        "Receiver has to be an individual who is a Chinese national. They will receive a link on their mobile to complete a verification by China Pay before they can receive the funds. ",
                    style: blackTextStyle16(context),
                    children: <TextSpan>[
                      TextSpan(
                        text: "More details",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrlString(
                                'https://www.singx.co/quicktransfer');
                          },
                        style: hanBlueTextStyle16(context),
                      ),
                    ],
                  ),
                ),
              ),);
            }
          }
        }
      }
      else if (manageReceiverNotifier.AEDAusList[i].fieldType == 'select') {
          //Checking field type if it is select. Field will be Dropdown
          if (receiverType != null) {
            //Checking receiver type is not null
            if ((manageReceiverNotifier.AEDAusList[i].fieldLabel !=
                    "Receiver Type") &&
                (manageReceiverNotifier.AEDAusList[i].type == receiverType ||
                    manageReceiverNotifier.AEDAusList[i].type == "Any")) {
              //Adding Data in children
              manageReceiverNotifier.childrens.add(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    buildText(
                        text: manageReceiverNotifier.AEDAusList[i].fieldLabel),
                    SizedBox(height: 10),
                    LayoutBuilder(builder: (context, constraints) {
                      List<String> dropDownData = [];
                      if (manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                              "Receiver Nationality" ||
                          manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                              "Country Of Incorporation") {
                        dropDownData =
                            manageReceiverNotifier.nationalityAusDataStr;
                      } else if (manageReceiverNotifier
                                  .AEDAusList[i].fieldLabel ==
                              "Receiver Bank Name" ||
                          manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                              "Receiver Pay-Out Partner") {
                        dropDownData = manageReceiverNotifier.bankNameListAus;
                      } else if (manageReceiverNotifier
                              .AEDAusList[i].fieldLabel ==
                          "Relationship With Sender") {
                        dropDownData =
                            manageReceiverNotifier.relationshipListAus;
                      } else if (manageReceiverNotifier
                              .AEDAusList[i].fieldLabel ==
                          "Residence State") {
                        dropDownData = manageReceiverNotifier.stateListDataStr;
                      } else if (manageReceiverNotifier
                              .AEDAusList[i].fieldLabel ==
                          "Receiver Place Of Issue") {
                        dropDownData =
                            manageReceiverNotifier.swiftCountryDataStr;
                      } else {
                        dropDownData =
                            manageReceiverNotifier.AEDAusList[i].options!;
                      }
                      return CustomizeDropdown(
                        context,
                        manageReceiverNotifier: manageReceiverNotifier,
                        dropdownItems: dropDownData,
                        controller:
                            manageReceiverNotifier.selectedDataController,
                        optionsViewBuilder: (BuildContext context,
                            AutocompleteOnSelected onSelected,
                            Iterable options) {
                          return buildDropDownContainer(
                            context,
                            options: options,
                            onSelected: onSelected,
                            dropdownData: dropDownData,
                            dropDownWidth: getScreenWidth(context) > 1100 &&
                                    !isReceiverPopUpEnabled!
                                ? commonWidth
                                : constraints.biggest.width,
                            dropDownHeight: options.first == 'No Data Found'
                                ? 150
                                : options.length < 5
                                    ? options.length * 50
                                    : 170,
                          );
                        },
                        width: commonWidth,
                        onChanged: (val) => onChangedFunction(
                            context, val, manageReceiverNotifier, i),
                        onSelected: (val) => onChangedFunction(
                            context, val, manageReceiverNotifier, i),
                        onSubmitted: (val) => onChangedFunction(
                            context, val, manageReceiverNotifier, i),
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return manageReceiverNotifier
                                .AEDAusList[i].errorLabel;
                          }
                          return null;
                        },
                      );
                    }),
                    SizedBox(height: 10),
                  ],
                ),
              );
            }
          } else {
            manageReceiverNotifier.childrens.add(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  buildText(
                      text: manageReceiverNotifier.AEDAusList[i].fieldLabel),
                  SizedBox(height: 10),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      List<String> dropDownData = [];
                      if (manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                          "Receiver Nationality") {
                        dropDownData =
                            manageReceiverNotifier.nationalityAusDataStr;
                      } else if (manageReceiverNotifier
                                  .AEDAusList[i].fieldLabel ==
                              "Receiver Bank Name" ||
                          manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                              "Receiver Pay-Out Partner") {
                        dropDownData = manageReceiverNotifier.bankNameListAus;
                      } else if (manageReceiverNotifier
                              .AEDAusList[i].fieldLabel ==
                          "Relationship With Sender") {
                        dropDownData =
                            manageReceiverNotifier.relationshipListAus;
                      } else if (manageReceiverNotifier
                              .AEDAusList[i].fieldLabel ==
                          "Residence State") {
                        dropDownData = manageReceiverNotifier.stateListDataStr;
                      } else if (manageReceiverNotifier
                              .AEDAusList[i].fieldLabel ==
                          "Receiver Place Of Issue") {
                        dropDownData =
                            manageReceiverNotifier.swiftCountryDataStr;
                      } else {
                        dropDownData =
                            manageReceiverNotifier.AEDAusList[i].options!;
                      }
                      return CustomizeDropdown(
                        context,
                        manageReceiverNotifier: manageReceiverNotifier,
                        dropdownItems: dropDownData,
                        controller:
                            manageReceiverNotifier.selectedBankController,
                        optionsViewBuilder: (BuildContext context,
                            AutocompleteOnSelected onSelected,
                            Iterable options) {
                          return buildDropDownContainer(
                            context,
                            options: options,
                            onSelected: onSelected,
                            dropdownData: dropDownData,
                            dropDownWidth: getScreenWidth(context) > 1100 &&
                                    !isReceiverPopUpEnabled!
                                ? commonWidth
                                : constraints.biggest.width,
                            dropDownHeight: options.first == 'No Data Found'
                                ? 150
                                : options.length < 5
                                    ? options.length * 50
                                    : 170,
                          );
                        },
                        width: commonWidth,
                        onChanged: (val) => onChangedFunction(
                            context, val, manageReceiverNotifier, i),
                        onSelected: (val) => onChangedFunction(
                            context, val, manageReceiverNotifier, i),
                        onSubmitted: (val) => onChangedFunction(
                            context, val, manageReceiverNotifier, i),
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return manageReceiverNotifier
                                .AEDAusList[i].errorLabel;
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  if (manageReceiverNotifier.selectedIndex == "NPR" &&
                      (manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                              "Receiver Bank Name" ||
                          manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                              "Receiver Pay-Out Partner"))
                    Consumer<ManageReceiverNotifier>(
                      builder: (context, manageReceiverNotifier, child) {
                        return Visibility(
                          visible: manageReceiverNotifier.showBranchName,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              buildText(text: "Receiver Branch Name"),
                              SizedBox(height: 10),
                              LayoutBuilder(
                                builder: (context, constraints) =>
                                    CustomizeDropdown(
                                  manageReceiverNotifier:
                                      manageReceiverNotifier,
                                  context,
                                  dropdownItems:
                                      manageReceiverNotifier.branchNameListAus,
                                  controller: manageReceiverNotifier
                                      .selectedBranchController,
                                  optionsViewBuilder: (BuildContext context,
                                      AutocompleteOnSelected onSelected,
                                      Iterable options) {
                                    return buildDropDownContainer(
                                      context,
                                      options: options,
                                      onSelected: onSelected,
                                      dropdownData: manageReceiverNotifier
                                          .branchNameListAus,
                                      dropDownWidth:
                                          getScreenWidth(context) > 1100 &&
                                                  !isReceiverPopUpEnabled!
                                              ? commonWidth
                                              : constraints.biggest.width,
                                      dropDownHeight:
                                          options.first == 'No Data Found'
                                              ? 150
                                              : options.length < 5
                                                  ? options.length * 50
                                                  : 170,
                                    );
                                  },
                                  width: commonWidth,
                                  onChanged: (val) {
                                    handleInteraction(context);
                                    manageReceiverNotifier.receiverBranchID =
                                        manageReceiverNotifier
                                                .branchDetailsList[
                                                    manageReceiverNotifier
                                                        .branchNameListAus
                                                        .indexOf(val!)]
                                                .branchId ??
                                            1;
                                  },
                                  onSelected: (val) {
                                    handleInteraction(context);
                                    manageReceiverNotifier.receiverBranchID =
                                        manageReceiverNotifier
                                                .branchDetailsList[
                                                    manageReceiverNotifier
                                                        .branchNameListAus
                                                        .indexOf(val!)]
                                                .branchId ??
                                            1;
                                  },
                                  onSubmitted: (val) {
                                    handleInteraction(context);
                                    manageReceiverNotifier.receiverBranchID =
                                        manageReceiverNotifier
                                                .branchDetailsList[
                                                    manageReceiverNotifier
                                                        .branchNameListAus
                                                        .indexOf(val!)]
                                                .branchId ??
                                            1;
                                  },
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return manageReceiverNotifier
                                          .AEDAusList[i].errorLabel;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        );
                      },
                    ),
                  if (manageReceiverNotifier.selectedIndex == "BDT" &&
                      manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                          "Receiver Account Type")
                    Consumer<ManageReceiverNotifier>(
                      builder: (context, manageReceiverNotifier, child) {
                        return Visibility(
                          visible:
                              manageReceiverNotifier.receiverACType == "Bank",
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              buildText(text: "Receiver Bank Name"),
                              SizedBox(height: 10),
                              LayoutBuilder(
                                builder: (context, constraints) =>
                                    CustomizeDropdown(
                                  manageReceiverNotifier:
                                      manageReceiverNotifier,
                                  context,
                                  dropdownItems:
                                      manageReceiverNotifier.bankNameListAus,
                                  controller: manageReceiverNotifier
                                      .selectedBankController,
                                  optionsViewBuilder: (BuildContext context,
                                      AutocompleteOnSelected onSelected,
                                      Iterable options) {
                                    return buildDropDownContainer(
                                      context,
                                      options: options,
                                      onSelected: onSelected,
                                      dropdownData: manageReceiverNotifier
                                          .bankNameListAus,
                                      dropDownWidth:
                                          getScreenWidth(context) > 1100 &&
                                                  !isReceiverPopUpEnabled!
                                              ? commonWidth
                                              : constraints.biggest.width,
                                      dropDownHeight:
                                          options.first == 'No Data Found'
                                              ? 150
                                              : options.length < 5
                                                  ? options.length * 50
                                                  : 170,
                                    );
                                  },
                                  width: commonWidth,
                                  onChanged: (val) {
                                    handleInteraction(context);
                                    manageReceiverNotifier.receiverBankName =
                                        val!;
                                    manageReceiverNotifier.receiverBankID =
                                        manageReceiverNotifier
                                                .bankDetailsList[
                                                    manageReceiverNotifier
                                                            .bankNameListAus
                                                            .indexOf(val) ??
                                                        0]
                                                .bankId ??
                                            1;
                                    manageReceiverNotifier
                                        .getBranchNameListAus(context);
                                  },
                                  onSelected: (val) {
                                    handleInteraction(context);
                                    manageReceiverNotifier.receiverBankName =
                                        val!;
                                    manageReceiverNotifier.receiverBankID =
                                        manageReceiverNotifier
                                                .bankDetailsList[
                                                    manageReceiverNotifier
                                                            .bankNameListAus
                                                            .indexOf(val) ??
                                                        0]
                                                .bankId ??
                                            1;
                                    manageReceiverNotifier
                                        .getBranchNameListAus(context);
                                    manageReceiverNotifier.showBranchName =
                                        false;
                                    Timer.periodic(Duration(milliseconds: 80),
                                        (timer) {
                                      manageReceiverNotifier.showBranchName =
                                          true;
                                      timer.cancel();
                                    });
                                  },
                                  onSubmitted: (val) {
                                    handleInteraction(context);
                                    manageReceiverNotifier.receiverBankName =
                                        val!;
                                    manageReceiverNotifier.receiverBankID =
                                        manageReceiverNotifier
                                                .bankDetailsList[
                                                    manageReceiverNotifier
                                                            .bankNameListAus
                                                            .indexOf(val) ??
                                                        0]
                                                .bankId ??
                                            1;
                                    manageReceiverNotifier
                                        .getBranchNameListAus(context);
                                  },
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return manageReceiverNotifier
                                          .AEDAusList[i].errorLabel;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: 15),
                              Visibility(
                                visible: manageReceiverNotifier.showBranchName,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildText(text: "Receiver Branch Name"),
                                    SizedBox(height: 10),
                                    LayoutBuilder(
                                      builder: (context, constraints) =>
                                          CustomizeDropdown(
                                        manageReceiverNotifier:
                                            manageReceiverNotifier,
                                        context,
                                        dropdownItems: manageReceiverNotifier
                                            .branchNameListAus,
                                        controller: manageReceiverNotifier
                                            .selectedBranchController,
                                        optionsViewBuilder: (BuildContext
                                                context,
                                            AutocompleteOnSelected onSelected,
                                            Iterable options) {
                                          return buildDropDownContainer(
                                            context,
                                            options: options,
                                            onSelected: onSelected,
                                            dropdownData: manageReceiverNotifier
                                                .branchNameListAus,
                                            dropDownWidth:
                                                getScreenWidth(context) >
                                                            1100 &&
                                                        !isReceiverPopUpEnabled!
                                                    ? commonWidth
                                                    : constraints.biggest.width,
                                            dropDownHeight:
                                                options.first == 'No Data Found'
                                                    ? 150
                                                    : options.length < 5
                                                        ? options.length * 50
                                                        : 170,
                                          );
                                        },
                                        width: commonWidth,
                                        onChanged: (val) {
                                          handleInteraction(context);
                                          manageReceiverNotifier
                                                  .receiverBranchID =
                                              manageReceiverNotifier
                                                      .branchDetailsList[
                                                          manageReceiverNotifier
                                                              .branchNameListAus
                                                              .indexOf(val!)]
                                                      .branchId ??
                                                  1;
                                        },
                                        onSelected: (val) {
                                          handleInteraction(context);
                                          manageReceiverNotifier
                                                  .receiverBranchID =
                                              manageReceiverNotifier
                                                      .branchDetailsList[
                                                          manageReceiverNotifier
                                                              .branchNameListAus
                                                              .indexOf(val!)]
                                                      .branchId ??
                                                  1;
                                        },
                                        onSubmitted: (val) {
                                          handleInteraction(context);
                                          manageReceiverNotifier
                                                  .receiverBranchID =
                                              manageReceiverNotifier
                                                      .branchDetailsList[
                                                          manageReceiverNotifier
                                                              .branchNameListAus
                                                              .indexOf(val!)]
                                                      .branchId ??
                                                  1;
                                        },
                                        validation: (value) {
                                          if (value == null || value.isEmpty) {
                                            return manageReceiverNotifier
                                                .AEDAusList[i].errorLabel;
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  if (manageReceiverNotifier.selectedIndex == "BDT" &&
                      manageReceiverNotifier.AEDAusList[i].fieldLabel ==
                          "Receiver Account Type")
                    Consumer<ManageReceiverNotifier>(
                      builder: (context, manageReceiverNotifier, child) {
                        return Visibility(
                          visible: manageReceiverNotifier.receiverACType ==
                              "E-Wallet",
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              buildText(text: "Receiver E-Wallet Name"),
                              SizedBox(height: 10),
                              LayoutBuilder(
                                builder: (context, constraints) =>
                                    CustomizeDropdown(
                                  manageReceiverNotifier:
                                      manageReceiverNotifier,
                                  context,
                                  dropdownItems:
                                      manageReceiverNotifier.eWalletListAus,
                                  controller: manageReceiverNotifier
                                      .selectedDataController,
                                  optionsViewBuilder: (BuildContext context,
                                      AutocompleteOnSelected onSelected,
                                      Iterable options) {
                                    return buildDropDownContainer(
                                      context,
                                      options: options,
                                      onSelected: onSelected,
                                      dropdownData:
                                          manageReceiverNotifier.eWalletListAus,
                                      dropDownWidth:
                                          getScreenWidth(context) > 1100 &&
                                                  !isReceiverPopUpEnabled!
                                              ? commonWidth
                                              : constraints.biggest.width,
                                      dropDownHeight:
                                          options.first == 'No Data Found'
                                              ? 150
                                              : options.length < 5
                                                  ? options.length * 50
                                                  : 170,
                                    );
                                  },
                                  width: commonWidth,
                                  onChanged: (val) {
                                    handleInteraction(context);
                                    manageReceiverNotifier.receiverBankID =
                                        3982;
                                    manageReceiverNotifier
                                        .getBranchNameListAus(context);
                                  },
                                  onSelected: (val) {
                                    handleInteraction(context);
                                    manageReceiverNotifier.receiverBankID =
                                        3982;
                                    manageReceiverNotifier
                                        .getBranchNameListAus(context);
                                  },
                                  onSubmitted: (val) {
                                    handleInteraction(context);
                                    manageReceiverNotifier.receiverBankID =
                                        3982;
                                    manageReceiverNotifier
                                        .getBranchNameListAus(context);
                                  },
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return manageReceiverNotifier
                                          .AEDAusList[i].errorLabel;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        );
                      },
                    )
                ],
              ),
            );
          }
        }
      },);
  }

  loadPHPOptions(ManageReceiverNotifier manageReceiverNotifier, context) {

    //Adding Php option in childrens
    manageReceiverNotifier.childrens.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              buildText(text: "Transfer PHP Via:"),
              GestureDetector(
                onTap: () {
                  manageReceiverNotifier.transferValue = 0;
                  manageReceiverNotifier.countryID = 10000273;
                  manageReceiverNotifier.getAusFields(context);
                  manageReceiverNotifier.getSideNoteList(context);
                  manageReceiverNotifier.childrens = [];
                  manageReceiverNotifier.makeAusValueEmpty();

                  Timer.periodic(Duration(milliseconds: 5), (timer) {
                    loadPHPOptions(manageReceiverNotifier, context);
                    loadReceiverTypeAus(manageReceiverNotifier, context,
                        isReceiverPopUp: false,
                        isReceiverPopUpEnabled: isReceiverPopUpEnabled);
                    manageReceiverNotifier.notifyListenersData();
                    timer.cancel();
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: manageReceiverNotifier.transferValue == 0
                            ? Colors.blueAccent
                            : Colors.grey),
                  ),
                  child: Icon(
                    Icons.circle,
                    size: 10,
                    color: manageReceiverNotifier.transferValue == 0
                        ? Colors.blueAccent
                        : Colors.white,
                  ),
                ),
              ),
              Text("Bank Transfer"),
              GestureDetector(
                onTap: () {
                  manageReceiverNotifier.transferValue = 1;
                  manageReceiverNotifier.countryID = 10000278;
                  manageReceiverNotifier.getAusFields(context);
                  manageReceiverNotifier.getSideNoteList(context);
                  manageReceiverNotifier.childrens = [];
                  Timer.periodic(Duration(milliseconds: 5), (timer) {
                    loadPHPOptions(manageReceiverNotifier, context);
                    loadReceiverTypeAus(manageReceiverNotifier, context,
                        isReceiverPopUp: false,
                        isReceiverPopUpEnabled: isReceiverPopUpEnabled);
                    manageReceiverNotifier.notifyListenersData();
                    timer.cancel();
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: manageReceiverNotifier.transferValue == 1
                            ? Colors.blueAccent
                            : Colors.grey),
                  ),
                  child: Icon(
                    Icons.circle,
                    size: 10,
                    color: manageReceiverNotifier.transferValue == 1
                        ? Colors.blueAccent
                        : Colors.white,
                  ),
                ),
              ),
              Text("Cash"),
            ],
          ),
        ],
      ),
    );
  }

  onChangedFunction(context, val, manageReceiverNotifier, i) async {

    //On Change Function Australia Dropdown fields
    handleInteraction(context);

    if (manageReceiverNotifier.AEDAusList[i].fieldLabel ==
        "Receiver Nationality" || manageReceiverNotifier.AEDAusList[i].fieldLabel ==
    "Country Of Incorporation") {
      manageReceiverNotifier.receiverNationality = val!;
    } else if (manageReceiverNotifier.AEDAusList[i].fieldLabel ==
        "Receiver Type") {
      manageReceiverNotifier.receiverType = val!;
    } else if (manageReceiverNotifier.AEDAusList[i].fieldLabel ==
        "Receiver Id Type") {
      manageReceiverNotifier.receiverIDType = val!;
    } else if (manageReceiverNotifier.AEDAusList[i].fieldLabel ==
        "Receiver Place Of Issue") {
      manageReceiverNotifier.receiverPlaceOfIssue = val!;
    } else if (manageReceiverNotifier.AEDAusList[i].fieldLabel ==
            "Receiver Bank Name" ||
        manageReceiverNotifier.AEDAusList[i].fieldLabel ==
            "Receiver Pay-Out Partner") {
      manageReceiverNotifier.receiverBankName = val!;
      manageReceiverNotifier.receiverBankID = manageReceiverNotifier
              .bankDetailsList[
                  manageReceiverNotifier.bankNameListAus.indexOf(val) ?? 0]
              .bankId ??
          1;
      await manageReceiverNotifier.getBranchNameListAus(context);
      manageReceiverNotifier.receiverBranchID =
          manageReceiverNotifier.branchDetailsList[0].branchId ?? 1;
      manageReceiverNotifier.showBranchName = false;
      Timer.periodic(Duration(milliseconds: 80), (timer) {
        manageReceiverNotifier.showBranchName = true;
        timer.cancel();
      });
    } else if (manageReceiverNotifier.AEDAusList[i].fieldLabel ==
        "Receiver Account Type") {
      manageReceiverNotifier.receiverACType = val!;
    } else if (manageReceiverNotifier.AEDAusList[i].fieldLabel ==
        "Residence State") {
      manageReceiverNotifier.receiverState = val!;
      int data = manageReceiverNotifier.stateListDataStr.indexOf(val);
      manageReceiverNotifier.receiverStateId = manageReceiverNotifier.stateListDataId[data];
    } else if (manageReceiverNotifier.AEDAusList[i].fieldLabel ==
        "Relationship With Sender") {
      manageReceiverNotifier.receiverRelationshipWithSender = val!;
    }
  }
}

class CustomSliverChildBuilderDelegateReceiver
    extends SliverChildBuilderDelegate with ChangeNotifier {
  CustomSliverChildBuilderDelegateReceiver(builder) : super(builder);

  @override
  int get childCount => receiverRepository.contentCount;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    return true;
  }

  @override
  bool shouldRebuild(
      covariant CustomSliverChildBuilderDelegateReceiver oldDelegate) {
    return true;
  }
}
