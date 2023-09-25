import 'package:flutter/material.dart';
import 'package:singx/core/base/base_change_notifier.dart';
import 'package:singx/utils/common/app_widgets.dart';

class WalletTopUpNotifier extends BaseChangeNotifier {


  WalletTopUpNotifier(BuildContext context) {
    userCheck(context);
  }

  //integer value
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    if (value == _selectedIndex) {
      return;
    }
    _selectedIndex = value;
    notifyListeners();
  }
}
