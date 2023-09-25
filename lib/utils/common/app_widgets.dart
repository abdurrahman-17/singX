import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/service/australia/auth_repository_aus.dart';
import 'package:singx/core/data/remote/service/auth_repository.dart';
import 'package:singx/core/models/request_response/australia/customer_status/customer_status_response.dart';
import 'package:singx/core/notifier/common_notifier.dart';
import 'package:singx/core/notifier/dashboard_notifier.dart';
import 'package:singx/core/notifier/register_notifier.dart';
import 'package:singx/core/notifier/wallet_top_up_now_notifier.dart';
import 'package:singx/generated/l10n.dart';
import 'package:singx/main.dart';
import 'package:singx/utils/common/app_button.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_font.dart';
import 'package:singx/utils/common/app_images.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import 'package:singx/utils/justToolTip/src/just_the_tooltip.dart';
import 'package:singx/utils/justToolTip/src/models/just_the_controller.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'app_colors.dart';
import 'app_custom_icon.dart';
import 'app_screen_dimen.dart';
import 'app_text_style.dart';

showMessageDialog(BuildContext context, String msg,
    {void Function()? onPressed}) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AppInActiveCheck(
      context: context,
      child: AppInActiveCheck(
        context: context,
        child: new AlertDialog(
          content: Text('$msg'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: onPressed ??
                      () {
                    if (msg == "Alert Updated") {
                      Navigator.of(context, rootNavigator: true).pop();
                      MyApp.navigatorKey.currentState!.maybePop();
                    } else {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  },
              child: new Text('OK'),
            ),
          ],
        ),
      ),
    ),
  );
}

Timer? _timer;

void startTimer(context) {
  if (_timer != null) {
    _timer!.cancel();
  }

//Sets the timer to 300 seconds, after which the callback logs the user out
  _timer = Timer(const Duration(minutes: 10), () {
    _timer?.cancel();
    _timer = null;
    inActiveAlert(context);
  });
}

void stopTimer(context){
  _timer!.cancel();
}

Widget AppInActiveCheck(
    {required BuildContext context, required Widget child}) {
  return MouseRegion(
      onHover: (PointerEvent event) {
        handleInteraction(context);
      },
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (RawKeyEvent event) {
          handleInteraction(context);
        },
        autofocus: true,
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              handleInteraction(context);
            },
            onPanDown: (_) {
              handleInteraction(context);
            },
            onScaleStart: (_) {
              handleInteraction(context);
            },
            child: Listener(
              onPointerSignal: (pointerSignal) {
                if (pointerSignal is PointerScrollEvent) {
                  handleInteraction(context);
                }
              },
              child: child,
            )),
      ));
}

handleInteraction(BuildContext context) {
  startTimer(context);
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> initNotification({String? fileName, String? path}) async {
  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
  }
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  if(Platform.isAndroid) {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!.requestPermission();
  } else if(Platform.isIOS) {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()!.requestPermissions();
  }
  AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  final DarwinInitializationSettings initializationSettingsDarwin =
  DarwinInitializationSettings(requestAlertPermission: true,requestSoundPermission: true,requestBadgePermission: true,
    onDidReceiveLocalNotification: onDidReceiveLocalNotification
  );
  flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails().then((value) {

  });
  final LinuxInitializationSettings initializationSettingsLinux =
  LinuxInitializationSettings(defaultActionName: 'Open notification');
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux);
  flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) {
      if(details.payload!.isNotEmpty){
        OpenFilex.open(details.payload);
      }
    },
  );
  const AndroidNotificationDetails androidNotificationDetails =
  AndroidNotificationDetails('your channel id', 'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker');
  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      0, 'File Downloaded', fileName, notificationDetails,
      payload: path);
}

Widget amountFieldWeb(
    BuildContext context,
    TextEditingController controller,
    {String? text,
    String? hintText,
    Widget? suffixIcon,
    void Function(String)? callBack,
    void Function(bool)? focusChange,
    String? textType,
    int? maxLenght}) {
  return Focus(
    onFocusChange: focusChange,
    child: Container(
      padding: EdgeInsets.only(left: 15),
      alignment: Alignment.center,
      decoration: fieldContainerStyle2(context),
      child: Center(
        child: Selector<WalletTopUpNowNotifier, TextEditingController>(
            builder: (context, textEditControl, child) {
              return TextField(
                inputFormatters: [
                  DecimalTextInputFormatter(decimalRange: 2),
                  FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                ],
                onChanged: callBack,
                maxLength: maxLenght,
                keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
                obscuringCharacter: '*',
                style: fieldTextStyle(context),
                controller: textEditControl,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  counterText: '',
                  isDense: true,
                  isCollapsed: true,
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  labelText: text,
                  hintText: hintText,
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: oxfordBlueTint300,
                  ),
                  suffixIcon: suffixIcon,
                ),
              );
            },
            selector: (buildContext, walletTopUpNowNotifier) =>
            walletTopUpNowNotifier.amountController),
      ),
    ),
  );
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, // unused.
      TextEditingValue newValue,
      ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: min(truncated.length, truncated.length + 1),
          extentOffset: min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}

Widget dropdownCountrySelectionWeb(
    context, String selected, List<Map> myJson, onchanged) {
  return DropdownButtonHideUnderline(
    child: ButtonTheme(
      alignedDropdown: true,
      child: StatefulBuilder(builder: (context, setState) {
        return DropdownButton<String>(
          focusColor: lightBlueWebColor,
          icon: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Visibility(
                visible: false,
                child: Icon(
                  Icons.expand_more_outlined,
                  color: Color(0xff292D32),
                )),
          ),
          isDense: true,
          value: selected,
          onChanged: onchanged,
          items: myJson.map((Map map) {
            return DropdownMenuItem<String>(
              value: map["id"].toString(),
              child: Row(
                children: <Widget>[
                  Image.asset(
                    map["image"],
                    width: 25,
                    height: 25,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        map["name"],
                        style: fieldTextStyle(context),
                      )),
                ],
              ),
            );
          }).toList(),
        );
      }),
    ),
  );
}

Widget dropdownCountrySelectionDashboard(
    context, String? selected, myJson, onchanged) {
  myJson.sort();
  return DropdownButtonHideUnderline(
    child: ButtonTheme(
      alignedDropdown: true,
      child: StatefulBuilder(builder: (context, setState) {
        return DropdownButton<String>(
          focusColor: lightBlueWebColor,
          icon: myJson.length == 1
              ? SizedBox(
            width: 26,
          )
              : Icon(
            Icons.expand_more_outlined,
            color: Color(0xff292D32),
          ),
          isDense: true,
          value: selected!,
          onChanged: onchanged,
          items: myJson.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: <Widget>[
                  Image.asset(
                    'assets/flags/${value}.png',
                    width: 25,
                    height: 25,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        value,
                        style: fieldTextStyle(context),
                      )),
                ],
              ),
            );
          }).toList(),
        );
      }),
    ),
  );
}

Widget dropdownReceiverDynamic({context, String? selected,Map? myJson, onChanged}) {

  return PopupMenuButton(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(selected!, style: fieldTextStyle(context),),
        ),
        Icon(
        Icons.expand_more_outlined,
        color: Color(0xff292D32),
      ),
      ],
    ),
    onSelected: onChanged,
    itemBuilder: (context) {
     return myJson!.values.map((value) {
        List newValue = value.split(" ");
        return PopupMenuItem<String>(
          value: newValue.first,
          child: Text(
            value,
            style: fieldTextStyle(context),
          ),
        );
      }).toList();
  },);
}


