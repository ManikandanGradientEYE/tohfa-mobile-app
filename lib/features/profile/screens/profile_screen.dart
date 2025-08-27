import 'package:demo/core/widgets/custom_drop_down.dart';
import 'package:demo/export.dart';
import 'package:demo/features/auth/sign_in/presentation/bloc/sign_in_cubit.dart';
import 'package:demo/features/auth/sign_in/presentation/bloc/sign_in_state.dart';

import '../bloc/profile_bloc_cubit.dart';
import '../bloc/profile_bloc_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static Widget builder(BuildContext context) {
    logV("ProfileScreen");
    return BlocProvider(
      create: (context) => ProfileBlocCubit()..getProfile(),
      child: ProfileScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List list = [
      {
        "title": "Settings",
        "route": AppRoutes.settingScreen,
        "image": ImageConstants.icSetting,
      },
      {
        "title": "Contact Us",
        "route": AppRoutes.contactUsScreen,
        "image": ImageConstants.phone,
      },

      // {
      //   "title": "Generate Token",
      //   "image": ImageConstants.ticket,
      // },
      {
        "title": "Logout",
        "image": ImageConstants.logout,
      },
      {
        "title": "Delete Account",
        "image": ImageConstants.bin,
      },
      // {
      //   "title": "Invoice",
      //   "route": AppRoutes.invoiceScreen,
      // },
      // {
      //   "title": "Past Food Orders",
      //   "route": AppRoutes.pastFoodOrderScreen,
      // },
    ];
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: BlocConsumer<ProfileBlocCubit, ProfileBlocState>(
        listener: (context, state) {
          final bloc = context.read<ProfileBlocCubit>();
          if (state is DropDownValueChangeState) {
            if (state.isCustomerSite) {
              bloc.selectedVisitStuts = state.value;
            } else {
              bloc.selectedSection = state.value;
            }
          }

          if (state is ProfileSectionDataState) {
            bloc.sectionModel = state.sectionModel;
          }
          if (state is ProfileVisitStatusState) {
            bloc.visitStatusModel = state.visitStatusModel;
          }
        },
        builder: (profileContext, state) {
          final bloc = profileContext.read<ProfileBlocCubit>();

          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: getPadding(all: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomText(
                                  text: Singleton.instance.userData?.customerName ?? "N/A",
                                  style: CustomTextStyle.normalText.copyWith(
                                      color: Color(0xFF606060),
                                      fontWeight: FontWeight.w400,
                                      fontSize: getSize(18)),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  final data =
                                      await NavigatorService.pushNamed(AppRoutes.editProfileScreen);
                                  if (data != null) {
                                    context.read<ProfileBlocCubit>().getProfile();
                                  }
                                },
                                child: Container(
                                  padding: getPadding(all: 5),
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle, color: AppColors.white),
                                  child: Icon(
                                    Icons.remove_red_eye,
                                    color: Color(0xFF606060),
                                    size: getSize(18),
                                  ),
                                ),
                              )
                            ],
                          ),
                          // CustomText(
                          //   textAlign: TextAlign.center,
                          //   text: Singleton.instance.userData?.customerBillEmail ?? "N/A",
                          //   style: CustomTextStyle.normalText.copyWith(
                          //       color: Color(0xFF656565),
                          //       fontWeight: FontWeight.w400,
                          //       fontSize: getSize(13)),
                          // ),
                          getSizeBox(height: 10),
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: Row(
                          //         children: [
                          //           Container(
                          //             padding: getPadding(all: 8),
                          //             decoration: BoxDecoration(
                          //                 color: AppColors.whiteText,
                          //                 borderRadius: BorderRadius.circular(
                          //                     getSize(3))),
                          //             child: CustomText(
                          //               text: "50% profile completed",
                          //               style: CustomTextStyle.normalText
                          //                   .copyWith(
                          //                       color: Color(0xFF9E9C9C),
                          //                       fontWeight: FontWeight.w400,
                          //                       fontSize: getSize(12)),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          // if (bloc.customerSiteModel.length > 1)
                          //   Expanded(
                          //     child: customDropDown2(
                          //       bloc.customerSiteModel,
                          //       (p0) => p0.customerSiteName??"",
                          //       customLabel: SizedBox(),
                          //       onChanged: (value) async {
                          //         await SharedPref.instance.setUserData(value!);
                          //         bloc.getProfile();
                          //       },
                          //       valueText: bloc.selectedModel?.customerSiteName
                          //     ),
                          //   )
                          //   ],
                          // ),
                          customDropDown2(bloc.customerSiteModel, (p0) => p0.customerSiteName ?? "",
                              customLabel: SizedBox(), onChanged: (value) async {
                            await SharedPref.instance.setUserData(value!);
                            // Singleton.instance.appInit();
                            bloc.getProfile();
                          }, valueText: bloc.selectedModel?.customerSiteName),
                          getSizeBox(height: 10),
                          Row(
                            spacing: getSize(15),
                            children: [
                              Container(
                                padding: getPadding(all: 8),
                                decoration: BoxDecoration(
                                    color: AppColors.whiteText,
                                    borderRadius: BorderRadius.circular(getSize(3))),
                                child: CustomText(
                                  text:
                                      "TIER : ${Singleton.instance.userOtherData?.tierName == null || Singleton.instance.userOtherData!.tierName.toString().isEmpty ? "N/A" : Singleton.instance.userOtherData!.tierName.toString()}",
                                  textAlign: TextAlign.center,
                                  style: CustomTextStyle.normalText.copyWith(
                                      color: Color(0xFF656565),
                                      fontWeight: FontWeight.w500,
                                      fontSize: getSize(14)),
                                ),
                              ),
                              // Container(
                              //   padding: getPadding(all: 8),
                              //   decoration: BoxDecoration(
                              //       color: AppColors.whiteText,
                              //       borderRadius:
                              //           BorderRadius.circular(getSize(3))),
                              //   child: CustomText(
                              //     text:
                              //         "Total Purchase Value: \n${Singleton.instance.userOtherData?.totalPurchaseValue ?? "N/A"} ",
                              //     textAlign: TextAlign.center,
                              //     style: CustomTextStyle.normalText.copyWith(
                              //         color: Color(0xFF656565),
                              //         fontWeight: FontWeight.w500,
                              //         fontSize: getSize(14)),
                              //   ),
                              // ),
                            ],
                          )
                        ],
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      primary: false,
                      separatorBuilder: (context, index) => Divider(
                        color: AppColors.textGrey5.withValues(alpha: .33),
                        height: getSize(5),
                      ),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: getPadding(all: 8),
                          child: InkWell(
                            onTap: () async {
                              if (list[index]['route'] != null) {
                                Navigator.pushNamed(context, list[index]['route']);
                              } else if (list[index]['title'] == "Logout") {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: AppColors.bgColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      title: Text("Logout"),
                                      content: Text("Are you sure you want to logout?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            SharedPref.instance.logOut();
                                            Navigator.pushReplacementNamed(
                                                context, AppRoutes.sendOtpScreen);
                                          },
                                          child: Text("Logout"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else if (list[index]['title'] == "Delete Account") {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: AppColors.bgColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      title: Text("Delete Account"),
                                      content:
                                          Text("Are you sure you want to delete your account?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("No"),
                                        ),
                                        BlocProvider<SignInCubit>(
                                          create: (context) => SignInCubit(false),
                                          child: BlocConsumer<SignInCubit, SignInState>(
                                              listener: (context, state1) {
                                            if (state1 is SignInSuccessState) {
                                              log("=---=-=-==- ${state1.loginResponse.length}");
                                            }
                                          }, builder: (context, state1) {
                                            return TextButton(
                                              onPressed: () {
                                                final bloc1 = context.read<SignInCubit>();
                                                var contactNo =
                                                    bloc.selectedModel!.ogContactNo.toString();
                                                // var contactNo = "";
                                                // if (state1 is SignInSuccessState) {
                                                //   log("=--=- ${state1.loginResponse.length}");
                                                // }
                                                // for (var i = 0;
                                                //     i < bloc1.loginResponse.length;
                                                //     i++) {
                                                //   log("=--=- ${bloc1.loginResponse[i].id}");
                                                //   if (bloc1.loginResponse[i].id ==
                                                //       bloc.selectedModel!.customerId) {
                                                //     contactNo = bloc1.loginResponse[i].contactNo;
                                                //
                                                //     break;
                                                //   }
                                                // }
                                                var contactCode =
                                                    bloc.selectedModel!.customerShipIsdCode ??
                                                        "+91";
                                                log(contactNo, name: "CUSTOMER CONTACT NO");
                                                log("$contactCode", name: "CUSTOMER CONTACT CODE");

                                                bloc1.sendOtp(
                                                  contactNo,
                                                  contactCode ?? "+91",
                                                  isForDeleteAccount: true,
                                                  customerSiteId: bloc.selectedModel!.id,
                                                  context: context,
                                                );

                                                // var customerSiteId = bloc.selectedModel!.id;
                                                // log("$customerSiteId",
                                                //     name: "DELETE ACCOUNT CUSTOMER SITE ID");
                                                // bloc.deleteAccount(customerSiteId: customerSiteId);

                                                // Navigator.of(context).pop();
                                                // SharedPref.instance.logOut();
                                                // Navigator.pushReplacementNamed(
                                                //     context, AppRoutes.sendOtpScreen);
                                              },
                                              child: Text(
                                                "Yes",
                                              ),
                                            );
                                          }),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                await bloc.getvisitStatus(customerSiteId: bloc.selectedModel?.id);

                                if (bloc.visitStatusModel.isNotEmpty) {
                                  await bloc.getAllSections(
                                      siteId: bloc.visitStatusModel.first.siteId.toString());
                                  bloc.selectedVisitStutsId =
                                      bloc.visitStatusModel.first.siteId.toString();
                                  bloc.selectedVisitStuts =
                                      bloc.visitStatusModel.first.siteName.toString();
                                }
                                if (bloc.sectionModel.isNotEmpty) {
                                  bloc.selectedSection = bloc.sectionModel.first.text.toString();
                                  bloc.selectedSectionId = bloc.sectionModel.first.value.toString();
                                }

                                if (bloc.visitStatusModel.isEmpty) {
                                  showInSnackBar("Need to visit Site to Generate Tokens", context);
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(builder: (context, setState) {
                                          return Dialog(
                                            insetPadding: EdgeInsets.symmetric(horizontal: 15),
                                            backgroundColor: AppColors.bgColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0, right: 5.0, top: 15.0, bottom: 15),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: 5.0, bottom: 15),
                                                      child: CustomText(
                                                        text: "Create New Token",
                                                        style: CustomTextStyle.bodyText.copyWith(
                                                          color: AppColors.blackText,
                                                          fontSize: getSize(16),
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(
                                                          horizontal: 5.0),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                              children: [
                                                                CustomText(
                                                                  text: "Site :",
                                                                  style: CustomTextStyle.bodyText
                                                                      .copyWith(
                                                                    color: AppColors.blackText,
                                                                    fontSize: getSize(15),
                                                                    fontWeight: FontWeight.w400,
                                                                  ),
                                                                ),
                                                                getSizeBox(height: 2),
                                                                customDropDown2(
                                                                  bloc.visitStatusModel,
                                                                  (p0) => p0.siteName ?? "",
                                                                  customLabel: SizedBox(),
                                                                  defaultHintText: "Select Site",
                                                                  onChanged: (value) async {
                                                                    bloc.sectionModel.clear();
                                                                    await bloc.getAllSections(
                                                                        siteId: value!.siteId
                                                                            .toString());
                                                                    bloc.onDropDownValueChange(
                                                                        value: value.siteName
                                                                            .toString(),
                                                                        isCustomerSite: true);

                                                                    bloc.selectedVisitStutsId =
                                                                        value.siteId.toString();
                                                                    if (bloc
                                                                        .sectionModel.isNotEmpty) {
                                                                      bloc.selectedSection = bloc
                                                                          .sectionModel.first.text
                                                                          .toString();
                                                                    }
                                                                    setState(
                                                                      () {},
                                                                    );
                                                                  },
                                                                  valueText:
                                                                      bloc.selectedVisitStuts,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          getSizeBox(width: 5),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                              children: [
                                                                CustomText(
                                                                  text: "Section :",
                                                                  style: CustomTextStyle.bodyText
                                                                      .copyWith(
                                                                    color: AppColors.blackText,
                                                                    fontSize: getSize(15),
                                                                    fontWeight: FontWeight.w400,
                                                                  ),
                                                                ),
                                                                getSizeBox(height: 2),
                                                                customDropDown2(
                                                                  bloc.sectionModel,
                                                                  (p0) => p0.text.toString(),
                                                                  customLabel: SizedBox(),
                                                                  onChanged: (value) async {
                                                                    bloc.onDropDownValueChange(
                                                                        value:
                                                                            value!.text.toString(),
                                                                        isCustomerSite: false);

                                                                    bloc.selectedSectionId =
                                                                        value.value.toString();
                                                                    setState(
                                                                      () {},
                                                                    );
                                                                  },
                                                                  valueText:
                                                                      bloc.selectedSection.isEmpty
                                                                          ? "Select"
                                                                          : bloc.selectedSection,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    getSizeBox(height: 25),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () async {
                                                            String generatedToken =
                                                                await bloc.generateToken(
                                                                    customerSite:
                                                                        bloc.selectedModel!.id,
                                                                    sectionId:
                                                                        bloc.selectedSectionId,
                                                                    siteId:
                                                                        bloc.selectedVisitStutsId);
                                                            Navigator.pop(context);
                                                            customAlertDialog(
                                                                title: "Token",
                                                                message:
                                                                    "Your generated token is $generatedToken");
                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets.only(right: 10),
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(10),
                                                              color: AppColors.green,
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(
                                                                  horizontal: 15.0, vertical: 8),
                                                              child: CustomText(
                                                                text: "Generate",
                                                                style: CustomTextStyle.bodyText
                                                                    .copyWith(
                                                                  color: AppColors.whiteText,
                                                                  fontSize: getSize(15),
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                      });
                                }
                              }
                            },
                            child: Row(
                              spacing: getSize(10),
                              children: [
                                list[index]['title'] == "Delete"
                                    ? Container(
                                        height: getSize(48),
                                        width: getSize(48),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF9F6F6).withValues(alpha: .27),
                                          borderRadius: BorderRadius.circular(getSize(8)),
                                          border: Border.all(
                                            color: Color(0xfffbdb6b6).withValues(alpha: .15),
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: getSize(26),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: getSize(48),
                                        width: getSize(48),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF9F6F6).withValues(alpha: .27),
                                          borderRadius: BorderRadius.circular(getSize(8)),
                                          border: Border.all(
                                            color: Color(0xfffbdb6b6).withValues(alpha: .15),
                                          ),
                                        ),
                                        child: Center(
                                          child: CustomImageView(
                                            imagePath: list[index]['image'],
                                            height: getSize(26),
                                            width: getSize(26),
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                Expanded(
                                  child: CustomText(
                                    text: list[index]['title'],
                                    style: CustomTextStyle.bodyText.copyWith(
                                      color: AppColors.textGrey5,
                                      fontSize: getSize(16),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: state is ProfileLoadingState,
                child: Container(
                  color: AppColors.black.withValues(alpha: .07),
                  child: CustomLoading(),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
