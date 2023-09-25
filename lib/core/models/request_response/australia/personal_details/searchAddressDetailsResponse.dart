// To parse this JSON data, do
//
//     final searchAddressDetailsResponse = searchAddressDetailsResponseFromJson(jsonString);

import 'dart:convert';

SearchAddressDetailsResponse searchAddressDetailsResponseFromJson(String str) => SearchAddressDetailsResponse.fromJson(json.decode(str));

String searchAddressDetailsResponseToJson(SearchAddressDetailsResponse data) => json.encode(data.toJson());

class SearchAddressDetailsResponse {
  List<dynamic>? htmlAttributions;
  Result? result;
  String? status;

  SearchAddressDetailsResponse({
    this.htmlAttributions,
    this.result,
    this.status,
  });

  factory SearchAddressDetailsResponse.fromJson(Map<String, dynamic> json) => SearchAddressDetailsResponse(
    htmlAttributions: List<dynamic>.from(json["html_attributions"].map((x) => x)),
    result: Result.fromJson(json["result"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "html_attributions": List<dynamic>.from(htmlAttributions!.map((x) => x)),
    "result": result!.toJson(),
    "status": status,
  };
}

class Result {
  List<AddressComponent>? addressComponents;
  String? adrAddress;
  String? formattedAddress;
  Geometry? geometry;
  String? icon;
  String? iconBackgroundColor;
  String? iconMaskBaseUri;
  String? name;
  String? placeId;
  String? reference;
  List<String>? types;
  String? url;
  int? utcOffset;
  String? vicinity;

  Result({
    this.addressComponents,
    this.adrAddress,
    this.formattedAddress,
    this.geometry,
    this.icon,
    this.iconBackgroundColor,
    this.iconMaskBaseUri,
    this.name,
    this.placeId,
    this.reference,
    this.types,
    this.url,
    this.utcOffset,
    this.vicinity,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    addressComponents: List<AddressComponent>.from(json["address_components"].map((x) => AddressComponent.fromJson(x))),
    adrAddress: json["adr_address"],
    formattedAddress: json["formatted_address"],
    geometry: Geometry.fromJson(json["geometry"]),
    icon: json["icon"],
    iconBackgroundColor: json["icon_background_color"],
    iconMaskBaseUri: json["icon_mask_base_uri"],
    name: json["name"],
    placeId: json["place_id"],
    reference: json["reference"],
    types: List<String>.from(json["types"].map((x) => x)),
    url: json["url"],
    utcOffset: json["utc_offset"],
    vicinity: json["vicinity"],
  );

  Map<String, dynamic> toJson() => {
    "address_components": List<dynamic>.from(addressComponents!.map((x) => x.toJson())),
    "adr_address": adrAddress,
    "formatted_address": formattedAddress,
    "geometry": geometry!.toJson(),
    "icon": icon,
    "icon_background_color": iconBackgroundColor,
    "icon_mask_base_uri": iconMaskBaseUri,
    "name": name,
    "place_id": placeId,
    "reference": reference,
    "types": List<dynamic>.from(types!.map((x) => x)),
    "url": url,
    "utc_offset": utcOffset,
    "vicinity": vicinity,
  };
}

class AddressComponent {
  String? longName;
  String? shortName;
  List<String>? types;

  AddressComponent({
    this.longName,
    this.shortName,
    this.types,
  });

  factory AddressComponent.fromJson(Map<String, dynamic> json) => AddressComponent(
    longName: json["long_name"],
    shortName: json["short_name"],
    types: List<String>.from(json["types"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "long_name": longName,
    "short_name": shortName,
    "types": List<dynamic>.from(types!.map((x) => x)),
  };
}

class Geometry {
  Location? location;
  Viewport? viewport;

  Geometry({
    this.location,
    this.viewport,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    location: Location.fromJson(json["location"]),
    viewport: Viewport.fromJson(json["viewport"]),
  );

  Map<String, dynamic> toJson() => {
    "location": location!.toJson(),
    "viewport": viewport!.toJson(),
  };
}

class Location {
  double? lat;
  double? lng;

  Location({
    this.lat,
    this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}

class Viewport {
  Location? northeast;
  Location? southwest;

  Viewport({
    this.northeast,
    this.southwest,
  });

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
    northeast: Location.fromJson(json["northeast"]),
    southwest: Location.fromJson(json["southwest"]),
  );

  Map<String, dynamic> toJson() => {
    "northeast": northeast!.toJson(),
    "southwest": southwest!.toJson(),
  };
}
