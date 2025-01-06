import 'dart:developer';

import 'package:lisit_mobile_app/const/lib_all.dart';

class Favourite extends ChangeNotifier {
  List favouriteList = [];
  List favouriteIdList = [];
  List favouriteDataList = [];
  bool isLoading = false;
  bool isAddedToFavourite = false;
  bool isFavLoading = false;

  addToFavourite(context, {required String addId, bool? fromFavourite}) async {
    getIsFav() {
      if (favouriteIdList.contains(addId)) {
        return false;
      } else {
        return true;
      }
    }

    print('add to favourte is clicked');
    isLoading = true;
    notifyListeners();
    Map<String, dynamic> userData = {
      'Id': addId,
      'IsFav': fromFavourite != null ? fromFavourite : getIsFav(),
    };
    print('this is $userData');
    print('this is favouite value: $isAddedToFavourite');
    print('this is id list: $favouriteIdList');
    var response = await CallApi.postApi(context,
        token: Controller.getUserToken(),
        isInsideData: false,
        parametersList: userData,
        isAdmin: false,
        endPoint: '/user/favourites');
    isLoading = false;
    notifyListeners();
    if (response['success'] == true) {
      log('calling getFavourite');
      await getFavouriteList(addId, context);
    } else {}
  }

  getFavouriteList(String? id, context) async {
    print('this is favourite response $favouriteDataList');
    favouriteIdList.clear();

    isFavLoading = true;
    notifyListeners();
    var response = await CallApi.getApi(context,
        token: Controller.getUserToken(),
        parametersMap: {},
        isAdmin: false,
        endPoint: '/user/favourites');
    isFavLoading = false;
    notifyListeners();
    if (response is! String) {
      if (response['success'] == true) {
        favouriteIdList =
            (response['data'] as List).map((e) => e['_id']).toList();
        favouriteDataList = response['data'];
        notifyListeners();
        if (id != null) {
          log('checking id');
          checkFavourite(id: id);
          log('$favouriteIdList');
        }
      } else if (response['success'] == false) {
        print('this is favourite response $response');
        print('this is favourite response $favouriteDataList');
      }
    }
  }

  checkFavourite({required String id}) {
    log(id);
    if (favouriteIdList.contains(id)) {
      isAddedToFavourite = true;
      notifyListeners();
    } else {
      isAddedToFavourite = false;
      notifyListeners();
    }
  }
}
