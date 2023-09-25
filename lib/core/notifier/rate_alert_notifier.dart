import 'package:flutter/material.dart';
import 'package:singx/core/base/base_change_notifier.dart';
import 'package:singx/core/data/remote/service/contact_repository.dart';
import 'package:singx/core/data/remote/service/rate_alert_repository.dart';
import 'package:singx/core/models/request_response/edit_profile/edit_profile_response.dart';
import 'package:singx/core/models/request_response/login/login_response.dart';
import 'package:singx/core/models/request_response/rate_alert/CorridorIdListResponse.dart';
import 'package:singx/core/models/request_response/rate_alert/alert_list_response.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class RateAlertNotifier extends BaseChangeNotifier {
  RateAlertRepository? rateAlertRepository;
  TextEditingController INRController = TextEditingController();
  TextEditingController INRControllerPopup = TextEditingController();
  String? _selectedIndex = '';
  String _corridorId = '';
  ScrollController scrollController = ScrollController();
  String get corridorId => _corridorId;

  set corridorId(String value) {
    if (_corridorId == value) return;
    _corridorId = value;
    notifyListeners();
  }

  String? _selectedTypePopUp = '';

  String get selectedTypePopUp => _selectedTypePopUp!;

  set selectedTypePopUp(String value) {
    if (value == _selectedTypePopUp) return;
    _selectedTypePopUp = value;
    notifyListeners();
  }

  String? _selectedCorridorId = '';
  String? _mobileNumber = '';
  String? _email = '';
  String? _selectedCountry = '';

  String get selectedCountry => _selectedCountry!;

  set selectedCountry(String value) {
    if (value == _selectedCountry) return;
    _selectedCountry = value;
    notifyListeners();
  }

  String? _selectedCurrencyPair = '';

  String get selectedCurrencyPair => _selectedCurrencyPair!;

  set selectedCurrencyPair(String value) {
    if (value == _selectedCountry) return;
    _selectedCurrencyPair = value;
    notifyListeners();
  }

  String get mobileNumber => _mobileNumber!;

  set mobileNumber(String value) {
    if (value == _mobileNumber) return;
    _mobileNumber = value;
    notifyListeners();
  }

  List<bool> _isChecked = [];
  List<AlertListResponse> _contentList = [];
  List<String> _currencyDataApi = [];

  Map<String, List<CorridorIdListResponse>> _corridorFields = {};

  Map<String, List<CorridorIdListResponse>> get corridorFields =>
      _corridorFields;

  set corridorFields(Map<String, List<CorridorIdListResponse>> value) {
    _corridorFields = value;
  }

  List<String> _corridorKeyData = [];

  List<String> get corridorKeyData => _corridorKeyData;

  set corridorKeyData(List<String> value) {
    _corridorKeyData = value;
    notifyListeners();
  }

  List<String> get currencyDataApi => _currencyDataApi;

  set currencyDataApi(List<String> value) {
    _currencyDataApi = value;
    notifyListeners();
  }

  String get selectedIndex => _selectedIndex ?? '';

  set selectedIndex(String value) {
    _selectedIndex = value;
    notifyListeners();
  }

  String get selectedCorridorId => _selectedCorridorId ?? '';

  set selectedCorridorId(String value) {
    _selectedCorridorId = value;
    notifyListeners();
  }

  List<AlertListResponse> get contentList => _contentList;

  set contentList(List<AlertListResponse>? value) {
    _contentList = value!;
    notifyListeners();
  }

  List<CorridorIdListResponse> _corridorList = [];

  List<CorridorIdListResponse> get corridorList => _corridorList;

  set corridorList(List<CorridorIdListResponse> value) {
    _corridorList = value;
    notifyListeners();
  }

  List<bool> get isChecked => _isChecked;

  RateAlertNotifier(context) {
    userCheck(context);
    rateAlertRepository = RateAlertRepository();
    ContactRepository().apiEditProfile(context).then((value) async {
      EditProfileResponse responseData = value as EditProfileResponse;
      email = responseData.emailId!;
      mobileNumber = responseData.mobile!;
    });
    SharedPreferencesMobileWeb.instance.getUserData(AppConstants.user).then((value) {
      LoginResponse loginResponse = loginResponseFromJson(value);
      email = loginResponse.userinfo!.emailId!;
      mobileNumber = loginResponse.userinfo!.phoneNumber!;
      SharedPreferencesMobileWeb.instance.getCountry(country).then((value) {
        selectedCountry = value;
        loadAPiCalls(context, selectedCountry == HongKongName ? "HKD" : "SGD");
      });
    });
  }

  loadAPiCalls(context, String currency) async {
    await alertList(context, currency);
    await getCorridorIdList(context, currency);
  }

  String? _alertMode = "Email";

  String? _alertModePopup = "Email";

  String get alertModePopup => _alertModePopup!;

  set alertModePopup(String value) {
    if (value == _alertModePopup) {
      return;
    }

    _alertModePopup = value;
    notifyListeners();
  }

  String get alertMode => _alertMode!;

  set alertMode(String value) {
    if (value == _alertMode) {
      return;
    }

    _alertMode = value;
    notifyListeners();
  }

  changeCheckedIndexValue(int index, bool value) {
    _isChecked[index] = value;
    notifyListeners();
  }

  String? _deleteId = "";

  String get deleteId => _deleteId!;

  set deleteId(String value) {
    if (value == _deleteId) {
      return;
    }

    _deleteId = value;
    notifyListeners();
  }

//alert me if sgd reaches
  bool _alertMe = false;

  bool get alertMe => _alertMe;

  set alertMe(bool value) {
    _alertMe = value;
    notifyListeners();
  } // Alert me when the rate is at its two-week high via ,

  bool _alertVia = false;

  //alert me if sgd reaches
  bool _alertMePopUp = false;

// Alert me when the rate is at its two-week high via ,
  bool _alertViaPopup = false;

//List of bool data

  //Enable Delete Button
  bool _enable = false;

  bool get alertVia => _alertVia;

  set alertVia(bool value) {
    _alertVia = value;
    notifyListeners();
  }

  bool get alertMePopUp => _alertMePopUp;

  set alertMePopUp(bool value) {
    _alertMePopUp = value;
    notifyListeners();
  }

  bool get alertViaPopup => _alertViaPopup;

  set alertViaPopup(bool value) {
    _alertViaPopup = value;
    notifyListeners();
  }

  bool get enable => _enable;

  set enable(bool value) {
    if (enable == value) {
      return;
    }
    _enable = value;
    notifyListeners();
  }

  alertList(BuildContext context, String currency) async {
    contentList = await rateAlertRepository?.alertList(context, currency);
    if (contentList.length > 0) {
      _isChecked = List.generate(contentList.length, (index) => false);
      notifyListeners();
    }
  }

  getCorridorIdList(context, String currency) async {
    corridorList =
        await rateAlertRepository?.getCorridorIDList(context, currency) ?? [];

    if (corridorList.isNotEmpty) {
      currencyDataApi.clear();
      corridorKeyData.clear();
      corridorList.forEach((element) {
        currencyDataApi.add(element.value ?? "");
        corridorKeyData.add(element.key ?? "");
      });
    }
    notifyListeners();
  }

  getSelectedCorridorId() {
    corridorList.forEach((element) {
      if (selectedIndex == element.value) {
        selectedCorridorId = element.key ?? "";
      }
    });
  }

  String get email => _email!;

  set email(String value) {
    if (value == _email) return;
    _email = value;
    notifyListeners();
  }
}
