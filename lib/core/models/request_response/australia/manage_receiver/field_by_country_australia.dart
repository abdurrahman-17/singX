// To parse this JSON data, do
//
//     final fieldByCountryListResponse = fieldByCountryListResponseFromJson(jsonString);

import 'dart:convert';

FieldByCountryListResponse fieldByCountryListResponseFromJson(String str) => FieldByCountryListResponse.fromJson(json.decode(str));

String fieldByCountryListResponseToJson(FieldByCountryListResponse data) => json.encode(data.toJson());

class FieldByCountryListResponse {
  FieldByCountryListResponse({
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

  List<Aed>? aed;
  List<Aed>? bdt;
  List<Aed>? cad;
  List<Aed>? cny;
  List<Aed>? eur;
  List<Aed>? gbp;
  List<Aed>? hkd;
  List<Aed>? idr;
  List<Aed>? inr;
  List<Aed>? jpy;
  List<Aed>? krw;
  List<Aed>? lkr;
  List<Aed>? myr;
  List<Aed>? npr;
  List<Aed>? nzd;
  List<Aed>? sgd;
  List<Aed>? thb;
  List<Aed>? usd;
  List<Aed>? vnd;
  List<Aed>? zar;
  List<Php>? php;

  factory FieldByCountryListResponse.fromJson(Map<String, dynamic> json) => FieldByCountryListResponse(
    aed: json["AED"] == null ? null : List<Aed>.from(json["AED"].map((x) => Aed.fromJson(x))),
    bdt: json["BDT"] == null ? null : List<Aed>.from(json["BDT"].map((x) => Aed.fromJson(x))),
    cad: json["CAD"] == null ? null : List<Aed>.from(json["CAD"].map((x) => Aed.fromJson(x))),
    cny: json["CNY"] == null ? null : List<Aed>.from(json["CNY"].map((x) => Aed.fromJson(x))),
    eur: json["EUR"] == null ? null : List<Aed>.from(json["EUR"].map((x) => Aed.fromJson(x))),
    gbp: json["GBP"] == null ? null : List<Aed>.from(json["GBP"].map((x) => Aed.fromJson(x))),
    hkd: json["HKD"] == null ? null : List<Aed>.from(json["HKD"].map((x) => Aed.fromJson(x))),
    idr: json["IDR"] == null ? null : List<Aed>.from(json["IDR"].map((x) => Aed.fromJson(x))),
    inr: json["INR"] == null ? null : List<Aed>.from(json["INR"].map((x) => Aed.fromJson(x))),
    jpy: json["JPY"] == null ? null : List<Aed>.from(json["JPY"].map((x) => Aed.fromJson(x))),
    krw: json["KRW"] == null ? null : List<Aed>.from(json["KRW"].map((x) => Aed.fromJson(x))),
    lkr: json["LKR"] == null ? null : List<Aed>.from(json["LKR"].map((x) => Aed.fromJson(x))),
    myr: json["MYR"] == null ? null : List<Aed>.from(json["MYR"].map((x) => Aed.fromJson(x))),
    npr: json["NPR"] == null ? null : List<Aed>.from(json["NPR"].map((x) => Aed.fromJson(x))),
    nzd: json["NZD"] == null ? null : List<Aed>.from(json["NZD"].map((x) => Aed.fromJson(x))),
    sgd: json["SGD"] == null ? null : List<Aed>.from(json["SGD"].map((x) => Aed.fromJson(x))),
    thb: json["THB"] == null ? null : List<Aed>.from(json["THB"].map((x) => Aed.fromJson(x))),
    usd: json["USD"] == null ? null : List<Aed>.from(json["USD"].map((x) => Aed.fromJson(x))),
    vnd: json["VND"] == null ? null : List<Aed>.from(json["VND"].map((x) => Aed.fromJson(x))),
    zar: json["ZAR"] == null ? null : List<Aed>.from(json["ZAR"].map((x) => Aed.fromJson(x))),
    php: json["PHP"] == null ? null : List<Php>.from(json["PHP"].map((x) => Php.fromJson(x))),
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

class Aed {
  Aed({
    this.fieldLabel,
    this.fieldType,
    this.type,
    this.options,
    this.helpText,
    this.errorLabel
  });

  String? fieldLabel;
  String? fieldType;
  String? type;
  List<String>? options;
  String? helpText;
  String? errorLabel;

  factory Aed.fromJson(Map<String, dynamic> json) => Aed(
    fieldLabel: json["fieldLabel"] == null ? null : json["fieldLabel"],
    fieldType: json["fieldType"] == null ? null : json["fieldType"],
    type: json["type"] == null ? null : json["type"],
    options: json["options"] == null ? null : List<String>.from(json["options"].map((x) => x)),
    helpText: json["helpText"] == null ? null : json["helpText"],
    errorLabel: json["errorLabel"] == null ? null : json["errorLabel"],
  );

  Map<String, dynamic> toJson() => {
    "fieldLabel": fieldLabel == null ? null : fieldLabel,
    "fieldType": fieldType == null ? null : fieldType,
    "type": type == null ? null : type,
    "options": options == null ? null : List<dynamic>.from(options!.map((x) => x)),
    "helpText": helpText == null ? null : helpText,
    "errorLabel": errorLabel == null ? null : errorLabel,
  };
}

class Php {
  Php({
    this.bank,
    this.cash,
  });

  List<Aed>? bank;
  List<Aed>? cash;

  factory Php.fromJson(Map<String, dynamic> json) => Php(
    bank: json["bank"] == null ? null : List<Aed>.from(json["bank"].map((x) => Aed.fromJson(x))),
    cash: json["cash"] == null ? null : List<Aed>.from(json["cash"].map((x) => Aed.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "bank": bank == null ? null : List<dynamic>.from(bank!.map((x) => x.toJson())),
    "cash": cash == null ? null : List<dynamic>.from(cash!.map((x) => x.toJson())),
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
