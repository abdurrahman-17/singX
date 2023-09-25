// To parse this JSON data, do
//
//     final sgTransactionStatusFilterApi = sgTransactionStatusFilterApiFromJson(jsonString);

import 'dart:convert';

SgTransactionStatusFilterApi sgTransactionStatusFilterApiFromJson(String str) => SgTransactionStatusFilterApi.fromJson(json.decode(str));

String sgTransactionStatusFilterApiToJson(SgTransactionStatusFilterApi data) => json.encode(data.toJson());

class SgTransactionStatusFilterApi {
  SgTransactionStatusFilterApi({
    this.statuses,
    this.countries,
  });

  List<Datas>? statuses;
  List<Datas>? countries;

  factory SgTransactionStatusFilterApi.fromJson(Map<String, dynamic> json) => SgTransactionStatusFilterApi(
    statuses: json["statuses"] == null ? [] : List<Datas>.from(json["statuses"]!.map((x) => Datas.fromJson(x))),
    countries: json["countries"] == null ? [] : List<Datas>.from(json["countries"]!.map((x) => Datas.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statuses": statuses == null ? [] : List<dynamic>.from(statuses!.map((x) => x.toJson())),
    "countries": countries == null ? [] : List<dynamic>.from(countries!.map((x) => x.toJson())),
  };
}

class Datas {
  Datas({
    this.value,
    this.key,
  });

  String? value;
  String? key;

  factory Datas.fromJson(Map<String, dynamic> json) => Datas(
    value: json["value"],
    key: json["key"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "key": key,
  };
}
