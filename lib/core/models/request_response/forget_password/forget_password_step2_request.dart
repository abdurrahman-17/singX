import 'dart:convert';

ForgetPasswordStep2Request forgetPasswordStep2RequestFromJson(String str) => ForgetPasswordStep2Request.fromJson(json.decode(str));

String forgetPasswordStep2RequestToJson(ForgetPasswordStep2Request data) => json.encode(data.toJson());

class ForgetPasswordStep2Request {
  ForgetPasswordStep2Request({
    this.source,
    this.email,
    this.token,
    this.password,
  });

  String? source;
  String? email;
  String? token;
  String? password;

  factory ForgetPasswordStep2Request.fromJson(Map<String, dynamic> json) => ForgetPasswordStep2Request(
    source: json["source"] == null ? null : json["source"],
    email: json["email"] == null ? null : json["email"],
    token: json["token"] == null ? null : json["token"],
    password: json["password"] == null ? null : json["password"],
  );

  Map<String, dynamic> toJson() => {
    "source": source == null ? null : source,
    "email": email == null ? null : email,
    "token": token == null ? null : token,
    "password": password == null ? null : password,
  };
}
