import 'dart:developer';

import 'package:lisit_mobile_app/const/lib_all.dart';

class AdReport extends ChangeNotifier {
  bool isLoading = false;
  String error = '';
  List resportConfigList = [];

  reportConfig(context) async {
    isLoading = true;
    notifyListeners();
    error = '';
    notifyListeners();

    var response = await CallApi.getApi(context,
        parametersMap: {}, isAdmin: false, endPoint: '/vehicles/reportconfig');

    if (response is! String) {
      if (response is Map<String, dynamic>) {
        if (response['success'] == true) {
          resportConfigList = (response['data'] as List).map((e) => e).toList();

          log('$resportConfigList');
          notifyListeners();
          isLoading = false;
          notifyListeners();
        } else {
          isLoading = false;
          notifyListeners();
          error = response['message'] ?? 'Response failed';
          notifyListeners();
        }
      } else {
        isLoading = false;
        notifyListeners();
        print('error in reportconfig: $response');
        error = 'Unable to process';
        notifyListeners();
      }
    } else {
      isLoading = false;
      notifyListeners();
      error = response;
      notifyListeners();
    }
  }
}
