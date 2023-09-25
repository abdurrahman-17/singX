// To parse this JSON data, do
//
//     final receiverFieldsResponse = receiverFieldsResponseFromJson(jsonString);

import 'dart:convert';

List<ReceiverFieldsResponse> receiverFieldsResponseFromJson(String str) => List<ReceiverFieldsResponse>.from(json.decode(str).map((x) => ReceiverFieldsResponse.fromJson(x)));

String receiverFieldsResponseToJson(List<ReceiverFieldsResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReceiverFieldsResponse {
  ReceiverFieldsResponse({
    this.field,
    this.country,
    this.currency,
    this.type,
    this.visible,
    this.required,
    this.helpText,
    this.fieldLabel,
    this.condition,
    this.sortOrder,
    this.fieldType,
    this.groupId,
    this.groupName,
    this.options,
    this.max,
    this.min,
    this.mapValue,
  });

  String? field;
  String? country;
  String? currency;
  String? type;
  bool? visible;
  bool? required;
  String? helpText;
  String? fieldLabel;
  String? condition;
  int? sortOrder;
  String? fieldType;
  int? groupId;
  String? groupName;
  List<String>? options;
  String? max;
  String? min;
  List<MapValueElement>? mapValue;

  factory ReceiverFieldsResponse.fromJson(Map<String, dynamic> json) => ReceiverFieldsResponse(
    field: json["field"] == null ? null : json["field"],
    country: json["country"] == null ? null : json["country"],
    currency: json["currency"] == null ? null : json["currency"],
    type: json["type"] == null ? null : json["type"],
    visible: json["visible"] == null ? null : json["visible"],
    required: json["required"] == null ? null : json["required"],
    helpText: json["helpText"] == null ? null : json["helpText"],
    fieldLabel: json["fieldLabel"] == null ? null : json["fieldLabel"],
    condition: json["condition"] == null ? null : json["condition"],
    sortOrder: json["sortOrder"] == null ? null : json["sortOrder"],
    fieldType: json["fieldType"] == null ? null : json["fieldType"],
    groupId: json["groupId"] == null ? null : json["groupId"],
    groupName: json["groupName"] == null ? null : json["groupName"],
    options: json["options"] == null ? null : List<String>.from(json["options"].map((x) => x)),
    max: json["max"] == null ? null : json["max"],
    min: json["min"] == null ? null : json["min"],
    mapValue: json["map"] == null ? null : List<MapValueElement>.from(json["map"].map((x) => MapValueElement.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
    "field": field == null ? null : field,
    "country": country == null ? null : country,
    "currency": currency == null ? null : currency,
    "type": type == null ? null : type,
    "visible": visible == null ? null : visible,
    "required": required == null ? null : required,
    "helpText": helpText == null ? null : helpText,
    "fieldLabel": fieldLabel == null ? null : fieldLabel,
    "condition": condition == null ? null : condition,
    "sortOrder": sortOrder == null ? null : sortOrder,
    "fieldType": fieldType == null ? null : fieldType,
    "groupId": groupId == null ? null : groupId,
    "groupName": groupName == null ? null : groupName,
    "options": options == null ? null : List<dynamic>.from(options!.map((x) => x)),
    "max": max == null ? null : max,
    "min": min == null ? null : min,
    "map": mapValue == null ? null : List<dynamic>.from(mapValue!.map((x) => x.toJson())),

  };
}
class MapValueElement {
  MapValueElement({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory MapValueElement.fromJson(Map<String, dynamic> json) => MapValueElement(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
  };
}