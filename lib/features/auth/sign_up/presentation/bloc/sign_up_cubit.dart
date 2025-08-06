import 'package:demo/features/auth/sign_in/model/customer_site_id_model.dart';
import 'package:demo/features/auth/sign_up/data/model/signUp_res_model.dart';
import 'package:demo/features/auth/sign_up/presentation/bloc/sign_up_state.dart';

import '../../../../../export.dart';
import '../../data/model/city_model.dart';
import '../../data/model/country_model.dart';
import '../../data/model/isd_code_model.dart';
import '../../data/model/state_model.dart';

class SignUpCubit extends Cubit<SignUpState> with ApiClientMixin {
  List<IsdCodeModel> isdCodeModelList = [];
  List<CountryModel> countryModelList = [];
  List<StateModel> stateModelList = [];
  List<CityModel> cityModelList = [];
  CountryModel? selectedCountry;
  bool isValueSet = false;
  IsdCodeModel? selectedCode;

  SignUpCubit() : super(SignUpInitial());

  ///Get All dial code list
  getISDCodeList() async {
    emit(SignUpLoadingState());
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

  ///For check number already resister or not
  validateNumber(String phone, String code) async {
    emit(SignUpLoadingState());
    try {
      var body = {"ISDCode": code, "ContactNo": phone};
      final response = await apiClient.post(
        body: jsonEncode(body),
        headers: Singleton.instance.getAuthHeaders(withType: true),
        ApiConstants.validateNewContact,
        (p0) => p0,
      );

      if (response.success) {
        Singleton.instance.tempRegData = body;
        await onSendOptForSignUp(body);
        // NavigatorService.pushNamed(AppRoutes.locationScreen);
      } else if (response.responseCode == 409) {
        Singleton.instance.tempRegData = body;
        emit(SignUpErrorState(error: response.errorMessage));
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

  onSendOptForSignUp(var body) async {
    emit(SignUpLoadingState());
    try {
      final response2 = await apiClient.post(
        body: jsonEncode(body),
        headers: Singleton.instance.getAuthHeaders(withType: true),
        ApiConstants.generateAndSendOtp,
        (p0) => p0,
      );
      if (response2.success) {
        showToast(response2.data["message"] ?? "Otp Send Successfully");
        onValueChange();
        NavigatorService.pushNamed(AppRoutes.verifyOtpScreen, arguments: {
          'isUserFromReg': true,
          'isFromEditScreen': false,
          'bodyForUpdateProfile': {}
        });
      } else {
        showToast(response2.errorMessage ?? AppStrings.somethingWentWrong);
        onValueChange();
      }
    } catch (e) {
      showToast(AppStrings.somethingWentWrong);
      logV("Error===>$e");
      onValueChange();
    }
  }

  ///Location screen
  submitLocation(String countryName, String postalCode) async {
    emit(SignUpLoadingState());
    try {
      String url =
          "${ApiConstants.byCountryAndPostalCode}?countryName=$countryName&&postalCode=$postalCode";
      final response = await apiClient.get(
        url,
        (p0) => p0,
      );

      if (response.success) {
        showToast("Location submitted successfully");
        onValueChange();
        if (response.data != null) {
          try {
            logV("Singleton.instance.tempRegData==>${Singleton.instance.tempRegData}");
            Singleton.instance.tempRegData["cityId"] = response.data["data"]["cityId"].toString();
            Singleton.instance.tempRegData["stateId"] = response.data["data"]["stateId"].toString();
            Singleton.instance.tempRegData["countryId"] =
                response.data["data"]["countryId"].toString();
            Singleton.instance.tempRegData["postalCode"] = postalCode;
            logV("Singleton.instance.tempRegData==>${Singleton.instance.tempRegData}");
          } catch (e) {
            logV("Error===>$e");
          }
        }

        NavigatorService.pushNamed(AppRoutes.signUpScreen);
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

  ///Get All Country List
  getAllCountry({bool getOnlyCountry = false}) async {
    emit(SignUpLoadingState());
    try {
      final response = await apiClient.get(
        ApiConstants.countryList,
        (p0) => p0,
      );

      if (response.success) {
        countryModelList = response.data["data"] != null
            ? countryModelFromJson(jsonEncode(response.data["data"]))
            : [];
        if (!getOnlyCountry) {
          await getAllState();
          await getAllCity();
        }
        try {
          selectedCountry = countryModelList.firstWhere(
            (element) => element.id == 1,
          );
        } catch (e) {
          selectedCountry = countryModelList.first;
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

  ///Get All State List
  getAllState() async {
    try {
      final response = await apiClient.get(
        ApiConstants.stateList,
        (p0) => p0,
      );

      if (response.success) {
        stateModelList = response.data["data"] != null
            ? stateModelFromJson(jsonEncode(response.data["data"]))
            : [];
      } else {
        showToast(response.errorMessage ?? AppStrings.somethingWentWrong);
      }
    } catch (e) {
      showToast(AppStrings.somethingWentWrong);
      logV("Error===>$e");
    }
  }

  ///Get All City List
  getAllCity() async {
    try {
      final response = await apiClient.get(
        ApiConstants.cityList,
        (p0) => p0,
      );

      if (response.success) {
        cityModelList = response.data["data"] != null
            ? cityModelFromJson(jsonEncode(response.data["data"]))
            : [];
      } else {
        showToast(response.errorMessage ?? AppStrings.somethingWentWrong);
      }
    } catch (e) {
      showToast(AppStrings.somethingWentWrong);
      logV("Error===>$e");
    }
  }

  SignUpResponseModel signUpResponse = SignUpResponseModel();

  ///Sign Up
  signUp(var body) async {
    emit(SignUpLoadingState());
    try {
      final response = await apiClient.post(
        body: jsonEncode(body),
        headers: Singleton.instance.getAuthHeaders(withType: true),
        ApiConstants.signup,
        (p0) => p0,
      );

      if (response.success) {
        showToast("Your details submitted successfully for verification");

        signUpResponse = SignUpResponseModel.fromJson(response.data["data"]);

        log(jsonEncode(signUpResponse.toJson()), name: "SIGNUP RESPONSE MODEL");

        SharedPref.instance.setUserToken(authToken: "${response.data["token"]}");
        final authtoken = await SharedPref.instance.getUserToken();
        log("$authtoken", name: "AUTH TOKEN FROM SIGNUP API");

        await getCustomerSiteId(signUpResponse.id, signUpResponse);
        await SharedPref.instance.setUserData(customerSiteidList.first);
        await SharedPref.instance.setUserOtherData(UserOtherDataModel(
          createdOn: signUpResponse.createdOn,
          tierName: signUpResponse.tierName,
          totalPurchaseValue: signUpResponse.totalPurchaseValue,
        ));
        onValueChange();
        NavigatorService.pushNamedAndRemoveUntil(AppRoutes.dashBoardScreen);
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

  List<CustomerSiteIdModel> customerSiteidList = [];

  ///Get customer Site Id
  getCustomerSiteId(String id, SignUpResponseModel signUpResponse) async {
    try {
      final response = await apiClient.get(
        headers: Singleton.instance.getAuthHeaders(withType: true),
        "${ApiConstants.customerSite}?customerId=$id",
        (p0) => p0,
      );

      if (response.success) {
        if (response.data["data"] != null) {
          customerSiteidList = customerSiteIdModelFromJson(jsonEncode(response.data["data"]));
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

  onValueChange() {
    emit(SignUpValueChangeState());
  }
}
