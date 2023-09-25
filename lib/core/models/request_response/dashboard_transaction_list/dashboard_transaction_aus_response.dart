// To parse this JSON data, do
//
//     final dashboardTransactionAustraliaResponse = dashboardTransactionAustraliaResponseFromJson(jsonString);

import 'dart:convert';

List<DashboardTransactionAustraliaResponse> dashboardTransactionAustraliaResponseFromJson(String str) => List<DashboardTransactionAustraliaResponse>.from(json.decode(str).map((x) => DashboardTransactionAustraliaResponse.fromJson(x)));

String dashboardTransactionAustraliaResponseToJson(List<DashboardTransactionAustraliaResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DashboardTransactionAustraliaResponse {
  DashboardTransactionAustraliaResponse({
    this.transactiondt,
    this.recname,
    this.sendamnt,
    this.exchngrate,
    this.totalPayable,
    this.usrtxnid,
    this.txnstatus,
  });

  DateTime? transactiondt;
  String? recname;
  String? sendamnt;
  String? exchngrate;
  String? totalPayable;
  String? usrtxnid;
  String? txnstatus;

  factory DashboardTransactionAustraliaResponse.fromJson(Map<String, dynamic> json) => DashboardTransactionAustraliaResponse(
    transactiondt: json["transactiondt"] == null ? null : DateTime.parse(json["transactiondt"]),
    recname: json["recname"] == null ? null : json["recname"],
    sendamnt: json["sendamnt"] == null ? null : json["sendamnt"],
    exchngrate: json["exchngrate"] == null ? null : json["exchngrate"],
    totalPayable: json["totalPayable"] == null ? null : json["totalPayable"],
    usrtxnid: json["usrtxnid"] == null ? null : json["usrtxnid"],
    txnstatus: json["txnstatus"] == null ? null : json["txnstatus"],
  );

  Map<String, dynamic> toJson() => {
    "transactiondt": transactiondt == null ? null : "${transactiondt!.year.toString().padLeft(4, '0')}-${transactiondt!.month.toString().padLeft(2, '0')}-${transactiondt!.day.toString().padLeft(2, '0')}",
    "recname": recname == null ? null : recname,
    "sendamnt": sendamnt == null ? null : sendamnt,
    "exchngrate": exchngrate == null ? null : exchngrate,
    "totalPayable": totalPayable == null ? null : totalPayable,
    "usrtxnid": usrtxnid == null ? null : usrtxnid,
    "txnstatus": txnstatus == null ? null : txnstatus,
  };
}

