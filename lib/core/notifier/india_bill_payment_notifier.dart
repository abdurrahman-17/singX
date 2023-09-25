import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:singx/core/base/base_change_notifier.dart';
import 'package:singx/core/data/remote/service/sg_bill_pay_repository.dart';
import 'package:singx/core/data/remote/service/sg_wallet_repository.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/categoryList.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/pricing_response.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/sg_bill_operator_list_response.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/transaction_history_response.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/view_bill_response.dart';
import 'package:singx/core/models/request_response/sg_wallet/sg_wallet_response.dart';
import 'package:singx/screens/india_bill_payment/india_bill_payment.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class IndiaBillPaymentNotifier extends BaseChangeNotifier {

  //List Data
  List<Content> _billPaymentArr = [];
  List<BillCategoryTitle> _billCategoryTitleArr = <BillCategoryTitle>[];
  List<BillCategoryItems> _billCategoryItemsArr = <BillCategoryItems>[];
  List<String> _statusData = [];
  List<String> _billingCategoryData = [];
  List<CategoryList> _billingCategoryList = [];
  List<OperatorList> _billingOperatorList = [];
  List<String> _billingOperatorData = [];

  // Scroll Controller
  final ScrollController scrollController = ScrollController();
  final ScrollController scrollController1 = ScrollController();
  final ScrollController scrollController2 = ScrollController();
  final ScrollController verticalScrollController = ScrollController();
  final ScrollController horizontalScrollController = ScrollController();
  final ScrollController utilsController = ScrollController();
  final ScrollController listScrollController = ScrollController();

  // TextField Controller
  final dateRangeController = TextEditingController();
  final searchController = TextEditingController();
  final consumerController = TextEditingController();
  final adField1Controller = TextEditingController();
  final adField2Controller = TextEditingController();
  final adField3Controller = TextEditingController();
  final statusController = TextEditingController();
  final billingCategoryController = TextEditingController();
  final billingOperatorController = TextEditingController();

  // Key for validating Form
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();


  //Table Data
  // late BillPaymentDataSource _billPaymentDataSource;

  //String Values
  String _billPaymentStatus = '';
  String _selectedCategory = '';
  String _walletBal = '';
  String _startDateAPI = "";
  String _endDateAPI = "";
  String _selectedStatus = "";
  String _selectedOperator = '';
  String _consumerTitle = '';
  String _regexData = '';
  String _additionalField1 = '';
  String _additionalField2 = '';
  String _additionalField3 = '';
  String _viewBillRequired = '';
  String _errorData = '';
  String _walletBalanceErrorMsg = '';
  String _referenceNumber = '';

  //Integer Values
  int _selectedOperatorID = 0;
  int _operatorID = 0;
  int _visibleDataCount = 10;

  // boolean Values
  bool _showLoadingIndicator = false;
  bool _showLoadingIndicatorForList = false;
  bool? _isIndiaBillPayment = true;
  bool _isIndiaBillPaymentSuccess = false;
  bool _isBillPaymentPreview = false;
  bool _referenceCopied = false;
  bool _operatorFieldVisible = true;
  bool _fieldVisible = false;

  // DateTime Values
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  // Response Values
  ViewBillResponse? _viewBillData;
  PricingResponse? _pricingData;

  // Constructor
  IndiaBillPaymentNotifier(BuildContext context, bool val) {
    showLoadingIndicator = true;
    userCheck(context);
    selectedCategoryDatas(context);
    initialData();
  }

  // Initial Datas
  selectedCategoryDatas(BuildContext context) async {
    await SharedPreferencesMobileWeb.instance
        .getSelectedCategory(selectedCategoryDummy)
        .then((value) {
      if (value.isNotEmpty) {
        selectedCategory = value;
      }
    });
    await SGWalletRepository().SGWalletBalance(context).then((value) {
      if (value != null) {
        SgWalletBalance sgWalletBalance = value as SgWalletBalance;
        walletBal = sgWalletBalance.balance!;
      }
    });
    await SGBillPayRepository().SGBillPayFilterList().then((value) {
      String data = jsonEncode(value.statuses);
      Map valueMap = json.decode(data);

      valueMap.forEach((key, value) {
        statusData.add(value);
      });
    });
    await SGBillPayRepository().SGBillCategoryList().then((value) async {
      List<CategoryList> categoryList = value as List<CategoryList>;
      billingCategoryList = categoryList;
      billingOperatorData.clear();
      for (int i = 0; i < categoryList.length; i++) {
        billingCategoryData.add(categoryList[i].productName!);
        if (selectedCategory == categoryList[i].productName) {
          await SGBillPayRepository().SGBillOperatorList().then((value) {
            billingOperatorList = value as List<OperatorList>;
            for (int j = 0; j < billingOperatorList.length; j++) {
              if (categoryList[i].productId.toString() ==
                  billingOperatorList[j].category) {
                billingOperatorData.add(billingOperatorList[j].operatorName!);
              }
            }
          });
        }
      }
    });
  }

  // Initial Data
  initialData() {
    showLoadingIndicatorForList = true;
    SGBillPayRepository()
        .SGBillTransactionHistory(startDateAPI.isNotEmpty ? startDateAPI : null,
        endDateAPI.isNotEmpty ? endDateAPI : null,
        selectedStatus.isNotEmpty ? selectedStatus: null,
        searchController.text.isNotEmpty ? searchController.text : null)
        .then((value) {
      TransactionHistoryResponse res = value as TransactionHistoryResponse;
      billPaymentArr.addAll(res.content!);
      billCategoryTitleArr = getBillCategoryTitles();
      billCategoryItemsArr = getUtilitiesItems();
      // billPaymentDataSource =
      //     BillPaymentDataSource(billPaymentData: billPaymentArr);
      showLoadingIndicator = false;
      showLoadingIndicatorForList = false;
    });
    listScrollController.addListener(_scrollListener);
  }

  // Updating the state
  notifyListenerUpdate() {
    notifyListeners();
  }

  List<BillCategoryTitle> getBillCategoryTitles() {
    return [
      BillCategoryTitle("Utilities", true),
      BillCategoryTitle("Finance", false),
      BillCategoryTitle("On The Go", false),
    ];
  }

  List<BillCategoryItems> getUtilitiesItems() {
    return [
      BillCategoryItems(
          "BroadBand", 'assets/images/broadband_selected.png', false),
      BillCategoryItems("Cable", 'assets/images/cable_unselected.png', false),
      BillCategoryItems("DTH", 'assets/images/dth_unselected.png', false),
      BillCategoryItems(
          "Electricity", 'assets/images/electricity_unselected.png', false),
      BillCategoryItems("Gas", 'assets/images/gas_unselected.png', false),
      BillCategoryItems(
          "LPG Booking", 'assets/images/lpg_booking_unselected.png', false),
      BillCategoryItems("Water", 'assets/images/water_unselected.png', false),
    ];
  }

  List<BillCategoryItems> getFinanceItems() {
    return [
      BillCategoryItems("EMI", 'assets/images/emi_unselected.png', false),
      BillCategoryItems(
          "Insurance", 'assets/images/insurance_unselected.png', false),
    ];
  }

  List<BillCategoryItems> getOnTheGoItems() {
    return [
      BillCategoryItems("FastTag", 'assets/images/fast_unselected.png', false),
      BillCategoryItems(
          "Postpaid Datacard", 'assets/images/post_unselected.png', false),
      BillCategoryItems(
          "Postpaid Mobile", 'assets/images/prepaid_unselected.png', false),
    ];
  }

  void loadMoreData() {
    // Simulate data loading delay
    Future.delayed(Duration(seconds: 1), () {
      visibleDataCount += 10;
    });
  }

  // Scroll listener
  void _scrollListener() {
    if (listScrollController.position.pixels ==
        listScrollController.position.maxScrollExtent) {
      loadMoreData();
    }
  }

  // getter and setter
  int get visibleDataCount => _visibleDataCount;

  set visibleDataCount(int value) {
    if (value == _visibleDataCount) return;
    _visibleDataCount = value;
    notifyListeners();
  }
  String get selectedStatus => _selectedStatus;

  bool get showLoadingIndicatorForList => _showLoadingIndicatorForList;

  set showLoadingIndicatorForList(bool value) {
    if (value == _showLoadingIndicatorForList) return;
    _showLoadingIndicatorForList = value;
    notifyListeners();
  }

  bool get showLoadingIndicator => _showLoadingIndicator;

  set showLoadingIndicator(bool value) {
    if (value == _showLoadingIndicator) return;
    _showLoadingIndicator = value;
    notifyListeners();
  }

  set selectedStatus(String value) {
    if (value == _selectedStatus) return;
    _selectedStatus = value;
    notifyListeners();
  }

  String get walletBal => _walletBal;

  set walletBal(String value) {
    if (value == _walletBal) return;
    _walletBal = value;
    notifyListeners();
  }

  String get consumerTitle => _consumerTitle;

  set consumerTitle(String value) {
    if (value == _consumerTitle) return;
    _consumerTitle = value;
    notifyListeners();
  }

  int get operatorID => _operatorID;

  set operatorID(int value) {
    if (value == _operatorID) return;
    _operatorID = value;
    notifyListeners();
  }

  int get selectedOperatorID => _selectedOperatorID;

  set selectedOperatorID(int value) {
    if (value == _selectedOperatorID) return;
    _selectedOperatorID = value;
    notifyListeners();
  }

  DateTime? get selectedStartDate => _selectedStartDate;

  set selectedStartDate(DateTime? value) {
    if (_selectedStartDate == value) return;
    _selectedStartDate = value;
    notifyListeners();
  }

  DateTime? get selectedEndDate => _selectedEndDate;

  set selectedEndDate(DateTime? value) {
    if (_selectedEndDate == value) return;
    _selectedEndDate = value;
    notifyListeners();
  }

  String get referenceNumber => _referenceNumber;

  set referenceNumber(String value) {
    if (value == _referenceNumber) return;
    _referenceNumber = value;
    notifyListeners();
  }

  String get walletBalanceErrorMsg => _walletBalanceErrorMsg;

  set walletBalanceErrorMsg(String value) {
    if (value == _walletBalanceErrorMsg) return;
    _walletBalanceErrorMsg = value;
    notifyListeners();
  }

  String get errorData => _errorData;

  ViewBillResponse get viewBillData => _viewBillData!;

  set viewBillData(ViewBillResponse value) {
    if (value == _viewBillData) return;
    _viewBillData = value;
    notifyListeners();
  }

  set errorData(String value) {
    if (value == _errorData) return;
    _errorData = value;
    notifyListeners();
  }

  String get viewBillRequired => _viewBillRequired;

  set viewBillRequired(String value) {
    if (value == _viewBillRequired) return;
    _viewBillRequired = value;
    notifyListeners();
  }

  String get regexData => _regexData;

  set regexData(String value) {
    if (value == _regexData) return;
    _regexData = value;
    notifyListeners();
  }

  String get selectedOperator => _selectedOperator;

  set selectedOperator(String value) {
    if (value == _selectedOperator) return;
    billingOperatorController.text = value;
    _selectedOperator = value;
    notifyListeners();
  }

  String get selectedCategory => _selectedCategory;

  set selectedCategory(String value) {
    if (value == _selectedCategory) return;
    billingCategoryController.text = value;
    _selectedCategory = value;
    notifyListeners();
  } //textField Controller

  List<CategoryList> get billingCategoryList => _billingCategoryList;

  set billingCategoryList(List<CategoryList> value) {
    if (_billingCategoryList == value) return;
    _billingCategoryList = value;
    notifyListeners();
  }

  List<OperatorList> get billingOperatorList => _billingOperatorList;

  set billingOperatorList(List<OperatorList> value) {
    if (value == _billingOperatorList) return;
    _billingOperatorList = value;
    notifyListeners();
  }

  bool get fieldVisible => _fieldVisible;

  set fieldVisible(bool value) {
    if (value == _fieldVisible) return;
    _fieldVisible = value;
    notifyListeners();
  }

  bool get operatorFieldVisible => _operatorFieldVisible;

  set operatorFieldVisible(bool value) {
    if (value == _operatorFieldVisible) return;
    _operatorFieldVisible = value;
    notifyListeners();
  }

  bool get isIndiaBillPaymentSuccess => _isIndiaBillPaymentSuccess;

  set isIndiaBillPaymentSuccess(bool value) {
    if (value == _isIndiaBillPaymentSuccess) return;
    _isIndiaBillPaymentSuccess = value;
    notifyListeners();
  }

  bool get referenceCopied => _referenceCopied;

  set referenceCopied(bool value) {
    if (value == _referenceCopied) return;
    _referenceCopied = value;
    notifyListeners();
  }

  bool get isBillPaymentPreview => _isBillPaymentPreview;

  set isBillPaymentPreview(bool value) {
    if (value == _isBillPaymentPreview) return;
    _isBillPaymentPreview = value;
    notifyListeners();
  }

  List<Content> get billPaymentArr => _billPaymentArr;

  set billPaymentArr(List<Content> value) {
    if (billPaymentArr == value) {
      return;
    }
    _billPaymentArr = value;
    notifyListeners();
  }

  List<BillCategoryTitle> get billCategoryTitleArr => _billCategoryTitleArr;

  set billCategoryTitleArr(List<BillCategoryTitle> value) {
    if (billCategoryTitleArr == value) {
      return;
    }
    _billCategoryTitleArr = value;
    notifyListeners();
  }

  List<BillCategoryItems> get billCategoryItemsArr => _billCategoryItemsArr;

  set billCategoryItemsArr(List<BillCategoryItems> value) {
    if (billCategoryItemsArr == value) {
      return;
    }
    _billCategoryItemsArr = value;
    notifyListeners();
  }

  // BillPaymentDataSource get billPaymentDataSource => _billPaymentDataSource;
  //
  // set billPaymentDataSource(BillPaymentDataSource value) {
  //   _billPaymentDataSource = value;
  //   notifyListeners();
  // }

  String get billPaymentStatus => _billPaymentStatus;

  set billPaymentStatus(String value) {
    if (billPaymentStatus == value) {
      return;
    }
    _billPaymentStatus = value;
    notifyListeners();
  }

  List<String> get statusData => _statusData;

  set statusData(List<String> value) {
    if (statusData == value) {
      return;
    }
    _statusData = value;
    notifyListeners();
  }

  List<String> get billingCategoryData => _billingCategoryData;

  set billingCategoryData(List<String> value) {
    if (billingCategoryData == value) {
      return;
    }
    _billingCategoryData = value;
    notifyListeners();
  }

  List<String> get billingOperatorData => _billingOperatorData;

  set billingOperatorData(List<String> value) {
    if (billingOperatorData == value) {
      return;
    }
    _billingOperatorData = value;
    notifyListeners();
  }

  bool get isIndiaBillPayment => _isIndiaBillPayment!;

  set isIndiaBillPayment(bool value) {
    if (isIndiaBillPayment == value) {
      return;
    }
    _isIndiaBillPayment = value;
    notifyListeners();
  }

  String get additionalField1 => _additionalField1;

  set additionalField1(String value) {
    if (value == _additionalField1) return;
    _additionalField1 = value;
    notifyListeners();
  }

  String get additionalField2 => _additionalField2;

  set additionalField2(String value) {
    if (value == _additionalField2) return;
    _additionalField2 = value;
    notifyListeners();
  }

  String get additionalField3 => _additionalField3;

  set additionalField3(String value) {
    if (value == _additionalField3) return;
    _additionalField3 = value;
    notifyListeners();
  }

  PricingResponse get pricingData => _pricingData!;

  set pricingData(PricingResponse value) {
    if (value == _pricingData) return;
    _pricingData = value;
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
}
