// To parse this JSON data, do
//
//     final editProfileResponse = editProfileResponseFromJson(jsonString);

import 'dart:convert';

EditProfileResponse editProfileResponseFromJson(String str) => EditProfileResponse.fromJson(json.decode(str));

String editProfileResponseToJson(EditProfileResponse data) => json.encode(data.toJson());

class EditProfileResponse {
  EditProfileResponse({
    this.primaryKey,
    this.callingCode,
    this.gender,
    this.activeStatus,
    this.status,
    this.unitNo,
    this.blockNo,
    this.streetName,
    this.buildingName,
    this.postalCode,
    this.city,
    this.state,
    this.employerName,
    this.updateable,
    this.addReceiverEmailforReceiver,
    this.brandNameOrFullName,
    this.fullName,
    this.mobile,
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
    this.onboardedDt,
    this.masspaoutId,
    this.brandName,
    this.ekycSelfie,
    this.ekycSelfieStatus,
  });

  dynamic primaryKey;
  CallingCode? callingCode;
  Gender? gender;
  int? activeStatus;
  String? status;
  String? unitNo;
  String? blockNo;
  String? streetName;
  String? buildingName;
  String? postalCode;
  dynamic city;
  dynamic state;
  dynamic employerName;
  bool? updateable;
  int? addReceiverEmailforReceiver;
  String? brandNameOrFullName;
  String? fullName;
  String? mobile;
  String? dateOfBirth;
  String? emailId;
  String? firstName;
  String? phoneNumber;
  String? middleName;
  String? lastName;
  String? contactId;
  String? countryId;
  int? docStatusId;
  String? prefixId;
  String? phoneCountryCode;
  String? genderId;
  String? promoCode;
  dynamic customerType;
  int? versionId;
  String? verificationType;
  int? ekycMobVerify;
  String? ekycUploadStatus;
  String? ekycScanStatus;
  String? occupation;
  String? otherOccupation;
  DateTime? onboardedDt;
  String? masspaoutId;
  dynamic brandName;
  int? ekycSelfie;
  String? ekycSelfieStatus;

