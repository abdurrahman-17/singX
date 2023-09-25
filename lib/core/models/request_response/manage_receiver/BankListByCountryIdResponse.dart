// To parse this JSON data, do
//
//     final bankListByCountryIdResponse = bankListByCountryIdResponseFromJson(jsonString);

import 'dart:convert';

BankListByCountryIdResponse bankListByCountryIdResponseFromJson(String str) => BankListByCountryIdResponse.fromJson(json.decode(str));

String bankListByCountryIdResponseToJson(BankListByCountryIdResponse data) => json.encode(data.toJson());

class BankListByCountryIdResponse {
  BankListByCountryIdResponse({
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

  List<BankContent>? content;
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

  factory BankListByCountryIdResponse.fromJson(Map<String, dynamic> json) => BankListByCountryIdResponse(
    content: json["content"] == null ? null : List<BankContent>.from(json["content"].map((x) => BankContent.fromJson(x))),
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
    "pageable": pageable == null ? null : pageable?.toJson(),
    "totalElements": totalElements == null ? null : totalElements,
    "totalPages": totalPages == null ? null : totalPages,
    "last": last == null ? null : last,
    "size": size == null ? null : size,
    "number": number == null ? null : number,
    "sort": sort == null ? null : sort?.toJson(),
    "numberOfElements": numberOfElements == null ? null : numberOfElements,
    "first": first == null ? null : first,
    "empty": empty == null ? null : empty,
  };
}

class BankContent {
  BankContent({
    this.bankName,
    this.bankId,
  });

  String? bankName;
  String? bankId;

  factory BankContent.fromJson(Map<String, dynamic> json) => BankContent(
    bankName: json["bankName"] == null ? null : json["bankName"],
    bankId: json["bankId"] == null ? null : json["bankId"],
  );

  Map<String, dynamic> toJson() => {
    "bankName": bankName == null ? null : bankName,
    "bankId": bankId == null ? null : bankId,
  };
}

class Pageable {
  Pageable({
    this.sort,
    this.offset,
    this.pageSize,
    this.pageNumber,
    this.paged,
    this.unpaged,
  });

  Sort? sort;
  int? offset;
  int? pageSize;
  int? pageNumber;
  bool? paged;
  bool? unpaged;

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
    sort: json["sort"] == null ? null : Sort.fromJson(json["sort"]),
    offset: json["offset"] == null ? null : json["offset"],
    pageSize: json["pageSize"] == null ? null : json["pageSize"],
    pageNumber: json["pageNumber"] == null ? null : json["pageNumber"],
    paged: json["paged"] == null ? null : json["paged"],
    unpaged: json["unpaged"] == null ? null : json["unpaged"],
  );

  Map<String, dynamic> toJson() => {
    "sort": sort == null ? null : sort?.toJson(),
    "offset": offset == null ? null : offset,
    "pageSize": pageSize == null ? null : pageSize,
    "pageNumber": pageNumber == null ? null : pageNumber,
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
