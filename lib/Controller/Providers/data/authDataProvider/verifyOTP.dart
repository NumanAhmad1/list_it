import 'package:lisit_mobile_app/const/lib_all.dart';

class VerifyOTP extends ChangeNotifier {
  bool isLoading = false;
  bool isresending = false;
  bool isResetingPassword = false;

  getVerifyOTP(context, {required String code, required String email}) async {
    print(code);
    print(email);
    isLoading = true;
    Map<String, dynamic> userData = {
      'email': email,
      'passcode': code,
    };
    notifyListeners();
    var response = await CallApi.postApi(context,
        isInsideData: false,
        parametersList: userData,
        isAdmin: false,
        endPoint: '/auth/users/validate-email');
    isLoading = false;
    notifyListeners();
    return response;
  }

  getResendOTP({required String email, context}) async {
    isresending = true;
    notifyListeners();

    Map<String, dynamic> userData = {
      'email': email,
    };

    var response = await CallApi.postApi(context,
        isInsideData: false,
        parametersList: userData,
        isAdmin: false,
        endPoint: '/auth/users/resend-otp');

    isresending = false;
    notifyListeners();
    return response;
  }

  getResetPassword(context,
      {required String email,
      required String password,
      required String confirmPassword}) async {
    isResetingPassword = true;
    notifyListeners();

    Map<String, dynamic> userData = {
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
    };

    var response = await CallApi.postApi(context,
        isInsideData: false,
        parametersList: userData,
        isAdmin: false,
        endPoint: '/auth/users/reset-password');
    isResetingPassword = false;
    notifyListeners();
    return response;
  }
}
