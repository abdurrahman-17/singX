// To parse this JSON data, do
//
//     final exchangeAustraliaResponse = exchangeAustraliaResponseFromJson(jsonString);

import 'dart:convert';

ExchangeAustraliaResponse exchangeAustraliaResponseFromJson(String str) => ExchangeAustraliaResponse.fromJson(json.decode(str));

String exchangeAustraliaResponseToJson(ExchangeAustraliaResponse data) => json.encode(data.toJson());

class ExchangeAustraliaResponse {
  ExchangeAustraliaResponse({
    this.response,
    this.transfermodefee,
  });

  ResponseData? response;
  List<Transfermodefee>? transfermodefee;

  factory ExchangeAustraliaResponse.fromJson(Map<String, dynamic> json) => ExchangeAustraliaResponse(
    response: json["response"] == null ? null : ResponseData.fromJson(json["response"]),
    transfermodefee: json["transfermodefee"] == null ? null : List<Transfermodefee>.from(json["transfermodefee"].map((x) => Transfermodefee.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "response": response == null ? null : response!.toJson(),
    "transfermodefee": transfermodefee == null ? null : List<dynamic>.from(transfermodefee!.map((x) => x.toJson())),
  };
}

class ResponseData {
  ResponseData({
    this.sendamount,
    this.receiveamount,
    this.corridorId,
    this.corridorName,
    this.exchangeRate,
    this.singxFee,
    this.frmcountryId,
    this.tocountryId,
  });

  double? sendamount;
  double? receiveamount;
  int? corridorId;
  String? corridorName;
  double? exchangeRate;
  double? singxFee;
  int? frmcountryId;
  int? tocountryId;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    sendamount: json["sendamount"] == null ? null : json["sendamount"],
    receiveamount: json["receiveamount"] == null ? null : json["receiveamount"],
    corridorId: json["corridorId"] == null ? null : json["corridorId"],
    corridorName: json["corridorName"] == null ? null : json["corridorName"],
    exchangeRate: json["exchangeRate"] == null ? null : json["exchangeRate"].toDouble(),
    singxFee: json["singxFee"] == null ? null : json["singxFee"].toDouble(),
    frmcountryId: json["frmcountryId"] == null ? null : json["frmcountryId"],
    tocountryId: json["tocountryId"] == null ? null : json["tocountryId"],
  );

  Map<String, dynamic> toJson() => {
    "sendamount": sendamount == null ? null : sendamount,
    "receiveamount": receiveamount == null ? null : receiveamount,
    "corridorId": corridorId == null ? null : corridorId,
    "corridorName": corridorName == null ? null : corridorName,
    "exchangeRate": exchangeRate == null ? null : exchangeRate,
    "singxFee": singxFee == null ? null : singxFee,
    "frmcountryId": frmcountryId == null ? null : frmcountryId,
    "tocountryId": tocountryId == null ? null : tocountryId,
  };
}

class Transfermodefee {
  Transfermodefee({
    this.transferType,
    this.transferFee,
    this.transfermodeId,
  });

  String? transferType;
  double? transferFee;
  int? transfermodeId;

  factory Transfermodefee.fromJson(Map<String, dynamic> json) => Transfermodefee(
    transferType: json["transfer_Type"] == null ? null : json["transfer_Type"],
    transferFee: json["transfer_Fee"] == null ? null : json["transfer_Fee"],
    transfermodeId: json["transfermodeId"] == null ? null : json["transfermodeId"],
  );

  Map<String, dynamic> toJson() => {
    "transfer_Type": transferType == null ? null : transferType,
    "transfer_Fee": transferFee == null ? null : transferFee,
    "transfermodeId": transfermodeId == null ? null : transfermodeId,
  };
}
