// To parse this JSON data, do
//
//     final getReceiverAccountDetails = getReceiverAccountDetailsFromJson(jsonString);

import 'dart:convert';

List<GetReceiverAccountDetails> getReceiverAccountDetailsFromJson(String str) => List<GetReceiverAccountDetails>.from(json.decode(str).map((x) => GetReceiverAccountDetails.fromJson(x)));

String getReceiverAccountDetailsToJson(List<GetReceiverAccountDetails> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetReceiverAccountDetails {
  GetReceiverAccountDetails({
    this.accInfo,
    this.receiverId,
    this.bankTypeId,
    this.receiverType,
  });

  String? accInfo;
  String? receiverId;
  int? bankTypeId;
  String? receiverType;

  factory GetReceiverAccountDetails.fromJson(Map<String, dynamic> json) => GetReceiverAccountDetails(
    accInfo: json["accInfo"] == null ? null : json["accInfo"],
    receiverId: json["receiverId"] == null ? null : json["receiverId"],
    bankTypeId: json["bankTypeId"] == null ? null : json["bankTypeId"],
    receiverType: json["receiverType"] == null ? null : json["receiverType"],
  );

  Map<String, dynamic> toJson() => {
    "accInfo": accInfo == null ? null : accInfo,
    "receiverId": receiverId == null ? null : receiverId,
    "bankTypeId": bankTypeId == null ? null : bankTypeId,
    "receiverType": receiverType == null ? null : receiverType,
  };

  @override
  String toString() {
    return '$accInfo'.toLowerCase();
  }
}
