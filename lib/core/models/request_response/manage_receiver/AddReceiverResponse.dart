// To parse this JSON data, do
//
//     final addReceiverResponse = addReceiverResponseFromJson(jsonString);

import 'dart:convert';

AddReceiverResponse addReceiverResponseFromJson(String str) => AddReceiverResponse.fromJson(json.decode(str));

String addReceiverResponseToJson(AddReceiverResponse data) => json.encode(data.toJson());

class AddReceiverResponse {
  AddReceiverResponse({
    this.success=false,
    this.errors,
    this.id,
    this.message,
  });

  bool success;
  List<String>? errors;
  String? id;
  String? message;

  factory AddReceiverResponse.fromJson(Map<String, dynamic> json) => AddReceiverResponse(
    success: json["success"] == null ? null : json["success"],
    errors: json["errors"] == null ? null : List<String>.from(json["errors"].map((x) => x)),
    id: json["id"] == null ? null : json["id"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? false : success,
    "errors": errors == null ? null : List<dynamic>.from(errors!.map((x) => x)),
    "id": id == null ? null : id,
    "message": message == null ? null : message,
  };
}
