// To parse this JSON data, do
//
//     final transactionStatusResponse = transactionStatusResponseFromJson(jsonString);

import 'dart:convert';

List<TransactionStatusResponse> transactionStatusResponseFromJson(String str) => List<TransactionStatusResponse>.from(json.decode(str).map((x) => TransactionStatusResponse.fromJson(x)));

String transactionStatusResponseToJson(List<TransactionStatusResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransactionStatusResponse {
  TransactionStatusResponse({
    this.stageId,
    this.statusName,
  });

  int? stageId;
  String? statusName;

  factory TransactionStatusResponse.fromJson(Map<String, dynamic> json) => TransactionStatusResponse(
    stageId: json["stageId"] == null ? null : json["stageId"],
    statusName: json["statusName"] == null ? null : json["statusName"],
  );

  Map<String, dynamic> toJson() => {
    "stageId": stageId == null ? null : stageId,
    "statusName": statusName == null ? null : statusName,
  };
}
