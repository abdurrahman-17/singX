class IndiaBillPaymentFilterResponse {
  Statuses? statuses;

  IndiaBillPaymentFilterResponse({this.statuses});

  IndiaBillPaymentFilterResponse.fromJson(Map<String, dynamic> json) {
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
  String? completed;
  String? underProcessing;
  String? unableToCredit;
  String? pendingPayment;

  Statuses(
      {this.completed,
        this.underProcessing,
        this.unableToCredit,
        this.pendingPayment});

  Statuses.fromJson(Map<String, dynamic> json) {
    completed = json['Completed'];
    underProcessing = json['Under Processing'];
    unableToCredit = json['Unable to Credit'];
    pendingPayment = json['Pending Payment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Completed'] = this.completed;
    data['Under Processing'] = this.underProcessing;
    data['Unable to Credit'] = this.unableToCredit;
    data['Pending Payment'] = this.pendingPayment;
    return data;
  }
}
