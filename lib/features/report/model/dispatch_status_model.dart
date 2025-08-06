// // To parse this JSON data, do
// //
// //     final dispatchStatusResModel = dispatchStatusResModelFromJson(jsonString);

// import 'dart:convert';

// DispatchStatusResModel dispatchStatusResModelFromJson(String str) => DispatchStatusResModel.fromJson(json.decode(str));

// String dispatchStatusResModelToJson(DispatchStatusResModel data) => json.encode(data.toJson());

// class DispatchStatusResModel {
//   List<DispatchStatus>? data;

//   DispatchStatusResModel({
//     this.data,
//   });

//   DispatchStatusResModel copyWith({
//     List<DispatchStatus>? data,
//   }) =>
//       DispatchStatusResModel(
//         data: data ?? this.data,
//       );

//   factory DispatchStatusResModel.fromJson(Map<String, dynamic> json) => DispatchStatusResModel(
//     data: json["data"] == null ? [] : List<DispatchStatus>.from(json["data"]!.map((x) => DispatchStatus.fromJson(x))),
//   );

//   Map<String, dynamic> toJson() => {
//     "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
//   };
// }

// class DispatchStatus {
//   dynamic salesInvoiceNo;
//   dynamic date;
//   dynamic orNo;
//   dynamic status;
//   dynamic discountpercentage;
//   dynamic refDocNo;
//   dynamic lrId;
//   dynamic refDocDate;
//   dynamic customerSiteId;
//   dynamic transitDays;
//   dynamic transitDueDate;
//   dynamic transporterName;
//   dynamic creditDueDate;
//   dynamic agentName;
//   dynamic commisionRate;
//   dynamic totalQty;
//   dynamic totalValue;
//   dynamic totalGrossAmt;
//   dynamic dispatchStatus;
//   dynamic discount;
//   dynamic freightCharges;
//   dynamic basicValue;
//   dynamic integratedGst;
//   dynamic roundOff;
//   dynamic netAmount;
//   dynamic sgst;
//   dynamic cgst;
//   dynamic igst;
//   dynamic others;
//   dynamic bondNo;
//   dynamic portCode;
//   dynamic shippingBill;
//   dynamic shippingBillDate;
//   dynamic logisticsNo;
//   dynamic declarationAmount;
//   dynamic parcelid;
//   dynamic lrDate;
//   dynamic remarks;
//   dynamic siteId;
//   dynamic customerSiteName;
//   dynamic details;
//   dynamic parcelManagements;
//   dynamic billContactNo;
//   dynamic customerBillEmail;
//   dynamic billAddress;
//   dynamic customerBillGstin;
//   dynamic customerBillGstState;
//   dynamic shipAddress;
//   dynamic customerShipGstin;
//   dynamic customerShipGstState;
//   dynamic agent;
//   dynamic termName;
//   dynamic siteAddress1;
//   dynamic customerName;
//   dynamic siteContactMobile;
//   dynamic siteWebsite;
//   dynamic siteEmail;
//   dynamic siteGstin;
//   dynamic siteGstinState;
//   dynamic siteCinNo;
//   dynamic reportLogo;
//   dynamic id;
//   dynamic createdBy;
//   DateTime? createdOn;
//   dynamic modifiedBy;
//   DateTime? modifiedOn;
//   bool? isActive;

//   DispatchStatus({
//     this.salesInvoiceNo,
//     this.date,
//     this.status,
//     this.discountpercentage,
//     this.totalGrossAmt,
//     this.refDocNo,
//     this.lrId,
//     this.refDocDate,
//     this.customerSiteId,
//     this.transitDays,
//     this.transitDueDate,
//     this.transporterName,
//     this.creditDueDate,
//     this.agentName,
//     this.commisionRate,
//     this.totalQty,
//     this.totalValue,
//     this.discount,
//     this.freightCharges,
//     this.basicValue,
//     this.integratedGst,
//     this.roundOff,
//     this.netAmount,
//     this.sgst,
//     this.cgst,
//     this.igst,
//     this.others,
//     this.orNo,
//     this.bondNo,
//     this.portCode,
//     this.shippingBill,
//     this.dispatchStatus,
//     this.shippingBillDate,
//     this.logisticsNo,
//     this.declarationAmount,
//     this.parcelid,
//     this.lrDate,
//     this.remarks,
//     this.siteId,
//     this.customerSiteName,
//     this.details,
//     this.parcelManagements,
//     this.billContactNo,
//     this.customerBillEmail,
//     this.billAddress,
//     this.customerBillGstin,
//     this.customerBillGstState,
//     this.shipAddress,
//     this.customerShipGstin,
//     this.customerShipGstState,
//     this.agent,
//     this.termName,
//     this.siteAddress1,
//     this.customerName,
//     this.siteContactMobile,
//     this.siteWebsite,
//     this.siteEmail,
//     this.siteGstin,
//     this.siteGstinState,
//     this.siteCinNo,
//     this.reportLogo,
//     this.id,
//     this.createdBy,
//     this.createdOn,
//     this.modifiedBy,
//     this.modifiedOn,
//     this.isActive,
//   });

