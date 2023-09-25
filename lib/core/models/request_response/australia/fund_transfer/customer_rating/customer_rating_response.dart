// To parse this JSON data, do
//
//     final customerRatingResponse = customerRatingResponseFromJson(jsonString);

import 'dart:convert';

CustomerRatingResponse customerRatingResponseFromJson(String str) => CustomerRatingResponse.fromJson(json.decode(str));

String customerRatingResponseToJson(CustomerRatingResponse data) => json.encode(data.toJson());

class CustomerRatingResponse {
  CustomerRatingResponse({
    this.contactId,
    this.isratingdone,
    this.rating,
  });

  int? contactId;
  bool? isratingdone;
  int? rating;

  factory CustomerRatingResponse.fromJson(Map<String, dynamic> json) => CustomerRatingResponse(
    contactId: json["contactId"] == null ? null : json["contactId"],
    isratingdone: json["isratingdone"] == null ? null : json["isratingdone"],
    rating: json["rating"] == null ? null : json["rating"],
  );

  Map<String, dynamic> toJson() => {
    "contactId": contactId == null ? null : contactId,
    "isratingdone": isratingdone == null ? null : isratingdone,
    "rating": rating == null ? null : rating,
  };
}
