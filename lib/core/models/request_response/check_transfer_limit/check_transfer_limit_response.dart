// To parse this JSON data, do
//
//     final checkTransferLimitResponse = checkTransferLimitResponseFromJson(jsonString);

import 'dart:convert';

CheckTransferLimitResponse checkTransferLimitResponseFromJson(String str) => CheckTransferLimitResponse.fromJson(json.decode(str));

String checkTransferLimitResponseToJson(CheckTransferLimitResponse data) => json.encode(data.toJson());

class CheckTransferLimitResponse {
  CheckTransferLimitResponse({
    this.response,
  });

  ResponseCheckData? response;

  factory CheckTransferLimitResponse.fromJson(Map<String, dynamic> json) => CheckTransferLimitResponse(
    response: json["response"] == null ? null : ResponseCheckData.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "response": response == null ? null : response!.toJson(),
  };
}

class ResponseCheckData {
  ResponseCheckData({
    this.success,
    this.message,
    this.data,
  });

  bool? success;
  String? message;
  CheckLimitData? data;

  factory ResponseCheckData.fromJson(Map<String, dynamic> json) => ResponseCheckData(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : CheckLimitData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : data!.toJson(),
  };
}

class CheckLimitData {
  CheckLimitData({
    this.limit,
    this.error,
  });

  double? limit;
  String? error;

  factory CheckLimitData.fromJson(Map<String, dynamic> json) => CheckLimitData(
    limit: json["limit"] == null ? null : json["limit"],
    error: json["error"] == null ? null : json["error"],
  );

  Map<String, dynamic> toJson() => {
    "limit": limit == null ? null : limit,
    "error": error == null ? null : error,
  };
}



CheckTransferLimitSuccessResponse checkTransferLimitSuccessResponseFromJson(String str) => CheckTransferLimitSuccessResponse.fromJson(json.decode(str));

String checkTransferLimitSuccessResponseToJson(CheckTransferLimitSuccessResponse data) => json.encode(data.toJson());

class CheckTransferLimitSuccessResponse {
  CheckTransferLimitSuccessResponse({
    this.response,
  });

  ResponseCheckSuccessData? response;

  factory CheckTransferLimitSuccessResponse.fromJson(Map<String, dynamic> json) => CheckTransferLimitSuccessResponse(
    response: json["response"] == null ? null : ResponseCheckSuccessData.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "response": response == null ? null : response!.toJson(),
  };
}

class ResponseCheckSuccessData {
  ResponseCheckSuccessData({
    this.success,
    this.message,
    this.data,
  });

  bool? success;
  String? message;
  String? data;

  factory ResponseCheckSuccessData.fromJson(Map<String, dynamic> json) => ResponseCheckSuccessData(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : json["data"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : data,
  };
}
