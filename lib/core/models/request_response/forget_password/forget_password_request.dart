import 'dart:convert';

ForgetPasswordRequest forgetPasswordRequestFromJson(String str) => ForgetPasswordRequest.fromJson(json.decode(str));

String forgetPasswordRequestToJson(ForgetPasswordRequest data) => json.encode(data.toJson());

class ForgetPasswordRequest {
  ForgetPasswordRequest({
    this.source,
    this.email,
  });

  String? source;
  String? email;

  factory ForgetPasswordRequest.fromJson(Map<String, dynamic> json) => ForgetPasswordRequest(
    source: json["source"] == null ? null : json["source"],
    email: json["email"] == null ? null : json["email"],
  );

  Map<String, dynamic> toJson() => {
    "source": source == null ? null : source,
    "email": email == null ? null : email,
  };
}
