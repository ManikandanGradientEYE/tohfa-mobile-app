// To parse this JSON data, do
//
//     final customerSiteIdModel = customerSiteIdModelFromJson(jsonString);

import 'dart:convert';

UserOtherDataModel userOtherDataModelFromJson(String str) =>
    UserOtherDataModel.fromJson(json.decode(str));

String userOtherDataModelToJson(UserOtherDataModel data) => json.encode(data.toJson());

class UserOtherDataModel {
  dynamic createdOn;
  dynamic totalPurchaseValue;
  dynamic tierName;

  UserOtherDataModel({
    this.createdOn,
    this.totalPurchaseValue,
    this.tierName,
  });

  UserOtherDataModel copyWith({
    dynamic createdOn,
    dynamic totalPurchaseValue,
    dynamic tierName,
  }) =>
      UserOtherDataModel(
        createdOn: createdOn ?? this.createdOn,
        totalPurchaseValue: totalPurchaseValue ?? this.totalPurchaseValue,
        tierName: tierName ?? this.tierName,
      );

  factory UserOtherDataModel.fromJson(Map<String, dynamic> json) => UserOtherDataModel(
        createdOn: json["createdOn"],
        totalPurchaseValue: json["totalPurchaseValue"],
        tierName: json["tier_name"],
      );

  Map<String, dynamic> toJson() => {
        "createdOn": createdOn,
        "totalPurchaseValue": totalPurchaseValue,
        "tier_name": tierName,
      };
}

List<CustomerSiteIdModel> customerSiteIdModelFromJson(String str) =>
    List<CustomerSiteIdModel>.from(json.decode(str).map((x) => CustomerSiteIdModel.fromJson(x)));

