import '../../../export.dart';
import '../../auth/sign_in/model/customer_site_id_model.dart';
import '../../auth/sign_up/data/model/isd_code_model.dart';
import '../../report/widget/report_screen_appbar.dart';
import '../bloc/edit_profile/edit_profile_cubit.dart';

class EditProfileScreenNew extends StatelessWidget {
  const EditProfileScreenNew({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider<EditProfileCubit>(
      create: (context) => EditProfileCubit()..getISDCodeList(),
      child: EditProfileScreenNew(),
    );
  }

  @override
  Widget build(BuildContext context) {
    CustomerSiteIdModel? tempData;
      tempData = Singleton.instance.userData;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: reportScreenAppbar("Your Profile"),
      body: BlocConsumer<EditProfileCubit, EditProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
        
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: getPadding(left: 26, right: 26, top: 1,bottom: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // spacing: getSize(15),
                        children: [
                          ///new
                          Column(
                            spacing: getSize(5),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "Primary Details",
                                style: CustomTextStyle.bodyText.copyWith(
                                  color: AppColors.primaryText3,
                                  fontSize: getSize(24),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),   SizedBox(height: 1,),
                              _buildReadOnlyFieldwithLable(
                                  labelText: "Business / Shop Name",
                                  value: tempData!.customerSiteName),
                              _buildReadOnlyFieldwithLable(
                                  labelText: "Contact Name",
                                  value: tempData.contactPerson),
                              _buildReadOnlyFieldwithLable(
                                  labelText: "Primary Mobile",
                                  value:
                                      "${tempData.customerIsdCode} ${tempData.contactNo}"),
                              _buildReadOnlyFieldwithLable(
                                  labelText: "Alternate Phone",
                                  value: "${tempData.customerIsdCode} ${tempData.customerPhone1}"),
                              _buildReadOnlyFieldwithLable(
                                  labelText: "Email",
                                  value: tempData.customerEmail),
                              Divider(
                                thickness: 0.7,
                              ),
                            ],
                          ),

                          Column(
                            spacing: getSize(5),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "Billing Details",
                                style: CustomTextStyle.bodyText.copyWith(
                                  color: AppColors.primaryText3,
                                  fontSize: getSize(20),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),   SizedBox(height: 1,),
                              _buildReadOnlyFieldwithLable(
                                  labelText: "Address",
                                  value:
                                      "${tempData.customerBillAddress1} ${tempData.customerBillAddress2}"),
                              _buildReadOnlyFieldwithLable(
                                  labelText: "Landmark",
                                  value: tempData.customerBillLandmark),
                              _buildReadOnlyFieldwithLable(
                                  labelText: "Area",
                                  value: "${tempData.customerBillArea}"),
                              _buildReadOnlyFieldwithLable(
                                  labelText: "District",
                                  value: tempData.customerBillDistrict),
                              _buildReadOnlyFieldwithLable(
                                  labelText: "City",
                                  value: tempData.customerBillCityName),
                              _buildReadOnlyFieldwithLable(
                                  labelText: "Pincode",
                                  value: tempData.customerBillPincode),
                              _buildReadOnlyFieldwithLable(
                                  labelText: "State",
                                  value: tempData.customerBillStateName),
                              _buildReadOnlyFieldwithLable(
                                  labelText: "Country",
                                  value: tempData.customerBillCountryName),
                              _buildReadOnlyFieldwithLable(
                                  labelText: "PAN",
                                  value: tempData.billPanCard),
                              _buildReadOnlyFieldwithLable(
                                  labelText: "GSTIN",
                                  value: tempData.customerBillGstin),
                              Divider(
                                thickness: 0.7,
                              ),
                            ],
                          ),

                          Column(
                            spacing: getSize(5),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "Shipping Details",
                                style: CustomTextStyle.bodyText.copyWith(
                                  color: AppColors.primaryText3,
                                  fontSize: getSize(20),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 1,),
                              _buildReadOnlyFieldwithLable(
                                  labelText: "Address",
                                  value:
                                      "${tempData.customerShipAddress1 } ${tempData.customerBillAddress2}"),
                              _buildReadOnlyFieldwithLable(
                                  labelText: "Landmark",
                                  value: tempData.customerShipLandmark),
                              _buildReadOnlyFieldwithLable(
                                  labelText: "Area",
                                  value: "${tempData.customerShipArea}"),
                              _buildReadOnlyFieldwithLable(
                                  labelText: "District",
                                  value: tempData.customerShipDistrict),
                              _buildReadOnlyFieldwithLable(
                                  labelText: "City",
                                  value: tempData.customerShipCityName),
                              _buildReadOnlyFieldwithLable(
                                  labelText: "Pincode",
                                  value: tempData.customerShipPincode),
                              _buildReadOnlyFieldwithLable(
                                  labelText: "State",
                                  value: tempData.customerShipStateName),
                              _buildReadOnlyFieldwithLable(
                                  labelText: "Country",
                                  value: tempData.customerShipCountryName),
                              _buildReadOnlyFieldwithLable(
                                  labelText: "PAN",
                                  value: tempData.shipPanCard),
                              _buildReadOnlyFieldwithLable(
                                  labelText: "GSTIN",
                                  value: tempData.customerShipGstin),
                              Divider(
                                thickness: 0.7,
                              ),
                            ],
                          ),
                       Center(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      CustomText(
        text:
            "For any changes in your Profile Data, Kindly contact the Tohfa Sales Team on",
        style: CustomTextStyle.bodyText.copyWith(
          color: AppColors.primaryText3,
          fontSize: getSize(14),
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 4), // spacing
      Row(mainAxisAlignment: MainAxisAlignment.center,spacing: 10,
        children: [
          CustomText(
            text: "+918425000635",
            style: CustomTextStyle.bodyText.copyWith(
              color: AppColors.primaryText3,
              fontSize: getSize(14),
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          CustomText(
        text: "OR Email us at",
        style: CustomTextStyle.bodyText.copyWith(
          color: AppColors.primaryText3,
          fontSize: getSize(14),
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
        ],
      ),
   
     
      const SizedBox(height: 4),
      CustomText(
        text: "sales@tohfajewellery.in",
        style: CustomTextStyle.bodyText.copyWith(
          color: AppColors.primaryText3,
          fontSize: getSize(14),
          fontWeight: FontWeight.w800,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  ),
)

                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                  visible: state is EditProfileLoadingState,
                  child: Container(
                    color: AppColors.primaryColorDark.withValues(alpha: .2),
                    child: CustomLoading(),
                  ))
            ],
          );
        },
      ),
    );
  }
}

Widget _buildReadOnlyFieldwithLable({
  required String labelText,
  String? value,
}) {
  return Row(
    children: [
      CustomText(
        text: "$labelText - ",
        style: CustomTextStyle.bodyText.copyWith(
          color: AppColors.primaryText3,
          fontSize: getSize(14),
          fontWeight: FontWeight.w800,
        ),
      ),
      CustomText(
        text: value ?? " ",
        style: CustomTextStyle.bodyText.copyWith(
          color: value!.isEmpty ? Colors.transparent : AppColors.primaryText3,
          fontSize: getSize(14),
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}
