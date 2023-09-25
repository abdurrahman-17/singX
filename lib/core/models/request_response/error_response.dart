import 'dart:convert';

class ErrorResponse {
  String? message;
  List<String>? parameters;
  String? trace;

  ErrorResponse({this.message, this.parameters, this.trace});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    parameters = json['parameters'].cast<String>();
    trace = json['trace'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['parameters'] = this.parameters;
    data['trace'] = this.trace;
    return data;
  }
}

// To parse this JSON data, do
//
//     final errorString = errorStringFromJson(jsonString);


ErrorString errorStringFromJson(String str) => ErrorString.fromJson(json.decode(str));

String errorStringToJson(ErrorString data) => json.encode(data.toJson());

class ErrorString {
  ErrorString({
    this.timestamp,
    this.status,
    this.error,
  });

  DateTime? timestamp;
  int? status;
  String? error;

  factory ErrorString.fromJson(Map<String, dynamic> json) => ErrorString(
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    status: json["status"] == null ? null : json["status"],
    error: json["error"] == null ? null : json["error"],
  );

  Map<String, dynamic> toJson() => {
    "timestamp": timestamp == null ? null : timestamp!.toIso8601String(),
    "status": status == null ? null : status,
    "error": error == null ? null : error,
  };
}

// To parse this JSON data, do
//
//     final errorList = errorListFromJson(jsonString);


ErrorList errorListFromJson(String str) => ErrorList.fromJson(json.decode(str));

String errorListToJson(ErrorList data) => json.encode(data.toJson());

class ErrorList {
  ErrorList({
    this.timestamp,
    this.status,
    this.errors,
  });

  DateTime? timestamp;
  int? status;
  List<String>? errors;

  factory ErrorList.fromJson(Map<String, dynamic> json) => ErrorList(
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    status: json["status"] == null ? null : json["status"],
    errors: json["errors"] == null ? null : List<String>.from(json["errors"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "timestamp": timestamp == null ? null : timestamp!.toIso8601String(),
    "status": status == null ? null : status,
    "errors": errors == null ? null : List<dynamic>.from(errors!.map((x) => x)),
  };
}

// To parse this JSON data, do
//
//     final errorStringAus = errorStringAusFromJson(jsonString);

ErrorStringAus errorStringAusFromJson(String str) => ErrorStringAus.fromJson(json.decode(str));

String errorStringAusToJson(ErrorStringAus data) => json.encode(data.toJson());

class ErrorStringAus {
  ErrorStringAus({
    this.success,
    this.error,
  });

  bool? success;
  String? error;

  factory ErrorStringAus.fromJson(Map<String, dynamic> json) => ErrorStringAus(
    success: json["success"] == null ? null : json["success"],
    error: json["error"] == null ? null : json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "error": error == null ? null : error,
  };
}




ErrResponse errResponseFromJson(String str) => ErrResponse.fromJson(json.decode(str));

String errResponseToJson(ErrResponse data) => json.encode(data.toJson());

class ErrResponse {
  ErrResponse({
    this.timestamp,
    this.status,
    this.error,
  });

  DateTime? timestamp;
  int? status;
  String? error;

  factory ErrResponse.fromJson(Map<String, dynamic> json) => ErrResponse(
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    status: json["status"] == null ? null : json["status"],
    error: json["error"] == null ? null : json["error"],
  );

  Map<String, dynamic> toJson() => {
    "timestamp": timestamp == null ? null : timestamp!.toIso8601String(),
    "status": status == null ? null : status,
    "error": error == null ? null : error,
  };
}
