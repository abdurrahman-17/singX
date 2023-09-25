import 'dart:convert';

Map<String, List<CorridorsResponse>> corridorsResponseFromJson(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, List<CorridorsResponse>>(k, List<CorridorsResponse>.from(v.map((x) => CorridorsResponse.fromJson(x)))));

String corridorsResponseToJson(Map<String, List<CorridorsResponse>> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson())))));

class CorridorsResponse {
  CorridorsResponse({
    this.key,
    this.value,
  });

  String? key;
  String? value;

  factory CorridorsResponse.fromJson(Map<String, dynamic> json) => CorridorsResponse(
    key: json["key"] == null ? null : json["key"],
    value: json["value"] == null ? null : json["value"],
  );

  Map<String, dynamic> toJson() => {
    "key": key == null ? null : key,
    "value": value == null ? null : value,
  };
}
