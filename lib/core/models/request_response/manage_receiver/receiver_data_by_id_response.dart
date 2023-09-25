// To parse this JSON data, do
//
//     final receiverDataByIdResponse = receiverDataByIdResponseFromJson(jsonString);

import 'dart:convert';

ReceiverDataByIdResponse receiverDataByIdResponseFromJson(String str) => ReceiverDataByIdResponse.fromJson(json.decode(str));

String receiverDataByIdResponseToJson(ReceiverDataByIdResponse data) => json.encode(data.toJson());

class ReceiverDataByIdResponse {
  ReceiverDataByIdResponse({
    this.id,
    this.name,
    this.accountNumber,
    this.bankName,
    this.branchName,
    this.country,
    this.address,
    this.accountType,
  });

  String? id;
  String? name;
  String? accountNumber;
  String? bankName;
  String? branchName;
  String? country;
  String? address;
  String? accountType;

  factory ReceiverDataByIdResponse.fromJson(Map<String, dynamic> json) => ReceiverDataByIdResponse(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    accountNumber: json["accountNumber"] == null ? null : json["accountNumber"],
    bankName: json["bankName"] == null ? null : json["bankName"],
    branchName: json["branchName"] == null ? null : json["branchName"],
    country: json["country"] == null ? null : json["country"],
    address: json["address"] == null ? null : json["address"],
    accountType: json["accountType"] == null ? null : json["accountType"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "accountNumber": accountNumber == null ? null : accountNumber,
    "bankName": bankName == null ? null : bankName,
    "branchName": branchName == null ? null : branchName,
    "country": country == null ? null : country,
    "address": address == null ? null : address,
    "accountType": accountType == null ? null : accountType,
  };
}
