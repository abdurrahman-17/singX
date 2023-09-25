import 'dart:convert';

ForgetPasswordStep2Response forgetPasswordStep2ResponseFromJson(String str) => ForgetPasswordStep2Response.fromJson(json.decode(str));

String forgetPasswordStep2ResponseToJson(ForgetPasswordStep2Response data) => json.encode(data.toJson());

class ForgetPasswordStep2Response {
  ForgetPasswordStep2Response({
    this.success,
    this.message,
  });

  bool? success;
  String? message;

  factory ForgetPasswordStep2Response.fromJson(Map<String, dynamic> json) => ForgetPasswordStep2Response(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
  };
}
