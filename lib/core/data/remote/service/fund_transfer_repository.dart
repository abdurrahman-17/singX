import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:singx/core/data/remote/network/app_url.dart';
import 'package:singx/core/data/remote/network/method.dart';
import 'package:singx/core/models/request_response/australia/corridors/corrdidors_response.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/customer_rating/customer_rating_response.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/generate_otp/generate_otp_response.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/initiate_transfer/initiate_transfer_request.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/initiate_transfer/initiate_transfer_response.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/promo_code/promo_code_request.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/promo_code/promo_code_response.dart';
import 'package:singx/core/models/request_response/fund_transfer/customer_rating_response.dart';
import 'package:singx/core/models/request_response/fund_transfer/relationship/relationship_response.dart';
import 'package:singx/core/models/request_response/fund_transfer/save_transaction_sg_request.dart';
import 'package:singx/core/models/request_response/fund_transfer/save_transaction_sg_response.dart';
import 'package:singx/core/models/request_response/fund_transfer/transfer_purpose/transfer_purpose_response.dart';
import 'package:singx/core/models/request_response/check_transfer_limit/check_transfer_limit_request.dart';
import 'package:singx/core/models/request_response/check_transfer_limit/check_transfer_limit_response.dart';
import 'package:singx/core/models/request_response/manage_receiver/receiver_list_response.dart';
import 'package:singx/core/models/request_response/send_receiver_country/receiver_country_response.dart';
import 'package:singx/core/models/request_response/send_receiver_country/send_country_response.dart';
import 'package:singx/core/models/request_response/transaction/PromoCodeCerifyResponseSG.dart';
import 'package:singx/core/models/request_response/transaction/PromoCodeVerifyRequestSg.dart';
import 'package:singx/core/models/request_response/fund_transfer/bank_details_response.dart';
import 'package:singx/core/models/request_response/fund_transfer/get_receiver_account_details_response.dart';
import 'package:singx/core/models/request_response/fund_transfer/get_sender_account_details_response.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/save_transaction/save_transaction_request.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/save_transaction/save_transaction_response.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/validate_transaction/validate_transaction_request.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/validate_transaction/validate_transaction_response.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/verify_otp/verify_otp_response.dart';
import 'package:singx/core/models/request_response/dashboard_transaction_list/dashboard_transaction_aus_response.dart';
import 'package:singx/core/models/request_response/error_response.dart';
import 'package:singx/core/models/request_response/referral/referral_aus_response.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/relationship_dropdown/relationship_response_aus.dart';
import 'package:singx/core/models/request_response/transaction_file_upload/transaction_file_upload_response.dart';
import 'package:singx/core/models/request_response/australia/fund_transfer/transfer_purpose/transfer_purpose_aus_response.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';
import 'package:http_parser/src/media_type.dart';
import 'base/base_repository.dart';

class FundTransferRepository extends BaseRepository {
  FundTransferRepository._internal();

  static final FundTransferRepository _singleInstance =
      FundTransferRepository._internal();

  factory FundTransferRepository() => _singleInstance;

  String? userToken;
  int? contactId;
  String loginErrorMessage = "";

  String get ErrorMessageGet => loginErrorMessage;

  set ErrorMessageGet(String value) {
    if (value == loginErrorMessage) return;
    loginErrorMessage = value;
    notifyListeners();
  }

  ReferralAusResponse referralAusResponseData = ReferralAusResponse();

  ReferralAusResponse get ReferralAusResponseData => referralAusResponseData;

  set ReferralAusResponseData(ReferralAusResponse value) {
    if (value == referralAusResponseData) return;
    referralAusResponseData = value;
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

  List<DashboardTransactionAustraliaResponse> _transactionAusData = [];

  List<DashboardTransactionAustraliaResponse> get transactionAusData =>
      _transactionAusData;

  set transactionAusData(List<DashboardTransactionAustraliaResponse> value) {
    if (value == _transactionAusData) return;
    _transactionAusData = value;
    notifyListeners();
  }

  //api: transfer_purpose
  Future<Object?> apiRelationShipDataAus(BuildContext context) async {
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
      var relationshipResponse =
          relationShipAustraliaResponseFromJson(jsonEncode(response.data));

      return relationshipResponse;
    } else {}
  }

