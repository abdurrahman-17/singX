// To parse this JSON data, do
//
//     final exchangeRequest = exchangeRequestFromJson(jsonString);

import 'dart:convert';

ExchangeRequest exchangeRequestFromJson(String str) => ExchangeRequest.fromJson(json.decode(str));

String exchangeRequestToJson(ExchangeRequest data) => json.encode(data.toJson());

class ExchangeRequest {
  ExchangeRequest({
    this.fromCurrency,
    this.toCurrency,
    this.type,
    this.amount,
    this.swift,
    this.cash,
    this.wallet,
  });

  String? fromCurrency;
  String? toCurrency;
  String? type;
  double? amount;
  bool? swift;
  bool? cash;
  bool? wallet;

  factory ExchangeRequest.fromJson(Map<String, dynamic> json) => ExchangeRequest(
    fromCurrency: json["fromCurrency"],
    toCurrency: json["toCurrency"],
    type: json["type"],
    amount: json["amount"],
    swift: json["swift"],
    cash: json["cashPickup"],
    wallet: json["wallet"],
  );

  Map<String, dynamic> toJson() => {
    "fromCurrency": fromCurrency,
    "toCurrency": toCurrency,
    "type": type,
    "amount": amount,
    "swift": swift,
    "cashPickup": cash,
    "wallet": wallet,
  };
}
