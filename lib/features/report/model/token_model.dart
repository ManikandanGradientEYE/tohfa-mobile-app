// To parse this JSON data, do
//
//     final tokenModel = tokenModelFromJson(jsonString);

import 'dart:convert';

List<TokenModel> tokenModelFromJson(String str) =>
    List<TokenModel>.from(json.decode(str).map((x) => TokenModel.fromJson(x)));

String tokenModelToJson(List<TokenModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TokenModel {
  String? tokenNo;
  String? customersId;
  String? sectionCode;
  String? sectionName;
  int? customerSiteId;
  dynamic orderMemoHeaderId;
  dynamic refOrDate;
  String? tokenStatus;
  String? customerName;
  String? customerSiteName;
  String? siteId;
  String? orNo;
  String? orStatus;
  String? siteName;
  int? id;
  String? createdBy;
  String? createdOn;
  dynamic modifiedBy;
  dynamic modifiedOn;
  bool? isActive;
  String? totalQty;
  String? totalAmount;

  TokenModel(
      {this.tokenNo,
      this.customersId,
      this.sectionCode,
      this.sectionName,
      this.customerSiteId,
      this.orderMemoHeaderId,
      this.refOrDate,
      this.tokenStatus,
      this.customerName,
      this.customerSiteName,
      this.siteId,
      this.orNo,
      this.orStatus,
      this.siteName,
      this.id,
      this.createdBy,
      this.createdOn,
      this.modifiedBy,
      this.modifiedOn,
      this.isActive,
      this.totalQty,
      this.totalAmount});

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
      tokenNo: json["tokenNo"],
      customersId: json["customersId"],
      sectionCode: json["section_code"],
      sectionName: json["section_name"],
      customerSiteId: json["customerSiteId"],
      orderMemoHeaderId: json["orderMemoHeaderId"],
      refOrDate: json["refORDate"],
      tokenStatus: json["tokenStatus"],
      customerName: json["customer_name"],
      customerSiteName: json["customer_site_name"],
      siteId: json["siteId"],
      orNo: json["orNo"],
      orStatus: json["orStatus"],
      siteName: json["site_name"],
      id: json["id"],
      createdBy: json["createdBy"],
      createdOn: json["createdOn"],
      modifiedBy: json["modifiedBy"],
      modifiedOn: json["modifiedOn"],
      isActive: json["isActive"],
      totalQty: json['totalQty'],
      totalAmount: json['totalGrossAmt']);

  Map<String, dynamic> toJson() => {
        "tokenNo": tokenNo,
        "customersId": customersId,
        "section_code": sectionCode,
        "section_name": sectionName,
        "customerSiteId": customerSiteId,
        "orderMemoHeaderId": orderMemoHeaderId,
        "refORDate": refOrDate,
        "tokenStatus": tokenStatus,
        "customer_name": customerName,
        "customer_site_name": customerSiteName,
        "siteId": siteId,
        "orNo": orNo,
        "orStatus": orStatus,
        "site_name": siteName,
        "id": id,
        "createdBy": createdBy,
        "createdOn": createdOn,
        "modifiedBy": modifiedBy,
        "modifiedOn": modifiedOn,
        "isActive": isActive,
        "totalQty": totalQty,
        "totalGrossAmt": totalAmount
      };
}
