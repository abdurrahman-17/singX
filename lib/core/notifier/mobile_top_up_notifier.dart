import 'package:flutter/material.dart';
import 'package:singx/core/base/base_change_notifier.dart';
import 'package:singx/core/data/remote/service/sg_bill_pay_repository.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/country_list.dart';
import 'package:singx/screens/mobile_top_up/mobile_top_up.dart';

class MobileTopUpNotifier extends BaseChangeNotifier {
  MobileTopUpNotifier() {
    SGBillPayRepository().SGBillPayCountries().then((value) {
      List<CountryList> countryList = value as List<CountryList>;
      for (int i = 0; i < countryList.length; i++) {
        countryListData.add(countryList[i].countryName!);
      }
    });
  }
  ScrollController scrollController = ScrollController();
  //Selected Data
  String? _selectedCountry = 'Singapore';
  String? _selectedProvider;
  String? _selectedStatus;
  String _finalInrPrice = '';
  String _finalSgdPrice = '';

  //Data Controller
  TextEditingController SearchController = TextEditingController();
  TextEditingController DateController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  List<String> _countryListData = [];

  List<String> get countryListData => _countryListData;

  set countryListData(List<String> value) {
    if (value == _countryListData) return;
    _countryListData = value;
    notifyListeners();
  }

  // List<MobileTransaction> _employees = <MobileTransaction>[];
  // MobileTransactionSource? _mobileTransactionSource;
  // List<MobileTopUpTitle> _values = [
  //   MobileTopUpTitle("Airtime", true),
  //   MobileTopUpTitle("Data", false),
  //   MobileTopUpTitle("Bundles", false),
  // ];

  //boolean values
  bool _isPlanSelected = false;
  bool _isProceed = false;
  bool _isPaymentSuccess = true;
  bool _showLoadingIndicator = false;

  String get selectedCountry => _selectedCountry!;

  set selectedCountry(String value) {
    if (selectedCountry == value) {
      return;
    }
    _selectedCountry = value;
    notifyListeners();
  } // integer values

  int _gridAccountSelected = 0;
  int _itemCountData = 100;

  // double values
  double _pageCount = 0;

  String get selectedProvider => _selectedProvider!;

  set selectedProvider(String value) {
    if (selectedProvider == value) {
      return;
    }
    _selectedProvider = value;
    notifyListeners();
  }

  String get selectedStatus => _selectedStatus!;

  set selectedStatus(String value) {
    if (selectedStatus == value) {
      return;
    }
    _selectedStatus = value;
    notifyListeners();
  }

  String get finalInrPrice => _finalInrPrice;

  set finalInrPrice(String value) {
    if (finalInrPrice == value) {
      return;
    }
    _finalInrPrice = value;
    notifyListeners();
  }

  String get finalSgdPrice => _finalSgdPrice;

  set finalSgdPrice(String value) {
    if (finalSgdPrice == value) {
      return;
    }
    _finalSgdPrice = value;
    notifyListeners();
  }

  // List<MobileTransaction> get employees => _employees;
  //
  // set employees(List<MobileTransaction> value) {
  //   if (employees == value) {
  //     return;
  //   }
  //   _employees = value;
  //   notifyListeners();
  // }
  //
  // MobileTransactionSource get mobileTransactionSource =>
  //     _mobileTransactionSource!;
  //
  // set mobileTransactionSource(MobileTransactionSource value) {
  //   _mobileTransactionSource = value;
  //   notifyListeners();
  // }
  //
  // List<MobileTopUpTitle> get values => _values;
  //
  // set values(List<MobileTopUpTitle> value) {
  //   if (values == value) {
  //     return;
  //   }
  //   _values = value;
  //   notifyListeners();
  // }

  bool get isPlanSelected => _isPlanSelected;

  set isPlanSelected(bool value) {
    if (isPlanSelected == value) {
      return;
    }
    _isPlanSelected = value;
    notifyListeners();
  }

  bool get isProceed => _isProceed;

  set isProceed(bool value) {
    if (isProceed == value) {
      return;
    }
    _isProceed = value;
    notifyListeners();
  }

  bool get isPaymentSuccess => _isPaymentSuccess;

  set isPaymentSuccess(bool value) {
    if (isPaymentSuccess == value) {
      return;
    }
    _isPaymentSuccess = value;
    notifyListeners();
  }

  bool get showLoadingIndicator => _showLoadingIndicator;

  set showLoadingIndicator(bool value) {
    if (showLoadingIndicator == value) {
      return;
    }
    _showLoadingIndicator = value;
    notifyListeners();
  }

  int get gridAccountSelected => _gridAccountSelected;

  set gridAccountSelected(int value) {
    if (gridAccountSelected == value) {
      return;
    }
    _gridAccountSelected = value;
    notifyListeners();
  }

  int get itemCountData => _itemCountData;

  set itemCountData(int value) {
    if (itemCountData == value) {
      return;
    }
    _itemCountData = value;
    notifyListeners();
  }

  double get pageCount => _pageCount;

  set pageCount(double value) {
    if (pageCount == value) {
      return;
    }
    _pageCount = value;
    notifyListeners();
  }
}

class PagingProduct {
  PagingProduct({
    this.inrPrice,
    this.sgdPrice,
  });

  final String? inrPrice;
  final String? sgdPrice;
}

class PagingProductRepository {
  List inrPrice = [
    '1',
    '20',
    '61',
    '75',
    '24',
    '12',
    '15',
    '40',
    '99',
    '29',
    '39',
    '21',
    '10',
    '62',
    '98',
    '34',
    '99',
    '12',
    '56',
    '40',
    '20',
    '24',
    '89',
    '56',
    '32',
    '23',
    '15',
    '27',
    '99',
    '11'
  ];
  List sgdPrice = [
    '0.3',
    '0.6',
    '1.6',
    '2.5',
    '1.6',
    '2.5',
    '1.5',
    '3.0',
    '2.0',
    '2.2',
    '1.9',
    '1.5',
    '1.7',
    '2.7',
    '1.9',
    '1.5',
    '1.0',
    '2.5',
    '0.3',
    '0.6',
    '1.6',
    '2.5',
    '1.6',
    '2.5',
    '0.3',
    '0.6',
    '1.6',
    '2.5',
    '1.6',
    '2.5'
  ];
}

final PagingProductRepository pagingProductRepository =
    PagingProductRepository();

List<PagingProduct> populateData() {
  final List<PagingProduct> pagingProducts = [];
  var index = 0;
  for (int i = 0; i < pagingProductRepository.inrPrice.length; i++) {
    if (index == 21) index = 0;
    var p = new PagingProduct(
        inrPrice: pagingProductRepository.inrPrice[i],
        sgdPrice: pagingProductRepository.sgdPrice[i]);
    index++;
    pagingProducts.add(p);
  }

  return pagingProducts;
}
