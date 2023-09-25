// To parse this JSON data, do
//
//     final digitalVerificationStepTwoResponseAus = digitalVerificationStepTwoResponseAusFromJson(jsonString);

import 'dart:convert';

DigitalVerificationStepTwoResponseAus digitalVerificationStepTwoResponseAusFromJson(String str) => DigitalVerificationStepTwoResponseAus.fromJson(json.decode(str));

String digitalVerificationStepTwoResponseAusToJson(DigitalVerificationStepTwoResponseAus data) => json.encode(data.toJson());

class DigitalVerificationStepTwoResponseAus {
  DigitalVerificationStepTwoResponseAus({
    this.stateofIssue,
    this.cardType,
  });

  List<String>? stateofIssue;
  List<String>? cardType;

  factory DigitalVerificationStepTwoResponseAus.fromJson(Map<String, dynamic> json) => DigitalVerificationStepTwoResponseAus(
    stateofIssue: json["stateofIssue"] == null ? null : List<String>.from(json["stateofIssue"].map((x) => x)),
    cardType: json["cardType"] == null ? null : List<String>.from(json["cardType"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "stateofIssue": stateofIssue == null ? null : List<dynamic>.from(stateofIssue!.map((x) => x)),
    "cardType": cardType == null ? null : List<dynamic>.from(cardType!.map((x) => x)),
  };
}
