import 'package:lisit_mobile_app/const/lib_all.dart';

class DeleteMyAdProvider extends ChangeNotifier {
  bool isLoading = false;
  String error = '';
  List<String> selectedAdIds = [];
  bool isErrorFalse = true;

  addIdtoSelectedList({required String adId}) {
    if (selectedAdIds.contains(adId)) {
      selectedAdIds.remove(adId);
      notifyListeners();
    } else {
      selectedAdIds.add(adId);
      notifyListeners();
    }
  }

  deleteResponse(context) async {
    isErrorFalse = true;
    error = '';
    startLoading();
    Map<String, dynamic> body = {
      'data': {'ad_ids': selectedAdIds}
    };
    var response = await CallApi.deleteApi(context,
        endPoint: '/user/delete-my-ads',
        body: body,
        token: Controller.getUserToken());

    if (response is! String) {
      if (response is Map) {
        if (response['success'] == true) {
          error = response['message'];
          isErrorFalse = true;

          notifyListeners();
          selectedAdIds.clear();
          endLoading();
        } else {
          error = response['message'];
          isErrorFalse = false;

          notifyListeners();
          endLoading();
        }
      } else {
        error = 'Unable to proccess';
        isErrorFalse = false;

        notifyListeners();
        endLoading();
      }
    } else {
      error = response;
      isErrorFalse = false;

      notifyListeners();
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
