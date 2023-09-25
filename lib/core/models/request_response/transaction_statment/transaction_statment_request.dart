// To parse this JSON data, do
//
//     final transactionStatement = transactionStatementFromJson(jsonString);

import 'dart:convert';

TransactionStatement transactionStatementFromJson(String str) => TransactionStatement.fromJson(json.decode(str));

String transactionStatementToJson(TransactionStatement data) => json.encode(data.toJson());

class TransactionStatement {
  TransactionStatement({
    this.contactId,
    this.countryId,
    this.fromDate,
    this.statusId,
    this.toDate,
  });

  int? contactId;
  int? countryId;
  String? fromDate;
  int? statusId;
  String? toDate;

  factory TransactionStatement.fromJson(Map<String, dynamic> json) => TransactionStatement(
    contactId: json["contactId"] == null ? null : json["contactId"],
    countryId: json["countryId"] == null ? null : json["countryId"],
    fromDate: json["fromDate"] == null ? null : json["fromDate"],
    statusId: json["statusId"] == null ? null : json["statusId"],
    toDate: json["toDate"] == null ? null : json["toDate"],
  );

  Map<String, dynamic> toJson() => {
    "contactId": contactId == null ? null : contactId,
    "countryId": countryId == null ? null : countryId,
    "fromDate": fromDate == null ? null : fromDate,
    "statusId": statusId == null ? null : statusId,
    "toDate": toDate == null ? null : toDate,
  };
}
