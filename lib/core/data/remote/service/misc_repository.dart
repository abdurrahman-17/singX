import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:singx/core/data/remote/network/app_url.dart';
import 'package:singx/core/data/remote/network/method.dart';
import 'package:singx/core/models/request_response/dashboard_notification/dashboard_notification_response.dart';
import 'package:singx/core/models/request_response/error_response.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';
import 'base/base_repository.dart';

class MiscRepository extends BaseRepository {
  MiscRepository._internal();

  static final MiscRepository _singleInstance = MiscRepository._internal();

  factory MiscRepository() => _singleInstance;

  String? userToken;
  String loginErrorMessage = "";
  List<DashboardNotificationResponse> _notificationData = [];

  List<DashboardNotificationResponse> get notificationData => _notificationData;

  set notificationData(List<DashboardNotificationResponse> value) {
    if (value == _notificationData) return;
    _notificationData = value;
    notifyListeners();
  }

  String get ErrorMessageGet => loginErrorMessage;

  set ErrorMessageGet(String value) {
    if (value == loginErrorMessage) return;
    loginErrorMessage = value;
    notifyListeners();
  }

  //api: Dashboard Notification
  Future<Object?> apiDashboardNotification(BuildContext context) async {
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathDashboardNotification,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      var dashboardNotificationResponse =
          dashboardNotificationResponseFromJson(jsonEncode(response.data));

      notificationData.clear();
      notificationData.addAll(dashboardNotificationResponse);

      return dashboardNotificationResponse;
    } else {
      ErrorString errorString = ErrorString.fromJson(response.data);
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }
}
