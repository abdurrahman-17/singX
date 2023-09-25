// To parse this JSON data, do
//
//     final getAddressByPostalCodeResponse = getAddressByPostalCodeResponseFromJson(jsonString);

import 'dart:convert';

GetAddressByPostalCodeResponse getAddressByPostalCodeResponseFromJson(String str) => GetAddressByPostalCodeResponse.fromJson(json.decode(str));

String getAddressByPostalCodeResponseToJson(GetAddressByPostalCodeResponse data) => json.encode(data.toJson());

class GetAddressByPostalCodeResponse {
  GetAddressByPostalCodeResponse({
    this.postcode,
    this.bldgno,
    this.streetname,
    this.bldgname,
  });

  String? postcode;
  String? bldgno;
  String? streetname;
  String? bldgname;

  factory GetAddressByPostalCodeResponse.fromJson(Map<String, dynamic> json) => GetAddressByPostalCodeResponse(
    postcode: json["POSTCODE"] == null ? null : json["POSTCODE"],
    bldgno: json["BLDGNO"] == null ? null : json["BLDGNO"],
    streetname: json["STREETNAME"] == null ? null : json["STREETNAME"],
    bldgname: json["BLDGNAME"] == null ? null : json["BLDGNAME"],
  );

  Map<String, dynamic> toJson() => {
    "POSTCODE": postcode == null ? null : postcode,
    "BLDGNO": bldgno == null ? null : bldgno,
    "STREETNAME": streetname == null ? null : streetname,
    "BLDGNAME": bldgname == null ? null : bldgname,
  };
}
