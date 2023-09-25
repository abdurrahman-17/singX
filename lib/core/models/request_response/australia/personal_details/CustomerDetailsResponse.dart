// To parse this JSON data, do
//
//     final customerDetailsResponse = customerDetailsResponseFromJson(jsonString);

import 'dart:convert';

CustomerDetailsResponse customerDetailsResponseFromJson(String str) => CustomerDetailsResponse.fromJson(json.decode(str));

String customerDetailsResponseToJson(CustomerDetailsResponse data) => json.encode(data.toJson());

class CustomerDetailsResponse {
  CustomerDetailsResponse({
    this.tittle,
    this.firstName,
    this.middleName,
    this.lastName,
    this.dateOfBirth,
    this.nationality,
    this.residenceId,
    this.occupation,
    this.otherOccupation,
    this.employerName,
    this.position,
    this.estimatedTxnamount,
    this.openingPurpose,
    this.countryCode,
    this.phoneNumber,
    this.address,
    this.addressLine1,
    this.addressLine2,
    this.addressLine3,
    this.addressLine4,
    this.addressLine5,
    this.state,
    this.country,
    this.postalCode,
    this.cra,
    this.promoCode,
    this.contactId,
    this.gender,
    this.countryOfBirth,
    this.custOnboardApiDocBeans,
    this.custOnboardDocBeans,
    this.annualIncome,
    this.stepTwoAttempts,
    this.errorList,
    this.profileEdit,
  });

  String? tittle;
  String? firstName;
  String? middleName;
  String? lastName;
  DateTime? dateOfBirth;
  String? nationality;
  String? residenceId;
  String? occupation;
  String? otherOccupation;
  String? employerName;
  dynamic? position;
  String? estimatedTxnamount;
  dynamic? openingPurpose;
  String? countryCode;
  String? phoneNumber;
  String? address;
  String? addressLine1;
  String? addressLine2;
  String? addressLine3;
  String? addressLine4;
  String? addressLine5;
  String? state;
  String? country;
  String? postalCode;
  bool? cra;
  String? promoCode;
  int? contactId;
  dynamic? gender;
  dynamic? countryOfBirth;
  List<CustOnboardApiDocBean>? custOnboardApiDocBeans;
  CustOnboardDocBeans? custOnboardDocBeans;
  dynamic? annualIncome;
  int? stepTwoAttempts;
  List<String>? errorList;
  bool? profileEdit;

