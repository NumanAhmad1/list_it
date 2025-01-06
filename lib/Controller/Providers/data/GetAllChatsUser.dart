import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:lisit_mobile_app/Controller/Services/callApi.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';
import '../../../Models/AllChatsUserModel.dart';

class GetAllChatsUser extends ChangeNotifier {
  List<AllChatsUserModel> allChatsUser = [];
  List adDataList = [];
  bool isLoading = false;

  getAllChatsUser(context) async {
    allChatsUser.clear();
    isLoading = true;
    notifyListeners();
    var endPoint = "/chat/users";

    var response = await CallApi.getApi(context,
        parametersMap: {},
        endPoint: endPoint,
        token: Controller.getUserToken(),
        isAdmin: false);
    if (kDebugMode) {
      // print(response['data']);
    }

    adDataList = (response['data'] ?? [] as List).map((e) => e['ad']).toList();
    isLoading = false;
    notifyListeners();

    // log('$adDataList');

    // Change this check
    if (response['data'] is List<dynamic>) {
      allChatsUser = (response['data'] as List)
          .map((json) => AllChatsUserModel.fromJson(json))
          .toList();
      isLoading = false;
      notifyListeners();
      // log('user: ${response['data'][1]}');
    } else {
      if (kDebugMode) {
        isLoading = false;
        notifyListeners();
        print('Unexpected API response format: $response');
      }
    }
    isLoading = false;
    notifyListeners();
  }

  Future deleteChatsUser(String to, String refId, context) async {
    // isLoading = true;
    // notifyListeners();
    var endPoint = "/chat/delete-all";

    var response = await CallApi.deleteApi(context,
        endPoint: endPoint,
        token: Controller.getUserToken(),
        body: {
          "to": to.toString(),
          "refid": refId.toString(),
        });
    // isLoading = false;
    // notifyListeners();
    return Controller.languageChange(english: response['message'], arabic: response['message_ar']);
  }
}
