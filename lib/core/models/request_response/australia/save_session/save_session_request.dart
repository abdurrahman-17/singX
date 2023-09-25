// To parse this JSON data, do
//
//     final saveSessionRequest = saveSessionRequestFromJson(jsonString);

import 'dart:convert';

SaveSessionRequest saveSessionRequestFromJson(String str) => SaveSessionRequest.fromJson(json.decode(str));

String saveSessionRequestToJson(SaveSessionRequest data) => json.encode(data.toJson());

class SaveSessionRequest {
  SaveSessionRequest({
    this.webdeviceId,
    this.deviceInfo,
    this.emailId,
    this.gaid,
    this.idfa,
    this.pushnotificationtoken,
    this.country,
    this.contactId,
    this.utmMedium,
    this.utmSource,
    this.utmCampaign,
    this.utmTerm,
    this.utmContent,
  });

  String? webdeviceId;
  String? deviceInfo;
  String? emailId;
  String? gaid;
  String? idfa;
  String? pushnotificationtoken;
  String? country;
  String? contactId;
  String? utmMedium;
  String? utmSource;
  String? utmCampaign;
  String? utmTerm;
  String? utmContent;

  factory SaveSessionRequest.fromJson(Map<String, dynamic> json) => SaveSessionRequest(
    webdeviceId: json["webdeviceId"] == null ? null : json["webdeviceId"],
    deviceInfo: json["deviceInfo"] == null ? null : json["deviceInfo"],
    emailId: json["emailId"] == null ? null : json["emailId"],
    gaid: json["gaid"] == null ? null : json["gaid"],
    idfa: json["idfa"] == null ? null : json["idfa"],
    pushnotificationtoken: json["pushnotificationtoken"] == null ? null : json["pushnotificationtoken"],
    country: json["country"] == null ? null : json["country"],
    contactId: json["contactId"] == null ? null : json["contactId"],
    utmMedium: json["utm_medium"] == null ? null : json["utm_medium"],
    utmSource: json["utm_source"] == null ? null : json["utm_source"],
    utmCampaign: json["utm_campaign"] == null ? null : json["utm_campaign"],
    utmTerm: json["utm_term"] == null ? null : json["utm_term"],
    utmContent: json["utm_content"] == null ? null : json["utm_content"],
  );

  Map<String, dynamic> toJson() => {
    "webdeviceId": webdeviceId == null ? null : webdeviceId,
    "deviceInfo": deviceInfo == null ? null : deviceInfo,
    "emailId": emailId == null ? null : emailId,
    "gaid": gaid == null ? null : gaid,
    "idfa": idfa == null ? null : idfa,
    "pushnotificationtoken": pushnotificationtoken == null ? null : pushnotificationtoken,
    "country": country == null ? null : country,
    "contactId": contactId == null ? null : contactId,
    "utm_medium": utmMedium == null ? null : utmMedium,
    "utm_source": utmSource == null ? null : utmSource,
    "utm_campaign": utmCampaign == null ? null : utmCampaign,
    "utm_term": utmTerm == null ? null : utmTerm,
    "utm_content": utmContent == null ? null : utmContent,
  };
}
