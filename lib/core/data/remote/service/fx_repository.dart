import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:singx/core/data/remote/network/app_url.dart';
import 'package:singx/core/data/remote/network/method.dart';
import 'package:singx/core/models/request_response/australia/corridors/corrdidors_response.dart';
import 'package:singx/core/models/request_response/australia/corridors/get_receiver_currency_response.dart';
import 'package:singx/core/models/request_response/australia/corridors/get_sender_currency_response.dart';
import 'package:singx/core/models/request_response/dashboard_china_transfer_limit/dashboard_china_transfer_limit_request.dart';
import 'package:singx/core/models/request_response/dashboard_china_transfer_limit/dashboard_china_transfer_limit_response.dart';
import 'package:singx/core/models/request_response/dashboard_transaction_list/dashboard_transaction_aus_request.dart';
import 'package:singx/core/models/request_response/dashboard_transaction_list/dashboard_transaction_aus_response.dart';
import 'package:singx/core/models/request_response/error_response.dart';
import 'package:singx/core/models/request_response/exchange/exchange_aus_request.dart';
import 'package:singx/core/models/request_response/exchange/exchange_aus_response.dart';
import 'package:singx/core/models/request_response/exchange/exchange_request.dart';
import 'package:singx/core/models/request_response/exchange/exchange_response.dart';
import 'package:singx/core/models/request_response/get_invoice_transaction/get_invoice_aus_transaction.dart';
import 'package:singx/core/models/request_response/referral/referral_aus_response.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';
import 'package:universal_html/html.dart' as html;
import 'base/base_repository.dart';

class FxRepository extends BaseRepository {
  FxRepository._internal();

  static final FxRepository _singleInstance = FxRepository._internal();

  factory FxRepository() => _singleInstance;

  int? contactId;
  String loginErrorMessage = "";

  String get ErrorMessageGet => loginErrorMessage;

  set ErrorMessageGet(String value) {
    if (value == loginErrorMessage) return;
    loginErrorMessage = value;
    notifyListeners();
  }

  ExchangeResponse exchangeResponseData = ExchangeResponse();

  ExchangeResponse get ExchangeResponseData => exchangeResponseData;

  set ExchangeResponseData(ExchangeResponse value) {
    if (value == exchangeResponseData) return;
    exchangeResponseData = value;
    notifyListeners();
  }

  ExchangeAustraliaResponse exchangeAustraliaResponseData =
      ExchangeAustraliaResponse();

  ExchangeAustraliaResponse get ExchangeAustraliaResponseData =>
      exchangeAustraliaResponseData;

  set ExchangeAustraliaResponseData(ExchangeAustraliaResponse value) {
    if (value == exchangeAustraliaResponseData) return;
    exchangeAustraliaResponseData = value;
    notifyListeners();
  }

  ReferralAusResponse referralAusResponseData = ReferralAusResponse();

  ReferralAusResponse get ReferralAusResponseData => referralAusResponseData;

  set ReferralAusResponseData(ReferralAusResponse value) {
    if (value == referralAusResponseData) return;
    referralAusResponseData = value;
    notifyListeners();
  }

  Map listData = {};

  Map get ListData => listData;

  set ListData(Map value) {
    if (value == listData) return;
    listData = value;
    notifyListeners();
  }

  Map<String, List<CorridorsResponse>> corridorResponseData = {};

  Map<String, List<CorridorsResponse>> get CorridorResponseData =>
      corridorResponseData;

  set CorridorResponseData(Map<String, List<CorridorsResponse>> value) {
    if (value == corridorResponseData) return;
    corridorResponseData = value;
    notifyListeners();
  }

  List<String> corridorResponseDataKey = [];

  List<String> get CorridorResponseDataKey => corridorResponseDataKey;

  set CorridorResponseDataKey(List<String> value) {
    if (value == corridorResponseDataKey) return;
    corridorResponseDataKey = value;
    notifyListeners();
  }

