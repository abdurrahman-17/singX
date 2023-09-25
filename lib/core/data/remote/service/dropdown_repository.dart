import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:singx/core/data/remote/network/app_url.dart';
import 'package:singx/core/data/remote/network/method.dart';
import 'package:singx/core/data/remote/service/base/base_repository.dart';
import 'package:singx/core/models/request_response/dropdown/dropdown_response.dart';
import 'package:singx/core/models/request_response/dropdown/gender_dropdown_response.dart';
import 'package:singx/utils/common/app_constants.dart';
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/shared_preference/shared_preference_mobile_web.dart';

class DropdownRepository extends BaseRepository {
  DropdownRepository._internal();

  static final DropdownRepository _singleInstance =
      DropdownRepository._internal();

  factory DropdownRepository() => _singleInstance;

  //api: Salutation
  Future<Object?> apiSalutaion(BuildContext context) async {
    String? selectedCountry;

    await SharedPreferencesMobileWeb.instance
        .getCountry(country)
        .then((value) async {
      if (value == AustraliaName) selectedCountry = AppConstants.au;
      if (value == HongKongName) selectedCountry = AppConstants.hk;
      if (value == SingaporeName) selectedCountry = AppConstants.sg;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: "${AppUrl.pathSatlutation}${selectedCountry}",
      headers: headerContentTypeAndAccept,
      dropdown: true,
    );
    if (response.statusCode == HttpStatus.ok) {
      DropdownResponse salutationList =
          dropdownResponseFromJson(jsonEncode(response.data));
      return salutationList;
    } else {
      return dropdownResponseFromJson(jsonEncode(response.data));
    }
  }

  //api: Annual Income
  Future<Object?> apiAnnualIncome(BuildContext context) async {
    String? selectedCountry;

    await SharedPreferencesMobileWeb.instance
        .getCountry(country)
        .then((value) async {
      if (value == AustraliaName) selectedCountry = AppConstants.au;
      if (value == HongKongName) selectedCountry = AppConstants.hk;
      if (value == SingaporeName) selectedCountry = AppConstants.sg;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: "${AppUrl.pathAnnualIncome}${selectedCountry}",
      headers: headerContentTypeAndAccept,
      dropdown: true,
    );

    if (response.statusCode == HttpStatus.ok) {
      DropdownResponse annualIncomeList =
          dropdownResponseFromJson(jsonEncode(response.data));
      return annualIncomeList;
    } else {
      return dropdownResponseFromJson(jsonEncode(response.data));
    }
  }

  //api: Occupation
  Future<Object?> apiOccupation(BuildContext context) async {
    String? selectedCountry;

    await SharedPreferencesMobileWeb.instance
        .getCountry(country)
        .then((value) async {
      if (value == AustraliaName) selectedCountry = AppConstants.au;
      if (value == HongKongName) selectedCountry = AppConstants.hk;
      if (value == SingaporeName) selectedCountry = AppConstants.sg;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: "${AppUrl.pathOccupation}${selectedCountry}",
      headers: headerContentTypeAndAccept,
      dropdown: true,
    );

    if (response.statusCode == HttpStatus.ok) {
      DropdownResponse occupationList =
          dropdownResponseFromJson(jsonEncode(response.data));
      return occupationList;
    } else {
      return dropdownResponseFromJson(jsonEncode(response.data));
    }
  }

  //api: Nationality
  Future<Object?> apiNationality(BuildContext context) async {
    String? selectedCountry;

    await SharedPreferencesMobileWeb.instance
        .getCountry(country)
        .then((value) async {
      if (value == AustraliaName) selectedCountry = AppConstants.au;
      if (value == HongKongName) selectedCountry = AppConstants.hk;
      if (value == SingaporeName) selectedCountry = AppConstants.sg;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: "${AppUrl.pathNationality}${selectedCountry}",
      headers: headerContentTypeAndAccept,
      dropdown: true,
    );

    if (response.statusCode == HttpStatus.ok) {
      DropdownResponse nationalityList =
          dropdownResponseFromJson(jsonEncode(response.data));
      return nationalityList;
    } else {
      return dropdownResponseFromJson(jsonEncode(response.data));
    }
  }

  //api: Industry
  Future<Object?> apiIndustry(BuildContext context) async {
    String? selectedCountry;

    await SharedPreferencesMobileWeb.instance
        .getCountry(country)
        .then((value) async {
      if (value == AustraliaName) selectedCountry = AppConstants.au;
      if (value == HongKongName) selectedCountry = AppConstants.hk;
      if (value == SingaporeName) selectedCountry = AppConstants.sg;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: "${AppUrl.pathIndustry}${selectedCountry}",
      headers: headerContentTypeAndAccept,
      dropdown: true,
    );

    if (response.statusCode == HttpStatus.ok) {
      DropdownResponse industryList =
          dropdownResponseFromJson(jsonEncode(response.data));
      return industryList;
    } else {
      return dropdownResponseFromJson(jsonEncode(response.data));
    }
  }

  //api: Registration Purpose
  Future<Object?> apiRegistrationPurpose(BuildContext context) async {
    String? selectedCountry;

    await SharedPreferencesMobileWeb.instance
        .getCountry(country)
        .then((value) async {
      if (value == AustraliaName) selectedCountry = AppConstants.au;
      if (value == HongKongName) selectedCountry = AppConstants.hk;
      if (value == SingaporeName) selectedCountry = AppConstants.sg;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: "${AppUrl.pathRegistrationPurpose}${selectedCountry}",
      headers: headerContentTypeAndAccept,
      dropdown: true,
    );

    if (response.statusCode == HttpStatus.ok) {
      DropdownResponse registrationPurposeResponse =
          dropdownResponseFromJson(jsonEncode(response.data));
      return registrationPurposeResponse;
    } else {
      return dropdownResponseFromJson(jsonEncode(response.data));
    }
  }

  //api: Corridor Of Interest
  Future<Object?> apiCorridorOfInterest(BuildContext context) async {
    String? selectedCountry;

    await SharedPreferencesMobileWeb.instance
        .getCountry(country)
        .then((value) async {
      if (value == AustraliaName) selectedCountry = AppConstants.au;
      if (value == HongKongName) selectedCountry = AppConstants.hk;
      if (value == SingaporeName) selectedCountry = AppConstants.sg;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: "${AppUrl.pathCorridorOfInterest}${selectedCountry}",
      headers: headerContentTypeAndAccept,
      dropdown: true,
    );

    if (response.statusCode == HttpStatus.ok) {
      DropdownResponse corridorOfInterestResponse =
          dropdownResponseFromJson(jsonEncode(response.data));
      return corridorOfInterestResponse;
    } else {
      return dropdownResponseFromJson(jsonEncode(response.data));
    }
  }

  //api: Education Qualification
  Future<Object?> apiEducationQualification(BuildContext context) async {
    String? selectedCountry;

    await SharedPreferencesMobileWeb.instance
        .getCountry(country)
        .then((value) async {
      if (value == AustraliaName) selectedCountry = AppConstants.au;
      if (value == HongKongName) selectedCountry = AppConstants.hk;
      if (value == SingaporeName) selectedCountry = AppConstants.sg;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: "${AppUrl.pathEducationQualification}${selectedCountry}",
      headers: headerContentTypeAndAccept,
      dropdown: true,
    );

    if (response.statusCode == HttpStatus.ok) {
      DropdownResponse educationQualificationResponse =
          dropdownResponseFromJson(jsonEncode(response.data));
      return educationQualificationResponse;
    } else {
      return dropdownResponseFromJson(jsonEncode(response.data));
    }
  }

  //api: Estimated Transaction Amount
  Future<Object?> apiEstimatedTransactionAmount(BuildContext context) async {
    String? selectedCountry;

    await SharedPreferencesMobileWeb.instance
        .getCountry(country)
        .then((value) async {
      if (value == AustraliaName) selectedCountry = AppConstants.au;
      if (value == HongKongName) selectedCountry = AppConstants.hk;
      if (value == SingaporeName) selectedCountry = AppConstants.sg;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: "${AppUrl.pathEstimatedTransactionAmount}${selectedCountry}",
      headers: headerContentTypeAndAccept,
      dropdown: true,
    );

    if (response.statusCode == HttpStatus.ok) {
      DropdownResponse estimatedTransactionAmountResponse =
          dropdownResponseFromJson(jsonEncode(response.data));
      return estimatedTransactionAmountResponse;
    } else {
      return dropdownResponseFromJson(jsonEncode(response.data));
    }
  }

  //api: State
  Future<Object?> apiState(BuildContext context) async {
    String? selectedCountry;

    await SharedPreferencesMobileWeb.instance
        .getCountry(country)
        .then((value) async {
      if (value == AustraliaName) selectedCountry = AppConstants.au;
      if (value == HongKongName) selectedCountry = AppConstants.hk;
      if (value == SingaporeName) selectedCountry = AppConstants.sg;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: "${AppUrl.pathState}${selectedCountry}",
      headers: headerContentTypeAndAccept,
      dropdown: true,
    );

    if (response.statusCode == HttpStatus.ok) {
      DropdownResponse stateResponse =
          dropdownResponseFromJson(jsonEncode(response.data));
      return stateResponse;
    } else {
      return dropdownResponseFromJson(jsonEncode(response.data));
    }
  }

  //api: State
  Future<Object?> apiRegion(BuildContext context) async {
    String? selectedCountry;

    await SharedPreferencesMobileWeb.instance
        .getCountry(country)
        .then((value) async {
      if (value == AustraliaName) selectedCountry = AppConstants.au;
      if (value == HongKongName) selectedCountry = AppConstants.hk;
      if (value == SingaporeName) selectedCountry = AppConstants.sg;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: "${AppUrl.pathRegion}${selectedCountry}",
      headers: headerContentTypeAndAccept,
      dropdown: true,
    );

    if (response.statusCode == HttpStatus.ok) {
      DropdownResponse regionResponse =
          dropdownResponseFromJson(jsonEncode(response.data));
      return regionResponse;
    } else {
      return dropdownResponseFromJson(jsonEncode(response.data));
    }
  }

  //api: Residence Status
  Future<Object?> apiResidenceStatus(BuildContext context) async {
    String? selectedCountry;

    await SharedPreferencesMobileWeb.instance
        .getCountry(country)
        .then((value) async {
      if (value == AustraliaName) selectedCountry = AppConstants.au;
      if (value == HongKongName) selectedCountry = AppConstants.hk;
      if (value == SingaporeName) selectedCountry = AppConstants.sg;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: "${AppUrl.pathResidenceStatus}${selectedCountry}",
      headers: headerContentTypeAndAccept,
      dropdown: true,
    );
    if (response.statusCode == HttpStatus.ok) {
      var dropdownResponse =
          dropdownResponseResidenceFromJson(json.encode(response.data));
      return dropdownResponse;
    } else {
      return dropdownResponseFromJson(jsonEncode(response.data));
    }
  }

  //api: State
  Future<Object?> apiGender(BuildContext context) async {
    String? selectedCountry;

    await SharedPreferencesMobileWeb.instance
        .getCountry(country)
        .then((value) async {
      if (value == AustraliaName) selectedCountry = AppConstants.au;
      if (value == HongKongName) selectedCountry = AppConstants.hk;
      if (value == SingaporeName) selectedCountry = AppConstants.sg;
    });

    Response response = await networkProvider.call(
      method: Method.GET,
      pathUrl: "${AppUrl.pathGender}${selectedCountry}",
      headers: headerContentTypeAndAccept,
      dropdown: true,
    );
    if (response.statusCode == HttpStatus.ok) {
      List<GenderDropdownResponse> regionResponse =
          genderDropdownResponseFromJson(jsonEncode(response.data));
      return regionResponse;
    } else {
      return genderDropdownResponseFromJson(jsonEncode(response.data));
    }
  }
}
