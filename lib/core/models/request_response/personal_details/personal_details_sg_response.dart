// To parse this JSON data, do
//
//     final personalDetailsResponseSg = personalDetailsResponseSgFromJson(jsonString);

import 'dart:convert';

PersonalDetailsResponseSg personalDetailsResponseSgFromJson(String str) => PersonalDetailsResponseSg.fromJson(json.decode(str));

String personalDetailsResponseSgToJson(PersonalDetailsResponseSg data) => json.encode(data.toJson());

class PersonalDetailsResponseSg {
  PersonalDetailsResponseSg({
    this.success,
    this.message,
    this.error,
  });

  bool? success;
  String? message;
  String? error;

  factory PersonalDetailsResponseSg.fromJson(Map<String, dynamic> json) => PersonalDetailsResponseSg(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    error: json["error"] == null ? null : json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "error": error == null ? null : error,
  };
}
