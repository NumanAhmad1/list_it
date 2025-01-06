import 'package:flutter/material.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class NoData extends StatelessWidget {
  const NoData({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.7.sh,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 267.h,
            width: 331.w,
            child: Image.asset('assets/homeScreenNoData.png'),
          ),
          SizedBox(
            height: 22.h,
          ),
          H2semi(text: Controller.getTag('there_are_no_Ads_posted_yet!')),
        ],
      ),
    );
  }
}
