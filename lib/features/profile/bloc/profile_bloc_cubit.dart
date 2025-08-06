import 'package:demo/features/home/model/section_model.dart';
import 'package:demo/features/home/model/visit_status_model.dart';
import 'package:demo/features/profile/bloc/profile_bloc_state.dart';

import '../../../export.dart';
import '../../auth/sign_in/model/customer_site_id_model.dart';

class ProfileBlocCubit extends Cubit<ProfileBlocState> with ApiClientMixin {
  List<CustomerSiteIdModel> customerSiteModel = [];
  CustomerSiteIdModel? selectedModel;
  ProfileBlocCubit() : super(ProfileBlocInitial());

  // List<String> customerSiteList = ["Surat", "Mumbai", "Pune"];
  List sectionList = ["12-A", "13-F", "22-P"];
  String selectedSectionId = "";
  String selectedVisitStutsId = "";
  String selectedVisitStuts = "";
  String selectedSection = "";
  List<VisitStatusModel> visitStatusModel = [];
  List<SectionModel> sectionModel = [];

  void onDropDownValueChange({required String value, required bool isCustomerSite}) {
    emit(DropDownValueChangeState(value: value, isCustomerSite: isCustomerSite));
  }

  ///Get customer Site Id
  getCustomerSiteId(String id) async {
    try {
      final response = await apiClient.get(
        headers: Singleton.instance.getAuthHeaders(),
        "${ApiConstants.customerSite}?customerId=$id",
        (p0) => p0,
      );

      if (response.success) {
        if (response.data["data"] != null) {
          customerSiteModel = customerSiteIdModelFromJson(jsonEncode(response.data["data"]));
          log("$customerSiteModel", name: "Customer Site ID");
        }
      } else {
        showToast(response.errorMessage ?? AppStrings.somethingWentWrong);
        onSuccess();
      }
    } catch (e) {
      showToast(AppStrings.somethingWentWrong);
      logV("Error===>$e");
      onSuccess();
    }
  }

  getAllSections({required String siteId}) async {
    try {
      final response = await apiClient.get(
        "${ApiConstants.getSection}?siteId=$siteId",
        (p0) => p0,
      );
      if (response.success) {
        log(response.data.toString(), name: "DATA IS");
        sectionModel = sectionModelFromJson(jsonEncode(response.data));
        log(sectionModel.length.toString(), name: "name");
        emit(ProfileSectionDataState(sectionModel: sectionModel));
      } else {
        showToast(response.errorMessage ?? AppStrings.somethingWentWrong);
      }
    } catch (e) {
      showToast(AppStrings.somethingWentWrong);
      logV("Get all section Error===>$e");
    }
  }

  Future<String> generateToken({
    required String customerSite,
    required String sectionId,
    required String siteId,
  }) async {
    Object? body =
        json.encode({"CustomerSite": customerSite, "SectionId": sectionId, "siteid": siteId});
    try {
      final response = await apiClient.post(ApiConstants.generateToken, (p0) => p0, body: body);
      if (response.success) {
        return response.data["data"];
      } else {
        return "";
      }
    } catch (e) {
      showToast(AppStrings.somethingWentWrong);
      logV("Generate token error===>$e");
      return "";
    }
  }

  deleteAccount({
    required String customerSiteId,
  }) async {
    Object? body = json.encode({
      "CustomerSiteId": customerSiteId,
    });

    try {
      log(ApiConstants.deleteAccount, name: "DELETE ACCOUNT API URL");
      final response = await apiClient.post(
          "${ApiConstants.deleteAccount}?CustomerSiteId=$customerSiteId", (p0) => p0);
      log("${response.data}", name: "DELETE ACCOUNT RESPONSE");
      if (response.success) {
        return response.data["data"];
      } else {
        return "";
      }
    } catch (e) {
      showToast(AppStrings.somethingWentWrong);
      logV("Generate token error===>$e");
      return "";
    }
  }

  getProfile() async {
    final String? customerSiteId = Singleton.instance.userData?.id;
    // final String customerSiteId = "68";
    emit(ProfileLoadingState());
    try {
      final response = await apiClient.get(
        // "${ApiConstants.getOrderMemo}?customerSiteId=${Singleton.instance.userData?.id}",
        "${ApiConstants.customerSiteDetails}?customerSiteId=$customerSiteId",
        (p0) => p0,
      );
      if (response.success) {
        if (response.data["data"] != null) {
          CustomerSiteIdModel profile = CustomerSiteIdModel.fromJson(response.data["data"]);
          await SharedPref.instance.setUserData(profile);
          await getCustomerSiteId(profile.customerId.toString());
          try {
            selectedModel = customerSiteModel.firstWhere(
              (element) => element.id.toString() == profile.id.toString(),
            );
          } catch (e) {}
          onSuccess();
        } else {
          showToast(response.errorMessage ?? AppStrings.somethingWentWrong);
          emit(ProfileErrorState(error: response.errorMessage));
        }
      } else {
        showToast(response.errorMessage ?? AppStrings.somethingWentWrong);
        emit(ProfileErrorState(error: response.errorMessage));
      }
    } catch (e) {
      showToast(AppStrings.somethingWentWrong);
      emit(ProfileErrorState());
    }
  }

  getvisitStatus({required String customerSiteId}) async {
    try {
      final response = await apiClient.get(
        "${ApiConstants.visitStatus}?customerSiteId=$customerSiteId",
        (p0) => p0,
      );
      if (response.success) {
        log(response.data.toString(), name: "DATA IS");
        visitStatusModel = visitStatusModelFromJson(jsonEncode(response.data));
        emit(ProfileVisitStatusState(visitStatusModel: visitStatusModel));
      } else {
        showToast(response.errorMessage ?? AppStrings.somethingWentWrong);
      }
    } catch (e) {
      showToast(AppStrings.somethingWentWrong);
      logV("Get all visit status Error===>$e");
    }
  }

  onSuccess() {
    emit(ProfileSuccessState());
  }
}
