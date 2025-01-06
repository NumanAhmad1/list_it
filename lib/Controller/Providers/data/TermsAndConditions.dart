import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class TermsAndConditions extends ChangeNotifier{
  bool isLoading = false;
  String error = '';
  String webContent = '';
  startLoading(){
    isLoading = true;
    notifyListeners();
  }
  endLoading(){
    isLoading = false;
    notifyListeners();
  }

  getTermsAndConditions(context,type)async{
    error = '';
    webContent = '';
    notifyListeners();
    startLoading();
    var response = await CallApi.getApi(context, parametersMap: {'type': type}, isAdmin: false, endPoint: '/get-website-content');

    if (response['data'] is List<dynamic>) {
      webContent = response['data'][0][Controller.languageChange(english: 'mobileEnglish', arabic: 'mobileArabic')];
      notifyListeners();
    } else {
      webContent = "error: ${response['error'].toString()}";
      if (kDebugMode) {
        print('Unexpected API response format: $response');
      }
    }
    isLoading = false;
    notifyListeners();

    endLoading();
  }
}