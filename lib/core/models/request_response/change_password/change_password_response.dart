import 'dart:convert';

ChangePasswordResponse changePasswordResponseFromJson(String str) => ChangePasswordResponse.fromJson(json.decode(str));

String changePasswordResponseToJson(ChangePasswordResponse data) => json.encode(data.toJson());

class ChangePasswordResponse {
  ChangePasswordResponse({
    this.success,
    this.message,
  });

  bool? success;
  String? message;

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) => ChangePasswordResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
  };
}