  factory CustomerDetailsResponse.fromJson(Map<String, dynamic> json) => CustomerDetailsResponse(
    tittle: json["tittle"] == null ? null : json["tittle"],
    firstName: json["firstName"] == null ? null : json["firstName"],
    middleName: json["middleName"] == null ? null : json["middleName"],
    lastName: json["lastName"] == null ? null : json["lastName"],
    dateOfBirth: json["dateOfBirth"] == null ? null : DateTime.parse(json["dateOfBirth"]),
    nationality: json["nationality"] == null ? null : json["nationality"],
    residenceId: json["residenceId"] == null ? null : json["residenceId"],
    occupation: json["occupation"] == null ? null : json["occupation"],
    otherOccupation: json["otherOccupation"] == null ? null : json["otherOccupation"],
    employerName: json["employerName"] == null ? null : json["employerName"],
    position: json["position"],
    estimatedTxnamount: json["estimatedTxnamount"] == null ? null : json["estimatedTxnamount"],
    openingPurpose: json["openingPurpose"],
    countryCode: json["countryCode"] == null ? null : json["countryCode"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    address: json["address"] == null ? null : json["address"],
    addressLine1: json["addressLine1"] == null ? null : json["addressLine1"],
    addressLine2: json["addressLine2"] == null ? null : json["addressLine2"],
    addressLine3: json["addressLine3"] == null ? null : json["addressLine3"],
    addressLine4: json["addressLine4"] == null ? null : json["addressLine4"],
    addressLine5: json["addressLine5"] == null ? null : json["addressLine5"],
    state: json["state"] == null ? null : json["state"],
    country: json["country"] == null ? null : json["country"],
    postalCode: json["postalCode"] == null ? null : json["postalCode"],
    cra: json["cra"] == null ? null : json["cra"],
    promoCode: json["promoCode"] == null ? null : json["promoCode"],
    contactId: json["contactId"] == null ? null : json["contactId"],
    gender: json["gender"],
    countryOfBirth: json["countryOfBirth"],
    custOnboardApiDocBeans: json["custOnboardApiDocBeans"] == null ? null : List<CustOnboardApiDocBean>.from(json["custOnboardApiDocBeans"].map((x) => CustOnboardApiDocBean.fromJson(x))),
    custOnboardDocBeans: json["custOnboardDocBeans"] == null ? null : CustOnboardDocBeans.fromJson(json["custOnboardDocBeans"]),
    annualIncome: json["annualIncome"],
    stepTwoAttempts: json["stepTwoAttempts"] == null ? null : json["stepTwoAttempts"],
    errorList: json["errorList"] == null ? null : List<String>.from(json["errorList"].map((x) => x)),
    profileEdit: json["profileEdit"] == null ? null : json["profileEdit"],
  );

  Map<String, dynamic> toJson() => {
    "tittle": tittle == null ? null : tittle,
    "firstName": firstName == null ? null : firstName,
    "middleName": middleName == null ? null : middleName,
    "lastName": lastName == null ? null : lastName,
    "dateOfBirth": dateOfBirth == null ? null : "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
    "nationality": nationality == null ? null : nationality,
    "residenceId": residenceId == null ? null : residenceId,
    "occupation": occupation == null ? null : occupation,
    "otherOccupation": otherOccupation == null ? null : otherOccupation,
    "employerName": employerName == null ? null : employerName,
    "position": position,
    "estimatedTxnamount": estimatedTxnamount == null ? null : estimatedTxnamount,
    "openingPurpose": openingPurpose,
    "countryCode": countryCode == null ? null : countryCode,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "address": address == null ? null : address,
    "addressLine1": addressLine1 == null ? null : addressLine1,
    "addressLine2": addressLine2 == null ? null : addressLine2,
    "addressLine3": addressLine3 == null ? null : addressLine3,
    "addressLine4": addressLine4 == null ? null : addressLine4,
    "addressLine5": addressLine5 == null ? null : addressLine5,
    "state": state == null ? null : state,
    "country": country == null ? null : country,
    "postalCode": postalCode == null ? null : postalCode,
    "cra": cra == null ? null : cra,
    "promoCode": promoCode == null ? null : promoCode,
    "contactId": contactId == null ? null : contactId,
    "gender": gender,
    "countryOfBirth": countryOfBirth,
    "custOnboardApiDocBeans": custOnboardApiDocBeans == null ? null : List<dynamic>.from(custOnboardApiDocBeans!.map((x) => x.toJson())),
    "custOnboardDocBeans": custOnboardDocBeans == null ? null : custOnboardDocBeans!.toJson(),
    "annualIncome": annualIncome,
    "stepTwoAttempts": stepTwoAttempts == null ? null : stepTwoAttempts,
    "errorList": errorList == null ? null : List<dynamic>.from(errorList!.map((x) => x)),
    "profileEdit": profileEdit == null ? null : profileEdit,
  };
}

class CustOnboardApiDocBean {
  CustOnboardApiDocBean({
    this.contactId,
    this.requestType,
    this.docStatus,
  });

  int? contactId;
  String? requestType;
  String? docStatus;

  factory CustOnboardApiDocBean.fromJson(Map<String, dynamic> json) => CustOnboardApiDocBean(
    contactId: json["contactId"] == null ? null : json["contactId"],
    requestType: json["requestType"] == null ? null : json["requestType"],
    docStatus: json["docStatus"] == null ? null : json["docStatus"],
  );

  Map<String, dynamic> toJson() => {
    "contactId": contactId == null ? null : contactId,
    "requestType": requestType == null ? null : requestType,
    "docStatus": docStatus == null ? null : docStatus,
  };
}

class CustOnboardDocBeans {
  CustOnboardDocBeans({
    this.australianDrivingLicense,
  });

  AustralianDrivingLicense? australianDrivingLicense;

  factory CustOnboardDocBeans.fromJson(Map<String, dynamic> json) => CustOnboardDocBeans(
    australianDrivingLicense: json["Australian-Driving-License"] == null ? null : AustralianDrivingLicense.fromJson(json["Australian-Driving-License"]),
  );

