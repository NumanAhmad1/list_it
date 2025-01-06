import 'dart:developer';

import 'package:lisit_mobile_app/const/lib_all.dart';

class MyNotificationData extends ChangeNotifier {
  bool isLoading = false;
  String error = '';
  bool isReadNotification = false;

  List notificationsDataList = [];

  getMyNotification(context) async {
    notifyListeners();
    isLoading = true;
    notifyListeners();
    error = '';
    notifyListeners();

    var response = await CallApi.getApi(context,
        parametersMap: {},
        isAdmin: false,
        endPoint: '/user/my-notifications',
        token: Controller.getUserToken());

    if (response is! String) {
      if (response is Map) {
        if (response['success'] == true) {
          notificationsDataList =
              (response['data'] == null ? [] as List : response['data'] as List)
                  .map((e) => e)
                  .toList();
          isLoading = false;
          notifyListeners();
        } else {
          isLoading = false;
          notifyListeners();
          error = response['message'] ?? response['error'];
          notifyListeners();
        }
      } else {
        isLoading = false;
        notifyListeners();
        error = 'Unable to process data';
        print('error response: $response');
        notifyListeners();
      }
    } else {
      isLoading = false;
      notifyListeners();
      error = response;
      notifyListeners();
    }
  }

  markAsReadNotification(context, {required String notificationId}) async {
    isReadNotification = true;
    notifyListeners();

    var response = await CallApi.patchApi(context,
        token: Controller.getUserToken(),
        endPoint: '/user/update-notification/$notificationId',
        body: {});

    if (response is! String) {
      if (response is Map) {
        if (response['success']) {
          getMyNotification(context);
        }
      }
    }
    isReadNotification = false;
    notifyListeners();
  }

  removeNotification(context, {required String notificationId}) async {
    var response = await CallApi.deleteApi(context,
        token: Controller.getUserToken(),
        endPoint: '/user/remove-notification/$notificationId',
        body: {});

    if (response is! String) {
      if (response is Map) {
        if (response['success'] == true) {
          getMyNotification(context);
        }
      }
    }
  }
}
