import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:singx/core/data/remote/network/app_url.dart';
import 'package:singx/core/data/remote/network/method.dart';
import 'package:singx/core/data/remote/service/base/base_repository.dart';
import 'package:singx/core/models/request_response/australia/manage_sender/branch_detail_response.dart';
import 'package:singx/core/models/request_response/australia/manage_sender/save_sender_request.dart';
import 'package:singx/core/models/request_response/australia/manage_sender/sender_list_response_aus.dart';
import 'package:singx/core/models/request_response/common_response_aus.dart';
import 'package:singx/core/models/request_response/manage_sender/AddSenderAccountRequest.dart';
import 'package:singx/core/models/request_response/manage_sender/sender_fileds_response.dart';
import 'package:singx/core/models/request_response/manage_sender/sender_list_response.dart';
import 'package:singx/main.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

import '../../../models/request_response/australia/manage_sender/bank_detail_response.dart';

class SenderRepository extends BaseRepository {
  SenderRepository._internal();

  static final SenderRepository _singleInstance = SenderRepository._internal();

  factory SenderRepository() => _singleInstance;

  List<Content> _contentList = [];
  List _contentListAus = [];
  List<String> _bankNames = [];
  List<String> _bankId = [];
  List<String> _branchId = [];
  List<String> senderBankAccount = [];
  List<BankDetailResponse> senderResponse = [];

  List<String> get branchId => _branchId;

  set branchId(List<String> value) {
    _branchId = value;
  }

  List<String> get bankId => _bankId;

  set bankId(List<String> value) {
    _bankId = value;
    notifyListeners();
  }

  int _rowPerPage = 5;

  int get rowPerPage => _rowPerPage;
  int _contentCount = 0;

  int get contentCount => _contentCount;

  set contentCount(int value) {
    _contentCount = value;
    notifyListeners();
  }

  List<String> get bankNames => _bankNames;

  set bankNames(List<String> value) {
    _bankNames = value;
    notifyListeners();
  }

  List get contentListAus => _contentListAus;

  set contentListAus(List value) {
    _contentListAus = value;
    notifyListeners();
  }

  List<Content> get contentList => _contentList;

  set contentList(List<Content> value) {
    _contentList = value;
  }

  List<dynamic> senderDynamicFields = [];
  int pageCount = 0;

  var senderListResponseCode;

  //api: SenderList
  Future<Object?> senderList(BuildContext context, url) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathSenderList + url,
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    senderListResponseCode = response.statusCode;

    if (response.statusCode == HttpStatus.ok) {
      SenderListResponse senderListResponse =
          SenderListResponse.fromJson(response.data);
      pageCount = senderListResponse.totalPages!;
      contentList = senderListResponse.content!;
      contentCount = contentList.length;
      return senderListResponse;
    } else {
      return SenderListResponse.fromJson(response.data);
    }
  }

  //api: SenderFields
  Future<List<dynamic>> senderFields(
      {BuildContext? context, String? currency}) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathSenderFields + currency!,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      List<dynamic> senderResponse = <dynamic>[];
      senderResponse =
          response.data.map((i) => SenderFieldsResponse.fromJson(i)).toList();

      senderDynamicFields = senderResponse;

      return senderDynamicFields;
    } else {
      return senderDynamicFields;
    }
  }

  //api: SenderListAustralia
  Future<Object?> senderListAus(BuildContext context, contactId) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
        method: Method.GET,
        pathUrl: AppUrl.pathSenderListAus + '?contactId=$contactId',
        headers: buildDefaultHeaderWithToken(userToken!),
        australia: true);

    senderListResponseCode = response.statusCode;

    if (response.statusCode == HttpStatus.ok) {
      contentListAus = senderListResponseAusFromJson(jsonEncode(response.data));
      contentCount = rowPerPage;

      return contentListAus;
    } else {
      return [];
    }
  }

  //api: SenderBankNamesDropdown
  Future<Object?> senderBankNames(BuildContext context, countryCode) async {
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
      senderResponse = BankDetailResponseFromJson(jsonEncode(response.data));
      bankNames.clear();
      senderResponse.forEach((element) {
        bankNames.add(element.bankName!);
        bankId.add(element.bankId.toString());
      });

      return bankNames;
    } else {
      return [];
    }
  }

  //api: SenderBankId
  Future<Object?> senderBankId(BuildContext context, id) async {
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
      List<BranchDetailResponse> detailResponse = [];

      detailResponse = branchDetailResponseFromJson(jsonEncode(response.data));
      detailResponse.forEach((element) {
        branchId.add(element.branchId.toString());
      });

      return branchId;
    } else {
      return BranchDetailResponse.fromJson(response.data);
    }
  }

  //api: SenderFieldSave
  Future<Object?> senderFieldSave(SaveSenderRequest requestParams, BuildContext context, {bool? isSenderPopUpEnabled,bool? isWalletPopUpEnabled}) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
        method: Method.POST,
        pathUrl: AppUrl.pathSenderFieldSave,
        body: jsonEncode(requestParams.toJson()),
        headers: buildDefaultHeaderWithToken(userToken!),
        australia: true);

    if (response.statusCode == HttpStatus.ok) {
      if(isSenderPopUpEnabled!) {

        Navigator.pushNamed(context,fundTransferSelectAccountRoute );
      } else if(isWalletPopUpEnabled!) {
        MyApp.navigatorKey.currentState!.maybePop();
        MyApp.navigatorKey.currentState!.maybePop();
      } else
        Navigator.pushNamed(context,manageSenderRoute );

    }else {
      return CommonResponseAus.fromJson(json.decode(response.data));
    }
  }

  Future<Object> addSenderSG(
      BuildContext context, AddSenderAccountRequest requestParams,
      {bool? isSenderPopUpEnabled, bool? isWalletPopUpEnabled}) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      body: requestParams.toJson(),
      pathUrl: AppUrl.pathAddSender,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      final result = json.decode(response.toString());
      if (result['success'] == false) {
        return response;
      } else {
        showMessageDialog(context, "Sender added successfully",
            onPressed: () async {
          await SharedPreferencesMobileWeb.instance
              .getCountry(country)
              .then((value) async {
            if (isSenderPopUpEnabled!) {
              Navigator.pushNamed(context, fundTransferSelectAccountRoute);
            } else if (isWalletPopUpEnabled!) {
              MyApp.navigatorKey.currentState!.pop();
              MyApp.navigatorKey.currentState!.pop();
            } else
              Navigator.pushNamed(context, manageSenderRoute);
          });
        });
      }
      return true;
    } else {
      return false;
    }
  }
}
