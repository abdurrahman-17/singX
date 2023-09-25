import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:singx/core/data/remote/network/app_url.dart';
import 'package:singx/core/data/remote/network/method.dart';
import 'package:singx/core/data/remote/service/base/base_repository.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/categoryList.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/country_list.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/india_bill_payment_history_filter.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/pricing_request.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/pricing_response.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/sg_bill_operator_list_by_id.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/sg_bill_operator_list_response.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/sg_bill_save_request.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/sg_bill_save_response.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/transaction_history_response.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/view_bill_request.dart';
import 'package:singx/core/models/request_response/sg_bill_pay/view_bill_response.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class SGBillPayRepository extends BaseRepository {
  SGBillPayRepository._internal();

  static final SGBillPayRepository _singleInstance =
  SGBillPayRepository._internal();

  factory SGBillPayRepository() => _singleInstance;

  //api: SG Wallet Balance
  Future<Object?> SGBillPayCountries() async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathSGBillCountryList,
      SGbp: true,
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    
    if (response.statusCode == HttpStatus.ok) {
      return countryListFromJson(jsonEncode(response.data));
    } else {
      return countryListFromJson(jsonEncode(response.data));
    }
  }

  //api: SG Operator List
  Future<Object?> SGBillCategoryList() async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
      final countryID= '1000002';
    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathSGBillCategoryList,
      SGbp: true,
      queryParam: countryID,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      return categoryListFromJson(jsonEncode(response.data));
    } else {
      return categoryListFromJson(jsonEncode(response.data));
    }
  }

 //api: SG Operator List
  Future<Object?> SGBillOperatorList() async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    final countryID= '1000002';
    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathSGBillOperatorList,
      SGbp: true,
      queryParam: countryID,
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    
    if (response.statusCode == HttpStatus.ok) {
      return operatorListFromJson(jsonEncode(response.data));
    } else {
      return operatorListFromJson(jsonEncode(response.data));
    }
  }

  //api: SG Operator By ID
  Future<Object?> SGBillOperatorByID(String operatorId) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    final countryID= '1000002/';
    final id= operatorId;
    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathSGBillOperatorByID,
      SGbp: true,
      queryParam: countryID+id,
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    
    if (response.statusCode == HttpStatus.ok) {
      return operatorByIdFromJson(jsonEncode(response.data));
    } else {
      return operatorByIdFromJson(jsonEncode(response.data));
    }
  }

  //api: SG View Bill
  Future<Object?> SGViewBill(ViewBillRequest viewBillRequest) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathSGBillViewBill,
      SGbp: true,
      body: jsonEncode(viewBillRequest),
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    
    if (response.statusCode == HttpStatus.ok) {
      if(response.data['success'] == true) {
        return viewBillResponseFromJson(jsonEncode(response.data));
      }else{
        return viewBillErrorResponseFromJson(jsonEncode(response.data));
      }
    } else {
      return viewBillResponseFromJson(jsonEncode(response.data));
    }
  }

  //api: SG Transaction History
  Future<Object?> SGBillTransactionHistory(String? fromDate, String? toDate,
      String? Status, String? searchID) async {
    String? userToken;
    var fromDateAPI=fromDate == null? "":"date GT '$fromDate';";
    var toDateAPI=toDate == null? "":"date LT '$toDate';";
    var StatusAPI=Status == null? "":"status EQ '$Status';";
    var searchIDAPI=searchID == null? "":" id EQ '$searchID';";
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathSGBillTransactionHistory+ fromDateAPI + toDateAPI + StatusAPI + searchIDAPI + '&size=500',
      SGbp: true,
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    
    if (response.statusCode == HttpStatus.ok) {
      return transactionHistoryResponseFromJson(jsonEncode(response.data));
    } else {
      return transactionHistoryResponseFromJson(jsonEncode(response.data));
    }
  }

  //api: SG Bill Pricing
  Future<Object?> SGPricing(PricingRequest pricingRequest) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathSGPricing,
      SGbp: true,
      body: jsonEncode(pricingRequest),
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    
    if (response.statusCode == HttpStatus.ok) {
      if(response.data['success'] == true) {
        return pricingResponseFromJson(jsonEncode(response.data));
      }else{
        return pricingResponseFromJson(jsonEncode(response.data));
      }
    } else {
      return pricingResponseFromJson(jsonEncode(response.data));
    }
  }

  //api: SG Bill Save
  Future<Object?> SGBillSave(BillSaveRequest billSaveRequest) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathSGBillSave,
      SGbp: true,
      body: jsonEncode(billSaveRequest),
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    
    if (response.statusCode == HttpStatus.ok) {

      if(response.data['success'] == true) {
        return billSaveResponseFromJson(jsonEncode(response.data));
      }else{
        return billSaveResponseFromJson(jsonEncode(response.data));
      }
    } else {
      return billSaveResponseFromJson(jsonEncode(response.data));
    }
  }

  //api: SG IndiaBillPayment Filter
  Future<IndiaBillPaymentFilterResponse> SGBillPayFilterList() async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathSGBillFilter,
      SGbp: true,
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    
    if (response.statusCode == HttpStatus.ok) {
      IndiaBillPaymentFilterResponse indiaBillPaymentFilterResponse = IndiaBillPaymentFilterResponse.fromJson(response.data);
      return indiaBillPaymentFilterResponse;
    } else {
      return IndiaBillPaymentFilterResponse.fromJson(response.data);
    }
  }
}
