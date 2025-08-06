import 'dart:async';

import 'package:demo/features/auth/sign_in/presentation/bloc/sign_in_state.dart';
import 'package:demo/features/auth/sign_up/data/model/isd_code_model.dart';
import 'package:demo/features/profile/bloc/edit_profile/edit_profile_cubit.dart';

import '../../../../../export.dart';
import '../../model/customer_site_id_model.dart';
import '../../model/login_res_model.dart';

class SignInCubit extends Cubit<SignInState> with ApiClientMixin {
  EditProfileCubit editProfileCubit = EditProfileCubit();
  List<IsdCodeModel> isdCodeModelList = [];
  Timer? _timer;
  int otpTImer = 90;
  int timerSeconds = 600;
  IsdCodeModel? selectedCode;
  bool canResendOtp = false;
  bool isUserFromReg = false;
  LoginResponseModel? loginResponseModel;
  SignInCubit(this.isUserFromReg) : super(SignInInitial());
  bool isLoading = false;
  final TextEditingController otpController = TextEditingController();

  ///Get All dial code list
  getISDCodeList() async {
    emit(SignInLoadingState());
    try {
      final response = await apiClient.get(
        ApiConstants.getISDCode,
        (p0) => p0,
      );

      if (response.success) {
        isdCodeModelList = response.data["data"] != null
            ? isdCodeModelFromJson(jsonEncode(response.data["data"]))
            : [];
        if (isdCodeModelList.isNotEmpty) {
          try {
            selectedCode = isdCodeModelList.firstWhere(
              (element) => element.value == "+91",
            );
          } catch (e) {
            selectedCode = isdCodeModelList.first;
          }
        }
      } else {
        showToast(response.errorMessage ?? AppStrings.somethingWentWrong);
      }
    } catch (e) {
      showToast(AppStrings.somethingWentWrong);
      logV("Error===>$e");
    } finally {
      onValueChange();
    }
  }

  ///Send otp
  sendOtp(String phone, String code,
      {bool isResend = false,
      bool isFromEditProfile = false,
      dynamic bodyForUpdateProfile,
      bool isForDeleteAccount = false,
      String customerSiteId = "",
      required BuildContext context}) async {
    emit(SignInLoadingState());
    try {
      var body = {"ISDCode": code, "ContactNo": phone};
      final response = await apiClient.post(
        body: jsonEncode(body),
        headers: Singleton.instance.getAuthHeaders(withType: true),
        isUserFromReg ? ApiConstants.generateAndSendOtp : ApiConstants.signInUsingMobile,
        (p0) => p0,
      );
      logV("response===>${response.data}");
      logV("response===>${response.errorMessage}");
      logV("response.responseCode===>${response.responseCode}");

      if (response.success) {
        showToast(response.data["message"]);
        Singleton.instance.tempRegData = body;
        if (isResend) {
          startOtpTimer();
          return;
        }
        onValueChange();
        if (isFromEditProfile == true) {
          log(bodyForUpdateProfile.toString(), name: "UPDATE BODY PASS FROM SEND OTP");
          NavigatorService.pushNamed(
            AppRoutes.verifyOtpScreen,
            arguments: {
              'isUserFromReg': isUserFromReg,
              'isFromEditScreen': true,
              'bodyForUpdateProfile': bodyForUpdateProfile
            },
          );
        } else if (isForDeleteAccount == true) {
          log(customerSiteId, name: "CUSTOMER SITE ID FOR DELETE ACCOUNT");
          log(phone, name: "PHONE FOR DELETE ACCOUNT");
          log(code, name: "PHONE CODE DELETE ACCOUNT");
          NavigatorService.goBack();
          NavigatorService.pushNamed(
            AppRoutes.verifyOtpScreen,
            arguments: {
              'isUserFromReg': isUserFromReg,
              'isFromEditScreen': false,
              'isForDeleteAccount': true,
              'customerSiteId': customerSiteId,
              'bodyForUpdateProfile': {}
            },
          );
        } else {
          NavigatorService.pushNamed(
            AppRoutes.verifyOtpScreen,
            arguments: {
              'isUserFromReg': isUserFromReg,
              'isFromEditScreen': false,
              'bodyForUpdateProfile': {}
            },
          );
        }
      } else {
        String message = response.errorMessage ?? AppStrings.somethingWentWrong;

        await customAlertDialog(title: "Error", message: message, waitForDialogClose: true);
        onValueChange();
      }
    } catch (e) {
      showToast(AppStrings.somethingWentWrong);
      logV("Error===>$e");
      onValueChange();
    }
  }

