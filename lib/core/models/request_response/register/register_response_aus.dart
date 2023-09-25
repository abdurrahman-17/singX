// To parse this JSON data, do
//
//     final registerAustraliaResponse = registerAustraliaResponseFromJson(jsonString);

import 'dart:convert';

RegisterAustraliaResponse registerAustraliaResponseFromJson(String str) => RegisterAustraliaResponse.fromJson(json.decode(str));

String registerAustraliaResponseToJson(RegisterAustraliaResponse data) => json.encode(data.toJson());

class RegisterAustraliaResponse {
  RegisterAustraliaResponse({
    this.contactId,
    this.token,
  });

  int? contactId;
  String? token;

  factory RegisterAustraliaResponse.fromJson(Map<String, dynamic> json) => RegisterAustraliaResponse(
    contactId: json["contactId"] == null ? null : json["contactId"],
    token: json["token"] == null ? null : json["token"],
  );

  Map<String, dynamic> toJson() => {
    "contactId": contactId == null ? null : contactId,
    "token": token == null ? null : token,
  };
}
