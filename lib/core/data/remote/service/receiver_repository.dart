import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:singx/core/data/remote/network/app_url.dart';
import 'package:singx/core/data/remote/network/method.dart';
import 'package:singx/core/data/remote/service/base/base_repository.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/relationship_dropdown/relationship_response_aus.dart';
import 'package:singx/core/models/request_response/australia/manage_receiver/all_countries_list_response.dart';
import 'package:singx/core/models/request_response/australia/manage_receiver/europe_countries_list_response.dart';
import 'package:singx/core/models/request_response/australia/manage_receiver/nationality_list_response.dart';
import 'package:singx/core/models/request_response/australia/manage_receiver/receiver_country_list_response.dart';
import 'package:singx/core/models/request_response/australia/manage_receiver/receiver_list_response.dart';
import 'package:singx/core/models/request_response/australia/manage_receiver/state_list_response.dart';
import 'package:singx/core/models/request_response/australia/manage_sender/bank_detail_response.dart';
import 'package:singx/core/models/request_response/australia/manage_sender/branch_detail_response.dart';
import 'package:singx/core/models/request_response/common_response_aus.dart';
import 'package:singx/core/models/request_response/error_response.dart';
import 'package:singx/core/models/request_response/manage_receiver/AddReceiverResponse.dart';
import 'package:singx/core/models/request_response/manage_receiver/BankListByBranchCodeResponse.dart';
import 'package:singx/core/models/request_response/manage_receiver/BankListByCountryIdResponse.dart';
import 'package:singx/core/models/request_response/manage_receiver/BranchListByBankIdResponse.dart';
import 'package:singx/core/models/request_response/manage_receiver/branch_code_validate_response.dart';
import 'package:singx/core/models/request_response/manage_receiver/ifsc_details_response.dart';
import 'package:singx/core/models/request_response/manage_receiver/receiver_country_response.dart';
import 'package:singx/core/models/request_response/manage_receiver/receiver_data_by_id_response.dart';
import 'package:singx/core/models/request_response/manage_receiver/receiver_fields_response.dart';
import 'package:singx/core/models/request_response/manage_receiver/receiver_list_response.dart';
import 'package:singx/core/models/request_response/manage_receiver/save_receiver_account_request.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class ReceiverRepository extends BaseRepository {
  ReceiverRepository._internal();

  static final ReceiverRepository _singleInstance =
      ReceiverRepository._internal();

  factory ReceiverRepository() => _singleInstance;

  List<Content> _contentList = [];

  List<Content> get contentList => _contentList;

  set contentList(List<Content> value) {
    _contentList = value;
  }

  List<ReceiverListAusResponse> _contentAusList = [];

  List<ReceiverListAusResponse> get contentAusList => _contentAusList;

  set contentAusList(List<ReceiverListAusResponse> value) {
    _contentAusList = value;
  }

  List<ReceiverListAusResponse> _contentAusByIDList = [];

  List<ReceiverListAusResponse> get contentAusByIDList => _contentAusByIDList;

  set contentAusByIDList(List<ReceiverListAusResponse> value) {
    _contentAusByIDList = value;
  }

  int _rowPerPage = 10;

  int get rowPerPage => _rowPerPage;

  set rowPerPage(int value) {
    _rowPerPage = value;
  }

  List<ReceiverFieldsResponse> receiverDynamicFields = [];
  Map<String, List<ReceiverCountryResponse>> _receiverCountryFields = {};

  Map<String, List<ReceiverCountryResponse>> get receiverCountryFields =>
      _receiverCountryFields;

  set receiverCountryFields(Map<String, List<ReceiverCountryResponse>> value) {
    _receiverCountryFields = value;
  }

  int _pageCount = 0;

  int get pageCount => _pageCount;

  set pageCount(int value) {
    _pageCount = value;
    notifyListeners();
  }

  int _contentCount = 0;

  int get contentCount => _contentCount;

  set contentCount(int value) {
    _contentCount = value;
    notifyListeners();
  }

  //api: ReceiverList
  Future<Object?> receiverList(BuildContext context, url) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathReceiverList + url,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      ReceiverListResponse receiverListResponse =
          ReceiverListResponse.fromJson(response.data);
      pageCount = receiverListResponse.totalPages!;
      contentList = receiverListResponse.content!;
      contentCount = contentList.length;
      return receiverListResponse;
    } else {
      return ReceiverListResponse.fromJson(response.data);
    }
  }

  //api: ReceiverListAustralia
  Future<Object?> receiverAusList(BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    int? contactId =
        await SharedPreferencesMobileWeb.instance.getContactId(apiContactId);
    Response response = await networkProvider.call(
        method: Method.POST,
        body: jsonEncode({"contactId": contactId}),
        pathUrl: AppUrl.pathReceiverListAus,
        headers: buildDefaultHeaderWithToken(userToken!),
        australia: true);

    if (response.statusCode == HttpStatus.ok) {
      pageCount = 1;
      contentAusList = (response.data as List)
          .map((x) => ReceiverListAusResponse.fromJson(x))
          .toList();
      contentCount = rowPerPage;

      return contentAusList;
    } else {
      return contentAusList;
    }
  }

  //api: ReceiverListAustralia
  Future<Object?> receiverCountryAusList(BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    int? contactId =
        await SharedPreferencesMobileWeb.instance.getContactId(apiContactId);
    Response response = await networkProvider.call(
        method: Method.POST,
        pathUrl: AppUrl.pathReceiverCountryListAus,
        headers: buildDefaultHeaderWithToken(userToken!),
        australia: true);

    if (response.statusCode == HttpStatus.ok) {
      return (response.data as List)
          .map((x) => ReceiverCountryListAusResponse.fromJson(x))
          .toList();
    } else {
      return [];
    }
  }

  //api: ReceiverNationalityListAustralia
  Future<Object?> receiverNationalityAusList(BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
        method: Method.POST,
        pathUrl: AppUrl.pathReceiverNationalityListAus,
        headers: buildDefaultHeaderWithToken(userToken!),
        australia: true);

    if (response.statusCode == HttpStatus.ok) {
      return (response.data as List)
          .map((x) => NationalityAusListResponse.fromJson(x))
          .toList();
    } else {
      return [];
    }
  }

  //api: ReceiverEuropeCountryListAustralia
  Future<Object?> receiverEuropeCountryAusList(BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
        method: Method.POST,
        pathUrl: AppUrl.pathEuropeCountriesListAus,
        headers: buildDefaultHeaderWithToken(userToken!),
        australia: true);

    if (response.statusCode == HttpStatus.ok) {
      return (response.data as List)
          .map((x) => EuropeCountriesListResponse.fromJson(x))
          .toList();
    } else {
      return [];
    }
  }

  //api: ReceiverEuropeCountryListAustralia
  Future<Object?> receiverAllCountryAusList(
      BuildContext context, bool swift) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
        method: Method.POST,
        pathUrl: swift
            ? AppUrl.pathSwiftCountriesListAus
            : AppUrl.pathAllCountriesListAus,
        headers: buildDefaultHeaderWithToken(userToken!),
        australia: true);

    if (response.statusCode == HttpStatus.ok) {
      return (response.data as List)
          .map((x) => AllCountriesListResponse.fromJson(x))
          .toList();
    } else {
      return [];
    }
  }

  //api: ReceiverEuropeCountryListAustralia
  Future<Object?> getBankNameAusList(BuildContext context, countryCode) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
        method: Method.GET,
        pathUrl: AppUrl.pathSenderBanksDropDown + '?countryId=$countryCode',
        headers: buildDefaultHeaderWithToken(userToken!),
        australia: true);

    if (response.statusCode == HttpStatus.ok) {
      return (response.data as List)
          .map((x) => BankDetailResponse.fromJson(x))
          .toList();
    } else {
      return [];
    }
  }

  //api: ReceiverEuropeCountryListAustralia
  Future<Object?> getStateAusList(BuildContext context, countryID) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
        method: Method.POST,
        body: jsonEncode({"countryId": countryID}),
        pathUrl: AppUrl.pathStateListAus,
        headers: buildDefaultHeaderWithToken(userToken!),
        australia: true);

    if (response.statusCode == HttpStatus.ok) {
      return (response.data as List)
          .map((x) => StateListResponse.fromJson(x))
          .toList();
    } else {
      return [];
    }
  }

  //api: DeleteReceiverAccount
  Future<bool?> deleteReceiverAus(
      BuildContext context, receiverAccountID) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
        method: Method.POST,
        body: jsonEncode({"receiverAccountId": receiverAccountID}),
        pathUrl: AppUrl.pathDeleteReceiver,
        headers: buildDefaultHeaderWithToken(userToken!),
        australia: true);
    if (response.statusCode == HttpStatus.ok) {
      return true;
    } else {
      return false;
    }
  }

  //api: DeleteReceiverAccount SG & HK
  Future<bool?> deleteReceiverSG_HK(
      BuildContext context, receiverAccountID) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathDeleteReceiverSG_HK + "$receiverAccountID/delete",
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      return true;
    } else {
      return false;
    }
  }

  Future<AddReceiverResponse> addReceiverSG(BuildContext context, map) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      body: map,
      pathUrl: AppUrl.pathAddReceiver,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      final result = json.decode(response.toString());

      AddReceiverResponse addReceiverResponse =
          addReceiverResponseFromJson(response.toString());
      return addReceiverResponse;
    } else {
      return addReceiverResponseFromJson(response.toString());
    }
  }

  //api: DeleteReceiverAccount
  Future<bool?> saveReceiverAccount(
    BuildContext context,
    SaveReceiverAccountRequest requestParams,
  ) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
        method: Method.POST,
        body: requestParams.toJson(),
        pathUrl: AppUrl.pathSaveReceiverAccount,
        headers: buildDefaultHeaderWithToken(userToken!),
        australia: true);

    if (response.statusCode == HttpStatus.ok) {
      return true;
    } else {
      return false;
    }
  }

  //api: ReceiverEuropeCountryListAustralia
  Future<Object?> getRelationshipDropdownAusList(BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathRelationShipAus,
      headers: buildDefaultHeaderWithToken(userToken!),
      australia: true,
    );

    if (response.statusCode == HttpStatus.ok) {
      return (response.data as List)
          .map((x) => RelationShipAustraliaResponse.fromJson(x))
          .toList();
    } else {
      return [];
    }
  }

  //api: ReceiverCountry
  Future<Object?> receiverCountry(BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathReceiverCountry,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      final receiverCountryResponse =
          ReceiverCountryResponseFromJson(response.toString());

      receiverCountryFields = receiverCountryResponse;
      notifyListeners();
      return receiverCountryResponse;
    } else {
      return ReceiverCountryResponse.fromJson(response.data);
    }

    return null;
  }

  //api: IFSCCodeDetails
  Future<IfscDetailsResponse> getIFSCCode(
      BuildContext context, String IFSC) async {
    String? userToken;
    final input = {"ifscCode": IFSC};
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.getIFSCData,
      body: jsonEncode(input),
      headers: buildDefaultHeaderWithToken(userToken!),
      australia: true,
    );

    if (response.statusCode == HttpStatus.ok) {
      IfscDetailsResponse ifscDetailsResponse =
          ifscDetailsResponseFromJson(response.toString());
      return ifscDetailsResponse;
    } else {
      return IfscDetailsResponse.fromJson(response.data);
    }

    return IfscDetailsResponse.fromJson(response.data);
  }

  //api: IFSCCodeDetails
  Future<IfscDetailsResponse> getFindByRoutingNumber(
      BuildContext context, String code) async {
    String? userToken;
    final input = {"code": code};
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathFindByRoutingNumber,
      body: jsonEncode(input),
      headers: buildDefaultHeaderWithToken(userToken!),
      australia: true,
    );

    if (response.statusCode == HttpStatus.ok) {
      IfscDetailsResponse ifscDetailsResponse =
          ifscDetailsResponseFromJson(response.toString());
      return ifscDetailsResponse;
    } else {
      return IfscDetailsResponse.fromJson(response.data);
    }
  }

  //api: SwiftCodeDetails
  Future<IfscDetailsResponse> getSwiftCodeDetails(
      BuildContext context, String swiftCode, String countryId) async {
    String? userToken;
    final input = {"swiftCode": swiftCode, "countryId": countryId};
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.findByUSSSwiftCode,
      body: jsonEncode(input),
      headers: buildDefaultHeaderWithToken(userToken!),
      australia: true,
    );

    if (response.statusCode == HttpStatus.ok) {
      IfscDetailsResponse ifscDetailsResponse =
          ifscDetailsResponseFromJson(response.toString());
      return ifscDetailsResponse;
    } else if (response.statusCode == HttpStatus.unauthorized) {
      SharedPreferencesMobileWeb.instance.removeParticularKey(apiToken);
      Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
      SharedPreferencesMobileWeb.instance.removeAll();
      return IfscDetailsResponse.fromJson(response.data);
    } else {
      return IfscDetailsResponse.fromJson(response.data);
    }
  }

  //api: SwiftCodeDetails
  Future<IfscDetailsResponse> getHkCodeDetails(
      BuildContext context, String bankCode, String branchCode) async {
    String? userToken;
    final input = {"bankCode": bankCode, "branchCode": branchCode};
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.findByHKBankBranch,
      body: jsonEncode(input),
      headers: buildDefaultHeaderWithToken(userToken!),
      australia: true,
    );

    if (response.statusCode == HttpStatus.ok) {
      IfscDetailsResponse hkFindBankBranch =
          ifscDetailsResponseFromJson(response.toString());
      return hkFindBankBranch;
    } else {
      return IfscDetailsResponse.fromJson(response.data);
    }
  }

