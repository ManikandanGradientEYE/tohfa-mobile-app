import 'package:intl/intl.dart';

import '../../../export.dart';
import '../bloc/report_cubit.dart';
import '../bloc/report_state.dart';
import '../model/order_memo_model.dart';
import '../model/past_food_order_res_model.dart';
import '../widget/report_screen_appbar.dart';

class PastFoodOrderScreen extends StatelessWidget {
  const PastFoodOrderScreen({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider<ReportCubit>(
      create: (context) => ReportCubit()..getPastFoodOrder(),
      child: const PastFoodOrderScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: reportScreenAppbar("Past Food Order"),
      body: BlocBuilder<ReportCubit, ReportState>(
        builder: (context, state) {
          if (state is ReportErrorState) {
            return NoDataFoundView(
              message: state.errorMessage,
            );
          } else if (state is PastFoodOrderSuccessState) {
            List<PastOrderFood> orderMemoList =
                state.pastFoodOrderResModel.data ?? [];
            return orderMemoList.isEmpty
                ? const NoDataFoundView(
                    message: "No Past Food Orders Found",
                  )
                : ListView.builder(
                    // separatorBuilder: (context, index) => const Divider(),
                    itemCount: orderMemoList.length,
                    itemBuilder: (context, index) {
                      PastOrderFood item = orderMemoList[index];

                      String date = "N/A";
                      try {
                        final inputFormat = DateFormat("MM/dd/yyyy HH:mm:ss");
                        final outputFormat = DateFormat("dd MMMM yyyy");
                        final parsedDate =
                            inputFormat.parse(item.foodOrderDate ?? "");
                        date = outputFormat.format(parsedDate);
                      } catch (e) {
                        logV("Error===>$e");
                        date = "N/A";
                      }

                      return Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: getPadding(all: 8),
                            child: Column(
                              spacing: getSize(5),
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  spacing: getSize(10),
                                  children: [
                                    Expanded(
                                      child: CustomText(
                                        text: item.foodMenuName ?? "N/A",
                                        style: CustomTextStyle.bodyText.copyWith(
                                          color: AppColors.primaryText3,
                                          fontSize: getSize(14),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: "Token No - ",
                                          style: CustomTextStyle.bodyText.copyWith(
                                            color: AppColors.primaryText3,
                                            fontSize: getSize(14),
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        CustomText(
                                          text: item.foodOrderNo ?? "N/A",
                                          style: CustomTextStyle.bodyText.copyWith(
                                            color: AppColors.primaryText3,
                                            fontSize: getSize(14),
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: null,
                                        ),
                                      ],
                                    ),
                          //
                                  ],
                                ),
                          
                                ///Date
                                ///
                          
                                Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Date Column
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: "Date - ",
                                      style: CustomTextStyle.bodyText.copyWith(
                                        color: AppColors.primaryText3,
                                        fontSize: getSize(14),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Flexible(
                                      child: CustomText(
                                        text: date,
                                        style: CustomTextStyle.bodyText.copyWith(
                                          color: AppColors.primaryText3,
                                          fontSize: getSize(14),
                                          fontWeight: FontWeight.w600,overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 2, // allow wrapping
                                       
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          
                              /// Order Status Column
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: "Order Status - ",
                                      style: CustomTextStyle.bodyText.copyWith(
                                        color: AppColors.primaryText3,
                                        fontSize: getSize(14),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Flexible(
                                      child: CustomText(
                                        text: item.itemDelvStatus ?? "N/A",
                                        style: CustomTextStyle.bodyText.copyWith(
                                          color: AppColors.primaryText3,
                                          fontSize: getSize(14),
                                          fontWeight: FontWeight.w600,overflow:  TextOverflow.ellipsis,
                                        ),
                                        maxLines: 2,
                                       
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
                  );
          }
          return const CustomLoading();
        },
      ),
    );
  }
}
