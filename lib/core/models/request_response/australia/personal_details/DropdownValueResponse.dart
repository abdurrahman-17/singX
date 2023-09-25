// To parse this JSON data, do
//
//     final dropdownValueResponse = dropdownValueResponseFromJson(jsonString);

import 'dart:convert';


DropdownValueResponse dropdownValueResponseFromJson(String str) => DropdownValueResponse.fromJson(json.decode(str));

String dropdownValueResponseToJson(DropdownValueResponse data) => json.encode(data.toJson());

class DropdownValueResponse {
  DropdownValueResponse({
    this.residenceType,
    this.nationality,
    this.occupation,
    this.designation,
    this.estimatedTxnAmount,
    this.openingPurpose,
    this.salutation,
    this.state,
    this.statelist,
    this.annaulIncome,
  });

  List<String>? residenceType;
  List<String>? nationality;
  List<String>? occupation;
  List<String>? designation;
  List<String>? estimatedTxnAmount;
  dynamic openingPurpose;
  List<String>? salutation;
  List<String>? state;
  Statelist? statelist;
  List<String>? annaulIncome;

  factory DropdownValueResponse.fromJson(Map<String, dynamic> json) => DropdownValueResponse(
    residenceType: json["residenceType"] == null ? null : List<String>.from(json["residenceType"].map((x) => x)),
    nationality: json["nationality"] == null ? null : List<String>.from(json["nationality"].map((x) => x)),
    occupation: json["occupation"] == null ? null : List<String>.from(json["occupation"].map((x) => x)),
    designation: json["designation"] == null ? null : List<String>.from(json["designation"].map((x) => x)),
    estimatedTxnAmount: json["estimatedTxnAmount"] == null ? null : List<String>.from(json["estimatedTxnAmount"].map((x) => x)),
    openingPurpose: json["openingPurpose"],
    salutation: json["salutation"] == null ? null : List<String>.from(json["salutation"].map((x) => x)),
    state: json["state"] == null ? null : List<String>.from(json["state"].map((x) => x)),
    statelist: json["statelist"] == null ? null : Statelist.fromJson(json["statelist"]),
    annaulIncome: json["annaulIncome"] == null ? null : List<String>.from(json["annaulIncome"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "residenceType": residenceType == null ? null : List<dynamic>.from(residenceType!.map((x) => x)),
    "nationality": nationality == null ? null : List<dynamic>.from(nationality!.map((x) => x)),
    "occupation": occupation == null ? null : List<dynamic>.from(occupation!.map((x) => x)),
    "designation": designation == null ? null : List<dynamic>.from(designation!.map((x) => x)),
    "estimatedTxnAmount": estimatedTxnAmount == null ? null : List<dynamic>.from(estimatedTxnAmount!.map((x) => x)),
    "openingPurpose": openingPurpose,
    "salutation": salutation == null ? null : List<dynamic>.from(salutation!.map((x) => x)),
    "state": state == null ? null : List<dynamic>.from(state!.map((x) => x)),
    "statelist": statelist == null ? null : statelist!.toJson(),
    "annaulIncome": annaulIncome == null ? null : List<dynamic>.from(annaulIncome!.map((x) => x)),
  };

  @override
  String toString() {
    return '${state.toString().toLowerCase()}';
  }
}

class Statelist {
  Statelist({
    this.nsw,
    this.qld,
    this.sa,
    this.tas,
    this.vic,
    this.wa,
    this.act,
    this.nt,
    this.jbt,
  });

  String? nsw;
  String? qld;
  String? sa;
  String? tas;
  String? vic;
  String? wa;
  String? act;
  String? nt;
  String? jbt;

  factory Statelist.fromJson(Map<String, dynamic> json) => Statelist(
    nsw: json["NSW"] == null ? null : json["NSW"],
    qld: json["QLD"] == null ? null : json["QLD"],
    sa: json["SA"] == null ? null : json["SA"],
    tas: json["TAS"] == null ? null : json["TAS"],
    vic: json["VIC"] == null ? null : json["VIC"],
    wa: json["WA"] == null ? null : json["WA"],
    act: json["ACT"] == null ? null : json["ACT"],
    nt: json["NT"] == null ? null : json["NT"],
    jbt: json["JBT"] == null ? null : json["JBT"],
  );

  Map<String, dynamic> toJson() => {
    "NSW": nsw == null ? null : nsw,
    "QLD": qld == null ? null : qld,
    "SA": sa == null ? null : sa,
    "TAS": tas == null ? null : tas,
    "VIC": vic == null ? null : vic,
    "WA": wa == null ? null : wa,
    "ACT": act == null ? null : act,
    "NT": nt == null ? null : nt,
    "JBT": jbt == null ? null : jbt,
  };
}
