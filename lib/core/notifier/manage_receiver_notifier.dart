import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:singx/core/base/base_change_notifier.dart';
import 'package:singx/core/data/remote/service/receiver_repository.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/relationship_dropdown/relationship_response_aus.dart';
import 'package:singx/core/models/request_response/australia/manage_receiver/all_countries_list_response.dart';
import 'package:singx/core/models/request_response/australia/manage_receiver/europe_countries_list_response.dart';
import 'package:singx/core/models/request_response/australia/manage_receiver/field_by_country_australia.dart';
import 'package:singx/core/models/request_response/australia/manage_receiver/nationality_list_response.dart';
import 'package:singx/core/models/request_response/australia/manage_receiver/receiver_country_list_response.dart';
import 'package:singx/core/models/request_response/australia/manage_receiver/receiver_list_response.dart';
import 'package:singx/core/models/request_response/australia/manage_receiver/side_note_reponse.dart';
import 'package:singx/core/models/request_response/australia/manage_receiver/state_list_response.dart';
import 'package:singx/core/models/request_response/australia/manage_sender/bank_detail_response.dart';
import 'package:singx/core/models/request_response/australia/manage_sender/branch_detail_response.dart';
import 'package:singx/core/models/request_response/common_response_aus.dart';
import 'package:singx/core/models/request_response/error_response.dart';
import 'package:singx/core/models/request_response/login/login_response.dart';
import 'package:singx/core/models/request_response/manage_receiver/AddReceiverResponse.dart';
import 'package:singx/core/models/request_response/manage_receiver/BankListByBranchCodeResponse.dart';
import 'package:singx/core/models/request_response/manage_receiver/BankListByCountryIdResponse.dart';
import 'package:singx/core/models/request_response/manage_receiver/BranchListByBankIdResponse.dart';
import 'package:singx/core/models/request_response/manage_receiver/branch_code_validate_response.dart';
import 'package:singx/core/models/request_response/manage_receiver/ifsc_details_response.dart';
import 'package:singx/core/models/request_response/manage_receiver/receiver_fields_response.dart';
import 'package:singx/core/models/request_response/manage_receiver/receiver_list_response.dart';
import 'package:singx/core/models/request_response/manage_receiver/save_receiver_account_request.dart';
import 'package:singx/main.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_screen_dimen.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class ManageReceiverNotifier extends BaseChangeNotifier {

  ManageReceiverNotifier(BuildContext context,
      {isReceiverPopUp, navigateData}) {
    userCheck(context);
    receiverRepository = ReceiverRepository();
    isAddReceiver = navigateData ?? false;

    loadInitialApi(context, isReceiverPopUp);
    isAddReceiver = navigateData!;
  }

  loadInitialApi(context, isReceiverPopUp) async {
    userName =
    await SharedPreferencesMobileWeb.instance.getUserName("userName");
    countryData = await SharedPreferencesMobileWeb.instance.getCountry(country);
    if (isAddReceiver == false) {
      await getApi(context);
    } else {
      await getFieldApi(context, isReceiverPopUp);
      await loadCountryDataStr();
      if (countryData == AustraliaName) {
        await getPhoneNumberData(context);
        await getNationalityListAus(context);
        await getEuroCountryListAus(context);
        await getAllCountryListAus(context);
        await loadFieldByCountryData();
        await loadSideNoteData();
        await getRelationshipListAus(context);
        await getSwiftListAus(context);
      }
    }
  }


  //ScrollController
  ScrollController commonController = ScrollController();
  ScrollController paginationScrollController = ScrollController();
  ScrollController commonController1 = ScrollController();
  ScrollController commonController3 = ScrollController();

  //TextEdit Controller
  final otpController = TextEditingController();
  final dateOfExpiryController = TextEditingController();
  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dateIdController = TextEditingController();
  final ifscCodeController = TextEditingController();
  TextEditingController _bankNameController = TextEditingController();
  TextEditingController _branchNameController = TextEditingController();
  TextEditingController _branchAddressController = TextEditingController();
  TextEditingController selectedCurrencyController = TextEditingController();
  TextEditingController selectedReceiverTypeController = TextEditingController();
  TextEditingController selectedReceiverTypeAUSController = TextEditingController();
  TextEditingController selectedCountryController = TextEditingController();
  TextEditingController selectedBankController = TextEditingController();
  TextEditingController selectedBranchController = TextEditingController();
  TextEditingController selectedDataController = TextEditingController();

  //Global Key
  final GlobalKey<FormState> addReceiverFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> manageReceiverKey = GlobalKey<FormState>();

  //boolean Value
  bool _isAddReceiver = false;
  bool _radio_Value = true;
  bool _showBranchName = false;
  bool _isError = false;
  bool _isTimer = false;
  bool _showLoadingIndicator = false;
  bool _showDynamicFields = false;
  bool _isVisible = false;
  bool _isCountryFieldVisible = false;
  bool _isIFSCCodeValid = false;
  bool _isIBANValid =false;
  bool _isBSBCodeValid = false;
  bool _isSwiftCodeValid = false;
  bool _showIFSCData = false;
  bool _showBranchData = false;
  bool _showBranchField = false;

  //String value
  String _bankCode = '';
  String _branchCode = '';
  String _selectedCountry = '';
  String _selectedCurrency = '';
  String _selectedCurrencyForAus = '';
  String _selectedPhoneNumberCode = '';
  String _overallErrorMessage = '';
  String _selectedReceiverType = 'Individual';
  String _url = '?page=0&size=10&filter=';
  String? _receiverBranchCode = '';
  String? _receiverFinancialInstitutionCode = '';
  String? _receiverBranchTransitCode = '';
  String? _receiverIFSCCode = '';
  String? _receiverIBANCode = '';
  String? _receiverBSBCode = '';
  String? _receiverSwiftCode = '';
  String? _receiverACHNumber = '';
  String? _errorIFSCCode = '';
  String? _errorIBANCode = '';
  String? _errorBSBCode = '';
  String? _errorSwiftCode = '';
  String? _receiverCity = '';
  String? _receiverState = '';
  String? _receiverPostalCode = '';
  String? _receiverInstitutionNumber = '';
  String? _receiverTransitNumber = '';
  String? _receiverBicORSwift = '';
  String? _receiverDebitCardNumber = '';
  String? _receiverSortCode = '';
  String? _receiverBankCode = '';
  String? _receiverPayOutPartner = '';
  String country_ = SingaporeName;
  String _OTPErrorMessage = "";
  String? _selectedIndex = '';
  String? _receiverNationality = '';
  String? _receiverType = '';
  String? _receiverIDType = '';
  String? _receiverACType = '';
  String? _receiverIDNumber = '';
  String? _receiverPhoneNumber = '';
  String? _receiverBankName = '';
  String? _receiverBranchName = '';
  String? _receiverBranchAddress = '';
  String? _receiverIBAN = '';
  String? _receiverAcNo = '';
  String _receiverBranchIDSG = "0";
  String _receiverBankIDSG = "0";
  String? _receiverRelationshipWithSender = '';
  String? _receiverPlaceOfIssue = '';
  String? _receiverResAddress = '';
  String _userName = '';
  String _selectedNationality = '';
  String _selectedMobileNumber = '';

  //integer Value
  int _radioValue = 0;
  int _groupValue = -1;
  int? _pageIndex = 1;
  int _number = 0;
  int _pageCount = 0;
  int _transferValue = 0;
  int _countryID = 0;
  int _rowPerPage = 10;
  int _receiverBankID = 0;
  int _receiverBranchID = 0;
  int _receiverStateId = 0;

  //Double value
  late double _commonWidth;

  //Datetime
  DateTime? _selectedDatePicker;
  DateTime? _dateExpiryId;

  //List Data
  List<ReceiverListAusResponse> _contentListPaginatedAus = [];
  List _finalData = [];
  List<String> _currencyDataApi = [];
  List<String> _countryDataStr = [];
  List<String> _currencyAusDataStr = [];
  List<String> _nationalityAusDataStr = [];
  List<int> _nationalityIdAusDataStr = [];
  List<String> _euroCountryAusDataStr = [];
  List<ReceiverFieldsResponse> _receiverDynamicFields = [];
  List _products = [];
  List<Widget> _childrens = <Widget>[];
  List<Content> _contentList = [];
  List<ReceiverListAusResponse> _contentAusList = [];
  List<ReceiverListAusResponse> _contentAusOriList = [];
  List<ReceiverCountryListAusResponse> _countryAusList = [];
  List<NationalityAusListResponse> _nationalityAusList = [];
  List<EuropeCountriesListResponse> _euroCountryAusList = [];
  List<Aed> _AEDAusList = [];
  List<String> _sideNoteList = [];
  List<Php> _PhpAusList = [];
  List<AllCountriesListResponse> _allCountryAusList = [];
  List<String> _allCountryDataStr = [];
  List<String> _swiftCountryDataStr = [];
  List<String> _stateListDataStr = [];
  List<int> _stateListDataId = [];
  List<BankDetailResponse> _bankDetailsList = [];
  List<BranchDetailResponse> _branchDetailsList = [];
  List<String> _bankNameListAus = [];
  List<String> _eWalletListAus = ["Bangladesh Bkash"];
  List<String> _branchNameListAus = [];
  List<String> _branchIDListSG = [];
  List<String> _relationshipListAus = [];
  List<int> _relationshipIdListAus = [];


  //Custom DataTypes
  ReceiverRepository? receiverRepository;
  FieldByCountryListResponse? fieldByCountryListResponse;
  SideNoteResponse? sideNoteResponse;

  //Map Data
  Map<String, String> phoneNumberData = <String, String>{
    "+60": "+60 Malaysia",
    "+94": "+94 Sri Lanka",
    "+65": "+65 Singapore",
    "+62": "+62 Indonesia",
    "+84": "+84 Vietnam",
    "+63": "+63 Philippines",
    "+66": "+66 Thailand",
    "+82": "+82 South Korea",
    "+86": "+86 China",
    "+91": "+91 India",
    "+977": "+977 Nepal",
    "+971": "+971 United Arab Emirates"
  };
  Map<String, dynamic> receiverMap = {};


  //var Data
  var _isExpanded;

  //Functions
  notifyListenersData() {
    notifyListeners();
  }

  makeChildrenEmpty() {
    if (childrens.length > 1) {
      isIFSCCodeValid = false;
      isIBANValid = false;
      isBSBCodeValid = false;
      isSwiftCodeValid = false;
      receiverIFSCCode = '';
      receiverIBANCode = '';
      receiverACHNumber = '';
      receiverBSBCode = '';
      receiverSwiftCode = '';
      errorIBANCode = '';
      errorIFSCCode = '';
      errorBSBCode = '';
      errorSwiftCode = '';
      childrens.removeRange(1, childrens.length);
      finalData.removeRange(1, childrens.length);
      notifyListeners();
    }
  }

  makeAusValueEmpty() {
    showIFSCData = false;
    firstNameController.text = '';
    firstNameController.text = '';
    lastNameController.text = '';
    middleNameController.text = '';
    bankNameController.text = '';
    branchNameController.text = '';
    branchAddressController.text = '';
    bankCode = "";
    branchCode = '';
    receiverNationality = '';
    receiverType = '';
    receiverIDType = '';
    receiverACType = '';
    receiverIDNumber = '';
    receiverPhoneNumber = '';
    receiverBankName = '';
    receiverBranchName = '';
    receiverACHNumber = "";
    receiverBranchAddress = '';
    receiverIBAN = '';
    receiverPlaceOfIssue = '';
    receiverPostalCode = '';
    receiverRelationshipWithSender = '';
    receiverState = '';
    receiverCity = '';
    receiverResAddress = '';
    receiverBankID = 0;
    receiverBranchID = 0;
    receiverPayOutPartner = '';
    receiverDebitCardNumber = '';
    receiverInstitutionNumber = '';
    receiverTransitNumber = '';
    receiverBicORSwift = '';
    receiverSortCode = '';
    receiverIFSCCode = '';
  }

  getCommonWidth(context) {
    commonWidth = isMobile(context) ||
        isTab(context) ||
        getScreenWidth(context) > 800 && getScreenWidth(context) < 1100
        ? getScreenWidth(context)
        : getScreenWidth(context) / 3;
    notifyListeners();
  }

  getPhoneNumberData(BuildContext context)async{
    await SharedPreferencesMobileWeb.instance.getPhoneNumber(AppConstants.phoneNumber).then((value) {
      selectedMobileNumber = value.substring(1, value.length);
    });
  }

  changeRepoRowValue(int value) {
    receiverRepository?.contentCount = value ?? 1;
  }

  getEuroCountryListAus(context) async {
    showLoadingIndicator = true;
    await receiverRepository
        ?.receiverEuropeCountryAusList(context)
        .then((value) {
      showLoadingIndicator = false;
      if (value != null) {
        euroCountryAusList = value as List<EuropeCountriesListResponse>;
        if (euroCountryAusList.isNotEmpty) {
          euroCountryAusDataStr.clear();
          euroCountryAusList.forEach((element) {
            if (element.country != null) {
              euroCountryAusDataStr.add(element.country ?? "");
            }
          });
        }
        notifyListeners();
      } else {
        showLoadingIndicator = false;
      }
    });
    showLoadingIndicator = false;
  }

  getAllCountryListAus(context) async {
    showLoadingIndicator = true;
    await receiverRepository
        ?.receiverAllCountryAusList(context, false)
        .then((value) {
      showLoadingIndicator = false;
      if (value != null) {
        allCountryAusList = value as List<AllCountriesListResponse>;
        if (allCountryAusList.isNotEmpty) {
          allCountryDataStr.clear();
          allCountryAusList.forEach((element) {
            if (element.country != null) {
              allCountryDataStr.add(element.country ?? "");
            }
          });
        }
        notifyListeners();
      } else {
        showLoadingIndicator = false;
      }
    });
    showLoadingIndicator = false;
  }

  getSwiftListAus(context) async {
    showLoadingIndicator = true;
    List<AllCountriesListResponse> senderResponse = [];
    await receiverRepository
        ?.receiverAllCountryAusList(context, true)
        .then((value) {
      showLoadingIndicator = false;
      senderResponse = value as List<AllCountriesListResponse>;
      if (senderResponse.isNotEmpty) {
        swiftCountryDataStr.clear();
        senderResponse.forEach((element) {
          if (element.country != null) {
            swiftCountryDataStr.add(element.country ?? "");
          }
        });
      }
    });

    showLoadingIndicator = false;
  }

  getStateListAus(context) async {
    showLoadingIndicator = true;
    List<StateListResponse> senderResponse = [];
    await receiverRepository?.getStateAusList(context, countryID).then((value) {
      showLoadingIndicator = false;
      senderResponse = value as List<StateListResponse>;
      if (senderResponse.isNotEmpty) {
        stateListDataStr.clear();
        stateListDataId.clear();
        senderResponse.forEach((element) {
          if (element.stateName != null) {
            stateListDataStr.add(element.stateName ?? "");
            stateListDataId.add(element.stateId ?? 0);
          }
        });
      }
    });

    showLoadingIndicator = false;
  }

  getNationalityListAus(context) async {
    showLoadingIndicator = true;
    await receiverRepository?.receiverNationalityAusList(context).then((value) {
      showLoadingIndicator = false;
      if (value != null) {
        nationalityAusList = value as List<NationalityAusListResponse>;
        if (nationalityAusList.isNotEmpty) {
          nationalityAusDataStr.clear();
          nationalityAusList.forEach((element) {
            if (element.country != null) {
              nationalityAusDataStr.add(element.country ?? "");
              nationalityIdAusDataStr.add(element.countryId ?? 0);
            }
          });
        }
        notifyListeners();
      } else {
        showLoadingIndicator = false;
      }
    });
    showLoadingIndicator = false;
  }

  Future<bool> saveReceiver(context, isReceiverPopUp) async {
    int? contactId =
    await SharedPreferencesMobileWeb.instance.getContactId(apiContactId);
    int nationalityIndex = nationalityAusDataStr.indexOf(receiverNationality) ?? -1;
    int nationality = nationalityIndex != -1 ?nationalityIdAusDataStr[nationalityIndex] : 0;
    int senderRelationString =receiverRelationshipWithSender.isNotEmpty ?
        relationshipListAus.indexOf(receiverRelationshipWithSender) : -1;

    int senderRelation = senderRelationString != -1 ? relationshipIdListAus[senderRelationString] : 0;

    showLoadingIndicator = true;
    int isSwiftEuro = selectedIndex == "USD" &&
        euroCountryAusDataStr.contains(selectedCountry)
        ? 1
        : 0;

    int isSwift = selectedIndex == "USD" && isSwiftEuro != 1 ? 1 : 0;

    var requestParams = SaveReceiverAccountRequest(
        accountNumber: "$receiverIBAN",
        accountType: receiverACType,
        activeStatus: 1,
        bankId: receiverBankID,
        branchId: receiverBranchID,
        businessCateogry: "",
        city: receiverCity,
        contactId: contactId,
        createdBy: "$contactId",
        countryId: countryID,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        middleName: middleNameController.text,
        phoneNumber: receiverPhoneNumber,
        postalCode: receiverPostalCode,
        receiverType: "$selectedReceiverType",
        residenceAddress: receiverResAddress,
        senderRelationship: senderRelation,
        state: receiverStateId == 0 ? null : receiverStateId,
        versionId: 1,
        wireTransferModeId: 1,
        nationalityId: nationality,
        isSwift: isSwift,
        isSwiftEuro: isSwiftEuro);

    bool status =
        await receiverRepository?.saveReceiverAccount(context, requestParams) ??
            false;
    showLoadingIndicator = false;
    if (isReceiverPopUp) {
      MyApp.navigatorKey.currentState!.maybePop();
    }

    if (status) {
      if (isReceiverPopUp) {
        showMessageDialog(context, "Receiver Account Saved Successfully",
            onPressed: () async {
              await SharedPreferencesMobileWeb.instance
                  .getCountry(country)
                  .then((value) async {
                MyApp.navigatorKey.currentState!
                    .pushNamed(fundTransferSelectReceiverRoute);
              });
            });
      } else {
        showMessageDialog(context, "Receiver Account Saved Successfully",
            onPressed: () async {
              await SharedPreferencesMobileWeb.instance
                  .getCountry(country)
                  .then((value) async {
                Navigator.pushNamed(context, manageReceiverRoute);
              });
            });
      }
    }
    showLoadingIndicator = false;
    return status;
  }

  Future<bool> addReceiverSG(context, isReceiverPopUp) async {
    showLoadingIndicator = true;
    String email = "";
    SharedPreferencesMobileWeb.instance.getUserData(AppConstants.user).then((value) {
      LoginResponse loginResponse = loginResponseFromJson(value);
      email = loginResponse.userinfo!.emailId!;
    });

    receiverMap["countryId"] = selectedCountry;
    receiverMap["receiverCurrency"] = selectedCurrency;
    receiverMap["receiverType"] = selectedReceiverType;
    // receiverMap["ID Expiry Date"] = selectedReceiverType;

    await receiverRepository?.addReceiverSG(context, receiverMap).then((value) {
      showLoadingIndicator = false;
      AddReceiverResponse response = value as AddReceiverResponse;
      if (response != null) {
        if (response.success) {
          if (isReceiverPopUp) {
            showMessageDialog(context, "Receiver Account Saved Successfully",
                onPressed: () async {
                  await SharedPreferencesMobileWeb.instance
                      .getCountry(country)
                      .then((value) async {
                    MyApp.navigatorKey.currentState!
                        .pushNamed(fundTransferSelectReceiverRoute);
                  });
                });
          } else {
            showMessageDialog(context, "Receiver added successfully",
                onPressed: () async {
                  await SharedPreferencesMobileWeb.instance
                      .getCountry(country)
                      .then((value) async {
                    Navigator.pushNamed(context, manageReceiverRoute);
                  });
                });
            return true;
          }
        } else {
          // showMessageDialog(context,
          //     response.errors![0] ?? AppConstants.somethingWentWrongMessage);
          Navigator.pop(context);
          overallErrorMessage = response.errors![0];
          return false;
        }
      } else {
        showMessageDialog(context, AppConstants.somethingWentWrongMessage);
        return false;
      }
    });

    showLoadingIndicator = false;
    return false;
  }

  Future<bool> dltReceiver(context, receiverAccountID) async {
    showLoadingIndicator = true;
    bool? status;
    if (countryData == AustraliaName) {
      status = await receiverRepository?.deleteReceiverAus(
          context, receiverAccountID);
    } else {
      status = await receiverRepository?.deleteReceiverSG_HK(
          context, receiverAccountID);
    }
    showLoadingIndicator = false;
    return status!;
  }

  getBankNameListAus(context) async {
    showLoadingIndicator = true;
    List<BankDetailResponse> senderResponse = [];
    await receiverRepository
        ?.getBankNameAusList(context, countryID)
        .then((value) {
      showLoadingIndicator = false;
      senderResponse = value as List<BankDetailResponse>;
      bankDetailsList = value as List<BankDetailResponse>;
      if (senderResponse.isNotEmpty) {
        bankNameListAus.clear();
        senderResponse.forEach((element) {
          if (element.bankName != null) {
            bankNameListAus.add(element.bankName ?? "");
          }
        });
      }
    });

    showLoadingIndicator = false;
  }

  getBranchNameListAus(context) async {
    showLoadingIndicator = true;
    List<BranchDetailResponse> senderResponse = [];
    await receiverRepository
        ?.getBranchDetailsByBankID(context, receiverBankID)
        .then((value) {
      showLoadingIndicator = false;
      senderResponse = value as List<BranchDetailResponse>;
      branchDetailsList = value as List<BranchDetailResponse>;
      if (senderResponse.isNotEmpty) {
        branchNameListAus.clear();
        senderResponse.forEach((element) {
          if (element.branchName != null) {
            branchNameListAus.add(element.branchName ?? "");
          }
        });
      }
    });

    showLoadingIndicator = false;
  }

  getRelationshipListAus(context) async {
    showLoadingIndicator = true;
    List<RelationShipAustraliaResponse> senderResponse = [];
    await receiverRepository
        ?.getRelationshipDropdownAusList(context)
        .then((value) {
      showLoadingIndicator = false;
      senderResponse = value as List<RelationShipAustraliaResponse>;
      if (senderResponse.isNotEmpty) {
        relationshipListAus.clear();
        senderResponse.forEach((element) {
          if (element.relationshipName != null) {
            relationshipListAus.add(element.relationshipName ?? "");
            relationshipIdListAus.add(element.relationshipId ?? 0);
          }
        });
      }
    });

    showLoadingIndicator = false;
  }

  getIFSCDetails(context, {isReceiverPopUp = false, setState}) async {
    isReceiverPopUp
        ? setState(() {
      showLoadingIndicator = true;
    })
        : showLoadingIndicator = true;
    await receiverRepository
        ?.getIFSCCode(context, receiverIFSCCode)
        .then((value) async {
      showLoadingIndicator = false;
      IfscDetailsResponse? response = value;

      if (response != null && response.message == null) {
        isReceiverPopUp
            ? setState(() {
          showIFSCData = true;
        })
            : showIFSCData = true;
        overallErrorMessage = "";

        receiverBranchID = response.branchId ?? 1;
        receiverBankID = response.bankId ?? 1;
        receiverBankName = response.bankName ?? "";
        receiverBranchName = response.branchName ?? receiverBankName ?? "";
        receiverBranchAddress = response.branchAddress ?? "";
        branchNameController.text = receiverBranchName;
        branchAddressController.text = receiverBranchAddress;

        await getBankNameByID(context);
      } else {
        showIFSCData = false;
        showMessageDialog(context,
            response.message ?? AppConstants.somethingWentWrongMessage);
      }
    });
    isReceiverPopUp
        ? setState(() {
      showLoadingIndicator = true;
    })
        : showLoadingIndicator = false;
  }

  getFindByRoutingNumber(context) async {
    showLoadingIndicator = true;
    await receiverRepository
        ?.getFindByRoutingNumber(context, receiverBicORSwift)
        .then((value) async {
      showLoadingIndicator = false;
      IfscDetailsResponse? response = value;

      if (response != null && response.message == null) {
        showIFSCData = true;

        receiverBranchID = response.branchId ?? 1;
        receiverBankID = response.bankId ?? 1;
        receiverBankName = response.bankName ?? "";
        receiverBranchName = response.branchName ?? "";
        receiverBranchAddress = response.branchAddress ?? "";
        branchNameController.text = receiverBranchName;
        branchAddressController.text = receiverBranchAddress;

        await getBankNameByID(context);
      } else {
        showIFSCData = false;
        showMessageDialog(context,
            response.message ?? AppConstants.somethingWentWrongMessage);
      }
    });

    showLoadingIndicator = false;
  }

  getCADCodeDetails(context) async {
    showLoadingIndicator = true;
    await receiverRepository
        ?.getCADCodeDetails(context, receiverBicORSwift,
        "$receiverTransitNumber-$receiverInstitutionNumber")
        .then((value) async {
      showLoadingIndicator = false;
      IfscDetailsResponse? response = value;

      if (response != null && response.message == null) {
        showIFSCData = true;

        receiverBranchID = response.branchId ?? 1;
        receiverBankID = response.bankId ?? 1;
        receiverBankName = response.bankName ?? "";
        receiverBranchName = response.branchName ?? receiverBankName ?? "";
        receiverBranchAddress = response.branchAddress ?? "";
        branchNameController.text = receiverBranchName;
        branchAddressController.text = receiverBranchAddress;

        await getBankNameByID(context);
      } else {
        showIFSCData = false;
        showMessageDialog(context,
            response!.message ?? AppConstants.somethingWentWrongMessage);
      }
    });

    showLoadingIndicator = false;
  }

  getBankDetailByBranchCode(context, label, type, value) async {
    showLoadingIndicator = true;
    if(label == "IFSC Code"){
      await receiverRepository
          ?.getBankDetailByBranchCode(
          context, selectedCountry, selectedCurrency, receiverIFSCCode)
          .then((value) async {
        showLoadingIndicator = false;
        BankListByBranchCodeResponse? response = value;
        if (response.success == true) {
          showIFSCData = true;
          receiverBankName = response.bank!.name ?? "";
          receiverBranchName = response.bank!.branch ?? receiverBankName ?? "";
          receiverBranchAddress = response.bank!.address ?? "";
          bankNameController.text = receiverBankName;
          branchNameController.text = receiverBranchName;
          branchAddressController.text = receiverBranchAddress;
        } else {
          showIFSCData = false;
          showMessageDialog(context, AppConstants.somethingWentWrongMessage);
        }
      });
    }else if(label == "Bank code" || label == "Branch Transit Number"){
      await receiverRepository
          ?.getBankDetailByBranchCode(
          context, selectedCountry, selectedCurrency, value)
          .then((value) async {
        showLoadingIndicator = false;
        BankListByBranchCodeResponse? response = value;
        if(label == "Branch Transit Number"){
          if (response.success == true) {
            showIFSCData = true;
            receiverBankName = response.bank!.name ?? "";
            receiverBranchAddress = response.bank!.address ?? "";
            bankNameController.text = receiverBankName;
            branchAddressController.text = receiverBranchAddress;
          } else {
            showIFSCData = false;
            showMessageDialog(context, AppConstants.somethingWentWrongMessage);
          }
        }else{
          if (response.success == true) {
            showIFSCData = true;
            receiverBankName = response.bank!.name ?? "";
            receiverBranchName = response.bank!.branch ?? receiverBankName ?? "";
            bankNameController.text = receiverBankName;
            branchNameController.text = receiverBranchName;
          } else {
            showIFSCData = false;
            showMessageDialog(context, AppConstants.somethingWentWrongMessage);
          }
        }
      });
    }else{
      ReceiverRepository().getBranchCodeValidation(context,selectedCountry,selectedCurrency,type,value).then((value) {
        BranchCodeValidationResponse res = value as BranchCodeValidationResponse;
        if(res.success == true){
          showIFSCData = true;
          receiverBankName = res.bank!.name ?? "";
          receiverBranchAddress = res.bank!.address ?? "";
          bankNameController.text = receiverBankName;
          branchAddressController.text = receiverBranchAddress;
        }else{
          showIFSCData = false;
          showMessageDialog(context, res.errors!.first);
        }
      });
    }
    showLoadingIndicator = false;
  }

  getBranchListByBankID(context, String receiverBankID) async {
    showLoadingIndicator = true;
    await receiverRepository
        ?.getBranchListByBranchCode(context, "$receiverBankID")
        .then((value) async {
      showLoadingIndicator = false;
      BranchListByBankIdResponse? response = value;

      List<BranchContent> contentList = response.content!;
      branchNameListAus = [];
      branchIDListSG = [];
      if (contentList.isNotEmpty) {
        contentList.forEach((element) {
          if (element.branchName != null) {
            branchNameListAus.add(element.branchName ?? "");
            branchIDListSG.add(element.branchId ?? "");
          }
        });
      }
    });
    showLoadingIndicator = false;
  }

  getBankListByCountryID(context) async {
    showLoadingIndicator = true;
    await receiverRepository
        ?.getBankListByCountryID(context, "$countryID", selectedCurrency, "1")
        .then((value) async {
      showLoadingIndicator = false;
      BankListByCountryIdResponse? response = value;

      List<BankContent> contentList = response.content!;
      if (contentList.isNotEmpty) {
        contentList.forEach((element) {
          if (element.bankName != null) {
            bankNameListAus.add(element.bankName ?? "");
          }
        });
      }
    });
    showLoadingIndicator = false;
  }

  getSwiftCodeDetails(context) async {
    showLoadingIndicator = true;

    await receiverRepository
        ?.getSwiftCodeDetails(context, receiverBicORSwift, "$countryID")
        .then((value) async {
      showLoadingIndicator = false;
      IfscDetailsResponse? response = value;

      if (response != null && response.message == null) {
        showIFSCData = true;
        overallErrorMessage = "";
        receiverBranchID = response.branchId ?? 1;
        receiverBankID = response.bankId ?? 1;
        receiverBankName = response.bankName ?? "";
        receiverBranchName = response.branchName ?? receiverBankName ?? "";
        receiverBranchAddress = response.branchAddress ?? "";
        branchNameController.text = receiverBranchName;
        branchAddressController.text = receiverBranchAddress;
        await getBankNameByID(context);
      } else {
        showIFSCData = false;
        showMessageDialog(context,
            response.message ?? AppConstants.somethingWentWrongMessage);
      }
    });
    showLoadingIndicator = false;
  }

  getSortCodeDetails(context) async {
    showLoadingIndicator = true;
    await receiverRepository
        ?.getSortCode(context, receiverSortCode)
        .then((value) async {
      showLoadingIndicator = false;
      IfscDetailsResponse? response = value;

      if (response != null && response.message == null) {
        showIFSCData = true;
        overallErrorMessage = "";
        receiverBranchID = response.branchId ?? 1;
        receiverBankID = response.bankId ?? 1;
        receiverBankName = response.bankName ?? "";
        receiverBranchName = response.branchName ?? receiverBankName ?? "";
        receiverBranchAddress = response.branchAddress ?? "";
        branchNameController.text = receiverBranchName;
        branchAddressController.text = receiverBranchAddress;
        await getBankNameByID(context);
      } else {
        showIFSCData = false;
        showMessageDialog(context,
            response.message ?? AppConstants.somethingWentWrongMessage);
      }
    });
    showLoadingIndicator = false;
  }

  getHKCodeDetails(context) async {
    showLoadingIndicator = true;
    await receiverRepository
        ?.getHkCodeDetails(context, bankCode, branchCode)
        .then((value) async {
      showLoadingIndicator = false;
      IfscDetailsResponse? response = value;

      if (response != null && response.message == null) {
        showIFSCData = true;
        overallErrorMessage = "";
        receiverBranchID = response.branchId ?? 1;
        receiverBankID = response.bankId ?? 1;
        receiverBankName = response.bankName ?? "";
        receiverBranchName = response.branchName ?? receiverBankName ?? "";
        receiverBranchAddress = response.branchAddress ?? "";
        bankNameController.text = response.bankName ?? "";
        branchNameController.text = receiverBranchName;
        branchAddressController.text = receiverBranchAddress;
      } else {
        showIFSCData = false;
        showMessageDialog(context,
            response!.message ?? AppConstants.somethingWentWrongMessage);
      }
    });
    showLoadingIndicator = false;
  }

  getBankNameByID(context) async {
    showLoadingIndicator = true;
    await receiverRepository
        ?.getBankNameByID(context, receiverBankID)
        .then((value) {
      showLoadingIndicator = false;

      CommonResponseAus? response = value;
      if (response.message != null) {
        receiverBankName = response.message ?? "";
        bankNameController.text = receiverBankName;
      }
    });
    showLoadingIndicator = false;
  }

  getFieldApi(context, isReceiverPopUp) async {
    countryData = await SharedPreferencesMobileWeb.instance.getCountry(country);
    if (countryData == AustraliaName) {
      await receiverRepository?.receiverCountryAusList(context).then((value) {
        if (value != null) {
          _currencyAusDataStr.clear();
          countryAusList = value as List<ReceiverCountryListAusResponse>;
          if (countryAusList.isNotEmpty) {
            countryAusList.forEach((element) {
              _currencyAusDataStr
                  .add("${element.currencyCode} - ${element.country}");
            });
          }

          showLoadingIndicator = false;
          notifyListeners();
        } else {
          countryAusList = [];
          currencyAusDataStr.clear();
          showLoadingIndicator = false;
          notifyListeners();
        }
      });
    } else {
      await receiverRepository?.receiverCountry(context);

      selectedIndex =
          receiverRepository?.receiverCountryFields.keys.first ?? "";
      showLoadingIndicator = false;
    }
    notifyListeners();
  }

  Future<int> getApi1(context) async {
    return 1;
  }

  getApi(context) async {
    contentList = [];
    showLoadingIndicator = true;
    countryData = await SharedPreferencesMobileWeb.instance.getCountry(country);

    notifyListeners();
    if (countryData == AustraliaName) {
      await receiverRepository?.receiverAusList(context).then((value) {
        showLoadingIndicator = false;
        if (value != null) {

          contentAusOriList = value as List<ReceiverListAusResponse>;
          if (contentAusOriList.length > 0) {
            contentAusList = contentAusOriList;
          }
          pageCount = (contentAusList.length / 10).ceil();
          int start = (pageIndex! -1) * 10;
          int end = start + 10;
          if (end > contentAusList.length) {
            end = contentAusList.length;
          }
          contentListPaginatedAus =  contentAusList.sublist(start, end);
          ReceiverRepository receiverRepository = ReceiverRepository();
          receiverRepository.contentCount = contentListPaginatedAus.length;
          isExpanded =
              List.filled(contentAusList.length, false, growable: true);

          notifyListeners();
        } else {
          contentAusList = [];
          showLoadingIndicator = false;
          notifyListeners();
        }
      });
    } else {
      await receiverRepository?.receiverList(context, url).then((value) {
        showLoadingIndicator = false;
        if (value != null) {
          ReceiverListResponse receiverListResponse =
          value as ReceiverListResponse;
          pageCount = receiverListResponse.totalPages!;
          contentList = receiverListResponse.content!;
          _products.addAll(receiverListResponse.content!);
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

    notifyListeners();
  }

  loadCountryDataStr() async {
    countryData = await SharedPreferencesMobileWeb.instance.getCountry(country);
    if (countryData == AustraliaName) {
      _countryDataStr.clear();
      countryAusList.forEach((value) {
        if (selectedIndex == value.currencyCode) {
          _countryDataStr.add(value.country ?? "");
        }
      });

      notifyListeners();
    } else {
      currencyDataApi =
          receiverRepository?.receiverCountryFields.keys.toList() ?? [];

      _countryDataStr.clear();
      receiverRepository?.receiverCountryFields.forEach((key, value) {
        if (selectedIndex == key) {
          value.forEach((element) {
            _countryDataStr.add(element.country!);
          });
        }
      });
    }
    notifyListeners();
  }

  Future<void> getAusFields(context) async {
    if (selectedIndex == "AED") {
      AEDAusList = fieldByCountryListResponse?.aed ?? [];
      getBankNameListAus(context);
    } else if (selectedIndex == "BDT") {
      AEDAusList = fieldByCountryListResponse?.bdt ?? [];
      getBankNameListAus(context);
    } else if (selectedIndex == "CAD") {
      AEDAusList = fieldByCountryListResponse?.cad ?? [];
      getStateListAus(context);
    } else if (selectedIndex == "CNY") {
      AEDAusList = fieldByCountryListResponse?.cny ?? [];
      getBankNameListAus(context);
    } else if (selectedIndex == "EUR") {
      AEDAusList = fieldByCountryListResponse?.eur ?? [];
    } else if (selectedIndex == "GBP") {
      AEDAusList = fieldByCountryListResponse?.gbp ?? [];
    } else if (selectedIndex == "HKD") {
      AEDAusList = fieldByCountryListResponse?.hkd ?? [];
    } else if (selectedIndex == "IDR") {
      AEDAusList = fieldByCountryListResponse?.idr ?? [];
      getBankNameListAus(context);
    } else if (selectedIndex == "INR") {
      AEDAusList = fieldByCountryListResponse?.inr ?? [];
    } else if (selectedIndex == "JPY") {
      AEDAusList = fieldByCountryListResponse?.jpy ?? [];
    } else if (selectedIndex == "KRW") {
      AEDAusList = fieldByCountryListResponse?.krw ?? [];
      getBankNameListAus(context);
    } else if (selectedIndex == "LKR") {
      AEDAusList = fieldByCountryListResponse?.lkr ?? [];
      getBankNameListAus(context);
    } else if (selectedIndex == "MYR") {
      AEDAusList = fieldByCountryListResponse?.myr ?? [];
      getBankNameListAus(context);
    } else if (selectedIndex == "NPR") {
      AEDAusList = fieldByCountryListResponse?.npr ?? [];
      getBankNameListAus(context);
    } else if (selectedIndex == "NZD") {
      AEDAusList = fieldByCountryListResponse?.nzd ?? [];
    } else if (selectedIndex == "SGD") {
      AEDAusList = fieldByCountryListResponse?.sgd ?? [];
      getBankNameListAus(context);
    } else if (selectedIndex == "THB") {
      AEDAusList = fieldByCountryListResponse?.thb ?? [];
      getBankNameListAus(context);
    } else if (selectedIndex == "USD") {
      AEDAusList = fieldByCountryListResponse?.usd ?? [];
    } else if (selectedIndex == "VND") {
      AEDAusList = fieldByCountryListResponse?.vnd ?? [];
      getBankNameListAus(context);
    } else if (selectedIndex == "ZAR") {
      AEDAusList = fieldByCountryListResponse?.zar ?? [];
      getBankNameListAus(context);
    } else if (selectedIndex == "PHP" && transferValue == 0) {
      AEDAusList = fieldByCountryListResponse?.php![0].bank ?? [];
      getBankNameListAus(context);
    } else if (selectedIndex == "PHP" && transferValue == 1) {
      AEDAusList = fieldByCountryListResponse?.php![0].cash ?? [];
      getBankNameListAus(context);
    }
  }

  Future<void> getSideNoteList(context) async {
    if (selectedIndex == "AED") {
      sideNoteResponse?.aed!.forEach((element) {
        if (selectedReceiverType == element.type)
          sideNoteList = element.options!;
      });
    } else if (selectedIndex == "BDT") {
      sideNoteResponse?.bdt!.forEach((element) {
        sideNoteList = element.options!;
      });
    } else if (selectedIndex == "CAD") {
      sideNoteResponse?.cad!.forEach((element) {
        if (selectedReceiverType == element.type)
          sideNoteList = element.options!;
      });
    } else if (selectedIndex == "CNY") {
      sideNoteResponse?.cny!.forEach((element) {
        sideNoteList = element.options!;
      });
    } else if (selectedIndex == "EUR") {
      sideNoteResponse?.eur!.forEach((element) {
        if (selectedReceiverType == element.type)
          sideNoteList = element.options!;
      });
    } else if (selectedIndex == "GBP") {
      sideNoteResponse?.gbp!.forEach((element) {
        if (selectedReceiverType == element.type)
          sideNoteList = element.options!;
      });
    } else if (selectedIndex == "HKD") {
      sideNoteResponse?.hkd!.forEach((element) {
        sideNoteList = element.options!;
      });
    } else if (selectedIndex == "IDR") {
      sideNoteResponse?.idr!.forEach((element) {
        if (selectedReceiverType == element.type)
          sideNoteList = element.options!;
      });
    } else if (selectedIndex == "INR") {
      sideNoteResponse?.inr!.forEach((element) {
        sideNoteList = element.options!;
      });
    } else if (selectedIndex == "JPY") {
      sideNoteResponse?.jpy!.forEach((element) {
        if (selectedReceiverType == element.type)
          sideNoteList = element.options!;
      });
    } else if (selectedIndex == "KRW") {
      sideNoteResponse?.krw!.forEach((element) {
        if (selectedReceiverType == element.type)
          sideNoteList = element.options!;
      });
    } else if (selectedIndex == "LKR") {
      sideNoteResponse?.lkr!.forEach((element) {
        if (selectedReceiverType == element.type)
          sideNoteList = element.options!;
      });
    } else if (selectedIndex == "MYR") {
      sideNoteResponse?.myr!.forEach((element) {
        sideNoteList = element.options!;
      });
    } else if (selectedIndex == "NPR") {
      sideNoteResponse?.npr!.forEach((element) {
        sideNoteList = element.options!;
      });
    } else if (selectedIndex == "NZD") {
      sideNoteResponse?.nzd!.forEach((element) {
        sideNoteList = element.options!;
      });
    } else if (selectedIndex == "SGD") {
      sideNoteResponse?.sgd!.forEach((element) {
        sideNoteList = element.options!;
      });
    } else if (selectedIndex == "THB") {
      sideNoteResponse?.thb!.forEach((element) {
        if (selectedReceiverType == element.type)
          sideNoteList = element.options!;
      });
    } else if (selectedIndex == "USD") {
      sideNoteResponse?.usd!.forEach((element) {
        if (selectedReceiverType == element.type)
          sideNoteList = element.options!;
      });
    } else if (selectedIndex == "VND") {
      sideNoteResponse?.vnd!.forEach((element) {
        sideNoteList = element.options!;
      });
    } else if (selectedIndex == "ZAR") {
      sideNoteResponse?.zar!.forEach((element) {
        if (selectedReceiverType == element.type)
          sideNoteList = element.options!;
      });
    } else if (selectedIndex == "PHP" && transferValue == 0) {
      selectedReceiverType = "Individual";

      sideNoteResponse?.php!.forEach((element) {
        if (selectedReceiverType == element.type)
          sideNoteList = element.options!;
      });
    } else if (selectedIndex == "PHP" && transferValue == 1) {
      selectedReceiverType = "Business";

      sideNoteResponse?.php!.forEach((element) {
        if (selectedReceiverType == element.type)
          sideNoteList = element.options!;
      });
    }
  }

  Future loadFieldByCountryData() async {
    String jsonPhotos = await getFieldByCountryAusData();
    final jsonResponse = json.decode(jsonPhotos);

    fieldByCountryListResponse =
        FieldByCountryListResponse.fromJson(jsonResponse);
  }

  Future<String> getFieldByCountryAusData() async {
    return await rootBundle
        .loadString('assets/field_by_country_australia.json');
  }

  Future loadSideNoteData() async {
    String jsonPhotos = await getSideNoteListLoad();
    final jsonResponse = json.decode(jsonPhotos);

    sideNoteResponse = SideNoteResponse.fromJson(jsonResponse);
  }

  Future<String> getSideNoteListLoad() async {
    return await rootBundle
        .loadString('assets/country_fields_receiver_list.json');
  }

  getData(context, selectedCountry, selectedCurrency, {isReceiverPopUp}) async {
    branchNameListAus = [];
    receiverDynamicFields = await receiverRepository?.receiverFields(
        context,
        countryData == HongKongName && selectedCurrency == "EUR"
            ? "Europe"
            : (countryData == HongKongName &&
            selectedCurrency == "USD" &&
            selectedCountry == "United States - Local Payments")
            ? "United States of America"
            : (countryData == HongKongName && selectedCurrency == "USD")
            ? "USSWIFT"
            : selectedCountry,
        selectedCurrency) ??
        [];

    if (receiverDynamicFields.isNotEmpty) {
      receiverDynamicFields
          .sort((m, m2) => (m.sortOrder ?? 0).compareTo(m2.sortOrder ?? 0));
    }
    var contain =
    receiverDynamicFields.where((element) => element.field == "branch");
    if (contain.isNotEmpty) {
      // if(selectedCurrency == "LKR" && countryData == SingaporeName) showBranchData = false;
      // else
      showBranchData = true;
    } else {
      showBranchData = false;
    }

    notifyListeners();
    Timer(Duration(seconds: 1), () {
      showLoadingIndicator = false;
      notifyListeners();
    });
    ;
  }

  deleteReceiverAlert(BuildContext context, index) {
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('');
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () async {
        Navigator.of(context, rootNavigator: true).pop('');
        bool status;
        if (countryData == AustraliaName) {
          status = await dltReceiver(
              context, "${contentAusList[index].receiverAccountId}");
        } else {
          status = await dltReceiver(context, "${contentList[index].id}");
        }
        if (status) {
          Navigator.pushNamed(context, manageReceiverRoute);
        } else {
          showMessageDialog(context, AppConstants.somethingWentWrongMessage);
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Do you want to delete this receiver account?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    CupertinoAlertDialog alertios = CupertinoAlertDialog(
      content: Text("Do you want to delete this receiver account?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // if (Theme.of(context).platform == TargetPlatform.iOS) {
        //   return AppInActiveCheck(context: context, child: alertios);
        // }
        return AppInActiveCheck(context: context, child: alert);
      },
    );
  }

  Future<bool?> getBranchAPICall(BuildContext context, ManageReceiverNotifier manageReceiverNotifier,String type,String value) async {
    //ifsc/iban/bsb/swift
    BranchCodeValidationResponse? res;
    await ReceiverRepository().getBranchCodeValidation(context,manageReceiverNotifier.selectedCountry,manageReceiverNotifier.selectedCurrency,type,value).then((value) {
      if(value is BranchCodeValidationResponse){
        res = value;
        type == "iBan"
            ? manageReceiverNotifier.errorIBANCode = (res!.errors != null && res!.errors!.isNotEmpty) ? res!.errors![0] : ''
            : type == 'ifsc'
            ? manageReceiverNotifier.errorIFSCCode = (res!.errors != null && res!.errors!.isNotEmpty) ? res!.errors![0] : ''
            : type == 'bsb'
            ? manageReceiverNotifier.errorBSBCode = (res!.errors != null && res!.errors!.isNotEmpty) ? res!.errors![0] : ''
            : manageReceiverNotifier.errorSwiftCode = (res!.errors != null && res!.errors!.isNotEmpty) ? res!.errors![0] : '';
      }else{
        ErrorString error = value as ErrorString;
        type == "iBan"
            ? manageReceiverNotifier.errorIBANCode = error.error!
            : type == 'ifsc'
            ? manageReceiverNotifier.errorIFSCCode = error.error!
            : type == 'bsb'
            ? manageReceiverNotifier.errorBSBCode = error.error!
            : manageReceiverNotifier.errorSwiftCode = error.error!;
      }

      manageReceiverNotifier.notifyListeners();
    });

    return (res!.success != null ? res!.success : false);
  }

  //Getter Setter
  bool get showBranchName => _showBranchName;

  set showBranchName(bool value) {
    _showBranchName = value;
    notifyListeners();
  }

  bool get isError => _isError;

  set isError(bool value) {
    _isError = value;
    notifyListeners();
  }

  bool get isTimer => _isTimer;

  set isTimer(bool value) {
    if (_isTimer == value) {
      return;
    }
    _isTimer = value;
    notifyListeners();
  }

  List<ReceiverListAusResponse> get contentListPaginatedAus => _contentListPaginatedAus;

  set contentListPaginatedAus(List<ReceiverListAusResponse> value) {
    if(_contentListPaginatedAus == value) return;
    _contentListPaginatedAus = value;
    notifyListeners();
  }

  int? get pageIndex => _pageIndex;

  set pageIndex(int? value) {
    if (value == _pageIndex) return;
    _pageIndex = value;
    notifyListeners();
  }

  int get receiverStateId => _receiverStateId;

  set receiverStateId(int value) {
    if (value == _receiverStateId) return;
    _receiverStateId = value;
    notifyListeners();
  }

  DateTime? get selectedDatePicker => _selectedDatePicker;

  set selectedDatePicker(DateTime? value) {
    if (_selectedDatePicker == value) return;
    _selectedDatePicker = value;
    notifyListeners();
  }

  String get selectedPhoneNumberCode => _selectedPhoneNumberCode;

  set selectedPhoneNumberCode(String value) {
    if (_selectedPhoneNumberCode == value) return;
    _selectedPhoneNumberCode = value;
    notifyListeners();
  }

  String get overallErrorMessage => _overallErrorMessage;

  set overallErrorMessage(String value) {
    if (_overallErrorMessage == value) return;
    _overallErrorMessage = value;
    notifyListeners();
  }

  List<Widget> get childrens => _childrens;

  set childrens(List<Widget> value) {
    _childrens = value;
    notifyListeners();
  }

  String get bankCode => _bankCode;

  set bankCode(String value) {
    _bankCode = value;
    notifyListeners();
  }

  String get branchCode => _branchCode;

  set branchCode(String value) {
    _branchCode = value;
    notifyListeners();
  }



  String get userName => _userName;

  set userName(String value) {
    _userName = value;
    notifyListeners();
  }

  double get commonWidth => _commonWidth;

  set commonWidth(double value) {
    _commonWidth = value;
  }

  String get url => _url;

  set url(String value) {
    _url = value;
  }

  String get selectedReceiverType => _selectedReceiverType;

  set selectedReceiverType(String value) {
    _selectedReceiverType = value;
    notifyListeners();
  }

  String get selectedNationality => _selectedNationality;

  set selectedNationality(String value) {
    _selectedNationality = value;
    notifyListeners();
  }

  String get selectedMobileNumber => _selectedMobileNumber;

  set selectedMobileNumber(String value) {
    if(_selectedMobileNumber == value) return;
    _selectedMobileNumber = value;
    notifyListeners();
  }

  List<Content> get contentList => _contentList;

  set contentList(List<Content> value) {
    if(_contentList == value) return;
    _contentList = value;
    notifyListeners();
  }

  List<ReceiverListAusResponse> get contentAusList => _contentAusList;

  set contentAusList(List<ReceiverListAusResponse> value) {
    if(_contentAusList == value) return;
    _contentAusList = value;
    notifyListeners();
  }

  List<ReceiverListAusResponse> get contentAusOriList => _contentAusOriList;

  set contentAusOriList(List<ReceiverListAusResponse> value) {
    if(_contentAusOriList == value) return;
    _contentAusOriList = value;
    notifyListeners();
  }

  List<ReceiverCountryListAusResponse> get countryAusList => _countryAusList;

  set countryAusList(List<ReceiverCountryListAusResponse> value) {
    if(_countryAusList == value) return;
    _countryAusList = value;
    notifyListeners();
  }



  List<NationalityAusListResponse> get nationalityAusList =>
      _nationalityAusList;

  set nationalityAusList(List<NationalityAusListResponse> value) {
    _nationalityAusList = value;
  }



  List<EuropeCountriesListResponse> get euroCountryAusList =>
      _euroCountryAusList;

  set euroCountryAusList(List<EuropeCountriesListResponse> value) {
    _euroCountryAusList = value;
  }



  List<Aed> get AEDAusList => _AEDAusList;

  set AEDAusList(List<Aed> value) {
    _AEDAusList = value;
  }



  List<String> get sideNoteList => _sideNoteList;

  set sideNoteList(List<String> value) {
    _sideNoteList = value;
  }



  List<Php> get PhpAusList => _PhpAusList;

  set PhpAusList(List<Php> value) {
    _PhpAusList = value;
  }



  List<AllCountriesListResponse> get allCountryAusList => _allCountryAusList;

  set allCountryAusList(List<AllCountriesListResponse> value) {
    _allCountryAusList = value;
  }



  List<String> get allCountryDataStr => _allCountryDataStr;

  set allCountryDataStr(List<String> value) {
    _allCountryDataStr = value;
  }



  List<String> get swiftCountryDataStr => _swiftCountryDataStr;

  set swiftCountryDataStr(List<String> value) {
    _swiftCountryDataStr = value;
  }



  List<String> get stateListDataStr => _stateListDataStr;

  set stateListDataStr(List<String> value) {
    _stateListDataStr = value;
  }

  List<int> get stateListDataId => _stateListDataId;

  set stateListDataId(List<int> value) {
    _stateListDataId = value;
  }

  int get pageCount => _pageCount;

  set pageCount(int value) {
    _pageCount = value;
    notifyListeners();
  }

  List get products => _products;

  set products(List value) {
    _products = value;
    notifyListeners();
  }

  List<ReceiverFieldsResponse> get receiverDynamicFields =>
      _receiverDynamicFields;

  set receiverDynamicFields(List<ReceiverFieldsResponse> value) {
    _receiverDynamicFields = value;
    notifyListeners();
  }

  bool get showDynamicFields => _showDynamicFields;

  set showDynamicFields(bool value) {
    _showDynamicFields = value;
    notifyListeners();
  }



  bool get showIFSCData => _showIFSCData;

  set showIFSCData(bool value) {
    _showIFSCData = value;
    notifyListeners();
  }




  bool get showBranchField => _showBranchField;

  set showBranchField(bool value) {
    _showBranchField = value;
    notifyListeners();
  }

  bool get showBranchData => _showBranchData;

  set showBranchData(bool value) {
    _showBranchData = value;
    notifyListeners();
  }

  bool get isCountryFieldVisible => _isCountryFieldVisible;

  set isCountryFieldVisible(bool value) {
    if (_isCountryFieldVisible == value) return;
    _isCountryFieldVisible = value;
    notifyListeners();
  }

  bool get isVisible => _isVisible;

  set isVisible(bool value) {
    _isVisible = value;
    notifyListeners();
  }

  List<String> get currencyAusDataStr => _currencyAusDataStr;

  set currencyAusDataStr(List<String> value) {
    _currencyAusDataStr = value;
    notifyListeners();
  }

  List<String> get nationalityAusDataStr => _nationalityAusDataStr;

  set nationalityAusDataStr(List<String> value) {
    _nationalityAusDataStr = value;
    notifyListeners();
  }

  List<int> get nationalityIdAusDataStr => _nationalityIdAusDataStr;

  set nationalityIdAusDataStr(List<int> value) {
    _nationalityIdAusDataStr = value;
    notifyListeners();
  }



  List<BankDetailResponse> get bankDetailsList => _bankDetailsList;

  set bankDetailsList(List<BankDetailResponse> value) {
    _bankDetailsList = value;
    notifyListeners();
  }



  List<BranchDetailResponse> get branchDetailsList => _branchDetailsList;

  set branchDetailsList(List<BranchDetailResponse> value) {
    _branchDetailsList = value;
    notifyListeners();
  }



  List<String> get bankNameListAus => _bankNameListAus;

  set bankNameListAus(List<String> value) {
    _bankNameListAus = value;
    notifyListeners();
  }



  List<String> get eWalletListAus => _eWalletListAus;

  set eWalletListAus(List<String> value) {
    _eWalletListAus = value;
    notifyListeners();
  }



  List<String> get branchNameListAus => _branchNameListAus;

  set branchNameListAus(List<String> value) {
    _branchNameListAus = value;
    notifyListeners();
  }



  List<String> get branchIDListSG => _branchIDListSG;

  set branchIDListSG(List<String> value) {
    _branchIDListSG = value;
    notifyListeners();
  }



  List<String> get relationshipListAus => _relationshipListAus;

  set relationshipListAus(List<String> value) {
    _relationshipListAus = value;
    notifyListeners();
  }

  List<int> get relationshipIdListAus => _relationshipIdListAus;

  set relationshipIdListAus(List<int> value) {
    _relationshipIdListAus = value;
    notifyListeners();
  }

  List<String> get euroCountryAusDataStr => _euroCountryAusDataStr;

  set euroCountryAusDataStr(List<String> value) {
    _euroCountryAusDataStr = value;
    notifyListeners();
  }

  List<String> get countryDataStr => _countryDataStr;

  set countryDataStr(List<String> value) {
    _countryDataStr = value;
    notifyListeners();
  }

  List<String> get currencyDataApi => _currencyDataApi;

  set currencyDataApi(List<String> value) {
    _currencyDataApi = value;
    notifyListeners();
  }

  get isExpanded => _isExpanded;

  set isExpanded(value) {
    _isExpanded = value;
    notifyListeners();
  }

  String get selectedIndex => _selectedIndex ?? '';

  set selectedIndex(String value) {
    _selectedIndex = value;
    notifyListeners();
  }



  String get receiverNationality => _receiverNationality ?? '';

  set receiverNationality(String value) {
    _receiverNationality = value;
    notifyListeners();
  }



  String get receiverType => _receiverType ?? '';

  set receiverType(String value) {
    _receiverType = value;
    notifyListeners();
  }



  String get receiverIDType => _receiverIDType ?? '';

  set receiverIDType(String value) {
    _receiverIDType = value;
    notifyListeners();
  }



  String get receiverACType => _receiverACType ?? '';

  set receiverACType(String value) {
    _receiverACType = value;
    notifyListeners();
  }



  String get receiverIDNumber => _receiverIDNumber ?? '';

  set receiverIDNumber(String value) {
    _receiverIDNumber = value;
    notifyListeners();
  }



  String get receiverPhoneNumber => _receiverPhoneNumber ?? '';

  set receiverPhoneNumber(String value) {
    _receiverPhoneNumber = value;
    notifyListeners();
  }



  String get receiverBankName => _receiverBankName ?? '';

  set receiverBankName(String value) {
    _receiverBankName = value;
    notifyListeners();
  }



  String get receiverBranchName => _receiverBranchName ?? '';

  set receiverBranchName(String value) {
    _receiverBranchName = value;
    notifyListeners();
  }



  String get receiverBranchAddress => _receiverBranchAddress ?? '';

  set receiverBranchAddress(String value) {
    _receiverBranchAddress = value;
    notifyListeners();
  }



  String get receiverIBAN => _receiverIBAN ?? '';

  set receiverIBAN(String value) {
    _receiverIBAN = value;
    notifyListeners();
  }



  String get receiverAcNo => _receiverAcNo ?? '';

  set receiverAcNo(String value) {
    _receiverAcNo = value;
    notifyListeners();
  }



  String get receiverPlaceOfIssue => _receiverPlaceOfIssue ?? '';

  set receiverPlaceOfIssue(String value) {
    _receiverPlaceOfIssue = value;
    notifyListeners();
  }



  String get receiverResAddress => _receiverResAddress ?? '';

  set receiverResAddress(String value) {
    _receiverResAddress = value;
    notifyListeners();
  }



  int get receiverBankID => _receiverBankID;

  set receiverBankID(int value) {
    _receiverBankID = value;
    notifyListeners();
  }



  int get receiverBranchID => _receiverBranchID;

  set receiverBranchID(int value) {
    _receiverBranchID = value;
    notifyListeners();
  }



  String get receiverBranchIDSG => _receiverBranchIDSG;

  set receiverBranchIDSG(String value) {
    _receiverBranchIDSG = value;
    notifyListeners();
  }



  String get receiverBankIDSG => _receiverBankIDSG;

  set receiverBankIDSG(String value) {
    _receiverBankIDSG = value;
    notifyListeners();
  }



  String get receiverRelationshipWithSender =>
      _receiverRelationshipWithSender ?? '';

  set receiverRelationshipWithSender(String value) {
    _receiverRelationshipWithSender = value;
    notifyListeners();
  }

  String get receiverCity => _receiverCity ?? '';

  set receiverCity(String value) {
    _receiverCity = value;
    notifyListeners();
  }

  String get receiverState => _receiverState ?? '';

  set receiverState(String value) {
    _receiverState = value;
    notifyListeners();
  }


  String get receiverPostalCode => _receiverPostalCode ?? '';

  set receiverPostalCode(String value) {
    _receiverPostalCode = value;
    notifyListeners();
  }



  String get receiverInstitutionNumber => _receiverInstitutionNumber ?? '';

  set receiverInstitutionNumber(String value) {
    _receiverInstitutionNumber = value;
    notifyListeners();
  }



  String get receiverTransitNumber => _receiverTransitNumber ?? '';

  set receiverTransitNumber(String value) {
    _receiverTransitNumber = value;
    notifyListeners();
  }



  String get receiverBicORSwift => _receiverBicORSwift ?? '';

  set receiverBicORSwift(String value) {
    _receiverBicORSwift = value;
    notifyListeners();
  }



  String get receiverDebitCardNumber => _receiverDebitCardNumber ?? '';

  set receiverDebitCardNumber(String value) {
    _receiverDebitCardNumber = value;
    notifyListeners();
  }



  String get receiverSortCode => _receiverSortCode ?? '';

  set receiverSortCode(String value) {
    _receiverSortCode = value;
    notifyListeners();
  }



  String get receiverBankCode => _receiverBankCode ?? '';

  set receiverBankCode(String value) {
    _receiverBankCode = value;
    notifyListeners();
  }



  DateTime? get dateExpiryId => _dateExpiryId;

  set dateExpiryId(DateTime? value) {
    _dateExpiryId = value;
    notifyListeners();
  }



  bool get isIFSCCodeValid => _isIFSCCodeValid;

  set isIFSCCodeValid(bool value) {
    if (_isIFSCCodeValid == value) return;
    _isIFSCCodeValid = value;
    notifyListeners();
  }

  get isIBANValid => _isIBANValid;

  set isIBANValid(value) {
    if (_isIBANValid == value) return;
    _isIBANValid = value;
    notifyListeners();
  }

  get isBSBCodeValid => _isBSBCodeValid;

  set isBSBCodeValid(value) {
    if (_isBSBCodeValid == value) return;
    _isBSBCodeValid = value;
    notifyListeners();
  }

  get isSwiftCodeValid => _isSwiftCodeValid;

  set isSwiftCodeValid(value) {
    if (_isSwiftCodeValid == value) return;
    _isSwiftCodeValid = value;
    notifyListeners();
  }

  String get errorIFSCCode => _errorIFSCCode!;

  set errorIFSCCode(String value) {
    if (_errorIFSCCode == value) return;
    _errorIFSCCode = value;
    notifyListeners();
  }

  String get errorIBANCode => _errorIBANCode!;

  set errorIBANCode(String value) {
    if (_errorIBANCode == value) return;
    _errorIBANCode = value;
    notifyListeners();
  }

  String get errorBSBCode => _errorBSBCode!;

  set errorBSBCode(String value) {
    if (_errorBSBCode == value) return;
    _errorBSBCode = value;
    notifyListeners();
  }

  String get errorSwiftCode => _errorSwiftCode!;

  set errorSwiftCode(String value) {
    if (_errorSwiftCode == value) return;
    _errorSwiftCode = value;
    notifyListeners();
  }

  String get receiverSwiftCode => _receiverSwiftCode!;

  set receiverSwiftCode(String value) {
    if (_receiverSwiftCode == value) return;
    _receiverSwiftCode = value;
    notifyListeners();
  }


  String get receiverACHNumber => _receiverACHNumber!;

  set receiverACHNumber(String value) {
    if (_receiverACHNumber == value) return;
    _receiverACHNumber = value;
    notifyListeners();
  }

  String get receiverIBANCode => _receiverIBANCode!;

  set receiverIBANCode(String value) {
    if (_receiverIBANCode == value) return;
    _receiverIBANCode = value;
    notifyListeners();
  }

  String get receiverBSBCode => _receiverBSBCode!;

  set receiverBSBCode(String value) {
    if (_receiverBSBCode == value) return;
    _receiverBSBCode = value;
    notifyListeners();
  }

  String get receiverBranchCode => _receiverBranchCode ?? '';

  set receiverBranchCode(String value) {
    _receiverBranchCode = value;
    notifyListeners();
  }

  String get receiverFinancialInstitutionCode => _receiverFinancialInstitutionCode ?? '';

  set receiverFinancialInstitutionCode(String value) {
    _receiverFinancialInstitutionCode = value;
    notifyListeners();
  }

  String get receiverBranchTransitCode => _receiverBranchTransitCode ?? '';

  set receiverBranchTransitCode(String value) {
    _receiverBranchTransitCode = value;
    notifyListeners();
  }

  String get receiverIFSCCode => _receiverIFSCCode ?? '';

  set receiverIFSCCode(String value) {
    _receiverIFSCCode = value;
    notifyListeners();
  }



  String get receiverPayOutPartner => _receiverPayOutPartner ?? '';

  set receiverPayOutPartner(String value) {
    _receiverPayOutPartner = value;
    notifyListeners();
  }

  List get finalData => _finalData;

  set finalData(List value) {
    _finalData = value;
    notifyListeners();
  }



  int get number => _number;

  set number(int value) {
    _number = value;
    notifyListeners();
  }

  String get selectedCountry => _selectedCountry;

  set selectedCountry(String value) {
    _selectedCountry = value;
    notifyListeners();
  }

  String get selectedCurrency => _selectedCurrency;

  set selectedCurrency(String value) {
    _selectedCurrency = value;
    notifyListeners();
  }

  String get selectedCurrencyForAus => _selectedCurrencyForAus;

  set selectedCurrencyForAus(String value) {
    _selectedCurrencyForAus = value;
    notifyListeners();
  }

  bool get showLoadingIndicator => _showLoadingIndicator;

  set showLoadingIndicator(bool value) {
    _showLoadingIndicator = value;
    notifyListeners();
  }

  bool get isAddReceiver => _isAddReceiver;

  set isAddReceiver(bool value) {
    _isAddReceiver = value;
    notifyListeners();
  }

  bool get radio_Value => _radio_Value;

  set radio_Value(bool value) {
    _radio_Value = value;
    notifyListeners();
  }



  int get transferValue => _transferValue;

  set transferValue(int value) {
    _transferValue = value;
    notifyListeners();
  }



  int get countryID => _countryID;

  set countryID(int value) {
    _countryID = value;
    notifyListeners();
  }



  int get rowPerPage => _rowPerPage;

  int get radioValue => _radioValue;

  set radioValue(int value) {
    _radioValue = value;
    notifyListeners();
  }

  int get groupValue => _groupValue;

  set groupValue(int value) {
    _groupValue = value;
    notifyListeners();
  }



  String get countryData => country_;

  set countryData(String value) {
    country_ = value;
    notifyListeners();
  }

  TextEditingController get branchAddressController => _branchAddressController;

  set branchAddressController(TextEditingController value) {
    _branchAddressController.text = value.text;
    notifyListeners();
  }

  TextEditingController get branchNameController => _branchNameController;

  set branchNameController(TextEditingController value) {
    _branchNameController = value;
    notifyListeners();
  }

  TextEditingController get bankNameController => _bankNameController;

  set bankNameController(TextEditingController value) {
    _bankNameController = value;
    notifyListeners();
  }



  String get OTPErrorMessage => _OTPErrorMessage;

  set OTPErrorMessage(String value) {
    if(value == _OTPErrorMessage) return;
    _OTPErrorMessage = value;
    notifyListeners();
  }


}
