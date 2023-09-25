import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singx/core/base/base_change_notifier.dart';
import 'package:singx/core/data/remote/service/auth_repository.dart';
import 'package:singx/core/data/remote/service/fx_repository.dart';
import 'package:singx/core/data/remote/service/misc_repository.dart';
import 'package:singx/core/data/remote/service/sg_wallet_repository.dart';
import 'package:singx/core/data/remote/service/transaction_repository.dart';
import 'package:singx/core/models/request_response/australia/corridors/corrdidors_response.dart';
import 'package:singx/core/models/request_response/australia/corridors/get_receiver_currency_response.dart';
import 'package:singx/core/models/request_response/australia/corridors/get_sender_currency_response.dart';
import 'package:singx/core/models/request_response/australia/customer_status/customer_status_response.dart';
import 'package:singx/core/models/request_response/dashboard_notification/dashboard_notification_response.dart';
import 'package:singx/core/models/request_response/dashboard_transaction_list/dashboard_transaction_aus_request.dart';
import 'package:singx/core/models/request_response/dashboard_transaction_list/dashboard_transaction_aus_response.dart';
import 'package:singx/core/models/request_response/edit_profile/edit_profile_response.dart';
import 'package:singx/core/models/request_response/exchange/exchange_aus_request.dart';
import 'package:singx/core/models/request_response/exchange/exchange_aus_response.dart';
import 'package:singx/core/models/request_response/exchange/exchange_request.dart';
import 'package:singx/core/models/request_response/exchange/exchange_response.dart';
import 'package:singx/core/models/request_response/referral/referral_aus_response.dart';
import 'package:singx/core/models/request_response/sg_wallet/sg_wallet_response.dart';
import 'package:singx/core/models/request_response/transaction/transacton_response.dart';
import 'package:singx/core/notifier/common_notifier.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/justToolTip/src/models/just_the_controller.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';
import '../data/remote/service/contact_repository.dart';
import '../models/request_response/australia/personal_details/CustomerDetailsResponse.dart';
import '../models/request_response/australia/save_session/save_session_request.dart';

class DashboardNotifier extends BaseChangeNotifier {