Widget sendMoneyCommon(BuildContext context,
    {required TextEditingController sendController,
      onChangedSend,
      required TextEditingController recipientController,
      onChangedReceive,
      required String singxFee,
      required String totalAmountPay,
      String? title,
      String? errorMessage,
      String? sendCountry,
      String? receiverCountry,
      sendCountryList,
      receiverCountryList,
      sendOnchanged,
      receiverOnchanged,
      VoidCallback? buttonFunction,
      String? exchangeRateInitialValue,
      String? exchangeRateConvertedValue,
      VoidCallback? buttonFunctionForExchange,
      required String selectedCountry,
      required DashboardNotifier dashboardNotifier}) {
  return Container(
    padding: px24DimenAll(context),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        BoxShadow(
          color: black.withOpacity(0.08),
          blurRadius: 20,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title!,
          style: fairexchangeStyle(context),
        ),
        sizedBoxHeight15(context),
        Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).youSend,
                    style: greySendTextStyle(context),
                  ),
                  getScreenWidth(context) < 340
                      ? Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xffecf1fb),
                      ),
                      child: dropdownCountrySelectionDashboard(
                        context,
                        sendCountry!,
                        sendCountryList,
                        sendOnchanged,
                      ),
                    ),
                  )
                      : SizedBox(),
                  Container(
                    padding: EdgeInsets.only(right: 5),
                    height: getScreenWidth(context) > 1060 ? 43 : null,
                    child: Selector<DashboardNotifier, TextEditingController>(
                        builder: (context, textEditControl, child) {
                          return TextField(
                            keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
                            style: sgdValueTextBoldForField(context),
                            controller: textEditControl,
                            onChanged: onChangedSend,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              counterText: "",
                            ),
                          );
                        },
                        selector: (buildContext, dashboardNotifier) =>
                        dashboardNotifier.sendController),
                  ),
                ],
              ),
            ),
            getScreenWidth(context) > 340
                ? Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0xffecf1fb),
                ),
                child: dropdownCountrySelectionDashboard(
                  context,
                  sendCountry!,
                  sendCountryList,
                  sendOnchanged,
                ),
              ),
            )
                : SizedBox(),
          ],
        ),
        Divider(
          color: dividercolor,
          thickness: 2,
        ),
        sizedBoxHeight8(context),
        Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).recipientGets,
                    style: greySendTextStyle(context),
                  ),
                  getScreenWidth(context) < 340
                      ? Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xffecf1fb),
                      ),
                      child: dropdownCountrySelectionDashboard(
                        context,
                        receiverCountry!,
                        receiverCountryList,
                        receiverOnchanged,
                      ),
                    ),
                  )
                      : SizedBox(),
                  Container(
                    height: getScreenWidth(context) > 1060 ? 43 : null,
                    child: Selector<DashboardNotifier, TextEditingController>(
                        builder: (context, textEditControl, child) {
                          return TextField(
                            keyboardType: TextInputType.numberWithOptions(decimal: true,signed: true),
                            style: sgdValueTextBoldForField(context),
                            controller: textEditControl,
                            onChanged: onChangedReceive,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              counterText: "",
                            ),
                          );
                        },
                        selector: (buildContext, dashboardNotifier) =>
                        dashboardNotifier.recipientController),
                  ),
                ],
              ),
            ),
            getScreenWidth(context) > 340
                ? Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0xffecf1fb),
                ),
                child: dropdownCountrySelectionDashboard(
                  context,
                  receiverCountry!,
                  receiverCountryList,
                  receiverOnchanged,
                ),
              ),
            )
                : SizedBox(),
          ],
        ),
        Divider(
          color: dividercolor,
          thickness: 2,
        ),
        if(dashboardNotifier.userVerified ==
            true)(dashboardNotifier.selectedReceiver == "BDT" ||
            dashboardNotifier.selectedReceiver == "KRW" ||
            (dashboardNotifier.selectedReceiver == "MYR" && dashboardNotifier.selectedCountryData == AustraliaName) ||
            dashboardNotifier.selectedReceiver == "PHP" ||
            dashboardNotifier.selectedReceiver == "USD")
            ? getScreenWidth(context) > 550
            ? Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                "Transfer ${dashboardNotifier.selectedReceiver} ${dashboardNotifier.selectedReceiver == "BDT" || dashboardNotifier.selectedReceiver == "PHP" ? "via:" : "to:"}",
                style: topUpTextDataTextStyle(context),
              ),
            ),
            Expanded(
              flex: 4,
              child: ListTileTheme(
                horizontalTitleGap: 0,
                child: RadioListTile(
                  value: 1,
                  contentPadding: EdgeInsets.all(1),
                  groupValue: dashboardNotifier.selectedRadioTile,
                  title: Text(
                    dashboardNotifier.selectedReceiver == "BDT"
                        ? "Bank Transfer"
                        : dashboardNotifier.selectedReceiver == "KRW" ||
                        dashboardNotifier.selectedReceiver ==
                            "MYR"
                        ? "Individual"
                        : dashboardNotifier.selectedReceiver ==
                        "PHP"
                        ? "Bank Transfer"
                        : dashboardNotifier.selectedReceiver ==
                        "USD"
                        ? "USA"
                        : "Radio1",
                    style: TextStyle(
                      fontSize: getScreenWidth(context) < 1400 ? 15 : 16
                    ),
                  ),
                  onChanged: (int? val) {
                    dashboardNotifier.setSelectedRadioTile(val!);
                    if(dashboardNotifier.selectedReceiver == "PHP" && dashboardNotifier.selectedCountryData != AustraliaName){
                      dashboardNotifier.isCash = false;
                      dashboardNotifier.isSwift = false;
                      dashboardNotifier.isWallet = false;
                    }else{
                      dashboardNotifier.isSwift = false;
                      dashboardNotifier.isCash = false;
                      dashboardNotifier.isWallet = false;
                    }
                    dashboardNotifier.exchangeApi(
                      context,
                      dashboardNotifier.selectedSender,
                      dashboardNotifier.selectedReceiver,
                      dashboardNotifier.selectedCountryData == AppConstants.australia
                          ? "First"
                          : "Send",
                      double.parse(dashboardNotifier.sendController.text), false,);
                  },
                  activeColor: orangePantone,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: ListTileTheme(
                horizontalTitleGap: 0,
                child: RadioListTile(
                  value: 2,
                  groupValue: dashboardNotifier.selectedRadioTile,
                  title: Text(
                    dashboardNotifier.selectedReceiver == "BDT"
                        ? "E-Wallet"
                        : dashboardNotifier.selectedReceiver == "KRW" ||
                        dashboardNotifier.selectedReceiver ==
                            "MYR"
                        ? "Business"
                        : dashboardNotifier.selectedReceiver ==
                        "PHP"
                        ? "Cash"
                        : dashboardNotifier.selectedReceiver ==
                        "USD"
                        ? "Country Outside USA"
                        : "Radio2",
                    style: TextStyle(
                        fontSize: getScreenWidth(context) < 700 ? 14 : getScreenWidth(context) < 1400 ? 15 : 16
                    ),
                  ),
                  onChanged: (int? val) {
                    dashboardNotifier.setSelectedRadioTile(val!);
                    if(dashboardNotifier.selectedReceiver == "BDT" && dashboardNotifier.selectedCountryData != AustraliaName){
                      dashboardNotifier.isCash = false;
                      dashboardNotifier.isSwift = false;
                      dashboardNotifier.isWallet = true;
                    }else if(dashboardNotifier.selectedReceiver == "PHP" && dashboardNotifier.selectedCountryData != AustraliaName){
                      dashboardNotifier.isCash = true;
                      dashboardNotifier.isSwift = false;
                      dashboardNotifier.isWallet = false;
                    }else if(dashboardNotifier.selectedReceiver == "USD" || (dashboardNotifier.selectedReceiver == "PHP" && dashboardNotifier.selectedCountryData == AustraliaName)){
                      dashboardNotifier.isSwift = true;
                      dashboardNotifier.isCash = false;
                      dashboardNotifier.isWallet = false;
                    }else{
                      dashboardNotifier.isSwift = false;
                      dashboardNotifier.isCash = false;
                      dashboardNotifier.isWallet = false;
                    }
                    dashboardNotifier.exchangeApi(
                      context,
                      dashboardNotifier.selectedSender,
                      dashboardNotifier.selectedReceiver,
                      dashboardNotifier.selectedCountryData == AppConstants.australia
                          ? "First"
                          : "Send",
                      double.parse(dashboardNotifier.sendController.text), false,);
                  },
                  activeColor: orangePantone,
                ),
              ),
            )
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Transfer ${dashboardNotifier.selectedReceiver} ${dashboardNotifier.selectedReceiver == "BDT" || dashboardNotifier.selectedReceiver == "PHP" ? "via:" : "to:"}",
              style: topUpTextDataTextStyle(context),
            ),
            getScreenWidth(context) > 375
                ? Row(
              children: [
                Expanded(
                  child: ListTileTheme(
                    horizontalTitleGap: 0,
                    child: RadioListTile(
                      value: 1,
                      groupValue:
                      dashboardNotifier.selectedRadioTile,
                      title: Text(
                        dashboardNotifier.selectedReceiver ==
                            "BDT"
                            ? "Bank Transfer"
                            : dashboardNotifier
                            .selectedReceiver ==
                            "KRW" ||
                            dashboardNotifier
                                .selectedReceiver ==
                                "MYR"
                            ? "Individual"
                            : dashboardNotifier
                            .selectedReceiver ==
                            "PHP"
                            ? "Bank Transfer"
                            : dashboardNotifier
                            .selectedReceiver ==
                            "USD"
                            ? "USA"
                            : "Radio1",
                      ),
                      onChanged: (int? val) {
                        dashboardNotifier
                            .setSelectedRadioTile(val!);
                        if(dashboardNotifier.selectedReceiver == "PHP" && dashboardNotifier.selectedCountryData != AustraliaName){
                          dashboardNotifier.isCash = false;
                          dashboardNotifier.isSwift = false;
                          dashboardNotifier.isWallet = false;
                        }else{
                          dashboardNotifier.isSwift = false;
                          dashboardNotifier.isCash = false;
                          dashboardNotifier.isWallet = false;
                        }
                        dashboardNotifier.exchangeApi(
                          context,
                          dashboardNotifier.selectedSender,
                          dashboardNotifier.selectedReceiver,
                          dashboardNotifier.selectedCountryData == AppConstants.australia
                              ? "First"
                              : "Send",
                          double.parse(dashboardNotifier.sendController.text), false,);
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
                      dashboardNotifier.selectedRadioTile,
                      title: Text(
                        dashboardNotifier.selectedReceiver ==
                            "BDT"
                            ? "E-Wallet"
                            : dashboardNotifier
                            .selectedReceiver ==
                            "KRW" ||
                            dashboardNotifier
                                .selectedReceiver ==
                                "MYR"
                            ? "Business"
                            : dashboardNotifier
                            .selectedReceiver ==
                            "PHP"
                            ? "Cash"
                            : dashboardNotifier
                            .selectedReceiver ==
                            "USD"
                            ? "Country Outside USA"
                            : "Radio2",
                      ),
                      onChanged: (int? val) {
                        dashboardNotifier
                            .setSelectedRadioTile(val!);
                        if(dashboardNotifier.selectedReceiver == "BDT" && dashboardNotifier.selectedCountryData != AustraliaName){
                          dashboardNotifier.isCash = false;
                          dashboardNotifier.isSwift = false;
                          dashboardNotifier.isWallet = true;
                        }else if(dashboardNotifier.selectedReceiver == "PHP" && dashboardNotifier.selectedCountryData != AustraliaName){
                          dashboardNotifier.isCash = true;
                          dashboardNotifier.isSwift = false;
                          dashboardNotifier.isWallet = false;
                        }else if(dashboardNotifier.selectedReceiver == "USD" || (dashboardNotifier.selectedReceiver == "PHP" && dashboardNotifier.selectedCountryData == AustraliaName)){
                          dashboardNotifier.isSwift = true;
                          dashboardNotifier.isCash = false;
                          dashboardNotifier.isWallet = false;
                        }else{
                          dashboardNotifier.isSwift = false;
                          dashboardNotifier.isCash = false;
                          dashboardNotifier.isWallet = false;
                        }
                        dashboardNotifier.exchangeApi(
                          context,
                          dashboardNotifier.selectedSender,
                          dashboardNotifier.selectedReceiver,
                          dashboardNotifier.selectedCountryData == AppConstants.australia
                              ? "First"
                              : "Send",
                          double.parse(dashboardNotifier.sendController.text), false,);
                      },
                      activeColor: orangePantone,
                    ),
                  ),
                ),
              ],
            )
                : Column(
              children: [
                ListTileTheme(
                  horizontalTitleGap: 0,
                  child: RadioListTile(
                    value: 1,
                    groupValue:
                    dashboardNotifier.selectedRadioTile,
                    title: Text(
                      dashboardNotifier.selectedReceiver == "BDT"
                          ? "Bank Transfer"
                          : dashboardNotifier.selectedReceiver ==
                          "KRW" ||
                          dashboardNotifier
                              .selectedReceiver ==
                              "MYR"
                          ? "Individual"
                          : dashboardNotifier
                          .selectedReceiver ==
                          "PHP"
                          ? "Bank Transfer"
                          : dashboardNotifier
                          .selectedReceiver ==
                          "USD"
                          ? "USA"
                          : "Radio1",
                    ),
                    onChanged: (int? val) {
                      dashboardNotifier
                          .setSelectedRadioTile(val!);
                      if(dashboardNotifier.selectedReceiver == "PHP" && dashboardNotifier.selectedCountryData != AustraliaName){
                        dashboardNotifier.isCash = false;
                        dashboardNotifier.isSwift = false;
                        dashboardNotifier.isWallet = false;
                      }else{
                        dashboardNotifier.isSwift = false;
                        dashboardNotifier.isCash = false;
                        dashboardNotifier.isWallet = false;
                      }
                      dashboardNotifier.exchangeApi(
                        context,
                        dashboardNotifier.selectedSender,
                        dashboardNotifier.selectedReceiver,
                        dashboardNotifier.selectedCountryData == AppConstants.australia
                            ? "First"
                            : "Send",
                        double.parse(dashboardNotifier.sendController.text), false,);
                    },
                    activeColor: orangePantone,
                  ),
                ),
                ListTileTheme(
                  horizontalTitleGap: 0,
                  child: RadioListTile(
                    value: 2,
                    groupValue:
                    dashboardNotifier.selectedRadioTile,
                    title: Text(
                      dashboardNotifier.selectedReceiver == "BDT"
                          ? "E-Wallet"
                          : dashboardNotifier.selectedReceiver ==
                          "KRW" ||
                          dashboardNotifier
                              .selectedReceiver ==
                              "MYR"
                          ? "Business"
                          : dashboardNotifier
                          .selectedReceiver ==
                          "PHP"
                          ? "Cash"
                          : dashboardNotifier
                          .selectedReceiver ==
                          "USD"
                          ? "Country Outside USA"
                          : "Radio2",
                    ),
                    onChanged: (int? val) {
                      dashboardNotifier
                          .setSelectedRadioTile(val!);
                      if(dashboardNotifier.selectedReceiver == "BDT" && dashboardNotifier.selectedCountryData != AustraliaName){
                        dashboardNotifier.isCash = false;
                        dashboardNotifier.isSwift = false;
                        dashboardNotifier.isWallet = true;
                      }else if(dashboardNotifier.selectedReceiver == "PHP" && dashboardNotifier.selectedCountryData != AustraliaName){
                        dashboardNotifier.isCash = true;
                        dashboardNotifier.isSwift = false;
                        dashboardNotifier.isWallet = false;
                      }else if(dashboardNotifier.selectedReceiver == "USD" || (dashboardNotifier.selectedReceiver == "PHP" && dashboardNotifier.selectedCountryData == AustraliaName)){
                        dashboardNotifier.isSwift = true;
                        dashboardNotifier.isCash = false;
                        dashboardNotifier.isWallet = false;
                      }else{
                        dashboardNotifier.isSwift = false;
                        dashboardNotifier.isCash = false;
                        dashboardNotifier.isWallet = false;
                      }
                      dashboardNotifier.exchangeApi(
                        context,
                        dashboardNotifier.selectedSender,
                        dashboardNotifier.selectedReceiver,
                        dashboardNotifier.selectedCountryData == AppConstants.australia
                            ? "First"
                            : "Send",
                        double.parse(dashboardNotifier.sendController.text), false,);
                    },
                    activeColor: orangePantone,
                  ),
                ),
              ],
            ),
          ],
        )
            : SizedBox(),
        errorMessage == "" || errorMessage == "null"
            ? sizedBoxHeight10(context)
            : sizedBoxHeight5(context),
        Provider.of<CommonNotifier>(context, listen: false)
            .updateUserVerifiedBool ==
            false ? SizedBox() :errorMessage == "" || errorMessage == "null"
            ? SizedBox()
            : Text(
          errorMessage!,
          style: errorMessageStyle(context),
        ),
        errorMessage == "" || errorMessage == "null"
            ? SizedBox()
            : sizedBoxHeight8(context),
        Container(
          decoration: BoxDecoration(
              color: oxfordBlue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(5)),
          padding: px15DimenHorizontalandpx12vertical(context),
          child: Column(
            children: [
              getScreenWidth(context) > 430
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).exchangeRate,
                    style: exchangeRateHeadingTextStyle(context),
                  ),
                  getScreenWidth(context) <= 430
                      ? Column(
                    children: [
                      Text(
                        "1 ${dashboardNotifier.exchangeSelectedSender}",
                        style: exchangeRateDataTextStyle(context),
                      ),
                      sizedBoxHeight5(context),
                      RotatedBox(
                        quarterTurns: 1,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: buttonFunctionForExchange,
                            child: Icon(
                              AppCustomIcon.transferIndicator,
                              size: 15,
                              color: orangeColor,
                            ),
                          ),
                        ),
                      ),
                      sizedBoxHeight5(context),
                      Text(
                        "${double.parse(dashboardNotifier.exchagneRateConverted) ==0?"0":getNumber(double.parse(dashboardNotifier.exchagneRateConverted),)} ${dashboardNotifier.exchangeSelectedReceiver}",
                        style: exchangeRateDataTextStyle(context),
                      ),
                      sizedBoxWidth3(context),
                      questionToolTip(context,dashboardNotifier),
                    ],
                  )
                      : Row(
                    children: [
                      Selector<DashboardNotifier, String>(
                          builder: (context,
                              exchangeRateInitialValue, child) {
                            return Text(
                              "1 ${dashboardNotifier.exchangeSelectedSender}",
                              style: exchangeRateDataTextStyle(
                                  context),
                            );
                          },
                          selector: (buildContext,
                              dashboardNotifier) =>
                          dashboardNotifier.exchagneRateInital),
                      sizedBoxWidth10(context),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: buttonFunctionForExchange,
                          child: Icon(
                            AppCustomIcon.transferIndicator,
                            size: 15,
                            color: orangeColor,
                          ),
                        ),
                      ),
                      sizedBoxWidth10(context),
                      Selector<DashboardNotifier, String>(
                          builder: (context,
                              exchangeRateConvertedValue, child) {
                            return Text(
                              "${double.parse(dashboardNotifier.exchagneRateConverted) ==0?"0":getNumber(double.parse(dashboardNotifier.exchagneRateConverted),)} ${dashboardNotifier.exchangeSelectedReceiver}",
                              style: exchangeRateDataTextStyle(
                                  context),
                            );
                          },
                          selector: (buildContext,
                              dashboardNotifier) =>
                          dashboardNotifier
                              .exchagneRateConverted),
                      sizedBoxWidth3(context),
                      questionToolTip(context,dashboardNotifier),
                    ],
                  ),
                ],
              )
                  : Column(
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
                      Selector<DashboardNotifier, String>(
                          builder:
                              (context, exchangeRateInitialValue, child) {
                            return Text(
                              "1 ${dashboardNotifier.exchangeSelectedSender}",
                              style: exchangeRateDataTextStyle(context),
                            );
                          },
                          selector: (buildContext, dashboardNotifier) =>
                          dashboardNotifier.exchagneRateInital),
                      sizedBoxWidth10(context),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: buttonFunctionForExchange,
                          child: Icon(
                            AppCustomIcon.transferIndicator,
                            size: 15,
                            color: orangeColor,
                          ),
                        ),
                      ),
                      sizedBoxWidth10(context),
                      Selector<DashboardNotifier, String>(
                          builder: (context, exchangeRateConvertedValue,
                              child) {
                            return Text(
                              "${double.parse(dashboardNotifier.exchagneRateConverted) ==0?"0":getNumber(double.parse(dashboardNotifier.exchagneRateConverted),)} ${dashboardNotifier.exchangeSelectedReceiver}",
                              style: exchangeRateDataTextStyle(context),
                            );
                          },
                          selector: (buildContext, dashboardNotifier) =>
                          dashboardNotifier.exchagneRateConverted),
                      sizedBoxWidth3(context),
                      questionToolTip(context, dashboardNotifier),
                    ],
                  ),
                ],
              ),
              getScreenWidth(context) > 340
                  ? sizedBoxHeight8(context)
                  : sizedBoxHeight15(context),
              getScreenWidth(context) > 340
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).singXFee,
                    style: exchangeRateHeadingTextStyle(context),
                  ),
                  Text(
                    "${dashboardNotifier.selectedSender} ${sendController.text == '0' ? '0.0' : double.parse(singxFee).toStringAsFixed(2)}",
                    style: exchangeRateDataTextStyle(context),
                  ),
                ],
              )
                  : Column(
                children: [
                  Text(
                    S.of(context).singXFee,
                    style: exchangeRateHeadingTextStyle(context),
                  ),
                  sizedBoxHeight5(context),
                  Selector<DashboardNotifier, String>(
                      builder: (context, sendCountry, child) {
                        return Text(
                          "${dashboardNotifier.selectedSender} ${sendController.text == '0' ? '0.0' : double.parse(singxFee).toStringAsFixed(2)}",
                          style: exchangeRateDataTextStyle(context),
                        );
                      },
                      selector: (buildContext, dashboardNotifier) =>
                      dashboardNotifier.selectedSender)
                ],
              ),
              getScreenWidth(context) > 340
                  ? sizedBoxHeight8(context)
                  : sizedBoxHeight15(context),
              getScreenWidth(context) > 340
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedCountry == AppConstants.singapore
                        ? S.of(context).totalAmount
                        : getScreenWidth(context) < 420
                        ? S.of(context).totalPayableAmountMobile
                        : S.of(context).totalPayableAmountWeb,
                    style: totalAmountTextStyleStyleWeb(context),
                  ),
                  Selector<DashboardNotifier, String>(
                      builder: (context, sendCountry, child) {
                        return Flexible(
                          child: Text(
                            "${dashboardNotifier.selectedSender} ${double.parse(sendController.text == '0' ? '0.0' : totalAmountPay).toStringAsFixed(2)}",
                            textAlign: TextAlign.right,
                            style: totalAmountTextStyleStyleWeb(context),
                          ),
                        );
                      },
                      selector: (buildContext, dashboardNotifier) =>
                      dashboardNotifier.selectedSender),
                ],
              )
                  : Column(
                children: [
                  Text(
                    selectedCountry == AppConstants.singapore
                        ? S.of(context).totalAmount
                        : getScreenWidth(context) < 420
                        ? S.of(context).totalPayableAmountMobile
                        : S.of(context).totalPayableAmountWeb,
                    style: totalAmountTextStyleStyleWeb(context),
                  ),
                  sizedBoxHeight5(context),
                  Selector<DashboardNotifier, String>(
                      builder: (context, sendCountry, child) {
                        return Text(
                          "${dashboardNotifier.selectedSender} ${double.parse(sendController.text == '0' ? '0.0' : totalAmountPay).toStringAsFixed(2)}",
                          style: totalAmountTextStyleStyleWeb(context),
                        );
                      },
                      selector: (buildContext, dashboardNotifier) =>
                      dashboardNotifier.selectedSender),
                ],
              ),
            ],
          ),
        ),
        errorMessage == "" || errorMessage == "null"
            ? sizedBoxHeight15(context)
            : sizedBoxHeight8(context),
        if(dashboardNotifier.userVerified ==
            true)if(dashboardNotifier.selectedCountryData == AustraliaName)dashboardNotifier.checkTransferLimit == "" ? SizedBox() : Text(dashboardNotifier.checkTransferLimit,style: errorMessageStyle(context),),
        if(dashboardNotifier.userVerified ==
            true)
            if(dashboardNotifier.selectedReceiver == 'JPY')
        countryDataMessage(context, dashboardNotifier,
            dashboardNotifier.selectedReceiver) ==
            ""
            ? SizedBox()
            : Text(
          countryDataMessage(context, dashboardNotifier,
              dashboardNotifier.selectedReceiver),
          style: errorMessageStyle(context),
        ),
        if(dashboardNotifier.userVerified ==
            true)if(dashboardNotifier.selectedReceiver == 'JPY')sizedBoxHeight5(context),
        if(dashboardNotifier.userVerified ==
            true)dashboardNotifier.selectedReceiver == 'KRW' ||
            dashboardNotifier.selectedReceiver == 'VND' ||
            dashboardNotifier.selectedReceiver == 'JPY' ||
            dashboardNotifier.selectedReceiver == 'PHP'
            ? countryRoundOff(context, dashboardNotifier)
            : countryDataMessage(context, dashboardNotifier,
            dashboardNotifier.selectedReceiver) ==
            ""
            ? SizedBox()
            : Text(
          countryDataMessage(context, dashboardNotifier,
              dashboardNotifier.selectedReceiver),
          style: errorMessageStyle(context),
        ),
        Provider.of<CommonNotifier>(context, listen: false)
            .updateUserVerifiedBool ==
            false ? SizedBox() :dashboardNotifier.selectedReceiver == 'KRW' ||
            dashboardNotifier.selectedReceiver == 'VND' ||
            dashboardNotifier.selectedReceiver == 'PHP'||
            dashboardNotifier.selectedReceiver == 'JPY'
            ? sizedBoxHeight10(context)
            : SizedBox(),
        errorMessage == "" || errorMessage == "null"
            ? sizedBoxHeight15(context)
            : SizedBox(),
        Container(
          width: double.infinity,
          child: primarywebButton(context, 'Send money', buttonFunction),
        ),
      ],
    ),
  );
}
double getNumber(double input){
  String result = input.toString();
  int decimalIndex = result.indexOf('.');
  if (decimalIndex != -1 && result.length > decimalIndex + 5) {
    result = result.substring(0, decimalIndex + 5);
  }
  return double.parse(result);
}

