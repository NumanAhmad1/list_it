import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class LocalProvider extends ChangeNotifier {
  bool isEnglishLoading = false;

  int scrolledIndex = 0;


  bool isLoginfromBid = false;

  scrollList(
      {required ScrollController scrollController,
        required double itemHeight,
        required int listLength}) {

    scrolledIndex = (scrollController.position.pixels + 400.h) ~/ itemHeight;
    notifyListeners();
    double maxScroll = scrollController.position.maxScrollExtent;
    double currentScroll = scrollController.position.pixels;
    if (currentScroll >= maxScroll) {
      // Scrolled to the bottom
      scrolledIndex = listLength;
      notifyListeners(); // Call your notification method
    }
  }

  showDialoge() {
    isLoginfromBid = true;
    notifyListeners();
  }

  englishLoading() {
    isEnglishLoading = !isEnglishLoading;
    notifyListeners();
  }

  bool isArabicLoading = false;

  arabicLoading() {
    isArabicLoading = !isArabicLoading;
    notifyListeners();
  }

  Locale locale = Controller.getLanguage().toString().toLowerCase() == 'english'
      ? const Locale('en')
      : const Locale('ar');

  setLocal() {
    locale = Controller.getLanguage().toString().toLowerCase() == 'english'
        ? const Locale('en')
        : const Locale('ar');

    notifyListeners();
  }
}
