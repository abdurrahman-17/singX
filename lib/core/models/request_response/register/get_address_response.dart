// To parse this JSON data, do
//
//     final getAddressResponse = getAddressResponseFromJson(jsonString);

import 'dart:convert';

GetAddressResponse getAddressResponseFromJson(String str) => GetAddressResponse.fromJson(json.decode(str));

String getAddressResponseToJson(GetAddressResponse data) => json.encode(data.toJson());

class GetAddressResponse {
  GetAddressResponse({
    this.postcode,
    this.bldgno,
    this.streetname,
    this.bldgname,
    this.status,
  });

  String? postcode;
  String? bldgno;
  String? streetname;
  String? bldgname;
  int? status;

  factory GetAddressResponse.fromJson(Map<String, dynamic> json) => GetAddressResponse(
    postcode: json["POSTCODE"],
    bldgno: json["BLDGNO"],
    streetname: json["STREETNAME"],
    bldgname: json["BLDGNAME"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "POSTCODE": postcode,
    "BLDGNO": bldgno,
    "STREETNAME": streetname,
    "BLDGNAME": bldgname,
    "status": status,
  };
}
