// To parse this JSON data, do
//
//     final viewBillResponse = viewBillResponseFromJson(jsonString);

import 'dart:convert';

ViewBillResponse viewBillResponseFromJson(String str) => ViewBillResponse.fromJson(json.decode(str));

String viewBillResponseToJson(ViewBillResponse data) => json.encode(data.toJson());

class ViewBillResponse {
  ViewBillResponse({
    this.success,
    this.data,
  });

  bool? success;
  List<Datum>? data;

  factory ViewBillResponse.fromJson(Map<String, dynamic> json) => ViewBillResponse(
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.billNumber,
    this.billAmount,
    this.billnetamount,
    this.billdate,
    this.dueDate,
    this.statusMessage,
    this.acceptPayment,
    this.acceptPartPay,
    this.cellNumber,
  });

  String? billNumber;
  String? billAmount;
  String? billnetamount;
  String? billdate;
  String? dueDate;
  String? statusMessage;
  bool? acceptPayment;
  bool? acceptPartPay;
  String? cellNumber;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    billNumber: json["billNumber"],
    billAmount: json["billAmount"],
    billnetamount: json["billnetamount"],
    billdate: json["billdate"],
    dueDate: json["dueDate"],
    statusMessage: json["statusMessage"],
    acceptPayment: json["acceptPayment"],
    acceptPartPay: json["acceptPartPay"],
    cellNumber: json["cellNumber"],
  );

  Map<String, dynamic> toJson() => {
    "billNumber": billNumber,
    "billAmount": billAmount,
    "billnetamount": billnetamount,
    "billdate": billdate,
    "dueDate": dueDate,
    "statusMessage": statusMessage,
    "acceptPayment": acceptPayment,
    "acceptPartPay": acceptPartPay,
    "cellNumber": cellNumber,
  };
}


ViewBillErrorResponse viewBillErrorResponseFromJson(String str) => ViewBillErrorResponse.fromJson(json.decode(str));

String viewBillErrorResponseToJson(ViewBillErrorResponse data) => json.encode(data.toJson());

class ViewBillErrorResponse {
  ViewBillErrorResponse({
    this.success,
    this.message,
  });

  bool? success;
  Message? message;

  factory ViewBillErrorResponse.fromJson(Map<String, dynamic> json) => ViewBillErrorResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : Message.fromJson(json["message"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message!.toJson(),
  };
}

class Message {
  Message({
    this.code,
    this.text,
  });

  String? code;
  String? text;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    code: json["code"] == null ? null : json["code"],
    text: json["text"] == null ? null : json["text"],
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "text": text == null ? null : text,
  };
}
