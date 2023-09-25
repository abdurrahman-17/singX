// To parse this JSON data, do
//
//     final industryList = industryListFromJson(jsonString);

import 'dart:convert';

List<IndustryList> industryListFromJson(String str) => List<IndustryList>.from(json.decode(str).map((x) => IndustryList.fromJson(x)));

String industryListToJson(List<IndustryList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IndustryList {
  IndustryList({
    this.name,
    this.id,
  });

  String? name;
  String? id;

  factory IndustryList.fromJson(Map<String, dynamic> json) => IndustryList(
    name: json["name"] == null ? null : json["name"],
    id: json["id"] == null ? null : json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "id": id == null ? null : id,
  };
}
