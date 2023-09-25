// To parse this JSON data, do
//
//     final getInvoiceRequest = getInvoiceRequestFromJson(jsonString);

import 'dart:convert';

GetInvoiceRequest getInvoiceRequestFromJson(String str) => GetInvoiceRequest.fromJson(json.decode(str));

String getInvoiceRequestToJson(GetInvoiceRequest data) => json.encode(data.toJson());

class GetInvoiceRequest {
  GetInvoiceRequest({
    this.contactId,
    this.userTxnId,
  });

  int? contactId;
  String? userTxnId;

  factory GetInvoiceRequest.fromJson(Map<String, dynamic> json) => GetInvoiceRequest(
    contactId: json["contactId"] == null ? null : json["contactId"],
    userTxnId: json["userTxnId"] == null ? null : json["userTxnId"],
  );

  Map<String, dynamic> toJson() => {
    "contactId": contactId == null ? null : contactId,
    "userTxnId": userTxnId == null ? null : userTxnId,
  };
}
