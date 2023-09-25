// To parse this JSON data, do
//
//     final loginRequest = loginRequestFromJson(jsonString);

import 'dart:convert';

LoginRequest loginRequestFromJson(String str) => LoginRequest.fromJson(json.decode(str));

String loginRequestToJson(LoginRequest data) => json.encode(data.toJson());

class LoginRequest {
  LoginRequest({
    this.username,
    this.password,
    this.source,
  });

  String? username;
  String? password;
  String? source;

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
    username: json["username"] == null ? null : json["username"],
    password: json["password"] == null ? null : json["password"],
    source: json["source"] == null ? null : json["source"],
  );

  Map<String, dynamic> toJson() => {
    "username": username == null ? null : username,
    "password": password == null ? null : password,
    "source": source == null ? null : source,
  };
}
