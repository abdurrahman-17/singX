import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:singx/core/data/remote/network/app_url.dart';
import 'package:singx/core/data/remote/network/method.dart';
import 'package:singx/core/data/remote/service/base/base_repository.dart';
import 'package:singx/core/models/request_response/rate_alert/CorridorIdListResponse.dart';
import 'package:singx/core/models/request_response/rate_alert/UpdateAlertRequest.dart';
import 'package:singx/core/models/request_response/rate_alert/alert_list_response.dart';
import 'package:singx/core/models/request_response/rate_alert/save_alert_request.dart';
import 'package:singx/main.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class RateAlertRepository extends BaseRepository {
  RateAlertRepository._internal();

  static final RateAlertRepository _singleInstance =
      RateAlertRepository._internal();

  factory RateAlertRepository() => _singleInstance;

  List<bool> _isChecked = [];
  List<AlertListResponse> _contentList = [];

  List<AlertListResponse> get contentList => _contentList;

  set contentList(List<AlertListResponse> value) {
    _contentList = value;
    notifyListeners();
  }

  List<CorridorIdListResponse> _corridorList = [];

  List<CorridorIdListResponse> get corridorList => _corridorList;

  set corridorList(List<CorridorIdListResponse> value) {
    _corridorList = value;
    notifyListeners();
  }

  List<bool> get isChecked => _isChecked;

  //api: saveAlert
  Future<int?> apiSaveAlert(SaveAlertRequest requestParams,
      BuildContext context, String currency, String msg) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.saveRateAlert + "$currency",
      body: requestParams.toJson(),
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response?.statusCode == HttpStatus.ok) {
      showMessageDialog(
          context, msg == "save" ? "Alert Saved" : "Alert Updated");
      return 1;
    }
    return 0;
  }

  //api: updateAlert
  Future<int?> apiUpdateAlert(UpdateAlertRequest requestParams,
      BuildContext context, String currency, String msg) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.updateRateAlert + "$currency",
      body: requestParams.toJson(),
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response?.statusCode == HttpStatus.ok) {
      showMessageDialog(context, "Alert Updated");
      return 1;
    }
    return 0;
  }

  //api: deleteAlert
  Future<int?> apiDeleteAlert(BuildContext context, String id) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.deleteRateAlert + "$id?currency=SGD",
      headers: buildDefaultHeaderWithTokenXML(userToken!),
    );

    if (response?.statusCode == HttpStatus.ok) {
      showMessageDialog(context, "Alert Deleted");
      return 1;
    } else if (response?.statusCode == HttpStatus.unauthorized) {
      Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
      SharedPreferencesMobileWeb.instance.removeAll();
    } else if (response?.statusCode == HttpStatus.notFound) {
      showMessageDialog(context, AppConstants.somethingWentWrongMessage);
    } else if (response?.statusCode == HttpStatus.forbidden) {
      MyApp.navigatorKey.currentState!.maybePop();
      await SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        Navigator.pushNamedAndRemoveUntil(
            context, accessDeniedRoute, (route) => false);
      });
    } else if (response?.statusCode == HttpStatus.unprocessableEntity) {
      showMessageDialog(context, AppConstants.somethingWentWrongMessage);
    } else if (response?.statusCode == HttpStatus.badRequest) {
      showMessageDialog(context, AppConstants.somethingWentWrongMessage);
    } else {
      return null;
    }
  }

//api: alertList
  Future<List<AlertListResponse>> alertList(
      BuildContext context, String currency) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.saveRateAlert + "$currency",
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      contentList = (response.data as List)
          .map((x) => AlertListResponse.fromJson(x))
          .toList();

      _isChecked = List.generate(contentList.length, (index) => false);
      notifyListeners();
      return contentList;
    } else if (response.statusCode == HttpStatus.unauthorized) {
      Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
      SharedPreferencesMobileWeb.instance.removeAll();
      return contentList;
    } else if (response.statusCode == HttpStatus.notFound) {
      return contentList;
    } else if (response.statusCode == HttpStatus.forbidden) {
      await SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        Navigator.pushNamedAndRemoveUntil(
            context, accessDeniedRoute, (route) => false);
      });

      return contentList;
    } else if (response.statusCode == HttpStatus.unprocessableEntity) {
      return contentList;
    } else if (response.statusCode == HttpStatus.badRequest) {
      return contentList;
    } else {
      return contentList;
    }
  }

  //api: corridorIDList
  Future<List<CorridorIdListResponse>> getCorridorIDList(
      BuildContext context, String currency) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.getCorridorID + "$currency",
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      corridorList = (response.data as List)
          .map((x) => CorridorIdListResponse.fromJson(x))
          .toList();

      notifyListeners();
      return corridorList;
    } else if (response.statusCode == HttpStatus.unauthorized) {
      Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
      SharedPreferencesMobileWeb.instance.removeAll();
      return corridorList;
    } else if (response.statusCode == HttpStatus.notFound) {
      return corridorList;
    } else if (response.statusCode == HttpStatus.forbidden) {
      await SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        Navigator.pushNamedAndRemoveUntil(
            context, accessDeniedRoute, (route) => false);
      });

      return corridorList;
    } else if (response.statusCode == HttpStatus.unprocessableEntity) {
      return corridorList;
    } else if (response.statusCode == HttpStatus.badRequest) {
      return corridorList;
    } else {
      return corridorList;
    }
  }
}
