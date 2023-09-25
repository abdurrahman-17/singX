// To parse this JSON data, do
//
//     final contactDetailsResponse = contactDetailsResponseFromJson(jsonString);

import 'dart:convert';

ContactDetailsResponse contactDetailsResponseFromJson(String str) => ContactDetailsResponse.fromJson(json.decode(str));

String contactDetailsResponseToJson(ContactDetailsResponse data) => json.encode(data.toJson());

class ContactDetailsResponse {
  ContactDetailsResponse({
    this.primaryKey,
    this.callingCode,
    this.gender,
    this.activeStatus,
    this.addReceiverEmailforReceiver,
    this.brandNameOrFullName,
    this.fullName,
    this.dateOfBirth,
    this.emailId,
    this.firstName,
    this.phoneNumber,
    this.middleName,
    this.lastName,
    this.contactId,
    this.countryId,
    this.docStatusId,
    this.prefixId,
    this.phoneCountryCode,
    this.genderId,
    this.promoCode,
    this.customerType,
    this.versionId,
    this.verificationType,
    this.ekycMobVerify,
    this.ekycUploadStatus,
    this.ekycScanStatus,
    this.occupation,
    this.otherOccupation,
    this.masspaoutId,
    this.brandName,
    this.data,
    this.ekycSelfie,
    this.ekycSelfieStatus,
  });

  dynamic primaryKey;
  CallingCode? callingCode;
  Gender? gender;
  int? activeStatus;
  int? addReceiverEmailforReceiver;
  String? brandNameOrFullName;
  String? fullName;
  dynamic dateOfBirth;
  String? emailId;
  String? firstName;
  String? phoneNumber;
  String? middleName;
  String? lastName;
  String? contactId;
  String? countryId;
  dynamic docStatusId;
  String? prefixId;
  String? phoneCountryCode;
  String? genderId;
  String? promoCode;
  dynamic customerType;
  int? versionId;
  dynamic verificationType;
  int? ekycMobVerify;
  dynamic ekycUploadStatus;
  dynamic ekycScanStatus;
  String? occupation;
  String? otherOccupation;
  dynamic masspaoutId;
  dynamic brandName;
  String? data;
  int? ekycSelfie;
  dynamic ekycSelfieStatus;

