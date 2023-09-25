import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/service/rate_alert_repository.dart';
import 'package:singx/core/models/request_response/rate_alert/UpdateAlertRequest.dart';
import 'package:singx/core/models/request_response/rate_alert/save_alert_request.dart';
import 'package:singx/core/notifier/rate_alert_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/main.dart';
import 'package:singx/utils/common/app_colors.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_font.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_text_style.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/common/page_scaffold/page_scaffold.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RateAlerts extends StatelessWidget {
  RateAlertRepository rateAlertRepository = RateAlertRepository();

  @override
  Widget build(BuildContext context) {
    userCheck(context);
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return PageScaffold(
      title: 'Rate Alert',
      color: bankDetailsBackground,
      appbar: PreferredSize(
        preferredSize: Size.fromHeight(AppConstants.appBarHeight),
        child: buildCustomAppBar(context),
      ),
      body: ChangeNotifierProvider(
        create: (context) => RateAlertNotifier(context),
        child: Consumer<RateAlertNotifier>(
            builder: (context, rateAlertNotifier, _) {
          return SingleChildScrollView(
            controller: rateAlertNotifier.scrollController,
            child: Padding(
              padding: px20DimenAll(context),
              child: getScreenWidth(context) > 1155 ||
                      getScreenWidth(context) < 1060 &&
                          getScreenWidth(context) > 920
                  ? Row(
                      children: [
                        buildSetAlert(context, rateAlertNotifier),
                        sizedBoxwidth20(context),
                        buildEditAlert(context, rateAlertNotifier),
                      ],
                    )
                  : Column(
                      children: [
                        buildSetAlert(context, rateAlertNotifier),
                        sizedBoxHeight20(context),
                        Visibility(
                            visible: rateAlertNotifier.contentList.isNotEmpty,
                            child: buildEditAlert(context, rateAlertNotifier)),
                      ],
                    ),
            ),
          );
        }),
      ),
    );
  }

  Widget buildSetAlert(
      BuildContext context, RateAlertNotifier rateAlertNotifier) {
    return Container(
      height: getScreenWidth(context) < 300
          ? 850
          : getScreenWidth(context) < 380
              ? 780
              : getScreenWidth(context) < 450
                  ? 750
                  : getScreenHeight(context) > 900
                      ? 750
                      : 650,
      width: getScreenWidth(context) <= 920
          ? getScreenWidth(context) * 0.95
          : getScreenWidth(context) <= 1060
              ? getScreenWidth(context) * 0.45
              : getScreenWidth(context) > 1060 &&
                      getScreenWidth(context) <= 1155
                  ? getScreenWidth(context) * 0.8
                  : getScreenWidth(context) <= 1250
                      ? getScreenWidth(context) * 0.37
                      : getScreenWidth(context) <= 1365
                          ? getScreenWidth(context) * 0.38
                          : getScreenWidth(context) * 0.39,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radiusAll5(context),
          boxShadow: [
            BoxShadow(
              color: listTileexpansionColor.withOpacity(0.10),
              blurRadius: AppConstants.thirty,
              offset: Offset(
                0,
                AppConstants.fifteen,
              ),
            ),
          ],
          border: Border.all(color: dividercolor, width: AppConstants.one)),
      child: Padding(
        padding: px24DimenAll(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  text: 'Email: ${rateAlertNotifier.email}',
                  fontWeight: AppFont.fontWeightRegular,
                  fontSize: AppConstants.sixteen,
                ),
                sizedBoxHeight5(context),
                buildText(
                  text: 'Mobile: ${rateAlertNotifier.mobileNumber}',
                  fontWeight: AppFont.fontWeightRegular,
                  fontSize: AppConstants.sixteen,
                ),
              ],
            ),
            SizedBoxHeight(context, 0.03),
            MySeparator(color: dottedLineColor),
            SizedBoxHeight(context, 0.03),
            buildText(
              text: S.of(context).selectCurrencyPair,
              fontSize: AppConstants.sixteen,
              fontColor: oxfordBlueTint500,
            ),
            SizedBoxHeight(context, 0.01),
            CommonDropDownField(
              maxHeight: 150,
              width: getScreenWidth(context),
              hintText: S.of(context).select,
              hintStyle: hintStyle(context),
              items: rateAlertNotifier.currencyDataApi,
              onChanged: (val) {
                handleInteraction(context);
                rateAlertNotifier.selectedIndex = val!;
                rateAlertNotifier.getSelectedCorridorId();
              },
            ),
            SizedBoxHeight(context, 0.02),
            buildText(
              text: S.of(context).selectAlertType,
              fontWeight: FontWeight.w700,
              fontSize: AppConstants.sixteen,
              fontColor: oxfordBlueTint500,
            ),
            SizedBoxHeight(context, 0.0),
            ListTile(
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 0,
              leading: buildCheckBox(
                rateAlertNotifier.alertMe,
                (bool? value) {
                  rateAlertNotifier.alertMe = value!;
                },
              ),
              title: GestureDetector(
                onTap: () {
                  rateAlertNotifier.alertMe == true
                      ? rateAlertNotifier.alertMe = false
                      : rateAlertNotifier.alertMe = true;
                },
                child: buildText(
                  text: 'Alert me if 1 SGD reaches INR,',
                  fontSize: AppConstants.sixteen,
                  fontColor: oxfordBlueTint500,
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Selector<RateAlertNotifier, TextEditingController>(
                          builder: (context, INRController, child) {
                            return CommonTextField(
                                onChanged: (val) {
                                  handleInteraction(context);
                                },
                                controller: INRController,
                                width: AppConstants.hundred,
                                hintText: 'eg.100 INR',
                                height: AppConstants.fortyTwo,
                                hintStyle: hintStyle(context));
                          },
                          selector: (buildContext, editProfileNotifier) =>
                              editProfileNotifier.INRController),
                    ),
                  ],
                ),
                sizedBoxHeight10(context),
                buildText(text: 'Via', fontSize: AppConstants.sixteen),
                sizedBoxHeight10(context),
                Row(
                  children: [
                    Expanded(
                      child: CommonDropDownField(
                        showSearchBox: false,
                        onChanged: (val) {
                          handleInteraction(context);
                          rateAlertNotifier.alertMode = val!;
                        },
                        selectedItem: "Email",
                        maxHeight: 150,
                        items: alertMeVia,
                        width: AppConstants.hundred,
                        hintText: 'Email',
                        height: 42,
                        hintStyle: hintStyle(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            getScreenWidth(context) < 500
                ? sizedBoxHeight10(context)
                : getScreenWidth(context) >= 920 &&
                        getScreenWidth(context) < 1020
                    ? sizedBoxHeight10(context)
                    : getScreenWidth(context) >= 1155 &&
                            getScreenWidth(context) < 1240
                        ? sizedBoxHeight10(context)
                        : SizedBox(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 0,
              leading: buildCheckBox(
                rateAlertNotifier.alertVia,
                (bool? value) {
                  rateAlertNotifier.alertVia = value!;
                },
              ),
              title: GestureDetector(
                onTap: () {
                  rateAlertNotifier.alertVia == true
                      ? rateAlertNotifier.alertVia = false
                      : rateAlertNotifier.alertVia = true;
                },
                child: buildText(
                  text: 'Alert me when the rate is at its two-week high ,',
                  fontSize: 16,
                  fontColor: Color(0xff424B5C),
                ),
              ),
            ),
            SizedBoxHeight(context, 0.04),
            buildButton(context,
                name: 'Set alerts',
                width: getScreenWidth(context), onPressed: () async {
              if ((rateAlertNotifier.alertMe == false &&
                      rateAlertNotifier.alertVia == false) ||
                  rateAlertNotifier.selectedCorridorId.length < 1) {
                showMessageDialog(context, "Please select require fields");
              } else {
                int? status = await rateAlertRepository.apiSaveAlert(
                    SaveAlertRequest(
                      corridor: "${rateAlertNotifier.selectedCorridorId}",
                      alertType: rateAlertNotifier.alertMe &&
                              rateAlertNotifier.alertVia
                          ? "3"
                          : rateAlertNotifier.alertVia
                              ? "2"
                              : "1",
                      alertRate: int.parse(
                          rateAlertNotifier.INRController.text.length == 0
                              ? "0"
                              : rateAlertNotifier.INRController.text),
                      alertMode: rateAlertNotifier.alertMode == "BOTH"
                          ? "3"
                          : rateAlertNotifier.alertMode == "SMS"
                              ? "2"
                              : "1",
                    ),
                    context,
                    rateAlertNotifier.selectedCountry == AppConstants.singapore
                        ? "SGD"
                        : "HKD",
                    "save");
                if (status == 1) {
                  rateAlertNotifier.alertList(
                    context,
                    rateAlertNotifier.selectedCountry == AppConstants.singapore
                        ? "SGD"
                        : "HKD",
                  );
                  rateAlertNotifier.enable = false;
                  rateAlertNotifier.INRController.clear();
                  rateAlertNotifier.alertMode = '';
                  rateAlertNotifier.alertVia = false;
                  rateAlertNotifier.alertMe = false;
                }
              }
            }, color: Color(0xff3F70D4), fontColor: white),
            SizedBoxHeight(
                context, getScreenWidth(context) < 320 ? 0.02 : 0.04),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text:
                          'Note: You can create one alert per currency pair for each alert type. For more details please refer to the ',
                      style: textSpan1(context)),
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchUrlString(
                            "https://uat.singx.co/singx/719be3430b91/Help.html",
                          );
                        },
                      text: 'FAQs',
                      style: textSpan2Bold(context)),
                ],
              ),
            ),
            SizedBoxHeight(context, 0.01)
          ],
        ),
      ),
    );
  }

  Widget buildEditAlert(
      BuildContext context, RateAlertNotifier rateAlertNotifier) {
    return Container(
      height: isMobile(context)
          ? null
          : getScreenWidth(context) < 300
              ? 850
              : getScreenWidth(context) < 380
                  ? 780
                  : getScreenWidth(context) < 450
                      ? 750
                      : getScreenHeight(context) > 900
                          ? 750
                          : 650,
      width: getScreenWidth(context) <= 920
          ? getScreenWidth(context) * 0.95
          : getScreenWidth(context) <= 1060
              ? getScreenWidth(context) * 0.45
              : getScreenWidth(context) > 1060 &&
                      getScreenWidth(context) <= 1155
                  ? getScreenWidth(context) * 0.8
                  : getScreenWidth(context) <= 1250
                      ? getScreenWidth(context) * 0.37
                      : getScreenWidth(context) <= 1365
                          ? getScreenWidth(context) * 0.38
                          : getScreenWidth(context) * 0.39,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Color(0xffE8E8E8), width: 1)),
      child: Padding(
        padding: px12DimenAll(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildText(
                text: 'Alerts', fontWeight: FontWeight.w700, fontSize: 20),
            SizedBoxHeight(context, 0.02),
            isMobile(context)
                ? listOfAlert(context, rateAlertNotifier)
                : Expanded(child: listOfAlert(context, rateAlertNotifier)),
            !rateAlertNotifier.enable
                ? SizedBox()
                : buildButton(context, name: 'Delete alert',
                    onPressed: () async {
                    int? status = await rateAlertRepository.apiDeleteAlert(
                        context, rateAlertNotifier.deleteId);
                    if (status == 1) {
                      rateAlertNotifier.alertList(
                          context,
                          rateAlertNotifier.selectedCountry ==
                                  AppConstants.singapore
                              ? "SGD"
                              : "HKD");
                      rateAlertNotifier.enable = false;
                    }
                  },
                    width: getScreenWidth(context),
                    color: error,
                    fontColor: white),
            SizedBoxHeight(context, 0.025)
          ],
        ),
      ),
    );
  }

  Widget buildCheckBox(value, onchanged) {
    return GestureDetector(
      onTap: () => onchanged,
      child: Container(
        height: 30,
        width: 30,
        color: Colors.transparent,
        child: Theme(
          data: ThemeData(
            checkboxTheme: CheckboxThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          child: Checkbox(
            side: const BorderSide(width: 1, color: fieldBorderColorNew),
            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
            value: value,
            onChanged: onchanged,
          ),
        ),
      ),
    );
  }

  Widget listOfAlert(
    BuildContext context,
    RateAlertNotifier rateAlertNotifier,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: isMobile(context)
          ? NeverScrollableScrollPhysics()
          : AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          children: [
            sizedBoxHeight24(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 3.5),
                  child: buildCheckBox(
                    rateAlertNotifier.isChecked[index],
                    (value) {
                      rateAlertNotifier.isChecked
                          .asMap()
                          .forEach((index, element) {
                        rateAlertNotifier.changeCheckedIndexValue(index, false);
                      });
                      rateAlertNotifier.changeCheckedIndexValue(index, value);
                      if (value == true) {
                        rateAlertNotifier.deleteId =
                            "${rateAlertNotifier.contentList[index].subscribeId}";
                        rateAlertNotifier.enable = true;
                      } else {
                        rateAlertNotifier.enable = false;
                      }
                    },
                  ),
                ),
                sizedBoxWidth8(context),
                sizedBoxWidth8(context),
                Expanded(
                  child: buildText(
                    text:
                        '${rateAlertNotifier.contentList[index].alertTypeString}',
                    fontSize: 16,
                    fontColor: Color(0xff424B5C),
                  ),
                ),
                sizedBoxWidth8(context),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      rateAlertNotifier.corridorList.forEach((element) {
                        if (rateAlertNotifier
                                .contentList[index].corridor!.corridorId! ==
                            element.key) {
                          rateAlertNotifier.corridorId = element.value!;
                        }
                      });
                      updateAlertDialog(
                        rateAlertNotifier,
                        context,
                        rateAlertNotifier.contentList[index].subscribeId!,
                        rateAlertNotifier.contentList[index].alertMode!,
                        rateAlertNotifier.contentList[index].alertType!,
                        rateAlertNotifier.contentList[index].currencyRate
                            .toString(),
                        rateAlertNotifier.corridorId,
                        rateAlertNotifier.contentList[index].alertMode! == 3
                            ? "BOTH"
                            : rateAlertNotifier.contentList[index].alertMode! ==
                                    2
                                ? "SMS"
                                : "Email",
                      );
                    },
                    child: Image.asset('assets/images/edit-2.png',
                        height: 24, width: 24),
                  ),
                ),
              ],
            ),
            sizedBoxHeight24(context),
            Divider(),
          ],
        );
      },
      itemCount: rateAlertNotifier.contentList.length,
    );
  }

  updateAlertDialog(
    RateAlertNotifier rateAlertNotifier,
    BuildContext context,
    String id,
    int alertMode,
    int alertType,
    String amount,
    String corridorId,
    String selectedType,
  ) {
    rateAlertNotifier.INRControllerPopup.text = amount;
    rateAlertNotifier.selectedTypePopUp = alertType == 1
        ? "Email"
        : alertType == 2
            ? "SMS"
            : "BOTH";
    rateAlertNotifier.alertMePopUp = alertType == 1 ? true : false;
    rateAlertNotifier.alertViaPopup = alertType == 2 ? true : false;
    if (alertType == 3) {
      rateAlertNotifier.alertMePopUp = true;
      rateAlertNotifier.alertViaPopup = true;
    }
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AppInActiveCheck(
        context: context,
        child: AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: StatefulBuilder(
            builder: (context, setState) {
              return IntrinsicHeight(
                child: buildUpdateAlert(context, setState, rateAlertNotifier,
                    id, corridorId, selectedType),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildUpdateAlert(
      BuildContext context,
      StateSetter setState,
      RateAlertNotifier rateAlertNotifier,
      String id,
      String corridorId,
      String selectedType) {
    return Container(
      width: isMobile(context) || isTab(context)
          ? getScreenWidth(context) * 0.80
          : getScreenWidth(context) < 1060
              ? getScreenWidth(context) * 0.70
              : getScreenWidth(context) < 1200
                  ? getScreenWidth(context) * 0.45
                  : getScreenWidth(context) * 0.39,
      height: getScreenWidth(context) > 700
          ? MediaQuery.of(context).size.height * 0.8
          : MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radiusAll5(context),
          boxShadow: [
            BoxShadow(
              color: listTileexpansionColor.withOpacity(0.10),
              blurRadius: AppConstants.thirty,
              offset: Offset(
                0,
                AppConstants.fifteen,
              ),
            ),
          ],
          border: Border.all(color: dividercolor, width: AppConstants.one)),
      child: SingleChildScrollView(
        controller: rateAlertNotifier.scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 15,
                right: 20,
                bottom: 10,
              ),
              child: GestureDetector(
                onTap: () {
                  MyApp.navigatorKey.currentState!.maybePop();
                  // Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                ),
              ),
            ),
            Padding(
              padding: px24NoTopDimen(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildText(
                        text: 'Email: ${rateAlertNotifier.email}',
                        fontWeight: AppFont.fontWeightRegular,
                        fontSize: AppConstants.sixteen,
                      ),
                      sizedBoxHeight10(context),
                      buildText(
                        text: 'Mobile: ${rateAlertNotifier.mobileNumber}',
                        fontWeight: AppFont.fontWeightRegular,
                        fontSize: AppConstants.sixteen,
                      ),
                    ],
                  ),
                  SizedBoxHeight(context, 0.03),
                  MySeparator(color: dottedLineColor),
                  SizedBoxHeight(context, 0.03),
                  buildText(
                    text: S.of(context).selectCurrencyPair,
                    fontSize: AppConstants.sixteen,
                    fontColor: oxfordBlueTint500,
                  ),
                  SizedBoxHeight(context, 0.01),
                  CommonDropDownField(
                    onChanged: (val) {
                      handleInteraction(context);
                      for (int i = 0;
                          i < rateAlertNotifier.contentList.length;
                          i++) {
                        if (val ==
                            rateAlertNotifier
                                .contentList[i].corridor!.corridorId) ;
                      }
                    },
                    maxHeight: 150,
                    width: getScreenWidth(context),
                    hintText: S.of(context).select,
                    hintStyle: hintStyle(context),
                    items: rateAlertNotifier.currencyDataApi,
                    selectedItem: corridorId,
                  ),
                  SizedBoxHeight(context, 0.02),
                  buildText(
                    text: S.of(context).selectAlertType,
                    fontWeight: FontWeight.w700,
                    fontSize: AppConstants.sixteen,
                    fontColor: oxfordBlueTint500,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    horizontalTitleGap: 0,
                    leading: buildCheckBox(
                      rateAlertNotifier.alertMePopUp,
                      (bool? value) {
                        setState(() {
                          rateAlertNotifier.alertMePopUp = value!;
                        });
                      },
                    ),
                    title: GestureDetector(
                      onTap: () {
                        setState(() {
                          rateAlertNotifier.alertMePopUp == true
                              ? rateAlertNotifier.alertMePopUp = false
                              : rateAlertNotifier.alertMePopUp = true;
                        });
                      },
                      child: buildText(
                        text: 'Alert me if 1 SGD reaches INR,',
                        fontSize: 16,
                        fontColor: Color(0xff424B5C),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CommonTextField(
                                onChanged: (val) {
                                  handleInteraction(context);
                                },
                                controller:
                                    rateAlertNotifier.INRControllerPopup,
                                width: AppConstants.hundred,
                                hintText: 'eg.100 INR',
                                height: AppConstants.fortyTwo,
                                hintStyle: hintStyle(context)),
                          ),
                        ],
                      ),
                      sizedBoxHeight15(context),
                      buildText(text: 'Via', fontSize: AppConstants.sixteen),
                      sizedBoxHeight15(context),
                      Row(
                        children: [
                          Expanded(
                            child: CommonDropDownField(
                              showSearchBox: false,
                              onChanged: (val) {
                                handleInteraction(context);
                                rateAlertNotifier.alertModePopup = val!;
                              },
                              maxHeight: 150,
                              selectedItem: selectedType,
                              items: alertMeVia,
                              width: AppConstants.hundred,
                              hintText: 'Email',
                              height: 42,
                              hintStyle: hintStyle(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  getScreenWidth(context) < 670
                      ? sizedBoxHeight20(context)
                      : SizedBox(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    horizontalTitleGap: 0,
                    leading: buildCheckBox(
                      rateAlertNotifier.alertViaPopup,
                      (bool? value) {
                        setState(() {
                          rateAlertNotifier.alertViaPopup = value!;
                        });
                      },
                    ),
                    title: GestureDetector(
                      onTap: () {
                        setState(() {
                          rateAlertNotifier.alertViaPopup == true
                              ? rateAlertNotifier.alertViaPopup = false
                              : rateAlertNotifier.alertViaPopup = true;
                        });
                      },
                      child: buildText(
                        text: 'Alert me when the rate is at its two-week high,',
                        fontSize: 16,
                        fontColor: Color(0xff424B5C),
                      ),
                    ),
                  ),
                  SizedBoxHeight(context, 0.05),
                  buildButton(context, name: 'Update alerts',
                      onPressed: () async {
                    if (rateAlertNotifier.alertMePopUp == false &&
                        rateAlertNotifier.alertViaPopup == false) {
                      showMessageDialog(
                          context, "Please select require fields");
                    } else {
                      int? status = await rateAlertRepository.apiUpdateAlert(
                          UpdateAlertRequest(
                            subscribeId: "$id",
                            alertType: rateAlertNotifier.alertMePopUp &&
                                    rateAlertNotifier.alertViaPopup
                                ? "3"
                                : rateAlertNotifier.alertViaPopup
                                    ? "2"
                                    : "1",
                            alertRate: double.parse(rateAlertNotifier
                                        .INRControllerPopup.text.length ==
                                    0
                                ? "0"
                                : rateAlertNotifier.INRControllerPopup.text),
                            alertMode:
                                rateAlertNotifier.alertModePopup == "BOTH"
                                    ? "3"
                                    : rateAlertNotifier.alertModePopup == "SMS"
                                        ? "2"
                                        : "1",
                          ),
                          context,
                          "SGD",
                          "update");
                      if (status == 1) {
                        rateAlertNotifier.alertList(
                            context,
                            rateAlertNotifier.selectedCountry ==
                                    AppConstants.singapore
                                ? "SGD"
                                : "HKD");
                        rateAlertNotifier.enable = false;
                        rateAlertNotifier.INRControllerPopup.clear();
                        setState(() {
                          rateAlertNotifier.alertModePopup = '';
                          rateAlertNotifier.alertViaPopup = false;
                          rateAlertNotifier.alertMePopUp = false;
                        });
                      }
                    }
                  },
                      width: getScreenWidth(context),
                      color: Color(0xff3F70D4),
                      fontColor: white),
                  SizedBoxHeight(context, 0.04),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text:
                                'Note: You can create one alert per currency pair for each alert type. For more details please refer to the ',
                            style: textSpan1(context)),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrlString(
                                "https://uat.singx.co/singx/719be3430b91/Help.html",
                              );
                            },
                          text: 'FAQs',
                          style: textSpan2Bold(context),
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
    );
  }

  Widget buildCustomAppBar(context) {
    return Padding(
      padding: isMobile(context) || isTab(context)
          ? px15DimenTop(context)
          : px30DimenTopOnly(context),
      child: buildAppBar(
        context,
        Text(
          S.of(context).rateAlerts,
          style: appBarWelcomeText(context),
        ),
      ),
    );
  }
}
