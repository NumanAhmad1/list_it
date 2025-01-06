import 'dart:developer';

import 'package:lisit_mobile_app/Models/categoryModel.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class GetCategory extends ChangeNotifier {
  List<CategoryModel> categoryiesList = [];
  List<CategoryModel> subCategoryiesList = [];

  bool isLoading = false;
  String error = '';

  checkToken(context) async {
    isLoading = true;
    notifyListeners();
    var result = await CallApi.getApi(context,
        token: Controller.getUserToken(),
        parametersMap: {},
        isAdmin: false,
        endPoint: '/check-token');
    if (result is! String) {
      if (result is Map<String, dynamic>) {
        if (result['success'] == true) {
          isLoading = false;
          notifyListeners();
          return true;
        } else {
          isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        isLoading = false;
        notifyListeners();
        return false;
      }
    } else {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  getCategories(context, {required String parentId}) async {
    error = '';
    notifyListeners();
    isLoading = true;
    notifyListeners();

    var response = await CallApi.getApi(
      context,
      parametersMap: {'parent_id': parentId},
      endPoint: '/category',
      isAdmin: true,
    );

    if (response is! String) {
      if (response['data'] is List<dynamic>) {
        categoryiesList = (response['data'] as List)
            .map((json) => CategoryModel.fromJson(json))
            .toList();
        notifyListeners();
        isLoading = false;
        notifyListeners();
      } else {
        print('Unexpected API response format: $response');
        isLoading = false;
        notifyListeners();
      }
    } else {
      error = response;
      isLoading = false;
      notifyListeners();
    }

    isLoading = false;
    notifyListeners();
  }

  //store subcategory
  goNexCategory(CategoryModel nextCategory) {
    log('ftn is called');
    if (subCategoryiesList.isEmpty) {
      subCategoryiesList.insert(
        0,
        CategoryModel(
            id: 0,
            name: 'name',
            nameAr: 'nameAr',
            isActive: true,
            isParent: true,
            parentId: 0,
            parentName: 'parentName',
            level: 2,
            createdAt: DateTime.now(),
            createdBy: DateTime.april,
            updatedAt: DateTime.now(),
            updatedBy: DateTime.august),
      );
      log('subcategory list');
      subCategoryiesList.map((e) => log(e.name));
    }
    if (!subCategoryiesList.contains(nextCategory) && nextCategory.isActive) {
      log('category is add');
      subCategoryiesList.add(nextCategory);
    }

    log('sub category name: ${subCategoryiesList.last.name}');
    subCategoryiesList.map((e) => log('cat name: ${e.name}'));
    notifyListeners();
  }

  //remove from previouse category
  goToPreviousCategory(context) async {
    if (subCategoryiesList.isNotEmpty) {
      subCategoryiesList.removeLast();

      // Get the parent ID of the current last subcategory
      print(subCategoryiesList.length);
      String parentId = subCategoryiesList.last.id.toString();
      print('last item: ${subCategoryiesList.last.name}');

      // Call the API to fetch subcategories for the current parent
      await getCategories(parentId: parentId, context);

      log(subCategoryiesList.length.toString());

      notifyListeners();
    }
  }
}
