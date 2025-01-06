import 'dart:developer';

import 'package:lisit_mobile_app/const/lib_all.dart';

class MySavedSearchProvider extends ChangeNotifier {
  bool isLoading = false;
  String error = '';
  List mySavedSearchList = [];
  List searchedSaveSearchTitle = [];
  bool isSearchClicked = false;

  changesearchclick() {
    isSearchClicked = !isSearchClicked;
    notifyListeners();
  }

  initsavedSearch() {
    searchedSaveSearchTitle = mySavedSearchList;
    notifyListeners();
  }

  savedSearchFunction({required String query}) {
    log('List: ${searchedSaveSearchTitle}');

    final suggestion = mySavedSearchList.where((searchName) {
      final savedSearchearchName = searchName['Name'].toString().toLowerCase();
      log('Name: ${savedSearchearchName}');
      final input = query.trim().toString().toLowerCase();
      return savedSearchearchName.contains(input);
    }).toList();
    searchedSaveSearchTitle = suggestion;
    notifyListeners();
  }

  Future getMySavedSearches(context) async {
    startLoading();
    error = '';
    notifyListeners();
    var response = await CallApi.getApi(context,
        token: Controller.getUserToken(),
        parametersMap: {},
        isAdmin: false,
        endPoint: '/user/my-searches');

    if (response is! String) {
      if (response is Map) {
        if (response['success'] == true) {
          mySavedSearchList =
              (response['data'] ?? [] as List).map((e) => e).toList();

          stopLoading();
        } else {
          error = response['error'] ?? response['message'];
          stopLoading();
        }
      } else {
        error = 'Unable to process';
        stopLoading();
      }
    } else {
      error = response;
      stopLoading();
    }
  }

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  updateSearchNotification(context,
      {required bool emailNotification,
      required bool inAppNotification,
      required String title,
      required String category,
      required String searchId}) async {
    var response = await CallApi.putApi(context,
        token: Controller.getUserToken(),
        endPoint: '/vehicles/update-search/$searchId',
        body: {
          'Name': title,
          'Value': category,
          'Pictures': '',
          'NotifyEmail': emailNotification,
          'NotifyMobile': inAppNotification,
        });

    if (response is! String) {
      if (response is Map) {
        return response;
      } else {
        return 'Unable to process';
      }
    } else {
      return response;
    }
  }

  deleteSearch(context, {required String searchId}) async {
    return await CallApi.deleteApi(context,
        token: Controller.getUserToken(),
        endPoint: '/vehicles/delete-search/$searchId',
        body: {});
  }
}
