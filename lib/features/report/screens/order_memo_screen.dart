import 'package:intl/intl.dart';

import '../../../export.dart';
import '../bloc/report_cubit.dart';
import '../bloc/report_state.dart';
import '../model/order_memo_model.dart';
import '../widget/report_screen_appbar.dart';

class OrderMemoScreen extends StatelessWidget {
  const OrderMemoScreen({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider<ReportCubit>(
      create: (context) => ReportCubit()..getOrderMemo(),
      child: const OrderMemoScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: reportScreenAppbar("Order Memo"),
      body: BlocBuilder<ReportCubit, ReportState>(
        builder: (context, state) {
          if (state is ReportErrorState) {
            return NoDataFoundView(
              message: state.errorMessage,
            );
          } else if (state is OrderMemoSuccessState) {
            final bloc = context.read<ReportCubit>();
            List<OrderMemo> orderMemoList = state.orderMemoModel.data ?? [];
            return Stack(
              children: [
                orderMemoList.isEmpty
                    ? const NoDataFoundView(
                        message: "No Order Memo Found",
                      )
                    : ListView.builder(
                        // separatorBuilder: (context, index) => const Divider(),
                        itemCount: orderMemoList.length,
                        itemBuilder: (context, index) {
                          OrderMemo item = orderMemoList[index];

                          String date = "N/A";
                          try {
                            final inputFormat = DateFormat("MM/dd/yyyy HH:mm:ss");
                            final outputFormat = DateFormat("dd MMMM yyyy");
                            final parsedDate = inputFormat.parse(item.orDate ?? "");
                            date = outputFormat.format(parsedDate);
                          } catch (e) {
                            logV("Error===>$e");
                            date = "N/A";
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: getPadding(all: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      // spacing: getSize(10),
                                      children: [
                                        Expanded(
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomText(
                                                text: "Order Memo No.",
                                                style: CustomTextStyle.bodyText.copyWith(
                                                  color: AppColors.primaryText3,
                                                  fontSize: getSize(14),
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              Expanded(
                                                child: CustomText(
                                                  text: item.orNo ?? "N/A",
                                                  style: CustomTextStyle.bodyText.copyWith(
                                                    color: AppColors.primaryText3,
                                                    fontSize: getSize(14),
                                                    overflow: TextOverflow.ellipsis,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Expanded(
                                        //   child: CustomText(
                                        //     text: "Order Memo No. ${item.orNo}",
                                        //     style:
                                        //         CustomTextStyle.bodyText.copyWith(
                                        //       color: AppColors.primaryText3,
                                        //       fontSize: getSize(14),
                                        //       fontWeight: FontWeight.w600,
                                        //     ),
                                        //   ),
                                        // ),

                                        ///Status builder
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),

                                    ///Date
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        CustomText(
                                          text: "Date - ",
                                          style: CustomTextStyle.bodyText.copyWith(
                                            color: AppColors.primaryText3,
                                            fontSize: getSize(14),
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        CustomText(
                                          text: date,
                                          style: CustomTextStyle.bodyText.copyWith(
                                            color: AppColors.primaryText3,
                                            fontSize: getSize(14),
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: null,
                                        ),
                                        Spacer(),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          padding: getPadding(all: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.white,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: CustomText(
                                            text: item.orStatus ?? "N/A",
                                            style: CustomTextStyle.bodyText.copyWith(
                                              fontSize: getSize(14),
                                              color: AppColors.primaryText4,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    // CustomText(
                                    //   text: "Date - $date",
                                    //   style: CustomTextStyle.bodyText.copyWith(
                                    //     fontSize: getSize(14),
                                    //     fontWeight: FontWeight.w500,
                                    //     color: AppColors.primaryText4,
                                    //   ),
                                    // ),

                                    ///Text :- [Quantity, Value] & Button :- [ Download pdf ]

                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      spacing: 20,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              text: "Quantity - ",
                                              style: CustomTextStyle.bodyText.copyWith(
                                                color: AppColors.primaryText3,
                                                fontSize: getSize(14),
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            CustomText(
                                              text: item.totalQty ?? "N/A",
                                              style: CustomTextStyle.bodyText.copyWith(
                                                color: AppColors.primaryText3,
                                                fontSize: getSize(14),
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: null,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              text: "Value - ",
                                              style: CustomTextStyle.bodyText.copyWith(
                                                color: AppColors.primaryText3,
                                                fontSize: getSize(14),
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            CustomText(
                                              text: item.totalGrossAmt ?? "N/A",
                                              style: CustomTextStyle.bodyText.copyWith(
                                                color: AppColors.primaryText3,
                                                fontSize: getSize(14),
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: null,
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Spacer(),
                                              InkWell(
                                                onTap: () {
                                                  bloc.downloadOrderMemo(
                                                      item.id.toString(), item.siteId.toString());
                                                },
                                                child: Container(
                                                  padding: getPadding(all: 4),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.white,
                                                    border: Border.all(
                                                      color: AppColors.green,
                                                    ),
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  child: CustomText(
                                                    text: "Download PDF",
                                                    style: CustomTextStyle.bodyText.copyWith(
                                                      fontSize: getSize(10),
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
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
                              ),
                              Divider(
                                thickness: 0.5,
                              ),
                            ],
                          );
                        },
                      ),
                Visibility(
                  visible: bloc.isLoading,
                  child: Container(
                    color: AppColors.black.withValues(alpha: .07),
                    child: CustomLoading(),
                  ),
                )
              ],
            );
          }
          return const CustomLoading();
        },
      ),
    );
  }
}
