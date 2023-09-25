// To parse this JSON data, do
//
//     final validateTransactionRequest = validateTransactionRequestFromJson(jsonString);

import 'dart:convert';

ValidateTransactionRequest validateTransactionRequestFromJson(String str) => ValidateTransactionRequest.fromJson(json.decode(str));

String validateTransactionRequestToJson(ValidateTransactionRequest data) => json.encode(data.toJson());

class ValidateTransactionRequest {
  ValidateTransactionRequest({
    this.contactId,
    this.receiverId,
    this.sendAmount,
    this.senderId,
    this.usrtxnId,
    this.insert,
  });

  int? contactId;
  int? receiverId;
  double? sendAmount;
  int? senderId;
  String? usrtxnId;
  bool? insert;

  factory ValidateTransactionRequest.fromJson(Map<String, dynamic> json) => ValidateTransactionRequest(
    contactId: json["contactId"] == null ? null : json["contactId"],
    receiverId: json["receiverId"] == null ? null : json["receiverId"],
    sendAmount: json["sendAmount"] == null ? null : json["sendAmount"].toDouble(),
    senderId: json["senderId"] == null ? null : json["senderId"],
    usrtxnId: json["usrtxnId"] == null ? null : json["usrtxnId"],
    insert: json["insert"] == null ? null : json["insert"],
  );

  Map<String, dynamic> toJson() => {
    "contactId": contactId == null ? null : contactId,
    "receiverId": receiverId == null ? null : receiverId,
    "sendAmount": sendAmount == null ? null : sendAmount,
    "senderId": senderId == null ? null : senderId,
    "usrtxnId": usrtxnId == null ? null : usrtxnId,
    "insert": insert == null ? null : insert,
  };
}
