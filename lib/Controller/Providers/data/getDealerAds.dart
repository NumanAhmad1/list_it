import 'package:lisit_mobile_app/const/lib_all.dart';

class GetDealerAds extends ChangeNotifier {
  bool isLoading = false;
  String error = '';
  Map createdBy = {};
  List adsDataList = [];

  getdealerAds(context, {required String dealerId}) async {
    isLoading = true;
    notifyListeners();
    error = '';
    notifyListeners();

    var response = await CallApi.getApi(context,
        parametersMap: {},
        isAdmin: false,
        endPoint: '/vehicles/user-ads/$dealerId');

    if (response is! String) {
      if (response is Map) {
        if (response['success'] == true) {
          adsDataList = (response['data'] as List).map((e) => e).toList();
          notifyListeners();
          isLoading = false;
          notifyListeners();
        } else {
          error = response['message'] ?? response['error'];
          notifyListeners();
          isLoading = false;
          notifyListeners();
        }
      } else {
        error = 'Unable to process';
        notifyListeners();
        isLoading = false;
        notifyListeners();
      }
    } else {
      error = response;
      notifyListeners();
      isLoading = false;
      notifyListeners();
    }
  }
}
