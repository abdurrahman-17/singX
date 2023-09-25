import 'package:flutter/material.dart';
import 'package:singx/core/base/base_change_notifier.dart';
import 'package:singx/utils/common/app_widgets.dart';

class ActivitiesNotifier extends BaseChangeNotifier {
  ActivitiesNotifier(BuildContext context) {
    userCheck(context);
  }

  //Scroll Controller
  ScrollController scrollController = ScrollController();

  //Selected page
  int _selectedIndex = 0;
  //Selected Country
  String? _countryData;

  // Getter and Setter
  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    if (value == _selectedIndex) {
      return;
    }
    _selectedIndex = value;
    notifyListeners();
  }


  String? get countryData => _countryData;

  set countryData(String? value) {
    if (value == _countryData) {
      return;
    }
    _countryData = value;
    notifyListeners();
  }
}
