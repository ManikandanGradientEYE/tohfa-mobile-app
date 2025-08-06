import 'dart:io';

import 'package:demo/features/report/bloc/report_state.dart';
import 'package:demo/features/report/model/token_model.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../../export.dart';
import '../model/dispatch_status_model.dart';
import '../model/invoices_res_model.dart';
import '../model/notification_model.dart';
import '../model/order_memo_model.dart';
import '../model/past_food_order_res_model.dart';

class ReportCubit extends Cubit<ReportState> with ApiClientMixin {
  // final String? customerSiteId = "68";
  bool isLoading = false;
  final String? customerSiteId = Singleton.instance.userData?.id;
  final String? customerSiteName = Singleton.instance.userData?.customerSiteName;
  final String? customerId = Singleton.instance.userData?.customerId;

  ReportCubit() : super(ReportInitial());

  getOrderMemo() async {
    emit(ReportLoadingState());
    try {
      final response = await apiClient.get(
        // "${ApiConstants.getOrderMemo}?customerSiteId=${Singleton.instance.userData?.id}",
        "${ApiConstants.getOrderMemo}?customerSiteId=$customerSiteId",
        (p0) => p0,
      );
      if (response.success) {
        // sectionModel = sectionModelFromJson(jsonEncode(response.data));
        emit(OrderMemoSuccessState(
            orderMemoModel: orderMemoResModelFromJson(jsonEncode(response.data))));
      } else {
        emit(ReportErrorState(errorMessage: response.errorMessage));
      }
    } catch (e) {
      emit(ReportErrorState());
    }
  }

  getTokenList() async {
    emit(ReportLoadingState());
    try {
      final response = await apiClient.get(
        // "${ApiConstants.getOrderMemo}?customerSiteId=${Singleton.instance.userData?.id}",
        "${ApiConstants.getToken}?customerSiteId=$customerSiteId",
        (p0) => p0,
      );
      if (response.success) {
        emit(GetTokenSuccessState(
            tokenModel: tokenModelFromJson(jsonEncode(response.data["data"]))));
      } else {
        emit(ReportErrorState(errorMessage: response.errorMessage));
      }
    } catch (e) {
      emit(ReportErrorState());
    }
  }

  onOrderMemoSuccess() {
    if (state is OrderMemoSuccessState) {
      final data = (state as OrderMemoSuccessState).orderMemoModel;
      emit(OrderMemoSuccessState(orderMemoModel: data));
    }
  }

  onInvoiceSuccess() {
    if (state is InvoicesSuccessState) {
      final data = (state as InvoicesSuccessState).invoicesResModel;
      emit(InvoicesSuccessState(invoicesResModel: data));
    }
  }

  downloadOrderMemo(String orderMemoId, String siteId) async {
    isLoading = true;
    onOrderMemoSuccess();
    String authToken = await SharedPref.instance.getUserToken() ?? "";
    try {
      final url = Uri.parse(
          "${ApiConstants.downloadOrderMemo}?orderMemoId=$orderMemoId&siteId=$siteId&Barcode=true");
      final response = await get(url, headers: {
        "Authorization": "Bearer $authToken",
      });
      isLoading = false;
      if (response.statusCode == 200) {
        // Save PDF to file
        final bytes = response.bodyBytes;
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/OrderMemo_$orderMemoId.pdf');
        await file.writeAsBytes(bytes);

        // Open the PDF
        await OpenFile.open(file.path);
      } else {
        showToast("Unable to download");
      }
    } catch (e) {
      logV("Error==>$e");
      showToast("Unable to download");
    } finally {
      onOrderMemoSuccess();
    }
  }

  downloadInvoice(String orderMemoId) async {
    isLoading = true;
    onInvoiceSuccess();
    try {
      final url = Uri.parse(
          "${ApiConstants.downloadOrderMemo}?orderMemoId=$orderMemoId&siteId=$customerSiteId&Barcode=false");
      final response = await get(
        url,
      );

      isLoading = false;
      if (response.statusCode == 200) {
        // Save PDF to file
        final bytes = response.bodyBytes;
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/Invoice_$orderMemoId.pdf');
        await file.writeAsBytes(bytes);

        // Open the PDF
        await OpenFile.open(file.path);
      } else {
        showToast("Unable to download");
      }
    } catch (e) {
      logV("Error==>$e");
      showToast("Unable to download");
    } finally {
      onInvoiceSuccess();
    }
  }

  getNotification() async {
    emit(ReportLoadingState());
    try {
      final response = await apiClient.get(
        // "${ApiConstants.getOrderMemo}?customerSiteId=${Singleton.instance.userData?.id}",
        "${ApiConstants.notifications}?customerSiteId=$customerSiteId&customerId=$customerId",
        (p0) => p0,
      );
      if (response.success) {
        // sectionModel = sectionModelFromJson(jsonEncode(response.data));
        emit(NotificationSuccessState(
            notificationModel: (response.data == null || response.data == {})
                ? []
                : notificationItemFromJson(jsonEncode(response.data))));
      } else {
        emit(ReportErrorState(errorMessage: response.errorMessage));
      }
    } catch (e) {
      emit(ReportErrorState());
    }
  }

  getDispatchStatus() async {
    emit(ReportLoadingState());
    try {
      final response = await apiClient.get(
        // "${ApiConstants.getOrderMemo}?customerSiteId=${Singleton.instance.userData?.id}",
        "${ApiConstants.getDispatchStatus}?customerSiteId=$customerSiteId&customerSiteName=$customerSiteName",
        (p0) => p0,
      );
      if (response.success) {
        // sectionModel = sectionModelFromJson(jsonEncode(response.data));
        emit(DispatchStatusSuccessState(
            dispatchStatusResModel: dispatchStatusResModelFromJson(jsonEncode(response.data))));
      } else {
        emit(ReportErrorState(errorMessage: response.errorMessage));
      }
    } catch (e) {
      logV("error==>$e");
      emit(ReportErrorState());
    }
  }

  getInvoices() async {
    emit(ReportLoadingState());
    try {
      final response = await apiClient.get(
        // "${ApiConstants.getOrderMemo}?customerSiteId=${Singleton.instance.userData?.id}",
        "${ApiConstants.getInvoices}?customerSiteId=$customerSiteId",
        (p0) => p0,
      );
      if (response.success) {
        // sectionModel = sectionModelFromJson(jsonEncode(response.data));
        emit(InvoicesSuccessState(
            invoicesResModel: invoicesResModelFromJson(jsonEncode(response.data))));
      } else {
        emit(ReportErrorState(errorMessage: response.errorMessage));
      }
    } catch (e) {
      emit(ReportErrorState());
    }
  }

  getPastFoodOrder() async {
    emit(ReportLoadingState());
    try {
      final response = await apiClient.get(
        // "${ApiConstants.getOrderMemo}?customerSiteId=${Singleton.instance.userData?.id}",
        "${ApiConstants.getPastFoodOrder}?customerSiteId=$customerSiteId",
        (p0) => p0,
      );
      if (response.success) {
        // sectionModel = sectionModelFromJson(jsonEncode(response.data));
        emit(PastFoodOrderSuccessState(
            pastFoodOrderResModel: pastFoodOrderResModelFromJson(jsonEncode(response.data))));
      } else {
        emit(ReportErrorState(errorMessage: response.errorMessage));
      }
    } catch (e) {
      emit(ReportErrorState());
    }
  }
}
