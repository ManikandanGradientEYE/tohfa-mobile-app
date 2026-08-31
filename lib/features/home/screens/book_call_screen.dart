import 'package:demo/export.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ZohoBookingEmbed extends StatefulWidget {
  const ZohoBookingEmbed({super.key});

  @override
  State<ZohoBookingEmbed> createState() => _ZohoBookingEmbedState();
}

class _ZohoBookingEmbedState extends State<ZohoBookingEmbed> {
  late final WebViewController _controller;

  bool _isLoading = true;
  int _selectedIndex = 0;
  bool _showWebView = false;
  String? _webViewUrl;
  load() async {
    await context.read<HomeCubit>().getAllMeeting(Singleton.instance.userData?.id ?? '');
  }

  String encodedName = Uri.encodeComponent(Singleton.instance.userData!.customerName);
  String encodedEmail = Uri.encodeComponent(
      Singleton.instance.userData!.customerBillEmail.toString() != ""
          ? Singleton.instance.userData!.customerBillEmail
          : "info@tohfajewellery.in");

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    final siteId = Singleton.instance.userData?.id ?? '';
    context.read<HomeCubit>().customerRequestLink == null
        ? context.read<HomeCubit>().getcustomerRequest(siteId)
        : null;
    log("${Singleton.instance.userData!.customerName}", name: "USER NAME");
    log("${Singleton.instance.userData!.customerBillEmail.toString() != "" ? Singleton.instance.userData!.customerBillEmail : "info@tohfajewellery.in"}",
        name: "USER EMAIL");
    super.initState();
    load();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              setState(() => _isLoading = false);
            }
          },
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) async {
            setState(() => _isLoading = false);
            await _controller.runJavaScript(
                '''
                document.documentElement.style.height = "100%";
                document.documentElement.style.margin = "0";
                document.body.style.height = "100%";
                document.body.style.margin = "0";
                document.body.innerHTML = `<iframe src="https://calendly.com/d/csxh-3tn-xqs?name=$encodedName&email=$encodedEmail&a1=8087382829&a2=GE%20Technologies" style="width:100%;height:100vh;border:0;display:block;"></iframe>`;
                ''');
            if (url.contains("confirmation") || url.contains("success")) {
              setState(() {
                _showWebView = false;
                _webViewUrl = null;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            setState(() => _isLoading = false);
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.bgColor,
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    setState(() {
                      _selectedIndex = 0;
                    });
                    await load();

                    setState(() {
                      _showWebView = false;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: _selectedIndex == 0 ? const Color(0xffE6DED4) : Colors.transparent,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                      child: Center(
                        child: CustomText(
                          text: "Upcoming Video Calls",
                          style: CustomTextStyle.bodyText.copyWith(
                            fontSize: getSize(15),
                            color: AppColors.grey.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                BlocListener<HomeCubit, HomeState>(
                  listener: (context, state) {
                    if (state is CustomerRequestSuccessState) {
                      setState(() {
                        _webViewUrl = state.link;
                        _showWebView = true;
                      });

                      _controller.loadRequest(Uri.parse(state.link));
                    } else if (state is HomeErrorState) {}
                  },
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                      // final siteId = Singleton.instance.userData?.id ?? '';
                      // context.read<HomeCubit>().getcustomerRequest(siteId);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: _selectedIndex == 1 ? const Color(0xffE6DED4) : Colors.transparent,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                        child: Center(
                            child: CustomText(
                          text: "Schedule Video Call",
                          style: CustomTextStyle.bodyText.copyWith(
                            fontSize: getSize(15),
                            color: AppColors.grey.withOpacity(0.5),
                            fontWeight: FontWeight.w400,
                          ),
                        )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            if (_selectedIndex == 1)
              _webViewUrl != null
                  ? Expanded(
                      child: WebViewWidget(
                        controller: _controller,
                        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                          Factory<OneSequenceGestureRecognizer>(
                            () => EagerGestureRecognizer(),
                          ),
                        },
                      ),
                    )
                  : CustomLoading(),
            // SizedBox(
            //     height: MediaQuery.of(context).size.height * 0.2,
            //     child: Center(
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           CustomText(
            //             text: "Schedule Video Call Meeting",
            //             style: CustomTextStyle.bodyText.copyWith(
            //               fontSize: getSize(14.5),
            //               color: AppColors.grey.withOpacity(0.7),
            //               fontWeight: FontWeight.w500,
            //             ),
            //           ),
            //           const SizedBox(height: 20),
            //           BlocListener<HomeCubit, HomeState>(
            //             listener: (context, state) {
            //               if (state is CustomerRequestSuccessState) {
            //                 setState(() {
            //                   _webViewUrl = state.link;
            //                   _showWebView = true;
            //                 });
            //                 _controller
            //                     .loadRequest(Uri.parse(state.link));
            //               } else if (state is HomeErrorState) {}
            //             },
            //             child: InkWell(
            //               onTap: () {
            //                 final siteId =
            //                     Singleton.instance.userData?.id ?? '';
            //                 context
            //                     .read<HomeCubit>()
            //                     .getcustomerRequest(siteId);
            //               },
            //               child: Container(
            //                 decoration: BoxDecoration(
            //                   color: const Color(0xff97948E),
            //                   borderRadius: BorderRadius.circular(5),
            //                 ),
            //                 padding: const EdgeInsets.symmetric(
            //                     horizontal: 15, vertical: 5),
            //                 child: CustomText(
            //                   text: "Schedule Video Call",
            //                   style: CustomTextStyle.bodyText.copyWith(
            //                     fontSize: getSize(14),
            //                     color: AppColors.white,
            //                     fontWeight: FontWeight.w500,
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           )
            //         ],
            //       ),
            //     ),
            //   ),

            if (_selectedIndex == 0)
              Expanded(
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    final meetings = context.read<HomeCubit>().meetingsList;

                    if (meetings == null || meetings.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "No Video Call Scheduled",
                              style: CustomTextStyle.bodyText.copyWith(
                                fontSize: getSize(14.5),
                                color: AppColors.grey.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                // final siteId =
                                //     Singleton.instance.userData?.id ?? '';
                                // context
                                //     .read<HomeCubit>()
                                //     .getcustomerRequest(siteId);

                                setState(() {
                                  _selectedIndex = 1;
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                decoration: BoxDecoration(
                                  color: const Color(0xff97948E),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: Center(
                                  child: CustomText(
                                    text: "Schedule Video Call",
                                    style: CustomTextStyle.bodyText.copyWith(
                                      fontSize: getSize(14),
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: meetings.length,
                      itemBuilder: (context, index) {
                        final meeting = meetings[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Card(
                            elevation: 0.5,
                            shadowColor: AppColors.black.withOpacity(0.5),
                            color: AppColors.bgColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15),
                              child: Column(
                                children: [
                                  _buildRow(
                                      "Date :", formatDateWithSuffix(meeting.startDate.toString())),
                                  _buildRow(
                                      "Time :",
                                      formatTimeRange(meeting.startTime.toString(),
                                          meeting.endTime.toString())),
                                  _buildRow("Section :", meeting.section),
                                  const SizedBox(height: 12),
                                  GestureDetector(
                                    onTap: () async {
                                      String url = meeting.meetingUrl;
                                      if (await canLaunchUrl(Uri.parse(url))) {
                                        await launchUrl(Uri.parse(url),
                                            mode: LaunchMode.inAppBrowserView);
                                      } else {
                                        log('Could not launch $url');
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.6,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff97948E),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                      child: Center(
                                        child: CustomText(
                                          text: "Join Meeting",
                                          style: CustomTextStyle.bodyText.copyWith(
                                            fontSize: getSize(14),
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ));
  }

  Widget _buildRow(String label, String? value) {
    return Row(
      children: [
        CustomText(
          text: label,
          style: CustomTextStyle.bodyText.copyWith(
            fontSize: getSize(14.5),
            color: AppColors.grey.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        CustomText(
          text: value ?? "-",
          style: CustomTextStyle.bodyText.copyWith(
            fontSize: getSize(14.5),
            color: AppColors.grey.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String formatDateWithSuffix(String dateStr) {
    final date = DateTime.parse(dateStr);
    final day = date.day;
    final suffix = _getDaySuffix(day);
    final monthYear = DateFormat("MMMM yyyy").format(date);
    return "$day$suffix $monthYear";
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return "th";
    switch (day % 10) {
      case 1:
        return "st";
      case 2:
        return "nd";
      case 3:
        return "rd";
      default:
        return "th";
    }
  }

  String formatTimeRange(String startTimeStr, String endTimeStr) {
    final start = DateTime.parse(startTimeStr).toLocal();
    final end = DateTime.parse(endTimeStr).toLocal();

    final timeFormat = DateFormat.jm();
    return "${timeFormat.format(start)} to ${timeFormat.format(end)}";
  }
}
