// To parse this JSON data, do
//
//     final genderDropdownResponse = genderDropdownResponseFromJson(jsonString);

import 'dart:convert';

List<GenderDropdownResponse> genderDropdownResponseFromJson(String str) => List<GenderDropdownResponse>.from(json.decode(str).map((x) => GenderDropdownResponse.fromJson(x)));

String genderDropdownResponseToJson(List<GenderDropdownResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GenderDropdownResponse {
  GenderDropdownResponse({
    this.primarykey,
    this.id,
    this.value,
  });

  String? primarykey;
  int? id;
  String? value;

  factory GenderDropdownResponse.fromJson(Map<String, dynamic> json) => GenderDropdownResponse(
    primarykey: json["primarykey"] == null ? null : json["primarykey"],
    id: json["id"] == null ? null : json["id"],
    value: json["value"] == null ? null : json["value"],
  );

  Map<String, dynamic> toJson() => {
    "primarykey": primarykey == null ? null : primarykey,
    "id": id == null ? null : id,
    "value": value == null ? null : value,
  };
}