  factory ContactDetailsResponse.fromJson(Map<String, dynamic> json) => ContactDetailsResponse(
    primaryKey: json["primaryKey"],
    callingCode: json["callingCode"] == null ? null : CallingCode.fromJson(json["callingCode"]),
    gender: json["gender"] == null ? null : Gender.fromJson(json["gender"]),
    activeStatus: json["activeStatus"] == null ? null : json["activeStatus"],
    addReceiverEmailforReceiver: json["addReceiverEmailforReceiver"] == null ? null : json["addReceiverEmailforReceiver"],
    brandNameOrFullName: json["brandNameOrFullName"] == null ? null : json["brandNameOrFullName"],
    fullName: json["fullName"] == null ? null : json["fullName"],
    dateOfBirth: json["dateOfBirth"],
    emailId: json["emailId"] == null ? null : json["emailId"],
    firstName: json["firstName"] == null ? null : json["firstName"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    middleName: json["middleName"] == null ? null : json["middleName"],
    lastName: json["lastName"] == null ? null : json["lastName"],
    contactId: json["contactId"] == null ? null : json["contactId"],
    countryId: json["countryId"] == null ? null : json["countryId"],
    docStatusId: json["docStatusId"],
    prefixId: json["prefixId"] == null ? null : json["prefixId"],
    phoneCountryCode: json["phoneCountryCode"] == null ? null : json["phoneCountryCode"],
    genderId: json["genderId"] == null ? null : json["genderId"],
    promoCode: json["promoCode"] == null ? null : json["promoCode"],
    customerType: json["customerType"],
    versionId: json["versionId"] == null ? null : json["versionId"],
    verificationType: json["verificationType"],
    ekycMobVerify: json["ekycMobVerify"] == null ? null : json["ekycMobVerify"],
    ekycUploadStatus: json["ekyc_upload_status"],
    ekycScanStatus: json["ekyc_scan_status"],
    occupation: json["occupation"] == null ? null : json["occupation"],
    otherOccupation: json["otherOccupation"] == null ? null : json["otherOccupation"],
    masspaoutId: json["masspaoutId"],
    brandName: json["brandName"],
    data: json["data"] == null ? null : json["data"],
    ekycSelfie: json["ekyc_selfie"] == null ? null : json["ekyc_selfie"],
    ekycSelfieStatus: json["ekyc_selfie_status"],
  );

  Map<String, dynamic> toJson() => {
    "primaryKey": primaryKey,
    "callingCode": callingCode == null ? null : callingCode!.toJson(),
    "gender": gender == null ? null : gender!.toJson(),
    "activeStatus": activeStatus == null ? null : activeStatus,
    "addReceiverEmailforReceiver": addReceiverEmailforReceiver == null ? null : addReceiverEmailforReceiver,
    "brandNameOrFullName": brandNameOrFullName == null ? null : brandNameOrFullName,
    "fullName": fullName == null ? null : fullName,
    "dateOfBirth": dateOfBirth,
    "emailId": emailId == null ? null : emailId,
    "firstName": firstName == null ? null : firstName,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "middleName": middleName == null ? null : middleName,
    "lastName": lastName == null ? null : lastName,
    "contactId": contactId == null ? null : contactId,
    "countryId": countryId == null ? null : countryId,
    "docStatusId": docStatusId,
    "prefixId": prefixId == null ? null : prefixId,
    "phoneCountryCode": phoneCountryCode == null ? null : phoneCountryCode,
    "genderId": genderId == null ? null : genderId,
    "promoCode": promoCode == null ? null : promoCode,
    "customerType": customerType,
    "versionId": versionId == null ? null : versionId,
    "verificationType": verificationType,
    "ekycMobVerify": ekycMobVerify == null ? null : ekycMobVerify,
    "ekyc_upload_status": ekycUploadStatus,
    "ekyc_scan_status": ekycScanStatus,
    "occupation": occupation == null ? null : occupation,
    "otherOccupation": otherOccupation == null ? null : otherOccupation,
    "masspaoutId": masspaoutId,
    "brandName": brandName,
    "data": data == null ? null : data,
    "ekyc_selfie": ekycSelfie == null ? null : ekycSelfie,
    "ekyc_selfie_status": ekycSelfieStatus,
  };
}

class CallingCode {
  CallingCode({
    this.mapId,
    this.countryId,
    this.callingCode,
    this.activeStatus,
  });

  String? mapId;
  String? countryId;
  String? callingCode;
  int? activeStatus;

  factory CallingCode.fromJson(Map<String, dynamic> json) => CallingCode(
    mapId: json["mapId"] == null ? null : json["mapId"],
    countryId: json["countryId"] == null ? null : json["countryId"],
    callingCode: json["callingCode"] == null ? null : json["callingCode"],
    activeStatus: json["activeStatus"] == null ? null : json["activeStatus"],
  );

  Map<String, dynamic> toJson() => {
    "mapId": mapId == null ? null : mapId,
    "countryId": countryId == null ? null : countryId,
    "callingCode": callingCode == null ? null : callingCode,
    "activeStatus": activeStatus == null ? null : activeStatus,
  };
}

class Gender {
  Gender({
    this.gender,
    this.genderId,
  });

  String? gender;
  String? genderId;

  factory Gender.fromJson(Map<String, dynamic> json) => Gender(
    gender: json["gender"] == null ? null : json["gender"],
    genderId: json["genderId"] == null ? null : json["genderId"],
  );

  Map<String, dynamic> toJson() => {
    "gender": gender == null ? null : gender,
    "genderId": genderId == null ? null : genderId,
  };
}
