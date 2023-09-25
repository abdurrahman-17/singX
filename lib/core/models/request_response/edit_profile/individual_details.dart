// To parse this JSON data, do
//
//     final individualRegDetail = individualRegDetailFromJson(jsonString);

import 'dart:convert';

List<IndividualRegDetail> individualRegDetailFromJson(String str) => List<IndividualRegDetail>.from(json.decode(str).map((x) => IndividualRegDetail.fromJson(x)));

String individualRegDetailToJson(List<IndividualRegDetail> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IndividualRegDetail {
  IndividualRegDetail({
    this.primaryKey,
    this.expiryDate,
    this.idProofValue,
    this.nationalityId,
    this.mapId,
    this.customerId,
    this.documentId,
    this.residenceTypeId,
    this.contactId,
    this.versionId,
    this.residenceType,
  });

  dynamic primaryKey;
  DateTime? expiryDate;
  String? idProofValue;
  String? nationalityId;
  String? mapId;
  String? customerId;
  String? documentId;
  String? residenceTypeId;
  String? contactId;
  int? versionId;
  ResidenceType? residenceType;

  factory IndividualRegDetail.fromJson(Map<String, dynamic> json) => IndividualRegDetail(
    primaryKey: json["primaryKey"],
    expiryDate: json["expiryDate"] == null ? null : DateTime.parse(json["expiryDate"]),
    idProofValue: json["idProofValue"],
    nationalityId: json["nationalityId"],
    mapId: json["mapId"],
    customerId: json["customerId"],
    documentId: json["documentId"],
    residenceTypeId: json["residenceTypeId"],
    contactId: json["contactId"],
    versionId: json["versionId"],
    residenceType: json["residenceType"] == null ? null : ResidenceType.fromJson(json["residenceType"]),
  );

  Map<String, dynamic> toJson() => {
    "primaryKey": primaryKey,
    "expiryDate": "${expiryDate!.year.toString().padLeft(4, '0')}-${expiryDate!.month.toString().padLeft(2, '0')}-${expiryDate!.day.toString().padLeft(2, '0')}",
    "idProofValue": idProofValue,
    "nationalityId": nationalityId,
    "mapId": mapId,
    "customerId": customerId,
    "documentId": documentId,
    "residenceTypeId": residenceTypeId,
    "contactId": contactId,
    "versionId": versionId,
    "residenceType": residenceType?.toJson(),
  };
}

class ResidenceType {
  ResidenceType({
    this.name,
    this.id,
    this.countryId,
  });

  String? name;
  String? id;
  String? countryId;

  factory ResidenceType.fromJson(Map<String, dynamic> json) => ResidenceType(
    name: json["name"],
    id: json["id"],
    countryId: json["countryId"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "countryId": countryId,
  };
}
