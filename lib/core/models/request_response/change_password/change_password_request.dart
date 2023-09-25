import 'dart:convert';

ChangePasswordRequest changePasswordRequestFromJson(String str) => ChangePasswordRequest.fromJson(json.decode(str));

String changePasswordRequestToJson(ChangePasswordRequest data) => json.encode(data.toJson());

class ChangePasswordRequest {
  ChangePasswordRequest({
    this.oldPassword,
    this.newPassword,
  });

  String? oldPassword;
  String? newPassword;

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) => ChangePasswordRequest(
    oldPassword: json["oldPassword"] == null ? null : json["oldPassword"],
    newPassword: json["newPassword"] == null ? null : json["newPassword"],
  );

  Map<String, dynamic> toJson() => {
    "oldPassword": oldPassword == null ? null : oldPassword,
    "newPassword": newPassword == null ? null : newPassword,
  };
}