  DashboardNotifier(BuildContext context) {
    userCheck(context);
    sendController.text = "1000.00";
    getCountry(context);

    SharedPreferencesMobileWeb.instance.getCountry(country).then((value) async {
      selectedCountryData = value;
      await corridorApi(context);
      await referralApi(context);

      //This Condition checks the verified and unverified dashboard
      userVerified =
          await SharedPreferencesMobileWeb.instance.getUserVerified();
      userVerified = Provider.of<CommonNotifier>(context, listen: false)
          .updateUserVerifiedBool!;
      Provider.of<CommonNotifier>(context, listen: false)
                      .updateUserVerifiedBool ==
                  true ||
              userVerified == true
          ? selectedCountryData == AppConstants.australia
              ? await transactionAusData(context)
              : await transactionSingData(context)
          : null;

      //Wallet Api
      if (selectedCountryData == AppConstants.singapore) {
        await SharedPreferencesMobileWeb.instance
            .getUserVerified()
            .then((value) async {
          value ? await SGWalletBpApi(context) : null;
        });
        Provider.of<CommonNotifier>(context, listen: false)
                    .updateUserVerifiedBool ==
                true
            ? await SGWalletBpApi(context)
            : null;
      }

      //Data Persistence
      SharedPreferences myPrefs = await SharedPreferences.getInstance();
      myPrefs.containsKey(dashboardCalc)
          ? await SharedPreferencesMobileWeb.instance
              .getDashboardCalculatorData(dashboardCalc)
              .then((dashboardValue) async {
              if (dashboardValue.isNotEmpty) {
                Map<String, dynamic> newDashboardValue =
                    jsonDecode(dashboardValue) as Map<String, dynamic>;
                sendController.text = newDashboardValue["sendAmount"];
                recipientController.text = newDashboardValue["receiveAmount"];
                selectedSender = newDashboardValue["sendCurrency"];
                exchangeSelectedSender = newDashboardValue["sendCurrency"];
                selectedReceiver = newDashboardValue["receiveCurrency"];
                isSwift = newDashboardValue["isSwift"];
                selectedReceiver == "PHP" ? (selectedRadioTile = isCash == false ? 1 : 2) : (selectedRadioTile = isSwift == false ? 1 : 2);
                selectedRadioTile = newDashboardValue["selectedRadioTile"];
                if(selectedReceiver == "PHP") isCash = selectedRadioTile == 2 ? true : false;
                if(selectedReceiver == "BDT") isWallet = selectedRadioTile == 2 ? true : false;
                await exchangeApi(
                  context,
                  selectedSender,
                  selectedReceiver,
                  selectedCountryData == AppConstants.australia ? "First" : "Send",
                  double.parse(sendController.text),
                  true,
                );
              }
            })
          : null;

      //Notification Api
      selectedCountryData == AppConstants.australia
          ? null
          : await miscApi(context);

      //Initial Exchange API
      selectedCountryData == AppConstants.australia
          ? selectedReceiver != "PHP" ? FxRepository()
          .apiExchangeAustralia(
          ExchangeAustraliaRequest(
            contactId: contactId,
            customerType: "Individual",
            fromAmount: double.parse(sendController.text),
            fromcurrencycode: selectedSender,
            isswift: isSwift,
            label: "First",
            toAmount: 0,
            tocurrencycode: selectedReceiver,
          ),
          context)
          .then((value) {
        if (value.runtimeType == ExchangeAustraliaResponse) {
          ExchangeAustraliaResponse exchangeResponseData =
          value as ExchangeAustraliaResponse;
          singXData = double.parse(
              exchangeResponseData.response!.singxFee!.toString());
          totalPayable = double.parse(sendController.text) + singXData;
          exchagneRateConverted =
              exchangeResponseData.response!.exchangeRate.toString();
          sendController.text =
              exchangeResponseData.response!.sendamount.toString();
          recipientController.text =
              exchangeResponseData.response!.receiveamount.toString();
        } else {
          errorExchangeValue = value as String;
        }
      }) : FxRepository()
          .apiExchangeAustralia(
          ExchangeAustraliaRequest(
            contactId: contactId,
            customerType: "Individual",
            fromAmount: double.parse(sendController.text),
            fromcurrencycode: selectedSender,
            isswift: isSwift,
            label: "First",
            toAmount: 0,
            tocurrencycode: selectedReceiver,
          ),
          context)
          .then((value) {
        if (value.runtimeType == ExchangeAustraliaResponse) {
          ExchangeAustraliaResponse exchangeResponseData =
          value as ExchangeAustraliaResponse;
          singXData = double.parse(
              exchangeResponseData.response!.singxFee!.toString());
          totalPayable = double.parse(sendController.text) + singXData;
          exchagneRateConverted =
              exchangeResponseData.response!.exchangeRate.toString();
          sendController.text =
              exchangeResponseData.response!.sendamount.toString();
          recipientController.text =
              exchangeResponseData.response!.receiveamount.toString();
        } else {
          errorExchangeValue = value as String;
        }
      })
          : await FxRepository()
              .apiExchange(
                  ExchangeRequest(
                    fromCurrency: selectedSender,
                    toCurrency: selectedReceiver,
                    amount: double.parse(sendController.text),
                    type: "Send",
                    swift: isSwift,
                     cash: isCash,
                      wallet: isWallet,
                  ),
                  context)
              .then((value) {
              if (value.runtimeType == ExchangeResponse) {
                ExchangeResponse exchangeResponseData =
                    value as ExchangeResponse;
                singXData = exchangeResponseData.singxFee!;
                totalPayable = exchangeResponseData.totalPayable!;
                exchagneRateConverted =
                    exchangeResponseData.exchangeRate!.toString();
                sendController.text =
                    exchangeResponseData.sendAmount.toString();
                recipientController.text =
                    exchangeResponseData.receiveAmount.toString();
                errorExchangeValue = exchangeResponseData.errors!.isEmpty ? '' : exchangeResponseData.errors!.first;
              } else {
                errorExchangeValue = value as String;
              }
            });


      //For Data Persistence
      if(myPrefs.containsKey(dashboardCalc)){
        await SharedPreferencesMobileWeb.instance
            .getDashboardCalculatorData(dashboardCalc)
            .then((value) async {
          Map<String, dynamic> newValue =
          jsonDecode(value) as Map<String, dynamic>;
          sendController.text = newValue["sendAmount"];
          recipientController.text = newValue["receiveAmount"];
          selectedSender = newValue["sendCurrency"];
          selectedReceiver = newValue["receiveCurrency"];
          isSwift = newValue["isSwift"];
          selectedReceiver == "PHP" ? (selectedRadioTile = isCash == false ? 1 : 2) : (selectedRadioTile = isSwift == false ? 1 : 2);
          selectedRadioTile = newValue["selectedRadioTile"];
          exchangeSelectedReceiver = selectedReceiver;
          await exchangeApi(
            context,
            selectedSender,
            selectedReceiver,
            selectedCountryData == AppConstants.australia
                ? "First"
                : "Send",
            double.parse(sendController.text),
            true,
          );
        });
      }

      //Checking User Status According to that will show the message.
      selectedCountryData == AppConstants.australia
          ? AuthRepository()
              .apiCustomerStatus(contactId, context)
              .then((value) {
              CustomerStatusResponse customerStatusResponse =
                  value as CustomerStatusResponse;
              error = customerStatusResponse.statusId!.toString();
              notifyListeners();
            })
          : AuthRepository().apiAuthDetail(context).then((value) {
              String customerStatusResponse = value as String;
              error = customerStatusResponse;
              notifyListeners();
            });
    });

    //Getting Device Id
    initPlatformState(context);
  }


