class SGWalletFilterResponse {
  Statuses? statuses;

  SGWalletFilterResponse({this.statuses});

  SGWalletFilterResponse.fromJson(Map<String, dynamic> json) {
    statuses = json['statuses'] != null
        ? new Statuses.fromJson(json['statuses'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.statuses != null) {
      data['statuses'] = this.statuses!.toJson();
    }
    return data;
  }
}

class Statuses {
  String? initiated;
  String? failed;
  String? processing;
  String? expired;
  String? refunded;
  String? completed;

  Statuses(
      {this.initiated,
        this.failed,
        this.processing,
        this.expired,
        this.refunded,
        this.completed});

  Statuses.fromJson(Map<String, dynamic> json) {
    initiated = json['Initiated'];
    failed = json['Failed'];
    processing = json['Processing'];
    expired = json['Expired'];
    refunded = json['Refunded'];
    completed = json['Completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Initiated'] = this.initiated;
    data['Failed'] = this.failed;
    data['Processing'] = this.processing;
    data['Expired'] = this.expired;
    data['Refunded'] = this.refunded;
    data['Completed'] = this.completed;
    return data;
  }
}
