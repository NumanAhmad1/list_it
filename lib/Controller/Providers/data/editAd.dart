import 'dart:developer';

import 'package:lisit_mobile_app/const/lib_all.dart';

class EditAd extends ChangeNotifier {
  bool isLoading = false;
  String error = '';
  String? categoryId;
  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }

  getAdData(context, {required String id}) async {
    error = '';
    notifyListeners();
    startLoading();
    var response = await CallApi.getApi(context,
        token: Controller.getUserToken(),
        parametersMap: {},
        isAdmin: false,
        endPoint: '/vehicles/summary/$id');

    log('${response}');
  }
}