  Map<String, dynamic> toJson() => {
    "Australian-Driving-License": australianDrivingLicense == null ? null : australianDrivingLicense!.toJson(),
  };
}

class AustralianDrivingLicense {
  AustralianDrivingLicense({
    this.documentId,
    this.documentName,
    this.contactId,
    this.referenceNumber,
    this.issueDate,
    this.expiryDate,
    this.issuingAuthority,
    this.cardColour,
    this.countryOfIssue,
    this.individualRefNo,
    this.medicareCardName,
    this.isDocVerified,
    this.dlFName,
    this.dlMName,
    this.dlLName,
    this.ppFName,
    this.ppMName,
    this.ppLName,
    this.gender,
  });

  int? documentId;
  String? documentName;
  int? contactId;
  String? referenceNumber;
  String? issueDate;
  DateTime? expiryDate;
  String? issuingAuthority;
  String? cardColour;
  String? countryOfIssue;
  String? individualRefNo;
  String? medicareCardName;
  int? isDocVerified;
  String? dlFName;
  String? dlMName;
  String? dlLName;
  String? ppFName;
  String? ppMName;
  String? ppLName;
  String? gender;

  factory AustralianDrivingLicense.fromJson(Map<String, dynamic> json) => AustralianDrivingLicense(
    documentId: json["documentId"] == null ? null : json["documentId"],
    documentName: json["documentName"] == null ? null : json["documentName"],
    contactId: json["contactId"] == null ? null : json["contactId"],
    referenceNumber: json["referenceNumber"] == null ? null : json["referenceNumber"],
    issueDate: json["issueDate"] == null ? null : json["issueDate"],
    expiryDate: json["expiryDate"] == null ? null : DateTime.parse(json["expiryDate"]),
    issuingAuthority: json["issuingAuthority"] == null ? null : json["issuingAuthority"],
    cardColour: json["cardColour"] == null ? null : json["cardColour"],
    countryOfIssue: json["countryOfIssue"] == null ? null : json["countryOfIssue"],
    individualRefNo: json["individualRefNo"] == null ? null : json["individualRefNo"],
    medicareCardName: json["medicareCardName"] == null ? null : json["medicareCardName"],
    isDocVerified: json["isDocVerified"] == null ? null : json["isDocVerified"],
    dlFName: json["dlFName"] == null ? null : json["dlFName"],
    dlMName: json["dlMName"] == null ? null : json["dlMName"],
    dlLName: json["dlLName"] == null ? null : json["dlLName"],
    ppFName: json["ppFName"] == null ? null : json["ppFName"],
    ppMName: json["ppMName"] == null ? null : json["ppMName"],
    ppLName: json["ppLName"] == null ? null : json["ppLName"],
    gender: json["gender"] == null ? null : json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "documentId": documentId == null ? null : documentId,
    "documentName": documentName == null ? null : documentName,
    "contactId": contactId == null ? null : contactId,
    "referenceNumber": referenceNumber == null ? null : referenceNumber,
    "issueDate": issueDate == null ? null : issueDate,
    "expiryDate": expiryDate == null ? null : "${expiryDate!.year.toString().padLeft(4, '0')}-${expiryDate!.month.toString().padLeft(2, '0')}-${expiryDate!.day.toString().padLeft(2, '0')}",
    "issuingAuthority": issuingAuthority == null ? null : issuingAuthority,
    "cardColour": cardColour == null ? null : cardColour,
    "countryOfIssue": countryOfIssue == null ? null : countryOfIssue,
    "individualRefNo": individualRefNo == null ? null : individualRefNo,
    "medicareCardName": medicareCardName == null ? null : medicareCardName,
    "isDocVerified": isDocVerified == null ? null : isDocVerified,
    "dlFName": dlFName == null ? null : dlFName,
    "dlMName": dlMName == null ? null : dlMName,
    "dlLName": dlLName == null ? null : dlLName,
    "ppFName": ppFName == null ? null : ppFName,
    "ppMName": ppMName == null ? null : ppMName,
    "ppLName": ppLName == null ? null : ppLName,
    "gender": gender == null ? null : gender,
  };
}
