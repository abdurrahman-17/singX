// To parse this JSON data, do
//
//     final sgWalletTransactionHistory = sgWalletTransactionHistoryFromJson(jsonString);

import 'dart:convert';

List<SgWalletTransactionHistory> sgWalletTransactionHistoryFromJson(String str) => List<SgWalletTransactionHistory>.from(json.decode(str).map((x) => SgWalletTransactionHistory.fromJson(x)));

String sgWalletTransactionHistoryToJson(List<SgWalletTransactionHistory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SgWalletTransactionHistory {
  SgWalletTransactionHistory({
    this.description,
    this.amount,
    this.producttxnid,
    this.txnstatus,
    this.transactiontype,
    this.currency,
    this.txndate,
    this.runningbal,
  });

  String? description;
  double? amount;
  String? producttxnid;
  String? txnstatus;
  String? transactiontype;
  String? currency;
  String? txndate;
  double? runningbal;

  factory SgWalletTransactionHistory.fromJson(Map<String, dynamic> json) => SgWalletTransactionHistory(
    description: json["description"] == null ? null : json["description"],
    amount: json["amount"] == null ? null : json["amount"],
    producttxnid: json["producttxnid"] == null ? null : json["producttxnid"],
    txnstatus: json["txnstatus"] == null ? null : json["txnstatus"],
    transactiontype: json["transactiontype"] == null ? null : json["transactiontype"],
    currency: json["currency"] == null ? null : json["currency"],
    txndate: json["txndate"] == null ? null : json["txndate"],
    runningbal: json["runningbal"] == null ? null : json["runningbal"],
  );

  Map<String, dynamic> toJson() => {
    "description": description == null ? null : description,
    "amount": amount == null ? null : amount,
    "producttxnid": producttxnid == null ? null : producttxnid,
    "txnstatus": txnstatus == null ? null : txnstatus,
    "transactiontype": transactiontype == null ? null : transactiontype,
    "currency": currency == null ? null : currency,
    "txndate": txndate == null ? null : txndate,
    "runningbal": runningbal == null ? null : runningbal,
  };
}
