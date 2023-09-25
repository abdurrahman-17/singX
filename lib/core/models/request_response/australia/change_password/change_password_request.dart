// To parse this JSON data, do
//
//     final changePasswordRequestAustralia = changePasswordRequestAustraliaFromJson(jsonString);

import 'dart:convert';

ChangePasswordRequestAUS changePasswordRequestAustraliaFromJson(String str) => ChangePasswordRequestAUS.fromJson(json.decode(str));

String changePasswordRequestAustraliaToJson(ChangePasswordRequestAUS data) => json.encode(data.toJson());

class ChangePasswordRequestAUS {
  ChangePasswordRequestAUS({
    this.contactId,
    this.oldPassword,
    this.newPassword,
    this.country,
  });

  int? contactId;
  String? oldPassword;
  String? newPassword;
  String? country;

  factory ChangePasswordRequestAUS.fromJson(Map<String, dynamic> json) => ChangePasswordRequestAUS(
    contactId: json["contactId"] == null ? null : json["contactId"],
    oldPassword: json["oldPassword"] == null ? null : json["oldPassword"],
    newPassword: json["newPassword"] == null ? null : json["newPassword"],
    country: json["country"] == null ? null : json["country"],
  );

  Map<String, dynamic> toJson() => {
    "contactId": contactId == null ? null : contactId,
    "oldPassword": oldPassword == null ? null : oldPassword,
    "newPassword": newPassword == null ? null : newPassword,
    "country": country == null ? null : country,
  };
}
