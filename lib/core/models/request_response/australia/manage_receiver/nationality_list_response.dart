// To parse this JSON data, do
//
//     final nationalityAusListResponse = nationalityAusListResponseFromJson(jsonString);

import 'dart:convert';

List<NationalityAusListResponse> nationalityAusListResponseFromJson(String str) => List<NationalityAusListResponse>.from(json.decode(str).map((x) => NationalityAusListResponse.fromJson(x)));

String nationalityAusListResponseToJson(List<NationalityAusListResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NationalityAusListResponse {
  NationalityAusListResponse({
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
  dynamic capitalLatitude;
  dynamic capitalLongitude;
  String? country;
  String? countryCode1;
  String? countryCode2;
  String? countryFlag;
  CreatedBy? createdBy;
  CreatedDate? createdDate;
  String? currencyCode;
  String? currencyName;
  int? isoNumeric;
  dynamic updatedBy;
  dynamic updatedDate;
  int? isReceiver;

  factory NationalityAusListResponse.fromJson(Map<String, dynamic> json) => NationalityAusListResponse(
    countryId: json["countryId"] == null ? null : json["countryId"],
    activeStatus: json["activeStatus"] == null ? null : json["activeStatus"],
    capital: json["capital"] == null ? null : json["capital"],
    capitalLatitude: json["capitalLatitude"],
    capitalLongitude: json["capitalLongitude"],
    country: json["country"] == null ? null : json["country"],
    countryCode1: json["countryCode1"] == null ? null : json["countryCode1"],
    countryCode2: json["countryCode2"] == null ? null : json["countryCode2"],
    countryFlag: json["countryFlag"] == null ? null : json["countryFlag"],
    createdBy: json["createdBy"] == null ? null : createdByValues.map[json["createdBy"]],
    createdDate: json["createdDate"] == null ? null : createdDateValues.map[json["createdDate"]],
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
    "capitalLatitude": capitalLatitude,
    "capitalLongitude": capitalLongitude,
    "country": country == null ? null : country,
    "countryCode1": countryCode1 == null ? null : countryCode1,
    "countryCode2": countryCode2 == null ? null : countryCode2,
    "countryFlag": countryFlag == null ? null : countryFlag,
    "createdBy": createdBy == null ? null : createdByValues.reverse![createdBy],
    "createdDate": createdDate == null ? null : createdDateValues.reverse![createdDate],
    "currencyCode": currencyCode == null ? null : currencyCode,
    "currencyName": currencyName == null ? null : currencyName,
    "isoNumeric": isoNumeric == null ? null : isoNumeric,
    "updatedBy": updatedBy,
    "updatedDate": updatedDate,
    "isReceiver": isReceiver == null ? null : isReceiver,
  };
}

enum CreatedBy { SWETHA, NAVEEN, CREATED_BY_NAVEEN }

final createdByValues = EnumValues({
  "Naveen": CreatedBy.CREATED_BY_NAVEEN,
  "Naveen ": CreatedBy.NAVEEN,
  "Swetha": CreatedBy.SWETHA
});

enum CreatedDate { THE_20190715_T03_33420000000, THE_20191209_T02_29250000000 }

final createdDateValues = EnumValues({
  "2019-07-15T03:33:42.000+0000": CreatedDate.THE_20190715_T03_33420000000,
  "2019-12-09T02:29:25.000+0000": CreatedDate.THE_20191209_T02_29250000000
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
