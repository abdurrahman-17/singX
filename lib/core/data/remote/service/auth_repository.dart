import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:singx/core/data/remote/network/app_url.dart';
import 'package:singx/core/data/remote/network/method.dart';
import 'package:singx/core/data/remote/service/base/base_repository.dart';
import 'package:singx/core/models/request_response/australia/change_password/change_password_request.dart';
import 'package:singx/core/models/request_response/australia/customer_status/customer_status_response.dart';
import 'package:singx/core/models/request_response/australia/save_session/save_session_request.dart';
import 'package:singx/core/models/request_response/auth_detail/auth_detail_response.dart';
import 'package:singx/core/models/request_response/change_password/change_password_request.dart';
import 'package:singx/core/models/request_response/change_password/change_password_response.dart';
import 'package:singx/core/models/request_response/common_response.dart';
import 'package:singx/core/models/request_response/digi_verify_send_step_2/digi_verify_send_request_step_2.dart';
import 'package:singx/core/models/request_response/digital_verification_step_2_aus/digital_verification_step_2_aus_response.dart';
import 'package:singx/core/models/request_response/edit_profile/edit_profile_response.dart';
import 'package:singx/core/models/request_response/error_response.dart';
import 'package:singx/core/models/request_response/forget_password/forget_password_request.dart';
import 'package:singx/core/models/request_response/forget_password/forget_password_response.dart';
import 'package:singx/core/models/request_response/forget_password/forget_password_step2_request.dart';
import 'package:singx/core/models/request_response/forget_password/forget_password_step2_response.dart';
import 'package:singx/core/models/request_response/login/login_request.dart';
import 'package:singx/core/models/request_response/login/login_request_aus.dart';
import 'package:singx/core/models/request_response/login/login_response.dart';
import 'package:singx/core/models/request_response/login/login_response_aus.dart';
import 'package:singx/core/models/request_response/otp_verify/otp_verify_response.dart';
import 'package:singx/core/models/request_response/refresh_token/refresh_token_response.dart';
import 'package:singx/core/models/request_response/register/register_request.dart';
import 'package:singx/core/models/request_response/register/register_request_aus.dart';
import 'package:singx/core/models/request_response/register/register_response.dart';
import 'package:singx/core/models/request_response/register/register_response_aus.dart';
import 'package:singx/core/notifier/common_notifier.dart';
import 'package:singx/core/notifier/register_notifier.dart';
import 'package:singx/main.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/app_route_paths.dart';
import 'package:singx/utils/common/app_widgets.dart';
import 'package:singx/utils/common/drop_zone.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';
import 'contact_repository.dart';

class AuthRepository extends BaseRepository {
  AuthRepository._internal();

  static final AuthRepository _singleInstance = AuthRepository._internal();

  factory AuthRepository() => _singleInstance;

  String loginErrorMessage = "";

  String get ErrorMessageGet => loginErrorMessage;

