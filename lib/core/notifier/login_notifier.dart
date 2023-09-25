import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:singx/core/base/base_change_notifier.dart';
import 'package:singx/core/data/remote/service/auth_repository.dart';
import 'package:singx/core/models/request_response/login/login_request.dart';
import 'package:singx/core/models/request_response/login/login_request_aus.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';
import 'package:universal_html/html.dart' as html;

class LoginNotifier extends BaseChangeNotifier {

  // Data controller
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController registerEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  TextEditingController registerPasswordController = TextEditingController();
  TextEditingController registerMobileController = TextEditingController();

  // Scroll controller
  final ScrollController scrollController = ScrollController();
  final ScrollController scrollController2 = ScrollController();
  final ScrollController scrollController3 = ScrollController();

  //boolean value
  bool _isPasswordVisible = false;
  bool _enableLoginWithFaceId = false;
  bool _isAgreeCondition = false;
  bool _isAgreePolicy = false;
  bool _errorCheck = false;
  bool _isEmailChecked = false;
  bool _canCheckBiometrics = false;
  bool? isUserLogin = false;

  // List values
  List _availableBiometrics = [];

  // focusnode
  FocusNode passwordFocusNode = FocusNode();

  //Local Authentication
  final localAuthentication = LocalAuthentication();

  //global key
  final GlobalKey<FormState> emailKey = GlobalKey<FormState>();
  final GlobalKey<FormState> mobileKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordKey = GlobalKey<FormState>();

  // String value
  String? _loginDropdown;
  String? _registerDropdown;
  String countryName = 'Singapore';
  String loginErrorMessage = "";
  String registerErrorMessage = "";

  List restrictedClass = [
    "manageWallet",
    "manageReceiver",
    "addNewReceiver",
    "manageSender",
    "addNewSender",
    "activities",
    "indiaBillPayment",
    "newBillPayment",
    "bankDetails"
  ];

  void asyncMethod(BuildContext context) async {
    if (kIsWeb) {
      await SharedPreferencesMobileWeb.instance
          .getUserVerified()
          .then((value) async {
        if(value == false){
          restrictedClass.forEach((element) {
            if(Uri.parse(html.window.location.href).pathSegments.last.contains(element)){
              Navigator.popAndPushNamed(context, dashBoardRoute);
            }
          });
        }else{
          if (Uri.parse(html.window.location.href).pathSegments.last == "login" ) {
            await SharedPreferencesMobileWeb.instance
                .getAccessToken(AppConstants.apiToken)
                .then((value) {
              if (value.isNotEmpty) {
                Navigator.popAndPushNamed(context, dashBoardRoute);
              }
            });
          }
        }
      });

      // if (Uri.parse(html.window.location.href).pathSegments.last == "login" ) {
      //   await SharedPreferencesMobileWeb.instance
      //       .getAccessToken(AppConstants.apiToken)
      //       .then((value) {
      //     if (value.isNotEmpty) {
      //       Navigator.popAndPushNamed(context, dashBoardRoute);
      //     } else {}
      //   });
      // }
    }
    await SharedPreferencesMobileWeb.instance
        .getEmailAddress(AppConstants.emailAddress)
        .then((value) async {
      if (value.toString().trim().length < 1) return;
      loginEmailController.text = await value;
      enableLoginWithFaceId = true;
    });
    await SharedPreferencesMobileWeb.instance
        .getPasswordAddress(AppConstants.passwordAddress)
        .then((value) async {
      if (value.toString().trim().length < 1) return;
      loginPasswordController.text = await value;
      isEmailChecked = true;
    });
    await SharedPreferencesMobileWeb.instance
        .getSelectedCountry(AppConstants.selectedCountryAddress)
        .then((value) async {
      if (value.toString().trim().length < 1) return;
      loginDropdown = await value;
      isEmailChecked = true;
    });
    if (!kIsWeb) {
      await localAuthentication.canCheckBiometrics;
    }
  }