  //Global Key
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();

  //Text Field controller
  TextEditingController _sendController = TextEditingController();
  TextEditingController _recipientController = TextEditingController();

  //Scroll Controller
  ScrollController _scrollController = ScrollController();


  //String Data
  String _webDeviceId = '';
  String _androidDeviceId = '';
  String _iosDeviceId = '';
  String _SGWalletBal = '';
  String _checkTransferLimit = '';
  String _error = '';
  String? _name;
  String _selectedSender = '';
  String _selectedReceiver = '';
  String _selected = 'Singapore';
  String _selectedCountryData = "";
  String _initialDataValue = "";
  String _errorExchangeValue = "";
  String _test = '';
  String _referralCodeData = "";
  String _exchagneRateInital = "0";
  String _exchagneRateConverted = "0";
  String _exchangeSelectedSender = "";
  String _exchangeSelectedReceiver = "";

  //boolean Data
  bool _referralCopied = false;
  bool _isSwift = false;
  bool _isCash = false;
  bool _isWallet = false;
  bool _userVerified = false;
  bool _getVerified = true;
  bool _unfinished = true;
  bool _topVerifyValidation = true;
  bool _amountValidation = false;
  bool _exchangeData = false;

  //Integer Data
  int _contactId = 0;
  int _selectedRadioTile = 1;
  int _selectedTransferMode = 1;

  //double Data
  double _singXData = 0;
  double _totalPayable = 0;

  //List data
  List<String> _senderData = [];
  List<DashboardTransactionAustraliaResponse> _transactionListData = [];
  List<Content> _transactionSingListData = [];
  List<DashboardNotificationResponse> _notificationData = [];
  List<String> _receiverData = [];

  //Custom DataTypes
  DateTime? currentBackPressTime;
  ContactRepository contactRepository = ContactRepository();
  FxRepository fxRepository = FxRepository();



  //Functions
  Future<void> initPlatformState(context) async {
    String? deviceId;

    try {
      // deviceId = await PlatformDeviceId.getDeviceId;
      deviceId = "";
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }

    if (kIsWeb) {
      webDeviceId = deviceId!;
    } else if (Platform.isAndroid) {
      androidDeviceId = deviceId!;
    } else if (Platform.isMacOS || Platform.isIOS) {
      iosDeviceId = deviceId!;
    } else {}

    callSaveSession(context);
  }

  getData(context) async {
    if (selectedCountryData == AustraliaName) {
      CustomerDetailsResponse? response = await contactRepository
          .getCustomerDetails(context, contactId.toString());
      await SharedPreferencesMobileWeb.instance
          .setUserName(userName, response.firstName ?? "User");
      await SharedPreferencesMobileWeb.instance.setPhoneNumber(
          AppConstants.phoneNumber, "${response.countryCode}${response.phoneNumber}" ?? "");
      name = response.firstName?? "User";
    } else {
      ContactRepository().apiEditProfile(context).then((value) async {
        EditProfileResponse responseData = value as EditProfileResponse;
        await SharedPreferencesMobileWeb.instance
            .setUserName(userName, responseData.firstName!);
        name = responseData.firstName!;
      });
    }
  }

