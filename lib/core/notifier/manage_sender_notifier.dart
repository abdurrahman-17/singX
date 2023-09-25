import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:singx/core/base/base_change_notifier.dart';
import 'package:singx/core/data/remote/service/sender_repository.dart';
import 'package:singx/core/models/request_response/australia/manage_sender/sender_list_response_aus.dart';
import 'package:singx/core/models/request_response/manage_sender/sender_list_response.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class ManageSenderNotifier extends BaseChangeNotifier {

  // ScrollController Controller
  final scrollController = ScrollController();
  final ScrollController paginationScrollController = ScrollController();
  final ScrollController senderDetailsController = ScrollController();

  // Data Controller
  TextEditingController accountHolderNameController = TextEditingController();
  TextEditingController currencyController = TextEditingController();
  TextEditingController currencySGController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController bsbCodeController = TextEditingController();
  TextEditingController jointAccountNameController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController otherBankNameController = TextEditingController();

  // Boolean Data
  bool _showLoadingIndicator = false;
  bool _isAddSender = false;
  bool _isJointAccount = false;
  bool _isOthersFieldVisible = false;

  // List Data
  List _finalData = [];
  List<String> _bankNameList = [];
  List<String> _bankNameListUSD = [];
  List<dynamic> _senderDynamicFields = [];
  List<Content> _contentList = [];
  List<Widget> _children = <Widget>[];
  List<SenderListResponseAus> _contentListAus = [];
  List<SenderListResponseAus> _contentListPaginatedAus = [];
  List<SenderListResponseAus> _contentListOriAus = [];

  // String
  String? _bankName;
  String? _currencyName = "SGD";
  String? _bankId;
  String _saveApiErrorMessage = '';
  String? _branchId;
  String _countryName = '';
  String _url = '?page=0&size=10&filter=';
  String country_ = AppConstants.SingaporeName;

  // Integer
  int _contactId = 0;
  int _countryId = AppConstants.australiaCode;
  int _pageCount = 0;
  int? _pageIndex = 1;

  // double
  double? _commonWidth;

  // Global Key
  final GlobalKey<FormState> manageSenderKey = GlobalKey<FormState>();

  //it is True it will expand the list
  var _isExpanded;

  // Repository
  SenderRepository? senderRepository;

  ManageSenderNotifier(BuildContext context,
      {bool isFundTransferPage = false, String? from, navigateData}) {
    isAddSender = navigateData ?? false;
    userCheck(context);
    senderRepository = SenderRepository();
    loadInitialData();
    if (isFundTransferPage) {
      getContactId();
    } else
      getCountryName(context, from: from);
  }

  loadInitialData() async {
    countryData = await SharedPreferencesMobileWeb.instance.getCountry(AppConstants.country);
  }

  getContactId() async {
    await SharedPreferencesMobileWeb.instance
        .getContactId(AppConstants.apiContactId)
        .then((value) {
      contactId = value;
      notifyListeners();
    });
  }

  makeSGFieldEmpty() {
    accountNumberController.text = '';
    accountHolderNameController.text = '';
    jointAccountNameController.text = '';
    isJointAccount = false;
    bankName = null;
    currencyName = '';
  }

  senderListApi(context) async {
    contentList = [];
    showLoadingIndicator = true;
    await senderRepository?.senderList(context, url).then((value) {
      if (value != null) {
        SenderListResponse senderListResponse = value as SenderListResponse;
        pageCount = senderListResponse.totalPages!;
        contentList = senderListResponse.content!;
        isExpanded = List.filled(contentList.length, false, growable: true);
        showLoadingIndicator = false;
        notifyListeners();
      } else {
        contentList = [];
        showLoadingIndicator = false;
        notifyListeners();
      }
    });
  }

  senderListAusApi(context) async {
    await SharedPreferencesMobileWeb.instance
        .getContactId(AppConstants.apiContactId)
        .then((value) {
      contactId = value;
      notifyListeners();
    });

    await senderRepository?.senderListAus(context, contactId).then((value) {
      if (value != null) {
        contentListOriAus = value as List<SenderListResponseAus>;
        if (contentListOriAus.length > 0) {
          contentListAus = contentListOriAus;
        }
        pageCount = (contentListAus.length / 10).ceil();
        int start = (pageIndex! - 1) * 10;
        int end = start + 10;
        if (end > contentListAus.length) {
          end = contentListAus.length;
        }
        contentListPaginatedAus = contentListAus.sublist(start, end);
        isExpanded = List.filled(contentListAus.length, false, growable: true);
        showLoadingIndicator = false;
        notifyListeners();
      } else {
        contentListAus = [];
        notifyListeners();
      }
    });
  }

  getCountryName(context, {String? from}) async {
    await SharedPreferencesMobileWeb.instance
        .getCountry(AppConstants.country)
        .then((value) async {
      countryName = value;

      notifyListeners();
      if (from == 'Wallet') {
      } else if (countryName == 'Australia') {
        if (isAddSender == false) {
          senderListAusApi(context);
        } else {
          await SharedPreferencesMobileWeb.instance
              .getContactId(AppConstants.apiContactId)
              .then((value) {
            contactId = value;
            notifyListeners();
          });
          senderRepository?.senderBankNames(context, AppConstants.australiaCode);
        }
      } else {
        if (isAddSender == false) {
          await senderListApi(context);
        } else {
          await senderFields(
              context: context,
              getCurrency:
              countryName == AppConstants.singapore ? "SGD" : "HKD");
        }
      }
    });
  }

  senderFields({required BuildContext context, getCurrency}) async {
    if (getCurrency.toString().trim().length != 3) return;
    showLoadingIndicator = true;

    senderDynamicFields = await senderRepository?.senderFields(
        context: context, currency: getCurrency) ??
        [];

    for (int i = 0; i < senderDynamicFields.length; i++) {
      if (senderDynamicFields[i].label == "Bank Name") {
        if (getCurrency == "SGD") {
          bankNameListSGD = senderDynamicFields[i].options;
        } else {
          bankNameListUSD = senderDynamicFields[i].options;
        }
      }
    }

    if (senderDynamicFields.isNotEmpty) {
      senderDynamicFields
          .sort((m, m2) => (m.sortOrder ?? 0).compareTo(m2.sortOrder ?? 0));
    }

    notifyListeners();
    Timer(Duration(seconds: 1), () {
      showLoadingIndicator = false;

      notifyListeners();
    });
    ;
  }

  // Getter and Setter
  bool get isOthersFieldVisible => _isOthersFieldVisible;

  set isOthersFieldVisible(bool value) {
    if (value == _isOthersFieldVisible) return;

    _isOthersFieldVisible = value;
    notifyListeners();
  }

  String get saveApiErrorMessage => _saveApiErrorMessage;

  set saveApiErrorMessage(String value) {
    _saveApiErrorMessage = value;
    notifyListeners();
  }

  int get contactId => _contactId;

  set contactId(int value) {
    _contactId = value;
    notifyListeners();
  }

  int get countryId => _countryId;

  set countryId(int value) {
    _countryId = value;
    notifyListeners();
  }

  String get countryName => _countryName;

  set countryName(String value) {
    _countryName = value;
    notifyListeners();
  }

  List<String> get bankNameListSGD => _bankNameList;

  set bankNameListSGD(List<String> value) {
    _bankNameList = value;
    notifyListeners();
  }

  List<String> get bankNameListUSD => _bankNameListUSD;

  set bankNameListUSD(List<String> value) {
    _bankNameListUSD = value;
    notifyListeners();
  }

  String get branchId => _branchId!;

  set branchId(String value) {
    _branchId = value;
    notifyListeners();
  }

  String get bankId => _bankId!;

  set bankId(String value) {
    _bankId = value;
    notifyListeners();
  }

  List<SenderListResponseAus> get contentListAus => _contentListAus;

  set contentListAus(List<SenderListResponseAus> value) {
    if(_contentListAus == value) return;
    _contentListAus = value;
    notifyListeners();
  }

  List<SenderListResponseAus> get contentListPaginatedAus =>
      _contentListPaginatedAus;

  set contentListPaginatedAus(List<SenderListResponseAus> value) {
    if(_contentListPaginatedAus == value) return;
    _contentListPaginatedAus = value;
    notifyListeners();
  }


  List<SenderListResponseAus> get contentListOriAus => _contentListOriAus;

  set contentListOriAus(List<SenderListResponseAus> value) {
    _contentListOriAus = value;
  }

  List<Content> get contentList => _contentList;

  set contentList(List<Content> value) {
    _contentList = value;
  }

  List<dynamic> get senderDynamicFields => _senderDynamicFields;

  set senderDynamicFields(List<dynamic> value) {
    _senderDynamicFields = value;
    notifyListeners();
  }

  int get pageCount => _pageCount;

  set pageCount(int value) {
    _pageCount = value;
    notifyListeners();
  }

  String get url => _url;

  set url(String value) {
    _url = value;
    notifyListeners();
  }

  int? get pageIndex => _pageIndex;

  set pageIndex(int? value) {
    if (value == _pageIndex) return;
    _pageIndex = value;
    notifyListeners();
  }

  List get finalData => _finalData;

  set finalData(List value) {
    _finalData = value;
    notifyListeners();
  }

  bool get showLoadingIndicator => _showLoadingIndicator;

  set showLoadingIndicator(bool value) {
    _showLoadingIndicator = value;
    notifyListeners();
  }

  get isExpanded => _isExpanded;

  set isExpanded(value) {
    if (value == _isExpanded) {
      return;
    }
    _isExpanded = value;
    notifyListeners();
  }

  bool get isAddSender => _isAddSender;

  set isAddSender(bool value) {
    if (value == _isAddSender) {
      return;
    }
    _isAddSender = value;
    notifyListeners();
  }

  double get commonWidth => _commonWidth!;

  set commonWidth(double value) {
    if (value == _commonWidth) {
      return;
    }
    _commonWidth = value;
    notifyListeners();
  }

  bool get isJointAccount => _isJointAccount;

  set isJointAccount(bool value) {
    if (value == _isJointAccount) {
      return;
    }
    _isJointAccount = value;
    notifyListeners();
  }


  String get bankName => _bankName!;

  set bankName(String? value) {
    if (value == _bankName) {
      return;
    }
    _bankName = value;
    notifyListeners();
  }

  String get currencyName => _currencyName!;

  set currencyName(String? value) {
    if (value == _currencyName) {
      return;
    }
    _currencyName = value;
    notifyListeners();
  }

  String get countryData => country_;

  set countryData(String value) {
    country_ = value;
    currencyController.text =
        country_ == AppConstants.australia ? 'AUD' : "HKD";
    notifyListeners();
  }

  List<Widget> get children => _children;

  set children(List<Widget> value) {
    _children = value;
      notifyListeners();
  }
}

