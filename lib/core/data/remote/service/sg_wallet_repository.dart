import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:singx/core/data/remote/network/app_url.dart';
import 'package:singx/core/data/remote/network/method.dart';
import 'package:singx/core/data/remote/service/base/base_repository.dart';
import 'package:singx/core/models/request_response/common_response.dart';
import 'package:singx/core/models/request_response/sg_wallet/sg_wallet_check_limit.dart';
import 'package:singx/core/models/request_response/sg_wallet/sg_wallet_filter_options.dart';
import 'package:singx/core/models/request_response/sg_wallet/sg_wallet_response.dart';
import 'package:singx/core/models/request_response/sg_wallet/sg_wallet_transaction_history.dart';
import 'package:singx/core/models/request_response/sg_wallet/sg_wallet_transaction_history_request.dart';
import 'package:singx/core/models/request_response/sg_wallet/wallet_debit_request.dart';
import 'package:singx/core/models/request_response/sg_wallet/wallet_top_up_request.dart';
import 'package:singx/core/models/request_response/sg_wallet/wallet_top_up_response.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class SGWalletRepository extends BaseRepository {
  SGWalletRepository._internal();

  static final SGWalletRepository _singleInstance =
      SGWalletRepository._internal();

  factory SGWalletRepository() => _singleInstance;

  //api: SG Wallet Balance
  Future<Object?> SGWalletBalance(BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathSGWalletBal,
      SGbp: true,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      SgWalletBalance sgWalletBalance = SgWalletBalance.fromJson(response.data);
      return sgWalletBalance;
    } else {
      return SgWalletBalance.fromJson(response.data);
    }
  }

  //api: SG Wallet History
  Future<Object?> SGWalletHistory(
      ActivitiesWalletRequest activitiesWalletRequest) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathSGWalletHistory,
      SGbp: true,
      body: jsonEncode(activitiesWalletRequest),
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      return sgWalletTransactionHistoryFromJson(jsonEncode(response.data));
    } else {
      return sgWalletTransactionHistoryFromJson(jsonEncode(response.data));
    }
  }

  //api: SG Wallet TopUp Limit Check
  Future<Object?> SGWalletTopUpLimitCheck(
      BuildContext context, String amount) async {
    String? userToken;
    apiLoader(context);
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathTopUpLimitCheck + amount,
      SGbp: true,
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    Navigator.pop(context);
    if (response.statusCode == HttpStatus.ok) {
      SgWalletTopUpLimitCheck sgWalletTopUpLimitCheck =
          SgWalletTopUpLimitCheck.fromJson(response.data);

      return sgWalletTopUpLimitCheck;
    } else {
      return SgWalletTopUpLimitCheck.fromJson(response.data);
    }
  }

  //api: SG Wallet TopUp Limit Check
  Future<WalletTopUpResponse> SGWalletTopUpWallet(
      BuildContext context, WalletTopUpRequest walletTopUpRequest) async {
    String? userToken;
    apiLoader(context);
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathTopUpWallet,
      body: jsonEncode(walletTopUpRequest),
      SGbp: true,
      headers: buildDefaultHeaderWithToken(userToken!),
    );
Navigator.pop(context);
    if (response.statusCode == HttpStatus.ok) {
      WalletTopUpResponse walletTopUpResponse =
          walletTopUpResponseFromJson(jsonEncode(response.data));

      return walletTopUpResponse;
    } else {
      return walletTopUpResponseFromJson(response.data);
    }
  }

  //api: SG Wallet Debit
  Future<Object> SGWalletDebit(
      BuildContext context, WalletDebitRequest walletDebitRequest) async {
    String? userToken;
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathWalletDebit,
      body: jsonEncode(walletDebitRequest),
      SGbp: true,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      CommonResponse debitResponse = CommonResponse.fromJson(response.data);

      return debitResponse;
    } else {
      return walletTopUpResponseFromJson(response.data);
    }
  }

  //api: SG Wallet Filter
  Future<SGWalletFilterResponse> SGWalletFilterList() async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathSGWalletFilter,
      SGbp: true,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      SGWalletFilterResponse sgWalletFilterResponse =
          SGWalletFilterResponse.fromJson(response.data);
      return sgWalletFilterResponse;
    } else {
      return SGWalletFilterResponse.fromJson(response.data);
    }
  }
}