  List<CorridorsResponse> corridorResponseDataValue = [];

  List<CorridorsResponse> get CorridorResponseDataValue =>
      corridorResponseDataValue;

  set CorridorResponseDataValue(List<CorridorsResponse> value) {
    if (value == corridorResponseDataValue) return;
    corridorResponseDataValue = value;
    notifyListeners();
  }

  List<DashboardTransactionAustraliaResponse> _transactionAusData = [];

  List<DashboardTransactionAustraliaResponse> get transactionAusData =>
      _transactionAusData;

  set transactionAusData(List<DashboardTransactionAustraliaResponse> value) {
    if (value == _transactionAusData) return;
    _transactionAusData = value;
    notifyListeners();
  }

  Future<Object?> apiCorridors(BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    final response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathCorridors,
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    ErrorString errorString = ErrorString.fromJson(response.data);

    if (response.statusCode == HttpStatus.ok) {
      var corridorsResponse = corridorsResponseFromJson(response.toString());

      CorridorResponseData = corridorsResponse;
      corridorsResponse.forEach((key, value) {
        CorridorResponseDataKey.add(key);
      });

      return corridorsResponse;
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  //exchange
  Future<Object?> apiExchange(
      ExchangeRequest requestParams, BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathExchange,
      body: requestParams.toJson(),
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      ExchangeResponse loginResponse = ExchangeResponse.fromJson(response.data);
      ExchangeResponseData = loginResponse;
      return loginResponse;
    } else {
      return errorStringFromJson(jsonEncode(response.data)).error;
    }
  }

  //api exchange
  Future<Object?> apiExchangeAustralia(
      ExchangeAustraliaRequest requestParams, BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathExchangeAus,
      body: requestParams.toJson(),
      headers: buildDefaultHeaderWithToken(userToken!),
      australia: true,
    );

    ErrorString errorString = ErrorString.fromJson(response.data);

    if (response.statusCode == HttpStatus.ok) {
      var jsonResponse = json.decode(jsonEncode(response.data));

      if (jsonResponse.containsKey("Error")) {
        return jsonResponse["Error"];
      } else {
        ExchangeAustraliaResponse exchangeAustraliaResponse =
            exchangeAustraliaResponseFromJson(jsonEncode(response.data));
        ExchangeAustraliaResponseData = exchangeAustraliaResponse;
        return exchangeAustraliaResponse;
      }
    } else {
      ErrorMessageGet = errorString.error!;
      return ExchangeAustraliaResponse.fromJson(response.data);
    }
  }


  Future<Object?> apiExchangePHPAustralia(
      ExchangeAustraliaRequest requestParams, BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathExchangePHPAus,
      body: requestParams.toJson(),
      headers: buildDefaultHeaderWithToken(userToken!),
      australia: true,
    );

    ErrorString errorString = ErrorString.fromJson(response.data);

