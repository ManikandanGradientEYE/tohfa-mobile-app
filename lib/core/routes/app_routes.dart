import 'package:demo/features/auth/sign_in/presentation/pages/verify_otp_screen.dart';
import 'package:demo/features/profile/screens/edit_screen_new.dart';
import 'package:demo/features/report/screens/token_screen.dart';

import '../../export.dart';
import '../../features/auth/sign_in/presentation/pages/send_otp_screen.dart';
import '../../features/auth/sign_up/presentation/pages/location_screen.dart';
import '../../features/auth/sign_up/presentation/pages/login_option_screen.dart';
import '../../features/auth/sign_up/presentation/pages/sign_up_screen.dart';
import '../../features/auth/sign_up/presentation/pages/validate_phone_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/profile/screens/contact_us_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/faq_screen.dart';
import '../../features/profile/screens/feed_back_screen.dart';
import '../../features/profile/screens/setting_screen.dart';
import '../../features/report/screens/dispatch_status_screen.dart';
import '../../features/report/screens/invoices_screen.dart';
import '../../features/report/screens/order_memo_screen.dart';
import '../../features/report/screens/past_food_order_screen.dart';

class AppRoutes {
  static const String splashScreen = '/SplashScreen';
  static const String loginScreen = '/LoginScreen';
  static const String loginOptionScreen = '/LoginOptionScreen';
  static const String dashBoardScreen = '/DashBoardScreen';
  static const String forgotPassword = '/ForgotPasswordScreen';
  static const String validatePhoneScreen = '/ValidatePhoneScreen';
  static const String locationScreen = '/LocationScreen';
  static const String signUpScreen = '/SignUpScreen';
  static const String sendOtpScreen = '/SendOtpScreen';
  static const String verifyOtpScreen = '/VerifyOtpScreen';
  static const String homeScreen = '/HomeScreen';
  static const String orderMemoScreen = '/OrderMemoScreen';
  static const String dispatchStatusScreen = '/DispatchStatusScreen';
  static const String invoiceScreen = '/InvoiceScreen';
  static const String pastFoodOrderScreen = '/PastFoodOrderScreen';
  static const String settingScreen = '/SettingScreen';
  static const String faqScreen = '/FaqScreen';
  static const String contactUsScreen = '/ContactUsScreen';
  static const String feedBackScreen = '/FeedBackScreen';
  static const String editProfileScreen = '/EditProfileScreen';
  static const String tokenScreen = '/tokenScreen';

  static Map<String, WidgetBuilder> get routes => {
        splashScreen: SplashScreen.builder,
        // loginScreen : LoginOptionScreen.builder,
        dashBoardScreen: DashBoardScreen.builder,
        loginOptionScreen: LoginOptionScreen.builder,
        validatePhoneScreen: ValidatePhoneScreen.builder,
        locationScreen: LocationScreen.builder,
        sendOtpScreen: SendOtpScreen.builder,
        verifyOtpScreen: VerifyOtpScreen.builder,
        signUpScreen: SignUpScreen.builder,
        homeScreen: HomeScreen.builder,
        orderMemoScreen: OrderMemoScreen.builder,
        dispatchStatusScreen: DispatchStatusScreen.builder,
        invoiceScreen: InvoicesScreen.builder,
        pastFoodOrderScreen: PastFoodOrderScreen.builder,
        settingScreen: SettingScreen.builder,
        faqScreen: FaqScreen.builder,
        contactUsScreen: ContactUsScreen.builder,
        feedBackScreen: FeedBackScreen.builder,
        editProfileScreen: EditProfileScreenNew.builder,
        tokenScreen: TokenScreen.builder
      };
}
