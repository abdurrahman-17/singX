// To parse this JSON data, do
//
//     final loginAustraliaResponse = loginAustraliaResponseFromJson(jsonString);

import 'dart:convert';

LoginAustraliaResponse loginAustraliaResponseFromJson(String str) => LoginAustraliaResponse.fromJson(json.decode(str));

String loginAustraliaResponseToJson(LoginAustraliaResponse data) => json.encode(data.toJson());

class LoginAustraliaResponse {
  LoginAustraliaResponse({
    this.contactId,
    this.token,
    this.changePasswordNextLogin,
  });

  int? contactId;
  String? token;
  bool? changePasswordNextLogin;

  factory LoginAustraliaResponse.fromJson(Map<String, dynamic> json) => LoginAustraliaResponse(
    contactId: json["contactId"] == null ? null : json["contactId"],
    token: json["token"] == null ? null : json["token"],
    changePasswordNextLogin: json["changePasswordNextLogin"] == null ? null : json["changePasswordNextLogin"],
  );

  Map<String, dynamic> toJson() => {
    "contactId": contactId == null ? null : contactId,
    "token": token == null ? null : token,
    "changePasswordNextLogin": changePasswordNextLogin == null ? null : changePasswordNextLogin,
  };
}
