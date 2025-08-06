import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_drop_down.dart';
import '../../../../../export.dart';
import '../../data/model/city_model.dart';
import '../../data/model/country_model.dart';
import '../../data/model/state_model.dart';
import '../bloc/sign_up_cubit.dart';
import '../bloc/sign_up_state.dart';
import '../widget/allready_login_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider<SignUpCubit>(
      create: (context) => SignUpCubit()..getAllCountry(),
      child: SignUpScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController customerAliasController =
        TextEditingController();
    final TextEditingController userNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController pinCodeController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();
    CountryModel? selectedCountryModel;
    StateModel? selectedStateModel;
    CityModel? selectedCityModel;
    return Scaffold(
      backgroundColor: Color(0xFFF6F4F0),
      body: SafeArea(
        child: BlocConsumer<SignUpCubit, SignUpState>(
          listener: (context, state) async {},
          builder: (context, state) {
            final bloc = context.read<SignUpCubit>();

            List<StateModel> stateModelList = [];
            List<CityModel> cityModelList = [];

            getLustValue() {
              if (selectedCountryModel != null) {
                logV("selectedCountryModel?.id===>${selectedCountryModel?.id}");
                stateModelList = bloc.stateModelList.where(
                  (element) {
                    logV(
                        "element.countryId.toString()===>${element.countryId.toString()}");
                    logV(
                        "selectedCountryModel?.id.toString()===>${selectedCountryModel?.id.toString()}");
                    logV("element===>${element.id.toString()}");
                    return element.countryId.toString() ==
                        selectedCountryModel?.id.toString();
                  },
                ).toList();
              }
              if (selectedStateModel != null) {
                cityModelList = bloc.cityModelList
                    .where(
                      (element) =>
                          element.countryId == selectedCountryModel?.id &&
                          selectedStateModel?.id == element.stateId,
                    )
                    .toList();
              }
            }

            getLustValue();
            if (!bloc.isValueSet && state is SignUpValueChangeState) {
              Map tempData = Singleton.instance.tempRegData;
              logV("tempData==>$tempData");
              phoneNumberController.text =
                  "${tempData["ISDCode"]} ${tempData["ContactNo"]}";
              pinCodeController.text = tempData["postalCode"] ?? "";
              try {
                selectedCountryModel = bloc.countryModelList.firstWhere(
                  (element) =>
                      element.id.toString() == tempData["countryId"].toString(),
                );
              } catch (e) {
                logV("Error while getting county id");
              }
              getLustValue();
              try {
                selectedStateModel = stateModelList.firstWhere(
                  (element) =>
                      element.id.toString() == tempData["stateId"].toString(),
                );
              } catch (e) {
                logV("Error while getting state id");
              }
              getLustValue();
              try {
                selectedCityModel = cityModelList.firstWhere(
                  (element) =>
                      element.id.toString() == tempData["cityId"].toString(),
                );
              } catch (e) {
                logV("Error while getting city id");
              }
              bloc.isValueSet = true;
            }
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: getPadding(all: 26),
                  child: Column(
                    spacing: getSize(40),
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomImageView(
                        height: getSize(60),
                        imagePath: ImageConstants.appLogo,
                        fit: BoxFit.contain,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: getSize(15),
                        children: [
                          CustomText(
                            text: "SIGN UP",
                            style: CustomTextStyle.headingText
                                .copyWith(fontSize: getSize(22)),
                          ),
                          AppTextField(
                            labelText: "Business name",
                            controller: customerAliasController,
                          ),
                          AppTextField(
                            labelText: "Your name",
                            controller: userNameController,
                          ),
                          AppTextField(
                            labelText: "Phone number",
                            readOnly: true,
                            controller: phoneNumberController,
                          ),
                          AppTextField(
                            labelText: "Email",
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          customDropDown2(
                            height2: getSize(47),
                            bloc.countryModelList,
                            (p0) => p0.countryName ?? "",
                            onChanged: (value) {
                              selectedCountryModel = value;
                              selectedStateModel = null;
                              selectedCityModel = null;
                              bloc.onValueChange();
                            },
                            customLabel: SizedBox(),
                            hintText: "Select country",
                            valueText: selectedCountryModel?.countryName,
                          ),
                          customDropDown2(
                            disableMessage: selectedCountryModel == null
                                ? "Please select country first"
                                : stateModelList.isEmpty
                                    ? "No State Found"
                                    : null,
                            enabled: stateModelList.isNotEmpty &&
                                selectedCountryModel != null,
                            height2: getSize(47),
                            stateModelList,
                            (p0) => p0.stateName ?? "",
                            onChanged: (value) {
                              selectedStateModel = value;
                              selectedCityModel = null;
                              bloc.onValueChange();
                            },
                            hintText: "Select state",
                            customLabel: SizedBox(),
                            valueText: selectedStateModel?.stateName,
                          ),
                          customDropDown2(
                            disableMessage: selectedStateModel == null
                                ? "Please select state first"
                                : cityModelList.isEmpty
                                    ? "No City Found"
                                    : null,
                            customLabel: SizedBox(),
                            enabled: cityModelList.isNotEmpty &&
                                selectedStateModel != null,
                            height2: getSize(47),
                            cityModelList,
                            (p0) => p0.cityName ?? "",
                            onChanged: (value) {
                              selectedCityModel = value;
                              bloc.onValueChange();
                            },
                            hintText: "Select city",
                            valueText: selectedCityModel?.cityName,
                          ),
                          AppTextField(
                            maxLength: 6,
                            inputFormatters: [
                              Validation.maxLength(maxLength: 6),
                              Validation.allowOnlyNumbers(),
                            ],
                            keyboardType: TextInputType.phone,
                            labelText: "Pin code",
                            controller: pinCodeController,
                            hintText: "Enter pin code",
                          ),
                          Center(
                            child: CustomButton(
                              text: "SIGN UP",
                              onPressed: () {
                                if (customerAliasController.text
                                    .trim()
                                    .isEmpty) {
                                  showToast("Please enter customer alias");
                                  HapticFeedback.vibrate();
                                } else if (userNameController.text
                                    .trim()
                                    .isEmpty) {
                                  showToast("Please enter username");
                                  HapticFeedback.vibrate();
                                }
                                // else if (emailController.text.trim().isEmpty) {
                                //   showToast("Please enter email address");
                                //   HapticFeedback.vibrate();
                                // } else if (!RegExp(
                                //         r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                                //     .hasMatch(emailController.text.trim())) {
                                //   showToast("Invalid email address");
                                //   HapticFeedback.vibrate();
                                // }
                                else if (pinCodeController.text
                                    .trim()
                                    .isEmpty) {
                                  showToast("Please enter pin code");
                                  HapticFeedback.vibrate();
                                } else if (pinCodeController.text.length != 6 ||
                                    !RegExp(r"^[0-9]+$").hasMatch(
                                        pinCodeController.text.trim())) {
                                  showToast("Invalid pin code");
                                  HapticFeedback.vibrate();
                                } else if (selectedCountryModel == null) {
                                  showToast("Please select a country");
                                  HapticFeedback.vibrate();
                                } else if (selectedStateModel == null) {
                                  showToast("Please select a state");
                                  HapticFeedback.vibrate();
                                } else if (selectedCityModel == null) {
                                  showToast("Please select a city");
                                  HapticFeedback.vibrate();
                                } else {
                                  var body = {
                                    "customer_alias":
                                        customerAliasController.text,
                                    "contact_person": userNameController.text,
                                    "countryid":
                                        selectedCountryModel?.id.toString(),
                                    "stateid":
                                        selectedStateModel?.id.toString(),
                                    "cityid": selectedCityModel?.id.toString(),
                                    "countryName":
                                        selectedCountryModel?.countryName,
                                    "customer_pincode": pinCodeController.text,
                                    "customer_isd_code": Singleton
                                        .instance.tempRegData["ISDCode"],
                                    "contact_no": Singleton
                                        .instance.tempRegData["ContactNo"],
                                    "email": emailController.text,
                                    "TransactionTermName": "",
                                    "customer_std_code": "",
                                  };
                                  bloc.signUp(body);
                                }
                              },
                            ),
                          ),
                          allReadyLogin()
                        ],
                      ),
                    ],
                  ),
                ),
                Visibility(
                    visible: state is SignUpLoadingState,
                    child: Container(
                      color: AppColors.primaryColorDark.withValues(alpha: .2),
                      child: CustomLoading(),
                    ))
              ],
            );
          },
        ),
      ),
    );
  }
}
