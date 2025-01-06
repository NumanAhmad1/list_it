import 'dart:developer';

import 'package:lisit_mobile_app/Models/getCategoryListingModel.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class GetCategoryListing extends ChangeNotifier {
  // List<GetCategoryListingModel> categoryListing = [];
  bool isFilterApplied = false;
  List data = [];
  List categoryFieldsFiltersData = [];
  List filtersDropdownNames = [];
  List filtersDropdownValues = [];
  List filtersDropdownsList = [];

  bool isLoading = false;
  bool filterLoading = false;
  String filterError = '';
  String filterNames = '';
  String searchedValue = '';
  int page = 1;
  String sortBy = '';
  String sortDirection = '';

  bool isLoadMore = false;
  int totalRecord = 0;
  int sortSelectionIndex = 0;
  List<List> dropdownValuesList = [];

  applyFilter() {
    isFilterApplied = true;
    notifyListeners();
  }

  removeFilter() {
    log('removefilter is called');
    isFilterApplied = false;
    notifyListeners();
  }

  changeSortSelectionIndex({required index}) {
    sortSelectionIndex = index;
    log('sortselectedIndex: ${sortSelectionIndex}');
    log('index: ${index}');

    notifyListeners();
  }

  getCategoryListing(context,
      {required Map<String, dynamic> parametersMap}) async {
    isLoading = true;
    notifyListeners();

    var response = await CallApi.postApi(context,
        isInsideData: true,
        parametersList: parametersMap,
        isAdmin: false,
        endPoint:
            '/vehicles/summary-sorted/all?page=1&limit=5&sort_by=$sortBy&sort_direction=$sortDirection');

    if (response is! String) {
      if (response['success'] == true) {
        if (response['data'][0]['metadata'].isNotEmpty) {
          totalRecord = response['data'][0]['metadata'][0]['totalRecords'];
        }

        notifyListeners();
        if ((response['data'][0]['records'] as List).isNotEmpty) {
          data =
              (response['data'][0]['records'] as List).map((e) => e).toList();
        } else {
          data = [];
        }

        notifyListeners();
      } else {
        print('Unexpected API response format: $response');
      }
    } else {
      print('this is the error: ${response}');
    }

    isLoading = false;
    notifyListeners();
  }

  loadMore(context, bool? isFromSort,
      {required Map<String, dynamic> parametersMap}) async {
    isLoadMore = true;
    notifyListeners();
    if (sortSelectionIndex == 0) {
      sortBy = 'created_at';
      sortDirection = 'desc';
      notifyListeners();
    } else if (sortSelectionIndex == 1) {
      sortBy = 'created_at';
      sortDirection = 'asc';
      notifyListeners();
    } else if (sortSelectionIndex == 2) {
      sortBy = 'Price';
      sortDirection = 'desc';
      notifyListeners();
    } else {
      sortBy = 'Price';
      sortDirection = 'asc';
      notifyListeners();
    }
    if (isFromSort == true) {
      page = 1;
      notifyListeners();
    }
    if (totalRecord > data.length) {
      page++;
    }
    if (isFromSort == true) {
      page = 1;
      notifyListeners();
    }

    notifyListeners();
    var response = await CallApi.postApi(context,
        isInsideData: true,
        parametersList: parametersMap,
        isAdmin: false,
        endPoint:
            '/vehicles/summary-sorted/all?page=${page}&limit=5&sort_by=$sortBy&sort_direction=$sortDirection');
    isLoadMore = false;
    notifyListeners();
    if (response is! String) {
      if (response['success'] == true) {
        if (isFromSort == true) {
          totalRecord = response['data'][0]['metadata'][0]['totalRecords'];
          notifyListeners();
          data =
              (response['data'][0]['records'] as List).map((e) => e).toList();
          notifyListeners();
        } else {
          totalRecord = response['data'][0]['metadata'][0]['totalRecords'];
          notifyListeners();
          if (response['data'][0]['records'] != null) {
            (response['data'][0]['records'] as List).forEach((element) {
              data.add(element);
              notifyListeners();
              isLoadMore = false;
              notifyListeners();
            });
          } else {
            data = [];
          }

          notifyListeners();
        }
      } else {
        print('Unexpected API response format: $response');
      }
    } else {
      print('this is the error: ${response}');
    }
  }

  // getCategoryFieldsFilter(context, {required String category}) async {
  //   filterLoading = true;
  //   notifyListeners();
  //   filterError = '';
  //   notifyListeners();
  //   filterNames = '';
  //   notifyListeners();

  //   var result = await CallApi.getApi(context,
  //       parametersMap: {
  //         'name': category,
  //         'type': '2',
  //       },
  //       isAdmin: true,
  //       endPoint: '/data/get-category-fields');

  //   if (result is! String) {
  //     if (result is Map<String, dynamic>) {
  //       if (result['success'] == true) {
  //         categoryFieldsFiltersData =
  //             (result['data'] ?? [] as List).map((e) => e).toList();

  //         categoryFieldsFiltersData.forEach((element) {
  //           if (element != categoryFieldsFiltersData.last) {
  //             filterNames += '${element['name']}~';
  //             notifyListeners();
  //           } else {
  //             filterNames += element['name'];
  //             notifyListeners();
  //           }
  //         });

  //         await getFiltersValue(filtersName: filterNames, context);

  //         filterLoading = false;
  //         notifyListeners();
  //       } else {
  //         filterError = result['message'];
  //         filterLoading = false;
  //         notifyListeners();
  //       }
  //     } else {
  //       filterError = 'Unable to process data';
  //       notifyListeners();
  //       filterLoading = false;
  //       notifyListeners();
  //     }
  //   } else {
  //     filterError = result;
  //     notifyListeners();
  //     filterLoading = false;
  //     notifyListeners();
  //   }
  //   filterLoading = false;
  //   notifyListeners();
  // }

  getCategoryFieldsFilter(context, {required String category}) async {
    filterLoading = true;
    notifyListeners();
    filterError = '';
    notifyListeners();

    Map<String, String> filters = {
      'name': category,
      'type': '2',
    };

    var result = await CallApi.getApi(context,
        parametersMap: filters,
        isAdmin: true,
        endPoint: '/data/get-category-fields-details');

    if (result is! String) {
      if (result is Map<String, dynamic>) {
        filtersDropdownNames.clear();
        filtersDropdownValues.clear();
        filtersDropdownsList.clear();
        if (result['success'] == true) {
          filtersDropdownsList =
              (result['data'] as List).map((e) => e).toList();
          // log('this is dropdown vlue list 44444444444:${dropdownValuesList}');

          makedropdownValuesList();

          // log('this is dropdown vlue list 44444444444:${dropdownValuesList}');

          // log('########$filtersDropdownsList');
          notifyListeners();
        } else {
          filterError = Controller.languageChange(
              english: result['message'], arabic: result['message_ar']);
          notifyListeners();
          filterLoading = false;
          notifyListeners();
        }
      } else {
        filterError = 'Unable to process data';
        notifyListeners();
        filterLoading = false;
        notifyListeners();
      }
    } else {
      filterError = result;
      notifyListeners();
      filterLoading = false;
      notifyListeners();
    }
  }

  Future saveYourSearch(context,
      {required String searchValue,
      required String searchName,
      required bool notifyMe}) async {
    var response = await CallApi.putApi(context,
        token: Controller.getUserToken(),
        endPoint: '/vehicles/save-search',
        body: {
          "Searchterms": {
            "Name": searchName,
            "Value": searchValue,
            "Pictures": "",
            "NotifyEmail": notifyMe ? true : false,
            "NotifyMobile": notifyMe ? true : false,
          },
          "IsSave": true,
        });

    if (response is! String) {
      if (response is Map) {
        if (response['success'] == true) {
          return response;
        } else {
          return response['message'];
        }
      } else {
        return "Unable to process";
      }
    } else {
      return response;
    }
  }

  convertSearchToSave({required Map<String, dynamic> searchMap}) {
    List<String> keyValuePairs = [];

    searchMap.forEach((key, value) {
      keyValuePairs.add("$key:$value");
    });

    searchedValue = keyValuePairs.join("~");
    log('searched Value: $searchedValue');
    notifyListeners();
  }

  void makedropdownValuesList() {
    List<List> data = [];

    for (var i = 0; i < filtersDropdownsList.length; i++) {
      // List categoryData = [
      //   Controller.languageChange(
      //       english: filtersDropdownsList[i]['categoryFieldName'],
      //       arabic: filtersDropdownsList[i]['categoryFieldNameArabic'])
      // ];
      // log('this is category data: ${categoryData}');
      List attributeData =
          filtersDropdownsList[i]['Attributes'].map((e) => e).toList();
      log('this is attribute data${[
        i
      ]}: ${filtersDropdownsList[i]['Attributes']}');

      // categoryData.addAll(attributeData);
      data.add(attributeData);
    }

    dropdownValuesList = data;
    notifyListeners();
  }

  void updateList({
    String? reloadCategoryFieldId,
    String? attributeId,
  }) {
    for (var i = 0; i < filtersDropdownsList.length; i++) {
      if (reloadCategoryFieldId ==
          filtersDropdownsList[i]['CategoryFieldID'].toString()) {
        // log('condition is true at ${i}: ${reloadCategoryFieldId == filtersDropdownsList[i]['CategoryFieldID'].toString()}');
        // log('this is the list for attribuites: ${filtersDropdownsList[i]['Attributes']}');
        dropdownValuesList[i] = filtersDropdownsList[i]['Attributes']
            .where((e) => attributeId == e['reloadByFieldIds'].toString())
            .map((e) => e)
            .toList();
        log('this is the selected attribuite id : ${attributeId}');
        log('this is the selected attribuite id : ${filtersDropdownsList[i]['categoryFieldName']}');

        log('this is the new list of vlaues : ${filtersDropdownsList[i]['Attributes'].where((e) => attributeId == e['reloadByFieldIds'].toString()).map((e) => e).toList()}');
        // dropdownValuesList[i].insert(
        //     0,
        //     Controller.languageChange(
        //         english: filtersDropdownsList[i]['categoryFieldName'],
        //         arabic: filtersDropdownsList[i]['categoryFieldNameArabic']));

        // dropdownValuesList[i].forEach((e) {
        //   log('this is updated list: ${e['attributeName']}');
        // });

        notifyListeners();
        break;
      }
    }
  }
}
