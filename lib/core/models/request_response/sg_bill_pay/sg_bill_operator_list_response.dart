// To parse this JSON data, do
//
//     final operatorList = operatorListFromJson(jsonString);

import 'dart:convert';

List<OperatorList> operatorListFromJson(String str) => List<OperatorList>.from(json.decode(str).map((x) => OperatorList.fromJson(x)));

String operatorListToJson(List<OperatorList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OperatorList {
  OperatorList({
    this.operatorId,
    this.activeStatusAu,
    this.activeStatusHk,
    this.activeStatusSg,
    this.ad1,
    this.ad2,
    this.ad3,
    this.bbpsEnabled,
    this.category,
    this.circleId,
    this.cn,
    this.countryId,
    this.operatorName,
    this.regex,
    this.viewBill,
    this.productType,
    this.viewBillId,
  });

  int? operatorId;
  int? activeStatusAu;
  int? activeStatusHk;
  int? activeStatusSg;
  String? ad1;
  String? ad2;
  String? ad3;
  String? bbpsEnabled;
  String? category;
  int? circleId;
  String? cn;
  int? countryId;
  String? operatorName;
  String? regex;
  String? viewBill;
  ProductType? productType;
  int? viewBillId;

  factory OperatorList.fromJson(Map<String, dynamic> json) => OperatorList(
    operatorId: json["operatorId"],
    activeStatusAu: json["activeStatusAU"],
    activeStatusHk: json["activeStatusHK"],
    activeStatusSg: json["activeStatusSG"],
    ad1: json["ad1"],
    ad2: json["ad2"],
    ad3: json["ad3"],
    bbpsEnabled: json["bbps_Enabled"],
    category: json["category"],
    circleId: json["circleId"],
    cn: json["cn"],
    countryId: json["countryId"],
    operatorName: json["operatorName"],
    regex: json["regex"],
    viewBill: json["viewBill"],
    productType: ProductType.fromJson(json["productType"]),
    viewBillId: json["viewBillId"],
  );

  Map<String, dynamic> toJson() => {
    "operatorId": operatorId,
    "activeStatusAU": activeStatusAu,
    "activeStatusHK": activeStatusHk,
    "activeStatusSG": activeStatusSg,
    "ad1": ad1,
    "ad2": ad2,
    "ad3": ad3,
    "bbps_Enabled": bbpsEnabled,
    "category": category,
    "circleId": circleId,
    "cn": cn,
    "countryId": countryId,
    "operatorName": operatorName,
    "regex": regex,
    "viewBill": viewBill,
    "productType": productType!.toJson(),
    "viewBillId": viewBillId,
  };
}

class ProductType {
  ProductType({
    this.productId,
    this.activeStatusAu,
    this.activeStatusHk,
    this.activeStatusSg,
    this.countryId,
    this.productName,
    this.type,
  });

  int? productId;
  int? activeStatusAu;
  int? activeStatusHk;
  int? activeStatusSg;
  int? countryId;
  String? productName;
  String? type;

  factory ProductType.fromJson(Map<String, dynamic> json) => ProductType(
    productId: json["product_Id"],
    activeStatusAu: json["activeStatusAU"],
    activeStatusHk: json["activeStatusHK"],
    activeStatusSg: json["activeStatusSG"],
    countryId: json["countryId"],
    productName: json["productName"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "product_Id": productId,
    "activeStatusAU": activeStatusAu,
    "activeStatusHK": activeStatusHk,
    "activeStatusSG": activeStatusSg,
    "countryId": countryId,
    "productName": productName,
    "type": type,
  };
}