  List<LoginResponseModel> loginResponse = [];

  verifyOtp(String phone, String code, String otp,
      {bool isFromEditScreen = false,
      dynamic bodyForUpdateProfile,
      bool isForDeleteAccount = false,
      BuildContext? context,
      String customerSiteId = ""}) async {
    emit(SignInLoadingState());
    try {
      isLoading = true;

      var body = {"ContactNo": phone, "Otp": otp};
      final response = await apiClient.post(
          body: jsonEncode(body),
          headers: Singleton.instance.getAuthHeaders(withType: true),
          isUserFromReg ? ApiConstants.otpverify : ApiConstants.verifyotp,
          (p0) => p0,
          isLoginScreen: true);

      if (response.success) {
        // loginResponse.clear();
        if (isFromEditScreen == true) {
          if (bodyForUpdateProfile != {}) {
            log(bodyForUpdateProfile.toString(), name: "BODY FOR UPDATE PROFILE");
            await editProfileCubit.updateProfile(bodyForUpdateProfile, isFromEdit: true);

            isLoading = false;
          }
        } else if (isForDeleteAccount == true) {
          if (customerSiteId != "") {
            log(customerSiteId.toString(), name: "CUSTOMER SITE ID FOR DELETE ACCOUNT");
            await editProfileCubit.deleteAccount(
                customerSiteId: customerSiteId, isForDeleteAccount: true);

            isLoading = false;
          }
        } else {
          if (isUserFromReg) {
            showToast(response.data["message"]);
            isLoading = false;

            NavigatorService.popAndPushNamed(AppRoutes.locationScreen);

            return;
          }
          if (response.data["data"] != null) {
            // List<LoginResponseModel> loginResponse =
            //     loginResponseModelFromJson(jsonEncode(response.data["data"]));
            loginResponse = loginResponseModelFromJson(jsonEncode(response.data["data"]));

            SharedPref.instance.setUserToken(authToken: "${response.data["token"]}");
            final authtoken = await SharedPref.instance.getUserToken();
            log("$authtoken", name: "AUTH TOKEN FROM LOGIN API");

            emit(SignInSuccessState(loginResponse));
          }
        }
      } else {
        showToast(response.errorMessage ?? AppStrings.somethingWentWrong);
        otpController.clear();
        isLoading = false;

        onValueChange();
      }
    } catch (e) {
      showToast(AppStrings.somethingWentWrong);
      logV("Error===>$e");
      onValueChange();
    }
  }

  ///Get customer Site Id
  getCustomerSiteId(String id, List<LoginResponseModel> loginResponse) async {
    emit(SignInLoadingState());
    try {
      final response = await apiClient.get(
        headers: Singleton.instance.getAuthHeaders(withType: true),
        "${ApiConstants.customerSite}?customerId=$id",
        (p0) => p0,
      );

      if (response.success) {
        if (response.data["data"] != null) {
          List<CustomerSiteIdModel> data =
              customerSiteIdModelFromJson(jsonEncode(response.data["data"]));
          emit(SignInSuccessState2(customerSiteModel: data));
        }
      } else {
        showToast(response.errorMessage ?? AppStrings.somethingWentWrong);
        onValueChange();
      }
    } catch (e) {
      showToast(AppStrings.somethingWentWrong);
      logV("Error===>$e");
      onValueChange();
    }
  }

  ///Start resend otp timer
  void startOtpTimer() {
    canResendOtp = false;
    timerSeconds = otpTImer;
    onValueChange();

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerSeconds > 0) {
        timerSeconds--;
        onValueChange();
      } else {
        canResendOtp = true;
        onValueChange();
        _timer?.cancel();
      }
    });
  }

  onValueChange() {
    emit(SignInValueChangeState());
  }

  callSuccess() {
    List<LoginResponseModel> loginResponse =
        loginResponseModelFromJson(jsonEncode(listOfrecord["data"]));
    emit(SignInSuccessState(loginResponse));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    // TODO: implement close
    return super.close();
  }
}

