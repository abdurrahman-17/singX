// To parse this JSON data, do
//
//     final dropdownResponse = dropdownResponseFromJson(jsonString);

import 'dart:convert';

DropdownResponse dropdownResponseFromJson(String str) => DropdownResponse.fromJson(json.decode(str));

String dropdownResponseToJson(DropdownResponse data) => json.encode(data.toJson());

class DropdownResponse {
  DropdownResponse({
    this.list,
  });

  List<String>? list;

  factory DropdownResponse.fromJson(Map<String, dynamic> json) => DropdownResponse(
    list: json["list"] == null ? null : List<String>.from(json["list"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "list": list == null ? null : List<dynamic>.from(list!.map((x) => x)),
  };

  @override
  String toString() {
    return '${list!}';
  }
}


List<DropdownResponseResidence> dropdownResponseResidenceFromJson(String str) => List<DropdownResponseResidence>.from(json.decode(str).map((x) => DropdownResponseResidence.fromJson(x)));

String dropdownResponseResidenceToJson(List<DropdownResponseResidence> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DropdownResponseResidence {
  DropdownResponseResidence({
    this.primarykey,
    this.id,
    this.value,
  });

  String? primarykey;
  int? id;
  String? value;

  factory DropdownResponseResidence.fromJson(Map<String, dynamic> json) => DropdownResponseResidence(
    primarykey: json["primarykey"] == null ? null : json["primarykey"],
    id: json["id"] == null ? null : json["id"],
    value: json["value"] == null ? null : json["value"],
  );

  Map<String, dynamic> toJson() => {
    "primarykey": primarykey == null ? null : primarykey,
    "id": id == null ? null : id,
    "value": value == null ? null : value,
  };

  @override
  String toString() {
    return '${value!.toLowerCase()}';
  }
}
