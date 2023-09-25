// To parse this JSON data, do
//
//     final personalDetailsRequestSg = personalDetailsRequestSgFromJson(jsonString);

import 'dart:convert';

PersonalDetailsRequestSg personalDetailsRequestSgFromJson(String str) => PersonalDetailsRequestSg.fromJson(json.decode(str));

String personalDetailsRequestSgToJson(PersonalDetailsRequestSg data) => json.encode(data.toJson());

class PersonalDetailsRequestSg {
  PersonalDetailsRequestSg({
    this.salutation,
    this.firstName,
    this.middleName,
    this.lastName,
    this.occupation,
    this.occupationOthers,
    this.phoneNumber,
    this.promoCode,
    this.residentStatus,
    this.employerName,
    this.unitNo,
    this.blockNo,
    this.streetName,
    this.buildingName,
    this.postalCode,
    this.city,
    this.state,
  });

  String? salutation;
  String? firstName;
  String? middleName;
  String? lastName;
  String? occupation;
  String? occupationOthers;
  String? phoneNumber;
  String? promoCode;
  String? residentStatus;
  String? employerName;
  String? unitNo;
  String? blockNo;
  String? streetName;
  String? buildingName;
  String? postalCode;
  String? city;
  String? state;

  factory PersonalDetailsRequestSg.fromJson(Map<String, dynamic> json) => PersonalDetailsRequestSg(
    salutation: json["salutation"] == null ? "" : json["salutation"],
    firstName: json["firstName"] == null ? "" : json["firstName"],
    middleName: json["middleName"] == null ? "" : json["middleName"],
    lastName: json["lastName"] == null ? "" : json["lastName"],
    occupation: json["occupation"] == null ? null : json["occupation"],
    occupationOthers: json["occupationOthers"] == null ? null : json["occupationOthers"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    promoCode: json["promoCode"] == null ? null : json["promoCode"],
    residentStatus: json["residentStatus"] == null ? null : json["residentStatus"],
    employerName: json["employerName"] == null ? null : json["employerName"],
    unitNo: json["unitNo"] == null ? null : json["unitNo"],
    blockNo: json["blockNo"] == null ? null : json["blockNo"],
    streetName: json["streetName"] == null ? null : json["streetName"],
    buildingName: json["buildingName"] == null ? null : json["buildingName"],
    postalCode: json["postalCode"] == null ? null : json["postalCode"],
    city: json["city"] == null ? null : json["city"],
    state: json["state"] == null ? null : json["state"],
  );

  Map<String, dynamic> toJson() => {
    "salutation": salutation== null ? null : salutation,
    "firstName": firstName == null ? null : firstName,
    "middleName": middleName == null ? null : middleName,
    "lastName": lastName == null ? null : lastName,
    "occupation": occupation == null ? null : occupation,
    "occupationOthers": occupationOthers == null ? null : occupationOthers,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "promoCode": promoCode == null ? null : promoCode,
    "residentStatus": residentStatus == null ? null : residentStatus,
    "employerName": employerName == null ? null : employerName,
    "unitNo": unitNo == null ? null : unitNo,
    "blockNo": blockNo == null ? null : blockNo,
    "streetName": streetName == null ? null : streetName,
    "buildingName": buildingName == null ? null : buildingName,
    "postalCode": postalCode == null ? null : postalCode,
    "city": city == null ? null : city,
    "state": state == null ? null : state,
  };
}
