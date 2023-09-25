import 'package:flutter/material.dart';
import 'package:singx/core/base/base_change_notifier.dart';
import 'package:singx/utils/common/app_constants.dart';

class ForgetPasswordNotifier extends BaseChangeNotifier {

  // Data Controller
  TextEditingController _otpController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  // Scroll Controller
  ScrollController scrollController = ScrollController();
  ScrollController scrollController1 = ScrollController();


  // Boolean
  bool _isNewPasswordVisible = true;
  bool _isTimer = false;
  bool _isError = false;

  // Form key
  GlobalKey<FormState> _uploadAddressFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();

  // String
  String _loginErrorMessage = "";
  String _selectedCountryDropdown = AppConstants.singapore;

  // Getter and setter
  String get loginErrorMessage => _loginErrorMessage;

  set loginErrorMessage(String value) {
    _loginErrorMessage = value;
    notifyListeners();
  }

  String get selectedCountryDropdown => _selectedCountryDropdown;

  set selectedCountryDropdown(String value) {
    _selectedCountryDropdown = value;
    notifyListeners();
  }

  get newPasswordController => _newPasswordController;

  set newPasswordController(value) {
    if (value == _newPasswordController) return;
    _newPasswordController = value;
    notifyListeners();
  }

  get otpController => _otpController;

  set otpController(value) {
    if (value == _otpController) return;
    _otpController = value;
    notifyListeners();
  }

  bool get isNewPasswordVisible => _isNewPasswordVisible;

  set isNewPasswordVisible(bool value) {
    if (value == _isNewPasswordVisible) return;
    _isNewPasswordVisible = value;
    notifyListeners();
  }


  bool get isTimer => _isTimer;

  set isTimer(bool value) {
    if (value == _isTimer) return;
    _isTimer = value;
    notifyListeners();
  }

  bool get isError => _isError;

  set isError(bool value) {
    if (value == _isError) return;
    _isError = value;
    notifyListeners();
  }

  GlobalKey<FormState> get uploadAddressFormKey => _uploadAddressFormKey;

  set uploadAddressFormKey(GlobalKey<FormState> value) {
    if (value == _uploadAddressFormKey) return;
    _uploadAddressFormKey = value;
    notifyListeners();
  }
}
