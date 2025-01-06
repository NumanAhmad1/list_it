import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class NoSearchResultFound extends StatelessWidget {
  const NoSearchResultFound({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.8.sh,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 279.h,
            width: 189.w,
            child: Image.asset('assets/noResultFound.png'),
          ),
          SizedBox(
            height: 22.h,
          ),
          H2semi(text: Controller.getTag('no_results_found')),
        ],
      ),
    );
  }
}
