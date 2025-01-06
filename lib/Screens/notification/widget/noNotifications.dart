import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class NoNotification extends StatefulWidget {
  const NoNotification({super.key});

  @override
  State<NoNotification> createState() => _NoNotificationState();
}

class _NoNotificationState extends State<NoNotification> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.8.sh,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(),
            height: 248.h,
            width: 302.w,
            child: Image.asset(
              'assets/noNotification.png',
              // fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 22.h,
          ),
          H2semi(text: Controller.getTag('No_notifications._._.yet!')),
          SizedBox(
            height: 22.h,
          ),
          H3Regular(text: Controller.getTag('view_ad_recommendations_and_news_by_listit,_etc._.')),
        ],
      ),
    );
  }
}
