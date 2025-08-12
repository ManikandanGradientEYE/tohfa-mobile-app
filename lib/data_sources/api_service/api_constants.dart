class ApiConstants {
  ///Dev
  static const String domain = 'http://vinitjfaria-001-site2.atempurl.com';
  // static const String domain2 = 'https://thf.initpos.in';
  static const String domain2 = 'https://app.initpos.in:5000';

  static const String url = '$domain2/';
  static const String baseUrl = '${url}api';
  static const String baseUrl2 = '$domain2/api';

  static const String post = "post";
  static const String put = "put";
  static const String get = "get";

  ///auth
  static const String validateNewContact =
      "$baseUrl/CustomerRequest/validatenewcontact";
  static const String getISDCode = "$baseUrl/CustomerRequest/getISDCode";
  static const String byCountryAndPostalCode =
      "$baseUrl/CustomerRequest/bycountryandpostalcode";
  static const String countryList = "$baseUrl/CustomerRequest/CountryList";
  static const String stateList = "$baseUrl/CustomerRequest/StateList";
  static const String cityList = "$baseUrl/CustomerRequest/CityList";
  static const String signup = "$baseUrl/CustomerRequest/signup";
  static const String signInUsingMobile =
      "$baseUrl/CustomerRequest/signinusingmobile";
  static const String verifyotp = "$baseUrl/CustomerRequest/verifyotp";
  static const String generateAndSendOtp =
      "$baseUrl/CustomerRequest/GenerateAndSendOtp";
  static const String otpverify = "$baseUrl/CustomerRequest/otpverify";
  static const String customerSite = "$baseUrl/CustomerRequest/CustomerSites";

  ///Home
  static const String activeBanners = "$baseUrl/CustomerRequest/activebanners";
  static const String activeEvents = "$baseUrl/CustomerRequest/activeevents";
  static const String activeFoodMenu =
      "$baseUrl/CustomerRequest/activefoodmenu";
  static const String visitStatus = "$baseUrl/CustomerRequest/visitstatus";
  static const String getSection = "$baseUrl/CustomerRequest/sections";
  static const String generateToken = "$baseUrl/CustomerRequest/GenerateToken";
  static const String deleteAccount = "$baseUrl/CustomerRequest/InActivate";
  static const String foodOrder = "$baseUrl/CustomerRequest/FoodOrder";
  static const String myQR = "$baseUrl/CustomerRequest/MyQR";
  static const String notifications = "$baseUrl/CustomerRequest/notifications";
  static const String customerSiteDetails =
      "$baseUrl/CustomerRequest/CustomerSiteDetails";
  static const String topics = "$baseUrl/CustomerRequest/topics";
  static const String feedBack = "$baseUrl/CustomerRequest/FeedBack";
  static const String updateCustomerSite =
      "$baseUrl/CustomerRequest/profileupdate";

  ///Report
  static const String getOrderMemo = "$baseUrl/CustomerRequest/OrderMemos";
  static const String getToken = "$baseUrl/CustomerRequest/Tokens";
  static const String downloadOrderMemo =
      "$baseUrl/CustomerRequest/downloadordermemo";
  // "https://thf.initpos.in/api/CustomerRequest/downloadordermemo";
  static const String getDispatchStatus =
      "$baseUrl/CustomerRequest/DispatchStatus";
  static const String getInvoices = "$baseUrl/CustomerRequest/Invoices";
  static const String getPastFoodOrder =
      "$baseUrl/CustomerRequest/PastFoodOrders";


  // CustomerRequest Meeting

    static const String meetings = "$baseUrl/CustomerRequest/Meetings";
    static const String customerRequest = "$baseUrl/CustomerRequest/EmbedUrl";
}
