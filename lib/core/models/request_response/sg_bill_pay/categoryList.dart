// To parse this JSON data, do
//
//     final categoryList = categoryListFromJson(jsonString);

import 'dart:convert';

List<CategoryList> categoryListFromJson(String str) => List<CategoryList>.from(json.decode(str).map((x) => CategoryList.fromJson(x)));

String categoryListToJson(List<CategoryList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryList {
  CategoryList({
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

  factory CategoryList.fromJson(Map<String, dynamic> json) => CategoryList(
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
