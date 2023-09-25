import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:singx/main.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';
import '../../../../utils/common/dummy_data.dart';
import 'app_url.dart';
import 'method.dart';

class NetworkProvider {
  var log;

  // singleton boilerplate
  NetworkProvider._internal();

  static final NetworkProvider _singleInstance = NetworkProvider._internal();

  factory NetworkProvider() => _singleInstance;


  Duration timeout = Duration(minutes: 2);


  static BaseOptions opts = BaseOptions(
    responseType: ResponseType.json,
    connectTimeout: 60 * 1000,
    receiveTimeout: 60 * 1000,
    sendTimeout: 60 * 1000,
  );

  static Dio? dio = Dio(opts);
  static Dio? client = addInterceptors(dio!);

  static Dio? addInterceptors(Dio dio) {
    return dio
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            var customHeaders = {
              'content-type': 'application/json',
              'Accept': 'application/json',
            };
            options.headers.addAll(customHeaders);
            return handler.next(options); //continue
          },
          onResponse: (response, handler) {
            return handler.next(response); // continue
          },
          onError: (DioError e, handler) async {
            if (e.message == "XMLHttpRequest error.") {
                MyApp.navigatorKey.currentState?.pushNamed(networkNotAvailable);
              return;
            }
            return handler.next(e); //continue.
          },
        ),
      );
  }

  static commonErrorResponseHandling(DioError dioError) async {
    var urlPath = dioError.requestOptions.path;
    Response? response = dioError.response;
    if (response!.statusCode == HttpStatus.unauthorized) {
      if (urlPath.contains("${AppUrl.baseUrlAus}${AppUrl.pathLoginAustralia}") ||
          urlPath.contains("${AppUrl.baseUrlAus}${AppUrl.pathRegisterAus}") ||
          urlPath.contains("${AppUrl.baseUrl}${AppUrl.pathLogin}") ||
          urlPath.contains("${AppUrl.baseUrl}${AppUrl.pathRegister}")) {
      } else {
        SharedPreferencesMobileWeb.instance.removeParticularKey(apiToken);
        MyApp.navigatorKey.currentState
            ?.pushNamedAndRemoveUntil(loginRoute, (route) => false);
        MyApp.navigatorKey.currentState
            ?.maybePop(loginRoute);


        return response;
      }
      return response;
    } else if (response.statusCode == HttpStatus.forbidden) {
      await SharedPreferencesMobileWeb.instance.getCountry(country).then((value) async {

        MyApp.navigatorKey.currentState
            ?.pushNamedAndRemoveUntil(accessDeniedRoute, (route) => false);
        return response;
      });

    } else if (response.statusCode == HttpStatus.notFound) {
      return response;
    } else if (response.statusCode == HttpStatus.unprocessableEntity) {
      return response;
    } else if (response.statusCode == HttpStatus.badRequest) {
      return response;
    } else {
      return response;
    }
  }

  Future call(
      {String? pathUrl,
      var queryParam,
      headers,
      Encoding? encoding,
      Method? method,
      body,
      bool? australia,
      bool? SGbp,
        bool? dropdown,
      bool? download,ResponseType? responseType}) async {
    var responseData;

    var url;
    if (queryParam == null) {
      url = australia == true
          ? AppUrl.baseUrlAus + pathUrl!
          : SGbp == true
          ? AppUrl.baseUrlSGBP + pathUrl!
          : dropdown == true ?
      AppUrl.baseUrlDropdown + pathUrl!
          :AppUrl.baseUrl + pathUrl!;
    } else {
      url = Uri.encodeFull(australia == true
          ? AppUrl.baseUrlAus+pathUrl!+queryParam
          : SGbp == true
          ? AppUrl.baseUrlSGBP+pathUrl!+queryParam
          : dropdown == true ?
      AppUrl.baseUrlDropdown+pathUrl!+queryParam : AppUrl.baseUrl+pathUrl!+queryParam);
    }
    switch (method) {
      case Method.GET:
        try {
          responseData = await client!
              .get(url,
                  options: Options(
                    headers: headers,
                  ))
              .timeout(timeout);
        } on DioError catch (dioError) {
          return commonErrorResponseHandling(dioError);
        }
        break;
      case Method.POST:
        try {
          responseData = await client!
              .post(url,
                  data: body,

                  options: Options(
                    headers: headers,

                    responseType: responseType
                  ))
              .timeout(timeout);
        } on DioError catch (dioError) {
          return commonErrorResponseHandling(dioError);
        }
        break;
      case Method.PUT:
        try {
          responseData = await client!
              .put(url,
                  data: body,
                  options: Options(
                    headers: headers,
                  ))
              .timeout(timeout);
        } on DioError catch (dioError) {
          return commonErrorResponseHandling(dioError);
        }
        break;
      case Method.DELETE:
        try {
          responseData = await client!
              .delete(url,
                  data: body,
                  options: Options(
                    headers: headers,
                  ))
              .timeout(timeout);
        } on DioError catch (dioError) {
          return commonErrorResponseHandling(dioError);
        }
        break;
      default:
        break;
    }
    print("URL: ${url}");
    print("responseData ${responseData}");
    return responseData;
  }
}
