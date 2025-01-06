import 'package:lisit_mobile_app/const/lib_all.dart';

class VerifyNumber extends ChangeNotifier {
  bool isLoading = false;
  bool isValidateCode = false;
  bool isGetProfile = false;
  String errorInSendCode = '';
  String errorInVerifying = '';

  sendCodeToNumber(
    context, {
    required String number,
  }) async {
    isLoading = true;
    notifyListeners();
    errorInSendCode = '';
    notifyListeners();

    var response = await CallApi.postApi(context,
        isInsideData: false,
        parametersList: {
          "email": Controller.getUserGmail(),
          "number": "$number"
        },
        isAdmin: false,
        endPoint: '/auth/users/number-otp');
    isLoading = false;
    notifyListeners();

    if (response is! String) {
      if (response is Map<String, dynamic>) {
        return response;
      } else {
        errorInSendCode = 'error in response';
      }
    } else {
      errorInSendCode = response;
    }
  }

  validateNumber(context,
      {required String code, required String number}) async {
    isValidateCode = true;
    notifyListeners();
    errorInVerifying = '';
    notifyListeners();
    var result = await CallApi.postApi(context,
        isInsideData: false,
        parametersList: {"number": '$number', "passcode": code},
        isAdmin: false,
        endPoint: '/auth/users/validate-number');

    isValidateCode = false;
    notifyListeners();

    if (result is! String) {
      if (result is Map<String, dynamic>) {
        return result;
      } else {
        return 'Some thing went wrong';
      }
    } else {
      return result;
    }
  }

  getProfile(context) async {
    isGetProfile = true;
    notifyListeners();
    var profileResult = await CallApi.getApi(context,
        token: Controller.getUserToken(),
        parametersMap: {},
        isAdmin: false,
        endPoint: '/user/profile');
    isGetProfile = false;
    notifyListeners();
    if (profileResult is! String) {
      if (profileResult is Map<String, dynamic>) {
        Controller.saveIsUserVerified(
            isUserVerifend: profileResult['data']['IsVerified']);
        return profileResult;
      } else {
        return 'Unable to proccess data';
      }
    } else {
      return profileResult;
    }
  }
}