String customerSiteIdModelToJson(List<CustomerSiteIdModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerSiteIdModel {
  dynamic customerSiteName;
  dynamic customerSiteShortName;
  dynamic customerName;
  dynamic classType;
  dynamic customerId;
  dynamic priceListName;
  dynamic agentPercentage;
  dynamic tradegroupId;
  dynamic salestermId;
  dynamic transitDays;
  dynamic transporterId;
  dynamic billContactPerson;
  dynamic billContactNo;
  dynamic customerBillAddress1;
  dynamic customerBillAddress2;
  dynamic customerBillLandmark;
  dynamic customerBillArea;
  dynamic customerBillDistrict;
  dynamic customerBillCity;
  dynamic customerBillPincode;
  dynamic customerBillState;
  dynamic customerBillCountry;
  dynamic customerBillIsdCode;
  dynamic customerBillStdCode;
  dynamic customerBillPhone1;
  dynamic customerBillPhone2;
  dynamic customerBillPhone3;
  dynamic customerBillDefaultWhatsapp;
  dynamic customerBillWhatsappNo1;
  dynamic customerBillWhatsappNo2;
  dynamic customerBillWhatsappNo3;
  dynamic customerBillEmail;
  dynamic customerBillAlternateEmail;
  dynamic customerBillWebsite;
  dynamic customerBillGstin;
  dynamic customerBillGstinDate;
  dynamic customerBillGstState;
  dynamic billPanCard;
  dynamic shipContactPerson;
  dynamic shipContactNo;
  dynamic customerShipAddress1;
  dynamic customerShipAddress2;
  dynamic customerShipLandmark;
  dynamic customerShipArea;
  dynamic customerShipDistrict;
  dynamic customerShipPincode;
  dynamic customerShipCity;
  dynamic customerShipState;
  dynamic customerShipCountry;
  dynamic customerShipIsdCode;
  dynamic customerShipStdCode;
  dynamic customerShipPhone1;
  dynamic customerShipPhone2;
  dynamic customerShipPhone3;
  dynamic customerShipDefaultWhatsapp;
  dynamic customerShipWhatsappNo1;
  dynamic customerShipWhatsappNo2;
  dynamic customerShipWhatsappNo3;
  dynamic customerShipEmail;
  dynamic customerShipAlternateEmail;
  dynamic customerShipWebsite;
  dynamic customerShipGstin;
  dynamic customerShipGstinDate;
  dynamic customerShipGstState;
  dynamic shipPanCard;
  dynamic agent;
  dynamic reference;
  dynamic note;
  dynamic tradeGroupName;
  dynamic termName;
  dynamic customersiteLoginNo;
  dynamic customersiteShipWhatsappNo;
  dynamic customersiteBillWhatsappNo;
  dynamic membershipCode;
  dynamic customerBillCityName;
  dynamic customerBillStateName;
  dynamic customerBillCountryName;
  dynamic customerShipCityName;
  String? customerShipStateName;
  dynamic customerShipCountryName;
  dynamic customerBillGstStateName;
  dynamic customerShipGstStateName;
  dynamic agentName;
  dynamic transactionTerm;
  dynamic priceList;
  dynamic transporterName;
  dynamic notificationCount;
  String? ogContactNo;
  String? contactPerson;
  String? customerIsdCode;
  String? contactNo;
  String? customerPhone1;
  String? customerEmail;
  dynamic id;
  dynamic createdBy;
  dynamic createdOn;
  dynamic modifiedBy;
  dynamic modifiedOn;
  String? isActive;

  CustomerSiteIdModel({
    this.customerSiteName,
    this.customerSiteShortName,
    this.customerName,
    this.classType,
    this.customerId,
    this.priceListName,
    this.agentPercentage,
    this.tradegroupId,
    this.salestermId,
    this.transitDays,
    this.transporterId,
    this.billContactPerson,
    this.billContactNo,
    this.customerBillAddress1,
    this.customerBillAddress2,
    this.customerBillLandmark,
    this.notificationCount,
    this.ogContactNo,
    this.customerEmail,
    this.customerPhone1,
    this.customerIsdCode,
    this.contactNo,
    this.customerBillArea,
    this.customerBillDistrict,
    this.customerBillCity,
    this.customerBillPincode,
    this.customerBillState,
    this.customerBillCountry,
    this.customerBillIsdCode,
    this.customerBillStdCode,
    this.customerBillPhone1,
    this.customerBillPhone2,
    this.customerBillPhone3,
    this.customerBillDefaultWhatsapp,
    this.customerBillWhatsappNo1,
    this.customerBillWhatsappNo2,
    this.customerBillWhatsappNo3,
    this.customerBillEmail,
    this.customerBillAlternateEmail,
    this.customerBillWebsite,
    this.customerBillGstin,
    this.customerBillGstinDate,
    this.customerBillGstState,
    this.billPanCard,
    this.shipContactPerson,
    this.shipContactNo,
    this.customerShipAddress1,
    this.customerShipAddress2,
    this.customerShipLandmark,
    this.customerShipArea,
    this.customerShipDistrict,
    this.customerShipPincode,
    this.customerShipCity,
    this.customerShipState,
    this.customerShipCountry,
    this.customerShipIsdCode,
    this.customerShipStdCode,
    this.customerShipPhone1,
    this.customerShipPhone2,
    this.customerShipPhone3,
    this.customerShipDefaultWhatsapp,
    this.customerShipWhatsappNo1,
    this.customerShipWhatsappNo2,
    this.customerShipWhatsappNo3,
    this.customerShipEmail,
    this.customerShipAlternateEmail,
    this.customerShipWebsite,
    this.customerShipGstin,
    this.customerShipGstinDate,
    this.customerShipGstState,
    this.shipPanCard,
    this.agent,
    this.reference,
    this.note,
    this.tradeGroupName,
    this.termName,
    this.customersiteLoginNo,
    this.customersiteShipWhatsappNo,
    this.customersiteBillWhatsappNo,
    this.membershipCode,
    this.id,
    this.createdBy,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
    this.isActive,
    //
    this.agentName,
    this.customerBillCityName,
    this.customerBillCountryName,
    this.customerBillGstStateName,
    this.customerBillStateName,
    this.customerShipCityName,
    this.customerShipCountryName,
    this.customerShipGstStateName,
    this.customerShipStateName,
    this.priceList,
    this.contactPerson,
    this.transactionTerm,
    this.transporterName,
  });
  CustomerSiteIdModel copyWith({
    dynamic customerSiteName,
    dynamic customerSiteShortName,
    dynamic customerName,
    dynamic classType,
    dynamic customerId,
    dynamic priceListName,
    dynamic agentPercentage,
    dynamic tradegroupId,
    dynamic salestermId,
    dynamic transitDays,
    dynamic transporterId,
    dynamic billContactPerson,
    dynamic billContactNo,
    dynamic customerBillAddress1,
    dynamic customerBillAddress2,
    dynamic customerBillLandmark,
    dynamic customerBillArea,
    dynamic customerBillDistrict,
    dynamic customerBillCity,
    dynamic customerBillPincode,
    dynamic customerBillState,
    dynamic customerBillCountry,
    dynamic customerBillIsdCode,
    dynamic customerBillStdCode,
    dynamic customerBillPhone1,
    dynamic customerBillPhone2,
    dynamic customerBillPhone3,
    dynamic customerBillDefaultWhatsapp,
    dynamic customerBillWhatsappNo1,
    dynamic customerBillWhatsappNo2,
    dynamic customerBillWhatsappNo3,
    dynamic customerBillEmail,
    dynamic customerBillAlternateEmail,
    dynamic customerBillWebsite,
    dynamic customerBillGstin,
    dynamic customerBillGstinDate,
    dynamic customerBillGstState,
    dynamic billPanCard,
    dynamic shipContactPerson,
    dynamic shipContactNo,
    dynamic customerShipAddress1,
    dynamic customerShipAddress2,
    dynamic customerShipLandmark,
    dynamic customerShipArea,
    dynamic customerShipDistrict,
    dynamic customerShipPincode,
    dynamic customerShipCity,
    dynamic customerShipState,
    dynamic customerShipCountry,
    dynamic customerShipIsdCode,
    dynamic customerShipStdCode,
    dynamic customerShipPhone1,
    dynamic customerShipPhone2,
    dynamic customerShipPhone3,
    dynamic customerShipDefaultWhatsapp,
    dynamic customerShipWhatsappNo1,
    dynamic customerShipWhatsappNo2,
    dynamic customerShipWhatsappNo3,
    dynamic customerShipEmail,
    dynamic customerShipAlternateEmail,
    dynamic customerShipWebsite,
    dynamic customerShipGstin,
    dynamic customerShipGstinDate,
    dynamic customerShipGstState,
    dynamic shipPanCard,
    dynamic agent,
    dynamic reference,
    dynamic note,
    dynamic tradeGroupName,
    dynamic termName,
    dynamic customersiteLoginNo,
    dynamic customersiteShipWhatsappNo,
    dynamic customersiteBillWhatsappNo,
    dynamic membershipCode,
    dynamic customerBillCityName,
    dynamic customerBillStateName,
    dynamic customerBillCountryName,
    dynamic customerShipCityName,
    String? customerShipStateName,
    dynamic customerShipCountryName,
    dynamic customerBillGstStateName,
    dynamic customerShipGstStateName,
    dynamic agentName,
    dynamic transactionTerm,
    dynamic priceList,
    dynamic transporterName,
    dynamic notificationCount,
    String? ogContactNo,
    String? customerPhone1,
    String? customerIsdCodectNo,
    String? contactNo,
    String? customerEmail,
    dynamic id,
    dynamic createdBy,
    dynamic createdOn,
    dynamic modifiedBy,
    dynamic modifiedOn,
    String? isActive,
  }) =>
      CustomerSiteIdModel(
          customerSiteName: customerSiteName ?? this.customerSiteName,
          customerSiteShortName: customerSiteShortName ?? customerSiteShortName,
          customerName: customerName ?? customerName,
          classType: classType ?? classType,
          customerId: customerId ?? customerId,
          priceListName: priceListName ?? priceListName,
          agentPercentage: agentPercentage ?? agentPercentage,
          tradegroupId: tradegroupId ?? tradegroupId,
          salestermId: salestermId ?? salestermId,
          transitDays: transitDays ?? transitDays,
          transporterId: transporterId ?? transporterId,
          billContactPerson: billContactPerson ?? billContactPerson,
          notificationCount: notificationCount ?? notificationCount,
          ogContactNo: ogContactNo ?? this.ogContactNo,
          customerEmail: customerEmail ?? this.customerEmail,
          customerPhone1: customerPhone1 ?? customerPhone1,
          contactPerson: contactPerson ?? contactPerson,
          customerIsdCode: customerIsdCode ?? customerIsdCode,
          contactNo: contactNo ?? contactNo,
          billContactNo: billContactNo ?? billContactNo,
          customerBillAddress1: customerBillAddress1 ?? customerBillAddress1,
          customerBillAddress2: customerBillAddress2 ?? customerBillAddress2,
          customerBillLandmark: customerBillLandmark ?? customerBillLandmark,
          customerBillArea: customerBillArea ?? customerBillArea,
          customerBillDistrict: customerBillDistrict ?? customerBillDistrict,
          customerBillCity: customerBillCity ?? customerBillCity,
          customerBillPincode: customerBillPincode ?? customerBillPincode,
          customerBillState: customerBillState ?? customerBillState,
          customerBillCountry: customerBillCountry ?? customerBillCountry,
          customerBillIsdCode: customerBillIsdCode ?? customerBillIsdCode,
          customerBillStdCode: customerBillStdCode ?? customerBillStdCode,
          customerBillPhone1: customerBillPhone1 ?? customerBillPhone1,
          customerBillPhone2: customerBillPhone2 ?? customerBillPhone2,
          customerBillPhone3: customerBillPhone3 ?? customerBillPhone3,
          customerBillDefaultWhatsapp: customerBillDefaultWhatsapp ?? customerBillDefaultWhatsapp,
          customerBillWhatsappNo1: customerBillWhatsappNo1 ?? customerBillWhatsappNo1,
          customerBillWhatsappNo2: customerBillWhatsappNo2 ?? customerBillWhatsappNo2,
          customerBillWhatsappNo3: customerBillWhatsappNo3 ?? customerBillWhatsappNo3,
          customerBillEmail: customerBillEmail ?? customerBillEmail,
          customerBillAlternateEmail: customerBillAlternateEmail ?? customerBillAlternateEmail,
          customerBillWebsite: customerBillWebsite ?? customerBillWebsite,
          customerBillGstin: customerBillGstin ?? customerBillGstin,
          customerBillGstinDate: customerBillGstinDate ?? customerBillGstinDate,
          customerBillGstState: customerBillGstState ?? customerBillGstState,
          billPanCard: billPanCard ?? billPanCard,
          shipContactPerson: shipContactPerson ?? shipContactPerson,
          shipContactNo: shipContactNo ?? shipContactNo,
          customerShipAddress1: customerShipAddress1 ?? customerShipAddress1,
          customerShipAddress2: customerShipAddress2 ?? customerShipAddress2,
          customerShipLandmark: customerShipLandmark ?? customerShipLandmark,
          customerShipArea: customerShipArea ?? customerShipArea,
          customerShipDistrict: customerShipDistrict ?? customerShipDistrict,
          customerShipPincode: customerShipPincode ?? customerShipPincode,
          customerShipCity: customerShipCity ?? customerShipCity,
          customerShipState: customerShipState ?? customerShipState,
          customerShipCountry: customerShipCountry ?? customerShipCountry,
          customerShipIsdCode: customerShipIsdCode ?? customerShipIsdCode,
          customerShipStdCode: customerShipStdCode ?? customerShipStdCode,
          customerShipPhone1: customerShipPhone1 ?? customerShipPhone1,
          customerShipPhone2: customerShipPhone2 ?? customerShipPhone2,
          customerShipPhone3: customerShipPhone3 ?? customerShipPhone3,
          customerShipDefaultWhatsapp: customerShipDefaultWhatsapp ?? customerShipDefaultWhatsapp,
          customerShipWhatsappNo1: customerShipWhatsappNo1 ?? customerShipWhatsappNo1,
          customerShipWhatsappNo2: customerShipWhatsappNo2 ?? customerShipWhatsappNo2,
          customerShipWhatsappNo3: customerShipWhatsappNo3 ?? customerShipWhatsappNo3,
          customerShipEmail: customerShipEmail ?? customerShipEmail,
          customerShipAlternateEmail: customerShipAlternateEmail ?? customerShipAlternateEmail,
          customerShipWebsite: customerShipWebsite ?? customerShipWebsite,
          customerShipGstin: customerShipGstin ?? customerShipGstin,
          customerShipGstinDate: customerShipGstinDate ?? customerShipGstinDate,
          customerShipGstState: customerShipGstState ?? customerShipGstState,
          shipPanCard: shipPanCard ?? shipPanCard,
          agent: agent ?? agent,
          reference: reference ?? reference,
          note: note ?? note,
          tradeGroupName: tradeGroupName ?? tradeGroupName,
          termName: termName ?? termName,
          customersiteLoginNo: customersiteLoginNo ?? customersiteLoginNo,
          customersiteShipWhatsappNo: customersiteShipWhatsappNo ?? customersiteShipWhatsappNo,
          customersiteBillWhatsappNo: customersiteBillWhatsappNo ?? customersiteBillWhatsappNo,
          membershipCode: membershipCode ?? membershipCode,
          id: id ?? id,
          createdBy: createdBy ?? createdBy,
          createdOn: createdOn ?? createdOn,
          modifiedBy: modifiedBy ?? modifiedBy,
          modifiedOn: modifiedOn ?? modifiedOn,
          isActive: isActive ?? isActive,
          agentName: agentName ?? agentName,
          customerBillCityName: customerBillCityName ?? customerBillCityName,
          customerBillCountryName: customerBillCountryName ?? customerBillCountryName,
          // customerShipStateName: customerShipStateName ?? customerShipStateName
          customerShipStateName: customerShipStateName ?? this.customerShipStateName);

  factory CustomerSiteIdModel.fromJson(Map<String, dynamic> json) => CustomerSiteIdModel(
        customerSiteName: json["customer_site_name"],
        customerSiteShortName: json["customer_site_short_name"],
        customerName: json["customer_name"],
        classType: json["classType"],
        customerId: json["customerId"] != null ? json["customerId"].toString() : "",
        priceListName: json["price_list_name"],
        agentPercentage: json["agent_percentage"],
        tradegroupId: json["tradegroupId"],
        salestermId: json["salestermId"],
        transitDays: json["transitDays"],
        transporterId: json["transporterId"],
        billContactPerson: json["bill_contact_person"],
        billContactNo: json["bill_contact_no"],
        customerBillAddress1: json["customer_bill_address1"] ?? "",
        customerBillAddress2: json["customer_bill_address2"] ?? "",
        customerBillLandmark: json["customer_bill_landmark"] ?? "",
        customerBillArea: json["customer_bill_area"],
        customerBillDistrict: json["customer_bill_district"],
        customerBillCity: json["customer_bill_city"],
        customerBillPincode: json["customer_bill_pincode"],
        customerBillState: json["customer_bill_state"],
        customerBillCountry: json["customer_bill_country"],
        customerBillIsdCode: json["customer_bill_isd_code"],
        customerBillStdCode: json["customer_bill_std_code"],
        customerBillPhone1: json["customer_bill_phone1"],
        customerBillPhone2: json["customer_bill_phone2"],
        customerBillPhone3: json["customer_bill_phone3"],
        customerBillDefaultWhatsapp: json["customer_bill_default_whatsapp"],
        customerBillWhatsappNo1: json["customer_bill_whatsapp_no1"],
        customerBillWhatsappNo2: json["customer_bill_whatsapp_no2"],
        customerBillWhatsappNo3: json["customer_bill_whatsapp_no3"],
        customerBillEmail: json["customer_bill_email"],
        customerBillAlternateEmail: json["customer_bill_alternate_email"],
        customerBillWebsite: json["customer_bill_website"],
        customerBillGstin: json["customer_bill_gstin"],
        customerBillGstinDate: json["customer_bill_gstin_date"],
        customerBillGstState: json["customer_bill_gst_state"],
        billPanCard: json["bill_pan_card"],
        shipContactPerson: json["ship_contact_person"],
        shipContactNo: json["ship_contact_no"],
        notificationCount: (json["notification_count"] ?? 0).toString(),
        ogContactNo: json["og_contact_no"] ?? "",
        customerEmail: json["customer_email"] ?? "",
        customerPhone1: json["customer_phone1"] ?? "",
        contactPerson: json["contact_person"] ?? "",
        customerIsdCode: json["customer_isd_code"] ?? "",
        contactNo: json["contact_no"] ?? "",
        customerShipAddress1: json["customer_ship_address1"] ?? "",
        customerShipAddress2: json["customer_ship_address2"] ?? "",
        customerShipLandmark: json["customer_ship_landmark"],
        customerShipArea: json["customer_ship_area"],
        customerShipDistrict: json["customer_ship_district"],
        customerShipPincode: json["customer_ship_pincode"],
        customerShipCity: json["customer_ship_city"],
        customerShipState: json["customer_ship_state"],
        customerShipCountry: json["customer_ship_country"],
        customerShipIsdCode: json["customer_ship_isd_code"],
        customerShipStdCode: json["customer_ship_std_code"],
        customerShipPhone1: json["customer_ship_phone1"],
        customerShipPhone2: json["customer_ship_phone2"],
        customerShipPhone3: json["customer_ship_phone3"],
        customerShipDefaultWhatsapp: json["customer_ship_default_whatsapp"],
        customerShipWhatsappNo1: json["customer_ship_whatsapp_no1"],
        customerShipWhatsappNo2: json["customer_ship_whatsapp_no2"],
        customerShipWhatsappNo3: json["customer_ship_whatsapp_no3"],
        customerShipEmail: json["customer_ship_email"],
        customerShipAlternateEmail: json["customer_ship_alternate_email"],
        customerShipWebsite: json["customer_ship_website"],
        customerShipGstin: json["customer_ship_gstin"],
        customerShipGstinDate: json["customer_ship_gstin_date"],
        customerShipGstState: json["customer_ship_gst_state"],
        shipPanCard: json["ship_pan_card"],
        agent: json["agent"],
        reference: json["reference"],
        note: json["note"],
        tradeGroupName: json["trade_group_name"],
        termName: json["term_name"],
        customersiteLoginNo: json["customersite_login_no"],
        customersiteShipWhatsappNo: json["customersite_ship_whatsapp_no"],
        customersiteBillWhatsappNo: json["customersite_bill_whatsapp_no"],
        membershipCode: json["membershipCode"],
        id: json["id"] != null ? json["id"].toString() : "",
        createdBy: json["createdBy"],
        createdOn: json["createdOn"],
        modifiedBy: json["modifiedBy"],
        modifiedOn: json["modifiedOn"],
        isActive: json["isActive"].toString(),
        agentName: json["agent_name"],
        customerBillCityName: json["customer_bill_city_name"],
        customerBillCountryName: json["customer_bill_country_name"],
        customerBillStateName: json["customer_bill_state_name"],
        customerBillGstStateName: json["customer_bill_gst_state_name"],
        customerShipGstStateName: json["customer_ship_gst_state_name"],
        customerShipCityName: json["customer_ship_city_name"],
        customerShipCountryName: json["customer_ship_country_name"],
        customerShipStateName: json["customer_ship_state_name"] ?? '',
        priceList: json["price_list"],
        transactionTerm: json["transaction_term"],
        transporterName: json["transporter_name"],
      );

  Map<String, dynamic> toJson() => {
        "customer_site_name": customerSiteName?.toString() ?? "",
        "customer_site_short_name": customerSiteShortName?.toString() ?? "",
        "customer_name": customerName?.toString() ?? "",
        "classType": classType?.toString() ?? "",
        "customerId": customerId?.toString() ?? "",
        "price_list_name": priceListName?.toString() ?? "",
        "agent_percentage": agentPercentage?.toString() ?? "",
        "tradegroupId": tradegroupId?.toString() ?? "",
        "salestermId": salestermId?.toString() ?? "",
        "transitDays": transitDays?.toString() ?? "",
        "transporterId": transporterId?.toString() ?? "",
        "bill_contact_person": billContactPerson?.toString() ?? "",
        "bill_contact_no": billContactNo?.toString() ?? "",
        "customer_bill_address1": customerBillAddress1?.toString() ?? "",
        "customer_bill_address2": customerBillAddress2?.toString() ?? "",
        "customer_bill_landmark": customerBillLandmark?.toString() ?? "",
        "customer_bill_area": customerBillArea?.toString() ?? "",
        "customer_bill_district": customerBillDistrict?.toString() ?? "",
        "customer_bill_city": customerBillCity?.toString() ?? "",
        "customer_bill_pincode": customerBillPincode?.toString() ?? "",
        "notification_count": notificationCount?.toString() ?? "",
        "og_contact_no": ogContactNo.toString(),
        "customer_email": customerEmail.toString(),
        "customer_phone1": customerPhone1.toString(),
        "contact_person": contactPerson.toString(),
        "customer_isd_code": customerIsdCode.toString(),
        "customer_bill_state": customerBillState?.toString() ?? "",
        "customer_bill_country": customerBillCountry?.toString() ?? "",
        "customer_bill_isd_code": customerBillIsdCode?.toString() ?? "",
        "customer_bill_std_code": customerBillStdCode?.toString() ?? "",
        "customer_bill_phone1": customerBillPhone1?.toString() ?? "",
        "customer_bill_phone2": customerBillPhone2?.toString() ?? "",
        "customer_bill_phone3": customerBillPhone3?.toString() ?? "",
        "customer_bill_default_whatsapp": customerBillDefaultWhatsapp?.toString() ?? "",
        "customer_bill_whatsapp_no1": customerBillWhatsappNo1?.toString() ?? "",
        "customer_bill_whatsapp_no2": customerBillWhatsappNo2?.toString() ?? "",
        "customer_bill_whatsapp_no3": customerBillWhatsappNo3?.toString() ?? "",
        "customer_bill_email": customerBillEmail?.toString() ?? "",
        "customer_bill_alternate_email": customerBillAlternateEmail?.toString() ?? "",
        "customer_bill_website": customerBillWebsite?.toString() ?? "",
        "customer_bill_gstin": customerBillGstin?.toString() ?? "",
        "customer_bill_gstin_date": customerBillGstinDate?.toString() ?? "",
        "customer_bill_gst_state": customerBillGstState?.toString() ?? "",
        "bill_pan_card": billPanCard?.toString() ?? "",
        "ship_contact_person": shipContactPerson?.toString() ?? "",
        "ship_contact_no": shipContactNo?.toString() ?? "",
        "customer_ship_address1": customerShipAddress1?.toString() ?? "",
        "customer_ship_address2": customerShipAddress2?.toString() ?? "",
        "customer_ship_landmark": customerShipLandmark?.toString() ?? "",
        "customer_ship_area": customerShipArea?.toString() ?? "",
        "customer_ship_district": customerShipDistrict?.toString() ?? "",
        "customer_ship_pincode": customerShipPincode?.toString() ?? "",
        "customer_ship_city": customerShipCity?.toString() ?? "",
        "customer_ship_state": customerShipState?.toString() ?? "",
        "customer_ship_country": customerShipCountry?.toString() ?? "",
        "customer_ship_isd_code": customerShipIsdCode?.toString() ?? "",
        "customer_ship_std_code": customerShipStdCode?.toString() ?? "",
        "customer_ship_phone1": customerShipPhone1?.toString() ?? "",
        "customer_ship_phone2": customerShipPhone2?.toString() ?? "",
        "customer_ship_phone3": customerShipPhone3?.toString() ?? "",
        "customer_ship_default_whatsapp": customerShipDefaultWhatsapp?.toString() ?? "",
        "customer_ship_whatsapp_no1": customerShipWhatsappNo1?.toString() ?? "",
        "customer_ship_whatsapp_no2": customerShipWhatsappNo2?.toString() ?? "",
        "customer_ship_whatsapp_no3": customerShipWhatsappNo3?.toString() ?? "",
        "customer_ship_email": customerShipEmail?.toString() ?? "",
        "customer_ship_alternate_email": customerShipAlternateEmail?.toString() ?? "",
        "customer_ship_website": customerShipWebsite?.toString() ?? "",
        "customer_ship_gstin": customerShipGstin?.toString() ?? "",
        "customer_ship_gstin_date": customerShipGstinDate?.toString() ?? "",
        "customer_ship_gst_state": customerShipGstState?.toString() ?? "",
        "ship_pan_card": shipPanCard?.toString() ?? "",
        "agent": agent?.toString() ?? "",
        "reference": reference?.toString() ?? "",
        "note": note?.toString() ?? "",
        "trade_group_name": tradeGroupName?.toString() ?? "",
        "term_name": termName?.toString() ?? "",
        "customersite_login_no": customersiteLoginNo?.toString() ?? "",
        "customersite_ship_whatsapp_no": customersiteShipWhatsappNo?.toString() ?? "",
        "customersite_bill_whatsapp_no": customersiteBillWhatsappNo?.toString() ?? "",
        "membershipCode": membershipCode?.toString() ?? "",
        "id": id.toString(),
        "isActive": isActive.toString(),
        "agent_name": agentName ?? "",
        "customer_bill_city_name": customerBillCityName ?? "",
        "customer_bill_country_name": customerBillCountryName ?? "",
        "customer_bill_state_name": customerBillStateName ?? "",
        "customer_bill_gst_state_name": customerBillGstStateName ?? "",
        "customer_ship_gst_state_name": customerShipGstStateName ?? "",
        "customer_ship_city_name": customerShipCityName ?? "",
        "customer_ship_country_name": customerShipCountryName ?? "",
        "customer_ship_state_name": customerShipStateName,
        "price_list": priceList ?? "",
        "transaction_term": transactionTerm ?? "",
        "transporter_name": transporterName ?? "",
      };
}