//   DispatchStatus copyWith({
//     dynamic salesInvoiceNo,
//     dynamic date,
//     dynamic status,
//     dynamic discountpercentage,
//     dynamic refDocNo,
//     dynamic lrId,
//     dynamic orNo,
//     dynamic refDocDate,
//     dynamic totalGrossAmt,
//     dynamic customerSiteId,
//     dynamic transitDays,
//     dynamic transitDueDate,
//     dynamic transporterName,
//     dynamic creditDueDate,
//     dynamic agentName,
//     dynamic commisionRate,
//     dynamic dispatchStatus,
//     dynamic totalQty,
//     dynamic totalValue,
//     dynamic discount,
//     dynamic freightCharges,
//     dynamic basicValue,
//     dynamic integratedGst,
//     dynamic roundOff,
//     dynamic netAmount,
//     dynamic sgst,
//     dynamic cgst,
//     dynamic igst,
//     dynamic others,
//     dynamic bondNo,
//     dynamic portCode,
//     dynamic shippingBill,
//     dynamic shippingBillDate,
//     dynamic logisticsNo,
//     dynamic declarationAmount,
//     dynamic parcelid,
//     dynamic lrDate,
//     dynamic remarks,
//     dynamic siteId,
//     dynamic customerSiteName,
//     dynamic details,
//     dynamic parcelManagements,
//     dynamic billContactNo,
//     dynamic customerBillEmail,
//     dynamic billAddress,
//     dynamic customerBillGstin,
//     dynamic customerBillGstState,
//     dynamic shipAddress,
//     dynamic customerShipGstin,
//     dynamic customerShipGstState,
//     dynamic agent,
//     dynamic termName,
//     dynamic siteAddress1,
//     dynamic customerName,
//     dynamic siteContactMobile,
//     dynamic siteWebsite,
//     dynamic siteEmail,
//     dynamic siteGstin,
//     dynamic siteGstinState,
//     dynamic siteCinNo,
//     dynamic reportLogo,
//     dynamic id,
//     dynamic createdBy,
//     DateTime? createdOn,
//     dynamic modifiedBy,
//     DateTime? modifiedOn,
//     bool? isActive,
//   }) =>
//       DispatchStatus(
//         salesInvoiceNo: salesInvoiceNo ?? this.salesInvoiceNo,
//         date: date ?? this.date,
//         status: status ?? this.status,
//         discountpercentage: discountpercentage ?? this.discountpercentage,
//         refDocNo: refDocNo ?? this.refDocNo,
//         lrId: lrId ?? this.lrId,
//         refDocDate: refDocDate ?? this.refDocDate,
//         customerSiteId: customerSiteId ?? this.customerSiteId,
//         transitDays: transitDays ?? this.transitDays,
//         transitDueDate: transitDueDate ?? this.transitDueDate,
//         transporterName: transporterName ?? this.transporterName,
//         creditDueDate: creditDueDate ?? this.creditDueDate,
//         orNo: orNo ?? this.orNo,
//         agentName: agentName ?? this.agentName,
//         commisionRate: commisionRate ?? this.commisionRate,
//         totalGrossAmt: totalGrossAmt ?? this.totalGrossAmt,
//         totalQty: totalQty ?? this.totalQty,
//         totalValue: totalValue ?? this.totalValue,
//         discount: discount ?? this.discount,
//         freightCharges: freightCharges ?? this.freightCharges,
//         basicValue: basicValue ?? this.basicValue,
//         integratedGst: integratedGst ?? this.integratedGst,
//         roundOff: roundOff ?? this.roundOff,
//         netAmount: netAmount ?? this.netAmount,
//         sgst: sgst ?? this.sgst,
//         cgst: cgst ?? this.cgst,
//         igst: igst ?? this.igst,
//         others: others ?? this.others,
//         bondNo: bondNo ?? this.bondNo,
//         portCode: portCode ?? this.portCode,
//         shippingBill: shippingBill ?? this.shippingBill,
//         shippingBillDate: shippingBillDate ?? this.shippingBillDate,
//         logisticsNo: logisticsNo ?? this.logisticsNo,
//         declarationAmount: declarationAmount ?? this.declarationAmount,
//         parcelid: parcelid ?? this.parcelid,
//         lrDate: lrDate ?? this.lrDate,
//         remarks: remarks ?? this.remarks,
//         siteId: siteId ?? this.siteId,
//         customerSiteName: customerSiteName ?? this.customerSiteName,
//         details: details ?? this.details,
//         parcelManagements: parcelManagements ?? this.parcelManagements,
//         billContactNo: billContactNo ?? this.billContactNo,
//         customerBillEmail: customerBillEmail ?? this.customerBillEmail,
//         dispatchStatus: dispatchStatus ?? this.dispatchStatus,
//         billAddress: billAddress ?? this.billAddress,
//         customerBillGstin: customerBillGstin ?? this.customerBillGstin,
//         customerBillGstState: customerBillGstState ?? this.customerBillGstState,
//         shipAddress: shipAddress ?? this.shipAddress,
//         customerShipGstin: customerShipGstin ?? this.customerShipGstin,
//         customerShipGstState: customerShipGstState ?? this.customerShipGstState,
//         agent: agent ?? this.agent,
//         termName: termName ?? this.termName,
//         siteAddress1: siteAddress1 ?? this.siteAddress1,
//         customerName: customerName ?? this.customerName,
//         siteContactMobile: siteContactMobile ?? this.siteContactMobile,
//         siteWebsite: siteWebsite ?? this.siteWebsite,
//         siteEmail: siteEmail ?? this.siteEmail,
//         siteGstin: siteGstin ?? this.siteGstin,
//         siteGstinState: siteGstinState ?? this.siteGstinState,
//         siteCinNo: siteCinNo ?? this.siteCinNo,
//         reportLogo: reportLogo ?? this.reportLogo,
//         id: id ?? this.id,
//         createdBy: createdBy ?? this.createdBy,
//         createdOn: createdOn ?? this.createdOn,
//         modifiedBy: modifiedBy ?? this.modifiedBy,
//         modifiedOn: modifiedOn ?? this.modifiedOn,
//         isActive: isActive ?? this.isActive,
//       );

