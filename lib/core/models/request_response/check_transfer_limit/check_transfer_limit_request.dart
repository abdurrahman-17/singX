// To parse this JSON data, do
//
//     final checkTransferLimitRequest = checkTransferLimitRequestFromJson(jsonString);

import 'dart:convert';

CheckTransferLimitRequest checkTransferLimitRequestFromJson(String str) => CheckTransferLimitRequest.fromJson(json.decode(str));

String checkTransferLimitRequestToJson(CheckTransferLimitRequest data) => json.encode(data.toJson());

class CheckTransferLimitRequest {
  CheckTransferLimitRequest({
    this.fromcurrency,
    this.sendAmount,
    this.tocurrency,
    this.receiveAmount,
  });

  String? fromcurrency;
  double? sendAmount;
  String? tocurrency;
  double? receiveAmount;

  factory CheckTransferLimitRequest.fromJson(Map<String, dynamic> json) => CheckTransferLimitRequest(
    fromcurrency: json["fromcurrency"] == null ? null : json["fromcurrency"],
    sendAmount: json["sendAmount"] == null ? null : json["sendAmount"],
    tocurrency: json["tocurrency"] == null ? null : json["tocurrency"],
    receiveAmount: json["receiveAmount"] == null ? null : json["receiveAmount"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "fromcurrency": fromcurrency == null ? null : fromcurrency,
    "sendAmount": sendAmount == null ? null : sendAmount,
    "tocurrency": tocurrency == null ? null : tocurrency,
    "receiveAmount": receiveAmount == null ? null : receiveAmount,
  };
}
