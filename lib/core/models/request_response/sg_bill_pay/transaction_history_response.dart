// To parse this JSON data, do
//
//     final transactionHistoryResponse = transactionHistoryResponseFromJson(jsonString);

import 'dart:convert';

TransactionHistoryResponse transactionHistoryResponseFromJson(String str) => TransactionHistoryResponse.fromJson(json.decode(str));

String transactionHistoryResponseToJson(TransactionHistoryResponse data) => json.encode(data.toJson());

class TransactionHistoryResponse {
  TransactionHistoryResponse({
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

  factory TransactionHistoryResponse.fromJson(Map<String, dynamic> json) => TransactionHistoryResponse(
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
    this.transactionDate,
    this.countryName,
    this.productName,
    this.operatorName,
    this.totalPayable,
    this.operatorId,
    this.receiveAmount,
    this.status,
    this.userTxnId,
    this.consumerNo,
    this.adParam1,
    this.adParam2,
    this.adParam3,
    this.circleId,
  });

  String? transactionDate;
  String? countryName;
  String? productName;
  String? operatorName;
  String? totalPayable;
  String? operatorId;
  String? receiveAmount;
  String? status;
  String? userTxnId;
  String? consumerNo;
  dynamic adParam1;
  dynamic adParam2;
  dynamic adParam3;
  String? circleId;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    transactionDate: json["transactionDate"] == null ? null : json["transactionDate"],
    countryName: json["countryName"] == null ? null : json["countryName"],
    productName: json["productName"] == null ? null : json["productName"],
    operatorName: json["operatorName"] == null ? null : json["operatorName"],
    totalPayable: json["totalPayable"] == null ? null : json["totalPayable"],
    operatorId: json["operatorId"] == null ? null : json["operatorId"],
    receiveAmount: json["receiveAmount"] == null ? null : json["receiveAmount"],
    status: json["status"] == null ? null : json["status"],
    userTxnId: json["userTxnId"] == null ? null : json["userTxnId"],
    consumerNo: json["consumerNo"] == null ? null : json["consumerNo"],
    adParam1: json["adParam1"],
    adParam2: json["adParam2"],
    adParam3: json["adParam3"],
    circleId: json["circleId"] == null ? null : json["circleId"],
  );

  Map<String, dynamic> toJson() => {
    "transactionDate": transactionDate == null ? null : transactionDate,
    "countryName": countryName == null ? null : countryName,
    "productName": productName == null ? null : productName,
    "operatorName": operatorName == null ? null : operatorName,
    "totalPayable": totalPayable == null ? null : totalPayable,
    "operatorId": operatorId == null ? null : operatorId,
    "receiveAmount": receiveAmount == null ? null : receiveAmount,
    "status": status == null ? null : status,
    "userTxnId": userTxnId == null ? null : userTxnId,
    "consumerNo": consumerNo == null ? null : consumerNo,
    "adParam1": adParam1,
    "adParam2": adParam2,
    "adParam3": adParam3,
    "circleId": circleId == null ? null : circleId,
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
    this.empty,
    this.sorted,
    this.unsorted,
  });

  bool? empty;
  bool? sorted;
  bool? unsorted;

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
    empty: json["empty"] == null ? null : json["empty"],
    sorted: json["sorted"] == null ? null : json["sorted"],
    unsorted: json["unsorted"] == null ? null : json["unsorted"],
  );

  Map<String, dynamic> toJson() => {
    "empty": empty == null ? null : empty,
    "sorted": sorted == null ? null : sorted,
    "unsorted": unsorted == null ? null : unsorted,
  };
}
