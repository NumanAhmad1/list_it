import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/updateProfile.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class NotificationPreferences extends StatefulWidget {
  const NotificationPreferences({super.key});

  @override
  State<NotificationPreferences> createState() =>
      _NotificationPreferencesState();
}

class _NotificationPreferencesState extends State<NotificationPreferences> {
  @override
  void initState() {
    if (Controller.getUserEmailNotification() == true) {
      emailNotification = true;
    } else {
      emailNotification = false;
    }
    if (Controller.getUserMobileNotification() == true) {
      // inAppNotification = true;
    } else {
      // inAppNotification = false;
    }
    if (Controller.getUserFcmNotification() == true) {
      pushNotification = true;
    } else {
      pushNotification = false;
    }

    if (Controller.getUserFcmNotification() == true &&
        Controller.getUserMobileNotification() == true &&
        Controller.getUserEmailNotification() == true) {
      mainNotification = true;
    } else {}

    // TODO: implement initState
    super.initState();
  }

  bool mainNotification = false;
  bool emailNotification = false;
  // bool inAppNotification = false;
  bool pushNotification = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // AppBar
          Container(
            width: 1.sw,
            height: 90.h,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: ksearchFieldColor),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // back icon
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back_ios_new_rounded)),

                  //Notification title

                  GestureDetector(
                      onTap: () {
                        print('$pushNotification');
                        // print('$inAppNotification');
                        print('$emailNotification');
                      },
                      child: H2Bold(
                          text: Controller.getTag('notification_preferences'))),

                  // trash icon button

                  const SizedBox.shrink(),
                ],
              ),
            ),
          ),

          // body

          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding:
                //       EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                //   child: H2Bold(text: 'Offers & Updates'),
                // ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 20.w),
                //   child: H3Regular(
                //       text:
                //           'Get notified to know about latest offers and promotion '),
                // ),
                // Padding(
                //   padding:
                //       EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                //   child: H2Bold(text: 'Notifications'),
                // ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 20.w),
                //   child: H3Regular(
                //       text:
                //           'Select the type of notification you would like to receive'),
                // ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  margin:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                  width: 1.sw,
                  decoration: BoxDecoration(
                    color: ksearchFieldColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          H3semi(
                              text: Controller.getTag('enable_notifications')),
                          Switch(
                            inactiveTrackColor: kbackgrounColor,
                            thumbColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                    (states) => kprimaryColor),
                            value: mainNotification,
                            activeColor: kbackgrounColor,
                            trackOutlineColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                    (states) => ksecondaryColor2),
                            onChanged: (value) async {
                              mainNotification = value;
                              if (mainNotification == true) {
                                pushNotification = true;
                                // inAppNotification = true;
                                emailNotification = true;
                              } else {
                                pushNotification = false;
                                // inAppNotification = false;
                                emailNotification = false;
                              }
                              setState(() {});
                              var result = await context
                                  .read<UpdateProfile>()
                                  .updateUser(context, profileData: {
                                "name": "${Controller.getUserName()}",
                                "profilePicture":
                                    "${Controller.getUserPhotoUrl()}",
                                "emailNotify": emailNotification,
                                // "mobileNotify": inAppNotification,
                                "mobileFcmNotify": pushNotification,
                              });
                              var updatedResult = result['data'];
                              SaveUserNotificationPreferences(
                                  emailNotification:
                                      updatedResult['EmailNotify'],
                                  mobileNotification:
                                      updatedResult['MobileNotify'],
                                  fcmNotification:
                                      updatedResult['MobileFcmNotify']);
                            },
                          ),
                        ],
                      ),
                      Divider(
                        color: ksecondaryColor,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 29.81.h,
                                  width: 21.91.w,
                                  child: Image.asset(
                                      'assets/emailNotificationPreferences.png'),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 6.0.w),
                                  child: H3Regular(
                                      text: Controller.getTag('email')),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            inactiveTrackColor: kbackgrounColor,
                            thumbColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                    (states) => kprimaryColor),
                            value: emailNotification,
                            activeColor: kbackgrounColor,
                            trackOutlineColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                    (states) => ksecondaryColor2),
                            onChanged: (value) async {
                              emailNotification = value;
                              if (emailNotification == false &&
                                      pushNotification == false
                                  // &&
                                  // inAppNotification == false
                                  ) {
                                mainNotification = false;
                              }
                              if (emailNotification == true &&
                                      pushNotification == true
                                  //  &&
                                  // inAppNotification == true
                                  ) {
                                mainNotification = true;
                              }
                              setState(() {});
                              var result = await context
                                  .read<UpdateProfile>()
                                  .updateUser(context, profileData: {
                                "name": "${Controller.getUserName()}",
                                "profilePicture":
                                    "${Controller.getUserPhotoUrl()}",
                                "emailNotify": emailNotification,
                                // "mobileNotify": inAppNotification,
                                "mobileFcmNotify": pushNotification,
                              });
                              var updatedResult = result['data'];
                              SaveUserNotificationPreferences(
                                  emailNotification:
                                      updatedResult['EmailNotify'],
                                  mobileNotification:
                                      updatedResult['MobileNotify'],
                                  fcmNotification:
                                      updatedResult['MobileFcmNotify']);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      Divider(
                        color: ksecondaryColor,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     SizedBox(
                      //       child: Row(
                      //         children: [
                      //           SizedBox(
                      //             height: 29.81.h,
                      //             width: 21.91.w,
                      //             child: Image.asset(
                      //                 'assets/inAppNotificationPreferences.png'),
                      //           ),
                      //           Padding(
                      //             padding: EdgeInsets.only(left: 6.0.w),
                      //             child: H3Regular(
                      //                 text: Controller.getTag('in_app')),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     Switch(
                      //       inactiveTrackColor: kbackgrounColor,
                      //       thumbColor:
                      //           MaterialStateProperty.resolveWith<Color?>(
                      //               (states) => kprimaryColor),
                      //       value: inAppNotification,
                      //       activeColor: kbackgrounColor,
                      //       trackOutlineColor:
                      //           MaterialStateProperty.resolveWith<Color?>(
                      //               (states) => ksecondaryColor2),
                      //       onChanged: (value) async {
                      //         inAppNotification = value;
                      //         if (emailNotification == false &&
                      //             pushNotification == false &&
                      //             inAppNotification == false) {
                      //           mainNotification = false;
                      //         }
                      //         if (emailNotification == true &&
                      //             pushNotification == true &&
                      //             inAppNotification == true) {
                      //           mainNotification = true;
                      //         }
                      //         setState(() {});
                      //         var result = await context
                      //             .read<UpdateProfile>()
                      //             .updateUser(context, profileData: {
                      //           "name": "${Controller.getUserName()}",
                      //           "profilePicture":
                      //               "${Controller.getUserPhotoUrl()}",
                      //           "emailNotify": emailNotification,
                      //           "mobileNotify": inAppNotification,
                      //           "mobileFcmNotify": pushNotification,
                      //         });

                      //         var updatedResult = result['data'];
                      //         SaveUserNotificationPreferences(
                      //             emailNotification:
                      //                 updatedResult['EmailNotify'],
                      //             mobileNotification:
                      //                 updatedResult['MobileNotify'],
                      //             fcmNotification:
                      //                 updatedResult['MobileFcmNotify']);
                      //         setState(() {});
                      //       },
                      //     ),
                      //   ],
                      // ),
                      // Divider(
                      //   color: ksecondaryColor,
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 29.81.h,
                                  width: 21.91.w,
                                  child: Image.asset(
                                      'assets/inAppNotificationPreferences.png'),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 6.0.w),
                                  child: H3Regular(
                                      text: Controller.getTag('push')),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            inactiveTrackColor: kbackgrounColor,
                            thumbColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                    (states) => kprimaryColor),
                            value: pushNotification,
                            activeColor: kbackgrounColor,
                            trackOutlineColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                    (states) => ksecondaryColor2),
                            onChanged: (value) async {
                              pushNotification = value;
                              if (emailNotification == false &&
                                      pushNotification == false
                                  // &&
                                  // inAppNotification == false
                                  ) {
                                mainNotification = false;
                              }
                              if (emailNotification == true &&
                                      pushNotification == true
                                  //  &&
                                  // inAppNotification == true
                                  ) {
                                mainNotification = true;
                              }
                              setState(() {});
                              var result = await context
                                  .read<UpdateProfile>()
                                  .updateUser(context, profileData: {
                                "name": "${Controller.getUserName()}",
                                "profilePicture":
                                    "${Controller.getUserPhotoUrl()}",
                                "emailNotify": emailNotification,
                                // "mobileNotify": inAppNotification,
                                "mobileFcmNotify": pushNotification,
                              });
                              var updatedResult = result['data'];
                              SaveUserNotificationPreferences(
                                  emailNotification:
                                      updatedResult['EmailNotify'],
                                  mobileNotification:
                                      updatedResult['MobileNotify'],
                                  fcmNotification:
                                      updatedResult['MobileFcmNotify']);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // body column  end
              ],
            ),
          ),

          //column1 end
        ],
      ),
    );
  }
}

SaveUserNotificationPreferences(
    {required bool emailNotification,
    required bool mobileNotification,
    required bool fcmNotification}) {
  Controller.saveUserEmailNotification(emailNotification: emailNotification);
  Controller.saveUserFcmNotification(fcmNotification: fcmNotification);
  Controller.saveUserMobileNotification(mobileNotification: mobileNotification);
}