//   factory DispatchStatus.fromJson(Map<String, dynamic> json) => DispatchStatus(
//     salesInvoiceNo: json["salesInvoiceNo"],
//     date: json["date"],
//     status: json["status"],
//     discountpercentage: json["discountpercentage"],
//     refDocNo: json["refDocNo"],
//     lrId: json["lrId"],
//     refDocDate: json["refDocDate"],
//     customerSiteId: json["customerSiteId"],
//     transitDays: json["transitDays"],
//     transitDueDate: json["transitDueDate"],
//     transporterName: json["transporterName"],
//     creditDueDate: json["creditDueDate"],
//     agentName: json["agentName"],
//     commisionRate: json["commisionRate"],
//     totalQty: json["totalQty"],
//     totalValue: json["totalValue"],
//     discount: json["discount"],
//     orNo: json["orNo"],
//     freightCharges: json["freightCharges"],
//     basicValue: json["basicValue"],
//     integratedGst: json["integratedGST"],
//     totalGrossAmt: json["totalGrossAmt"],
//     roundOff: json["roundOff"],
//     netAmount: json["netAmount"],
//     sgst: json["sgst"],
//     cgst: json["cgst"],
//     igst: json["igst"],
//     others: json["others"],
//     bondNo: json["bondNo"],
//     dispatchStatus: json["dcStatus"],
//     portCode: json["portCode"],
//     shippingBill: json["shippingBill"],
//     shippingBillDate: json["shippingBillDate"],
//     logisticsNo: json["logisticsNo"],
//     declarationAmount: json["declarationAmount"],
//     parcelid: json["parcelid"],
//     lrDate: json["lrDate"],
//     remarks: json["remarks"],
//     siteId: json["siteId"],
//     customerSiteName: json["customer_site_name"],
//     details: json["details"],
//     parcelManagements: json["parcelManagements"],
//     billContactNo: json["bill_contact_no"],
//     customerBillEmail: json["customer_bill_email"],
//     billAddress: json["billAddress"],
//     customerBillGstin: json["customer_bill_gstin"],
//     customerBillGstState: json["customer_bill_gst_state"],
//     shipAddress: json["shipAddress"],
//     customerShipGstin: json["customer_ship_gstin"],
//     customerShipGstState: json["customer_ship_gst_state"],
//     agent: json["agent"],
//     termName: json["term_name"],
//     siteAddress1: json["site_address1"],
//     customerName: json["customer_name"],
//     siteContactMobile: json["site_contact_mobile"],
//     siteWebsite: json["site_website"],
//     siteEmail: json["site_email"],
//     siteGstin: json["site_gstin"],
//     siteGstinState: json["site_gstin_state"],
//     siteCinNo: json["site_CINNo"],
//     reportLogo: json["report_logo"],
//     id: json["id"],
//     createdBy: json["createdBy"],
//     createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
//     modifiedBy: json["modifiedBy"],
//     modifiedOn: json["modifiedOn"] == null ? null : DateTime.parse(json["modifiedOn"]),
//     isActive: json["isActive"],
//   );