  referralApi(BuildContext context) async {
    if (selectedCountryData == AppConstants.australia) {
      await FxRepository().apiReferralAus(context).then((value) {
        ReferralAusResponse referralData = value as ReferralAusResponse;
        referralCodeData = referralData.referralCode!;
      });
    } else {
      await SharedPreferencesMobileWeb.instance.getUserData(AppConstants.user).then((value) {
        Map<String, dynamic> loginData =
        jsonDecode(value) as Map<String, dynamic>;
        referralCodeData = loginData["userinfo"]["referralCode"] == ""
            ? ""
            : loginData["userinfo"]["referralCode"];
      });
    }
  }

  miscApi(BuildContext context) async {
    await MiscRepository().apiDashboardNotification(context).then((value) {
      List<DashboardNotificationResponse> dashboardData =
      value as List<DashboardNotificationResponse>;
      notificationData.addAll(dashboardData.isNotEmpty ? dashboardData : []);
    });
  }

  SGWalletBpApi(BuildContext context) async {
    await SGWalletRepository().SGWalletBalance(context).then((value) {
      if (value != null) {
        SgWalletBalance sgWalletBalance = value as SgWalletBalance;
        SGWalletBal = sgWalletBalance.balance!;
      }
    });
  }

  transactionAusData(BuildContext context) async {
    final startDate = DateTime(
        DateTime.now().year, DateTime.now().month - 2, DateTime.now().day);
    final endDate = DateTime.now();
    final startDateAPI = DateFormat('yyy-MM-dd').format(startDate).toString();
    final endDateAPI = DateFormat('yyy-MM-dd').format(endDate).toString();
    await FxRepository()
        .apiDashboardTransactionAus(
        DashboardTransactionAustraliaRequest(
          allstatus: true,
          contactId: contactId,
          frmdt: startDateAPI,
          todt: endDateAPI,
          stageId: 0,
        ),
        context)
        .then((value) {
      List<DashboardTransactionAustraliaResponse>
      dashboardTransactionAustraliaResponse =
      value as List<DashboardTransactionAustraliaResponse>;
      transactionListData.addAll(
          dashboardTransactionAustraliaResponse.isEmpty ||
              dashboardTransactionAustraliaResponse.length < 5
              ? dashboardTransactionAustraliaResponse
              : dashboardTransactionAustraliaResponse.getRange(0, 5));
    });
  }

  transactionSingData(BuildContext context) async {
    await TransactionRepository()
        .apiActivitiesTransaction(
        "?page=0&size=5&filter=", null, null, null, null, null)
        .then((value) {
      TransactionResponse transactionResponse =
      TransactionResponse.fromJson(value);
      transactionSingListData.addAll(transactionResponse.content == null ? [] : transactionResponse.content!.isEmpty ||
          transactionResponse.content!.length < 5
          ? transactionResponse.content!
          : transactionResponse.content!.getRange(0, 5));
    });
  }

