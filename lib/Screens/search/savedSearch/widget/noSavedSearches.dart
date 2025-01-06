import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class NoSavedSearches extends StatelessWidget {
  const NoSavedSearches({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.8.sh,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 289.h,
            width: 189.w,
            child: Image.asset('assets/noSavedSearches.png'),
          ),
          SizedBox(
            height: 22.h,
          ),
          H2semi(text: Controller.getTag('you_have_no_saved_searches_yet')),
          SizedBox(
            height: 22.h,
          ),
          H3Regular(text: Controller.getTag('saving_a_search_helps_you_find_your_item_faster')),
        ],
      ),
    );
  }
}
