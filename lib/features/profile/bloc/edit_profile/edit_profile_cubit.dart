import '../../../../export.dart';
import '../../../auth/sign_up/data/model/city_model.dart';
import '../../../auth/sign_up/data/model/country_model.dart';
import '../../../auth/sign_up/data/model/isd_code_model.dart';
import '../../../auth/sign_up/data/model/state_model.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> with ApiClientMixin {
  EditProfileCubit() : super(EditProfileInitial());
  List<IsdCodeModel> isdCodeModelList = [];
  List<CountryModel> countryModelList = [];
  List<StateModel> stateModelList = [];
  List<CityModel> cityModelList = [];
  bool isValueSet = false;
  IsdCodeModel? selectedCode;

  ///Get All Country List
  getAllCountry({bool getOnlyCountry = false}) async {
    emit(EditProfileLoadingState());
    try {
      final response = await apiClient.get(
        ApiConstants.countryList,
        (p0) => p0,
      );

      if (response.success) {
        countryModelList = response.data["data"] != null
            ? countryModelFromJson(jsonEncode(response.data["data"]))
            : [];
        // if (!getOnlyCountry) {
        //   await getAllState();
        //   await getAllCity();
        //   await getISDCodeList();
        // }
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

  ///Get All dial code list
  getISDCodeList() async {
    emit(EditProfileLoadingState());
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
            final tempData = Singleton.instance.userData;
            selectedCode = isdCodeModelList.firstWhere(
              (element) => tempData?.customerBillIsdCode ?? "",
            );
          } catch (e) {
            try {
              selectedCode = isdCodeModelList.firstWhere(
                (element) => element.value == "+91",
              );
            } catch (e) {
              selectedCode = isdCodeModelList.first;
            }
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

  ///Sign Up
  updateProfile(var body, {bool isFromEdit = false}) async {
    // emit(EditProfileLoadingState());
    try {
      final response = await apiClient.put(
        body: jsonEncode(body),
        headers: Singleton.instance.getAuthHeaders(withType: true),
        ApiConstants.updateCustomerSite,
        (p0) => p0,
      );

      if (response.success) {
        showToast(response.data["message"]);
        if (isFromEdit == true) {
          NavigatorService.goBack();
          NavigatorService.goBack(arguments: true);
          // dashBoardBloc.on<DashBoardIndexChangeEvent>(
          //   (event, emit) {
          //     // event.selectedIndex = 3;
          //     Singleton.instance.dashBoardIndex = 3;
          //     emit(DashBoardIndexChangeState(3));
          //   },
          // );
          // NavigatorService.pushNamedAndRemoveUntil(AppRoutes.dashBoardScreen);
        } else {
          NavigatorService.goBack(arguments: true);
        }
        onValueChange();
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

  deleteAccount({
    bool isForDeleteAccount = false,
    required String customerSiteId,
  }) async {
    // Object? body = json.encode({
    //   "CustomerSiteId": customerSiteId,
    // });

    try {
      log(ApiConstants.deleteAccount, name: "DELETE ACCOUNT API URL");
      final response = await apiClient.post(
          "${ApiConstants.deleteAccount}?CustomerSiteId=$customerSiteId", (p0) => p0);
      log("${response.data}", name: "DELETE ACCOUNT RESPONSE");
      log("${response.success}", name: "DELETE ACCOUNT SUCCESS");
      if (response.data["succeeded"] == true) {
        // showToast(response.data["messages"].toString());
        NavigatorService.goBack();
        SharedPref.instance.logOut();
        NavigatorService.pushNamedAndRemoveUntil(AppRoutes.sendOtpScreen);
        onValueChange();
      } else {}
      // if (response.success) {
      //   showToast(response.data["message"]);
      //   NavigatorService.goBack();
      //   SharedPref.instance.logOut();
      //   NavigatorService.pushNamedAndRemoveUntil(AppRoutes.sendOtpScreen);
      //   // if (isForDeleteAccount == true) {
      //   //   NavigatorService.goBack();
      //   //   NavigatorService.goBack(arguments: true);
      //   // } else {
      //   //   NavigatorService.goBack(arguments: true);
      //   // }
      //   onValueChange();
      //   // return response.data["data"];
      // }
    } catch (e) {
      showToast(AppStrings.somethingWentWrong);
    } finally {
      onValueChange();
    }
  }

  onValueChange() {
    emit(EditProfileValueChangeState());
  }
}
