// To parse this JSON data, do
//
//     final jumioVerificationResponse = jumioVerificationResponseFromJson(jsonString);

import 'dart:convert';

JumioVerificationResponse jumioVerificationResponseFromJson(String str) => JumioVerificationResponse.fromJson(json.decode(str));

String jumioVerificationResponseToJson(JumioVerificationResponse data) => json.encode(data.toJson());

class JumioVerificationResponse {
  JumioVerificationResponse({
    this.transactionReference,
    this.timestamp,
    this.account,
    this.web,
    this.sdk,
    this.workflowExecution,
    this.success,
    this.message,
  });

  String? transactionReference;
  DateTime? timestamp;
  Account? account;
  Web? web;
  Sdk? sdk;
  WorkflowExecution? workflowExecution;
  bool? success;
  String? message;

  factory JumioVerificationResponse.fromJson(Map<String, dynamic> json) => JumioVerificationResponse(
    transactionReference: json["transactionReference"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    account: json["account"] == null ? null : Account.fromJson(json["account"]),
    web: json["web"] == null ? null : Web.fromJson(json["web"]),
    sdk: json["sdk"] == null ? null : Sdk.fromJson(json["sdk"]),
    workflowExecution: json["workflowExecution"] == null ? null : WorkflowExecution.fromJson(json["workflowExecution"]),
    success: json["success"] == null ? null : json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "transactionReference": transactionReference,
    "timestamp": timestamp?.toIso8601String(),
    "account": account?.toJson(),
    "web": web?.toJson(),
    "sdk": sdk?.toJson(),
    "workflowExecution": workflowExecution?.toJson(),
    "success": success == null ? null : success,
    "message": message,
  };
}

class Account {
  Account({
    this.id,
  });

  String? id;

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}

class Sdk {
  Sdk({
    this.token,
  });

  String? token;

  factory Sdk.fromJson(Map<String, dynamic> json) => Sdk(
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
  };
}

class Web {
  Web({
    this.href,
    this.successUrl,
    this.errorUrl,
  });

  String? href;
  String? successUrl;
  String? errorUrl;

  factory Web.fromJson(Map<String, dynamic> json) => Web(
    href: json["href"],
    successUrl: json["successUrl"],
    errorUrl: json["errorUrl"],
  );

  Map<String, dynamic> toJson() => {
    "href": href,
    "successUrl": successUrl,
    "errorUrl": errorUrl,
  };
}

class WorkflowExecution {
  WorkflowExecution({
    this.id,
    this.credentials,
  });

  String? id;
  List<Credential>? credentials;

  factory WorkflowExecution.fromJson(Map<String, dynamic> json) => WorkflowExecution(
    id: json["id"],
    credentials: json["credentials"] == null ? [] : List<Credential>.from(json["credentials"]!.map((x) => Credential.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "credentials": credentials == null ? [] : List<dynamic>.from(credentials!.map((x) => x.toJson())),
  };
}

class Credential {
  Credential({
    this.id,
    this.category,
    this.allowedChannels,
    this.api,
  });

  String? id;
  String? category;
  List<String>? allowedChannels;
  Api? api;

  factory Credential.fromJson(Map<String, dynamic> json) => Credential(
    id: json["id"],
    category: json["category"],
    allowedChannels: json["allowedChannels"] == null ? [] : List<String>.from(json["allowedChannels"]!.map((x) => x)),
    api: json["api"] == null ? null : Api.fromJson(json["api"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category": category,
    "allowedChannels": allowedChannels == null ? [] : List<dynamic>.from(allowedChannels!.map((x) => x)),
    "api": api?.toJson(),
  };
}

class Api {
  Api({
    this.token,
    this.parts,
    this.workflowExecution,
  });

  String? token;
  Parts? parts;
  String? workflowExecution;

  factory Api.fromJson(Map<String, dynamic> json) => Api(
    token: json["token"],
    parts: json["parts"] == null ? null : Parts.fromJson(json["parts"]),
    workflowExecution: json["workflowExecution"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "parts": parts?.toJson(),
    "workflowExecution": workflowExecution,
  };
}

class Parts {
  Parts({
    this.front,
    this.back,
    this.face,
  });

  String? front;
  String? back;
  String? face;

  factory Parts.fromJson(Map<String, dynamic> json) => Parts(
    front: json["front"],
    back: json["back"],
    face: json["face"],
  );

  Map<String, dynamic> toJson() => {
    "front": front,
    "back": back,
    "face": face,
  };
}


// // To parse this JSON data, do
// //
// //     final jumioVerificationResponse = jumioVerificationResponseFromJson(jsonString);
//
// import 'dart:convert';
//
// JumioVerificationResponse jumioVerificationResponseFromJson(String str) => JumioVerificationResponse.fromJson(json.decode(str));
//
// String jumioVerificationResponseToJson(JumioVerificationResponse data) => json.encode(data.toJson());
//
// class JumioVerificationResponse {
//   JumioVerificationResponse({
//     this.resp,
//     this.success,
//   });
//
//   Resp? resp;
//   bool? success;
//
//   factory JumioVerificationResponse.fromJson(Map<String, dynamic> json) => JumioVerificationResponse(
//     resp: json["resp"] == null ? null : Resp.fromJson(json["resp"]),
//     success: json["success"] == null ? null : json["success"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "resp": resp == null ? null : resp?.toJson(),
//     "success": success == null ? null : success,
//   };
// }
//
// class Resp {
//   Resp({
//     this.redirectUrl,
//     this.transactionReference,
//     this.timestamp,
//   });
//
//   String? redirectUrl;
//   String? transactionReference;
//   DateTime? timestamp;
//
//   factory Resp.fromJson(Map<String, dynamic> json) => Resp(
//     redirectUrl: json["redirectUrl"] == null ? null : json["redirectUrl"],
//     transactionReference: json["transactionReference"] == null ? null : json["transactionReference"],
//     timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "redirectUrl": redirectUrl == null ? null : redirectUrl,
//     "transactionReference": transactionReference == null ? null : transactionReference,
//     "timestamp": timestamp == null ? null : timestamp?.toIso8601String(),
//   };
// }
