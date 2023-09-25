import 'dart:convert';

RefreshTokenResponse refreshTokenResponseFromJson(String str) => RefreshTokenResponse.fromJson(json.decode(str));

String refreshTokenResponseToJson(RefreshTokenResponse data) => json.encode(data.toJson());

class RefreshTokenResponse {
  RefreshTokenResponse({
    this.success,
    this.message,
    this.token,
  });

  bool? success;
  String? message;
  String? token;

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) => RefreshTokenResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    token: json["token"] == null ? null : json["token"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "token": token == null ? null : token,
  };
}
