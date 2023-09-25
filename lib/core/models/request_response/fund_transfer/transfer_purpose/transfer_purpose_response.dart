// To parse this JSON data, do
//
//     final transferPurposeSingResponse = transferPurposeSingResponseFromJson(jsonString);

import 'dart:convert';

List<TransferPurposeSingResponse> transferPurposeSingResponseFromJson(String str) => List<TransferPurposeSingResponse>.from(json.decode(str).map((x) => TransferPurposeSingResponse.fromJson(x)));

String transferPurposeSingResponseToJson(List<TransferPurposeSingResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransferPurposeSingResponse {
  TransferPurposeSingResponse({
    this.transferPurposeId,
    this.transferPurposeName,
  });

  int? transferPurposeId;
  String? transferPurposeName;

  factory TransferPurposeSingResponse.fromJson(Map<String, dynamic> json) => TransferPurposeSingResponse(
    transferPurposeId: json["transferPurposeId"] == null ? null : json["transferPurposeId"],
    transferPurposeName: json["transferPurposeName"] == null ? null : json["transferPurposeName"],
  );

  Map<String, dynamic> toJson() => {
    "transferPurposeId": transferPurposeId == null ? null : transferPurposeId,
    "transferPurposeName": transferPurposeName == null ? null : transferPurposeName,
  };

  @override
  String toString() {
    return '$transferPurposeName'.toLowerCase();
  }
}