  exchangeApi(BuildContext context, String fromCurrency, String toCurrency,
      String typeData, double textEdit, bool canChangeExchange) async {
    errorExchangeValue = "";
    // if(selectedCountryData == AppConstants.australia) dataTransferLimitMessage(context, DashboardNotifier(context), country);
    selectedCountryData == AppConstants.australia
        ? (selectedReceiver == "PHP" && isSwift == true) ? await FxRepository()
        .apiExchangePHPAustralia(
        ExchangeAustraliaRequest(
          tocurrencycode: toCurrency,
          label: typeData,
          toAmount: double.parse(recipientController.text),
          isswift: isSwift,
          fromcurrencycode: fromCurrency,
          fromAmount: double.parse(sendController.text),
          customerType: "Individual",
          contactId: contactId,
        ),
        context)
        .then((value)async {
      if (value.runtimeType == ExchangeAustraliaResponse) {
        ExchangeAustraliaResponse exchangeResponseData =
        value as ExchangeAustraliaResponse;
        singXData = double.parse(
            exchangeResponseData.response!.singxFee!.toString());
        totalPayable = double.parse(sendController.text) + singXData;
        if(canChangeExchange == true) exchagneRateConverted =
            exchangeResponseData.response!.exchangeRate.toString();
        typeData == "Second"
            ? sendController.text =
            exchangeResponseData.response!.sendamount.toString()
            : recipientController.text =
            exchangeResponseData.response!.receiveamount.toString();
        await SharedPreferencesMobileWeb.instance
            .setCountryId(exchangeResponseData.response!.tocountryId!);
      } else {
        errorExchangeValue = value as String;
      }
    }) : await FxRepository()
        .apiExchangeAustralia(
        ExchangeAustraliaRequest(
          tocurrencycode: toCurrency,
          label: typeData,
          toAmount: double.parse(recipientController.text),
          isswift: isSwift,
          fromcurrencycode: fromCurrency,
          fromAmount: double.parse(sendController.text),
          customerType: "Individual",
          contactId: contactId,
        ),
        context)
        .then((value) async{
      if (value.runtimeType == ExchangeAustraliaResponse) {
        ExchangeAustraliaResponse exchangeResponseData =
        value as ExchangeAustraliaResponse;
        singXData = double.parse(
            exchangeResponseData.response!.singxFee!.toString());
        totalPayable = double.parse(sendController.text) + singXData;
        if(canChangeExchange == true) exchagneRateConverted =
            exchangeResponseData.response!.exchangeRate.toString();
        typeData == "Second"
            ? sendController.text =
            exchangeResponseData.response!.sendamount.toString()
            : recipientController.text =
            exchangeResponseData.response!.receiveamount.toString();
        await SharedPreferencesMobileWeb.instance
            .setCountryId(exchangeResponseData.response!.tocountryId!);
      } else {
        errorExchangeValue = value as String;
      }
    })
        : await FxRepository()
        .apiExchange(
        ExchangeRequest(
            fromCurrency: fromCurrency,
            toCurrency: toCurrency,
            amount: textEdit,
            type: typeData,
            cash: isCash,
            swift: isSwift,
            wallet: isWallet),
        context)
        .then((value)async {
      if (value.runtimeType == ExchangeResponse) {
        ExchangeResponse exchangeResponseData = value as ExchangeResponse;
        singXData = exchangeResponseData.singxFee!;
        totalPayable = exchangeResponseData.totalPayable!;
        if(canChangeExchange == true) exchagneRateConverted =
            exchangeResponseData.exchangeRate!.toString();
        errorExchangeValue = exchangeResponseData.errors!.isEmpty ? '' : exchangeResponseData.errors!.first;
        typeData == "Send"
            ? recipientController.text = exchangeResponseData.receiveAmount.toString()
            : sendController.text =
            exchangeResponseData.sendAmount.toString();
        // typeData == "Send"
        //     ? recipientController.text = sendController.text == "0"
        //         ? "0"
        //         : exchangeResponseData.receiveAmount.toString()
        //     : null;
      } else {
        errorExchangeValue = value as String;
      }
    });
  }

  corridorApi(BuildContext context) async {
    selectedCountryData == AppConstants.australia
        ? {
      await FxRepository().apiSenderCurrency(context).then((value) {
        List<GetSenderCurrencyAustraliaResponse> corridorData =
        value as List<GetSenderCurrencyAustraliaResponse>;
        corridorData.forEach((element) {
          senderData.add(element.currencyCode!);
        });
        selectedSender = senderData.first;
        exchangeSelectedSender = selectedSender;
      }),
      await FxRepository().apiReceiverCurrency(context).then((value) {
        List<GetReceiverCurrencyAustraliaResponse> corridorData =
        value as List<GetReceiverCurrencyAustraliaResponse>;
        corridorData.forEach((element) {
          ReceiverData.add(element.currencyCode!);
        });
        selectedReceiver = ReceiverData.first;
        exchangeSelectedReceiver = selectedReceiver;
      })
    }
        : selectedCountryData == AppConstants.hongKong
        ? {
      await FxRepository().apiCorridors(context).then((value) {
        Map<String, List<CorridorsResponse>> corridorData =
        value as Map<String, List<CorridorsResponse>>;
        corridorData.forEach((key, value) {
          if (selectedCountryData == HongKongName) {
            if (key == "HKD") senderData.add(key);
          }
        });
        selectedSender = senderData.first;
        exchangeSelectedSender = selectedSender;

        FxRepository().corridorResponseData.forEach((key, value) {
          if (_selectedSender == key) {
            value.forEach((element) {
              ReceiverData.add(element.key!);
            });
          }
        });
        selectedReceiver = ReceiverData.first;
        exchangeSelectedReceiver = selectedReceiver;
      })
    }
        : await FxRepository().apiCorridors(context).then((value) {
      Map<String, List<CorridorsResponse>> corridorData =
      value as Map<String, List<CorridorsResponse>>;
      corridorData.forEach((key, value) {
        senderData.add(key);
      });
      selectedSender = senderData.first;
      exchangeSelectedSender = selectedSender;

      FxRepository().corridorResponseData.forEach((key, value) {
        if (_selectedSender == key) {
          value.forEach((element) {
            ReceiverData.add(element.key!);
          });
        }
      });
      selectedReceiver = ReceiverData.first;
      exchangeSelectedReceiver = selectedReceiver;
    });
  }