    if (response.statusCode == HttpStatus.ok) {
      var jsonResponse = json.decode(jsonEncode(response.data));

      if (jsonResponse.containsKey("Error")) {
        return jsonResponse["Error"];
      }else {
        ExchangeAustraliaResponse exchangeAustraliaResponse =
            exchangeAustraliaResponseFromJson(jsonEncode(response.data));
        ExchangeAustraliaResponseData = exchangeAustraliaResponse;
        return exchangeAustraliaResponse;
      }
    } else {
      ErrorMessageGet = errorString.error!;
      return ExchangeAustraliaResponse.fromJson(response.data);
    }
  }

  Future<Object?> apiReferralAus(BuildContext context) async {
    String? userToken;
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    await SharedPreferencesMobileWeb.instance
        .getContactId(apiContactId)
        .then((value) {
      contactId = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: "${AppUrl.pathReferralAus}${contactId}",
      headers: buildDefaultHeaderWithToken(userToken!),
      australia: true,
    );

    if (response.statusCode == HttpStatus.ok) {
      ReferralAusResponse referralAusResponse =
          ReferralAusResponse.fromJson(response.data);
      ReferralAusResponseData = referralAusResponse;
      return ReferralAusResponseData;
    } else {
      return ReferralAusResponse.fromJson(response.data);
    }
  }

  Future<Object?> apiDashboardTransactionAus(
      DashboardTransactionAustraliaRequest requestParams,
      BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathDashboardTransaction,
      body: jsonEncode(requestParams.toJson()),
      headers: buildDefaultHeaderWithToken(userToken!),
      australia: true,
    );

    if (response.statusCode == HttpStatus.ok) {
      var dashboardTransactionAusResponse =
          dashboardTransactionAustraliaResponseFromJson(
              jsonEncode(response.data));

      return dashboardTransactionAusResponse;
    } else {
      return dashboardTransactionAustraliaResponseFromJson(
          jsonEncode(response.data));
    }
  }

  Future<Object?> apiDashboardChinaPayTransferLimit(
      DashboardChinaPayTransferLimitRequest requestParams,
      BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathDashboardChinaTransferLimit,
      body: jsonEncode(requestParams.toJson()),
      headers: buildDefaultHeaderWithToken(userToken!),
      australia: true,
    );

    if (response.statusCode == HttpStatus.ok) {
      var dashboardChinaPayTransferLimitResponse =
      dashboardChinaPayTransferLimitResponseFromJson(
          jsonEncode(response.data));

      return dashboardChinaPayTransferLimitResponse;
    } else {
      return dashboardTransactionAustraliaResponseFromJson(
          jsonEncode(response.data));
    }
  }

  Future<Object?> apiDashboardPHPTransferLimit(
      DashboardPHPTransferLimitRequest requestParams,
      BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathDashboardPHPTransferLimit,
      body: jsonEncode(requestParams.toJson()),
      headers: buildDefaultHeaderWithToken(userToken!),
      australia: true,
    );

    if (response.statusCode == HttpStatus.ok) {
      var dashboardPhpTransferLimitResponse =
      dashboardPhpTransferLimitResponseFromJson(
          jsonEncode(response.data));

      return dashboardPhpTransferLimitResponse;
    } else {
      return dashboardPhpTransferLimitResponseFromJson(
          jsonEncode(response.data));
    }
  }


  Future<Object?> apiSenderCurrency(BuildContext context) async {
    String? userToken;
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathSenderCurrencyAus,
      body: {},
      headers: buildDefaultHeaderWithToken(userToken!),
      australia: true,
    );
    if (response.statusCode == HttpStatus.ok) {
      var senderCurrencyResponse =
          getSenderCurrencyAustraliaResponseFromJson(jsonEncode(response.data));

      return senderCurrencyResponse;
    } else {
      return getSenderCurrencyAustraliaResponseFromJson(
          jsonEncode(response.data));
    }
  }

  Future<Object?> apiReceiverCurrency(BuildContext context) async {
    String? userToken;
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathReceiverCurrencyAus,
      body: {},
      headers: buildDefaultHeaderWithToken(userToken!),
      australia: true,
    );

    if (response.statusCode == HttpStatus.ok) {
      var receiverCurrencyResponse =
          getReceiverCurrencyAustraliaResponseFromJson(
              jsonEncode(response.data));

      return receiverCurrencyResponse;
    } else {
      getReceiverCurrencyAustraliaResponseFromJson(jsonEncode(response.data));
    }
  }

  Future<File?> apiGetInvoiceAus(
      GetInvoiceRequest requestParams, BuildContext context) async {
    String? userToken;
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    try {
      Response response = await Dio().post(
        "${AppUrl.baseHttp}${AppUrl.baseHostAus}${AppUrl.pathGetInvoice}",
        data: requestParams,
        options: Options(
          responseType: ResponseType.bytes,
          validateStatus: (status){
            return true;
          },
          headers: <String, dynamic>{
            'Content-Type': 'application/json',
            "Authorization": 'Bearer ${userToken}'
          },
        ),
      );

      if(response.statusCode == 404) {
        downloadEmptyDialog(context);
      }else if(response.data.isNotEmpty){
        if (kIsWeb) {
          if (response != null) {

            final content = base64Encode(response.data);
            html.AnchorElement(
                href: "data:application/octet-stream;charset=utf-16le;base64,$content")
              ..setAttribute("download", "invoice.pdf")
              ..click();

            html.Url.revokeObjectUrl('data:application/octet-stream;charset=utf-16le;base64,$content');
          }
        } else {
          if (response != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Downloading...'),duration: Duration(seconds: 3),));
            if(!kIsWeb) {
              if (await Permission.storage.isDenied) {
                await Permission.storage.request();
              } if (await Permission.photos.isDenied) {
                await Permission.photos.request();
              }if (await Permission.videos.isDenied) {
                await Permission.videos.request();
              }
            }
            final Directory? appDir = Platform.isAndroid
                ? await Directory('/storage/emulated/0/Download')
                : await getApplicationDocumentsDirectory();

            String tempPath = appDir!.path;

            final String fileName =
                DateTime.now().microsecondsSinceEpoch.toString() +
                    '-' +
                    'invoice.pdf';
            File file = new File('$tempPath/$fileName');

            if (!await file.exists()) {
              await file.create();
              initNotification(fileName: fileName,path: file.path);
            }

            await file.writeAsBytes(response.data);
            return file;
          }
        }
      }else if(response.statusCode == 404) {
        downloadEmptyDialog(context);
      }else{
      downloadEmptyDialog(context);
      }
    } catch (value) {}
  }

  //api: SG Operator List
  Future<Object?> apiGetInvoice(String transactionIdData,
      {BuildContext? context}) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    try {
      final transactionId = transactionIdData;
      var url = Uri.encodeFull(
          "${AppUrl.baseHttp}${AppUrl.baseHost}${AppUrl.pathGetInvoiceSing}${transactionId}");

      Response response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          validateStatus: (status){
            return true;
          },
          headers: <String, dynamic>{
            'Content-Type': 'application/json',
            "Authorization": 'Bearer ${userToken}'
          },
        ),
      );

      if(response.statusCode == 404) {
        downloadEmptyDialog(context!);
      }else if(response.data.isNotEmpty) {
        if (kIsWeb) {
          if (response != null) {
            final content = base64Encode(response.data);
            html.AnchorElement(
                href: "data:application/octet-stream;charset=utf-16le;base64,$content")
              ..setAttribute("download", "invoice.pdf")
              ..click();

            html.Url.revokeObjectUrl(
                'data:application/octet-stream;charset=utf-16le;base64,$content');
          }
        } else {
          if (response != null) {
            ScaffoldMessenger.of(context!)
                .showSnackBar(SnackBar(content: Text('Downloading...'),duration: Duration(seconds: 3),));
            if(!kIsWeb) {
              if (await Permission.storage.isDenied) {
                await Permission.storage.request();
              } if (await Permission.photos.isDenied) {
                await Permission.photos.request();
              }if (await Permission.videos.isDenied) {
                await Permission.videos.request();
              }
            }
            final Directory? appDir = Platform.isAndroid
                ? await Directory('/storage/emulated/0/Download')
                : await getApplicationDocumentsDirectory();

            String tempPath = appDir!.path;

            final String fileName =
                DateTime
                    .now()
                    .microsecondsSinceEpoch
                    .toString() +
                    '-' +
                    'invoice.pdf';

            File file = new File('$tempPath/$fileName');

            if (!await file.exists()) {
              await file.create();
              initNotification(fileName: fileName,path: file.path);
            }

            await file.writeAsBytes(response.data);
            return file;
          }
        }
      }else{
        downloadEmptyDialog(context!);
      }
    } catch (value) {}
  }
}
