// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.success,
    this.message,
    this.userinfo,
    this.token,
  });

  bool? success;
  String? message;
  Userinfo? userinfo;
  String? token;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    userinfo: json["userinfo"] == null ? null : Userinfo.fromJson(json["userinfo"]),
    token: json["token"] == null ? null : json["token"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "userinfo": userinfo == null ? null : userinfo!.toJson(),
    "token": token == null ? null : token,
  };
}

class Userinfo {
  Userinfo({
    this.lastName,
    this.contactId,
    this.profileStatus,
    this.emailId,
    this.userId,
    this.countryId,
    this.customerTypeId,
    this.customerTypeName,
    this.firstName,
    this.phoneNumber,
    this.referralCode,
    this.customerId,
    this.middleName,
  });

  String? lastName;
  String? contactId;
  String? profileStatus;
  String? emailId;
  String? userId;
  String? countryId;
  String? customerTypeId;
  String? customerTypeName;
  String? firstName;
  String? phoneNumber;
  String? referralCode;
  String? customerId;
  String? middleName;

  factory Userinfo.fromJson(Map<String, dynamic> json) => Userinfo(
    lastName: json["lastName"] == null ? null : json["lastName"],
    contactId: json["contactId"] == null ? null : json["contactId"],
    profileStatus: json["profileStatus"] == null ? null : json["profileStatus"],
    emailId: json["emailId"] == null ? null : json["emailId"],
    userId: json["userId"] == null ? null : json["userId"],
    countryId: json["countryId"] == null ? null : json["countryId"],
    customerTypeId: json["customerTypeId"] == null ? null : json["customerTypeId"],
    customerTypeName: json["customerTypeName"] == null ? null : json["customerTypeName"],
    firstName: json["firstName"] == null ? null : json["firstName"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    referralCode: json["referralCode"] == null ? null : json["referralCode"],
    customerId: json["customerId"] == null ? null : json["customerId"],
    middleName: json["middleName"] == null ? null : json["middleName"],
  );

  Map<String, dynamic> toJson() => {
    "lastName": lastName == null ? null : lastName,
    "contactId": contactId == null ? null : contactId,
    "profileStatus": profileStatus == null ? null : profileStatus,
    "emailId": emailId == null ? null : emailId,
    "userId": userId == null ? null : userId,
    "countryId": countryId == null ? null : countryId,
    "customerTypeId": customerTypeId == null ? null : customerTypeId,
    "customerTypeName": customerTypeName == null ? null : customerTypeName,
    "firstName": firstName == null ? null : firstName,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "referralCode": referralCode == null ? null : referralCode,
    "customerId": customerId == null ? null : customerId,
    "middleName": middleName == null ? null : middleName,
  };
}
