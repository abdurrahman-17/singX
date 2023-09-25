// To parse this JSON data, do
//
//     final documentListResponse = documentListResponseFromJson(jsonString);

import 'dart:convert';

SideNoteResponse sideNoteResponseFromJson(String str) => SideNoteResponse.fromJson(json.decode(str));

String sideNoteResponseToJson(SideNoteResponse data) => json.encode(data.toJson());


class SideNoteResponse {
  SideNoteResponse({
    this.aed,
    this.bdt,
    this.cad,
    this.cny,
    this.eur,
    this.gbp,
    this.hkd,
    this.idr,
    this.inr,
    this.jpy,
    this.krw,
    this.lkr,
    this.myr,
    this.npr,
    this.nzd,
    this.sgd,
    this.thb,
    this.usd,
    this.vnd,
    this.zar,
    this.php,
  });

  List<SideNoteData>? aed;
  List<SideNoteData>? bdt;
  List<SideNoteData>? cad;
  List<SideNoteData>? cny;
  List<SideNoteData>? eur;
  List<SideNoteData>? gbp;
  List<SideNoteData>? hkd;
  List<SideNoteData>? idr;
  List<SideNoteData>? inr;
  List<SideNoteData>? jpy;
  List<SideNoteData>? krw;
  List<SideNoteData>? lkr;
  List<SideNoteData>? myr;
  List<SideNoteData>? npr;
  List<SideNoteData>? nzd;
  List<SideNoteData>? sgd;
  List<SideNoteData>? thb;
  List<SideNoteData>? usd;
  List<SideNoteData>? vnd;
  List<SideNoteData>? zar;
  List<SideNoteData>? php;

  factory SideNoteResponse.fromJson(Map<String, dynamic> json) => SideNoteResponse(
    aed: json["AED"] == null ? null : List<SideNoteData>.from(json["AED"].map((x) => SideNoteData.fromJson(x))),
    bdt: json["BDT"] == null ? null : List<SideNoteData>.from(json["BDT"].map((x) => SideNoteData.fromJson(x))),
    cad: json["CAD"] == null ? null : List<SideNoteData>.from(json["CAD"].map((x) => SideNoteData.fromJson(x))),
    cny: json["CNY"] == null ? null : List<SideNoteData>.from(json["CNY"].map((x) => SideNoteData.fromJson(x))),
    eur: json["EUR"] == null ? null : List<SideNoteData>.from(json["EUR"].map((x) => SideNoteData.fromJson(x))),
    gbp: json["GBP"] == null ? null : List<SideNoteData>.from(json["GBP"].map((x) => SideNoteData.fromJson(x))),
    hkd: json["HKD"] == null ? null : List<SideNoteData>.from(json["HKD"].map((x) => SideNoteData.fromJson(x))),
    idr: json["IDR"] == null ? null : List<SideNoteData>.from(json["IDR"].map((x) => SideNoteData.fromJson(x))),
    inr: json["INR"] == null ? null : List<SideNoteData>.from(json["INR"].map((x) => SideNoteData.fromJson(x))),
    jpy: json["JPY"] == null ? null : List<SideNoteData>.from(json["JPY"].map((x) => SideNoteData.fromJson(x))),
    krw: json["KRW"] == null ? null : List<SideNoteData>.from(json["KRW"].map((x) => SideNoteData.fromJson(x))),
    lkr: json["LKR"] == null ? null : List<SideNoteData>.from(json["LKR"].map((x) => SideNoteData.fromJson(x))),
    myr: json["MYR"] == null ? null : List<SideNoteData>.from(json["MYR"].map((x) => SideNoteData.fromJson(x))),
    npr: json["NPR"] == null ? null : List<SideNoteData>.from(json["NPR"].map((x) => SideNoteData.fromJson(x))),
    nzd: json["NZD"] == null ? null : List<SideNoteData>.from(json["NZD"].map((x) => SideNoteData.fromJson(x))),
    sgd: json["SGD"] == null ? null : List<SideNoteData>.from(json["SGD"].map((x) => SideNoteData.fromJson(x))),
    thb: json["THB"] == null ? null : List<SideNoteData>.from(json["THB"].map((x) => SideNoteData.fromJson(x))),
    usd: json["USD"] == null ? null : List<SideNoteData>.from(json["USD"].map((x) => SideNoteData.fromJson(x))),
    vnd: json["VND"] == null ? null : List<SideNoteData>.from(json["VND"].map((x) => SideNoteData.fromJson(x))),
    zar: json["ZAR"] == null ? null : List<SideNoteData>.from(json["ZAR"].map((x) => SideNoteData.fromJson(x))),
    php: json["PHP"] == null ? null : List<SideNoteData>.from(json["PHP"].map((x) => SideNoteData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "AED": aed == null ? null : List<dynamic>.from(aed!.map((x) => x.toJson())),
    "BDT": bdt == null ? null : List<dynamic>.from(bdt!.map((x) => x.toJson())),
    "CAD": cad == null ? null : List<dynamic>.from(cad!.map((x) => x.toJson())),
    "CNY": cny == null ? null : List<dynamic>.from(cny!.map((x) => x.toJson())),
    "EUR": eur == null ? null : List<dynamic>.from(eur!.map((x) => x.toJson())),
    "GBP": gbp == null ? null : List<dynamic>.from(gbp!.map((x) => x.toJson())),
    "HKD": hkd == null ? null : List<dynamic>.from(hkd!.map((x) => x.toJson())),
    "IDR": idr == null ? null : List<dynamic>.from(idr!.map((x) => x.toJson())),
    "INR": inr == null ? null : List<dynamic>.from(inr!.map((x) => x.toJson())),
    "JPY": jpy == null ? null : List<dynamic>.from(jpy!.map((x) => x.toJson())),
    "KRW": krw == null ? null : List<dynamic>.from(krw!.map((x) => x.toJson())),
    "LKR": lkr == null ? null : List<dynamic>.from(lkr!.map((x) => x.toJson())),
    "MYR": myr == null ? null : List<dynamic>.from(myr!.map((x) => x.toJson())),
    "NPR": npr == null ? null : List<dynamic>.from(npr!.map((x) => x.toJson())),
    "NZD": nzd == null ? null : List<dynamic>.from(nzd!.map((x) => x.toJson())),
    "SGD": sgd == null ? null : List<dynamic>.from(sgd!.map((x) => x.toJson())),
    "THB": thb == null ? null : List<dynamic>.from(thb!.map((x) => x.toJson())),
    "USD": usd == null ? null : List<dynamic>.from(usd!.map((x) => x.toJson())),
    "VND": vnd == null ? null : List<dynamic>.from(vnd!.map((x) => x.toJson())),
    "ZAR": zar == null ? null : List<dynamic>.from(zar!.map((x) => x.toJson())),
    "PHP": php == null ? null : List<dynamic>.from(php!.map((x) => x.toJson())),
  };
}

class SideNoteData {
  SideNoteData({
    this.type,
    this.options,
  });

  String? type;
  List<String>? options;

  factory SideNoteData.fromJson(Map<String, dynamic> json) => SideNoteData(
    type: json["type"],
    options: json["options"] == null ? [] : List<String>.from(json["options"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x)),
  };
}
