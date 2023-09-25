// To parse this JSON data, do
//
//     final singpassCodeRequest = singpassCodeRequestFromJson(jsonString);

import 'dart:convert';

SingPassCodeRequest singpassCodeRequestFromJson(String str) => SingPassCodeRequest.fromJson(json.decode(str));

String singpassCodeRequestToJson(SingPassCodeRequest data) => json.encode(data.toJson());

class SingPassCodeRequest {
  SingPassCodeRequest({
    this.code,
    this.state,
    // this.apiId,
  });

  String? code;
  String? state;
  // String? apiId;

  factory SingPassCodeRequest.fromJson(Map<String, dynamic> json) => SingPassCodeRequest(
    code: json["code"] == null ? null : json["code"],
    state: json["state"] == null ? null : json["state"],
    // apiId: json["apiId"] == null ? null : json["apiId"],
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "state": state == null ? null : state,
    // "apiId": apiId == null ? null : apiId,
  };
}
