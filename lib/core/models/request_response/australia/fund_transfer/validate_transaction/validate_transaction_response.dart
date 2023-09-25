// To parse this JSON data, do
//
//     final validateTransactionResponse = validateTransactionResponseFromJson(jsonString);

import 'dart:convert';

ValidateTransactionResponse validateTransactionResponseFromJson(String str) => ValidateTransactionResponse.fromJson(json.decode(str));

String validateTransactionResponseToJson(ValidateTransactionResponse data) => json.encode(data.toJson());

class ValidateTransactionResponse {
  ValidateTransactionResponse({
    this.additionalInfoRequired,
    this.documentRequired,
    this.reason,
  });

  String? additionalInfoRequired;
  String? documentRequired;
  String? reason;

  factory ValidateTransactionResponse.fromJson(Map<String, dynamic> json) => ValidateTransactionResponse(
    additionalInfoRequired: json["AdditionalInfo_Required?"] == null ? null : json["AdditionalInfo_Required?"],
    documentRequired: json["Document_Required?"] == null ? null : json["Document_Required?"],
    reason: json["Reason"] == null ? null : json["Reason"],
  );

  Map<String, dynamic> toJson() => {
    "AdditionalInfo_Required?": additionalInfoRequired == null ? null : additionalInfoRequired,
    "Document_Required?": documentRequired == null ? null : documentRequired,
    "Reason": reason == null ? null : reason,
  };
}
