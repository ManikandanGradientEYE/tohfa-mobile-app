import '../../../export.dart';
import '../bloc/report_cubit.dart';
import '../bloc/report_state.dart';
import '../model/dispatch_status_model.dart';
import '../widget/report_screen_appbar.dart';

class DispatchStatusScreen extends StatelessWidget {
  const DispatchStatusScreen({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider<ReportCubit>(
      create: (context) => ReportCubit()..getDispatchStatus(),
      child: const DispatchStatusScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: reportScreenAppbar("Dispatch Status"),
      body: BlocBuilder<ReportCubit, ReportState>(
        builder: (context, state) {
          if (state is ReportErrorState) {
            return NoDataFoundView(
              message: state.errorMessage,
            );
          } else if (state is DispatchStatusSuccessState) {
            List<Datum> orderMemoList = state.dispatchStatusResModel.data ?? [];
            return orderMemoList.isEmpty
                ? const NoDataFoundView(
                    message: "No Dispatch Status Found",
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: orderMemoList.length,
                    itemBuilder: (context, index) {
                      Datum item = orderMemoList[index];

                      return Container(
                        padding: getPadding(all: 8),
                        child: Column(
                          spacing: getSize(5),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "LR Doc No: ${item.lrDocNo ?? "N/A"}",
                              style: CustomTextStyle.bodyText.copyWith(
                                color: AppColors.primaryText3,
                                fontSize: getSize(14),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            CustomText(
                              text: "LR Dated: ${item.lrDocDate ?? "N/A"}",
                              style: CustomTextStyle.bodyText.copyWith(
                                color: AppColors.primaryText3,
                                fontSize: getSize(14),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text:
                                      "Type: ${item.transactionType ?? "N/A"}",
                                  style: CustomTextStyle.bodyText.copyWith(
                                    fontSize: getSize(14),
                                    color: AppColors.primaryText4,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                CustomText(
                                  text:
                                      "Transporter: ${item.transporterName ?? "N/A"}",
                                  style: CustomTextStyle.bodyText.copyWith(
                                    fontSize: getSize(14),
                                    color: AppColors.primaryText4,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            CustomText(
                              text: "Value: ${item.transporterName ?? "N/A"}",
                              style: CustomTextStyle.bodyText.copyWith(
                                fontSize: getSize(14),
                                color: AppColors.primaryText4,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              spacing: getSize(10),
                              children: [
                                Expanded(
                                  child: CustomText(
                                    text: "Amt - ${item.totalAmount ?? "N/A"}",
                                    style: CustomTextStyle.bodyText.copyWith(
                                      fontSize: getSize(14),
                                      color: AppColors.primaryText4,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: CustomText(
                                    text: "Status - ${item.status ?? "N/A"}",
                                    style: CustomTextStyle.bodyText.copyWith(
                                      fontSize: getSize(14),
                                      color: AppColors.primaryText4,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomText(
                                  text: "Expires in 7 days",
                                  style: CustomTextStyle.bodyText.copyWith(
                                    fontSize: getSize(13),
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.primaryText4,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
          }
          return const CustomLoading();
        },
      ),
    );
  }
}
