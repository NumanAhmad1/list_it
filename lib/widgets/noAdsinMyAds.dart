import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lisit_mobile_app/Screens/motors/motors.dart';
import 'package:lisit_mobile_app/Screens/verifyNumber/enterNumber.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class NoAdsInMyAds extends StatelessWidget {
  int noAdText;
  NoAdsInMyAds({super.key, required this.noAdText});
  List<String> noAdMainTextList = [
    Controller.getTag('you_haven’t_placed_any_ads_yet_that_are_rejected'),
    Controller.getTag('you_don’t_have_any_ads_that_are_live'),
    Controller.getTag('you_don’t_have_any_ads_that_are_under_review'),
    Controller.getTag('you_haven’t_placed_any_ads_that_are_deleted'),
    Controller.getTag('you_haven’t_placed_any_ads_yet_that_are_rejected'),
    Controller.getTag('you_haven’t_placed_any_ads_expired'),
  ];

  @override
  Widget build(BuildContext context) {
    log('$noAdText');
    return SizedBox(
      height: 0.7.sh,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 302.w,
            height: 248.h,
            child: Image.asset('assets/noAdsInMyAds.png'),
          ),
          SizedBox(
            height: 22.h,
          ),
          SizedBox(
            width: 286.w,
            child: H2semi(
              text: '${noAdMainTextList[noAdText]}',
              maxLines: 3,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 22.h,
          ),
          MainButton(
              text: Controller.getTag('post_ad_now'),
              onTap: () {
                Controller.isUserVerified != true
                    ? showModalBottomSheet(
                        shape: const BeveledRectangleBorder(),
                        barrierColor: kbackgrounColor,
                        backgroundColor: kbackgrounColor,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return EnterNumber();
                        })
                    : Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Motors()));
              }),
        ],
      ),
    );
  }
}