  callSaveSession(context) async {
    int? contactId;
    String? emailData;
    await SharedPreferencesMobileWeb.instance
        .getEmail(email)
        .then((value) async {
      emailData = value;
      await SharedPreferencesMobileWeb.instance
          .getContactId(apiContactId)
          .then((value) async {
        contactId = value;
      });
    });
  }

  setSelectedRadioTile(int val) {
    selectedRadioTile = val;
  }

  getCountry(BuildContext context)async{
    await SharedPreferencesMobileWeb.instance.getCountry(country).then((value) async {
      await SharedPreferencesMobileWeb.instance
          .getContactId(apiContactId)
          .then((value) async {
        contactId = value;
        getData(context);
      });
    });
  }


  bool get userVerified => _userVerified;

  set userVerified(bool value) {
    if (_userVerified == value) return;
    _userVerified = value;
    notifyListeners();
  }

  bool get isCash => _isCash;

  set isCash(bool value) {
    if (_isCash == value) return;
    _isCash = value;
    notifyListeners();
  }

  bool get isWallet => _isWallet;

  set isWallet(bool value) {
    if (_isWallet == value) return;
    _isWallet = value;
    notifyListeners();
  }

  bool get isSwift => _isSwift;

  set isSwift(bool value) {
    if (value == _isSwift) return;
    _isSwift = value;
    notifyListeners();
  }

  bool get referralCopied => _referralCopied;

  set referralCopied(bool value) {
    if (value == _referralCopied) return;
    _referralCopied = value;
    notifyListeners();
  }

  String? get name => (_name != null) ? _name : "";

  set name(String? value) {
    _name = value! + "";
    notifyListeners();
  }

  String get checkTransferLimit => _checkTransferLimit;

  set checkTransferLimit(String value) {
    if (value == _checkTransferLimit) return;
    _checkTransferLimit = value;
    notifyListeners();
  }

  String get SGWalletBal => _SGWalletBal;

  set SGWalletBal(String value) {
    if (value == _SGWalletBal) return;
    _SGWalletBal = value;
    notifyListeners();
  }

  String get webDeviceId => _webDeviceId;

  set webDeviceId(String value) {
    if (value == _webDeviceId) return;
    _webDeviceId = value;
    notifyListeners();
  }

  String get androidDeviceId => _androidDeviceId;

  set androidDeviceId(String value) {
    if (value == _androidDeviceId) return;
    _androidDeviceId = value;
    notifyListeners();
  }

  String get iosDeviceId => _iosDeviceId;

  set iosDeviceId(String value) {
    if (value == _iosDeviceId) return;
    _iosDeviceId = value;
    notifyListeners();
  }



  String get error => _error;

  set error(String value) {
    if (_error == value) return;
    _error = value;
    notifyListeners();
  }

  String get test => _test;

  set test(String value) {
    _test = value;
    notifyListeners();
  }


  ScrollController get scrollController => _scrollController;

  set scrollController(ScrollController value) {
    _scrollController = value;
    notifyListeners();
  }


  TextEditingController get sendController => _sendController;

  set sendController(TextEditingController value) {
    if (_sendController == value) return;
    _sendController = value;
    notifyListeners();
  }

  TextEditingController get recipientController => _recipientController;

  set recipientController(TextEditingController value) {
    if (_recipientController == value) return;
    _recipientController = value;
    notifyListeners();
  }

  String get errorExchangeValue => _errorExchangeValue;

  set errorExchangeValue(String value) {
    if (_errorExchangeValue == value) return;
    _errorExchangeValue = value;
    notifyListeners();
  }

  int get selectedRadioTile => _selectedRadioTile;

