import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:singx/core/base/base_change_notifier.dart';
import 'package:singx/core/data/remote/service/fx_repository.dart';
import 'package:singx/core/data/remote/service/transaction_repository.dart';
import 'package:singx/core/models/request_response/dashboard_transaction_list/dashboard_transaction_aus_request.dart';
import 'package:singx/core/models/request_response/dashboard_transaction_list/dashboard_transaction_aus_response.dart';
import 'package:singx/core/models/request_response/transaction/transaction_status_filter.dart';
import 'package:singx/screens/activities/activities_tab/remittance.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';
import '../models/request_response/transaction/transacton_response.dart';

class ActivitiesRemittenceNotifier extends BaseChangeNotifier {

  //To Load Initial Data From API and Local Storage
  ActivitiesRemittenceNotifier(context, String from) {
    userCheck(context);
    if (from == "remittance") {
      SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        country_data = value;
        if (value == AppConstants.australia) {
          final rangeStartDate =
              DateFormat('yyy/MM/dd').format(startDate).toString();
          final rangeEndDate =
              DateFormat('yyy/MM/dd').format(endDate).toString();
          DateController.text = '$rangeStartDate - $rangeEndDate';
          startDateAPI = DateFormat('yyy-MM-dd').format(startDate).toString();
          endDateAPI = DateFormat('yyy-MM-dd').format(endDate).toString();
          await TransactionRepository()
              .apiTransactionStatusList(context)
              .then((value) {
            selectedStatusDataAus = value;
          });
        } else {
          final rangeStartDate =
          DateFormat('yyy/MM/dd').format(startDate).toString();
          final rangeEndDate =
          DateFormat('yyy/MM/dd').format(endDate).toString();
          DateController.text = '$rangeStartDate - $rangeEndDate';
          startDateAPI = DateFormat('yyy-MM-dd HH:mm:ss').format(startDate).toString();
          endDateAPI = DateFormat('yyy-MM-dd HH:mm:ss').format(endDate).toString();
          await TransactionRepository().apiSGFilterList(context).then((value) {
            SgTransactionStatusFilterApi sgTransactionStatusFilterApi =
                sgTransactionStatusFilterApiFromJson(jsonEncode(value));
            selectedStatusData.addAll(sgTransactionStatusFilterApi.statuses!);
            selectedReceiverCountry.addAll(sgTransactionStatusFilterApi.countries!);
            for (int i = 0; i < sgTransactionStatusFilterApi.statuses!.length; i++) {
              (sgTransactionStatusFilterApi.statuses![i].value);
            }
          });
        }
      });
      startDate = DateTime(
          DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
      endDate = DateTime.now();
      loadInitialRemmitanceData(context);
    }
  }

  //Pagination Data
  int? _pageNo;
  int? _pageCount = 1;
  int? _pageIndex = 1;

  //Selected Data
  int _stageID = 0;
  String? selectedCountry;
  String? selectedProvider;
  String _selectedCountryFilter='';
  String selectedStatus = "";
  String countryData = '';
  DateTime? _endDate;
  String _startDateAPI = "";
  String _endDateAPI = "";
  String _url = '?page=0&size=10&filter=';

  //List Of Data
  List<DashboardTransactionAustraliaResponse> _transactions = [];
  List<DashboardTransactionAustraliaResponse> _transactionsDataPaginated = [];
  List<DashboardTransactionAustraliaResponse> _orders = [];
  List<Content> _orderSg = [];
  List<Datas> _selectedStatusData = [];
  List<Content> _transactionSg = [];
  List<Datas> _selectedReceiverCountry = [];
  List _selectedStatusDataAus = [];

  //Data Controllers
  TextEditingController SearchController = TextEditingController();
  TextEditingController DateController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController receiverCountryController = TextEditingController();

  //Scroll Controllers
  ScrollController verticalScrollController = ScrollController();
  ScrollController horizontalScrollController = ScrollController();
  ScrollController paginationScrollController = ScrollController();

  // Getter and Setter
  int? get pageIndex => _pageIndex;

  set pageIndex(int? value) {
    if (value == _pageIndex) return;
    _pageIndex = value;
    notifyListeners();
  }

  int get stageID => _stageID;

  set stageID(int value) {
    if (value == _stageID) return;
    _stageID = value;
    notifyListeners();
  }

  List<Content> get orderSg => _orderSg;

  set orderSg(value) {
    _orderSg = value;
    notifyListeners();
  }

  List<Content> get transactionSg => _transactionSg;

  set transactionSg(value) {
    if(value == _transactionSg)return;
    _transactionSg = value;
    notifyListeners();
  }

  List<DashboardTransactionAustraliaResponse> get orders => _orders;

  set orders(value) {
    _orders = value;
    notifyListeners();
  }

  List<DashboardTransactionAustraliaResponse> get transactionsDataPaginated =>
      _transactionsDataPaginated;

  set transactionsDataPaginated(
      List<DashboardTransactionAustraliaResponse> value) {
    if(_transactionsDataPaginated == value)return;
    _transactionsDataPaginated = value;
    notifyListeners();
  }

  List<DashboardTransactionAustraliaResponse> get transactions => _transactions;

  set transactions(value) {
    _transactions = value;
    notifyListeners();
  }

  List<Datas> get selectedStatusData => _selectedStatusData;

  set selectedStatusData(List<Datas> value) {
    if (value == _selectedStatusData) return;
    _selectedStatusData = value;
    notifyListeners();
  }

  List<Datas> get selectedReceiverCountry => _selectedReceiverCountry;

  set selectedReceiverCountry(List<Datas> value) {
    if (value == _selectedReceiverCountry) return;
    _selectedReceiverCountry = value;
    notifyListeners();
  }

  List get selectedStatusDataAus => _selectedStatusDataAus;

  set selectedStatusDataAus(List value) {
    if (value == _selectedStatusDataAus) return;
    _selectedStatusDataAus = value;
    notifyListeners();
  }

  int get pageCount => _pageCount!;

  set pageCount(int value) {
    if (_pageCount == value) return;
    _pageCount = value;
    notifyListeners();
  }

  int get pageNo => _pageNo!;

  set pageNo(int value) {
    if (_pageNo == value) return;
    _pageNo = value;
    notifyListeners();
  }


  String get selectedCountryFilter => _selectedCountryFilter;

  set selectedCountryFilter(String value) {
    if(value == _selectedCountryFilter)return;
    _selectedCountryFilter = value;
    notifyListeners();
  }

  String get url => _url;

  set url(String value) {
    if (value == _url) return;
    _url = value;
    notifyListeners();
  }

  DateTime? _startDate;

  DateTime get startDate => _startDate!;

  set startDate(DateTime value) {
    if (value == _startDate) return;
    _startDate = value;
    notifyListeners();
  }
  //JsonData
  // TransactionDataSource? transactionDataSource;

  set selected_country(String value) {
    if (value == selectedCountry) {
      return;
    }
    selectedCountry = value;
    notifyListeners();
  }

  set selected_provider(String value) {
    if (value == selectedProvider) {
      return;
    }
    selectedProvider = value;
    notifyListeners();
  }

  set selected_status(String value) {
    if (value == selectedStatus) {
      return;
    }
    selectedStatus = value;
    notifyListeners();
  }

  set country_data(String value) {
    if (value == countryData) {
      return;
    }
    countryData = value;
    notifyListeners();
  }

  DateTime get endDate => _endDate!;

  set endDate(DateTime value) {
    if (value == _endDate) return;
    _endDate = value;
    notifyListeners();
  }

  String get startDateAPI => _startDateAPI;

  set startDateAPI(String value) {
    if (value == _startDateAPI) return;
    _startDateAPI = value;
    notifyListeners();
  }

  String get endDateAPI => _endDateAPI;

  set endDateAPI(String value) {
    if (value == _endDateAPI) return;
    _endDateAPI = value;
    notifyListeners();
  }

  DateTime? _selectedStartDate;

  DateTime? get selectedStartDate => _selectedStartDate;

  set selectedStartDate(DateTime? value) {
    if (_selectedStartDate == value) return;
    _selectedStartDate = value;
    notifyListeners();
  }

  DateTime? _selectedEndDate;

  DateTime? get selectedEndDate => _selectedEndDate;

  set selectedEndDate(DateTime? value) {
    if (_selectedEndDate == value) return;
    _selectedEndDate = value;
    notifyListeners();
  }

  //To Load Initial Data Content and Filter Options By Checking the country Flow
  loadInitialRemmitanceData(context) async {
    await SharedPreferencesMobileWeb.instance
        .getCountry(country)
        .then((value) async {
      countrySelectedData = value;

      if (value == AustraliaName) {
        AustraliaTransactionList(context);
      } else if (value == HongKongName) {
        await SingaporeTransactionList();
      } else if (value == AppConstants.singapore) {
        await SingaporeTransactionList();
      }
    });
  }

  //To Load Initial Data Content and Filter Options from backend
  SingaporeTransactionList() async {
    await TransactionRepository()
        .apiActivitiesTransaction(
      url,
      startDateAPI.isEmpty ? null : startDateAPI,
      endDateAPI.isEmpty ? null : endDateAPI,
      selectedStatus.isEmpty ? null : selectedStatus,
      SearchController.text.isEmpty ? null : SearchController.text,
      selectedCountryFilter.isEmpty? null : selectedCountryFilter
    )
        .then((value) {
      TransactionResponse transactionResponse =
          TransactionResponse.fromJson(value);
      List<Content> emptyData = [];

      pageIndex = 1;
      if(paginationScrollController.hasClients)paginationScrollController.position.animateTo(paginationScrollController.position.minScrollExtent, duration: Duration(seconds: 1), curve: Curves.easeOut);
      pageCount = transactionResponse.totalPages ?? 0;
      transactionSg = transactionResponse.content ?? emptyData;
      orderSg = transactionResponse.content ?? emptyData;
    });
  }

  //To Load Initial Data Content and Filter Options from backend
  AustraliaTransactionList(context) async {
    final startDate = DateTime(
        DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
    final endDate = DateTime.now();
    final startDateAPI = DateFormat('yyy-MM-dd').format(startDate).toString();
    final endDateAPI = DateFormat('yyy-MM-dd').format(endDate).toString();
    await SharedPreferencesMobileWeb.instance
        .getContactId(apiContactId)
        .then((value) async {
      await FxRepository()
          .apiDashboardTransactionAus(
              DashboardTransactionAustraliaRequest(
                contactId: value,
                allstatus: stageID != 0 ? false : true,
                frmdt: selectedStartDate !=null ?DateFormat('yyy-MM-dd').format(selectedStartDate!).toString() : startDateAPI,
                todt:selectedEndDate !=null?DateFormat('yyy-MM-dd').format(selectedEndDate!).toString() :  endDateAPI,
                stageId: stageID ,
              ),
              context)
          .then((value) {
        List<DashboardTransactionAustraliaResponse>
            dashboardTransactionAusResponse =
            value as List<DashboardTransactionAustraliaResponse>;

        transactions.clear();
        transactionsDataPaginated.clear();
        orders.clear();
        transactions = dashboardTransactionAusResponse;
        pageIndex = 1;
        if(paginationScrollController.hasClients) paginationScrollController.position.animateTo(paginationScrollController.position.minScrollExtent, duration: Duration(seconds: 1), curve: Curves.easeOut);
          pageCount = (transactions.length / 10).ceil();
          int start = (pageIndex! -1) * 10;
          int end = start + 10;
          if (end > transactions.length) {
            end = transactions.length;
          }
          transactionsDataPaginated =  transactions.sublist(start, end);
          orders = dashboardTransactionAusResponse;
        }
      );
    });
  }

}
