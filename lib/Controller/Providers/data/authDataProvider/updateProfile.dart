import 'dart:developer';

import 'package:lisit_mobile_app/const/lib_all.dart';

class UpdateProfile extends ChangeNotifier {
  bool isLoading = false;
  String error = '';

  updateUser(context, {required Map<String, dynamic> profileData}) async {
    isLoading = true;
    notifyListeners();
    error = '';
    notifyListeners();

    var response = await CallApi.patchApi(context,
        token: Controller.getUserToken(),
        endPoint: '/user/profile/update',
        body: profileData);

    if (response is Map<String, dynamic>) {
      if (response['success'] == true) {
        isLoading = false;
        notifyListeners();
        return response;
      } else {
        isLoading = false;
        error = response['message'];
        notifyListeners();
        return response;
      }
    } else {
      isLoading = false;
      notifyListeners();
    }
  }
}