  factory EditProfileResponse.fromJson(Map<String, dynamic> json) => EditProfileResponse(
    primaryKey: json["primaryKey"],
    callingCode: json["callingCode"] == null ? null : CallingCode.fromJson(json["callingCode"]),
    gender: json["gender"] == null ? null : Gender.fromJson(json["gender"]),
    activeStatus: json["activeStatus"] == null ? null : json["activeStatus"],
    status: json["status"] == null ? null : json["status"],
    unitNo: json["unitNo"] == null ? null : json["unitNo"],
    blockNo: json["blockNo"] == null ? null : json["blockNo"],
    streetName: json["streetName"] == null ? null : json["streetName"],
    buildingName: json["buildingName"] == null ? null : json["buildingName"],
    postalCode: json["postalCode"] == null ? null : json["postalCode"],
    city: json["city"],
    state: json["state"],
    employerName: json["employerName"],
    updateable: json["updateable"] == null ? null : json["updateable"],
    addReceiverEmailforReceiver: json["addReceiverEmailforReceiver"] == null ? null : json["addReceiverEmailforReceiver"],
    brandNameOrFullName: json["brandNameOrFullName"] == null ? null : json["brandNameOrFullName"],
    fullName: json["fullName"] == null ? null : json["fullName"],
    mobile: json["mobile"] == null ? null : json["mobile"],
    dateOfBirth: json["dateOfBirth"] == null ? null : json["dateOfBirth"],
    emailId: json["emailId"] == null ? null : json["emailId"],
    firstName: json["firstName"] == null ? null : json["firstName"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    middleName: json["middleName"] == null ? null : json["middleName"],
    lastName: json["lastName"] == null ? null : json["lastName"],
    contactId: json["contactId"] == null ? null : json["contactId"],
    countryId: json["countryId"] == null ? null : json["countryId"],
    docStatusId: json["docStatusId"] == null ? null : json["docStatusId"],
    prefixId: json["prefixId"] == null ? null : json["prefixId"],
    phoneCountryCode: json["phoneCountryCode"] == null ? null : json["phoneCountryCode"],
    genderId: json["genderId"] == null ? null : json["genderId"],
    promoCode: json["promoCode"] == null ? null : json["promoCode"],
    customerType: json["customerType"],
    versionId: json["versionId"] == null ? null : json["versionId"],
    verificationType: json["verificationType"] == null ? null : json["verificationType"],
    ekycMobVerify: json["ekycMobVerify"] == null ? null : json["ekycMobVerify"],
    ekycUploadStatus: json["ekyc_upload_status"] == null ? null : json["ekyc_upload_status"],
    ekycScanStatus: json["ekyc_scan_status"] == null ? null : json["ekyc_scan_status"],
    occupation: json["occupation"] == null ? null : json["occupation"],
    otherOccupation: json["otherOccupation"] == null ? null : json["otherOccupation"],
    onboardedDt: json["onboardedDt"] == null ? null : DateTime.parse(json["onboardedDt"]),
    masspaoutId: json["masspaoutId"] == null ? null : json["masspaoutId"],
    brandName: json["brandName"],
    ekycSelfie: json["ekyc_selfie"] == null ? null : json["ekyc_selfie"],
    ekycSelfieStatus: json["ekyc_selfie_status"] == null ? null : json["ekyc_selfie_status"],
  );

  Map<String, dynamic> toJson() => {
    "primaryKey": primaryKey,
    "callingCode": callingCode == null ? null : callingCode!.toJson(),
    "gender": gender == null ? null : gender!.toJson(),
    "activeStatus": activeStatus == null ? null : activeStatus,
    "status": status == null ? null : status,
    "unitNo": unitNo == null ? null : unitNo,
    "blockNo": blockNo == null ? null : blockNo,
    "streetName": streetName == null ? null : streetName,
    "buildingName": buildingName == null ? null : buildingName,
    "postalCode": postalCode == null ? null : postalCode,
    "city": city,
    "state": state,
    "employerName": employerName,
    "updateable": updateable == null ? null : updateable,
    "addReceiverEmailforReceiver": addReceiverEmailforReceiver == null ? null : addReceiverEmailforReceiver,
    "brandNameOrFullName": brandNameOrFullName == null ? null : brandNameOrFullName,
    "fullName": fullName == null ? null : fullName,
    "mobile": mobile == null ? null : mobile,
    "dateOfBirth": dateOfBirth == null ? null : dateOfBirth,
    "emailId": emailId == null ? null : emailId,
    "firstName": firstName == null ? null : firstName,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "middleName": middleName == null ? null : middleName,
    "lastName": lastName == null ? null : lastName,
    "contactId": contactId == null ? null : contactId,
    "countryId": countryId == null ? null : countryId,
    "docStatusId": docStatusId == null ? null : docStatusId,
    "prefixId": prefixId == null ? null : prefixId,
    "phoneCountryCode": phoneCountryCode == null ? null : phoneCountryCode,
    "genderId": genderId == null ? null : genderId,
    "promoCode": promoCode == null ? null : promoCode,
    "customerType": customerType,
    "versionId": versionId == null ? null : versionId,
    "verificationType": verificationType == null ? null : verificationType,
    "ekycMobVerify": ekycMobVerify == null ? null : ekycMobVerify,
    "ekyc_upload_status": ekycUploadStatus == null ? null : ekycUploadStatus,
    "ekyc_scan_status": ekycScanStatus == null ? null : ekycScanStatus,
    "occupation": occupation == null ? null : occupation,
    "otherOccupation": otherOccupation == null ? null : otherOccupation,
    "onboardedDt": onboardedDt == null ? null : "${onboardedDt!.year.toString().padLeft(4, '0')}-${onboardedDt!.month.toString().padLeft(2, '0')}-${onboardedDt!.day.toString().padLeft(2, '0')}",
    "masspaoutId": masspaoutId == null ? null : masspaoutId,
    "brandName": brandName,
    "ekyc_selfie": ekycSelfie == null ? null : ekycSelfie,
    "ekyc_selfie_status": ekycSelfieStatus == null ? null : ekycSelfieStatus,
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
