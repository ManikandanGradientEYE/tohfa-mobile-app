import 'package:demo/core/widgets/custom_actions.dart';
import 'package:demo/core/widgets/custom_button.dart';
import 'package:demo/features/profile/bloc/edit_profile/edit_profile_cubit.dart';
import 'package:pinput/pinput.dart';

import '../../../../../export.dart';
import '../../model/customer_site_id_model.dart';
import '../../model/login_res_model.dart';
import '../bloc/sign_in_cubit.dart';
import '../bloc/sign_in_state.dart';

class VerifyOtpScreen extends StatefulWidget {
  final bool isUserFromReg;
  final bool isFromEditScreen;
  final dynamic bodyForUpdateProfile;
  final bool isForDeleteAccount;
  final String customerSiteId;

  const VerifyOtpScreen(this.isUserFromReg,
      {super.key,
      this.isFromEditScreen = false,
      this.bodyForUpdateProfile,
      this.isForDeleteAccount = false,
      this.customerSiteId = ""});

  static Widget builder(BuildContext context) {
    // final arg = (ModalRoute.of(context)?.settings.arguments ?? false) as bool;
    final args = (ModalRoute.of(context)?.settings.arguments ?? {}) as Map;
    final isUserFromReg = args['isUserFromReg'] as bool? ?? false;
    final isFromEditScreen = args['isFromEditScreen'] as bool? ?? false;
    final bodyForUpdateProfile = args['bodyForUpdateProfile'] as dynamic ?? {};
    final isForDeleteAccount = args['isForDeleteAccount'] as bool? ?? false;
    final customerSiteId = args['customerSiteId'] as String? ?? "";

    return BlocProvider<SignInCubit>(
        create: (context) => SignInCubit(isUserFromReg)..startOtpTimer(),
        child: VerifyOtpScreen(
          isUserFromReg,
          isFromEditScreen: isFromEditScreen,
          bodyForUpdateProfile: bodyForUpdateProfile,
          isForDeleteAccount: isForDeleteAccount,
          customerSiteId: customerSiteId,
        ));
    // return BlocProvider<SignInCubit>(
    //   create: (context) => SignInCubit(arg)..startOtpTimer(),
    //   child: VerifyOtpScreen(
    //     arg,
    //     isFromEditScreen: true,
    //   ),
    // );
  }

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    // final TextEditingController otpController = TextEditingController();
    return Scaffold(
      backgroundColor: Color(0xFFF6F4F0),
      body: SafeArea(
        child: BlocConsumer<SignInCubit, SignInState>(
          listener: (context, state) async {
            if (widget.isFromEditScreen != true) {
              final cubit = context.read<SignInCubit>();

              if (state is SignInSuccessState) {
                List<LoginResponseModel> loginResponse = state.loginResponse;

                LoginResponseModel? loginResponseModel;
                if (loginResponse.isEmpty) {
                  showToast("Login account not found");
                  NavigatorService.goBack();
                } else if (loginResponse.length == 1 &&
                    loginResponse.first.membershipStatus == "Active") {
                  loginResponseModel = loginResponse.first;
                  cubit.loginResponseModel = loginResponseModel;
                  await cubit.getCustomerSiteId(loginResponseModel.id.toString(), loginResponse);
                } else {
                  int? selectedAccountIndex;
                  final data = await customDialog2(
                    context: context,
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            customDialogTitle("Select Customer Account"),
                            Flexible(
                              child: ListView.separated(
                                padding: getPadding(top: 10, bottom: 10),
                                shrinkWrap: true,
                                itemCount: loginResponse.length,
                                separatorBuilder: (context, index) => getSizeBox(height: 8),
                                itemBuilder: (context, index) {
                                  final item = loginResponse[index];
                                  bool isSelected = selectedAccountIndex == index;
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    padding: getPadding(all: 5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.primaryColorDark
                                              .withValues(alpha: isSelected ? 0.8 : 0.2)),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: RadioListTile<int>(
                                      value: index,
                                      activeColor: AppColors.primaryColor,
                                      groupValue: selectedAccountIndex,
                                      onChanged: (value) async {
                                        if (item.membershipStatus == "Active") {
                                          setState(() {
                                            selectedAccountIndex = value!;
                                          });
                                        } else {
                                          await _customErrorDialog(item.membershipStatus ?? "Idle");
                                        }
                                      },
                                      title: CustomText(
                                        text: item.customerAlias,
                                        style: CustomTextStyle.headingText.copyWith(
                                            fontSize: getSize(14), color: AppColors.blackText),
                                      ),
                                      subtitle: CustomText(
                                        text: item.customerName,
                                        style: CustomTextStyle.normalText
                                            .copyWith(fontSize: getSize(12)),
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  );
                                },
                              ),
                            ),
                            CustomButton(
                              text: "LOGIN",
                              onPressed: () {
                                if (selectedAccountIndex == null) {
                                  HapticFeedback.vibrate();
                                  showToast("Please select Customer Account");
                                  return;
                                }
                                final selectedAccount = loginResponse[selectedAccountIndex!];
                                NavigatorService.goBack(arguments: selectedAccount);
                              },
                            )
                          ],
                        );
                      },
                    ),
                  );

                  if (data != null) {
                    loginResponseModel = data;
                  } else {
                    showToast("No Account selected");
                    NavigatorService.goBack();
                  }

                  if (loginResponseModel != null) {
                    await cubit.getCustomerSiteId(loginResponseModel.id.toString(), loginResponse);
                    cubit.loginResponseModel = loginResponseModel;
                  }
                }
              }
              if (state is SignInSuccessState2) {
                List<CustomerSiteIdModel> customerSiteModel = state.customerSiteModel;
                if (customerSiteModel.isEmpty) {
                  showToast("Login account not found");
                  // NavigatorService.goBack();
                } else if (customerSiteModel.length == 1) {
                  await SharedPref.instance.setUserData(customerSiteModel.first);
                  await SharedPref.instance.setUserOtherData(UserOtherDataModel(
                    createdOn: cubit.loginResponseModel?.createdOn,
                    tierName: cubit.loginResponseModel?.tierName,
                    totalPurchaseValue: cubit.loginResponseModel?.totalPurchaseValue,
                  ));
                  NavigatorService.pushNamedAndRemoveUntil(AppRoutes.dashBoardScreen);
                } else {
                  int selectedAccountIndex = 0;
                  final data = await customDialog2(
                    context: context,
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            customDialogTitle("Select Customer Site"),
                            Flexible(
                              child: ListView.separated(
                                padding: getPadding(top: 10, bottom: 10),
                                shrinkWrap: true,
                                itemCount: customerSiteModel.length,
                                separatorBuilder: (context, index) => getSizeBox(height: 8),
                                itemBuilder: (context, index) {
                                  final item = customerSiteModel[index];
                                  bool isSelected = selectedAccountIndex == index;
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    padding: getPadding(all: 5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.primaryColorDark
                                              .withValues(alpha: isSelected ? 0.8 : 0.2)),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: RadioListTile<int>(
                                      value: index,
                                      activeColor: AppColors.primaryColor,
                                      groupValue: selectedAccountIndex,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedAccountIndex = value!;
                                        });
                                      },
                                      title: CustomText(
                                        text: item.customerSiteName ?? "N/A",
                                        style: CustomTextStyle.headingText.copyWith(
                                            fontSize: getSize(14), color: AppColors.blackText),
                                      ),
                                      subtitle: CustomText(
                                        text: item.customerName ??
                                            item.customerSiteShortName ??
                                            "N/A",
                                        style: CustomTextStyle.normalText
                                            .copyWith(fontSize: getSize(12)),
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  );
                                },
                              ),
                            ),
                            CustomButton(
                              text: "LOGIN",
                              onPressed: () {
                                final selectedAccount = customerSiteModel[selectedAccountIndex];
                                NavigatorService.goBack(arguments: selectedAccount);
                              },
                            )
                          ],
                        );
                      },
                    ),
                  );

                  if (data != null) {
                    await SharedPref.instance.setUserData(data);
                    NavigatorService.pushNamedAndRemoveUntil(AppRoutes.dashBoardScreen);
                    await SharedPref.instance.setUserOtherData(UserOtherDataModel(
                      createdOn: cubit.loginResponseModel?.createdOn,
                      tierName: cubit.loginResponseModel?.tierName,
                      totalPurchaseValue: cubit.loginResponseModel?.totalPurchaseValue,
                    ));
                  } else {
                    showToast("No Account selected");
                    NavigatorService.goBack();
                  }
                }
              }
            }
          },
          builder: (context, state) {
            final bloc = context.watch<SignInCubit>();
            int timerSeconds = bloc.timerSeconds;
            bool canResendOtp = bloc.canResendOtp;

            return Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding: getPadding(all: 26),
                    child: Column(
                      spacing: getSize(30),
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomImageView(
                          height: getSize(60),
                          imagePath: ImageConstants.appLogo,
                          fit: BoxFit.contain,
                        ),
                        CustomText(
                          text:
                              "Enter 4   digit code  sent on number ending with .......${getLastTwoCharacters(Singleton.instance.tempRegData["ContactNo"])}",
                          style: CustomTextStyle.subtitleText.copyWith(
                            color: AppColors.primaryText,
                            fontWeight: FontWeight.w300,
                            fontSize: getSize(17),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Center(
                          child: Pinput(
                            length: 4,
                            controller: bloc.otpController,
                            keyboardType: TextInputType.number,
                            focusedPinTheme: PinTheme(
                              width: getSize(55),
                              height: getSize(55),
                              textStyle:
                                  TextStyle(fontSize: getSize(20), fontWeight: FontWeight.w600),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(getSize(8)),
                                border: Border.all(color: AppColors.primaryColor),
                              ),
                            ),
                            defaultPinTheme: PinTheme(
                              width: getSize(55),
                              height: getSize(55),
                              textStyle:
                                  TextStyle(fontSize: getSize(20), fontWeight: FontWeight.w600),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(getSize(8)),
                                border: Border.all(
                                    color: Colors.black.withValues(alpha: 0.11999999731779099)),
                              ),
                            ),
                            onChanged: (value) async {
                              if (value.length == 4
                                  // &&
                                  //     isFromEditScreen == false
                                  ) {
                                // setState(() {
                                //   isLoading = true;
                                // });
                                var tempDate = Singleton.instance.tempRegData;
                                await bloc.verifyOtp(tempDate["ContactNo"], tempDate["ISDCode"],
                                    bloc.otpController.text.trim(),
                                    isFromEditScreen: widget.isFromEditScreen,
                                    bodyForUpdateProfile: widget.bodyForUpdateProfile,
                                    customerSiteId: widget.customerSiteId,
                                    isForDeleteAccount: widget.isForDeleteAccount,
                                    context: context);
                                Future.delayed(Duration(seconds: 1));
                                // setState(() {
                                //   isLoading = false;
                                // });
                              }
                            },
                          ),
                        ),
                        Column(
                          spacing: getSize(5),
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "Didn’t receive OTP? ",
                              style: CustomTextStyle.subtitleText.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: getSize(14),
                              ),
                            ),
                            canResendOtp
                                ? InkWell(
                                    onTap: () {
                                      var tempDate = Singleton.instance.tempRegData;
                                      bloc.sendOtp(tempDate["ContactNo"], tempDate["ISDCode"],
                                          isResend: true,
                                          context: context,
                                          isFromEditProfile: widget.isFromEditScreen);
                                    },
                                    child: CustomText(
                                      text: "Resend OTP",
                                      style: CustomTextStyle.subtitleText.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: getSize(16),
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColors.primaryColorDark,
                                      ),
                                    ),
                                  )
                                : CustomText(
                                    text: "Resend OTP in ${formatTimer(timerSeconds)}",
                                    style: CustomTextStyle.subtitleText.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: getSize(16),
                                      color: Colors.grey,
                                    ),
                                  ),
                            // InkWell(
                            //   onTap: () {
                            //     bloc.sendOtp("", "");
                            //   },
                            //   child: CustomText(
                            //     text: "Resend OTP",
                            //     style: CustomTextStyle.subtitleText.copyWith(
                            //         fontWeight: FontWeight.w500,
                            //         fontSize: getSize(16),
                            //         decoration: TextDecoration.underline,
                            //         decorationColor: AppColors.primaryColorDark),
                            //   ),
                            // ),
                          ],
                        ),
                        getSizeBox(height: 0),
                        BlocProvider<EditProfileCubit>(
                            create: (context2) => EditProfileCubit(),
                            child: BlocConsumer<EditProfileCubit, EditProfileState>(
                              listener: (context2, state1) {},
                              builder: (context2, state1) {
                                return state1 is EditProfileLoadingState
                                    ? CustomButton(
                                        onPressed: () {},
                                        text: '',
                                        child: CircularProgressIndicator.adaptive(
                                          backgroundColor: Colors.white,
                                        ),
                                      )
                                    : CustomButton(
                                        text: "Verify OTP",
                                        onPressed: () async {
                                          // bloc.callSuccess();
                                          if (bloc.otpController.text.trim().length != 4) {
                                            showToast("Please enter a valid 4-digit OTP");
                                            HapticFeedback.vibrate();
                                          } else {
                                            // setState(() {
                                            //   isLoading = true;
                                            // });
                                            var tempDate = Singleton.instance.tempRegData;
                                            log("${widget.isFromEditScreen}", name: "IS FROM EDIT");
                                            await bloc.verifyOtp(tempDate["ContactNo"],
                                                tempDate["ISDCode"], bloc.otpController.text.trim(),
                                                isFromEditScreen: widget.isFromEditScreen,
                                                bodyForUpdateProfile: widget.bodyForUpdateProfile,
                                                customerSiteId: widget.customerSiteId,
                                                isForDeleteAccount: widget.isForDeleteAccount);
                                            Future.delayed(Duration(seconds: 1));
                                            // setState(() {
                                            //   isLoading = false;
                                            // });
                                          }
                                        },
                                      );
                              },
                            )),
                        if (widget.isFromEditScreen == false || widget.isForDeleteAccount == false)
                          Center(
                            child: InkWell(
                              onTap: () {
                                NavigatorService.pushNamedAndRemoveUntil(AppRoutes.sendOtpScreen);
                              },
                              child: CustomText(
                                text: "Back to login",
                                style: CustomTextStyle.subtitleText.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: getSize(16),
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.primaryColorDark),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                    visible: state is SignInLoadingState || bloc.isLoading == true,
                    child: Container(
                      color: AppColors.primaryColorDark.withValues(alpha: .2),
                      child: CustomLoading(),
                    )),
              ],
            );
          },
        ),
      ),
    );
  }
}

_customErrorDialog(String status) async {
  return await customAlertDialog(
      message:
          "Your Registration request is $status approval and shall be processed shortly! Kindly WhatsApp us on +91 9930799799 for any urgent queries.",
      waitForDialogClose: true);
}

String formatTimer(int seconds) {
  int minutes = seconds ~/ 60;
  int remainingSeconds = seconds % 60;
  return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
}

String getLastTwoCharacters(String input) {
  if (input.length < 2) {
    return input; // Return the whole string if it's shorter than 2 characters.
  }
  return input.substring(input.length - 2);
}
