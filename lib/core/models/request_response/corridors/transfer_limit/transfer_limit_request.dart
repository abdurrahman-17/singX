// To parse this JSON data, do
//
//     final transferLimitRequest = transferLimitRequestFromJson(jsonString);

import 'dart:convert';

TransferLimitRequest transferLimitRequestFromJson(String str) => TransferLimitRequest.fromJson(json.decode(str));

String transferLimitRequestToJson(TransferLimitRequest data) => json.encode(data.toJson());

class TransferLimitRequest {
  TransferLimitRequest({
    this.fromcurrency,
    this.sendAmount,
    this.tocurrency,
    this.receiveAmount,
  });

  String? fromcurrency;
  int? sendAmount;
  String? tocurrency;
  int? receiveAmount;

  factory TransferLimitRequest.fromJson(Map<String, dynamic> json) => TransferLimitRequest(
    fromcurrency: json["fromcurrency"] == null ? null : json["fromcurrency"],
    sendAmount: json["sendAmount"] == null ? null : json["sendAmount"],
    tocurrency: json["tocurrency"] == null ? null : json["tocurrency"],
    receiveAmount: json["receiveAmount"] == null ? null : json["receiveAmount"],
  );

  Map<String, dynamic> toJson() => {
    "fromcurrency": fromcurrency == null ? null : fromcurrency,
    "sendAmount": sendAmount == null ? null : sendAmount,
    "tocurrency": tocurrency == null ? null : tocurrency,
    "receiveAmount": receiveAmount == null ? null : receiveAmount,
  };
}
