// To parse this JSON data, do
//
//     final addSenderAccountRequest = addSenderAccountRequestFromJson(jsonString);

import 'dart:convert';

AddSenderAccountRequest addSenderAccountRequestFromJson(String str) => AddSenderAccountRequest.fromJson(json.decode(str));

String addSenderAccountRequestToJson(AddSenderAccountRequest data) => json.encode(data.toJson());

class AddSenderAccountRequest {
  AddSenderAccountRequest({
    this.sendCurrency,
    this.firstName,
    this.jointAccount,
    this.jointAccHolderName,
    this.bankName,
    this.accountNumber,
    this.otherBankName,
  });

  String? sendCurrency;
  String? firstName;
  String? jointAccount;
  String? jointAccHolderName;
  String? bankName;
  String? accountNumber;
  String? otherBankName;

  factory AddSenderAccountRequest.fromJson(Map<String, dynamic> json) => AddSenderAccountRequest(
    sendCurrency: json["sendCurrency"] == null ? null : json["sendCurrency"],
    firstName: json["firstName"] == null ? null : json["firstName"],
    jointAccount: json["jointAccount"] == null ? null : json["jointAccount"],
    jointAccHolderName: json["jointAccHolderName"] == null ? null : json["jointAccHolderName"],
    bankName: json["bankName"] == null ? null : json["bankName"],
    accountNumber: json["accountNumber"] == null ? null : json["accountNumber"],
    otherBankName: json["otherBankName"] == null ? null : json["otherBankName"],
  );

  Map<String, dynamic> toJson() => {
    "sendCurrency": sendCurrency == null ? null : sendCurrency,
    "firstName": firstName == null ? null : firstName,
    "jointAccount": jointAccount == null ? null : jointAccount,
    "jointAccHolderName": jointAccHolderName == null ? null : jointAccHolderName,
    "bankName": bankName == null ? null : bankName,
    "accountNumber": accountNumber == null ? null : accountNumber,
    "otherBankName": otherBankName == null ? null : otherBankName,
  };
}
