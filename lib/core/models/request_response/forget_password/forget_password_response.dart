import 'dart:convert';

ForgetPasswordResponse forgetPasswordResponseFromJson(String str) => ForgetPasswordResponse.fromJson(json.decode(str));

String forgetPasswordResponseToJson(ForgetPasswordResponse data) => json.encode(data.toJson());

class ForgetPasswordResponse {
  ForgetPasswordResponse({
    this.success,
    this.message,
  });

  bool? success;
  String? message;

  factory ForgetPasswordResponse.fromJson(Map<String, dynamic> json) => ForgetPasswordResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
  };
}
