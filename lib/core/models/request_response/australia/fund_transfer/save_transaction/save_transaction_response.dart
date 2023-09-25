// To parse this JSON data, do
//
//     final saveTransactionResponse = saveTransactionResponseFromJson(jsonString);

import 'dart:convert';

SaveTransactionResponse saveTransactionResponseFromJson(String str) => SaveTransactionResponse.fromJson(json.decode(str));

String saveTransactionResponseToJson(SaveTransactionResponse data) => json.encode(data.toJson());

class SaveTransactionResponse {
  SaveTransactionResponse({
    this.userTxnId,
    this.bankname,
    this.accountname,
    this.accountnumber,
    this.bsbcode,
    this.message,
    this.contactId,
    this.success,
  });

  String? userTxnId;
  String? bankname;
  String? accountname;
  int? accountnumber;
  String? bsbcode;
  String? message;
  int? contactId;
  bool? success;

  factory SaveTransactionResponse.fromJson(Map<String, dynamic> json) => SaveTransactionResponse(
    userTxnId: json["userTxnID"] == null ? null : json["userTxnID"],
    bankname: json["bankname"] == null ? null : json["bankname"],
    accountname: json["accountname"] == null ? null : json["accountname"],
    accountnumber: json["accountnumber"] == null ? null : json["accountnumber"],
    bsbcode: json["bsbcode"] == null ? null : json["bsbcode"],
    message: json["message"] == null ? null : json["message"],
    contactId: json["contactId"] == null ? null : json["contactId"],
    success: json["success"] == null ? null : json["success"],
  );

  Map<String, dynamic> toJson() => {
    "userTxnID": userTxnId == null ? null : userTxnId,
    "bankname": bankname == null ? null : bankname,
    "accountname": accountname == null ? null : accountname,
    "accountnumber": accountnumber == null ? null : accountnumber,
    "bsbcode": bsbcode == null ? null : bsbcode,
    "message": message == null ? null : message,
    "contactId": contactId == null ? null : contactId,
    "success": success == null ? null : success,
  };
}