JustTheController tooltipController = JustTheController();
Widget questionToolTip(BuildContext context, DashboardNotifier dashboardNotifier){

  return InkWell(
    onTap: (){
      tooltipController.showTooltip();
    },
    child: IgnorePointer(
      ignoring: true,
      ignoringSemantics: false,
      child: JustTheTooltip(triggerMode: TooltipTriggerMode.tap,
        controller: tooltipController,
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
              if(dashboardNotifier.selectedCountryData != AustraliaName) TextSpan(
                text: '\nLearn more.',
                style: TextStyle(
                  color: hanBlue,
                ),
                mouseCursor: SystemMouseCursors.click,
                recognizer: TapGestureRecognizer()..onTap = (){
                  SharedPreferencesMobileWeb.instance
                      .getCountry(country)
                      .then((value) {
                    if (Uri.base.toString().contains("www.singx.co")) {
                      launchUrlString(
                          'https://www.singx.co/faq');
                    } else if (value == AppConstants.singapore) {
                      launchUrlString(
                          'https://uat.singx.co/faq');
                    } else if (value == AppConstants.hongKong) {
                      launchUrlString(
                          'https://hkuat.singx.co/faq');
                    } else if (value == AppConstants.australia) {
                      launchUrlString(
                          'https://uatau.singx.co/faq');
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


Widget countryRoundOff(
    BuildContext context, DashboardNotifier dashboardNotifier) {
  Widget richData = SizedBox();

  if (dashboardNotifier.selectedReceiver == 'KRW') {
    richData = Text.rich(
      TextSpan(
        text:
        'Note:- Please round off the receive amount to the nearest whole number (no decimals) to proceed with the transaction.',
        style: policyStyleBlack(context),
        children: <TextSpan>[
          TextSpan(
            text: ' Click here to round off now',
            recognizer: TapGestureRecognizer()
              ..onTap = () async{
                dashboardNotifier.recipientController.text =
                    double.parse(dashboardNotifier.recipientController.text)
                        .toStringAsFixed(0);
                await dashboardNotifier.exchangeApi(context,
                  dashboardNotifier.selectedSender,
                  dashboardNotifier.selectedReceiver,
                  dashboardNotifier.selectedCountryData == AppConstants.australia
                      ? "Second"
                      : "Receive",
                  double.parse(dashboardNotifier.recipientController.text), false,);
                if(dashboardNotifier.selectedCountryData == AustraliaName) dashboardNotifier.errorExchangeValue = '';
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
        'Note:- Please round off the receive amount to the nearest whole number (no decimals) to proceed with the transaction.',
        style: policyStyleBlack(context),
        children: <TextSpan>[
          TextSpan(
            text: ' Click here to round off now',
            recognizer: TapGestureRecognizer()
              ..onTap = () async{
                dashboardNotifier.recipientController.text =
                    double.parse(dashboardNotifier.recipientController.text)
                        .toStringAsFixed(0);
                await dashboardNotifier.exchangeApi(context,
                  dashboardNotifier.selectedSender,
                  dashboardNotifier.selectedReceiver,
                  dashboardNotifier.selectedCountryData == AppConstants.australia
                      ? "Second"
                      : "Receive",
                  double.parse(dashboardNotifier.recipientController.text), false,);
                if(dashboardNotifier.selectedCountryData == AustraliaName) dashboardNotifier.errorExchangeValue = '';
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
        'Note:- Please round off the receive amount to the nearest multiple of 500 to proceed with the transaction.',
        style: policyStyleBlack(context),
        children: <TextSpan>[
          TextSpan(
            text: ' Click here to round off now',
            recognizer: TapGestureRecognizer()
              ..onTap = () async{
                dashboardNotifier.recipientController.text =
                    double.parse(dashboardNotifier.recipientController.text)
                        .toStringAsFixed(0);
                dashboardNotifier.recipientController.text =
                double.parse(dashboardNotifier.recipientController.text.substring(dashboardNotifier.recipientController.text.length - 3)) <
                    500
                    ? dashboardNotifier.recipientController.text.replaceAll(
                    dashboardNotifier.recipientController.text
                        .substring(dashboardNotifier
                        .recipientController.text.length -
                        3),
                    '000')
                    : dashboardNotifier.recipientController.text.replaceAll(
                    dashboardNotifier.recipientController.text.substring(
                        dashboardNotifier.recipientController.text.length - 3),
                    '500');
                await dashboardNotifier.exchangeApi(context,
                  dashboardNotifier.selectedSender,
                  dashboardNotifier.selectedReceiver,
                  dashboardNotifier.selectedCountryData == AppConstants.australia
                      ? "Second"
                      : "Receive",
                  double.parse(dashboardNotifier.recipientController.text), false,);
                if(dashboardNotifier.selectedCountryData == AustraliaName) dashboardNotifier.errorExchangeValue = '';
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
        'Note:- Please round off the receive amount to the nearest multiple of 10 to proceed with the transaction.',
        style: policyStyleBlack(context),
        children: <TextSpan>[
          TextSpan(
            text: ' Click here to round off now',
            recognizer: TapGestureRecognizer()
              ..onTap = () async{
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
                        dashboardNotifier.recipientController.text.length -
                            1),
                    '0');
                await dashboardNotifier.exchangeApi(context,
                  dashboardNotifier.selectedSender,
                  dashboardNotifier.selectedReceiver,
                  dashboardNotifier.selectedCountryData == AppConstants.australia
                      ? "Second"
                      : "Receive",
                  double.parse(dashboardNotifier.recipientController.text), false,);
                if(dashboardNotifier.selectedCountryData == AustraliaName) dashboardNotifier.errorExchangeValue = '';
              },
            style: policyStyleHanBlue(context),
          ),
        ],
      ),
    );
  }

  return richData;
}

String countryDataMessage(
    context, DashboardNotifier dashboardNotifier, country) {
  String message = '';
  if (dashboardNotifier.selectedCountryData == SingaporeName) {
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
  } else if (dashboardNotifier.selectedCountryData == HongKongName) {
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
  } else if (dashboardNotifier.selectedCountryData == AustraliaName) {
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

String dataTransferLimitMessage(
    context, DashboardNotifier dashboardNotifier, country) {
  dashboardNotifier.checkTransferLimit = '';
  // if (dashboardNotifier.selectedCountryData == SingaporeName || dashboardNotifier.selectedCountryData == HongKongName) {
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
  //       if(dashboardNotifier.selectedCountryData == SingaporeName) if(double.parse(dashboardNotifier.recipientController.text) >= 500000) dashboardNotifier.checkTransferLimit = 'For transfers to Philippines (PHP), there is a maximum transfer limit of PHP 500,000 per transaction.';
  //       if(dashboardNotifier.selectedCountryData == HongKongName) if(double.parse(dashboardNotifier.recipientController.text) >= 490000) dashboardNotifier.checkTransferLimit = 'For transfers to Philippines (PHP), there is a maximum transfer limit of PHP 490,000 per transaction.';
  //     }else{
  //       if(double.parse(dashboardNotifier.recipientController.text) >= 500000) dashboardNotifier.checkTransferLimit = 'For transfers to Philippines (PHP), there is a maximum transfer limit of PHP 500,000 per transaction.';
  //       else if(double.parse(dashboardNotifier.recipientController.text) <= 5000) dashboardNotifier.checkTransferLimit = 'For cash transfers to Philippines (PHP), there is a minimum transfer limit of PHP 5,000 per transaction.';
  //     }
  //   }else if(country == 'THB'){
  //     if(double.parse(dashboardNotifier.recipientController.text) >= 49999) dashboardNotifier.checkTransferLimit = 'For transfers to Thailand (THB), there is a maximum transfer limit of THB 49,999 per transaction.';
  //   }else if(country == 'GBP'){
  //     if(double.parse(dashboardNotifier.recipientController.text) >= 550000) dashboardNotifier.checkTransferLimit = 'For transfers to United Kingdom (GBP), there is a maximum transfer limit of GBP 550,000 per transaction';
  //   }else if(country == 'CNY'){
  //     if(dashboardNotifier.selectedCountryData == SingaporeName) if(double.parse(dashboardNotifier.sendController.text) >= 3800) dashboardNotifier.checkTransferLimit = 'For transfers to China (CNY), there is a maximum transfer limit of SGD 3,800 per transaction and SGD 7,600 per day.';
  //     if(dashboardNotifier.selectedCountryData == HongKongName) if(double.parse(dashboardNotifier.sendController.text) >= 23000) dashboardNotifier.checkTransferLimit = 'For transfers to China (CNY), there is a maximum transfer limit of HKD 23,000 per transaction and HKD 45,000 per day.';
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
    if(dashboardNotifier.selectedCountryData == AustraliaName){
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
      else if(double.parse(dashboardNotifier.recipientController.text) < 100) dashboardNotifier.checkTransferLimit = 'For transfers to Sri Lanka (LKR), there is a minimum transfer limit of LKR 100 per transaction.';
    }else if(country == 'PKR'){
      if(double.parse(dashboardNotifier.recipientController.text) > 1000000) dashboardNotifier.checkTransferLimit = 'For transfers to Pakistan (PKR), there is a maximum transfer limit of PKR  1,000,000 per transaction.';
      else if(double.parse(dashboardNotifier.recipientController.text) < 100) dashboardNotifier.checkTransferLimit = 'For transfers to Pakistan (PKR), there is a minimum transfer limit of PKR 100 per transaction.';
    }else if(country == 'NPR'){
      if(double.parse(dashboardNotifier.recipientController.text) > 1000000) dashboardNotifier.checkTransferLimit = 'For transfers to Nepal (NPR), there is a maximum transfer limit of NPR 1,000,000 per transaction for businesses.';
      else if(double.parse(dashboardNotifier.recipientController.text) < 10) dashboardNotifier.checkTransferLimit = 'For transfers to Nepal (NPR), there is a minimum transfer limit of NPR 10 per transaction for individuals.';
    }else if(country == 'KRW'){
      if(dashboardNotifier.selectedRadioTile == 1) {
        if (double.parse(dashboardNotifier.recipientController.text) <= 0)
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
    }else if(country == 'USD'){
      if(dashboardNotifier.isSwift == false){
        if(double.parse(dashboardNotifier.recipientController.text) > 700000) dashboardNotifier.checkTransferLimit = 'For transfers to United States of America (USD), there is a maximum transfer limit of USD 700,000 per transaction.';
      }else{
        if(double.parse(dashboardNotifier.recipientController.text) > 700000) dashboardNotifier.checkTransferLimit = 'For transfers to United States of America (USD), there is a maximum transfer limit of USD 700,000 per transaction.';
      }
    }else if(country == 'BDT'){
      if(dashboardNotifier.selectedRadioTile == 1){
        if(double.parse(dashboardNotifier.recipientController.text) > 200000) dashboardNotifier.checkTransferLimit = 'For transfers to Bangladesh (BDT) Bank Account, there is a maximum transfer limit of BDT 200,000 per transaction.';
      }else{
        if(double.parse(dashboardNotifier.recipientController.text) > 125000) dashboardNotifier.checkTransferLimit = 'For transfers to Bangladesh (BDT) E-Wallet, there is a maximum transfer limit of BDT 125,000 per transaction.';
      }
    }

  }
  return dashboardNotifier.checkTransferLimit;
}


class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}

Widget buildAppBar(BuildContext context, Widget frontWidget,
    {bool isVisible = false,
      bool drawerVisible = true,
      backCondition,
      from,
      userNames}) {
  final ancestorScaffold = Scaffold.maybeOf(context);
  final ScaffoldState? scaffold = Scaffold.maybeOf(context);
  final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
  final bool hasEndDrawer = scaffold?.hasEndDrawer ?? false;
  final bool canPop = parentRoute?.canPop ?? false;
  bool? data;

  return Consumer<CommonNotifier>(builder: ((context, notifier, child) {
    notifier.setAppBarName();
    return AppBar(
      titleSpacing: 0,
      leadingWidth: 40,
      iconTheme: IconThemeData(color: black),
      leading: getScreenWidth(context) <= 1060 &&
          ((!hasEndDrawer && canPop) ||
              (parentRoute?.impliesAppBarDismissal ?? false))
          ? GestureDetector(
        child: Container(
          color: Colors.transparent,
          child: Icon(
            AppCustomIcon.leftArrow,
            color: Colors.black,
            size: 20,
          ),
        ),
        onTap: backCondition == null
            ? () async {
          await SharedPreferencesMobileWeb.instance
              .getCountry(country)
              .then((value) async {
            Navigator.pushNamedAndRemoveUntil(
                context, dashBoardRoute, (route) => false);
          });
        }
            : backCondition,
      )
          : null,
      automaticallyImplyLeading: false,
      backgroundColor: bankDetailsBackground.withOpacity(0.95),
      elevation: 0.4,
      title: Row(
        children: [
          Expanded(
            child: Padding(
                padding: ((!hasEndDrawer && canPop) ||
                    (parentRoute?.impliesAppBarDismissal ?? false)) &&
                    getScreenWidth(context) <= 1060
                    ? EdgeInsets.zero
                    : EdgeInsets.only(left: 15),
                child: frontWidget),
          ),
          getScreenWidth(context) <= 375
              ? SizedBox(width: 0)
              : sizedBoxWidth10(context),
          Theme(
            data: Theme.of(context).copyWith(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
            child: notifier.countryData == 'Australia'
                ? PopupMenuButton<int>(
              tooltip: "",
              onSelected: (ind) async {
                await SharedPreferencesMobileWeb.instance
                    .getCountry(country)
                    .then((value) async {
                  if (ind == 1) {
                    await SharedPreferencesMobileWeb.instance
                        .getContactId(apiContactId)
                        .then((value) async {
                      await AuthRepository()
                          .apiCustomerStatus(value, context)
                          .then((value) async {
                        CustomerStatusResponse customerStatusResponse =
                        value as CustomerStatusResponse;
                        if (customerStatusResponse.statusId == 10000000) {
                          await SharedPreferencesMobileWeb.instance
                              .getCountry(country)
                              .then((value) async {
                            Navigator.pushNamed(
                                context, personalDetailsAustraliaRoute);
                          });
                        } else if (customerStatusResponse.statusId ==
                            10000001) {
                          await SharedPreferencesMobileWeb.instance
                              .getCountry(country)
                              .then((value) async {
                            Navigator.pushNamed(
                                context, digitalVerificationAustralia);
                          });
                        } else if (customerStatusResponse.statusId ==
                            10000002) {
                          await SharedPreferencesMobileWeb.instance
                              .getCountry(country)
                              .then((value) async {
                            Navigator.pushNamed(
                                context, nonDigitalVerificationAustralia);
                          });
                        } else if (customerStatusResponse.statusId ==
                            10000003) {
                          await SharedPreferencesMobileWeb.instance
                              .getCountry(country)
                              .then((value) async {
                            Navigator.pushNamed(
                                context, digitalVerificationAustralia);
                          });
                        } else if (customerStatusResponse.statusId ==
                            10000004 ||
                            customerStatusResponse.statusId == 10000005) {
                          Navigator.pushNamed(context, editProfileRoute);
                        } else if (customerStatusResponse.statusId ==
                            10000009 ||
                            customerStatusResponse.statusId == 10000010 ||
                            customerStatusResponse.statusId == 10000011) {
                          Navigator.pushNamed(context, editProfileRoute);
                        } else if (customerStatusResponse.statusId ==
                            10000012 ||
                            customerStatusResponse.statusId == 10000013) {
                          Navigator.pushNamed(context, editProfileRoute);
                        } else if (customerStatusResponse.statusId ==
                            10000014) {
                          Navigator.pushNamed(context, editProfileRoute);
                        }
                      });
                    });
                  } else if (ind == 2) {
                    Navigator.pushNamed(context, changePassword);
                  } else if (ind == 4) {
                    logoutAlert(context);
                  }
                });
              },
              position: PopupMenuPosition.under,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.account_circle),
                      SizedBox(width: 10),
                      Text(
                        'Profile',
                        style: TextStyle(
                            fontFamily: 'Manrope',
                            color: black,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: 10),
                      Text(
                        S.of(context).changePassword,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          color: black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 4,
                  child: Row(
                    children: [
                      Icon(Icons.power_settings_new),
                      SizedBox(width: 10),
                      Text(
                        S.of(context).logout,
                        style: TextStyle(
                            fontFamily: 'Manrope',
                            color: black,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Container(
                  height: 44,
                  padding: px10DimenAll(context),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 5),
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: Image.asset(
                          AppImages.profile,
                        ),
                      ),
                      getScreenWidth(context) < 570
                          ? sizedBoxWidth3(context)
                          : sizedBoxWidth10(context),
                      Text(
                        "${userNames == null ? notifier.userNameData : userNames}",
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 16,
                          color: oxfordBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: 10,
                          left: 8,
                        ),
                        child: Icon(
                          AppCustomIcon.dropdownIcon,
                          size: 10,
                          color: Color(0xff131E33),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
                : PopupMenuButton<int>(
              tooltip: "",
              onSelected: (ind) async {
                await SharedPreferencesMobileWeb.instance
                    .getCountry(country)
                    .then((value) async {
                  if (ind == 1) {
                    RegisterNotifier(context)
                        .getAuthStatusProfile(context);
                  } else if (ind == 2) {
                    Navigator.pushNamed(context, changePassword);
                  } else if (ind == 4) {
                    logoutAlert(context);
                  }
                });
              },
              position: PopupMenuPosition.under,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.account_circle),
                      SizedBox(width: 10),
                      Text(
                        'Profile',
                        style: TextStyle(
                            fontFamily: 'Manrope',
                            color: black,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: 10),
                      Text(
                        S.of(context).changePassword,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          color: black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 4,
                  child: Row(
                    children: [
                      Icon(Icons.power_settings_new),
                      SizedBox(width: 10),
                      Text(
                        S.of(context).logout,
                        style: TextStyle(
                            fontFamily: 'Manrope',
                            color: black,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Container(
                  height: 44,
                  padding: px10DimenAll(context),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 5),
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: Image.asset(
                          AppImages.profile,
                        ),
                      ),
                      getScreenWidth(context) < 570
                          ? sizedBoxWidth3(context)
                          : sizedBoxWidth10(context),
                      Text(
                        "${userNames == null ? notifier.userNameData : userNames}",
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 16,
                          color: oxfordBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: 10,
                          left: 8,
                        ),
                        child: Icon(
                          AppCustomIcon.dropdownIcon,
                          size: 10,
                          color: Color(0xff131E33),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          data == false
              ? SizedBox()
              : isTabForClass(context)
              ? drawerVisible == true
              ? Provider.of<CommonNotifier>(context, listen: false)
              .updateUserVerifiedBool ==
              false
              ? SizedBox()
              : IconButton(
            onPressed: () {
              ancestorScaffold!.openEndDrawer();
            },
            icon: Icon(
              Icons.menu,
              color: black,
            ),
          )
              : SizedBox()
              : SizedBox(),
        ],
      ),
    );
  }));
}

Widget buildButtonMobile(context,
    {name,
      fontSize,
      fontWeight,
      fontColor,
      color,
      width,
      height,
      onPressed,
      style}) {
  return SizedBox(
    height: height,
    width: width ?? getScreenWidth(context) * 0.25,
    child: ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ))),
      child: Text(
        name ?? '',
        style: style ?? webButtonSingupStyle(context),
      ),
      onPressed: onPressed ?? () {},
    ),
  );
}

String dashboardDateFormatter() {
  DateTime today = new DateTime.now();
  String formattedDate = DateFormat('EEEE').format(today);
  String dateSlug =
      "$formattedDate ${today.day.toString()}th, ${today.year.toString()}";

  return dateSlug;
}

logoutAlert(BuildContext context) {
  Widget cancelButton = TextButton(
    child: Text("No"),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop('dialog');
    },
  );
  Widget continueButton = TextButton(
    child: Text("Yes"),
    onPressed: () async {
      Provider.of<CommonNotifier>(context, listen: false)
          .updateLoginData(false);
      String? country_ =
      await SharedPreferencesMobileWeb.instance.getCountry(country);
      if (country_ == AustraliaName) {
        AuthRepositoryAus().apiLogout(context);
        SharedPreferencesMobileWeb.instance.removeParticularKey(dashboardCalc);
        SharedPreferencesMobileWeb.instance.removeParticularKey(userName);
        SharedPreferencesMobileWeb.instance.removeParticularKey(apiToken);
      } else {
        AuthRepository().apiLogout(context);
        SharedPreferencesMobileWeb.instance.removeParticularKey(dashboardCalc);
        SharedPreferencesMobileWeb.instance.removeParticularKey(userName);
        SharedPreferencesMobileWeb.instance.removeParticularKey(apiToken);
      }
      stopTimer(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Logout"),
    content: Text("Are you sure, do you want to logout?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  CupertinoAlertDialog alertios = CupertinoAlertDialog(
    title: Text("Logout"),
    content: Text("Are you sure, do you want to logout?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

fundTransferCloseAlert(BuildContext context, {navigation}) {
  Widget cancelButton = TextButton(
    child: Text("No"),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop('dialog');
    },
  );
  Widget continueButton = TextButton(
    child: Text("Yes"),
    onPressed: navigation,
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Cancel Transaction"),
    content: Text("Are you sure, would you like to cancel transaction?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  CupertinoAlertDialog alertios = CupertinoAlertDialog(
    title: Text("Cancel Transaction"),
    content: Text("Are you sure, would you like to cancel transaction?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AppInActiveCheck(context: context, child: alert);
    },
  );
}

downloadEmptyDialog(BuildContext context) {
  Widget cancelButton = TextButton(
    child: Text("No"),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop('dialog');
    },
  );
  Widget continueButton = TextButton(
    child: Text("Ok"),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop('dialog');
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("No Statement"),
    content: Text("There is no statement to download."),
    actions: [
      continueButton,
    ],
  );

  CupertinoAlertDialog alertios = CupertinoAlertDialog(
    title: Text("No Statement"),
    content: Text("There is no statement to download."),
    actions: [
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AppInActiveCheck(context: context, child: alert);
    },
  );
}

registerCloseAlert(BuildContext context) {
  Widget cancelButton = TextButton(
    child: Text("No"),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop('dialog');
    },
  );
  Widget continueButton = TextButton(
    child: Text("Yes"),
    onPressed: () async {
      Provider.of<CommonNotifier>(context, listen: false)
          .updateUserVerifiedBool = false;
      await SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        Navigator.pushNamedAndRemoveUntil(
            context, dashBoardRoute, (route) => false);
      });
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Skip Registration"),
    content: Text("Are you sure, do you want to skip the register?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  CupertinoAlertDialog alertios = CupertinoAlertDialog(
    title: Text("Skip Registration"),
    content: Text("Are you sure, do you want to skip the register?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

successAlertDialog(context) {
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
              child: Container(
                padding: px5DimenAll(context),
                height: AppConstants.eighty,
                width: getScreenWidth(context) < 765
                    ? getScreenWidth(context) * 0.8
                    : getScreenWidth(context) * 0.5,
                child: Row(
                  children: [
                    Icon(
                      Icons.check,
                      color: black,
                      size: 20,
                    ),
                    sizedBoxWidth10(context),
                    buildText(
                        text: S.of(context).passwordUpdatedSuccessful,
                        fontSize: getScreenWidth(context) < 765
                            ? AppConstants.twelve
                            : AppConstants.sixteen,
                        fontWeight: getScreenWidth(context) < 765
                            ? FontWeight.w400
                            : FontWeight.w700,
                        fontColor: black),
                    Spacer(),
                    buildButtonMobile(
                      context,
                      name: S.of(context).oK,
                      onPressed: () async {
                        await SharedPreferencesMobileWeb.instance
                            .getCountry(country)
                            .then((value) async {
                          Navigator.pushNamedAndRemoveUntil(
                              context, dashBoardRoute, (route) => false);
                        });
                      },
                      style: TextStyle(
                        fontSize: AppConstants.sixteen,
                        fontWeight: AppFont.fontWeightBold,
                        color: Colors.white,
                      ),
                      width: AppConstants.sixty,
                      height: AppConstants.fortyTwo,
                      fontColor: white,
                      color: hanBlue,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}


inActiveAlert(BuildContext context) {
  Widget cancelButton = TextButton(
    child: Text("No"),
    onPressed: () {
      startTimer(context);
      Navigator.of(context, rootNavigator: true).pop('dialog');
    },
  );
  Widget continueButton = TextButton(
    child: Text("Yes"),
    onPressed: () {
      Provider.of<CommonNotifier>(context, listen: false)
          .updateLoginData(false);
      SharedPreferencesMobileWeb.instance.removeParticularKey(apiToken);
      Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("User InActivity"),
    content:
    Text("You are inactive for more than 10 min, Do you want to logout?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  CupertinoAlertDialog alertios = CupertinoAlertDialog(
    title: Text("User InActivity"),
    content:
    Text("You are inactive for more than 10 min, Do you want to logout?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(content),
        duration: const Duration(seconds: 3),
      ),
    );
}

int i = 0;
var screenSizeWidth = 0.0;
var screenSizeHeight = 0.0;

userCheck(BuildContext context) async {
  await SharedPreferencesMobileWeb.instance
      .getAccessToken(apiToken)
      .then((value) async {
    if (value.toString().trim().length < 1 && i != 1) {
      i = 1;
      if (ModalRoute.of(context)!.settings.name != loginRoute) {
        SharedPreferencesMobileWeb.instance.removeParticularKey(apiToken);
        Navigator.pushNamedAndRemoveUntil(
            context, loginRoute, (route) => false);
      } else {}
    } else {}
  });

  await SharedPreferencesMobileWeb.instance.getScreenSize(screenWidth).then((double value) async{
    screenSizeWidth = await  value;
  } );


  await SharedPreferencesMobileWeb.instance.getScreenSize1('height').then((double value) async{
    screenSizeHeight = await  value;
  } );
}

apiLoader(BuildContext context, {from}) {
  return showDialog(
    context: context,
    barrierColor: from == "web" ? Colors.white : null,
    barrierDismissible: false,
    builder: (context) {
      return Center(
        child: defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoActivityIndicator(radius: 30)
            : CircularProgressIndicator(strokeWidth: 3),
      );
    },
  );
}

apiVerificationLoader(BuildContext context, {from}) {
  return showDialog(
    context: context,
    barrierColor: from == "web" ? Colors.white : null,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: SingleChildScrollView(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Text("Verification in-progress"),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                    child: Row(
                      children: [
                        defaultTargetPlatform == TargetPlatform.iOS
                            ? CupertinoActivityIndicator(radius: 30)
                            : CircularProgressIndicator(strokeWidth: 3),
                        sizedBoxWidth10(context),
                        Expanded(
                          child: Text("We are Trying to verify, it may take a while. Please wait"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

addingSenderAlert(BuildContext context, {void Function()? onPressed}) {
  Widget cancelButton = buildButton(context, name: "No", onPressed: () {
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }, width: 100, fontColor: white, color: orangePantone);
  Widget continueButton = buildButton(context,
      name: "Yes",
      onPressed: onPressed,
      width: 100,
      fontColor: white,
      color: orangePantone);
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
      title: Row(
        children: [
          Expanded(
              child: Align(
                  alignment: Alignment.center,
                  child: buildText(
                      text: "Verification",
                      fontSize: 25,
                      fontColor: orangePantone))),
          IconButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
              icon: Icon(
                Icons.close,
                color: orangePantone,
              ))
        ],
      ),
      content: Text(
          "Please note that we do not accept third party payments.\n\nAre you the main or joint account holder of this account?"),
      actions: [
        cancelButton,
        sizedBoxWidth5(context),
        continueButton,
      ],
      actionsAlignment: MainAxisAlignment.center);

  CupertinoAlertDialog alertios = CupertinoAlertDialog(
    title: Row(
      children: [
        Expanded(
            child: Align(
                alignment: Alignment.center,
                child: buildText(
                    text: "Verification",
                    fontSize: 25,
                    fontColor: orangePantone))),
        IconButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');
            },
            icon: Icon(
              Icons.close,
              color: orangePantone,
            ))
      ],
    ),
    content: Text(
        "Please note that we do not accept third party payments.\n\nAre you the main or joint account holder of this account?"),
    actions: [
      cancelButton,
      sizedBoxWidth10(context),
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Timer? timer;

void refreshToken() {
  timer = Timer.periodic(const Duration(minutes: 10), (timer) async {
    String yourToken = "";
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      yourToken = value;
    });

    if (yourToken != "") {
      DateTime expirationDate = JwtDecoder.getExpirationDate(yourToken);
      DateTime now = DateTime.now();
      var currentTime = now.add(Duration(minutes: 5));

      if (currentTime.isAfter(expirationDate)) {
        if (JwtDecoder.isExpired(yourToken)) {
          Future.delayed(Duration.zero, () {
            AuthRepository().apiRefreshToken();
          });
        }
      }
    }
  });
}