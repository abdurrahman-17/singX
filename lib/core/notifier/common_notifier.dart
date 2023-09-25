import 'package:flutter/material.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class CommonNotifier extends ChangeNotifier {

  // Integer value
  int _count = 1;
  int bottomIndex = 0;
  int fundCount = 1;

  // String value
  String classNameData = "";
  String? classNameNavigationData;
  String _countryData = '';
  String _userNameData = '';
  String _countryName = '';
  String _countryOfRes = AppConstants.singapore;
  String currentTheme = 'system';

  // Boolean value
  bool? _userVerified;

  bool? get updateUserVerifiedBool => _userVerified;
  bool registerMethodScreen = false;
  bool personalDetailScreen = false;
  bool verificationScreen = false;
  bool appBarLeadingIcon = false;
  bool isLogin = false;

  // Language
  Locale _currentLocale = new Locale("en");

  updateCountryOfRes(String value) {
    _countryOfRes = value;
    notifyListeners();
  }

  void updateBottomData(int newValue) {
    if (bottomIndex == newValue) {
      return;
    }
    bottomIndex = newValue;
    notifyListeners();
  }

  void updateLoginData(bool newValue) {
    if (isLogin == newValue) {
      return;
    }
    isLogin = newValue;
    notifyListeners();
  }

  void updateLeadingData(bool newValue) {
    if (appBarLeadingIcon == newValue) {
      return;
    }
    appBarLeadingIcon = newValue;
    notifyListeners();
  }

  void updateClassNameData(String newValue) {
    if (classNameData == newValue) {
      return;
    }
    classNameData = newValue;
    notifyListeners();
  }

  void updateClassNameNavigationData(String newValue) {
    if (classNameNavigationData == newValue) {
      return;
    }
    classNameNavigationData = newValue;
    notifyListeners();
  }

  void updateRegisterMethodScreenData(bool newValue) {
    if (registerMethodScreen == newValue) {
      return;
    }
    registerMethodScreen = newValue;
    notifyListeners();
  }

  void updatePersonalDetailScreenData(bool newValue) {
    if (personalDetailScreen == newValue) {
      return;
    }
    personalDetailScreen = newValue;
    notifyListeners();
  }

  void updateVerificationScreenData(bool newValue) {
    if (verificationScreen == newValue) {
      return;
    }
    verificationScreen = newValue;
    notifyListeners();
  }

  void decrementCounter() {
    _count -= 1;
    notifyListeners();
  }

  void updateData(int num) {
    if (_count == num) {
      return;
    }
    _count = num;
    notifyListeners();
  }

  void incrementCounterFund() {
    fundCount += 1;
    notifyListeners();
  }

  void updateDataFund(int num) {
    if (fundCount == num) {
      return;
    }
    fundCount = num;
    notifyListeners();
  }

  Locale get currentLocale => _currentLocale;

  ThemeMode get themeMode {
    if (currentTheme == 'light') {
      return ThemeMode.light;
    } else if (currentTheme == 'dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  setAppBarName() async {
    await SharedPreferencesMobileWeb.instance
        .getCountry(AppConstants.country)
        .then((value) async {
      countryData = await value;
      await SharedPreferencesMobileWeb.instance
          .getUserName(AppConstants.userName)
          .then((valueName) async {
        userNameData = valueName;
        if (userNameData.isEmpty || userNameData == " ") {
          userNameData = "SingX";
        }
      });
    });
  }

  // Getter and Setter
  set updateUserVerifiedBool(bool? value) {
    if (_userVerified == value) return;
    _userVerified = value;
    notifyListeners();
  }

  String get userNameData => _userNameData;

  set userNameData(String value) {
    if (_userNameData == value) return;
    _userNameData = value;
    notifyListeners();
  }

  String get countryData => _countryData;

  set countryData(String value) {
    if (_countryData == value) return;
    _countryData = value;
    notifyListeners();
  }

  String get countryName => _countryName;

  String get countryOfRes => _countryOfRes;

  set countryOfRes(String value) {
    _countryOfRes = value;
    notifyListeners();
  }

  int get getCounter {
    return _count;
  }

  int get getBottomIndex {
    return bottomIndex;
  }
}
