// To parse this JSON data, do
//
//     final exchangeResponse = exchangeResponseFromJson(jsonString);

import 'dart:convert';

ExchangeResponse exchangeResponseFromJson(String str) => ExchangeResponse.fromJson(json.decode(str));

String exchangeResponseToJson(ExchangeResponse data) => json.encode(data.toJson());

class ExchangeResponse {
  ExchangeResponse({
    this.corridorName,
    this.exchangeRate,
    this.singxFee,
    this.totalPayable,
    this.receiverSingxFee,
    this.fromCountryId,
    this.toCountryId,
    this.errors,
    this.sendAmount,
    this.receiveAmount,
  });

  String? corridorName;
  double? exchangeRate;
  double? singxFee;
  double? totalPayable;
  double? receiverSingxFee;
  String? fromCountryId;
  String? toCountryId;
  List<String>? errors;
  double? sendAmount;
  double? receiveAmount;

  factory ExchangeResponse.fromJson(Map<String, dynamic> json) => ExchangeResponse(
    corridorName: json["corridorName"],
    exchangeRate: json["exchangeRate"]?.toDouble(),
    singxFee: json["singxFee"]?.toDouble(),
    totalPayable: json["totalPayable"]?.toDouble(),
    receiverSingxFee: json["receiverSingxFee"]?.toDouble(),
    fromCountryId: json["fromCountryId"],
    toCountryId: json["toCountryId"],
    errors: json["errors"] == null ? [] : List<String>.from(json["errors"]!.map((x) => x)),
    sendAmount: json["sendAmount"],
    receiveAmount: json["receiveAmount"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "corridorName": corridorName,
    "exchangeRate": exchangeRate,
    "singxFee": singxFee,
    "totalPayable": totalPayable,
    "receiverSingxFee": receiverSingxFee,
    "fromCountryId": fromCountryId,
    "toCountryId": toCountryId,
    "errors": errors == null ? [] : List<dynamic>.from(errors!.map((x) => x)),
    "sendAmount": sendAmount,
    "receiveAmount": receiveAmount,
  };
}
