class TransactionResponse {
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

  TransactionResponse(
      {this.content,
        this.pageable,
        this.totalElements,
        this.totalPages,
        this.last,
        this.size,
        this.number,
        this.sort,
        this.numberOfElements,
        this.first,
        this.empty});

  TransactionResponse.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content =  <Content>[];
      json['content'].forEach((v) {
        content!.add(new Content.fromJson(v));
      });
    }
    pageable = json['pageable'] != null
        ? new Pageable.fromJson(json['pageable'])
        : null;
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
    last = json['last'];
    size = json['size'];
    number = json['number'];
    sort = json['sort'] != null ? new Sort.fromJson(json['sort']) : null;
    numberOfElements = json['numberOfElements'];
    first = json['first'];
    empty = json['empty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    if (this.pageable != null) {
      data['pageable'] = this.pageable!.toJson();
    }
    data['totalElements'] = this.totalElements;
    data['totalPages'] = this.totalPages;
    data['last'] = this.last;
    data['size'] = this.size;
    data['number'] = this.number;
    if (this.sort != null) {
      data['sort'] = this.sort!.toJson();
    }
    data['numberOfElements'] = this.numberOfElements;
    data['first'] = this.first;
    data['empty'] = this.empty;
    return data;
  }
}

class Content {
  String? id;
  String? date;
  String? receiverId;
  String? receiverName;
  String? sendAmount;
  String? receiveAmount;
  String? exchangeRate;
  String? totalPayable;
  String? singxFee;
  String? status;
  String? txnId;

  Content(
      {this.id,
        this.date,
        this.receiverId,
        this.receiverName,
        this.sendAmount,
        this.receiveAmount,
        this.exchangeRate,
        this.totalPayable,
        this.singxFee,
        this.status,
        this.txnId});

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    receiverId = json['receiverId'];
    receiverName = json['receiverName'];
    sendAmount = json['sendAmount'];
    receiveAmount = json['receiveAmount'];
    exchangeRate = json['exchangeRate'];
    totalPayable = json['totalPayable'];
    singxFee = json['singxFee'];
    status = json['status'];
    txnId = json['txnId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['receiverId'] = this.receiverId;
    data['receiverName'] = this.receiverName;
    data['sendAmount'] = this.sendAmount;
    data['receiveAmount'] = this.receiveAmount;
    data['exchangeRate'] = this.exchangeRate;
    data['totalPayable'] = this.totalPayable;
    data['singxFee'] = this.singxFee;
    data['status'] = this.status;
    data['txnId'] = this.txnId;
    return data;
  }
}

class Pageable {
  Sort? sort;
  int? offset;
  int? pageNumber;
  int? pageSize;
  bool? paged;
  bool? unpaged;

  Pageable(
      {this.sort,
        this.offset,
        this.pageNumber,
        this.pageSize,
        this.paged,
        this.unpaged});

  Pageable.fromJson(Map<String, dynamic> json) {
    sort = json['sort'] != null ? new Sort.fromJson(json['sort']) : null;
    offset = json['offset'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    paged = json['paged'];
    unpaged = json['unpaged'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sort != null) {
      data['sort'] = this.sort!.toJson();
    }
    data['offset'] = this.offset;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['paged'] = this.paged;
    data['unpaged'] = this.unpaged;
    return data;
  }
}

class Sort {
  bool? sorted;
  bool? unsorted;
  bool? empty;

  Sort({this.sorted, this.unsorted, this.empty});

  Sort.fromJson(Map<String, dynamic> json) {
    sorted = json['sorted'];
    unsorted = json['unsorted'];
    empty = json['empty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sorted'] = this.sorted;
    data['unsorted'] = this.unsorted;
    data['empty'] = this.empty;
    return data;
  }
}
