// To parse this JSON data, do
//
//     final saveCustomerRequestHk = saveCustomerRequestHkFromJson(jsonString);

import 'dart:convert';

SaveCustomerRequestHk saveCustomerRequestHkFromJson(String str) => SaveCustomerRequestHk.fromJson(json.decode(str));

String saveCustomerRequestHkToJson(SaveCustomerRequestHk data) => json.encode(data.toJson());

class SaveCustomerRequestHk {
  SaveCustomerRequestHk({
    this.salutation,
    this.firstName,
    this.middleName,
    this.lastName,
    this.occupation,
    this.occupationOthers,
    this.nationality,
    this.promoCode,
    this.residentStatus,
    this.dateOfBirth,
    this.address,
    this.streetName,
    this.buildingName,
    this.district,
    this.state,
    this.buildingNumber,
  });

  String? salutation;
  String? firstName;
  String? middleName;
  String? lastName;
  String? occupation;
  String? occupationOthers;
  String? nationality;
  String? promoCode;
  String? residentStatus;
  String? dateOfBirth;
  String? address;
  String? streetName;
  String? buildingName;
  String? district;
  String? state;
  String? buildingNumber;

  factory SaveCustomerRequestHk.fromJson(Map<String, dynamic> json) => SaveCustomerRequestHk(
    salutation: json["salutation"] == null ? null : json["salutation"],
    firstName: json["firstName"] == null ? null : json["firstName"],
    middleName: json["middleName"] == null ? null : json["middleName"],
    lastName: json["lastName"] == null ? null : json["lastName"],
    occupation: json["occupation"] == null ? null : json["occupation"],
    occupationOthers: json["occupationOthers"] == null ? null : json["occupationOthers"],
    nationality: json["nationality"] == null ? null : json["nationality"],
    promoCode: json["promoCode"] == null ? null : json["promoCode"],
    residentStatus: json["residentStatus"] == null ? null : json["residentStatus"],
    dateOfBirth: json["dateOfBirth"] == null ? null : json["dateOfBirth"],
    address: json["address"] == null ? null : json["address"],
    streetName: json["streetName"] == null ? null : json["streetName"],
    buildingName: json["buildingName"] == null ? null : json["buildingName"],
    district: json["district"] == null ? null : json["district"],
    state: json["state"] == null ? null : json["state"],
    buildingNumber: json["buildingNumber"] == null ? null : json["buildingNumber"],
  );

  Map<String, dynamic> toJson() => {
    "salutation": salutation == null ? null : salutation,
    "firstName": firstName == null ? null : firstName,
    "middleName": middleName == null ? null : middleName,
    "lastName": lastName == null ? null : lastName,
    "occupation": occupation == null ? null : occupation,
    "occupationOthers": occupationOthers == null ? null : occupationOthers,
    "nationality": nationality == null ? null : nationality,
    "promoCode": promoCode == null ? null : promoCode,
    "residentStatus": residentStatus == null ? null : residentStatus,
    "dateOfBirth": dateOfBirth == null ? null : dateOfBirth,
    "address": address == null ? null : address,
    "streetName": streetName == null ? null : streetName,
    "buildingName": buildingName == null ? null : buildingName,
    "district": district == null ? null : district,
    "state": state == null ? null : state,
    "buildingNumber": buildingNumber == null ? null : buildingNumber,
  };
}