// var listOfrecord = {
//   "succeeded": true,
//   "message": "OTP verified successfully.",
//   "data": [
//     {
//       "membershipStatus": null,
//       "id": "67",
//       "customer_name": "Chirag Jain 2",
//       "customer_alias": "Gradient Eye Technologies 2",
//       "agent": null,
//       "password": "8087382828",
//       "customer_short_code": "C2502000023",
//       "agent_percentage": null,
//       "customerClassId": 0,
//       "per_trans_order_limit": null,
//       "max_credit_limit": null,
//       "max_credit_days": null,
//       "transporterId": null,
//       "groupTierId": null,
//       "groupPaymentCreditId": null,
//       "pricelistId": null,
//       "company_type": null,
//       "industry_type": null,
//       "product_type": null,
//       "brand_name": null,
//       "director_owner_name": null,
//       "contact_person": null,
//       "contact_no": "7990061509",
//       "customer_address1": null,
//       "customer_address2": null,
//       "customer_landmark": null,
//       "customer_area": null,
//       "customer_district": null,
//       "customer_isd_code": null,
//       "customer_std_code": null,
//       "customer_phone1": null,
//       "customer_phone2": null,
//       "customer_phone3": null,
//       "customer_default_whatsapp": null,
//       "customer_whatsapp_no1": null,
//       "customer_whatsapp_no2": null,
//       "customer_whatsapp_no3": null,
//       "customer_email": "chirag@ge2.com",
//       "customer_alternate_email": null,
//       "customer_website": null,
//       "customer_gst_no": null,
//       "customer_pan_card": null,
//       "customer_reference": null,
//       "customer_note": null,
//       "customer_gst_date": null,
//       "gstStateId": 0,
//       "taxgroupId": 0,
//       "salestermId": 0,
//       "customer_city": null,
//       "customer_state": null,
//       "customer_country": null,
//       "customer_pincode": null,
//       "isActive": false,
//       "cinNo": null,
//       "createdOn": "02/20/2025 11:20:03",
//       "totalPurchaseValue": "0",
//       "tier_name": null
//     },
//     // {
//     //   "membershipStatus": null,
//     //   "id": "68",
//     //   "customer_name": "Chirag Jain 2",
//     //   "customer_alias": "Gradient Eye Technologies 2",
//     //   "agent": null,
//     //   "password": "8087382828",
//     //   "customer_short_code": "C2502000023",
//     //   "agent_percentage": null,
//     //   "customerClassId": 0,
//     //   "per_trans_order_limit": null,
//     //   "max_credit_limit": null,
//     //   "max_credit_days": null,
//     //   "transporterId": null,
//     //   "groupTierId": null,
//     //   "groupPaymentCreditId": null,
//     //   "pricelistId": null,
//     //   "company_type": null,
//     //   "industry_type": null,
//     //   "product_type": null,
//     //   "brand_name": null,
//     //   "director_owner_name": null,
//     //   "contact_person": null,
//     //   "contact_no": "7990061509",
//     //   "customer_address1": null,
//     //   "customer_address2": null,
//     //   "customer_landmark": null,
//     //   "customer_area": null,
//     //   "customer_district": null,
//     //   "customer_isd_code": null,
//     //   "customer_std_code": null,
//     //   "customer_phone1": "7990061509",
//     //   "customer_phone2": null,
//     //   "customer_phone3": null,
//     //   "customer_default_whatsapp": "7990061509",
//     //   "customer_whatsapp_no1": null,
//     //   "customer_whatsapp_no2": null,
//     //   "customer_whatsapp_no3": null,
//     //   "customer_email": "chirag@ge2.com",
//     //   "customer_alternate_email": null,
//     //   "customer_website": null,
//     //   "customer_gst_no": null,
//     //   "customer_pan_card": null,
//     //   "customer_reference": null,
//     //   "customer_note": null,
//     //   "customer_gst_date": null,
//     //   "gstStateId": 0,
//     //   "taxgroupId": 0,
//     //   "salestermId": 0,
//     //   "customer_city": null,
//     //   "customer_state": null,
//     //   "customer_country": null,
//     //   "customer_pincode": null,
//     //   "isActive": false,
//     //   "cinNo": null,
//     //   "createdOn": "02/20/2025 11:20:03",
//     //   "totalPurchaseValue": "0",
//     //   "tier_name": null
//     // },
//     // {
//     //   "membershipStatus": "Active",
//     //   "id": "69",
//     //   "customer_name": "TechJohnDoe",
//     //   "customer_alias": "TechJohnDoe Mumbai",
//     //   "agent": "",
//     //   "password": null,
//     //   "customer_short_code": "C2502000024",
//     //   "agent_percentage": null,
//     //   "customerClassId": 1,
//     //   "per_trans_order_limit": "1000000",
//     //   "max_credit_limit": "0",
//     //   "max_credit_days": "0",
//     //   "transporterId": "1",
//     //   "groupTierId": "1",
//     //   "groupPaymentCreditId": "1",
//     //   "pricelistId": "1",
//     //   "company_type": null,
//     //   "industry_type": "",
//     //   "product_type":
//     //       "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24",
//     //   "brand_name": "",
//     //   "director_owner_name": "",
//     //   "contact_person": "John Doe",
//     //   "contact_no": "7990061509",
//     //   "customer_address1": "NA",
//     //   "customer_address2": "",
//     //   "customer_landmark": "",
//     //   "customer_area": "",
//     //   "customer_district": "",
//     //   "customer_isd_code": "+91",
//     //   "customer_std_code": "22",
//     //   "customer_phone1": "7990061509",
//     //   "customer_phone2": "",
//     //   "customer_phone3": "",
//     //   "customer_default_whatsapp": "7990061509",
//     //   "customer_whatsapp_no1": "",
//     //   "customer_whatsapp_no2": "",
//     //   "customer_whatsapp_no3": "",
//     //   "customer_email": "john.doe@example.com",
//     //   "customer_alternate_email": "",
//     //   "customer_website": "",
//     //   "customer_gst_no": "",
//     //   "customer_pan_card": "To Provide",
//     //   "customer_reference": "",
//     //   "customer_note": "",
//     //   "customer_gst_date": "2025-02-13T00:00:00",
//     //   "gstStateId": 23,
//     //   "taxgroupId": 1,
//     //   "salestermId": 1,
//     //   "customer_city": "988",
//     //   "customer_state": "14",
//     //   "customer_country": "1",
//     //   "customer_pincode": "400095",
//     //   "isActive": true,
//     //   "cinNo": null,
//     //   "createdOn": "02/20/2025 11:21:04",
//     //   "totalPurchaseValue": "0",
//     //   "tier_name": "Insider"
//     // },
//     // {
//     //   "membershipStatus": "Pending",
//     //   "id": "128",
//     //   "customer_name": "MNK Jhon",
//     //   "customer_alias": "MNK Jhon Veraiyur",
//     //   "agent": null,
//     //   "password": null,
//     //   "customer_short_code": "C2505000067",
//     //   "agent_percentage": null,
//     //   "customerClassId": 1,
//     //   "per_trans_order_limit": "1000000",
//     //   "max_credit_limit": "0",
//     //   "max_credit_days": "0",
//     //   "transporterId": "1",
//     //   "groupTierId": "1",
//     //   "groupPaymentCreditId": "1",
//     //   "pricelistId": "1",
//     //   "company_type": null,
//     //   "industry_type": null,
//     //   "product_type": null,
//     //   "brand_name": null,
//     //   "director_owner_name": null,
//     //   "contact_person": "BUSSINF",
//     //   "contact_no": "7990061509",
//     //   "customer_address1": "NA",
//     //   "customer_address2": null,
//     //   "customer_landmark": null,
//     //   "customer_area": null,
//     //   "customer_district": null,
//     //   "customer_isd_code": "+91",
//     //   "customer_std_code": "",
//     //   "customer_phone1": "7990061509",
//     //   "customer_phone2": null,
//     //   "customer_phone3": null,
//     //   "customer_default_whatsapp": "7990061509",
//     //   "customer_whatsapp_no1": null,
//     //   "customer_whatsapp_no2": null,
//     //   "customer_whatsapp_no3": null,
//     //   "customer_email": "john.doe@example.com",
//     //   "customer_alternate_email": null,
//     //   "customer_website": null,
//     //   "customer_gst_no": null,
//     //   "customer_pan_card": "To Provide",
//     //   "customer_reference": null,
//     //   "customer_note": null,
//     //   "customer_gst_date": null,
//     //   "gstStateId": 23,
//     //   "taxgroupId": 1,
//     //   "salestermId": 1,
//     //   "customer_city": "2709",
//     //   "customer_state": "23",
//     //   "customer_country": "1",
//     //   "customer_pincode": "400095",
//     //   "isActive": true,
//     //   "cinNo": null,
//     //   "createdOn": "05/13/2025 18:51:15",
//     //   "totalPurchaseValue": "0",
//     //   "tier_name": "Insider"
//     // },
//     // {
//     //   "membershipStatus": "Pending",
//     //   "id": "129",
//     //   "customer_name": "MNK Jhon Preto",
//     //   "customer_alias": "MNK Jhon Preto Veraiyur",
//     //   "agent": null,
//     //   "password": null,
//     //   "customer_short_code": "C2505000068",
//     //   "agent_percentage": null,
//     //   "customerClassId": 1,
//     //   "per_trans_order_limit": "1000000",
//     //   "max_credit_limit": "0",
//     //   "max_credit_days": "0",
//     //   "transporterId": "1",
//     //   "groupTierId": "1",
//     //   "groupPaymentCreditId": "1",
//     //   "pricelistId": "1",
//     //   "company_type": null,
//     //   "industry_type": null,
//     //   "product_type": null,
//     //   "brand_name": null,
//     //   "director_owner_name": null,
//     //   "contact_person": "BUSSINF",
//     //   "contact_no": "7990061509",
//     //   "customer_address1": "NA",
//     //   "customer_address2": null,
//     //   "customer_landmark": null,
//     //   "customer_area": null,
//     //   "customer_district": null,
//     //   "customer_isd_code": "+91",
//     //   "customer_std_code": "",
//     //   "customer_phone1": "7990061509",
//     //   "customer_phone2": null,
//     //   "customer_phone3": null,
//     //   "customer_default_whatsapp": "7990061509",
//     //   "customer_whatsapp_no1": null,
//     //   "customer_whatsapp_no2": null,
//     //   "customer_whatsapp_no3": null,
//     //   "customer_email": "john.doe@example.com",
//     //   "customer_alternate_email": null,
//     //   "customer_website": null,
//     //   "customer_gst_no": null,
//     //   "customer_pan_card": "To Provide",
//     //   "customer_reference": null,
//     //   "customer_note": null,
//     //   "customer_gst_date": null,
//     //   "gstStateId": 23,
//     //   "taxgroupId": 1,
//     //   "salestermId": 1,
//     //   "customer_city": "2709",
//     //   "customer_state": "23",
//     //   "customer_country": "1",
//     //   "customer_pincode": "400095",
//     //   "isActive": true,
//     //   "cinNo": null,
//     //   "createdOn": "05/13/2025 18:52:04",
//     //   "totalPurchaseValue": "0",
//     //   "tier_name": "Insider"
//     // }
//   ]
// };
var listOfrecord = {
  "succeeded": true,
  "message": "OTP verified successfully.",
  "data": [
    {
      "membershipStatus": "Active",
      "id": "69",
      "customer_name": "TechJohnDoe",
      "customer_alias": "TechJohnDoe Mumbai",
      "agent": "",
      "password": null,
      "customer_short_code": "C2502000024",
      "agent_percentage": null,
      "customerClassId": 1,
      "per_trans_order_limit": "1000000",
      "max_credit_limit": "0",
      "max_credit_days": "0",
      "transporterId": "1",
      "groupTierId": "1",
      "groupPaymentCreditId": "1",
      "pricelistId": "1",
      "company_type": null,
      "industry_type": "",
      "product_type": "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24",
      "brand_name": "",
      "director_owner_name": "",
      "contact_person": "John Doe",
      "contact_no": "7990061509",
      "customer_address1": "NA",
      "customer_address2": "",
      "customer_landmark": "",
      "customer_area": "",
      "customer_district": "",
      "customer_isd_code": "+91",
      "customer_std_code": "22",
      "customer_phone1": "7990061509",
      "customer_phone2": "",
      "customer_phone3": "",
      "customer_default_whatsapp": "7990061509",
      "customer_whatsapp_no1": "",
      "customer_whatsapp_no2": "",
      "customer_whatsapp_no3": "",
      "customer_email": "john.doe@example.com",
      "customer_alternate_email": "",
      "customer_website": "",
      "customer_gst_no": "",
      "customer_pan_card": "To Provide",
      "customer_reference": "",
      "customer_note": "",
      "customer_gst_date": "2025-02-13T00:00:00",
      "gstStateId": 23,
      "taxgroupId": 1,
      "salestermId": 1,
      "customer_city": "988",
      "customer_state": "14",
      "customer_country": "1",
      "customer_pincode": "400095",
      "isActive": true,
      "cinNo": null,
      "createdOn": "02/20/2025 11:21:04",
      "totalPurchaseValue": "0",
      "tier_name": "Insider"
    }
  ]
};
