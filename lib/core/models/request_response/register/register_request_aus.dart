// To parse this JSON data, do
//
//     final registerAustraliaRequest = registerAustraliaRequestFromJson(jsonString);

import 'dart:convert';

RegisterAustraliaRequest registerAustraliaRequestFromJson(String str) => RegisterAustraliaRequest.fromJson(json.decode(str));

String registerAustraliaRequestToJson(RegisterAustraliaRequest data) => json.encode(data.toJson());

class RegisterAustraliaRequest {
  RegisterAustraliaRequest({
    this.channelCode,
    this.countryCode,
    this.emailId,
    this.marketCommunications,
    this.mobileNumber,
    this.password,
    this.registeredCountry,
    this.termCondition,
    this.utmMedium,
    this.utmSource,
    this.utmCampaign,
    this.utmTerm,
    this.utmContent,
  });

  String? channelCode;
  String? countryCode;
  String? emailId;
  bool? marketCommunications;
  int? mobileNumber;
  String? password;
  String? registeredCountry;
  bool? termCondition;
  dynamic utmMedium;
  dynamic utmSource;
  dynamic utmCampaign;
  dynamic utmTerm;
  dynamic utmContent;

  factory RegisterAustraliaRequest.fromJson(Map<String, dynamic> json) => RegisterAustraliaRequest(
    channelCode: json["channelCode"] == null ? null : json["channelCode"],
    countryCode: json["countryCode"] == null ? null : json["countryCode"],
    emailId: json["emailId"] == null ? null : json["emailId"],
    marketCommunications: json["marketCommunications"] == null ? null : json["marketCommunications"],
    mobileNumber: json["mobileNumber"] == null ? null : json["mobileNumber"],
    password: json["password"] == null ? null : json["password"],
    registeredCountry: json["registeredCountry"] == null ? null : json["registeredCountry"],
    termCondition: json["termCondition"] == null ? null : json["termCondition"],
    utmMedium: json["utmMedium"],
    utmSource: json["utmSource"],
    utmCampaign: json["utmCampaign"],
    utmTerm: json["utmTerm"],
    utmContent: json["utmContent"],
  );

  Map<String, dynamic> toJson() => {
    "channelCode": channelCode == null ? null : channelCode,
    "countryCode": countryCode == null ? null : countryCode,
    "emailId": emailId == null ? null : emailId,
    "marketCommunications": marketCommunications == null ? null : marketCommunications,
    "mobileNumber": mobileNumber == null ? null : mobileNumber,
    "password": password == null ? null : password,
    "registeredCountry": registeredCountry == null ? null : registeredCountry,
    "termCondition": termCondition == null ? null : termCondition,
    "utmMedium": utmMedium,
    "utmSource": utmSource,
    "utmCampaign": utmCampaign,
    "utmTerm": utmTerm,
    "utmContent": utmContent,
  };
}
