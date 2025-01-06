import 'dart:convert';
import 'dart:developer';

import 'package:geocoding/geocoding.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class GetCarDetails extends ChangeNotifier {
  bool isLoading = false;
  int imageIndex = 0;
  Map<String, dynamic> createdBy = {};

  List<String> detailsKey = [];
  List<String> detailsValue = [];
  List extra = [];
  List extraValue = [];
  List<String> images = [];
  List result = [];
  List similarAds = [];
  List similarAdsIds = [];
  String price = '';
  String title = '';
  String description = '';
  String location = '';
  String address = '';
  String phoneNumber = '';
  String adId = '';
  String createdById = '';
  bool isYours = true;
  double latitude = 0.0;
  double longitude = 0.0;
  String categorId = '';
  List adDataList = [];
  String adLink = '';

  dd(var data) {
    result = data['data'];
    notifyListeners();
  }

  changeImage(index) {
    imageIndex = index;
    notifyListeners();
  }

  Future getCarDetails(context, {required String id}) async {
    categorId = '';
    adDataList = [];
    similarAds.clear();
    similarAdsIds.clear();
    extraValue.clear();
    extra.clear();
    isLoading = true;
    notifyListeners();
    var response = await CallApi.getApi(context,
        token: Controller.getUserToken(),
        parametersMap: {},
        isAdmin: false,
        endPoint: '/vehicles/summary/$id');
    detailsKey.clear();
    detailsValue.clear();
    images.clear();
    categorId = response['data'][0]['categoryId'].toString();
    adDataList = (response['data'][0]['data'] as List).map((e) => e).toList();

    response['data'][0]['data'].forEach((e) {
      if (e['name'].toString().contains('Pictures')) {
        images = Controller.languageChange(
                english: e['value'], arabic: e['value_ar'])
            .split(',');
      }
      adId = response['data'][0]['_id'];
    });

    for (int i = 0; i < response['data'][0]['data'].length; i++) {
      var value = response['data'][0]['data'][i];
      if (value['name'].contains('[') && value['name'].contains(']')) {
        var name = value['name'].split('[');
        if (extra.contains(name[0])) {
          for (int j = 0; j < extra.length; j++) {
            if (name[0] == extra[j]) {
              extraValue[j] += ',${name[1].replaceAll(']', '')}';
            }
          }
        } else {
          extra.add(name[0]);
          extraValue.add(name[1].replaceAll(']', ''));
        }
      }
    }

    response['data'][0]['data'].forEach((e) async {
      if (e['name'] == 'Phone Number') {
        phoneNumber = Controller.languageChange(
            english: e['value'], arabic: e['value_ar']);
      } else if (e['name'] == 'Price') {
        price = Controller.languageChange(
            english: e['value'], arabic: e['value_ar']);
      } else if (e['name'].toString().toLowerCase().contains('location')) {
        location = Controller.languageChange(
                english: e['value'], arabic: e['value_ar'])
            .split('_')[0]
            .toString();
        try{
          latitude = double.parse(e['value'].toString().split('_')[1]);
          longitude = double.parse(e['value'].toString().split('_')[2]);
        }catch(e){
          latitude = double.parse('0');
          longitude = double.parse('0');
        }

        log('this is location: $location');
        notifyListeners();
      } else if (e['name'] == 'Title') {
        title = Controller.languageChange(
            english: e['value'], arabic: e['value_ar']);
      } else if (e['name'].toString().contains('Description')) {
        description = Controller.languageChange(
            english: e['value'], arabic: e['value_ar']);
      } else if (e['name'].toString().contains('ad_link')) {
        log('${e['value']}');
        adLink = e['value'];
      }
    });

    if ((response['data'][0]['created_by'] as List).isNotEmpty) {
      createdBy = response['data'][0]['created_by'][0];
      notifyListeners();
      createdById = await response['data'][0]['created_by'][0]['_id'];
      isYours = (Controller.getUserId() == createdById);
      notifyListeners();
      log(' user id: ${Controller.getUserId()}');
      log('createdby id: ${createdById}}');
      log('$isYours');
    }

    print('this is created by${response['data'][0]}');

    response['data'][0]['data'].forEach((e) {
      String key = e['name'].toString();
      if (key != 'Phone Number' &&
          !key.toString().contains('Description') &&
          key != 'Locate your car' &&
          key != 'Category' &&
          key != 'Title' &&
          key != 'Price' &&
          !key.toString().contains('Pictures') &&
          !key.toString().toLowerCase().contains('sub category') &&
          key != 'ID' &&
          key != 'ad_link' &&
          key != 'meta_title' &&
          key != 'meta_description' &&
          key != 'img_alt_text' &&
          key != 'Emirates' &&
          key != 'Mechanical Condition' &&
          key != 'Extras' &&
          key != 'Manufacturer' &&
          key != 'Emirates' &&
          key != 'Is your Car insured in UAE' &&
          key != 'Add Location') {
        if (key.contains('[') && key.contains(']')) {
          notifyListeners();
        } else {
          if (key == 'Extras') {
            print("Extra Key : ${e['name_ar']}");
            print("Extra Key : ${e['name']}");
          }
          detailsKey.add(Controller.languageChange(
              english: e['name'], arabic: e['name_ar']));

          detailsValue.add(Controller.languageChange(
              english: e['value'], arabic: e['value_ar']));
          notifyListeners();
        }
      }
    });
    // log('response: ${response['similar_ads']}');

    similarAds = (response['similar_ads'] ?? [] as List)
        .expand((e) => (e as Map<String, dynamic>)
            .entries
            .where((entry) => entry.key == 'data')
            .map((entry) => entry.value))
        .toList();

    similarAdsIds =
        (response['similar_ads'] ?? [] as List).map((e) => e['_id']).toList();

    // log('tjhis id:  ${similarAdsIds}');

    if (extraValue.isNotEmpty) {
      detailsKey.addAll(extra.map((e) => e));
      detailsValue.addAll(extraValue.map((e) => e));
    }

    dd(response);
    isLoading = false;
    notifyListeners();
  }

  Future getAddress(String address) async {
    log('$address');
    List corrdinates = address.split(',');
    log('$corrdinates');

    // List<Placemark> placemarks = await placemarkFromCoordinates(
    //     double.parse(corrdinates[0]), double.parse(corrdinates[1]));

    // if (placemarks.isNotEmpty) {
    //   log('jjjjjjjtrue');

    //   Placemark place = placemarks[0];
    //   location =
    //       ' ${place.subLocality} ${place.administrativeArea} ${place.country}';
    //   log('$location');
    //   notifyListeners();
    // }
  }
}
