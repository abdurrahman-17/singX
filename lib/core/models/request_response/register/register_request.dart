// To parse this JSON data, do
//
//     final registerRequest = registerRequestFromJson(jsonString);

import 'dart:convert';

RegisterRequest registerRequestFromJson(String str) => RegisterRequest.fromJson(json.decode(str));

String registerRequestToJson(RegisterRequest data) => json.encode(data.toJson());

class RegisterRequest {
  RegisterRequest({
    this.source,
    this.email,
    this.mobile,
    this.password,
    this.promoCode,
    this.entrySource,
    this.marketingFlag,
    this.termsFlag,
    this.utmMedium,
    this.utmSource,
    this.utmCampaign,
    this.utmTerm,
    this.utmContent,
  });

  String? source;
  String? email;
  String? mobile;
  String? password;
  String? promoCode;
  String? entrySource;
  bool? marketingFlag;
  bool? termsFlag;
  String? utmMedium;
  String? utmSource;
  String? utmCampaign;
  String? utmTerm;
  String? utmContent;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => RegisterRequest(
    source: json["source"] == null ? null : json["source"],
    email: json["email"] == null ? null : json["email"],
    mobile: json["mobile"] == null ? null : json["mobile"],
    password: json["password"] == null ? null : json["password"],
    promoCode: json["promoCode"] == null ? null : json["promoCode"],
    entrySource: json["entrySource"] == null ? null : json["entrySource"],
    marketingFlag: json["marketingFlag"] == null ? null : json["marketingFlag"],
    termsFlag: json["termsFlag"] == null ? null : json["termsFlag"],
    utmMedium: json["utm_medium"] == null ? null : json["utm_medium"],
    utmSource: json["utm_source"] == null ? null : json["utm_source"],
    utmCampaign: json["utm_campaign"] == null ? null : json["utm_campaign"],
    utmTerm: json["utm_term"] == null ? null : json["utm_term"],
    utmContent: json["utm_content"] == null ? null : json["utm_content"],
  );

  Map<String, dynamic> toJson() => {
    "source": source == null ? null : source,
    "email": email == null ? null : email,
    "mobile": mobile == null ? null : mobile,
    "password": password == null ? null : password,
    "promoCode": promoCode == null ? null : promoCode,
    "entrySource": entrySource == null ? null : entrySource,
    "marketingFlag": marketingFlag == null ? null : marketingFlag,
    "termsFlag": termsFlag == null ? null : termsFlag,
    "utm_medium": utmMedium == null ? null : utmMedium,
    "utm_source": utmSource == null ? null : utmSource,
    "utm_campaign": utmCampaign == null ? null : utmCampaign,
    "utm_term": utmTerm == null ? null : utmTerm,
    "utm_content": utmContent == null ? null : utmContent,
  };
}
