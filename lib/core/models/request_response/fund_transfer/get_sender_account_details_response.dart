// To parse this JSON data, do
//
//     final getSenderAccountDetails = getSenderAccountDetailsFromJson(jsonString);

import 'dart:convert';

List<GetSenderAccountDetails> getSenderAccountDetailsFromJson(String str) => List<GetSenderAccountDetails>.from(json.decode(str).map((x) => GetSenderAccountDetails.fromJson(x)));

String getSenderAccountDetailsToJson(List<GetSenderAccountDetails> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetSenderAccountDetails {
  GetSenderAccountDetails({
    this.id,
    this.name,
    this.bankName,
    this.accountNumber,
    this.country,
  });

  String? id;
  String? name;
  String? bankName;
  String? accountNumber;
  String? country;

  factory GetSenderAccountDetails.fromJson(Map<String, dynamic> json) => GetSenderAccountDetails(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    bankName: json["bankName"] == null ? null : json["bankName"],
    accountNumber: json["accountNumber"] == null ? null : json["accountNumber"],
    country: json["country"] == null ? null : json["country"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "bankName": bankName == null ? null : bankName,
    "accountNumber": accountNumber == null ? null : accountNumber,
    "country": country == null ? null : country,
  };

  @override
  String toString() {
    return '$name $bankName $accountNumber'.toLowerCase();
  }

}

