class SearchAddressResponse {
  final String placeId;
  final String description;

  SearchAddressResponse(this.placeId, this.description);

  @override
  String toString() {
    return 'SearchAddressResponse(description: $description, placeId: $placeId)';
  }
}