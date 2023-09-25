// To parse this JSON data, do
//
//     final customerRatingResponseSg = customerRatingResponseSgFromJson(jsonString);

import 'dart:convert';

CustomerRatingResponseSg customerRatingResponseSgFromJson(String str) => CustomerRatingResponseSg.fromJson(json.decode(str));

String customerRatingResponseSgToJson(CustomerRatingResponseSg data) => json.encode(data.toJson());

class CustomerRatingResponseSg {
  CustomerRatingResponseSg({
    this.response,
  });

  ResponseData? response;

  factory CustomerRatingResponseSg.fromJson(Map<String, dynamic> json) => CustomerRatingResponseSg(
    response: json["response"] == null ? null : ResponseData.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "response": response == null ? null : response!.toJson(),
  };
}

class ResponseData {
  ResponseData({
    this.ratingPopcliked,
  });

  bool? ratingPopcliked;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    ratingPopcliked: json["ratingPopcliked"] == null ? null : json["ratingPopcliked"],
  );

  Map<String, dynamic> toJson() => {
    "ratingPopcliked": ratingPopcliked == null ? null : ratingPopcliked,
  };
}
