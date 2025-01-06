import 'package:lisit_mobile_app/const/lib_all.dart';

class GetCities extends ChangeNotifier {
  bool isLoading = false;
  String error = '';
  List cities = [];
  List categories = [];

  getCities(context, {required String teldaSeparatedFilterValues}) async {
    categories.clear();
    cities.clear();
    isLoading = true;
    notifyListeners();
    error = '';
    notifyListeners();

    var result = await CallApi.getApi(context,
        parametersMap: {},
        isAdmin: true,
        endPoint:
            '/data/get-category-fields-by-name?categoryId=135&categoryFieldName=Emirates');
    isLoading = false;
    notifyListeners();

    if (result['data'] != null) {
      if ((result['data'][0]['Attributes'] as List).isNotEmpty) {
        cities = (result['data'][0]['Attributes'] as List)
            .map((e) =>
                {"value": e['attributeName'], "value_ar": e['attributeNameAr']})
            .toList();
      }
    }

    var response = await CallApi.getApi(context,
        parametersMap: {}, isAdmin: true, endPoint: '/category?parent_id=0');

    if (response is! String) {
      if (response is Map<String, dynamic>) {
        if (response['success'] == true) {
          if (response['data'] != null &&
              (response['data'] as List).isNotEmpty) {
            categories = (response['data'] as List).map((e) => e).toList();
          }

          isLoading = false;
          notifyListeners();
        } else {
          error = response['message'];
          notifyListeners();
          isLoading = false;
          notifyListeners();
        }
      } else {
        error = 'Some thing went wrong';
        notifyListeners();
        isLoading = false;
        notifyListeners();
      }
    } else {
      error = response;
      notifyListeners();
      isLoading = false;
      notifyListeners();
    }
  }
}
