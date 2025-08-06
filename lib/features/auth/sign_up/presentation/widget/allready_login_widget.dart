import 'package:demo/export.dart';

Widget allReadyLogin() {
  return Row(
    spacing: getSize(5),
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CustomText(
        text: "Already have an account? ",
        style: CustomTextStyle.subtitleText.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: getSize(14),
        ),
      ),
      InkWell(
        onTap: () {
          NavigatorService.pushNamedAndRemoveUntil(AppRoutes.sendOtpScreen);
        },
        child: CustomText(
          text: "Sign in",
          style: CustomTextStyle.subtitleText.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: getSize(16),
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primaryColorDark),
        ),
      ),
    ],
  );
}
