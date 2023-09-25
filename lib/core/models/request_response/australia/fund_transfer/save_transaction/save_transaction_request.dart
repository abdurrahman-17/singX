// To parse this JSON data, do
//
//     final saveTransactionRequest = saveTransactionRequestFromJson(jsonString);

import 'dart:convert';

SaveTransactionRequest saveTransactionRequestFromJson(String str) => SaveTransactionRequest.fromJson(json.decode(str));

String saveTransactionRequestToJson(SaveTransactionRequest data) => json.encode(data.toJson());

class SaveTransactionRequest {
  SaveTransactionRequest({
    this.contactId,
    this.corridorId,
    this.exchangeRate,
    this.otherpurpose,
    this.promoCode,
    this.purposeId,
    this.purposeRemarks,
    this.receiveAmount,
    this.receiverId,
    this.relationshipwithId,
    this.sendAmount,
    this.senderId,
    this.singxFee,
    this.grosssingxFee,
    this.totalFee,
    this.totalPayable,
    this.transfermodeFee,
    this.transfermodeId,
    this.wiretransfermodeId,
    this.isswift,
  });

  int? contactId;
  int? corridorId;
  double? exchangeRate;
  String? otherpurpose;
  String? promoCode;
  int? purposeId;
  String? purposeRemarks;
  double? receiveAmount;
  int? receiverId;
  int? relationshipwithId;
  double? sendAmount;
  int? senderId;
  double? singxFee;
  double? grosssingxFee;
  double? totalFee;
  double? totalPayable;
  int? transfermodeFee;
  int? transfermodeId;
  int? wiretransfermodeId;
  bool? isswift;

  factory SaveTransactionRequest.fromJson(Map<String, dynamic> json) => SaveTransactionRequest(
    contactId: json["contactId"] == null ? null : json["contactId"],
    corridorId: json["corridorId"] == null ? null : json["corridorId"],
    exchangeRate: json["exchangeRate"] == null ? null : json["exchangeRate"].toDouble(),
    otherpurpose: json["otherpurpose"] == null ? null : json["otherpurpose"],
    promoCode: json["promoCode"] == null ? null : json["promoCode"],
    purposeId: json["purposeId"] == null ? null : json["purposeId"],
    purposeRemarks: json["purposeRemarks"] == null ? null : json["purposeRemarks"],
    receiveAmount: json["receiveAmount"] == null ? null : json["receiveAmount"],
    receiverId: json["receiverId"] == null ? null : json["receiverId"],
    relationshipwithId: json["relationshipwithId"] == null ? null : json["relationshipwithId"],
    sendAmount: json["sendAmount"] == null ? null : json["sendAmount"],
    senderId: json["senderId"] == null ? null : json["senderId"],
    singxFee: json["singxFee"] == null ? null : json["singxFee"].toDouble(),
    grosssingxFee: json["grosssingxFee"] == null ? null : json["grosssingxFee"].toDouble(),
    totalFee: json["totalFee"] == null ? null : json["totalFee"].toDouble(),
    totalPayable: json["totalPayable"] == null ? null : json["totalPayable"].toDouble(),
    transfermodeFee: json["transfermodeFee"] == null ? null : json["transfermodeFee"],
    transfermodeId: json["transfermodeId"] == null ? null : json["transfermodeId"],
    wiretransfermodeId: json["wiretransfermodeId"] == null ? null : json["wiretransfermodeId"],
    isswift: json["isswift"] == null ? null : json["isswift"],
  );

  Map<String, dynamic> toJson() => {
    "contactId": contactId == null ? null : contactId,
    "corridorId": corridorId == null ? null : corridorId,
    "exchangeRate": exchangeRate == null ? null : exchangeRate,
    "otherpurpose": otherpurpose == null ? null : otherpurpose,
    "promoCode": promoCode == null ? null : promoCode,
    "purposeId": purposeId == null ? null : purposeId,
    "purposeRemarks": purposeRemarks == null ? null : purposeRemarks,
    "receiveAmount": receiveAmount == null ? null : receiveAmount,
    "receiverId": receiverId == null ? null : receiverId,
    "relationshipwithId": relationshipwithId == null ? null : relationshipwithId,
    "sendAmount": sendAmount == null ? null : sendAmount,
    "senderId": senderId == null ? null : senderId,
    "singxFee": singxFee == null ? null : singxFee,
    "grosssingxFee": grosssingxFee == null ? null : grosssingxFee,
    "totalFee": totalFee == null ? null : totalFee,
    "totalPayable": totalPayable == null ? null : totalPayable,
    "transfermodeFee": transfermodeFee == null ? null : transfermodeFee,
    "transfermodeId": transfermodeId == null ? null : transfermodeId,
    "wiretransfermodeId": wiretransfermodeId == null ? null : wiretransfermodeId,
    "isswift": isswift == null ? null : isswift,
  };
}
