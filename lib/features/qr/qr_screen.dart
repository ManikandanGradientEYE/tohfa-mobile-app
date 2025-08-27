import 'package:demo/export.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  static Widget builder(BuildContext context) {
    return const QrScreen();
  }

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  String? svgData;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchQrCode();
  }

  Future<void> _fetchQrCode() async {
    String authToken = await SharedPref.instance.getUserToken() ?? "";
    try {
      // Replace 67 with your actual customer ID or make it dynamic
      // final response = await ApiClient().get(
      //   // "${ApiConstants.myQR}?customerId=${Singleton.instance.userData?.id}",
      //   "${ApiConstants.myQR}?customerId=67",
      //   (p0) => p0,
      // );
      final url = Uri.parse(
          "${ApiConstants.myQR}?customerId=${Singleton.instance.userData?.customerId}");
      final response = await get(url, headers: {
        "Authorization": "Bearer $authToken",
        "Accept": "application/json",
        "Content-Type": "application/json"
      });

      log("${response.statusCode}", name: "QR API RESPONSE");

      // logResponse(response, "${ApiConstants.myQR}?customerId=67", "GET", {}, {});
      if (response.statusCode == 200) {
        svgData = json.decode(response.body);
        log(svgData.toString(), name: "QR SVG");
        isLoading = false;
        setState(() {});
      } else {
        setState(() {
          isLoading = false;
          errorMessage = "No Abel to generate";
        });
      }

      // response.handleResponse(onSuccess: (data) {
      //   setState(() {
      //     svgData = response.data;
      //     isLoading = false;
      //   });
      // }, onFailure: (error) {
      //   setState(() {
      //     isLoading = false;
      //     errorMessage = error;
      //   });
      // });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "No Abel to generate";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Center(
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return CustomLoading();
    }

    if (errorMessage.isNotEmpty) {
      return Text(errorMessage);
    }

    if (svgData == null) {
      return const Text('No QR code available');
    }
    final data = Singleton.instance.userData;
    final data2 = Singleton.instance.userOtherData;
    logV("data===>${jsonEncode(data)}");
    return Column(
      spacing: getSize(10),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          textAlign: TextAlign.center,
          text: data?.customerName ??
              data?.customerSiteShortName ??
              data?.customerSiteName ??
              "N/A",
          style: CustomTextStyle.normalText.copyWith(
              color: Color(0xFF666060),
              fontWeight: FontWeight.w400,
              fontSize: getSize(22)),
        ),
        // Display the SVG QR code
        SvgPicture.string(
          svgData.toString(),
          width: 220,
          height: 220,
          placeholderBuilder: (context) => CustomLoading(),
        ),
        Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment:  MainAxisAlignment.center,
                                      children: [
                                        CustomText(
                                          text: "Membership Id: ",
                                                 style: CustomTextStyle.normalText.copyWith(
              color: Color(0xFF726F6A),
              fontWeight: FontWeight.w800,
              fontSize: getSize(20)),
                                        ),
                                        CustomText(
                                          text: data?.membershipCode.split(",").first ?? "N/A",
                                                  style: CustomTextStyle.normalText.copyWith(
              color: Color(0xFF726F6A),
              fontWeight: FontWeight.w500,
              fontSize: getSize(20)),
                                        ),
                                      ],
                                    ),
        // CustomText(
        //   textAlign: TextAlign.center,
        //   text:
        //       "Membership Id: ${data?.membershipCode.split(",").first ?? "N/A"}",
        //   style: CustomTextStyle.normalText.copyWith(
        //       color: Color(0xFF726F6A),
        //       fontWeight: FontWeight.w500,
        //       fontSize: getSize(20)),
        // ),

             Row(mainAxisAlignment:  MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: "Joined: ",
                                          style: CustomTextStyle.normalText.copyWith(
              color: Color(0xFF726F6A),
              fontWeight: FontWeight.w800,
              fontSize: getSize(17)),
                                        ),
                                        CustomText(
                                          text:(data2?.createdOn != null ? data2?.createdOn.toString() : "N/A") ?? "N/A",
                                           style: CustomTextStyle.normalText.copyWith(
              color: Color(0xFF726F6A),
              fontWeight: FontWeight.w500,
              fontSize: getSize(17)),
                                        ),
                                      ],
                                    ),
        // CustomText(
        //   textAlign: TextAlign.center,
        //   text:
        //       "Joined: ${(data2?.createdOn != null ? data2?.createdOn.toString() : "N/A") ?? "N/A"}",
        //   style: CustomTextStyle.normalText.copyWith(
        //       color: Color(0xFF726F6A),
        //       fontWeight: FontWeight.w500,
        //       fontSize: getSize(17)),
        // ),
      ],
    );
  }
}
