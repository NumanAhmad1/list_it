import 'dart:developer';

import 'package:lisit_mobile_app/const/lib_all.dart';

class HomeScreenData extends ChangeNotifier {
  bool isLoading = false;
  String error = '';
  List<String> categoryNameList = [];
  List categoryDataList = [];
  List favouriteDataList = [];
  Map<String, dynamic> recentlyLookedAt = {};

  getHomeData(context) async {
    recentlyLookedAt = {};
    error = '';
    notifyListeners();
    isLoading = true;
    notifyListeners();

    var response = await CallApi.getApi(context,
        token: Controller.getUserToken(),
        parametersMap: {},
        isAdmin: false,
        endPoint: '/home');

    if (response is! String) {
      if (response['success'] == true) {
        String recentlyLookedAtString =
            (response['data']['my_searches'] ?? [] as List).isNotEmpty
                ? (response['data']['my_searches'] as List).last['Value']
                : '';
        List recentlyLookedAtList = recentlyLookedAtString.split('~');
        if (recentlyLookedAtString.isNotEmpty &&
            recentlyLookedAtString != null) {
          recentlyLookedAtList.forEach((element) {
            List<String> splitData = element.split(':');
            String key = splitData.length > 0 ? splitData[0].trim() : '';
            String value = splitData.length > 1 ? splitData[1].trim() : '';
            recentlyLookedAt[key] = value;
          });
          log('${recentlyLookedAt}');
          notifyListeners();
        }
        categoryDataList.clear();
        categoryNameList.clear();
        (response['data']['categories_data'] ?? [] as Map<String, dynamic>)
            .forEach((key, value) {
          if (!categoryNameList.contains(key)) {
            categoryNameList.add(key);
            categoryDataList.add(value);
          }
          notifyListeners();
        });
        notifyListeners();
      } else {
        print('response Faild');
        isLoading = false;
        notifyListeners();
      }
    } else {
      error = response;
      notifyListeners();
      isLoading = false;
      notifyListeners();
    }

    for (int i = 0; i < categoryNameList.length; i++) {
      print(categoryNameList[i]);
      print(categoryDataList[i].length);
    }
    isLoading = false;
    notifyListeners();
  }
}

class HomeScreenData1 extends ChangeNotifier {
  bool isLoading = false;
  String error = '';

  List categoriesList = [];
  Map featuredAdsData = {};
  List adsList = [];
  List featuredBrands = [];

  String selectedCategoryName = '';

  getHomeData(context) async {
    isLoading = true;
    error = '';
    notifyListeners();

    String city =
        Controller.getCity() != null ? '?city=${Controller.getCity()}' : '';

    var response = await CallApi.getApi(context,
        parametersMap: {}, isAdmin: false, endPoint: '/home-featured$city');
    isLoading = false;
    notifyListeners();

    if (response is! String) {
      if (response is Map) {
        if (response['success'] == true) {
          if (response['data'] != null) {
            featuredBrands = (response['data']['featured_brands'] as List)
                .map((e) => e)
                .toList();
            notifyListeners();
            categoriesList =
                (response['data']['categories'] as List).map((e) => e).toList();
            notifyListeners();
            featuredAdsData = response['data'];
            if (categoriesList.isNotEmpty) {
              generateAdsList(categoriesList[0]['_id']);
            }
          } else {
            categoriesList = [];
            featuredAdsData = {};
            featuredBrands = [];
            notifyListeners();
          }
        } else {
          error = response['message'];
          notifyListeners();
        }
      } else {
        error = 'unable to process';
        notifyListeners();
      }
    } else {
      error = response;
      notifyListeners();
    }
  }

  generateAdsList(String categoryName) {
    selectedCategoryName = categoryName;
    notifyListeners();
    String catName = categoryName.replaceAll(' ', '_').toLowerCase();
    adsList =
        (featuredAdsData['featured_$catName'] as List).map((e) => e).toList();
    notifyListeners();
  }
}
