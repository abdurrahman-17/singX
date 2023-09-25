// To parse this JSON data, do
//
//     final saveCustomerRequest = saveCustomerRequestFromJson(jsonString);


import 'dart:convert';

SaveCustomerRequest saveCustomerRequestFromJson(String str) => SaveCustomerRequest.fromJson(json.decode(str));

String saveCustomerRequestToJson(SaveCustomerRequest data) => json.encode(data.toJson());

class SaveCustomerRequest {
  SaveCustomerRequest({
    this.tittle,
    this.firstName,
    this.middleName,
    this.lastName,
    this.dateOfBirth,
    this.nationality,
    this.residenceId,
    this.occupation,
    this.otherOccupation,
    this.employerName,
    this.estimatedTxnamount,
    this.annualIncome,
    this.countryCode,
    this.phoneNumber,
    this.address,
    this.addressLine1,
    this.addressLine2,
    this.addressLine3,
    this.addressLine4,
    this.addressLine5,
    this.country,
    this.postalCode,
    this.cra,
    this.promoCode,
    this.contactId,
    this.state,
  });

  String? tittle;
  String? firstName;
  String? middleName;
  String? lastName;
  String? dateOfBirth;
  String? nationality;
  String? residenceId;
  String? occupation;
  String? otherOccupation;
  String? employerName;
  String? estimatedTxnamount;
  String? annualIncome;
  String? countryCode;
  String? phoneNumber;
  String? address;
  String? addressLine1;
  String? addressLine2;
  String? addressLine3;
  String? addressLine4;
  String? addressLine5;
  String? country;
  String? postalCode;
  bool? cra;
  String? promoCode;
  int? contactId;
  String? state;

  factory SaveCustomerRequest.fromJson(Map<String, dynamic> json) => SaveCustomerRequest(
    tittle: json["tittle"] == null ? null : json["tittle"],
    firstName: json["firstName"] == null ? null : json["firstName"],
    middleName: json["middleName"] == null ? null : json["middleName"],
    lastName: json["lastName"] == null ? null : json["lastName"],
    dateOfBirth: json["dateOfBirth"] == null ? null : json["dateOfBirth"],
    nationality: json["nationality"] == null ? null : json["nationality"],
    residenceId: json["residenceId"] == null ? null : json["residenceId"],
    occupation: json["occupation"] == null ? null : json["occupation"],
    otherOccupation: json["otherOccupation"] == null ? null : json["otherOccupation"],
    employerName: json["employerName"] == null ? null : json["employerName"],
    estimatedTxnamount: json["estimatedTxnamount"] == null ? null : json["estimatedTxnamount"],
    annualIncome: json["annualIncome"] == null ? null : json["annualIncome"],
    countryCode: json["countryCode"] == null ? null : json["countryCode"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    address: json["address"] == null ? null : json["address"],
    addressLine1: json["addressLine1"] == null ? null : json["addressLine1"],
    addressLine2: json["addressLine2"] == null ? null : json["addressLine2"],
    addressLine3: json["addressLine3"] == null ? null : json["addressLine3"],
    addressLine4: json["addressLine4"] == null ? null : json["addressLine4"],
    addressLine5: json["addressLine5"] == null ? null : json["addressLine5"],
    country: json["country"] == null ? null : json["country"],
    postalCode: json["postalCode"] == null ? null : json["postalCode"],
    cra: json["cra"] == null ? null : json["cra"],
    promoCode: json["promoCode"] == null ? null : json["promoCode"],
    contactId: json["contactId"] == null ? null : json["contactId"],
    state: json["state"] == null ? null : json["state"],
  );

  Map<String, dynamic> toJson() => {
    "tittle": tittle == null ? null : tittle,
    "firstName": firstName == null ? null : firstName,
    "middleName": middleName == null ? null : middleName,
    "lastName": lastName == null ? null : lastName,
    "dateOfBirth": dateOfBirth == null ? null : dateOfBirth,
    "nationality": nationality == null ? null : nationality,
    "residenceId": residenceId == null ? null : residenceId,
    "occupation": occupation == null ? null : occupation,
    "otherOccupation": otherOccupation == null ? null : otherOccupation,
    "employerName": employerName == null ? null : employerName,
    "estimatedTxnamount": estimatedTxnamount == null ? null : estimatedTxnamount,
    "annualIncome": annualIncome == null ? null : annualIncome,
    "countryCode": countryCode == null ? null : countryCode,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "address": address == null ? null : address,
    "addressLine1": addressLine1 == null ? null : addressLine1,
    "addressLine2": addressLine2 == null ? null : addressLine2,
    "addressLine3": addressLine3 == null ? null : addressLine3,
    "addressLine4": addressLine4 == null ? null : addressLine4,
    "addressLine5": addressLine5 == null ? null : addressLine5,
    "country": country == null ? null : country,
    "postalCode": postalCode == null ? null : postalCode,
    "cra": cra == null ? null : cra,
    "promoCode": promoCode == null ? null : promoCode,
    "contactId": contactId == null ? null : contactId,
    "state": state == null ? null : state,
  };
}
