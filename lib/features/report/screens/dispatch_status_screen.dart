import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';

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

  String dateFormate(String dateString) {
    DateTime date = DateFormat('MM/dd/yyyy HH:mm:ss').parse(dateString);
    return DateFormat('dd/MM/yyyy').format(date);
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
                : ListView.builder(
                    // separatorBuilder: (context, index) => const Divider(),
                    itemCount: orderMemoList.length,
                    itemBuilder: (context, index) {
                      Datum item = orderMemoList[index];

                      return Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: getPadding(all: 8),
                            child: Column(
                              spacing: getSize(5),
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                      Row(
                                          children: [
                                            CustomText(
                                              text: "LR No: ",
                                              style:
                                                  CustomTextStyle.bodyText.copyWith(
                                                color: AppColors.primaryText3,
                                                fontSize: getSize(14),
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            CustomText(
                                              text: item.refDocNo ?? "N/A",
                                              style:
                                                  CustomTextStyle.bodyText.copyWith(
                                                color: AppColors.primaryText3,
                                                fontSize: getSize(14),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                    // CustomText(
                                    //   text: "LR No: ${item.refDocNo ?? "N/A"}",
                                    //   style: CustomTextStyle.bodyText.copyWith(
                                    //     color: AppColors.primaryText3,
                                    //     fontSize: getSize(14),
                                    //     fontWeight: FontWeight.w600,
                                    //   ),
                                    // ),
                          
                                    
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.35,
                                      child: Row(
                                          children: [
                                            CustomText(
                                              text: "Dated: ",
                                              style:
                                                  CustomTextStyle.bodyText.copyWith(
                                                color: AppColors.primaryText3,
                                                fontSize: getSize(14),
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            CustomText(
                                              text: dateFormate(item.refDocDate ?? "N/A"),
                                              style:
                                                  CustomTextStyle.bodyText.copyWith(
                                                color: AppColors.primaryText3,
                                                fontSize: getSize(14),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ),
                                  ],
                                ),
                                getSizeBox(height: 1),
                                Row(
                                          children: [
                                            CustomText(
                                              text: "Transporter: ",
                                              style:
                                                  CustomTextStyle.bodyText.copyWith(
                                                color: AppColors.primaryText3,
                                                fontSize: getSize(14),
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            CustomText(
                                              text: item.transporterName ?? "N/A",
                                              style:
                                                  CustomTextStyle.bodyText.copyWith(
                                                color: AppColors.primaryText3,
                                                fontSize: getSize(14),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                // CustomText(
                                //   text: "Transporter: ${item.transporterName ?? "N/A"}",
                                //   style: CustomTextStyle.bodyText.copyWith(
                                //     fontSize: getSize(14),
                                //     color: AppColors.primaryText4,
                                //     fontWeight: FontWeight.w500,
                                //   ),
                                // ),
                                getSizeBox(height: 1),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                          children: [
                                            CustomText(
                                              text: "Type: ",
                                              style:
                                                  CustomTextStyle.bodyText.copyWith(
                                                color: AppColors.primaryText3,
                                                fontSize: getSize(14),
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            CustomText(
                                              text: item.transactionType ?? "N/A",
                                              style:
                                                  CustomTextStyle.bodyText.copyWith(
                                                color: AppColors.primaryText3,
                                                fontSize: getSize(14),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                    // CustomText(
                                    //   text: "Type: ${item.transactionType ?? "N/A"}",
                                    //   style: CustomTextStyle.bodyText.copyWith(
                                    //     fontSize: getSize(14),
                                    //     color: AppColors.primaryText4,
                                    //     fontWeight: FontWeight.w500,
                                    //   ),
                                    // ),
                          
                                     
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.35,
                                      child: Row(
                                          children: [
                                            CustomText(
                                              text: "Value: ",
                                              style:
                                                  CustomTextStyle.bodyText.copyWith(
                                                color: AppColors.primaryText3,
                                                fontSize: getSize(14),
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            CustomText(
                                              text: "${item.declarationAmount ?? "N/A"}",
                                              style:
                                                  CustomTextStyle.bodyText.copyWith(
                                                color: AppColors.primaryText3,
                                                fontSize: getSize(14),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),),
                                  ],
                                ),
                                getSizeBox(height: 1),
                          
                             Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "Remarks - ",
                                style: CustomTextStyle.bodyText.copyWith(
                                  color: AppColors.primaryText3,
                                  fontSize: getSize(14),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Expanded(
                                child: CustomText(
                                  text: item.remarks ?? "N/A",
                                  style: CustomTextStyle.bodyText.copyWith(
                                    color: AppColors.primaryText3,
                                    fontSize: getSize(14),
                                    fontWeight: FontWeight.w600,
                                  ),
                                 
                                  maxLines: null,
                               
                                ),
                              ),
                            ],
                          ),
                                // CustomText(
                                //   text: "Remarks - ${item.remarks ?? "N/A"}",
                                //   style: CustomTextStyle.bodyText.copyWith(
                                //     fontSize: getSize(14),
                                //     color: AppColors.primaryText4,
                                //     fontWeight: FontWeight.w500,
                                //   ),
                                // ),
                                getSizeBox(height: 1),
                                Wrap(
                                  children: List.generate(
                                    item.documentUrl!.split(',').length,
                                    (index) => InkWell(
                                      onTap: () async {
                                        await downloadImagesToDevice(
                                            context, item.documentUrl!.split(',')[index]);
                                      },
                                      child: CustomText(
                                        text: item.documentUrl!.split(',').length == index + 1
                                            ? "Download LR${index + 1}"
                                            : index == 0
                                                ? "Download LR   |   "
                                                : "Download LR${index + 1}   |   ",
                                        style: TextStyle(
                                          fontSize: getSize(15),
                                          color: AppColors.primaryText4,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
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

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.isGranted) {
        return true;
      }

      // Request if not granted
      final status = await Permission.photos.request();
      return status.isGranted;
    } else if (Platform.isIOS) {
      if (await Permission.photosAddOnly.isGranted) {
        return true;
      }

      final status = await Permission.photosAddOnly.request();
      return status.isGranted;
    }

    return true;
  }

  Future<void> downloadImagesToDevice(BuildContext context, String imageUrls) async {
    try {
      final Dio dio = Dio();
      bool allSuccess = true;

      final response = await dio.get(imageUrls, options: Options(responseType: ResponseType.bytes));

      final result = await ImageGallerySaverPlus.saveImage(response.data);

      if (result['isSuccess'] != true) {
        allSuccess = false;
        log('Failed to save image: $imageUrls');
      } else {
        log('Saved image: $imageUrls, path: ${result['filePath']}');
      }

      if (allSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Images downloaded successfully to gallery')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Some images failed to download')),
        );
      }
    } catch (e) {
      log('Download error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading images')),
      );
    }
  }
}
