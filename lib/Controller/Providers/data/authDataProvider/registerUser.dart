import 'package:http/http.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class RegisterUser extends ChangeNotifier {
  bool isLoading = false;

  Map<String, dynamic> result = {};
  dd(var data) async {
    result = await data;
    notifyListeners();
  }

  registerUser(context,
      {required String email,
      required String password,
      required String name}) async {
    isLoading = true;
    notifyListeners();
    Map<String, dynamic> userData = {
      'name': name,
      'email': email,
      'password': password,
      'gender': '',
      'dob': '',
      'nationality': '',
    };
    notifyListeners();
    var response = await CallApi.postApi(context,
        isInsideData: false,
        parametersList: userData,
        isAdmin: false,
        endPoint: '/auth/users/add');
    isLoading = false;
    notifyListeners();
    return response;
  }
}
