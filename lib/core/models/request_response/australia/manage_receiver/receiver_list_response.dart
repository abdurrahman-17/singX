// To parse this JSON data, do
//
//     final receiverListAusResponse = receiverListAusResponseFromJson(jsonString);

import 'dart:convert';

List<ReceiverListAusResponse> receiverListAusResponseFromJson(String str) => List<ReceiverListAusResponse>.from(json.decode(str).map((x) => ReceiverListAusResponse.fromJson(x)));

String receiverListAusResponseToJson(List<ReceiverListAusResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReceiverListAusResponse {
  ReceiverListAusResponse({
    this.receiverAccountId,
    this.accountNumber,
    this.accountType,
    this.bankId,
    this.branchId,
    this.countryId,
    this.firstName,
    this.lastName,
    this.middleName,
    this.receiverType,
    this.contactId,
    this.swiftCode,
    this.iban,
    this.branchCode,
    this.bankName,
    this.country,
    this.currency,
  });

  int? receiverAccountId;
  String? accountNumber;
  AccountType? accountType;
  int? bankId;
  int? branchId;
  int? countryId;
  String? firstName;
  String? lastName;
  String? middleName;
  ReceiverType? receiverType;
  int? contactId;
  String? swiftCode;
  Iban? iban;
  String? branchCode;
  String? bankName;
  String? country;
  String? currency;

  factory ReceiverListAusResponse.fromJson(Map<String, dynamic> json) => ReceiverListAusResponse(
    receiverAccountId: json["receiverAccountId"] == null ? null : json["receiverAccountId"],
    accountNumber: json["accountNumber"] == null ? null : json["accountNumber"],
    accountType: json["accountType"] == null ? null : accountTypeValues.map[json["accountType"]],
    bankId: json["bankId"] == null ? null : json["bankId"],
    branchId: json["branchId"] == null ? null : json["branchId"],
    countryId: json["countryId"] == null ? null : json["countryId"],
    firstName: json["firstName"] == null ? null : json["firstName"],
    lastName: json["lastName"] == null ? null : json["lastName"],
    middleName: json["middleName"] == null ? null : json["middleName"],
    receiverType: json["receiverType"] == null ? null : receiverTypeValues.map[json["receiverType"]],
    contactId: json["contactId"] == null ? null : json["contactId"],
    swiftCode: json["swiftCode"] == null ? null : json["swiftCode"],
    iban: json["iban"] == null ? null : ibanValues.map[json["iban"]],
    branchCode: json["branchCode"] == null ? null : json["branchCode"],
    bankName: json["bankName"] == null ? null : json["bankName"],
    country: json["country"] == null ? null : json["country"],
    currency: json["currency"] == null ? null : json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "receiverAccountId": receiverAccountId == null ? null : receiverAccountId,
    "accountNumber": accountNumber == null ? null : accountNumber,
    "accountType": accountType == null ? null : accountTypeValues.reverse![accountType],
    "bankId": bankId == null ? null : bankId,
    "branchId": branchId == null ? null : branchId,
    "countryId": countryId == null ? null : countryId,
    "firstName": firstName == null ? null : firstName,
    "lastName": lastName == null ? null : lastName,
    "middleName": middleName == null ? null : middleNameValues.reverse![middleName],
    "receiverType": receiverType == null ? null : receiverTypeValues.reverse![receiverType],
    "contactId": contactId == null ? null : contactId,
    "swiftCode": swiftCode == null ? null : swiftCode,
    "iban": iban == null ? null : ibanValues.reverse![iban],
    "branchCode": branchCode == null ? null : branchCode,
    "bankName": bankName == null ? null : bankName,
    "country": country == null ? null : country,
    "currency": currency == null ? null : currency,
  };

  @override
  String toString() {
    return '$firstName $accountNumber'.toLowerCase();
  }
}

enum AccountType { EMPTY, SAVINGS, ACCOUNT_TYPE_SAVINGS, BANK, E_WALLET, NRE }

final accountTypeValues = EnumValues({
  "Savings": AccountType.ACCOUNT_TYPE_SAVINGS,
  "BANK": AccountType.BANK,
  "": AccountType.EMPTY,
  "E-WALLET": AccountType.E_WALLET,
  "NRE": AccountType.NRE,
  "SAVINGS": AccountType.SAVINGS
});

enum Iban { EMPTY, ES9121000418450200051332 }

final ibanValues = EnumValues({
  "": Iban.EMPTY,
  "ES9121000418450200051332": Iban.ES9121000418450200051332
});

enum MiddleName { EMPTY, TEST, ABC, UMBARE, M, NEW, AC, RAM, D }

final middleNameValues = EnumValues({
  "abc": MiddleName.ABC,
  "ac": MiddleName.AC,
  "d": MiddleName.D,
  "": MiddleName.EMPTY,
  "m": MiddleName.M,
  "new": MiddleName.NEW,
  "ram": MiddleName.RAM,
  "test": MiddleName.TEST,
  "umbare": MiddleName.UMBARE
});

enum ReceiverType { BUSINESS, INDIVIDUAL }

final receiverTypeValues = EnumValues({
  "Business": ReceiverType.BUSINESS,
  "Individual": ReceiverType.INDIVIDUAL
});

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
