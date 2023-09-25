// To parse this JSON data, do
//
//     final billSaveRequest = billSaveRequestFromJson(jsonString);

import 'dart:convert';

BillSaveRequest billSaveRequestFromJson(String str) => BillSaveRequest.fromJson(json.decode(str));

String billSaveRequestToJson(BillSaveRequest data) => json.encode(data.toJson());

class BillSaveRequest {
  BillSaveRequest({
    this.userId,
    this.adParam1,
    this.adParam2,
    this.adParam3,
    this.billpayresponse,
    this.consumerno,
    this.corridorId,
    this.countryId,
    this.customerbankId,
    this.fee,
    this.operatorid,
    this.paymentType,
    this.receiveamount,
    this.sendamount,
    this.totalPayable,
  });

  String? userId;
  String? adParam1;
  String? adParam2;
  String? adParam3;
  String? billpayresponse;
  String? consumerno;
  String? corridorId;
  String? countryId;
  String? customerbankId;
  String? fee;
  int? operatorid;
  String? paymentType;
  String? receiveamount;
  String? sendamount;
  String? totalPayable;

  factory BillSaveRequest.fromJson(Map<String, dynamic> json) => BillSaveRequest(
    userId: json["userId"] == null ? null : json["userId"],
    adParam1: json["adParam1"] == null ? null : json["adParam1"],
    adParam2: json["adParam2"] == null ? null : json["adParam2"],
    adParam3: json["adParam3"] == null ? null : json["adParam3"],
    billpayresponse: json["billpayresponse"] == null ? null : json["billpayresponse"],
    consumerno: json["consumerno"] == null ? null : json["consumerno"],
    corridorId: json["corridorId"] == null ? null : json["corridorId"],
    countryId: json["countryId"] == null ? null : json["countryId"],
    customerbankId: json["customerbankId"] == null ? null : json["customerbankId"],
    fee: json["fee"] == null ? null : json["fee"],
    operatorid: json["operatorid"] == null ? null : json["operatorid"],
    paymentType: json["paymentType"] == null ? null : json["paymentType"],
    receiveamount: json["receiveamount"] == null ? null : json["receiveamount"],
    sendamount: json["sendamount"] == null ? null : json["sendamount"],
    totalPayable: json["totalPayable"] == null ? null : json["totalPayable"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId == null ? null : userId,
    "adParam1": adParam1 == null ? null : adParam1,
    "adParam2": adParam2 == null ? null : adParam2,
    "adParam3": adParam3 == null ? null : adParam3,
    "billpayresponse": billpayresponse == null ? null : billpayresponse,
    "consumerno": consumerno == null ? null : consumerno,
    "corridorId": corridorId == null ? null : corridorId,
    "countryId": countryId == null ? null : countryId,
    "customerbankId": customerbankId == null ? null : customerbankId,
    "fee": fee == null ? null : fee,
    "operatorid": operatorid == null ? null : operatorid,
    "paymentType": paymentType == null ? null : paymentType,
    "receiveamount": receiveamount == null ? null : receiveamount,
    "sendamount": sendamount == null ? null : sendamount,
    "totalPayable": totalPayable == null ? null : totalPayable,
  };
}
