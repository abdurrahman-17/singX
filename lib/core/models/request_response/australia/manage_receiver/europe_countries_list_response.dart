// To parse this JSON data, do
//
//     final europeCountriesListResponse = europeCountriesListResponseFromJson(jsonString);

import 'dart:convert';

List<EuropeCountriesListResponse> europeCountriesListResponseFromJson(String str) => List<EuropeCountriesListResponse>.from(json.decode(str).map((x) => EuropeCountriesListResponse.fromJson(x)));

String europeCountriesListResponseToJson(List<EuropeCountriesListResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EuropeCountriesListResponse {
  EuropeCountriesListResponse({
    this.euroCountryId,
    this.country,
    this.countryId,
    this.countryCode1,
    this.activeStatus,
  });

  int? euroCountryId;
  String? country;
  int? countryId;
  String? countryCode1;
  int? activeStatus;

  factory EuropeCountriesListResponse.fromJson(Map<String, dynamic> json) => EuropeCountriesListResponse(
    euroCountryId: json["euroCountryId"] == null ? null : json["euroCountryId"],
    country: json["country"] == null ? null : json["country"],
    countryId: json["countryId"] == null ? null : json["countryId"],
    countryCode1: json["countryCode1"] == null ? null : json["countryCode1"],
    activeStatus: json["activeStatus"] == null ? null : json["activeStatus"],
  );

  Map<String, dynamic> toJson() => {
    "euroCountryId": euroCountryId == null ? null : euroCountryId,
    "country": country == null ? null : country,
    "countryId": countryId == null ? null : countryId,
    "countryCode1": countryCode1 == null ? null : countryCode1,
    "activeStatus": activeStatus == null ? null : activeStatus,
  };
}
