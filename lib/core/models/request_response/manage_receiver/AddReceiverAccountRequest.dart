// To parse this JSON data, do
//
//     final addReceiverAccountRequest = addReceiverAccountRequestFromJson(jsonString);

import 'dart:convert';

AddReceiverAccountRequest addReceiverAccountRequestFromJson(String str) => AddReceiverAccountRequest.fromJson(json.decode(str));

String addReceiverAccountRequestToJson(AddReceiverAccountRequest data) => json.encode(data.toJson());

class AddReceiverAccountRequest {
  AddReceiverAccountRequest({
    this.countryId,
    this.receiverCurrency,
    this.receiverType,
    this.email,
    this.receiverName,
    this.senderRelationship,
    this.accountNumber,
    this.address,
    this.branchCode,
    this.accountType,
  });

  String? countryId;
  String? receiverCurrency;
  String? receiverType;
  String? email;
  String? receiverName;
  String? senderRelationship;
  String? accountNumber;
  String? address;
  String? branchCode;
  String? accountType;

  factory AddReceiverAccountRequest.fromJson(Map<String, dynamic> json) => AddReceiverAccountRequest(
    countryId: json["countryId"] == null ? null : json["countryId"],
    receiverCurrency: json["receiverCurrency"] == null ? null : json["receiverCurrency"],
    receiverType: json["receiverType"] == null ? null : json["receiverType"],
    email: json["email"] == null ? null : json["email"],
    receiverName: json["receiverName"] == null ? null : json["receiverName"],
    senderRelationship: json["senderRelationship"] == null ? null : json["senderRelationship"],
    accountNumber: json["accountNumber"] == null ? null : json["accountNumber"],
    address: json["address"] == null ? null : json["address"],
    branchCode: json["branchCode"] == null ? null : json["branchCode"],
    accountType: json["accountType"] == null ? null : json["accountType"],
  );

  Map<String, dynamic> toJson() => {
    "countryId": countryId == null ? null : countryId,
    "receiverCurrency": receiverCurrency == null ? null : receiverCurrency,
    "receiverType": receiverType == null ? null : receiverType,
    "email": email == null ? null : email,
    "receiverName": receiverName == null ? null : receiverName,
    "senderRelationship": senderRelationship == null ? null : senderRelationship,
    "accountNumber": accountNumber == null ? null : accountNumber,
    "address": address == null ? null : address,
    "branchCode": branchCode == null ? null : branchCode,
    "accountType": accountType == null ? null : accountType,
  };
}
