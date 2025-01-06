import 'dart:developer';

import 'package:lisit_mobile_app/const/lib_all.dart';

class GetDetailsbyVin extends ChangeNotifier {
  bool isLoading = false;
  Map<String, dynamic> carData = {};
  String error = '';

  Future getCarDataByVin(context, {required String carVin}) async {
    error = '';
    startLoading();
    var response = await CallApi.getApi(context,
        token: Controller.getUserToken(),
        parametersMap: {},
        isAdmin: false,
        endPoint: '/data/vinlookup?vin=$carVin');

    if (response is! String) {
      if (response is Map<String, dynamic>) {
        if (response['success'] == true) {
          carData = response['data'];
          log('$carData');
          endLoading();
        } else {
          error = response['message'].toString();
          endLoading();
        }
      } else {
        error = 'Unable to process';
        endLoading();
      }
    } else {
      error = response;
      endLoading();
    }
  }

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }
}