  //  Checking biometrics
  Future<void> localAuth(BuildContext context) async {
    final localAuth = LocalAuthentication();
    final availableBiometrics = await localAuth.getAvailableBiometrics();
    final availableLcok = await localAuth.isDeviceSupported();

    if (availableBiometrics.isEmpty == true && availableLcok == false) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(AppConstants.pleaseAddBiometric),
          duration: Duration(seconds: 3),
        ));
    } else {
      final didAuthenticate = await localAuth.authenticate(
          localizedReason: AppConstants.pleaseAuthenticate,
          options: AuthenticationOptions(useErrorDialogs: true));

      if (didAuthenticate) {
        if (loginDropdown == AppConstants.australia) {
          await AuthRepository()
              .apiUserLoginAustralia(
                  LoginAustraliaRequest(
                    username: loginEmailController.text,
                    password: loginPasswordController.text,
                  ),
                  context)
              .then((value) {
            ErrorMessageGet = value.toString();
          });
        } else {
          AuthRepository()
              .apiUserLogin(
                  LoginRequest(
                      username: loginEmailController.text,
                      password: loginPasswordController.text,
                      source: loginDropdown == AppConstants.singapore
                          ? AppConstants.sg
                          : AppConstants.hk),
                  context)
              .then((value) {
            ErrorMessageGet = value.toString();
          });
        }
      }
    }
  }

  // Getter and setter
  List get availableBiometrics => _availableBiometrics;

  set availableBiometrics(List value) {
    if (_availableBiometrics == value) {
      return;
    }
    _availableBiometrics = value;
    notifyListeners();
  } //String value

  String get loginDropdown => _loginDropdown!;

  set loginDropdown(String value) {
    if (value == _loginDropdown) {
      return;
    }

    _loginDropdown = value;
    notifyListeners();
  }

  String get registerDropdown => _registerDropdown!;

  set registerDropdown(String value) {
    if (value == _registerDropdown) {
      return;
    }

    _registerDropdown = value;
    notifyListeners();
  }

  LoginNotifier(BuildContext context) {
    asyncMethod(context);
    registerDropdown = AppConstants.singapore;
    loginDropdown = AppConstants.singapore;
  }

  String get ErrorMessageGet => loginErrorMessage;

  set ErrorMessageGet(String value) {
    if (value == loginErrorMessage) return;
    loginErrorMessage = value;
    notifyListeners();
  }

  String get RegisterErrorMessageGet => registerErrorMessage;

  set RegisterErrorMessageGet(String value) {
    if (value == registerErrorMessage) return;
    registerErrorMessage = value;
    notifyListeners();
  }

  bool get enableLoginWithFaceId => _enableLoginWithFaceId;

  set enableLoginWithFaceId(bool value) {
    if (value == _enableLoginWithFaceId) return;
    _enableLoginWithFaceId = value;
    notifyListeners();
  }

  set isUser_Login(value) {
    if (value == isUserLogin) {
      return;
    }

    isUserLogin = value;
    notifyListeners();
  }

  set country_Name(value) {
    if (value == countryName) {
      return;
    }

    countryName = value;
    notifyListeners();
  }

  set isPasswordVisible(value) {
    if (value == _isPasswordVisible) {
      return;
    }

    _isPasswordVisible = value;
    notifyListeners();
  }

  get isPasswordVisible => _isPasswordVisible;

  set isAgreeCondition(value) {
    if (value == _isAgreeCondition) {
      return;
    }
    _isAgreeCondition = value;
    notifyListeners();
  }

  get isAgreeCondition => _isAgreeCondition;

  set isAgreePolicy(value) {
    if (value == _isAgreePolicy) {
      return;
    }

    _isAgreePolicy = value;
    notifyListeners();
  }

  get isAgreePolicy => _isAgreePolicy;

  set errorCheck(value) {
    if (value == _errorCheck) {
      return;
    }

    _errorCheck = value;
    notifyListeners();
  }

  get errorCheck => _errorCheck;

  set isEmailChecked(value) {
    if (value == _isEmailChecked) {
      return;
    }

    _isEmailChecked = value;
    notifyListeners();
  }

  get isEmailChecked => _isEmailChecked;

  set canCheckBiometrics(value) {
    if (value == _canCheckBiometrics) {
      return;
    }
    _canCheckBiometrics = value;
    notifyListeners();
  }

  get canCheckBiometrics => _canCheckBiometrics;
}
