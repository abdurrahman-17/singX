// To parse this JSON data, do
//
//     final documentListResponse = documentListResponseFromJson(jsonString);

import 'dart:convert';

List<DocumentListResponse> documentListResponseFromJson(String str) => List<DocumentListResponse>.from(json.decode(str).map((x) => DocumentListResponse.fromJson(x)));

String documentListResponseToJson(List<DocumentListResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DocumentListResponse {
  DocumentListResponse({
    this.documentType,
    this.referenceNo,
    this.documentId,
    this.expiryDate,
    this.issueDate,
  });

  String? documentType;
  dynamic referenceNo;
  String? documentId;
  dynamic expiryDate;
  dynamic issueDate;

  factory DocumentListResponse.fromJson(Map<String, dynamic> json) => DocumentListResponse(
    documentType: json["documentType"] == null ? null : json["documentType"],
    referenceNo: json["referenceNo"],
    documentId: json["documentId"] == null ? null : json["documentId"],
    expiryDate: json["expiryDate"],
    issueDate: json["issueDate"],
  );

  Map<String, dynamic> toJson() => {
    "documentType": documentType == null ? null : documentType,
    "referenceNo": referenceNo,
    "documentId": documentId == null ? null : documentId,
    "expiryDate": expiryDate,
    "issueDate": issueDate,
  };
}
