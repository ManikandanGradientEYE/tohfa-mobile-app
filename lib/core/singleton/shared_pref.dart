import '../../export.dart';
import '../../features/auth/sign_in/model/customer_site_id_model.dart';

class SharedPref {
  SharedPref._privateConstructor();

  static final SharedPref _instance = SharedPref._privateConstructor();

  static SharedPref get instance => _instance;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  ///clear all Shared Pref store data
  Future<void> clearPref() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.clear();
  }

  ///clear Specific Shared Pref data
  Future<void> clearSpecificPref(String key) async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove(key);
  }

  /// login data
  Future<void> setUserData(CustomerSiteIdModel userObj) async {
    final SharedPreferences prefs = await _prefs;
    Singleton.instance.userData = userObj;
    // Singleton.instance.token = userObj.loginData.token;
    await prefs.setString(SharedKey.userData, jsonEncode(userObj));
  }

  Future<void> setUserToken({required String authToken}) async {
    final SharedPreferences prefs = await _prefs;
    Singleton.instance.token = authToken;
    await prefs.setString(SharedKey.authToken, authToken);
  }

  Future<String?> getUserToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(SharedKey.authToken);
  }

  // Future<void> setUserMobile({required String userMobile}) async {
  //   final SharedPreferences prefs = await _prefs;
  //   await prefs.setString(SharedKey.userMobile, userMobile);
  // }

  // Future<String?> getUserMobile() async {
  //   final SharedPreferences prefs = await _prefs;
  //   return prefs.getString(SharedKey.userMobile);
  // }

  /// login data
  Future<void> setUserOtherData(UserOtherDataModel userObj) async {
    final SharedPreferences prefs = await _prefs;
    Singleton.instance.userOtherData = userObj;
    // Singleton.instance.token = userObj.loginData.token;
    await prefs.setString(SharedKey.userOtherData, jsonEncode(userObj));
  }

  Future getUserData() async {
    final SharedPreferences prefs = await _prefs;
    var data = prefs.getString(SharedKey.userData);
    logV("data===>$data");
    if (data != null && data != "null") {
      Singleton.instance.userData = CustomerSiteIdModel.fromJson(jsonDecode(data));
      // Singleton.instance.token = Singleton.instance.userData!.;
    }
  }

  Future getUserOtherData() async {
    final SharedPreferences prefs = await _prefs;
    var data = prefs.getString(SharedKey.userOtherData);
    logV("data===>$data");
    if (data != null && data != "null") {
      Singleton.instance.userOtherData = UserOtherDataModel.fromJson(jsonDecode(data));
      // Singleton.instance.token = Singleton.instance.userData!.;
    }
  }

  ///logOut
  Future<void> logOut() async {
    Singleton.instance.dashBoardIndex = 0;
    final SharedPreferences prefs = await _prefs;
    await prefs.clear();
    Singleton.instance.userData = null;
  }
}
