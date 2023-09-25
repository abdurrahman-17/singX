// To parse this JSON data, do
//
//     final senderFieldsResponse = senderFieldsResponseFromJson(jsonString);

import 'dart:convert';

List<SenderFieldsResponse> senderFieldsResponseFromJson(String str) => List<SenderFieldsResponse>.from(json.decode(str).map((x) => SenderFieldsResponse.fromJson(x)));

String senderFieldsResponseToJson(List<SenderFieldsResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SenderFieldsResponse {
  SenderFieldsResponse({
    this.field,
    this.type,
    this.visible,
    this.required,
    this.label,
    this.sortOrder,
    this.fieldType,
    this.max,
    this.options,
    this.map,
  });

  String? field;
  String? type;
  bool? visible;
  bool? required;
  String? label;
  int? sortOrder;
  String? fieldType;
  String? max;
  List<String>? options;
  List<MapElement>? map;

  factory SenderFieldsResponse.fromJson(Map<String, dynamic> json) => SenderFieldsResponse(
    field: json["field"] == null ? null : json["field"],
    type: json["type"] == null ? null : json["type"],
    visible: json["visible"] == null ? null : json["visible"],
    required: json["required"] == null ? null : json["required"],
    label: json["label"] == null ? null : json["label"],
    sortOrder: json["sortOrder"] == null ? null : json["sortOrder"],
    fieldType: json["fieldType"] == null ? null : json["fieldType"],
    max: json["max"] == null ? null : json["max"],
    options: json["options"] == null ? null : List<String>.from(json["options"].map((x) => x)),
    map: json["map"] == null ? null : List<MapElement>.from(json["map"].map((x) => MapElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "field": field == null ? null : field,
    "type": type == null ? null : type,
    "visible": visible == null ? null : visible,
    "required": required == null ? null : required,
    "label": label == null ? null : label,
    "sortOrder": sortOrder == null ? null : sortOrder,
    "fieldType": fieldType == null ? null : fieldType,
    "max": max == null ? null : max,
    "options": options == null ? null : List<dynamic>.from(options!.map((x) => x)),
    "map": map == null ? null : List<dynamic>.from(map!.map((x) => x.toJson())),
  };
}

class MapElement {
  MapElement({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory MapElement.fromJson(Map<String, dynamic> json) => MapElement(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
  };
}
