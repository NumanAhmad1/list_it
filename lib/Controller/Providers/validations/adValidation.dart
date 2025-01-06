import 'package:lisit_mobile_app/const/lib_all.dart';

class AdValidation extends ChangeNotifier {
  bool makeModel = false;
  bool trim = false;
  bool regionalSpec = false;
  bool year = false;
  bool kiliometer = false;
  bool isInsured = false;
  bool price = false;
  bool phoneNumber = false;

  checkInputFeild(String value, bool booleanValue) {
    if (value.isEmpty) {
      booleanValue = true;
      notifyListeners();
    } else {
      booleanValue = false;
      notifyListeners();
    }
  }

  // checkDropDown(String value, bool booleanValue){
  //   if () {

  //   } else {

  //   }
  // }
}
