// To parse this JSON data, do
//
//     final billSaveResponse = billSaveResponseFromJson(jsonString);

import 'dart:convert';

BillSaveResponse billSaveResponseFromJson(String str) => BillSaveResponse.fromJson(json.decode(str));

String billSaveResponseToJson(BillSaveResponse data) => json.encode(data.toJson());

class BillSaveResponse {
  BillSaveResponse({
    this.status,
    this.transactionStatus,
    this.userTxnid,
  });

  String? status;
  String? transactionStatus;
  String? userTxnid;

  factory BillSaveResponse.fromJson(Map<String, dynamic> json) => BillSaveResponse(
    status: json["Status"] == null ? null : json["Status"],
    transactionStatus: json["Transaction Status"] == null ? null : json["Transaction Status"],
    userTxnid: json["UserTxnid"] == null ? null : json["UserTxnid"],
  );

  Map<String, dynamic> toJson() => {
    "Status": status == null ? null : status,
    "Transaction Status": transactionStatus == null ? null : transactionStatus,
    "UserTxnid": userTxnid == null ? null : userTxnid,
  };
}