  set ErrorMessageGet(String value) {
    if (value == loginErrorMessage) return;
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

  CustomerStatusResponse data = CustomerStatusResponse();

  String ErrorMessage = "";

  String get ErrorMessageResponse => ErrorMessage;

  set ErrorMessageResponse(String value) {
    if (value == ErrorMessage) return;
    ErrorMessage = value;
    notifyListeners();
  }

  //api: Logins
  Future<Object?> apiUserLogin(LoginRequest requestParams, BuildContext context,
      {bool? loginWithoutNavigation}) async {
    loginWithoutNavigation == true ? null : apiLoader(context);
    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathLogin,
      body: jsonEncode(requestParams.toJson()),
      headers: headerContentTypeAndAccept,
    );
    ErrorString errorString = ErrorString.fromJson(response.data);

    if (response.statusCode == HttpStatus.ok) {
      loginWithoutNavigation == true ? null : MyApp.navigatorKey.currentState!.maybePop();
      LoginResponse loginResponse =
          loginResponseFromJson(jsonEncode(response.data));
      if (loginResponse.success == true) {
        loginWithoutNavigation == true
            ? null
            : Provider.of<CommonNotifier>(context, listen: false)
                .updateUserVerifiedBool = true;
        loginWithoutNavigation == true
            ? null
            : SharedPreferencesMobileWeb.instance.setUserVerified(true);
        await SharedPreferencesMobileWeb.instance
            .setUserData(AppConstants.user, loginResponse);
        await SharedPreferencesMobileWeb.instance
            .setAccessToken(apiToken, loginResponse.token!);
        await SharedPreferencesMobileWeb.instance
            .setUserName(userName, loginResponse.userinfo!.firstName!);
        await ContactRepository().apiEditProfile(context).then((value) async {
          EditProfileResponse responseData = value as EditProfileResponse;
          await SharedPreferencesMobileWeb.instance
              .setUserName(userName, responseData.firstName!);
          CommonNotifier().setAppBarName();
        });

        loginWithoutNavigation == true
            ? null
            : RegisterNotifier(context).getVerifiedStatus(context);
      }
    } else {
      MyApp.navigatorKey.currentState!.maybePop();
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  //australia login
  Future<Object?> apiUserLoginAustralia(
      LoginAustraliaRequest requestParams, BuildContext context) async {
    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathLoginAustralia,
      body: jsonEncode(requestParams.toJson()),
      headers: headerContentTypeAndAcceptAUS,
      australia: true,
    );
    ErrorString errorString = ErrorString.fromJson(response.data);

    if (response.statusCode == HttpStatus.ok) {
      LoginAustraliaResponse loginResponse =
          LoginAustraliaResponse.fromJson(response.data);

      await SharedPreferencesMobileWeb.instance
          .setAccessToken(apiToken, loginResponse.token!);
      await SharedPreferencesMobileWeb.instance
          .setContactId(apiContactId, loginResponse.contactId!);
      await SharedPreferencesMobileWeb.instance
          .getAccessToken(apiToken)
          .then((value) {});
      apiCustomerStatus(loginResponse.contactId, context).then((value) async {
        CustomerStatusResponse customerStatusResponse =
            value as CustomerStatusResponse;

        if (customerStatusResponse.statusId == 10000000) {
          await SharedPreferencesMobileWeb.instance
              .getCountry(country)
              .then((value) async {
            Provider.of<CommonNotifier>(context, listen: false)
                .updateUserVerifiedBool = false;
            SharedPreferencesMobileWeb.instance.setUserVerified(false);
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamedAndRemoveUntil(
                context,
                dashBoardRoute,
                (route) => false,
              );
            });
          });
        } else if (customerStatusResponse.statusId == 10000001) {
          await SharedPreferencesMobileWeb.instance
              .getCountry(country)
              .then((value) async {
            Provider.of<CommonNotifier>(context, listen: false)
                .updateUserVerifiedBool = false;
            SharedPreferencesMobileWeb.instance.setUserVerified(false);
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamedAndRemoveUntil(
                context,
                dashBoardRoute,
                (route) => false,
              );
            });
          });
        } else if (customerStatusResponse.statusId == 10000002) {
          await SharedPreferencesMobileWeb.instance
              .getCountry(country)
              .then((value) async {
            Provider.of<CommonNotifier>(context, listen: false)
                .updateUserVerifiedBool = false;
            SharedPreferencesMobileWeb.instance.setUserVerified(false);
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamedAndRemoveUntil(
                context,
                dashBoardRoute,
                (route) => false,
              );
            });
          });
        } else if (customerStatusResponse.statusId == 10000003) {
          await SharedPreferencesMobileWeb.instance
              .getCountry(country)
              .then((value) async {
            Provider.of<CommonNotifier>(context, listen: false)
                .updateUserVerifiedBool = false;
            SharedPreferencesMobileWeb.instance.setUserVerified(false);
            await SharedPreferencesMobileWeb.instance
                .getCountry(country)
                .then((value) async {
              Navigator.pushNamedAndRemoveUntil(
                context,
                dashBoardRoute,
                (route) => false,
              );
            });
          });
        } else if (customerStatusResponse.statusId == 10000004 ||
            customerStatusResponse.statusId == 10000005) {
          Provider.of<CommonNotifier>(context, listen: false)
              .updateUserVerifiedBool = false;
          SharedPreferencesMobileWeb.instance.setUserVerified(false);
          await SharedPreferencesMobileWeb.instance
              .getCountry(country)
              .then((value) async {
            Navigator.pushNamedAndRemoveUntil(
              context,
              dashBoardRoute,
              (route) => false,
            );
          });
        } else if (customerStatusResponse.statusId == 10000009 ||
            customerStatusResponse.statusId == 10000010 ||
            customerStatusResponse.statusId == 10000011) {
          Provider.of<CommonNotifier>(context, listen: false)
              .updateUserVerifiedBool = true;
          SharedPreferencesMobileWeb.instance.setUserVerified(true);
          await SharedPreferencesMobileWeb.instance
              .getCountry(country)
              .then((value) async {
            Navigator.pushNamedAndRemoveUntil(
              context,
              dashBoardRoute,
              (route) => false,
            );
          });
        } else if (customerStatusResponse.statusId == 10000012 ||
            customerStatusResponse.statusId == 10000013) {
          Provider.of<CommonNotifier>(context, listen: false)
              .updateUserVerifiedBool = false;
          SharedPreferencesMobileWeb.instance.setUserVerified(false);
          await SharedPreferencesMobileWeb.instance
              .getCountry(country)
              .then((value) async {
            Navigator.pushNamedAndRemoveUntil(
              context,
              dashBoardRoute,
              (route) => false,
            );
          });
        } else if (customerStatusResponse.statusId == 10000014) {
          Provider.of<CommonNotifier>(context, listen: false)
              .updateUserVerifiedBool = true;
          SharedPreferencesMobileWeb.instance.setUserVerified(true);

          await SharedPreferencesMobileWeb.instance
              .getCountry(country)
              .then((value) async {
            Navigator.pushNamedAndRemoveUntil(
              context,
              dashBoardRoute,
              (route) => false,
            );
          });
        }
      });
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  //api: Register
  Future<Object?> apiUserRegister(RegisterRequest requestParams,
      BuildContext context, String source) async {
    apiLoader(context);
    Response response = await networkProvider.call(
        method: Method.POST,
        pathUrl: AppUrl.pathRegister,
        body: jsonEncode(requestParams.toJson()),
        headers: headerContentTypeAndAccept);

    if (response.statusCode == HttpStatus.ok) {
      RegisterResponse registerResponse =
          RegisterResponse.fromJson(response.data);
      MyApp.navigatorKey.currentState!.maybePop();

      if (registerResponse.success == true) {
        Provider.of<CommonNotifier>(context, listen: false)
            .updateLoginData(false);
        await apiUserLogin(
            LoginRequest(
                source: '$source',
                username: requestParams.email,
                password: requestParams.password),
            context,
            loginWithoutNavigation: true);

        //Navigation to register flow
        SharedPreferencesMobileWeb.instance.getCountry(country).then((value) {
          value == AppConstants.hongKong
              ? Navigator.pushNamed(context, registerHongKongHomeScreen)
              : value == AppConstants.australia
                  ? Navigator.pushNamed(context, registerHongKongHomeScreen)
                  : Navigator.pushNamed(context, registerMethodRoute);
        });
      } else {
        return registerResponse.message;
      }
    } else {
      response.statusCode == 400 ? MyApp.navigatorKey.currentState!.pop() : null;
      ErrorMessageGet = response.data["errors"][0];
      return ErrorMessageGet;
    }
  }

  //api: Forget Password
  Future<Object?> apiForgetPassword(
      ForgetPasswordRequest requestParams, BuildContext context) async {
    apiLoader(context);
    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathForgetPassword,
      body: jsonEncode(requestParams.toJson()),
      headers: headerContentTypeAndAccept,
    );

    MyApp.navigatorKey.currentState!.pop();
    ErrorMessageGet = "";
    if (response.statusCode == HttpStatus.ok) {
      ForgetPasswordResponse forgetResponse =
          ForgetPasswordResponse.fromJson(response.data);
      if (forgetResponse.success == true) {
        return "";
      } else {
        ErrorMessageGet = forgetResponse.message!;
        return forgetResponse.message;
      }
    } else {
      ErrorString errorString = ErrorString.fromJson(response.data);
      return errorString.error;
    }
  }

  //api: Forget Password Step 2
  Future<Object?> apiForgetPasswordStep2(
      ForgetPasswordStep2Request requestParams, BuildContext context) async {
    ;

    apiLoader(context);

    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathForgetPasswordStep2,
      body: jsonEncode(requestParams.toJson()),
      headers: headerContentTypeAndAccept,
    );
    MyApp.navigatorKey.currentState!.maybePop();
    ForgetPasswordStep2Response forgetResponse =
        ForgetPasswordStep2Response.fromJson(response.data);
    if (response.statusCode == HttpStatus.ok) {
      if (forgetResponse.success == true) {
        await SharedPreferencesMobileWeb.instance
            .getCountry(country)
            .then((value) async {
          Navigator.pushNamed(context, resetPasswordSuccess);
        });
      } else {
        ErrorMessageGet = forgetResponse.message!;
        return forgetResponse.message;
      }
    } else {
      return forgetResponse.message;
    }
  }

  //api: Refresh Token
  Future<Object?> apiRefreshToken() async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathRefreshToken,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      RefreshTokenResponse forgetResponse =
          RefreshTokenResponse.fromJson(response.data);
      await SharedPreferencesMobileWeb.instance
          .setAccessToken(apiToken, forgetResponse.token!);
    } else {
      return RefreshTokenResponse.fromJson(response.data);
    }
  }

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
      pathUrl: AppUrl.pathLogout,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      SharedPreferencesMobileWeb.instance.removeParticularKey(dashboardCalc);
      SharedPreferencesMobileWeb.instance.removeParticularKey(apiToken);
      Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
    } else {
      return RefreshTokenResponse.fromJson(response.data);
    }
  }

  //api: Change Password
  Future<Object?> apiChangePassword(
      ChangePasswordRequest requestParams, BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathChangePassword,
      body: jsonEncode(requestParams.toJson()),
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    ErrorString errorString = ErrorString.fromJson(response.data);
    if (response.statusCode == HttpStatus.ok) {
      ChangePasswordResponse changePasswordResponse =
          ChangePasswordResponse.fromJson(response.data);
      if (changePasswordResponse.success == true) {
        await SharedPreferencesMobileWeb.instance
            .getCountry(country)
            .then((value) async {
          Navigator.pushNamedAndRemoveUntil(
              context, dashBoardRoute, (route) => false);
        });
        successAlertDialog(context);
      } else {
        return changePasswordResponse.message!;
      }
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  //api: Detail
  Future<String?> apiAuthDetail(BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.pathAuthDetail,
      headers: buildDefaultHeaderWithToken(userToken!),
    );

    if (response.statusCode == HttpStatus.ok) {
      AuthDetailResponse authDetailResponse =
          AuthDetailResponse.fromJson(response.data);
      return authDetailResponse.status;
    } else {
      AuthDetailResponse.fromJson(response.data);
      return "";
    }
  }

  //Australia

  //api: Register AUS
  Future<Object?> apiUserRegisterAus(
      RegisterAustraliaRequest requestParams, BuildContext context) async {
    apiLoader(context);
    Response response = await networkProvider.call(
        method: Method.POST,
        pathUrl: AppUrl.pathRegisterAus,
        body: jsonEncode(requestParams.toJson()),
        headers: headerContentTypeAndAcceptAUS,
        australia: true);

    RegisterAustraliaResponse registerAustraliaResponse =
        RegisterAustraliaResponse.fromJson(response.data);
    MyApp.navigatorKey.currentState!.maybePop();
    if (response.statusCode == HttpStatus.ok) {
      await SharedPreferencesMobileWeb.instance
          .setAccessToken(apiToken, registerAustraliaResponse.token!);
      await SharedPreferencesMobileWeb.instance
          .setContactId(apiContactId, registerAustraliaResponse.contactId!);
      SharedPreferencesMobileWeb.instance.getCountry(country).then((value) {
        value == AppConstants.hongKong
            ? Navigator.pushNamed(context, registerHongKongHomeScreen)
            : value == AppConstants.australia
                ? Navigator.pushNamed(context, registerHongKongHomeScreen)
                : Navigator.pushNamed(context, registerMethodRoute);
      });
    } else {
      ErrorString errorString = ErrorString.fromJson(response.data);
      return errorString.error;
    }
  }

  //api: Digital Verification Get Data
  Future<Object?> apiDigitalVerificationGetData() async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: AppUrl.getDigitalVerificationStep2,
      australia: true,
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    if (response.statusCode == HttpStatus.ok) {
      DigitalVerificationStepTwoResponseAus
          digitalVerificationStepTwoResponseAus =
          DigitalVerificationStepTwoResponseAus.fromJson(response.data);
      return digitalVerificationStepTwoResponseAus;
    } else {
      return RefreshTokenResponse.fromJson(response.data);
    }
  }

  //api: Digital Verification Save Data
  Future<Object?> apiDigitalVerificationSaveData(
      DigiVerifyStepTwoRequestSendAus requestParams,
      BuildContext context) async {
    String? userToken;
    int? contactId;
    apiVerificationLoader(context);

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
        method: Method.POST,
        pathUrl: AppUrl.saveCRA,
        body: jsonEncode(requestParams.toJson()),
        headers: buildDefaultHeaderWithToken(userToken!),
        australia: true);

    MyApp.navigatorKey.currentState!.maybePop();
    if (response.statusCode == HttpStatus.ok) {
      return response;
    } else {
      ErrorMessageGet = ErrorList.fromJson(response.data).errors!.first;
      return ErrorList.fromJson(response.data).errors!.isEmpty
          ? ""
          : ErrorList.fromJson(response.data).errors!.first;
    }
  }

  //api: Non CRA File Upload
  Future<Object?> apiNonCRAFileUpload(filePath, fileName, BuildContext context,
      {bool? navigate}) async {
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
    apiLoader(context);
    var formData = FormData();
    if (kIsWeb) {
      List<File_Data_Model> filePaths = filePath;
      for (int i = 0; i < filePaths.length; i++) {
        formData.files.add(
          MapEntry(
            "file",
            await MultipartFile.fromBytes(filePaths[i].path,
                filename: filePaths[i].name,
                contentType: MediaType(
                    filePaths[i].name.split(".").last == "pdf"
                        ? "application"
                        : "image",
                    "${filePaths[i].name.split(".").last}")),
          ),
        );
      }
    } else {
      List<File> filePaths = filePath;
      for (int i = 0; i < filePaths.length; i++) {
        formData.files.add(
          MapEntry(
            "file",
            await MultipartFile.fromFile(filePaths[i].path,
                filename: filePaths[i].path.split("/").last,
                contentType: MediaType(
                    filePaths[i].path.split(".").last == "pdf"
                        ? "application"
                        : "image",
                    "${filePaths[i].path.split(".").last}")),
          ),
        );
      }
    }
    Response response = await networkProvider.call(
      method: Method.POST,
      body: formData,
      australia: true,
      pathUrl: AppUrl.nonCRAFileUpload + "?contactId=$contactId",
      headers: buildDefaultHeaderWithToken(userToken!),
    );
    Navigator.pop(context);
    if (response.statusCode == HttpStatus.ok) {
      OtpVerifyResponse otpVerifyResponse =
          OtpVerifyResponse.fromJson(response.data);
      if (otpVerifyResponse.success == true) {
        Provider.of<CommonNotifier>(context, listen: false)
            .updateUserVerifiedBool = false;
        SharedPreferencesMobileWeb.instance.setUserVerified(false);
        Provider.of<CommonNotifier>(context, listen: false)
            .updateUserVerifiedBool = false;
        SharedPreferencesMobileWeb.instance.setUserVerified(false);
        SharedPreferencesMobileWeb.instance
            .setMethodSelectedAUS('methodSelectedAUS', false);
        await SharedPreferencesMobileWeb.instance
            .getCountry(country)
            .then((value) async {
          navigate == true
              ? MyApp.navigatorKey.currentState!.pushNamedAndRemoveUntil(
                  dashBoardRoute, (route) => false)
              : null;
        });
      }
    } else {
      return RefreshTokenResponse.fromJson(response.data);
    }
    return null;
  }

  //api: Change Password
  Future<Object?> apiChangePasswordAus(
      ChangePasswordRequestAUS requestParams, BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });

    Response response = await networkProvider.call(
        method: Method.POST,
        pathUrl: AppUrl.pathChangePasswordAUS,
        body: jsonEncode(requestParams.toJson()),
        headers: buildDefaultHeaderWithToken(userToken!),
        australia: true);

    ErrorString errorString = ErrorString.fromJson(response.data);

    if (response.statusCode == HttpStatus.ok) {
      await SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        Navigator.pushNamedAndRemoveUntil(
          context,
          dashBoardRoute,
          (route) => false,
        );
      });

      successAlertDialog(context);
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }

  Future<Object?> apiCustomerStatus(
      int? contactId, BuildContext context) async {
    String? userToken;

    await SharedPreferencesMobileWeb.instance
        .getAccessToken(apiToken)
        .then((value) {
      userToken = value;
    });
    final input = {
      "contactId": contactId,
    };
    Response response = await networkProvider.call(
        method: Method.POST,
        pathUrl: AppUrl.pathCustomerStatusAUS,
        body: jsonEncode(input),
        headers: buildDefaultHeaderWithToken(userToken!),
        australia: true);
    if (response.statusCode == HttpStatus.ok) {
      CustomerStatusResponse customerStatusResponse =
          CustomerStatusResponse.fromJson(response.data);
      data = customerStatusResponse;
      return data;
    } else {
      return CustomerStatusResponse.fromJson(response.data);
    }
  }

  Future<Object?> apiForgetPasswordAus(
      String requestParams, BuildContext context) async {
    apiLoader(context);
    Response response = await networkProvider.call(
        method: Method.POST,
        pathUrl: AppUrl.pathForgetPasswordAUS,
        body: jsonEncode({'email': requestParams}),
        headers: headerContentTypeAndAccept,
        australia: true);

    MyApp.navigatorKey.currentState!.pop();
    ErrorMessageResponse = "";
    CommonResponse forgetResponse = CommonResponse.fromJson(response.data);
    if (response.statusCode == HttpStatus.ok) {
      CommonResponse forgetResponse = CommonResponse.fromJson(response.data);
      if (forgetResponse.success == true) {
        return "";
      } else {
        ErrorMessageResponse = forgetResponse.message!;
        return forgetResponse.message;
      }
    } else if (response.statusCode == HttpStatus.unauthorized) {
      SharedPreferencesMobileWeb.instance.removeParticularKey(apiToken);
      Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
      return forgetResponse.message;
    } else if (response.statusCode == HttpStatus.badRequest) {
      ErrorString errorString = ErrorString.fromJson(response.data);
      return errorString.error;
    } else if (response.statusCode == HttpStatus.internalServerError) {
      Map newResponse = jsonDecode(response.toString());
      return newResponse["error"];
    } else if (response.statusCode == HttpStatus.notFound) {
      ErrorMessageResponse = ErrorString.fromJson(response.data).error!;
      return ErrorMessageResponse;
    } else if (response.statusCode == HttpStatus.forbidden) {
      await SharedPreferencesMobileWeb.instance
          .getCountry(country)
          .then((value) async {
        Navigator.pushNamedAndRemoveUntil(
            context, accessDeniedRoute, (route) => false);
      });

      return forgetResponse.message;
    } else if (response.statusCode == HttpStatus.unprocessableEntity) {
      return forgetResponse.message;
    } else if (response.statusCode == HttpStatus.badRequest) {
      ErrorMessageResponse = ErrorString.fromJson(response.data).error!;
      return forgetResponse.message;
    } else {
      return null;
    }
  }

  Future<Object?> apiSaveSession(
      SaveSessionRequest requestParams, BuildContext context) async {
    Response response = await networkProvider.call(
        method: Method.POST,
        pathUrl: AppUrl.pathSaveSessionAUS,
        body: jsonEncode(requestParams.toJson()),
        headers: headerContentTypeAndAccept,
        australia: true);

    ErrorMessageResponse = "";

    ErrorString errorString = ErrorString.fromJson(response.data);
    if (response.statusCode == HttpStatus.ok) {
      CommonResponse commonResponse = CommonResponse.fromJson(response.data);
      if (commonResponse.success == true) {
        return "";
      } else {
        ErrorMessageResponse = commonResponse.message!;
        return commonResponse.message;
      }
    } else {
      ErrorMessageGet = errorString.error!;
      return errorString.error;
    }
  }
}