//   Map<String, dynamic> toJson() => {
//     "salesInvoiceNo": salesInvoiceNo,
//     "date": date,
//     "status": status,
//     "discountpercentage": discountpercentage,
//     "refDocNo": refDocNo,
//     "lrId": lrId,
//     "refDocDate": refDocDate,
//     "customerSiteId": customerSiteId,
//     "transitDays": transitDays,
//     "transitDueDate": transitDueDate,
//     "transporterName": transporterName,
//     "creditDueDate": creditDueDate,
//     "agentName": agentName,
//     "commisionRate": commisionRate,
//     "totalQty": totalQty,
//     "totalValue": totalValue,
//     "discount": discount,
//     "freightCharges": freightCharges,
//     "basicValue": basicValue,
//     "integratedGST": integratedGst,
//     "roundOff": roundOff,
//     "netAmount": netAmount,
//     "sgst": sgst,
//     "cgst": cgst,
//     "igst": igst,
//     "others": others,
//     "bondNo": bondNo,
//     "portCode": portCode,
//     "shippingBill": shippingBill,
//     "shippingBillDate": shippingBillDate,
//     "logisticsNo": logisticsNo,
//     "declarationAmount": declarationAmount,
//     "parcelid": parcelid,
//     "lrDate": lrDate,
//     "remarks": remarks,
//     "siteId": siteId,
//     "customer_site_name": customerSiteName,
//     "details": details,
//     "parcelManagements": parcelManagements,
//     "bill_contact_no": billContactNo,
//     "customer_bill_email": customerBillEmail,
//     "billAddress": billAddress,
//     "customer_bill_gstin": customerBillGstin,
//     "customer_bill_gst_state": customerBillGstState,
//     "shipAddress": shipAddress,
//     "customer_ship_gstin": customerShipGstin,
//     "customer_ship_gst_state": customerShipGstState,
//     "agent": agent,
//     "term_name": termName,
//     "site_address1": siteAddress1,
//     "customer_name": customerName,
//     "site_contact_mobile": siteContactMobile,
//     "site_website": siteWebsite,
//     "site_email": siteEmail,
//     "site_gstin": siteGstin,
//     "site_gstin_state": siteGstinState,
//     "site_CINNo": siteCinNo,
//     "report_logo": reportLogo,
//     "id": id,
//     "createdBy": createdBy,
//     "createdOn": createdOn?.toIso8601String(),
//     "modifiedBy": modifiedBy,
//     "modifiedOn": modifiedOn?.toIso8601String(),
//     "isActive": isActive,
//   };
// }

// To parse this JSON data, do
//
//     final dispatchStatusResModel = dispatchStatusResModelFromJson(jsonString);

import 'dart:convert';

DispatchStatusResModel dispatchStatusResModelFromJson(String str) => DispatchStatusResModel.fromJson(json.decode(str));

String dispatchStatusResModelToJson(DispatchStatusResModel data) => json.encode(data.toJson());

class DispatchStatusResModel {
    List<Datum>? data;
    bool? succeeded;
    List<dynamic>? messages;

    DispatchStatusResModel({
        this.data,
        this.succeeded,
        this.messages,
    });

