import 'dart:developer';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:lisit_mobile_app/Models/addSummaryModel.dart';
import 'package:lisit_mobile_app/Models/adsInputFieldsModel.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class AdsInputField extends ChangeNotifier {
  List<AdsInputFieldsModel> adsInputFieldListSummary = [];
  List<AdsInputFieldsModel> adsInputFieldListDetails = [];
  List<AddSummaryModel> selectedValueList = [];
  List<AddSummaryModel> carAdTwoSelectedValuesList = [];
  List<AddSummaryModel> carAdOneSelectedValuesList = [];
  List<AddSummaryModel> editAdSelectedValuesList = [];
  List<AdsInputFieldsModel> editAdInputFieldsList = [];
  List dependentControls = [];

  List<List<String>> dropdownValuesList = [];

  bool isLoading = false;

  double latitude = 0.0;
  double longitude = 0.0;
  String completeAddress = 'N/A';

  //update radion value

  void addSelectedItem(
      {required AddSummaryModel newItem,
      required List<AddSummaryModel> valuesList}) {
    // Check if an item with the same name already exists
    int existingIndex =
        valuesList.indexWhere((item) => item.name == newItem.name);

    print(existingIndex);

    if (existingIndex != -1) {
      // Item with the same name already exists, overwrite it
      valuesList[existingIndex] = newItem;
    } else {
      // Item with the same name doesn't exist, add the new item
      valuesList.add(newItem);
    }
  }

  

  updateRadioValue(newValue, index, valueTobeSet) {
    // adsInputFieldListSummary[index].categoryFieldId = newValue;
    // selectedValueList[index].value = valueTobeSet;
  }

  Future getInputFields(context,
      {required String categoryId, required String pageId}) async {
    dependentControls.clear();
    editAdSelectedValuesList = [];
    dropdownValuesList = [];
    isLoading = true;
    notifyListeners();
    String endPoint = '/data/customfir?categoryId=$categoryId&pageId=$pageId';
    var response = await CallApi.getApi(
      context,
      parametersMap: {},
      endPoint: endPoint,
      isAdmin: true,
    );

    dependentControls =
        (response['dependant_controls'] ?? []).map((e) => e).toList();
    notifyListeners();
    response = response['data'];
    if (response is List<dynamic>) {
      pageId.isEmpty
          ? editAdInputFieldsList = response
              .map((json) => AdsInputFieldsModel.fromJson(json))
              .toList()
          : pageId == '1'
              ? adsInputFieldListSummary = response
                  .map((json) => AdsInputFieldsModel.fromJson(json))
                  .toList()
              : adsInputFieldListDetails = response
                  .map((json) => AdsInputFieldsModel.fromJson(json))
                  .toList();
      makedropdownValuesList(pageId: pageId);

      notifyListeners();
      // print('ads field length: ${adsInputFieldList.length}');
    } else {
      print('Unexpected API response format: $response');
    }

    isLoading = false;
    notifyListeners();
  }

  Future getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('service is dissables');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission is denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission is denied for ever');
    }

    Position currentLocation = await Geolocator.getCurrentPosition();
    notifyListeners();
    latitude = currentLocation.latitude;
    notifyListeners();
    longitude = currentLocation.longitude;
    notifyListeners();

    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      completeAddress =
          ' ${place.subLocality} ${place.administrativeArea} ${place.country}';
      notifyListeners();
    }
  }

  getLatLangFromAdress({required Prediction prediction}) {
    latitude = double.parse(prediction.lat.toString() ?? 0.0.toString());
    notifyListeners();
    longitude = double.parse(prediction.lng.toString() ?? 0.0.toString());
    notifyListeners();
  }

  upEditSelectedValueList() {
    for (var i = 0; i < editAdInputFieldsList.length; i++) {
      editAdSelectedValuesList.forEach((e) {
        if (e.name == editAdInputFieldsList[i].categoryFieldName &&
            editAdInputFieldsList[i].categoryTypeId == '2') {
          var data = editAdInputFieldsList[i];

          int ind = data.attributes
              .indexWhere((element) => element.attributeName == e.value);

          e = AddSummaryModel(
              name: '${data.categoryFieldName}',
              nameAr: '${data.categoryFieldNameArabic}',
              value: '${data.attributes[ind].attributeName}',
              valueAr: '${data.attributes[ind].attributeNameAr}',
              field: data.categoryFieldName);
          notifyListeners();
        }
      });
    }
  }

  void makedropdownValuesList({required String pageId}) {
    List<List<String>> data = [];

    if (pageId == '1') {
      for (var i = 0; i < adsInputFieldListSummary.length; i++) {
        List<String> categoryData = [
          Controller.languageChange(
              english: adsInputFieldListSummary[i].categoryFieldName,
              arabic: adsInputFieldListSummary[i].categoryFieldNameArabic)
        ];
        List<String> attributeData = adsInputFieldListSummary[i]
            .attributes
            .map((e) => Controller.languageChange(
                english: e.attributeName, arabic: e.attributeNameAr))
            .toList();
        categoryData.addAll(attributeData);
        data.add(categoryData);
      }

      dropdownValuesList = data;
      notifyListeners();
    } else if (pageId == '2') {
      for (var i = 0; i < adsInputFieldListDetails.length; i++) {
        List<String> categoryData = [
          Controller.languageChange(
              english: adsInputFieldListDetails[i].categoryFieldName,
              arabic: adsInputFieldListDetails[i].categoryFieldNameArabic)
        ];
        List<String> attributeData = adsInputFieldListDetails[i]
            .attributes
            .map((e) => Controller.languageChange(
                english: e.attributeName, arabic: e.attributeNameAr))
            .toList();
        categoryData.addAll(attributeData);
        data.add(categoryData);
      }

      dropdownValuesList = data;
      notifyListeners();
    } else {
      for (var i = 0; i < editAdInputFieldsList.length; i++) {
        List<String> categoryData = [
          Controller.languageChange(
              english: editAdInputFieldsList[i].categoryFieldName,
              arabic: editAdInputFieldsList[i].categoryFieldNameArabic)
        ];
        List<String> attributeData = editAdInputFieldsList[i]
            .attributes
            .map((e) => Controller.languageChange(
                english: e.attributeName, arabic: e.attributeNameAr))
            .toList();
        categoryData.addAll(attributeData);
        data.add(categoryData);
      }

      dropdownValuesList = data;
      notifyListeners();
    }
  }

  updateDependentList({required String categoryFieldId}) {
    for (var i = 0; i < dependentControls.length; i++) {
      if (categoryFieldId.toString() == dependentControls[i].toString()) {
        dependentControls.removeAt(i);
        notifyListeners();
        break;
      }
    }
  }

  void updateList({
    String? reloadCategoryFieldId,
    String? attributeId,
    required List<AdsInputFieldsModel> adsInputFieldList,
  }) {
    for (var i = 0; i < adsInputFieldList.length; i++) {
      if (reloadCategoryFieldId ==
          adsInputFieldList[i].categoryFieldId.toString()) {
        updateDependentList(
            categoryFieldId: adsInputFieldList[i].categoryFieldId.toString());
        notifyListeners();
        List<String> temp = [];
        temp = adsInputFieldList[i]
            .attributes
            .where((e) =>
                attributeId == e.reloadByFieldIds.toString() &&
                !temp.contains(e.attributeName))
            .map((e) => Controller.languageChange(
                english: e.attributeName, arabic: e.attributeNameAr))
            .toList();

        dropdownValuesList[i] = temp;
        dropdownValuesList[i].insert(
            0,
            Controller.languageChange(
                english: adsInputFieldList[i].categoryFieldName,
                arabic: adsInputFieldList[i].categoryFieldNameArabic));
        notifyListeners();
      }
    }
  }
}
