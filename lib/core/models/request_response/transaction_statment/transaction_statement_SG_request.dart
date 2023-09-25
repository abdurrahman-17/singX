// To parse this JSON data, do
//
//     final downloadStatementSgRequest = downloadStatementSgRequestFromJson(jsonString);

import 'dart:convert';

DownloadStatementSgRequest downloadStatementSgRequestFromJson(String str) => DownloadStatementSgRequest.fromJson(json.decode(str));

String downloadStatementSgRequestToJson(DownloadStatementSgRequest data) => json.encode(data.toJson());

class DownloadStatementSgRequest {
  DownloadStatementSgRequest({
    this.fromDate,
    this.toDate,
  });

  int? fromDate;
  int? toDate;

  factory DownloadStatementSgRequest.fromJson(Map<String, dynamic> json) => DownloadStatementSgRequest(
    fromDate: json["fromDate"] == null ? null : json["fromDate"],
    toDate: json["toDate"] == null ? null : json["toDate"],
  );

  Map<String, dynamic> toJson() => {
    "fromDate": fromDate == null ? null : fromDate,
    "toDate": toDate == null ? null : toDate,
  };
}
