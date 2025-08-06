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
                    : ListView.separated(
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: orderMemoList.length,
                        itemBuilder: (context, index) {
                          OrderMemo item = orderMemoList[index];

                          String date = "N/A";
                          try {
                            final inputFormat =
                                DateFormat("MM/dd/yyyy HH:mm:ss");
                            final outputFormat = DateFormat("dd MMMM yyyy");
                            final parsedDate =
                                inputFormat.parse(item.orDate ?? "");
                            date = outputFormat.format(parsedDate);
                          } catch (e) {
                            logV("Error===>$e");
                            date = "N/A";
                          }

                          return Container(
                            padding: getPadding(all: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  spacing: getSize(10),
                                  children: [
                                    Expanded(
                                      child: CustomText(
                                        text: "Order Memo No. ${item.orNo}",
                                        style:
                                            CustomTextStyle.bodyText.copyWith(
                                          color: AppColors.primaryText3,
                                          fontSize: getSize(14),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),

                                    ///Status builder
                                    Container(
                                      padding: getPadding(all: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: CustomText(
                                        text: item.orStatus ?? "N/A",
                                        style:
                                            CustomTextStyle.bodyText.copyWith(
                                          fontSize: getSize(14),
                                          color: AppColors.primaryText4,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  ],
                                ),

                                ///Date
                                CustomText(
                                  text: "Date - $date",
                                  style: CustomTextStyle.bodyText.copyWith(
                                    fontSize: getSize(14),
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primaryText4,
                                  ),
                                ),

                                ///Text :- [Quantity, Value] & Button :- [ Download pdf ]
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomText(
                                        text:
                                            "Quantity - ${item.totalQty ?? "N/A"}",
                                        style:
                                            CustomTextStyle.bodyText.copyWith(
                                          fontSize: getSize(14),
                                          color: AppColors.primaryText4,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: CustomText(
                                        text:
                                            "Value - ${item.totalGrossAmt ?? "N/A"}",
                                        style:
                                            CustomTextStyle.bodyText.copyWith(
                                          fontSize: getSize(14),
                                          color: AppColors.primaryText4,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Spacer(),
                                          InkWell(
                                            onTap: () {
                                              bloc.downloadOrderMemo(
                                                  item.id.toString(),
                                                  item.siteId.toString());
                                            },
                                            child: Container(
                                              padding: getPadding(all: 4),
                                              decoration: BoxDecoration(
                                                color: AppColors.white,
                                                border: Border.all(
                                                  color: AppColors.green,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: CustomText(
                                                text: "Download PDF",
                                                style: CustomTextStyle.bodyText
                                                    .copyWith(
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
