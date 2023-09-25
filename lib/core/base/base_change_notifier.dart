import 'package:flutter/foundation.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'loading_state.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

abstract class BaseChangeNotifier with ChangeNotifier {
  String _countryBName = "";
  LoadingState _loadingState = LoadingState.Idle;
  ValueNotifier<String> showToast = ValueNotifier<String>('');

  String get countryBName => _countryBName;

  set countryBName(String value) {
    if (value == _countryBName || value.length < 2) {
      return;
    }
    _countryBName = value;
    notifyListeners();
  }
  loadData()async
  {
    await SharedPreferencesMobileWeb.instance.getCountry(country).then((value) async {

      countryBName = value??"";
    });
  }

  int _selectedReceiverCountryID=10000224;
  int get selectedReceiverCountryID => _selectedReceiverCountryID;

  set selectedReceiverCountryID(int value) {

    _selectedReceiverCountryID = value;

    notifyListeners();
  }

  bool _isLoading = false;


  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _disposed = false;

  LoadingState get loadingState => this._loadingState;

  void setLoadingState(LoadingState loadingState) {
    _loadingState = loadingState;
    this.notify();
  }
  void notify() {
    notifyListeners();
  }

  void showToastMessage(String _stMessage) {
    showToast.value = '';
    showToast.value = _stMessage;
  }

  @override
  void notifyListeners() {
    //to avoid calling listeners after notifier is disposed
    if (!_disposed) {
      super.notifyListeners();
    }
  }



  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

   void LogPrint(Object object) async {
    int defaultPrintLength = 1020;
    if (object == null || object.toString().length <= defaultPrintLength) {
    } else {
      String log = object.toString();
      int start = 0;
      int endIndex = defaultPrintLength;
      int logLength = log.length;
      int tmpLogLength = log.length;
      while (endIndex < logLength) {
        endIndex += defaultPrintLength;
        start += defaultPrintLength;
        tmpLogLength -= defaultPrintLength;
      }
      if (tmpLogLength > 0) {
      }
    }
  }
}
