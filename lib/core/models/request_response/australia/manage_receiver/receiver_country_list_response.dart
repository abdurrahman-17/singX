// To parse this JSON data, do
//
//     final receiverCountryListAusResponse = receiverCountryListAusResponseFromJson(jsonString);

import 'dart:convert';

List<ReceiverCountryListAusResponse> receiverCountryListAusResponseFromJson(String str) => List<ReceiverCountryListAusResponse>.from(json.decode(str).map((x) => ReceiverCountryListAusResponse.fromJson(x)));

String receiverCountryListAusResponseToJson(List<ReceiverCountryListAusResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReceiverCountryListAusResponse {
  ReceiverCountryListAusResponse({
    this.countryId,
    this.activeStatus,
    this.capital,
    this.capitalLatitude,
    this.capitalLongitude,
    this.country,
    this.countryCode1,
    this.countryCode2,
    this.countryFlag,
    this.createdBy,
    this.createdDate,
    this.currencyCode,
    this.currencyName,
    this.isoNumeric,
    this.updatedBy,
    this.updatedDate,
    this.isReceiver,
  });

  int? countryId;
  int? activeStatus;
  String? capital;
  int? capitalLatitude;
  int? capitalLongitude;
  String? country;
  String? countryCode1;
  String? countryCode2;
  String? countryFlag;
  String? createdBy;
  String? createdDate;
  String? currencyCode;
  String? currencyName;
  int? isoNumeric;
  dynamic updatedBy;
  dynamic updatedDate;
  int? isReceiver;

  factory ReceiverCountryListAusResponse.fromJson(Map<String, dynamic> json) => ReceiverCountryListAusResponse(
    countryId: json["countryId"] == null ? null : json["countryId"],
    activeStatus: json["activeStatus"] == null ? null : json["activeStatus"],
    capital: json["capital"] == null ? null : json["capital"],
    capitalLatitude: json["capitalLatitude"] == null ? null : json["capitalLatitude"],
    capitalLongitude: json["capitalLongitude"] == null ? null : json["capitalLongitude"],
    country: json["country"] == null ? null : json["country"],
    countryCode1: json["countryCode1"] == null ? null : json["countryCode1"],
    countryCode2: json["countryCode2"] == null ? null : json["countryCode2"],
    countryFlag: json["countryFlag"] == null ? null : json["countryFlag"],
    createdBy: json["createdBy"] == null ? null : json["createdBy"],
    createdDate: json["createdDate"] == null ? null : json["createdDate"],
    currencyCode: json["currencyCode"] == null ? null : json["currencyCode"],
    currencyName: json["currencyName"] == null ? null : json["currencyName"],
    isoNumeric: json["isoNumeric"] == null ? null : json["isoNumeric"],
    updatedBy: json["updatedBy"],
    updatedDate: json["updatedDate"],
    isReceiver: json["isReceiver"] == null ? null : json["isReceiver"],
  );

  Map<String, dynamic> toJson() => {
    "countryId": countryId == null ? null : countryId,
    "activeStatus": activeStatus == null ? null : activeStatus,
    "capital": capital == null ? null : capital,
    "capitalLatitude": capitalLatitude == null ? null : capitalLatitude,
    "capitalLongitude": capitalLongitude == null ? null : capitalLongitude,
    "country": country == null ? null : country,
    "countryCode1": countryCode1 == null ? null : countryCode1,
    "countryCode2": countryCode2 == null ? null : countryCode2,
    "countryFlag": countryFlag == null ? null : countryFlag,
    "createdBy": createdBy == null ? null : createdBy,
    "createdDate": createdDate == null ? null : createdDate,
    "currencyCode": currencyCode == null ? null : currencyCode,
    "currencyName": currencyName == null ? null : currencyName,
    "isoNumeric": isoNumeric == null ? null : isoNumeric,
    "updatedBy": updatedBy,
    "updatedDate": updatedDate,
    "isReceiver": isReceiver == null ? null : isReceiver,
  };
}