    factory DispatchStatusResModel.fromJson(Map<String, dynamic> json) => DispatchStatusResModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        succeeded: json["succeeded"],
        messages: List<dynamic>.from(json["messages"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "succeeded": succeeded,
        "messages": List<dynamic>.from(messages!.map((x) => x)),
    };
}

class Datum {
    int? siteId;
    String? siteName;
    String? lrDocNo;
    String? lrDocDate;
    String? site;
    String? consignee;
    String? transporterName;
    String? stockPoint;
    String? refDocNo;
    String? vehicleNo;
    String? refDocDate;
    String? mode;
    String? transactionType;
    int? gateExitId;
    String? gateExitNo;
    String? stationFrom;
    String? stationTo;
    String? distance;
    String? deliveryDate;
    String? toPay;
    int? rate;
    int? actualWeight;
    int? chargedWeight;
    int? freightCharges;
    int? otherCharges;
    int? totalAmount;
    int? declarationAmount;
    int? documentAmount;
    dynamic completionTime;
    String? remarks;
    String? documentUrl;
    String? status;
    int? id;
    String? createdBy;
    DateTime? createdOn;
    dynamic modifiedBy;
    dynamic modifiedOn;
    bool? isActive;

    Datum({
        this.siteId,
        this.siteName,
        this.lrDocNo,
        this.lrDocDate,
        this.site,
        this.consignee,
        this.transporterName,
        this.stockPoint,
        this.refDocNo,
        this.vehicleNo,
        this.refDocDate,
        this.mode,
        this.transactionType,
        this.gateExitId,
        this.gateExitNo,
        this.stationFrom,
        this.stationTo,
        this.distance,
        this.deliveryDate,
        this.toPay,
        this.rate,
        this.actualWeight,
        this.chargedWeight,
        this.freightCharges,
        this.otherCharges,
        this.totalAmount,
        this.declarationAmount,
        this.documentAmount,
        this.completionTime,
        this.remarks,
        this.documentUrl,
        this.status,
        this.id,
        this.createdBy,
        this.createdOn,
        this.modifiedBy,
        this.modifiedOn,
        this.isActive,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        siteId: json["siteId"],
        siteName: json["site_name"],
        lrDocNo: json["lrDocNo"],
        lrDocDate: json["lrDocDate"],
        site: json["site"],
        consignee: json["consignee"],
        transporterName: json["transporterName"],
        stockPoint: json["stockPoint"],
        refDocNo: json["refDocNo"],
        vehicleNo: json["vehicleNo"],
        refDocDate: json["refDocDate"],
        mode: json["mode"],
        transactionType: json["transactionType"],
        gateExitId: json["gateExitId"],
        gateExitNo: json["gateExitNo"],
        stationFrom: json["stationFrom"],
        stationTo: json["stationTo"],
        distance: json["distance"],
        deliveryDate: json["deliveryDate"],
        toPay: json["toPay"],
        rate: json["rate"],
        actualWeight: json["actualWeight"],
        chargedWeight: json["chargedWeight"],
        freightCharges: json["freightCharges"],
        otherCharges: json["otherCharges"],
        totalAmount: json["totalAmount"],
        declarationAmount: json["declarationAmount"],
        documentAmount: json["documentAmount"],
        completionTime: json["completionTime"],
        remarks: json["remarks"],
        documentUrl: json["documentUrl"],
        status: json["status"],
        id: json["id"],
        createdBy: json["createdBy"],
        createdOn: DateTime.parse(json["createdOn"]),
        modifiedBy: json["modifiedBy"],
        modifiedOn: json["modifiedOn"],
        isActive: json["isActive"],
    );

    Map<String, dynamic> toJson() => {
        "siteId": siteId,
        "site_name": siteName,
        "lrDocNo": lrDocNo,
        "lrDocDate": lrDocDate,
        "site": site,
        "consignee": consignee,
        "transporterName": transporterName,
        "stockPoint": stockPoint,
        "refDocNo": refDocNo,
        "vehicleNo": vehicleNo,
        "refDocDate": refDocDate,
        "mode": mode,
        "transactionType": transactionType,
        "gateExitId": gateExitId,
        "gateExitNo": gateExitNo,
        "stationFrom": stationFrom,
        "stationTo": stationTo,
        "distance": distance,
        "deliveryDate": deliveryDate,
        "toPay": toPay,
        "rate": rate,
        "actualWeight": actualWeight,
        "chargedWeight": chargedWeight,
        "freightCharges": freightCharges,
        "otherCharges": otherCharges,
        "totalAmount": totalAmount,
        "declarationAmount": declarationAmount,
        "documentAmount": documentAmount,
        "completionTime": completionTime,
        "remarks": remarks,
        "documentUrl": documentUrl,
        "status": status,
        "id": id,
        "createdBy": createdBy,
        "createdOn": createdOn!.toIso8601String(),
        "modifiedBy": modifiedBy,
        "modifiedOn": modifiedOn,
        "isActive": isActive,
    };
}
