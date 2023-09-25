import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:singx/core/base/base_change_notifier.dart';
import 'package:singx/core/data/remote/service/sg_wallet_repository.dart';
import 'package:singx/core/models/request_response/sg_wallet/sg_wallet_transaction_history.dart';
import 'package:singx/core/models/request_response/sg_wallet/sg_wallet_transaction_history_request.dart';
import 'package:singx/screens/activities/activities_tab/wallet.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';
import '../../utils/common/dummy_data.dart';

class ActivitiesWalletNotifier extends BaseChangeNotifier {

  //To Load Initial Data From API and Local Storage
  ActivitiesWalletNotifier(BuildContext context) {
    if (context != null) {
      userCheck(context);
      SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        countryData = value;
        GetFilterData();
        _selectedFromDate = DateTime(DateTime.now().year,
                DateTime.now().month - 2, DateTime.now().day)
            .millisecondsSinceEpoch;
        _selectedToDate = DateTime.now().millisecondsSinceEpoch;
        DateController.text =
            '${DateFormat('MM/dd/yyyy').format(DateTime(DateTime.now().year, DateTime.now().month - 2, DateTime.now().day)).toString()} - ${DateFormat('MM/dd/yyyy').format(DateTime.now()).toString()}';
        loadInitialData();
      });
    }
  }

  //Selected Data
  String? _selectedCountry;
  String? _selectedProvider;
  String _selectedStatus = '';
  int? _selectedFromDate;
  int _pageCount = 1;
  int _pageIndex = 1;
  int? _selectedToDate;
  String countryData = '';

  //Data and Scroll Controllers
  ScrollController scrollController = ScrollController();
  ScrollController DataTableVerticalScrollController = ScrollController();
  ScrollController DataTableHorizontalScrollController = ScrollController();
  ScrollController paginationScrollController = ScrollController();
  ScrollController horizontalScrollController = ScrollController();
  TextEditingController SearchController = TextEditingController();
  TextEditingController DateController = TextEditingController();
  TextEditingController statusController = TextEditingController();


  // Getter and Setter
  int get pageIndex => _pageIndex;

  set pageIndex(int value) {
    if(value == _pageIndex)return ;
    _pageIndex = value;
    notifyListeners();
  }


  int get pageCount => _pageCount;

  set pageCount(int value) {
    if(value == _pageCount) return;
    _pageCount = value;
  } //List Data
  List<String> _statusData = [];

  List<String> get statusData => _statusData;

  set statusData(List<String> value) {
    if (statusData == value) {
      return;
    }
    _statusData = value;
    notifyListeners();
  }

  int get selectedFromDate => _selectedFromDate!;

  set selectedFromDate(int value) {
    if (value == _selectedFromDate) return;
    _selectedFromDate = value;
    notifyListeners();
  } //Data Controller



  //JsonData
  // TransactionDataSourceWallet? transactionDataSource;

  String get selectedCountry => _selectedCountry!;

  set selectedCountry(String value) {
    if (value == _selectedCountry) {
      return;
    }
    _selectedCountry = value;
    notifyListeners();
  }

  DateTime? _selectedWalletStartDate;

  DateTime? get selectedWalletStartDate => _selectedWalletStartDate;

  set selectedWalletStartDate(DateTime? value) {
    if (_selectedWalletStartDate == value) return;
    _selectedWalletStartDate = value;
    notifyListeners();
  }

  DateTime? _selectedWalletEndDate;

  DateTime? get selectedWalletEndDate => _selectedWalletEndDate;

  set selectedWalletEndDate(DateTime? value) {
    if (_selectedWalletEndDate == value) return;
    _selectedWalletEndDate = value;
    notifyListeners();
  }

  String get selectedStatus => _selectedStatus;

  set selectedStatus(String value) {
    if (value == _selectedStatus) {
      return;
    }
    _selectedStatus = value;
    notifyListeners();
  }

  String get selectedProvider => _selectedProvider!;

  set selectedProvider(String value) {
    if (value == _selectedProvider) {
      return;
    }
    _selectedProvider = value;
    notifyListeners();
  }

  int get selectedToDate => _selectedToDate!;

  set selectedToDate(int value) {
    if (value == _selectedToDate) return;
    _selectedToDate = value;
    notifyListeners();
  }

  //list of Data Table
  List<SgWalletTransactionHistory> _walletOrders = [];

//list of Data Table with sorted
  List<SgWalletTransactionHistory> _walletTransactions = [];
  List<SgWalletTransactionHistory> _walletTransactionsDataPaginated = [];

  List<SgWalletTransactionHistory> get walletTransactionsDataPaginated =>
      _walletTransactionsDataPaginated;

  set walletTransactionsDataPaginated(List<SgWalletTransactionHistory> value) {
    if(_walletTransactionsDataPaginated == value)return;
    _walletTransactionsDataPaginated = value;
    notifyListeners();
  }

  List<SgWalletTransactionHistory> get walletTransactions =>
      _walletTransactions;

  set walletTransactions(value) {
    _walletTransactions = value;
    notifyListeners();
  }

  List<SgWalletTransactionHistory> get walletOrders => _walletOrders;

  set walletOrders(value) {
    _walletOrders = value;
    notifyListeners();
  }

  //To Load Initial Data By Checking the country Flow
  loadInitialData() async {
    await SharedPreferencesMobileWeb.instance
        .getCountry(country)
        .then((value) async {
      if (value == AppConstants.singapore) {
        await SGWalletTransactionList();
      }
    });
  }

  //Get Transaction Data From API
  SGWalletTransactionList() async {
    // apiLoader(context);
    await SGWalletRepository()
        .SGWalletHistory(ActivitiesWalletRequest(
        fromDate: DateTime(
            DateTime.now().year, DateTime.now().month - 2, DateTime.now().day)
            .millisecondsSinceEpoch,
        toDate: DateTime.now().millisecondsSinceEpoch,
        transactionId: SearchController.text.isNotEmpty ? SearchController.text : '',
        status: selectedStatus.isNotEmpty ? selectedStatus : ""))
        .then((value) {
      if (value != null) {
        List<SgWalletTransactionHistory> sgWalletTransactionHistory =
        value as List<SgWalletTransactionHistory>;

        walletTransactions = (sgWalletTransactionHistory);
        pageCount = (walletTransactions.length / 10).ceil();
        int start = (pageIndex! -1) * 10;
        int end = start + 10;
        if (end > walletTransactions.length) {
          end = walletTransactions.length;
        }
        walletTransactionsDataPaginated =  walletTransactions.sublist(start, end);
        walletOrders = (sgWalletTransactionHistory);
      }
    });
  }

  //Get Status Filter List
  GetFilterData() async {
    await SGWalletRepository().SGWalletFilterList().then((value) {
      String data = jsonEncode(value.statuses);
      Map valueMap = json.decode(data);
      statusData.add("All");
      valueMap.forEach((key, value) {
        statusData.add(value);
      });
    });
  }
}
