// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

List<SignUpResponseModel> signUpResponseModelFromJson(String str) =>
    List<SignUpResponseModel>.from(
        json.decode(str).map((x) => SignUpResponseModel.fromJson(x)));

String signUpResponseModelToJson(List<SignUpResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SignUpResponseModel {
  dynamic membershipStatus;
  dynamic id;
  dynamic customerName;
  dynamic customerAlias;
  dynamic agent;
  dynamic password;
  dynamic customerShortCode;
  dynamic agentPercentage;
  dynamic customerClassId;
  dynamic perTransOrderLimit;
  dynamic maxCreditLimit;
  dynamic maxCreditDays;
  dynamic transporterId;
  dynamic groupTierId;
  dynamic groupPaymentCreditId;
  dynamic pricelistId;
  dynamic companyType;
  dynamic industryType;
  dynamic productType;
  dynamic brandName;
  dynamic directorOwnerName;
  dynamic contactPerson;
  dynamic contactNo;
  dynamic customerAddress1;
  dynamic customerAddress2;
  dynamic customerLandmark;
  dynamic customerArea;
  dynamic customerDistrict;
  dynamic customerIsdCode;
  dynamic customerStdCode;
  dynamic customerPhone1;
  dynamic customerPhone2;
  dynamic customerPhone3;
  dynamic customerDefaultWhatsapp;
  dynamic customerWhatsappNo1;
  dynamic customerWhatsappNo2;
  dynamic customerWhatsappNo3;
  dynamic customerEmail;
  dynamic customerAlternateEmail;
  dynamic customerWebsite;
  dynamic customerGstNo;
  dynamic customerPanCard;
  dynamic customerReference;
  dynamic customerNote;
  dynamic customerGstDate;
  dynamic gstStateId;
  dynamic taxgroupId;
  dynamic salestermId;
  dynamic customerCity;
  dynamic customerState;
  dynamic customerCountry;
  dynamic customerPincode;
  dynamic createdOn;
  dynamic totalPurchaseValue;
  dynamic tierName;
  bool? isActive;

  SignUpResponseModel({
    this.membershipStatus,
    this.id,
    this.customerName,
    this.customerAlias,
    this.tierName,
    this.agent,
    this.totalPurchaseValue,
    this.password,
    this.customerShortCode,
    this.agentPercentage,
    this.customerClassId,
    this.perTransOrderLimit,
    this.maxCreditLimit,
    this.createdOn,
    this.maxCreditDays,
    this.transporterId,
    this.groupTierId,
    this.groupPaymentCreditId,
    this.pricelistId,
    this.companyType,
    this.industryType,
    this.productType,
    this.brandName,
    this.directorOwnerName,
    this.contactPerson,
    this.contactNo,
    this.customerAddress1,
    this.customerAddress2,
    this.customerLandmark,
    this.customerArea,
    this.customerDistrict,
    this.customerIsdCode,
    this.customerStdCode,
    this.customerPhone1,
    this.customerPhone2,
    this.customerPhone3,
    this.customerDefaultWhatsapp,
    this.customerWhatsappNo1,
    this.customerWhatsappNo2,
    this.customerWhatsappNo3,
    this.customerEmail,
    this.customerAlternateEmail,
    this.customerWebsite,
    this.customerGstNo,
    this.customerPanCard,
    this.customerReference,
    this.customerNote,
    this.customerGstDate,
    this.gstStateId,
    this.taxgroupId,
    this.salestermId,
    this.customerCity,
    this.customerState,
    this.customerCountry,
    this.customerPincode,
    this.isActive,
  });

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) =>
      SignUpResponseModel(
        membershipStatus: json["membershipStatus"],
        id: json["id"],
        customerName: json["customer_name"],
        customerAlias: json["customer_alias"],
        agent: json["agent"],
        password: json["password"],
        customerShortCode: json["customer_short_code"],
        agentPercentage: json["agent_percentage"],
        customerClassId: json["customerClassId"],
        perTransOrderLimit: json["per_trans_order_limit"],
        maxCreditLimit: json["max_credit_limit"],
        maxCreditDays: json["max_credit_days"],
        transporterId: json["transporterId"],
        groupTierId: json["groupTierId"],
        groupPaymentCreditId: json["groupPaymentCreditId"],
        pricelistId: json["pricelistId"],
        companyType: json["company_type"],
        industryType: json["industry_type"],
        productType: json["product_type"],
        brandName: json["brand_name"],
        directorOwnerName: json["director_owner_name"],
        contactPerson: json["contact_person"],
        contactNo: json["contact_no"],
        customerAddress1: json["customer_address1"],
        customerAddress2: json["customer_address2"],
        customerLandmark: json["customer_landmark"],
        customerArea: json["customer_area"],
        customerDistrict: json["customer_district"],
        customerIsdCode: json["customer_isd_code"],
        customerStdCode: json["customer_std_code"],
        customerPhone1: json["customer_phone1"],
        customerPhone2: json["customer_phone2"],
        customerPhone3: json["customer_phone3"],
        customerDefaultWhatsapp: json["customer_default_whatsapp"],
        customerWhatsappNo1: json["customer_whatsapp_no1"],
        customerWhatsappNo2: json["customer_whatsapp_no2"],
        customerWhatsappNo3: json["customer_whatsapp_no3"],
        createdOn: json["createdOn"],
        customerEmail: json["customer_email"],
        customerAlternateEmail: json["customer_alternate_email"],
        customerWebsite: json["customer_website"],
        customerGstNo: json["customer_gst_no"],
        customerPanCard: json["customer_pan_card"],
        customerReference: json["customer_reference"],
        customerNote: json["customer_note"],
        customerGstDate: json["customer_gst_date"],
        gstStateId: json["gstStateId"],
        taxgroupId: json["taxgroupId"],
        salestermId: json["salestermId"],
        customerCity: json["customer_city"],
        customerState: json["customer_state"],
        customerCountry: json["customer_country"],
        customerPincode: json["customer_pincode"],
        isActive: json["isActive"],
        tierName: json["tier_name"],
        totalPurchaseValue: json["totalPurchaseValue"],
      );

  Map<String, dynamic> toJson() => {
        "membershipStatus": membershipStatus,
        "id": id,
        "customer_name": customerName,
        "customer_alias": customerAlias,
        "agent": agent,
        "password": password,
        "tier_name": tierName,
        "customer_short_code": customerShortCode,
        "agent_percentage": agentPercentage,
        "customerClassId": customerClassId,
        "per_trans_order_limit": perTransOrderLimit,
        "max_credit_limit": maxCreditLimit,
        "max_credit_days": maxCreditDays,
        "transporterId": transporterId,
        "groupTierId": groupTierId,
        "groupPaymentCreditId": groupPaymentCreditId,
        "pricelistId": pricelistId,
        "company_type": companyType,
        "industry_type": industryType,
        "product_type": productType,
        "brand_name": brandName,
        "director_owner_name": directorOwnerName,
        "contact_person": contactPerson,
        "contact_no": contactNo,
        "customer_address1": customerAddress1,
        "customer_address2": customerAddress2,
        "customer_landmark": customerLandmark,
        "customer_area": customerArea,
        "customer_district": customerDistrict,
        "customer_isd_code": customerIsdCode,
        "customer_std_code": customerStdCode,
        "customer_phone1": customerPhone1,
        "customer_phone2": customerPhone2,
        "customer_phone3": customerPhone3,
        "customer_default_whatsapp": customerDefaultWhatsapp,
        "customer_whatsapp_no1": customerWhatsappNo1,
        "customer_whatsapp_no2": customerWhatsappNo2,
        "customer_whatsapp_no3": customerWhatsappNo3,
        "createdOn": createdOn,
        "totalPurchaseValue": totalPurchaseValue,
        "customer_email": customerEmail,
        "customer_alternate_email": customerAlternateEmail,
        "customer_website": customerWebsite,
        "customer_gst_no": customerGstNo,
        "customer_pan_card": customerPanCard,
        "customer_reference": customerReference,
        "customer_note": customerNote,
        "customer_gst_date": customerGstDate,
        "gstStateId": gstStateId,
        "taxgroupId": taxgroupId,
        "salestermId": salestermId,
        "customer_city": customerCity,
        "customer_state": customerState,
        "customer_country": customerCountry,
        "customer_pincode": customerPincode,
        "isActive": isActive,
      };
}
