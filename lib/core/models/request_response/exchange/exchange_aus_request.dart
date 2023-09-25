// To parse this JSON data, do
//
//     final exchangeAustraliaRequest = exchangeAustraliaRequestFromJson(jsonString);

import 'dart:convert';

ExchangeAustraliaRequest exchangeAustraliaRequestFromJson(String str) => ExchangeAustraliaRequest.fromJson(json.decode(str));

String exchangeAustraliaRequestToJson(ExchangeAustraliaRequest data) => json.encode(data.toJson());

class ExchangeAustraliaRequest {
  ExchangeAustraliaRequest({
    this.contactId,
    this.customerType,
    this.fromAmount,
    this.fromcurrencycode,
    this.isswift,
    this.label,
    this.toAmount,
    this.tocurrencycode,
  });

  int? contactId;
  String? customerType;
  double? fromAmount;
  String? fromcurrencycode;
  bool? isswift;
  String? label;
  double? toAmount;
  String? tocurrencycode;

  factory ExchangeAustraliaRequest.fromJson(Map<String, dynamic> json) => ExchangeAustraliaRequest(
    contactId: json["contactId"] == null ? null : json["contactId"],
    customerType: json["customerType"] == null ? null : json["customerType"],
    fromAmount: json["fromAmount"] == null ? null : json["fromAmount"],
    fromcurrencycode: json["fromcurrencycode"] == null ? null : json["fromcurrencycode"],
    isswift: json["isswift"] == null ? null : json["isswift"],
    label: json["label"] == null ? null : json["label"],
    toAmount: json["toAmount"] == null ? null : json["toAmount"],
    tocurrencycode: json["tocurrencycode"] == null ? null : json["tocurrencycode"],
  );

  Map<String, dynamic> toJson() => {
    "contactId": contactId == null ? null : contactId,
    "customerType": customerType == null ? null : customerType,
    "fromAmount": fromAmount == null ? null : fromAmount,
    "fromcurrencycode": fromcurrencycode == null ? null : fromcurrencycode,
    "isswift": isswift == null ? null : isswift,
    "label": label == null ? null : label,
    "toAmount": toAmount == null ? null : toAmount,
    "tocurrencycode": tocurrencycode == null ? null : tocurrencycode,
  };
}