//api: getCADCodeDetails
  Future<IfscDetailsResponse> getCADCodeDetails(
      BuildContext context, String swiftCode, String branchCode) async {
    String? userToken;
    final input = {"swiftCode": swiftCode, "branchCode": branchCode};
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.findByCADBankBranch,
      body: jsonEncode(input),
      headers: buildDefaultHeaderWithToken(userToken!),
      australia: true,
    );

    if (response.statusCode == HttpStatus.ok) {
      IfscDetailsResponse hkFindBankBranch =
          ifscDetailsResponseFromJson(response.toString());
      return hkFindBankBranch;
    } else {
      return IfscDetailsResponse.fromJson(response.data);
    }
  }

  //api: getCADCodeDetails
  Future<BankListByBranchCodeResponse> getBankDetailByBranchCode(
      BuildContext context,
      String country,
      String currency,
      String branchCode) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathReceiverBankList +
          "/$country/$currency/branch/$branchCode",
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      BankListByBranchCodeResponse hkFindBankBranch =
          bankListByBranchCodeResponseFromJson(response.toString());
      return hkFindBankBranch;
    } else {
      return BankListByBranchCodeResponse.fromJson(response.data);
    }
  }

  Future<BranchListByBankIdResponse> getBranchListByBranchCode(
      BuildContext context, String bankID) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathReceiverBankList + "/$bankID/branch?size=1000",
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      BranchListByBankIdResponse hkFindBankBranch =
          branchListByBankIdResponseFromJson(response.toString());
      return hkFindBankBranch;
    } else {
      return BranchListByBankIdResponse.fromJson(response.data);
    }
  }

  Future<BankListByCountryIdResponse> getBankListByCountryID(
      BuildContext context,
      String country,
      String currency,
      String page) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathReceiverBankList + "/$country/$currency?page=$page",
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      BankListByCountryIdResponse hkFindBankBranch =
          bankListByCountryIdResponseFromJson(response.toString());
      return hkFindBankBranch;
    } else {
      return BankListByCountryIdResponse.fromJson(response.data);
    }
  }

  //api: SortCodeDetails
  Future<IfscDetailsResponse> getSortCode(
      BuildContext context, String sortCode) async {
    String? userToken;
    final input = {"code": sortCode};
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.getSortCodeData,
      body: jsonEncode(input),
      headers: buildDefaultHeaderWithToken(userToken!),
      australia: true,
    );

    if (response.statusCode == HttpStatus.ok) {
      IfscDetailsResponse ifscDetailsResponse =
          ifscDetailsResponseFromJson(response.toString());
      return ifscDetailsResponse;
    } else {
      return IfscDetailsResponse.fromJson(response.data);
    }
  }

  //api: getReceiverDetailByCountryID
  Future<List<ReceiverListAusResponse>> getReceiverDetailByCountryID(
      BuildContext context, int countryID) async {
    String? userToken;
    int? contactID;

    await SharedPreferencesMobileWeb.instance
        .getContactId(apiContactId)
        .then((value) {
      contactID = value;
    });

    final input = {"contactId": contactID, "countryId": countryID};
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathReceiverDetailsByCountryID,
      body: jsonEncode(input),
      headers: buildDefaultHeaderWithToken(userToken!),
      australia: true,
    );

    if (response.statusCode == HttpStatus.ok) {
      return (response.data as List)
          .map((x) => ReceiverListAusResponse.fromJson(x))
          .toList();
    } else {
      return [];
    }
  }

  //api: getBankNameByID
  Future<CommonResponseAus> getBankNameByID(
      BuildContext context, int bankId) async {
    String? userToken;
    final input = {"bankId": bankId};
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.getBankNameByID,
      body: jsonEncode(input),
      headers: buildDefaultHeaderWithToken(userToken!),
      australia: true,
    );

    if (response.statusCode == HttpStatus.ok) {
      CommonResponseAus commonResponse =
          CommonResponseAusFromJson(response.toString());
      return commonResponse;
    } else {
      return CommonResponseAus.fromJson(response.data);
    }
  }

  //api: ReceiverFields
  Future<List<ReceiverFieldsResponse>> receiverFields(
      BuildContext context, country, currency) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathReceiverFields + '$country/fields/$currency',
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      receiverDynamicFields = (response.data as List)
          .map((x) => ReceiverFieldsResponse.fromJson(x))
          .toList();

      notifyListeners();

      return receiverDynamicFields;
    } else {
      return receiverDynamicFields;
    }
  }

  //api: branchDetailsBybankID
  Future<List<BranchDetailResponse>> getBranchDetailsByBankID(
      BuildContext context, id) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
        method: Method.GET,
        pathUrl: AppUrl.pathSenderBankId + '?bankId=$id',
        headers: buildDefaultHeaderWithToken(userToken!),
        australia: true);

    if (response.statusCode == HttpStatus.ok) {
      List<BranchDetailResponse> receiverResponse = <BranchDetailResponse>[];

      receiverResponse = (response.data as List)
          .map((x) => BranchDetailResponse.fromJson(x))
          .toList();
      return receiverResponse;
    } else {
      return [];
    }
  }

  //api: receiverDataById
  Future<Object?> receiverDataById(BuildContext context, id) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathReceiverDataById + id,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      ReceiverDataByIdResponse receiverDataByIdResponse =
          ReceiverDataByIdResponse.fromJson(response.data);
      return receiverDataByIdResponse;
    } else {
      return ReceiverDataByIdResponse.fromJson(response.data);
    }
  }

  //api: receiverBranchCodeValidation
  Future<Object> getBranchCodeValidation(
      BuildContext context,
      String country,
      String currency,
      String type,String code) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathBranchCodeValidation + "$country/$currency/validate/$type/$code",
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      BranchCodeValidationResponse branchCodeResponse =
      branchCodeValidationResponseFromJson(response.toString());
      return branchCodeResponse;
    } else {
      return ErrorString.fromJson(response.data);
    }
  }
}
