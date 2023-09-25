import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:singx/core/data/remote/network/app_url.dart';
import 'package:singx/core/data/remote/network/method.dart';
import 'package:singx/core/data/remote/service/base/base_repository.dart';
import 'package:singx/core/models/request_response/error_response.dart';
import 'package:singx/core/models/request_response/transaction_statment/transaction_statement_SG_request.dart';
import 'package:singx/core/models/request_response/transaction_statment/transaction_statment_request.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';
import 'package:universal_html/html.dart' as html;

class TransactionRepository extends BaseRepository {
  TransactionRepository._internal();

  static final TransactionRepository _singleInstance =
      TransactionRepository._internal();

  factory TransactionRepository() => _singleInstance;

  String? userToken;
  int? contactId;
  String loginErrorMessage = "";

  String get ErrorMessageGet => loginErrorMessage;

  set ErrorMessageGet(String value) {
    if (value == loginErrorMessage) return;
    loginErrorMessage = value;
    notifyListeners();
  }

  Future apiActivitiesTransaction(String url, String? fromDate, String? toDate,
      String? Status, String? searchID,String? countryFilter) async {
    String? userToken;
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    var fromDateAPI = fromDate == null ? "" : "date GT '$fromDate';";
    var toDateAPI = toDate == null ? "" : "date LT '$toDate';";
    var StatusAPI = Status == null ? "" : "status EQ '$Status';";
    var searchIDAPI = searchID == null ? "" : " id EQ '$searchID';";
    var countryFilterAPi = countryFilter == null ? "" : " countryId EQ '$countryFilter';";

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathActivitesTransaction +
          url +
          fromDateAPI +
          toDateAPI +
          StatusAPI +
          searchIDAPI+
          countryFilterAPi,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      return response.data;
    } else {
      return response.data;
    }
  }

  //Australia Transaction Status List
  Future apiTransactionStatusList(context) async {
    String? userToken;
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.getTransactionStatusData,
      australia: true,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      return response.data;
    } else {
      ErrorString errorString = ErrorString.fromJson(response.data);
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  //SG Filter List
  Future apiSGFilterList(context) async {
    String? userToken;
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathSGTransactionFilterAPI,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      return response.data;
    } else {
      ErrorString errorString = ErrorString.fromJson(response.data);
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  //SG Filter List
  Future apiSGBankDetails() async {
    String? userToken;
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathSGBankDetails,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      return response.data;
    } else {
      ErrorString errorString = ErrorString.fromJson(response.data);
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  Future<Object?> apiTransactionStatment(
      TransactionStatement requestParams, BuildContext context) async {
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    var response= await Dio().post(
        "https://uatau.singx.co/singx/transactionStatement/generateStatement",
        data: jsonEncode(requestParams.toJson()),
        options: Options(
          responseType: ResponseType.bytes,
          validateStatus: (status){
            return true;
          },
          headers: buildDefaultPDFHeaderWithToken(userToken!),
        ));

    if(response.statusCode == 404) {
      downloadEmptyDialog(context);
    }else if(response.data.isNotEmpty) {
      if (kIsWeb) {
        if (response != null) {
          final content = base64Encode(response.data);
          html.AnchorElement(
              href: "data:application/octet-stream;charset=utf-16le;base64,$content")
            ..setAttribute("download", "statement.pdf")
            ..click();

          html.Url.revokeObjectUrl(
              'data:application/octet-stream;charset=utf-16le;base64,$content');
        }
      } else {
        if (response != null) {
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
                  'statement.pdf';

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
      downloadEmptyDialog(context);
    }
  }

  Future<Object?> apiTransactionStatmentSG(
      DownloadStatementSgRequest requestParams, BuildContext context) async {
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await Dio()
        .post("https://api-uat.singx.co/central/transaction/v1/statement",
            data: jsonEncode(requestParams.toJson()),
            options: Options(
              responseType: ResponseType.bytes,
              validateStatus: (status){
                return true;
              },
              headers: buildDefaultPDFHeaderWithToken(userToken!),
            ));

    if(response.statusCode == 404) {
      downloadEmptyDialog(context);
    }else if(response.data.isNotEmpty) {
      if (kIsWeb) {
        if (response != null) {
          final content = base64Encode(response.data);
          html.AnchorElement(
              href: "data:application/octet-stream;charset=utf-16le;base64,$content")
            ..setAttribute("download", "statement.pdf")
            ..click();

          html.Url.revokeObjectUrl(
              'data:application/octet-stream;charset=utf-16le;base64,$content');
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
              DateTime
                  .now()
                  .microsecondsSinceEpoch
                  .toString() +
                  '-' +
                  'statement.pdf';

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
      downloadEmptyDialog(context);
    }
  }
}
