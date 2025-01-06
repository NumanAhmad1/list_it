import 'dart:developer';

import 'package:lisit_mobile_app/const/lib_all.dart';

class MyAds extends ChangeNotifier {
  bool isLoading = false;
  bool adsLoading = false;
  List<dynamic> statusList = [];
  List<dynamic> dataList = [];
  List<MyAdsStatusList> adStatusList = [
    MyAdsStatusList(status: 'All'),
    MyAdsStatusList(status: 'Active'),
    MyAdsStatusList(status: 'Pending'),
    MyAdsStatusList(status: 'Deleted'),
    MyAdsStatusList(status: 'Rejected'),
    MyAdsStatusList(status: 'Expired'),
  ];

  getMainAds(context) async {
    // int allAds = 0;
    isLoading = true;
    notifyListeners();
    var response = await CallApi.getApi(context,
        token: Controller.getUserToken(),
        parametersMap: {},
        isAdmin: false,
        endPoint: '/user/my-ads/all');
    isLoading = false;
    notifyListeners();

    if (response is! String) {
      if (response['success'] == true) {
        statusList = (response['data']['counts'] as List)
            .map((e) => e)
            .toList()
            .reversed
            .toList();
        notifyListeners();
        for (var i = 0; i < adStatusList.length; i++) {
          var matched = false;
          for (var j = 0; j < statusList.length; j++) {
            if (adStatusList[i].status.toLowerCase() ==
                statusList[j]['_id'].toString().toLowerCase()) {
              adStatusList[i].count = statusList[j]['count'];
              notifyListeners();
              matched = true;
              break; // No need to continue checking once a match is found
            }
          }
          if (!matched) {
            adStatusList[i].count = 0;
            notifyListeners(); // Set count to zero for non-matching statuses
          }
        }
        notifyListeners();
        dataList = (response['data']['ads'] as List).map((e) => e).toList();
        // for (int i = 0; i < statusList.length; i++) {
        //   // allAds += int.parse(statusList[i]['count'].toString());
        // }
        // statusList.insert(
        //   0,
        //   {"_id": "All", "count": allAds},
        // );
        notifyListeners();
      } else {}
    } else {
      print('String response: $response');
    }
    isLoading = false;
    notifyListeners();
  }

  getAds(context, {required String adStatus}) async {
    adsLoading = true;
    notifyListeners();
    var response = await CallApi.getApi(context,
        token: Controller.getUserToken(),
        parametersMap: {},
        isAdmin: false,
        endPoint: '/user/my-ads/$adStatus');
    if (response is! String) {
      if (response['success'] == true) {
        statusList = (response['data']['counts'] as List)
            .map((e) => e)
            .toList()
            .reversed
            .toList();
        notifyListeners();

        for (var i = 0; i < statusList.length; i++) {
          adStatusList.forEach((element) {
            if (element.status.toLowerCase() ==
                statusList[i]['_id'].toString().toLowerCase()) {
              element.count = statusList[i]['count'];
              notifyListeners();
            }
          });
        }
        dataList = (response['data']['ads'] as List).map((e) => e).toList();
        notifyListeners();
      } else {}
    } else {
      print('String response: $response');
    }
    adsLoading = false;
    notifyListeners();
  }
}

class MyAdsStatusList {
  String status;
  int count;
  MyAdsStatusList({required this.status, this.count = 0});
}
