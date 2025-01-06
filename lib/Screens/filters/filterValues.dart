import 'package:lisit_mobile_app/const/lib_all.dart';

class FilterValues extends ChangeNotifier {
  Map<String, dynamic> results = {
    'Category': 'Cars',
    'Emirates': 'All Cities',
    'Price': '',
    'Title': '',
  };

  updateCategory({required String keyword, required String key}) {
    if (key == 'Category') {
      results['Category'] = keyword;
      notifyListeners();
    } else if (key == 'Emirates') {
      results['Emirates'] = keyword;
      notifyListeners();
    } else if (key == 'Price') {
      results['Price'] = keyword;
      notifyListeners();
    } else if (key == 'Title') {
      results['Title'] = keyword;
      notifyListeners();
    }
  }

  Map<String, dynamic> selectedFilterData = {};

  selectValue(
      {required String value, required List dropdownList, required int index}) {
    selectedFilterData[value] = dropdownList[index]['name'];
    notifyListeners();
  }

  selectValueFromDropdown(
      {required String value, required List dropdownList, required int index}) {
    selectedFilterData[value] = dropdownList[index]['attributeName'];
    notifyListeners();
  }
}