  //api: transfer purpose
  Future<Object?> apiTransferPurposeAus(BuildContext context) async {
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathTransferPurposeAus,
      headers: buildDefaultHeaderWithToken(userToken!),
      australia: true,
    );

    if (response.statusCode == HttpStatus.ok) {
      var transferPurposeResponse =
          transferPurposeAustraliaResponseFromJson(jsonEncode(response.data));

      return transferPurposeResponse;
    } else {}
  }

  //api: verifyPromoCode
  Future<Object?> verifyPromoCode(
      BuildContext context, PromoCodeVerifyRequest requestParams) async {
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
        method: Method.POST,
        body: jsonEncode(requestParams.toJson()),
        pathUrl: AppUrl.pathVerifyPromo,
        headers: buildDefaultHeaderWithToken(userToken!),
        australia: true);
    ErrorString errorString = ErrorString.fromJson(response.data);

    if (response.statusCode == HttpStatus.ok) {
      PromoCodeVerifyResponse promoCodeVerifyResponse =
          PromoCodeVerifyResponse.fromJson(response.data);

      return promoCodeVerifyResponse;
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  //api: verifyPromoCode
  Future<Object?> verifyPromoCodeSG(
      BuildContext context, PromoCodeVerifyRequestSg requestParams) async {
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      body: jsonEncode(requestParams.toJson()),
      pathUrl: AppUrl.pathValidatePromoSG,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    ErrorString errorString = ErrorString.fromJson(response.data);

    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created ||
        response.statusCode == HttpStatus.accepted) {
      PromoCodeVerifyResponseSG promoCodeVerifyResponse =
          PromoCodeVerifyResponseSG.fromJson(response.data);

      return promoCodeVerifyResponse;
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  //api: generateOtp
  Future<Object?> generateOtp(BuildContext context, type) async {
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    int? contactId =
        await SharedPreferencesMobileWeb.instance.getContactId(apiContactId);

    Response response = await networkProvider.call(
        method: Method.POST,
        body: jsonEncode({"contactId": contactId, "type": type}),
        pathUrl: AppUrl.pathGenerateOTP,
        headers: buildDefaultHeaderWithToken(userToken!),
        australia: true);

    ErrorString errorString = ErrorString.fromJson(response.data);

    if (response.statusCode == HttpStatus.ok) {
      GenerateOtpResponse generateOtpResponse =
          GenerateOtpResponse.fromJson(response.data);

      return generateOtpResponse;
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  Future<Object?> generateOtpSG(
    BuildContext context,type
  ) async {
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathGenerateOTPSG + '/$type',
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    ErrorString errorString = ErrorString.fromJson(response.data);

    if (response.statusCode == HttpStatus.ok) {
      GenerateOtpResponse generateOtpResponse =
          GenerateOtpResponse.fromJson(response.data);

      return generateOtpResponse;
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  //api: verifyOtp
  Future<Object?> verifyOtp(BuildContext context, mobileNumber, otp) async {
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
        method: Method.POST,
        body: jsonEncode({"mobileNumber": "$mobileNumber", "otp": "$otp"}),
        pathUrl: AppUrl.pathVerifyOTP,
        headers: buildDefaultHeaderWithToken(userToken!),
        australia: true);

    ErrorString errorString = ErrorString.fromJson(response.data);

    if (response.statusCode == HttpStatus.ok) {
      VerifyOtpResponse verifyOtpResponse =
          verifyOtpResponseFromJson(jsonEncode(response.data));

      return verifyOtpResponse;
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  //api: saveTransaction
  Future<Object?> saveTransaction(
      BuildContext context, SaveTransactionRequest requestParams) async {
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
        method: Method.POST,
        body: jsonEncode(requestParams.toJson()),
        pathUrl: AppUrl.pathTransactionSave,
        headers: buildDefaultHeaderWithToken(userToken!),
        australia: true);

    ErrorString errorString = ErrorString.fromJson(response.data);

    if (response.statusCode == HttpStatus.ok) {
      SaveTransactionResponse saveTransactionResponse =
          SaveTransactionResponse.fromJson(response.data);

      return saveTransactionResponse;
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  //api: validateTransaction
  Future<Object?> validateTransaction(
      BuildContext context, ValidateTransactionRequest requestParams) async {
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
        method: Method.POST,
        body: jsonEncode(requestParams.toJson()),
        pathUrl: AppUrl.pathValidateTransaction,
        headers: buildDefaultHeaderWithToken(userToken!),
        australia: true);

    ErrorString errorString = ErrorString.fromJson(response.data);

    if (response.statusCode == HttpStatus.ok) {
      ValidateTransactionResponse validateTransactionResponse =
          ValidateTransactionResponse.fromJson(response.data);

      return validateTransactionResponse;
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  //api: initiateTransferMail
  Future<Object?> initiateTransferMail(
      BuildContext context, InitiateTransferEmailRequest requestParams) async {
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
        method: Method.POST,
        body: jsonEncode(requestParams.toJson()),
        pathUrl: AppUrl.pathInitiateTransferEmail,
        headers: buildDefaultHeaderWithToken(userToken!),
        australia: true);

    ErrorString errorString = ErrorString.fromJson(response.data);

    if (response.statusCode == HttpStatus.ok) {
      InitiateTransferEmailResponse emailResponse =
          InitiateTransferEmailResponse.fromJson(response.data);

      return emailResponse;
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  //api: customerRating
  Future<Object?> customerRating(BuildContext context, contactId) async {
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
        method: Method.POST,
        body: jsonEncode({"contactId": contactId}),
        pathUrl: AppUrl.pathCustomerRating,
        headers: buildDefaultHeaderWithToken(userToken!),
        australia: true);

    ErrorString errorString = ErrorString.fromJson(response.data);

    if (response.statusCode == HttpStatus.ok) {
      CustomerRatingResponse customerRatingResponse =
          CustomerRatingResponse.fromJson(response.data);

      return customerRatingResponse;
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  Future<Object?> apiTransactionFileUpload(filePath, fileName, int contactId,
      int field, String userTransactionId, BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    FormData? formData;
    if (kIsWeb) {
      formData = FormData.fromMap({
        "contactId": contactId,
        "field": field,
        "usertxnId": userTransactionId,
        "file": await MultipartFile.fromBytes(
          filePath,
          filename: fileName,
          contentType: MediaType(
            fileName.split(".").last == "pdf" ? "application" : "image",
            "${fileName.split(".").last}",
          ),
        ),
      });
    } else {
      formData = FormData.fromMap({
        "contactId": contactId,
        "field": field,
        "usertxnId": userTransactionId,
        "file": await MultipartFile.fromFile(
          filePath,
          filename: fileName,
          contentType: MediaType(
            fileName.split(".").last == "pdf" ? "application" : "image",
            "${fileName.split(".").last}",
          ),
        ),
      });
    }

    Response response = await networkProvider.call(
      method: Method.POST,
      body: formData,
      pathUrl: AppUrl.pathTransactionFiledUpload,
      headers: buildDefaultHeaderWithToken(userToken!),
      australia: true,
    );

    ErrorString errorString = ErrorString.fromJson(response.data);

    if (response.statusCode == HttpStatus.ok) {
      TransactionFileUploadResponse transactionFileUploadResponse =
          TransactionFileUploadResponse.fromJson(response.data);
      if (transactionFileUploadResponse.status == 200) {
        return transactionFileUploadResponse;
      }
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  //api: transfer purpose Singapore
  Future<Object?> apiTransferPurposeAusSingapore(BuildContext context,
      {String receiverCountryId =
          'Id2127be9f-b960-494c-8908-b64aa5c5876a'}) async {
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathTransferPurposeSingapore + receiverCountryId,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      var dropdownResponse =
          transferPurposeSingResponseFromJson(json.encode(response.data));

      return dropdownResponse;
    } else {}
  }

  //api: Sender Account Details
  Future<Object?> apiSenderAccountDetails(String countryId) async {
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathSenderAccountDetails + countryId,
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    if (response.statusCode == HttpStatus.ok) {
      var dropdownResponse =
          getSenderAccountDetailsFromJson(json.encode(response.data));

      return dropdownResponse;
    } else {}
  }

  //api: Receiver Account Details
  Future<Object?> apiReceieverAccountDetails(
      BuildContext context, String countryId) async {
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathReceiverAccountDetails + countryId,
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    if (response.statusCode == HttpStatus.ok) {
      var dropdownResponse =
          getReceiverAccountDetailsFromJson(json.encode(response.data));

      return dropdownResponse;
    } else {}
  }

  //api: Receiver Account Details
  Future<Object?> apiReceieverAccountList(
      BuildContext context, String countryId) async {
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathReceiverList + '?size=100&filter=country EQ $countryId',
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    if (response.statusCode == HttpStatus.ok) {
      var dropdownResponse =
      receiverListResponseFromJson(json.encode(response.data));

      return dropdownResponse;
    } else {}
  }

  //api: Send Country
  Future<Object?> apiSendCountry(BuildContext context) async {
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathSendCountry,
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    if (response.statusCode == HttpStatus.ok) {
      List<SendCountryResponse> sendCountryResponse =
          sendCountryResponseFromJson(jsonEncode(response.data));

      return sendCountryResponse;
    } else {}
  }

  //api: Send Country
  Future<Object?> apiReceiveCountry(BuildContext context) async {
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathReceiveCountry,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      List<ReceiveCountryResponse> receiveCountryResponse =
          receiveCountryResponseFromJson(jsonEncode(response.data));

      return receiveCountryResponse;
    } else {}
  }

  //api: Bank Account Details
  Future<Object?> apiBankAccountDetails(BuildContext context) async {
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathBankAccountDetails,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      var responseData =
          getBankAccountResponseFromJson(json.encode(response.data));

      return responseData;
    } else {
      getBankAccountResponseFromJson(json.encode(response.data));
    }
  }

  //api: Check Transfer Limit
  Future<Object?> apiChecktransferLimit(
      BuildContext context, CheckTransferLimitRequest requestParams) async {
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      body: jsonEncode(requestParams.toJson()),
      pathUrl: AppUrl.pathCheckTransferLimit,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      if (response.data["response"]["success"] == true) {
        return 1;
      } else {
        CheckTransferLimitResponse checkTransferLimitResponse =
            checkTransferLimitResponseFromJson(jsonEncode(response.data));

        return checkTransferLimitResponse.response!.message;
      }
    } else {
      return checkTransferLimitResponseFromJson(jsonEncode(response.data))
          .response!
          .message;
    }
  }

  //api: Relationship Dropdown
  Future<Object?> apiRelationshipDropdown(BuildContext context) async {
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathRelationshipDropdown,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      var dropdownResponse =
          relationshipDropdownResponseFromJson(json.encode(response.data));

      return dropdownResponse;
    } else {}
  }

  //api: saveTransactionSG
  Future<Object?> saveTransactionSG(
      BuildContext context, SaveTransactionRequestSG requestParams) async {
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      body: jsonEncode(requestParams.toJson()),
      pathUrl: AppUrl.pathSaveTransaction,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    ErrorString errorString = ErrorString.fromJson(response.data);

    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created ||
        response.statusCode == HttpStatus.preconditionFailed ||
        response.statusCode == HttpStatus.internalServerError) {
      SaveTransactionResponseSG saveTransactionResponse =
          SaveTransactionResponseSG.fromJson(response.data);

      return saveTransactionResponse;
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  //api: customerRating
  Future<Object?> customerRatingSG(BuildContext context, String userId) async {
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathCustomerRatingSG + userId,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    ErrorString errorString = ErrorString.fromJson(response.data);

    if (response.statusCode == HttpStatus.ok) {
      CustomerRatingResponseSg customerRatingResponseSG =
          CustomerRatingResponseSg.fromJson(response.data);

      return customerRatingResponseSG;
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  //api: customerRating
  Future<Object?> customerRatingReviewPopupClicked(
      BuildContext context, String userId) async {
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathSetReviewPopupClicked + userId,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    ErrorString errorString = ErrorString.fromJson(response.data);

    if (response.statusCode == HttpStatus.ok) {
      CustomerRatingResponseSg customerRatingResponseSG =
          CustomerRatingResponseSg.fromJson(response.data);

      return customerRatingResponseSG;
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }
}
