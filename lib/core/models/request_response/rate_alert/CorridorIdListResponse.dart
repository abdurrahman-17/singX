// To parse this JSON data, do
//
//     final corridorIdListResponse = corridorIdListResponseFromJson(jsonString);

import 'dart:convert';


List<CorridorIdListResponse> corridorIdListResponseFromJson(String str) => List<CorridorIdListResponse>.from(json.decode(str).map((x) => CorridorIdListResponse.fromJson(x)));

String corridorIdListResponseToJson(List<CorridorIdListResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class CorridorIdListResponse {
  CorridorIdListResponse({
    this.key,
    this.value,
  });

  String? key;
  String? value;

  factory CorridorIdListResponse.fromJson(Map<String, dynamic> json) => CorridorIdListResponse(
    key: json["key"] == null ? null : json["key"],
    value: json["value"] == null ? null : json["value"],
  );

  Map<String, dynamic> toJson() => {
    "key": key == null ? null : key,
    "value": value == null ? null : value,
  };
}
