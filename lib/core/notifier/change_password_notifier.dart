import 'package:flutter/material.dart';
import 'package:singx/core/base/base_change_notifier.dart';
import 'package:singx/utils/common/app_widgets.dart';
import '../../utils/common/dummy_data.dart';
import '../../utils/shared_preference/shared_preference_mobile_web.dart';

class ChangePasswordNotifier extends BaseChangeNotifier {

  //To Load Initial Data From API and Local Storage
  ChangePasswordNotifier(BuildContext context) {
    userCheck(context);
    SharedPreferencesMobileWeb.instance.getCountry(country).then((value) {
      countryName = value;
    });
    SharedPreferencesMobileWeb.instance
        .getContactId(apiContactId)
        .then((value) {
      contactId = value;
    });
  }

  // Key for validating fields
  GlobalKey<FormState> oldPasswordKey = GlobalKey<FormState>();
  GlobalKey<FormState> newPasswordKey = GlobalKey<FormState>();

  // Boolean values
  bool _isCurrentPasswordVisible = true;
  bool _isNewPasswordVisible = true;

  // Controller
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordEmailController = TextEditingController();
  ScrollController scrollController = ScrollController();

  //String Values
  String _errorMessage = "";
  String _countryName = "";

  // Integer
  int _contactId = 0;

  // FocusNode
  FocusNode newPasswordFocusNode = FocusNode();
  FocusNode currentPasswordFocusNode = FocusNode();

  // Getter and Setter
  int get contactId => _contactId;

  set contactId(int value) {
    _contactId = value;
  }

  String get countryName => _countryName;

  set countryName(String value) {
    if (value == _countryName) return;
    _countryName = value;
    notifyListeners();
  }

  String get errorMessage => _errorMessage;

  set errorMessage(String value) {
    if (value == _errorMessage) return;
    _errorMessage = value;
    notifyListeners();
  }

  bool get isCurrentPasswordVisible => _isCurrentPasswordVisible;

  set isCurrentPasswordVisible(bool value) {
    if (value == _isCurrentPasswordVisible) {
      return;
    }
    _isCurrentPasswordVisible = value;
    notifyListeners();
  }

  bool get isNewPasswordVisible => _isNewPasswordVisible;

  set isNewPasswordVisible(bool value) {
    if (value == _isNewPasswordVisible) {
      return;
    }
    _isNewPasswordVisible = value;
    notifyListeners();
  }
}
