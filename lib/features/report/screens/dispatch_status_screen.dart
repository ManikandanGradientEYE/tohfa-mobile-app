import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

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
                              text:
                                  "LR Dated: ${dateFormate(item.lrDocDate ?? "N/A")}",
                              style: CustomTextStyle.bodyText.copyWith(
                                color: AppColors.primaryText3,
                                fontSize: getSize(14),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  spacing: getSize(5),
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      child: CustomText(
                                        text:
                                            "Type: ${item.transactionType ?? "N/A"}",
                                        style:
                                            CustomTextStyle.bodyText.copyWith(
                                          fontSize: getSize(14),
                                          color: AppColors.primaryText4,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      child: CustomText(
                                        text:
                                            "Value: ${item.declarationAmount ?? "N/A"}",
                                        style:
                                            CustomTextStyle.bodyText.copyWith(
                                          fontSize: getSize(14),
                                          color: AppColors.primaryText4,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      child: CustomText(
                                        text:
                                            "Remarks - ${item.remarks ?? "N/A"}",
                                        style:
                                            CustomTextStyle.bodyText.copyWith(
                                          fontSize: getSize(14),
                                          color: AppColors.primaryText4,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 8,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: CustomText(
                                        text:
                                            "Transporter: ${item.transporterName ?? "N/A"}",
                                        style:
                                            CustomTextStyle.bodyText.copyWith(
                                          fontSize: getSize(14),
                                          color: AppColors.primaryText4,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        List<String> images =
                                            item.documentUrl!.split(',');
                                        bool permissionGranted =
                                            await requestStoragePermission();

                                        if (!permissionGranted) {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Storage/Photo permission not granted");
                                          return;
                                        }

                                        await downloadImagesToDevice(
                                            context, images);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                width: 1, color: Colors.green),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 5),
                                          child: Center(
                                            child: Text("Download LR"),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
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

Future<bool> requestStoragePermission() async {
  if (Platform.isAndroid) {
    if (await Permission.storage.isGranted) {
      return true;
    }

    // Request if not granted
    final status = await Permission.storage.request();
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


  Future<void> downloadImagesToDevice(
      BuildContext context, List<String> imageUrls) async {
    try {
      final Dio dio = Dio();
      bool allSuccess = true;

      for (int i = 0; i < imageUrls.length; i++) {
        final url = imageUrls[i].trim();
        final response = await dio.get(url,
            options: Options(responseType: ResponseType.bytes));

        final result = await ImageGallerySaverPlus.saveImage(response.data);

        if (result['isSuccess'] != true) {
          allSuccess = false;
          log('Failed to save image: $url');
        } else {
          log('Saved image: $url, path: ${result['filePath']}');
        }
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