  set selectedRadioTile(int value) {
    if (value == _selectedRadioTile) return;
    _selectedRadioTile = value;
    notifyListeners();
  }

  int get selectedTransferMode => _selectedTransferMode;

  set selectedTransferMode(int value) {
    if (value == _selectedTransferMode) return;
    _selectedTransferMode = value;
    notifyListeners();
  }



  String get referralCodeData => _referralCodeData;

  set referralCodeData(String value) {
    if (_referralCodeData == value) return;
    _referralCodeData = value;
    notifyListeners();
  }

  String get initialDataValue => _initialDataValue;

  set initialDataValue(String value) {
    _initialDataValue = value;
    notifyListeners();
  }

  String get exchagneRateInital => _exchagneRateInital;

  set exchagneRateInital(String value) {
    _exchagneRateInital = value;
    notifyListeners();
  }



  double get singXData => _singXData;

  set singXData(double value) {
    if (value == _singXData) return;
    _singXData = value;
    notifyListeners();
  }



  double get totalPayable => _totalPayable;

  set totalPayable(double value) {
    if (value == _totalPayable) return;
    _totalPayable = value;
    notifyListeners();
  }



  List<String> get senderData => _senderData;

  set senderData(List<String> value) {
    if (value == _senderData) return;
    _senderData = value;
    notifyListeners();
  }



  List<DashboardTransactionAustraliaResponse> get transactionListData =>
      _transactionListData;

  set transactionListData(List<DashboardTransactionAustraliaResponse> value) {
    if (value == _transactionListData) return;
    _transactionListData = value;
    notifyListeners();
  }



  List<Content> get transactionSingListData => _transactionSingListData;

  set transactionSingListData(List<Content> value) {
    if (value == _transactionSingListData) return;
    _transactionSingListData = value;
    notifyListeners();
  }



  List<DashboardNotificationResponse> get notificationData => _notificationData;

  set notificationData(List<DashboardNotificationResponse> value) {
    if (value == _notificationData) return;
    _notificationData = value;
    notifyListeners();
  }



  String get exchagneRateConverted => _exchagneRateConverted;

  set exchagneRateConverted(String value) {
    if (_exchagneRateConverted == value) return;
    _exchagneRateConverted = value;
    notifyListeners();
  }



  List<String> get ReceiverData => _receiverData;

  set ReceiverData(List<String> value) {
    if (value == _receiverData) return;
    _receiverData = value;
    notifyListeners();
  } //boolean value



  bool get exchangeData => _exchangeData;

  set exchangeData(bool value) {
    if (value == _exchangeData) return;
    _exchangeData = value;
    notifyListeners();
  }

  String get selectedSender => _selectedSender;

  set selectedSender(String value) {
    _selectedSender = value;
    notifyListeners();
  }

  String get selectedReceiver => _selectedReceiver;

  set selectedReceiver(String value) {
    _selectedReceiver = value;
    notifyListeners();
  }



  String get exchangeSelectedSender => _exchangeSelectedSender;

  set exchangeSelectedSender(String value) {
    if (_exchangeSelectedSender == value) return;
    _exchangeSelectedSender = value;
    notifyListeners();
  }



  String get exchangeSelectedReceiver => _exchangeSelectedReceiver;

  set exchangeSelectedReceiver(String value) {
    if (_exchangeSelectedReceiver == value) return;
    _exchangeSelectedReceiver = value;
    notifyListeners();
  }

  bool get amountValidation => _amountValidation;

  set amountValidation(bool value) {
    _amountValidation = value;
    notifyListeners();
  }

  bool get topVerifyValidation => _topVerifyValidation;

  set topVerifyValidation(bool value) {
    _topVerifyValidation = value;
    notifyListeners();
  }

  bool get unfinished => _unfinished;

  set unfinished(bool value) {
    _unfinished = value;
    notifyListeners();
  }

  bool get getVerified => _getVerified;

  set getVerified(bool value) {
    _getVerified = value;
    notifyListeners();
  }

  String get selectedCountryData => _selectedCountryData;

  set selectedCountryData(String value) {
    _selectedCountryData = value;
    notifyListeners();
  }

  int get contactId => _contactId;

  set contactId(int value) {
    _contactId = value;
    notifyListeners();
  }

  String get selected => _selected;

  set selected(String value) {
    _selected = value;
    notifyListeners();
  }
}
