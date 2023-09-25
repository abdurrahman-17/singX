import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:singx/core/data/remote/network/app_url.dart';
import 'package:singx/core/data/remote/network/method.dart';
import 'package:singx/core/data/remote/service/base/base_repository.dart';
import 'package:singx/core/models/request_response/australia/personal_details/DropdownValueResponse.dart';
import 'package:singx/core/models/request_response/australia/personal_details/SaveCustomerRequest.dart';
import 'package:singx/core/models/request_response/australia/personal_details/SaveCustomerResponse.dart';
import 'package:singx/core/models/request_response/australia/personal_details/searchAddressDetailsResponse.dart';
import 'package:singx/core/models/request_response/australia/personal_details/search_address_response.dart';
import 'package:singx/core/models/request_response/common_response.dart';
import 'package:singx/core/models/request_response/hongkong/personal_details/SaveAdditionalDetailRequestHk.dart';
import 'package:singx/core/models/request_response/hongkong/personal_details/SaveCustomerRequestHk.dart';
import 'package:singx/core/models/request_response/refresh_token/refresh_token_response.dart';
import 'package:singx/core/models/request_response/register/get_address_response.dart';
import 'package:singx/core/notifier/register_notifier.dart';
import 'package:singx/main.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class AuthRepositoryAus extends BaseRepository {
  AuthRepositoryAus._internal();

  static final AuthRepositoryAus _singleInstance =
      AuthRepositoryAus._internal();

  factory AuthRepositoryAus() => _singleInstance;

  //api: Logout
  Future apiLogout(context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    apiLoader(context);
    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathLogoutAus,
      australia: true,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      SharedPreferencesMobileWeb.instance.removeParticularKey(apiToken);
      Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
    } else if (response.statusCode == HttpStatus.unauthorized) {
      SharedPreferencesMobileWeb.instance.removeParticularKey(apiToken);
      Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
      SharedPreferencesMobileWeb.instance.removeAll();
      return RefreshTokenResponse.fromJson(response.data);
    } else if (response.statusCode == HttpStatus.forbidden) {
      await SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        Navigator.pushNamedAndRemoveUntil(
            context, accessDeniedRoute, (route) => false);
      });

      return RefreshTokenResponse.fromJson(response.data);
    } else if (response.statusCode == HttpStatus.notFound) {
      MyApp.navigatorKey.currentState!.maybePop();
      return RefreshTokenResponse.fromJson(response.data);
    } else if (response.statusCode == HttpStatus.unprocessableEntity) {
      MyApp.navigatorKey.currentState!.maybePop();
      return RefreshTokenResponse.fromJson(response.data);
    } else if (response.statusCode == HttpStatus.badRequest) {
      MyApp.navigatorKey.currentState!.maybePop();
      return RefreshTokenResponse.fromJson(response.data);
    } else {
      return null;
    }
  }

  //api: getDropdownValue
  Future<DropdownValueResponse> getDropdownValue(BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.getAusDropdownValue,
      headers: buildDefaultHeaderWithToken(userToken!),
      australia: true,
    );

    if (response.statusCode == HttpStatus.ok) {
      final dropdownValueResponse =
          dropdownValueResponseFromJson(response.toString());
      return dropdownValueResponse;
    } else {
      return dropdownValueResponseFromJson(response.toString());
    }
  }

  //api: saveCustomerDetails
  Future<SaveCustomerResponse> saveCustomerDetails(
      SaveCustomerRequest requestParams, BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
        method: Method.POST,
        pathUrl: AppUrl.saveCustomerDetails,
        body: jsonEncode(requestParams.toJson()),
        headers: buildDefaultHeaderWithToken(userToken!),
        australia: true);

    if (response.statusCode == HttpStatus.ok) {
      SaveCustomerResponse saveCustomerResponse =
          saveCustomerResponseFromJson(response.toString());
      return saveCustomerResponse;
    } else if (response.statusCode == HttpStatus.unauthorized) {
      SharedPreferencesMobileWeb.instance.removeParticularKey(apiToken);
      Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
      SharedPreferencesMobileWeb.instance.removeAll();
      return saveCustomerResponseFromJson(response.data);
    } else if (response.statusCode == HttpStatus.notFound) {
      // Navigator.pop(context);
      MyApp.navigatorKey.currentState!.maybePop();
      return saveCustomerResponseFromJson(json.decode(response.data));
    } else if (response.statusCode == HttpStatus.forbidden) {
      await SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        Navigator.pushNamedAndRemoveUntil(
            context, accessDeniedRoute, (route) => false);
      });

      return saveCustomerResponseFromJson(response.data);
    } else if (response.statusCode == HttpStatus.unprocessableEntity) {
      MyApp.navigatorKey.currentState!.maybePop();
      return saveCustomerResponseFromJson(json.decode(response.data));
    } else if (response.statusCode == HttpStatus.badRequest) {
      MyApp.navigatorKey.currentState!.maybePop();
      return saveCustomerResponseFromJson(json.decode(response.data));
    } else {
      return saveCustomerResponseFromJson(json.decode(response.data));
    }
  }

  Future<SaveCustomerRequestHk> getCustomerDetailsHK(
      BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathPersonalDetailsHK,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      SaveCustomerRequestHk saveCustomerRequestHk =
          saveCustomerRequestHkFromJson(response.toString());
      return saveCustomerRequestHk;
    } else if (response.statusCode == HttpStatus.unauthorized) {
      SharedPreferencesMobileWeb.instance.removeParticularKey(apiToken);
      Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
      SharedPreferencesMobileWeb.instance.removeAll();
      return saveCustomerRequestHkFromJson(response.data);
    } else if (response.statusCode == HttpStatus.notFound) {
      MyApp.navigatorKey.currentState!.maybePop();
      return saveCustomerRequestHkFromJson(json.decode(response.data));
    } else if (response.statusCode == HttpStatus.forbidden) {
      await SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        Navigator.pushNamedAndRemoveUntil(
            context, accessDeniedRoute, (route) => false);
      });
      return saveCustomerRequestHkFromJson(response.data);
    } else if (response.statusCode == HttpStatus.unprocessableEntity) {
      MyApp.navigatorKey.currentState!.maybePop();
      return saveCustomerRequestHkFromJson(json.decode(response.data));
    } else if (response.statusCode == HttpStatus.badRequest) {
      MyApp.navigatorKey.currentState!.maybePop();
      return saveCustomerRequestHkFromJson(json.decode(response.data));
    } else {
      return saveCustomerRequestHkFromJson(json.decode(response.data));
    }
  }

  Future<CommonResponse> saveCustomerDetailsHK(
      SaveCustomerRequestHk requestParams, BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    // apiLoader(context);
    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathPersonalDetailsHK,
      body: jsonEncode(requestParams.toJson()),
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      CommonResponse saveCustomerResponse =
          commonResponseFromJson(response.toString());
      return saveCustomerResponse;
    } else if (response.statusCode == HttpStatus.unauthorized) {
      Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
      SharedPreferencesMobileWeb.instance.removeParticularKey(apiToken);
      SharedPreferencesMobileWeb.instance.removeAll();
      return commonResponseFromJson(response.data);
    } else if (response.statusCode == HttpStatus.notFound) {
      MyApp.navigatorKey.currentState!.maybePop();
      return commonResponseFromJson(json.decode(response.data));
    } else if (response.statusCode == HttpStatus.forbidden) {
      await SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        Navigator.pushNamedAndRemoveUntil(
            context, accessDeniedRoute, (route) => false);
      });

      return commonResponseFromJson(response.data);
    } else if (response.statusCode == HttpStatus.unprocessableEntity) {
      MyApp.navigatorKey.currentState!.maybePop();
      return commonResponseFromJson(json.decode(response.data));
    } else if (response.statusCode == HttpStatus.badRequest) {
      MyApp.navigatorKey.currentState!.maybePop();
      return commonResponseFromJson(json.decode(response.data));
    } else {
      return commonResponseFromJson(json.decode(response.data));
    }
  }

  Future<bool> saveCustomerAdditionalDetailsHK(
      SaveAdditionalDetailRequestHk requestParams, BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathPersonalDetailsStep3HK,
      body: jsonEncode(requestParams.toJson()),
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      await RegisterNotifier(context).getAuthStatus(context);
      return true;
    } else {
      return false;
    }
  }

  Future<SaveAdditionalDetailRequestHk> getCustomerAdditionalDetailsHK(
      BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathPersonalDetailsStep3HK,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      SaveAdditionalDetailRequestHk saveAdditionalDetailRequestHk =
          saveAdditionalDetailRequestHkFromJson(response.toString());
      return saveAdditionalDetailRequestHk;
    } else {
      return saveAdditionalDetailRequestHkFromJson(response.toString());
    }
  }

  Future<SaveCustomerResponse> updateCustomerDetails(
      SaveCustomerRequest requestParams, BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    apiLoader(context);
    Response response = await networkProvider.call(
        method: Method.PUT,
        pathUrl: AppUrl.updateCustomerDetails,
        body: jsonEncode(requestParams.toJson()),
        headers: buildDefaultHeaderWithToken(userToken!),
        australia: true);
    MyApp.navigatorKey.currentState!.maybePop();
    if (response.statusCode == HttpStatus.ok) {
      SaveCustomerResponse saveCustomerResponse =
          saveCustomerResponseFromJson(response.toString());
      await SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        Navigator.pushReplacementNamed(context, editProfileRoute);
      });

      return saveCustomerResponse;
    } else {
      return saveCustomerResponseFromJson(response.toString());
    }
  }


  Future<List<SearchAddressResponse>> fetchAddress(String input, String apiKey) async {

    String? userToken;

      await SharedPreferencesMobileWeb.instance
          .getAccessToken(apiToken)
          .then((value) {
        userToken = value;
      });

    final request = "https://uatau.singx.co" + AppUrl.pathGoogleAddressApi + input;
    final response = await Dio().get(
      request,
      options: Options(
        headers: buildDefaultHeaderWithToken(userToken!),
      ),
    );
    if (response.statusCode == HttpStatus.ok) {
      final result = json.decode(response.toString());
      if (result['status'] == 'OK') {
        return result['predictions']
            .map<SearchAddressResponse>(
                (p) => SearchAddressResponse(p['place_id'], p['description']))
            .toList();
      }

      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else if (response.statusCode == HttpStatus.gatewayTimeout) {
      return [];
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<Object> getAddressDetails(String placeId) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathGoogleAddressDetailsApi + placeId,
      headers: buildDefaultHeaderWithToken(userToken!),
      australia: true,
    );
    if (response.statusCode == HttpStatus.ok) {
      SearchAddressDetailsResponse getAddressDetailsResponse = searchAddressDetailsResponseFromJson(response.toString());
      return getAddressDetailsResponse;
    } else {
      return searchAddressDetailsResponseFromJson(response.toString());
    }
  }

  Future<Object> getSGPostCodeAddress(String postCode) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathSGPostCodeAddress + postCode,
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    if (response.statusCode == HttpStatus.ok) {
      GetAddressResponse getAddressResponse = getAddressResponseFromJson(response.toString());
      return getAddressResponse;
    } else {
      return getAddressResponseFromJson(response.toString());
    }
  }
}
