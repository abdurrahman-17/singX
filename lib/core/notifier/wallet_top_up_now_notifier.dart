import 'package:flutter/material.dart';
import 'package:singx/core/base/base_change_notifier.dart';
import 'package:singx/core/data/remote/service/fund_transfer_repository.dart';
import 'package:singx/core/models/request_response/fund_transfer/get_sender_account_details_response.dart';
import 'package:singx/utils/common/app_constants.dart';

class WalletTopUpNowNotifier extends BaseChangeNotifier {

  // Scroll controller
  final ScrollController scrollController = ScrollController();

  // Data controller
  final amountController = TextEditingController();

  // Keys
  GlobalKey toolTipKey = GlobalKey();

  // String value
  String _selectedSender = '1';
  String _selectedSenderID = '';
  String _referenceNumber = '';
  String _payNowQR = '';
  String _bankName = '';
  String _acName = '';
  String _acNumber = '';
  String _walletTopUpErrorMessage = '';

  // List values
  List<GetSenderAccountDetails> _itemCountData = [];

  // Integer values
  int _gridAccountSelected = -1;

  //boolean value
  bool _isAccountSelected = false;
  bool _amountIsEmpty = false;
  bool _copied = false;

  WalletTopUpNowNotifier() {
    getSenderBankAccountsSG();
  }

  getSenderBankAccountsSG() async {
    await FundTransferRepository()
        .apiSenderAccountDetails(AppConstants.SGDCurrencyId)
        .then((value) {
      List<GetSenderAccountDetails> response =
          value as List<GetSenderAccountDetails>;
      itemCountData = response;
    });
  }

  // Getter and setter
  bool get amountIsEmpty => _amountIsEmpty;

  set amountIsEmpty(bool value) {
    if (value == _amountIsEmpty) return;
    _amountIsEmpty = value;
    notifyListeners();
  } //string value

  bool get copied => _copied;

  set copied(bool value) {
    if (value == _copied) return;
    _copied = value;
    notifyListeners();
  }

  String get bankName => _bankName;

  set bankName(String value) {
    if (value == _bankName) return;
    _bankName = value;
    notifyListeners();
  }

  String get referenceNumber => _referenceNumber;

  set referenceNumber(String value) {
    if (value == _referenceNumber) return;
    _referenceNumber = value;
    notifyListeners();
  }

  String get selectedSenderID => _selectedSenderID;

  set selectedSenderID(String value) {
    if (value == _selectedSenderID) return;
    _selectedSenderID = value;
    notifyListeners();
  }

  String get walletTopUpErrorMessage => _walletTopUpErrorMessage;

  set walletTopUpErrorMessage(String value) {
    if (value == _walletTopUpErrorMessage) return;
    _walletTopUpErrorMessage = value;
    notifyListeners();
  }

  bool get isAccountSelected => _isAccountSelected;

  set isAccountSelected(bool value) {
    if (value == _isAccountSelected) {
      return;
    }
    _isAccountSelected = value;
    notifyListeners();
  }

  String get selectedSender => _selectedSender;

  set selectedSender(String value) {
    if (value == _selectedSender) {
      return;
    }
    _selectedSender = value;
    notifyListeners();
  }

  List<GetSenderAccountDetails> get itemCountData => _itemCountData;

  set itemCountData(List<GetSenderAccountDetails> value) {
    if (value == _itemCountData) {
      return;
    }
    _itemCountData = value;
    notifyListeners();
  }

  int get gridAccountSelected => _gridAccountSelected;

  set gridAccountSelected(int value) {
    if (value == _gridAccountSelected) {
      return;
    }
    _gridAccountSelected = value;
    notifyListeners();
  }

  String get payNowQR => _payNowQR;

  set payNowQR(String value) {
    if (value == _payNowQR) return;
    _payNowQR = value;
    notifyListeners();
  }

  String get acName => _acName;

  set acName(String value) {
    if (value == _acName) return;
    _acName = value;
    notifyListeners();
  }

  String get acNumber => _acNumber;

  set acNumber(String value) {
    if (value == _acNumber) return;
    _acNumber = value;
    notifyListeners();
  }
}
