import 'dart:convert';

ChangePasswordResponseAUS changePasswordResponseFromJson(String str) => ChangePasswordResponseAUS.fromJson(json.decode(str));

String changePasswordResponseToJson(ChangePasswordResponseAUS data) => json.encode(data.toJson());

class ChangePasswordResponseAUS {
  ChangePasswordResponseAUS({
    this.success,
    this.message,
  });

  bool? success;
  String? message;

  factory ChangePasswordResponseAUS.fromJson(Map<String, dynamic> json) => ChangePasswordResponseAUS(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
  };
}
