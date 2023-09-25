// To parse this JSON data, do
//
//     final receiverListResponse = receiverListResponseFromJson(jsonString);

import 'dart:convert';

ReceiverListResponse receiverListResponseFromJson(String str) => ReceiverListResponse.fromJson(json.decode(str));

String receiverListResponseToJson(ReceiverListResponse data) => json.encode(data.toJson());

class ReceiverListResponse {
  ReceiverListResponse({
    this.content,
    this.pageable,
    this.totalElements,
    this.totalPages,
    this.last,
    this.size,
    this.number,
    this.sort,
    this.numberOfElements,
    this.first,
    this.empty,
  });

  List<Content>? content;
  Pageable? pageable;
  int? totalElements;
  int? totalPages;
  bool? last;
  int? size;
  int? number;
  Sort? sort;
  int? numberOfElements;
  bool? first;
  bool? empty;

  factory ReceiverListResponse.fromJson(Map<String, dynamic> json) => ReceiverListResponse(
    content: json["content"] == null ? null : List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
    pageable: json["pageable"] == null ? null : Pageable.fromJson(json["pageable"]),
    totalElements: json["totalElements"] == null ? null : json["totalElements"],
    totalPages: json["totalPages"] == null ? null : json["totalPages"],
    last: json["last"] == null ? null : json["last"],
    size: json["size"] == null ? null : json["size"],
    number: json["number"] == null ? null : json["number"],
    sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
    numberOfElements: json["numberOfElements"] == null ? null : json["numberOfElements"],
    first: json["first"] == null ? null : json["first"],
    empty: json["empty"] == null ? null : json["empty"],
  );

  Map<String, dynamic> toJson() => {
    "content": content == null ? null : List<dynamic>.from(content!.map((x) => x.toJson())),
    "pageable": pageable == null ? null : pageable!.toJson(),
    "totalElements": totalElements == null ? null : totalElements,
    "totalPages": totalPages == null ? null : totalPages,
    "last": last == null ? null : last,
    "size": size == null ? null : size,
    "number": number == null ? null : number,
    "sort": sort == null ? null : sort!.toJson(),
    "numberOfElements": numberOfElements == null ? null : numberOfElements,
    "first": first == null ? null : first,
    "empty": empty == null ? null : empty,
  };
}

class Content {
  Content({
    this.id,
    this.name,
    this.accountNumber,
    this.bankName,
    this.branchName,
    this.country,
    this.address,
    this.accountType,
  });

  String? id;
  String? name;
  String? accountNumber;
  String? bankName;
  String? branchName;
  String? country;
  String? address;
  String? accountType;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    accountNumber: json["accountNumber"] == null ? null : json["accountNumber"],
    bankName: json["bankName"] == null ? null : json["bankName"],
    branchName: json["branchName"] == null ? null : json["branchName"],
    country: json["country"] == null ? null : json["country"],
    address: json["address"] == null ? null : json["address"],
    accountType: json["accountType"] == null ? null : json["accountType"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "accountNumber": accountNumber == null ? null : accountNumber,
    "bankName": bankName == null ? null : bankName,
    "branchName": branchName == null ? null : branchName,
    "country": country == null ? null : country,
    "address": address == null ? null : address,
    "accountType": accountType == null ? null : accountType,
  };
}

class Pageable {
  Pageable({
    this.sort,
    this.offset,
    this.pageNumber,
    this.pageSize,
    this.paged,
    this.unpaged,
  });

  Sort? sort;
  int? offset;
  int? pageNumber;
  int? pageSize;
  bool? paged;
  bool? unpaged;

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
    sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
    offset: json["offset"] == null ? null : json["offset"],
    pageNumber: json["pageNumber"] == null ? null : json["pageNumber"],
    pageSize: json["pageSize"] == null ? null : json["pageSize"],
    paged: json["paged"] == null ? null : json["paged"],
    unpaged: json["unpaged"] == null ? null : json["unpaged"],
  );

  Map<String, dynamic> toJson() => {
    "sort": sort == null ? null : sort!.toJson(),
    "offset": offset == null ? null : offset,
    "pageNumber": pageNumber == null ? null : pageNumber,
    "pageSize": pageSize == null ? null : pageSize,
    "paged": paged == null ? null : paged,
    "unpaged": unpaged == null ? null : unpaged,
  };
}

class Sort {
  Sort({
    this.sorted,
    this.unsorted,
    this.empty,
  });

  bool? sorted;
  bool? unsorted;
  bool? empty;

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
    sorted: json["sorted"] == null ? null : json["sorted"],
    unsorted: json["unsorted"] == null ? null : json["unsorted"],
    empty: json["empty"] == null ? null : json["empty"],
  );

  Map<String, dynamic> toJson() => {
    "sorted": sorted == null ? null : sorted,
    "unsorted": unsorted == null ? null : unsorted,
    "empty": empty == null ? null : empty,
  };
}
