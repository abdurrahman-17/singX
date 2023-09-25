// To parse this JSON data, do
//
//     final singPassUrl = singPassUrlFromJson(jsonString);

import 'dart:convert';

SingPassUrl singPassUrlFromJson(String str) => SingPassUrl.fromJson(json.decode(str));

String singPassUrlToJson(SingPassUrl data) => json.encode(data.toJson());

class SingPassUrl {
  SingPassUrl({
    this.id,
    this.url,
  });

  String? id;
  String? url;

  factory SingPassUrl.fromJson(Map<String, dynamic> json) => SingPassUrl(
    id: json["id"] == null ? null : json["id"],
    url: json["url"] == null ? null : json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "url": url == null ? null : url,
  };
}
