// To parse this JSON data, do
//
//     final loginAustraliaRequest = loginAustraliaRequestFromJson(jsonString);

import 'dart:convert';

LoginAustraliaRequest loginAustraliaRequestFromJson(String str) => LoginAustraliaRequest.fromJson(json.decode(str));

String loginAustraliaRequestToJson(LoginAustraliaRequest data) => json.encode(data.toJson());

class LoginAustraliaRequest {
  LoginAustraliaRequest({
    this.username,
    this.password,
  });

  String? username;
  String? password;

  factory LoginAustraliaRequest.fromJson(Map<String, dynamic> json) => LoginAustraliaRequest(
    username: json["username"] == null ? null : json["username"],
    password: json["password"] == null ? null : json["password"],
  );

  Map<String, dynamic> toJson() => {
    "username": username == null ? null : username,
    "password": password == null ? null : password,
  };
}
