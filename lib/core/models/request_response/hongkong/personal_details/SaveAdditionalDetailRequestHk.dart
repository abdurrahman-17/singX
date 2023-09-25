// To parse this JSON data, do
//
//     final saveAdditionalDetailRequestHk = saveAdditionalDetailRequestHkFromJson(jsonString);

import 'dart:convert';

SaveAdditionalDetailRequestHk saveAdditionalDetailRequestHkFromJson(String str) => SaveAdditionalDetailRequestHk.fromJson(json.decode(str));

String saveAdditionalDetailRequestHkToJson(SaveAdditionalDetailRequestHk data) => json.encode(data.toJson());

class SaveAdditionalDetailRequestHk {
  SaveAdditionalDetailRequestHk({
    this.industry,
    this.employerName,
    this.openingPurpose,
    this.corridorInterest,
    this.estTransAmt,
    this.annualIncome,
    this.industryOthers,
    this.remitAmountComments,
    this.educationQualification,
    this.yearOfGraduation,
    this.gender,
    this.otp,
  });

  String? industry;
  String? employerName;
  String? openingPurpose;
  String? corridorInterest;
  String? estTransAmt;
  String? annualIncome;
  String? industryOthers;
  String? remitAmountComments;
  String? educationQualification;
  String? yearOfGraduation;
  String? gender;
  String? otp;

  factory SaveAdditionalDetailRequestHk.fromJson(Map<String, dynamic> json) => SaveAdditionalDetailRequestHk(
    industry: json["industry"] == null ? null : json["industry"],
    employerName: json["employerName"] == null ? null : json["employerName"],
    openingPurpose: json["openingPurpose"] == null ? null : json["openingPurpose"],
    corridorInterest: json["corridorInterest"] == null ? null : json["corridorInterest"],
    estTransAmt: json["estTransAmt"] == null ? null : json["estTransAmt"],
    annualIncome: json["annualIncome"] == null ? null : json["annualIncome"],
    industryOthers: json["industryOthers"] == null ? null : json["industryOthers"],
    remitAmountComments: json["remitAmountComments"] == null ? null : json["remitAmountComments"],
    educationQualification: json["educationQualification"] == null ? null : json["educationQualification"],
    yearOfGraduation: json["yearOfGraduation"] == null ? null : json["yearOfGraduation"],
    gender: json["gender"] == null ? null : json["gender"],
    otp: json["otp"] == null ? null : json["otp"],
  );

  Map<String, dynamic> toJson() => {
    "industry": industry == null ? null : industry,
    "employerName": employerName == null ? null : employerName,
    "openingPurpose": openingPurpose == null ? null : openingPurpose,
    "corridorInterest": corridorInterest == null ? null : corridorInterest,
    "estTransAmt": estTransAmt == null ? null : estTransAmt,
    "annualIncome": annualIncome == null ? null : annualIncome,
    "industryOthers": industryOthers == null ? null : industryOthers,
    "remitAmountComments": remitAmountComments == null ? null : remitAmountComments,
    "educationQualification": educationQualification == null ? null : educationQualification,
    "yearOfGraduation": yearOfGraduation == null ? null : yearOfGraduation,
    "gender": gender == null ? null : gender,
    "otp": otp == null ? null : otp,
  };
}
