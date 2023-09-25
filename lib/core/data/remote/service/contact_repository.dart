import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:singx/core/data/remote/network/app_url.dart';
import 'package:singx/core/data/remote/network/method.dart';
import 'package:singx/core/data/remote/service/base/base_repository.dart';
import 'package:singx/core/models/request_response/australia/personal_details/CustomerDetailsResponse.dart';
import 'package:singx/core/models/request_response/common_response.dart';
import 'package:singx/core/models/request_response/document/document_list_response.dart';
import 'package:singx/core/models/request_response/edit_profile/edit_profile_response.dart';
import 'package:singx/core/models/request_response/edit_profile/individual_details.dart';
import 'package:singx/core/models/request_response/error_response.dart';
import 'package:singx/core/models/request_response/get_profile_values/get_profile_value_response.dart';
import 'package:singx/core/models/request_response/jumio_verification/jumio_verification_response.dart';
import 'package:singx/core/models/request_response/otp_verify/otp_verify_response.dart';
import 'package:singx/core/models/request_response/personal_details/personal_details_sg_request.dart';
import 'package:singx/core/models/request_response/personal_details/personal_details_sg_response.dart';
import 'package:singx/core/models/request_response/sing_pass_url/sing_pass_url_response.dart';
import 'package:singx/core/models/request_response/singpass_code/singpass_code_request.dart';
import 'package:singx/main.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class ContactRepository extends BaseRepository {
  ContactRepository._internal();

  static final ContactRepository _singleInstance =
      ContactRepository._internal();

  factory ContactRepository() => _singleInstance;
  String loginErrorMessage = "";
  String? userToken;

  EditProfileResponse _editProfileResponseData = EditProfileResponse();

  EditProfileResponse get editProfileResponseData => _editProfileResponseData;

  set editProfileResponseData(EditProfileResponse value) {
    if (value == _editProfileResponseData) return;
    _editProfileResponseData = value;
    notifyListeners();
  }

  String get ErrorMessageGet => loginErrorMessage;

  set ErrorMessageGet(String value) {
    if (value == loginErrorMessage) {
      return;
    }

    loginErrorMessage = value;
    notifyListeners();
  }

  List _errorList = [];

  List get errorList => _errorList;

  set errorList(List value) {
    _errorList = value;
    notifyListeners();
  }

  List _industryListData = [];

  List get industryListData => _industryListData;

  set industryListData(List value) {
    if (_industryListData == value) {
      return;
    }
    _industryListData = value;
    notifyListeners();
  }

  List _nationalityListData = [];

  List get nationalityListData => _nationalityListData;

  set nationalityListData(List value) {
    if (_nationalityListData == value) {
      return;
    }
    _nationalityListData = value;
    notifyListeners();
  }

  String _documentID = "";

  String get documentID => _documentID;

  set documentID(String value) {
    _documentID = value;
    notifyListeners();
  }

  String _documentType = "";

  String get documentType => _documentType;

  set documentType(String value) {
    if (_documentType == value) return;
    _documentType = value;
    notifyListeners();
  }

  //api: SingPass Generated URL
  Future<Object?> singPassUrl(BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
        method: Method.GET,
        pathUrl: AppUrl.pathSingPassUrl,
        headers: buildDefaultHeaderWithToken(userToken!),
        responseType: ResponseType.plain);
    ErrorString errorString = ErrorString.fromJson(response.data);

    if (response.statusCode == HttpStatus.ok) {
      SingPassUrl singPassUrl = SingPassUrl.fromJson(response.data);
      return singPassUrl;
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  //api: Personal Details SG
  Future<Object?> apiPersonalDetailsSG(
      PersonalDetailsRequestSg requestParams, BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    apiLoader(context);
    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathPersonalDetailsSg,
      body: jsonEncode(requestParams),
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    MyApp.navigatorKey.currentState!.pop();
    ErrorString errorString = ErrorString.fromJson(response.data);
    if (response.statusCode == HttpStatus.ok) {
      return PersonalDetailsResponseSg.fromJson(response.data);
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  //api: Personal Details SG
  Future<Object?> getPersonalDetailsSG(BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    apiLoader(context);
    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathPersonalDetailsSg,
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    MyApp.navigatorKey.currentState!.maybePop();
    ErrorString errorString = ErrorString.fromJson(response.data);
    if (response.statusCode == HttpStatus.ok) {
      PersonalDetailsRequestSg personalDetailsResponseSg =
          PersonalDetailsRequestSg.fromJson(response.data);
      return personalDetailsResponseSg;
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

//api: Individual Reg Detail
  Future<Object?> getIndividualRegDetailSG(BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    apiLoader(context);
    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathIndividualRegDetail,
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    MyApp.navigatorKey.currentState!.maybePop();
    if (response.statusCode == HttpStatus.ok) {
      IndividualRegDetail individualRegDetail =
      IndividualRegDetail.fromJson(response.data[0]);
      return individualRegDetail;
    } else {
      ErrorMessageGet = "Something Went Wrong";
      return ErrorMessageGet;
    }
  }

  //api: Generate Otp
  Future<Object?> apiOtpGenerate() async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      body: {},
      pathUrl: AppUrl.pathOtpGenerate,
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    ErrorString errorString = ErrorString.fromJson(response.data);

    if (response.statusCode == HttpStatus.ok) {
      CommonResponse res = CommonResponse.fromJson(response.data);
      if(res.success == true) {
        fetchOTP();
      }
      return res;
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }

    return null;
  }

  //api: Fetch OTP
  Future<Object?> fetchOTP() async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.fetchOTP,
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    ErrorString errorString = ErrorString.fromJson(response.data);
    if (response.statusCode == HttpStatus.ok) {
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }

    return null;
  }

  //api: Verify OTP
  Future<Object?> apiOtpVerify(
    String OTP,
    BuildContext context,
  ) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      body: OTP,
      pathUrl: AppUrl.pathOtpVerify,
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    ErrorString errorString = ErrorString.fromJson(response.data);

    if (response.statusCode == HttpStatus.ok) {
      OtpVerifyResponse otpVerifyResponse =
          OtpVerifyResponse.fromJson(response.data);
      return otpVerifyResponse.success;
    } else {
      ErrorMessageGet = errorString.error!;
      return false;
    }
  }

  //api: Sg File Upload
  Future<Object?> apiSGFileUpload(
      filePath, BuildContext context, String route, String type,
      {String? fileName}) async {
    String? userToken;
    apiLoader(context);
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    FormData? formData;
    if (kIsWeb) {
      formData = FormData.fromMap({
        "file": await MultipartFile.fromBytes(
          filePath,
          filename: fileName,
        ),
      });
    } else {
      formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      });
    }

    Response response = await networkProvider.call(
      method: Method.POST,
      body: formData,
      pathUrl: AppUrl.pathSGFiledUpload + "/$type",
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    MyApp.navigatorKey.currentState!.pop();
    if (response.statusCode == HttpStatus.ok) {
      OtpVerifyResponse otpVerifyResponse =
          OtpVerifyResponse.fromJson(response.data);

      if (otpVerifyResponse.success == true) {
        documentID = otpVerifyResponse.documentId ?? "";
        route.isEmpty ? null : Navigator.pushNamed(context, route);
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  //api: HK File Upload
  Future<Object?> apiHKFileUpload(
      filePath, BuildContext context, String filename) async {
    String? userToken;
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    FormData? formData;
    if (kIsWeb) {
      formData = FormData.fromMap({
        "file": await MultipartFile.fromBytes(
          filePath,
          filename: "image",
        ),
      });
    } else {
      formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      });
    }

    Response response = await networkProvider.call(
      method: Method.POST,
      body: formData,
      pathUrl: AppUrl.pathHKFiledUpload,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    ErrorString errorString = ErrorString.fromJson(response.data);
    if (response.statusCode == HttpStatus.ok) {
      OtpVerifyResponse otpVerifyResponse =
          OtpVerifyResponse.fromJson(response.data);

      if (otpVerifyResponse.success == true) {
        documentID = otpVerifyResponse.path ?? "";
      }
      return otpVerifyResponse;
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  //api: SingPass Verify
  Future<Object?> apiSingPassVerify(
      SingPassCodeRequest requestedParams, BuildContext context) async {
    String? userToken;
    apiLoader(context);
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      body: jsonEncode(requestedParams.toJson()),
      pathUrl: AppUrl.pathSingPassVerify,
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    MyApp.navigatorKey.currentState!.pop();
    ErrorString errorString = ErrorString.fromJson(response.data);
    if (response.statusCode == HttpStatus.ok) {
      final result = json.decode(response.toString());
      bool status = result["success"];
      if (status == true) {
        return true;
      } else {
        return false;
      }
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  //api: Jumio Callback
  Future<Object?> jumioCallBack(String ref, BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.jumioCallback + "?ref=$ref",
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    ErrorString errorString = ErrorString.fromJson(response.data);
    if (response.statusCode == HttpStatus.ok) {
      final result = json.decode(response.toString());

      bool status = result["success"];
      return status;
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  //api: Personal Details SG
  Future<Object?> apiJumioVerification(
      bool selfie, String otp, BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    apiLoader(context);
    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.jumioCallbackUpdated,
      body: jsonEncode({"selfie": selfie, "otp": otp}),
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    ErrorString errorString = ErrorString.fromJson(response.data);

    if (response.statusCode == HttpStatus.ok) {
      JumioVerificationResponse jumioVerificationResponse =
          JumioVerificationResponse.fromJson(response.data);
      return jumioVerificationResponse;
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  //api: Edit Profile
  Future<Object?> apiEditProfile(BuildContext context) async {
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    apiLoader(context);
    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathEditProfile,
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    MyApp.navigatorKey.currentState!.maybePop();

    if (response.statusCode == HttpStatus.ok) {
      EditProfileResponse editProfileResponse =
          EditProfileResponse.fromJson(response.data);
      editProfileResponseData = editProfileResponse;
      return editProfileResponse;
    } else {
      ErrorString errorString = ErrorString.fromJson(response.data);
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  //api: getCustomerDetails
  Future<CustomerDetailsResponse> getCustomerDetails(
      BuildContext context, String contactId) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
        method: Method.GET,
        pathUrl: AppUrl.getAusCustomerDetails + "$contactId",
        headers: buildDefaultHeaderWithToken(userToken!),
        australia: true);

    if (response.statusCode == HttpStatus.ok) {
      CustomerDetailsResponse customerDetailsResponse =
          customerDetailsResponseFromJson(response.toString());

      return customerDetailsResponse;
    } else {
      return customerDetailsResponseFromJson(response.data);
    }
  }

  //api: Get Profile Details Australia
  Future<Object?> apiProfileDetails(BuildContext context) async {
    String? userToken;
    int? contactId;

    await SharedPreferencesMobileWeb.instance
        .getContactId(apiContactId)
        .then((value) {
      contactId = value;
    });

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.getProfileDetails + contactId.toString(),
      headers: buildDefaultHeaderWithToken(userToken!),
      australia: true,
    );
    ErrorString errorString = ErrorString.fromJson(response.data);
    if (response.statusCode == HttpStatus.ok) {
      GetProfileValues getProfileValues =
          GetProfileValues.fromJson(response.data);
      return getProfileValues;
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  //api: Address OTP SG
  Future<Object?> apiAddressVerifySG(
      BuildContext context, String finNRICNumber, String finNRICExpiry) async {
    String? userToken;
    final input = {
      "finNRICNumber": finNRICNumber,
      "finNRICExpiry": finNRICExpiry,
      "documentId": documentID,
    };
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      body: jsonEncode(input),
      pathUrl: AppUrl.pathAddressVerificationSg,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    ErrorString errorString = ErrorString.fromJson(response.data);

    if (response.statusCode == HttpStatus.ok) {
      CommonResponse commonResponse = CommonResponse.fromJson(response.data);
      if (commonResponse.success == true) {
      } else {
        showMessageDialog(context,
            commonResponse.message ?? AppConstants.somethingWentWrongMessage);
      }
      return commonResponse.success;
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  //api: Address OTP HK
  Future<Object?> apiAddressVerifyHK(
      BuildContext context, String finNRICNumber, String finNRICExpiry) async {
    String? userToken;
    final input = {
      "path": documentID,
      "refNo": finNRICNumber,
      "issueDate": finNRICExpiry,
      "id": "3ca162da-417c-11e9-b210-d663bd873d93",
    };
    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      body: jsonEncode(input),
      pathUrl: AppUrl.pathPersonalDetailsStep2HK,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    ErrorString errorString = ErrorString.fromJson(response.data);

    if (response.statusCode == HttpStatus.ok) {
      CommonResponse commonResponse = CommonResponse.fromJson(response.data);
      return commonResponse;
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  //api: Address Verification HK
  Future<Response> getAddressVerificationDetailsHK(
    BuildContext context,
  ) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathPersonalDetailsStep2HK,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      return response;
    } else {
      return response;
    }
  }

  //api: OTP Verify HK
  Future<Object?> apiOtpVerifyHK(
    String OTP,
    BuildContext context,
  ) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      body: OTP,
      pathUrl: AppUrl.pathHKVerifyOTP,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    ErrorString errorString = ErrorString.fromJson(response.data);
    if (response.statusCode == HttpStatus.ok) {
      OtpVerifyResponse otpVerifyResponse =
          OtpVerifyResponse.fromJson(response.data);
      return otpVerifyResponse.success;
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  // api : DocumentList SG
  Future<Object?> apiDocumentListSg(BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathDocumentList,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      List<DocumentListResponse> documentListResponse =
          documentListResponseFromJson(jsonEncode(response.data));
      return documentListResponse;
    } else {
      return response.data["error"];
    }
  }

  // api : DocumentList AU
  Future<Object?> apiDocumentListHk(BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathDocumentListHk,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      List<DocumentListResponse> documentListResponse =
          documentListResponseFromJson(jsonEncode(response.data));
      return documentListResponse;
    } else {
      return response.data;
    }
  }

  Future<Object?> apiViewDocument(
      String documentIdData, BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    try {
      final documentId = documentIdData;
      var url = Uri.encodeFull(
          "${AppUrl.baseHttp}${AppUrl.baseHost}${AppUrl.pathViewDocument}${documentId}");
      apiLoader(context);
      Response response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          headers: <String, dynamic>{
            'Content-Type': 'application/json',
            "Authorization": 'Bearer ${userToken}'
          },
        ),
      );
      MyApp.navigatorKey.currentState!.maybePop();
      String base64String = base64Encode(response.data);

      String getBase64FileExtension(String base64String) {
        switch (base64String.characters.first) {
          case '/':
            documentType = "jpeg";
            return "jpeg";
          case 'i':
            documentType = "png";
            return 'png';
          case 'R':
            documentType = "gif";
            return 'gif';
          case 'U':
            documentType = "webp";
            return 'webp';
          case 'J':
            documentType = "pdf";
            return 'pdf';
          default:
            documentType = "unknown";
            return 'unknown';
        }
      }

      getBase64FileExtension(base64String);

      return response.data;
    } catch (value) {

    }
  }

  Future<Object?> apiViewDocumentHk(
      String documentIdData, BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    try {
      final documentId = documentIdData;
      var url = Uri.encodeFull(
          "${AppUrl.baseHttp}${AppUrl.baseHost}${AppUrl.pathViewDocumentHk}${documentId}");
      Response response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          headers: <String, dynamic>{
            'Content-Type': 'application/json',
            "Authorization": 'Bearer ${userToken}'
          },
        ),
      );
      String base64String = base64Encode(response.data);

      String getBase64FileExtension(String base64String) {
        switch (base64String.characters.first) {
          case '/':
            documentType = "jpeg";
            return "jpeg";
          case 'i':
            documentType = "png";
            return 'png';
          case 'R':
            documentType = "gif";
            return 'gif';
          case 'U':
            documentType = "webp";
            return 'webp';
          case 'J':
            documentType = "pdf";
            return 'pdf';
          default:
            documentType = "unknown";
            return 'unknown';
        }
      }

      getBase64FileExtension(base64String);

      return response.data;
    } catch (value) {

    }
  }
}
