import 'package:lisit_mobile_app/Controller/Providers/data/mySavedSearches.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class NotificationButtonDialog extends StatefulWidget {
  String searchId;
  String searchTitle;
  String searchCategory;
  String searchImage;
  String searchName;
  String searchValue;
  bool emailNotification;
  bool inAppnotification;
  NotificationButtonDialog({
    super.key,
    required this.searchId,
    required this.searchTitle,
    required this.searchCategory,
    required this.searchImage,
    required this.searchName,
    required this.searchValue,
    required this.emailNotification,
    required this.inAppnotification,
  });

  @override
  State<NotificationButtonDialog> createState() =>
      _NotificationButtonDialogState();
}

class _NotificationButtonDialogState extends State<NotificationButtonDialog> {
  bool emailNotification = false;
  bool emailNotification2 = false;
  @override
  void initState() {
    if (widget.emailNotification != null) {
      emailNotification = widget.emailNotification;
    }
    if (widget.inAppnotification != null) {
      emailNotification2 = widget.inAppnotification;
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: 0.48.sh,
        width: 1.sw,
        color: kbackgrounColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20.h, left: 12.w, right: 10.w),
              child: Row(
                children: [
                  const Icon(Icons.notifications_none),
                  SizedBox(
                    width: 10.w,
                  ),
                  H2semi(text: Controller.getTag('enable_notification')),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ParaRegular(
                    text: '${widget.searchCategory}',
                    maxLines: 1,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 248.w,
                        child: H3semi(
                          text: '${widget.searchTitle}',
                          maxLines: 2,
                        ),
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(left: 5.w),
                      //   alignment: Alignment.center,
                      //   padding: EdgeInsets.symmetric(horizontal: 5.w),
                      //   height: 14.h,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(7.r),
                      //     color: kprimaryColor,
                      //   ),
                      //   child: Text(
                      //     '5426 new ads',
                      //     style: TextStyle(
                      //       fontSize: 8.sp,
                      //       fontWeight: FontWeight.w700,
                      //       color: kbackgrounColor,
                      //     ),
                      //   ),
                      // ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15.w),
                        height: 39.h,
                        width: 76.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.r),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4.r,
                              color: khelperTextColor.withOpacity(0.2),
                            ),
                          ],
                        ),
                        child: Image.asset('assets/savedSearchImage.png'),
                      ),
                    ],
                  ),

                  // city button

                  // Container(
                  //   padding: EdgeInsets.symmetric(horizontal: 5.w),
                  //   height: 14.h,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(7.r),
                  //     color: ksecondaryColor2.withOpacity(0.5),
                  //   ),
                  //   child: Text(
                  //     'Dubai',
                  //     style: TextStyle(
                  //       fontSize: 8.sp,
                  //       fontWeight: FontWeight.w400,
                  //       color: kbackgrounColor,
                  //     ),
                  //   ),
                  // ),
                  const Divider(),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  H3Regular(text: Controller.getTag('email')),
                                  ParaRegular(
                                      text: Controller.getTag(
                                          'receive_emails_with_new_ads_that_match')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        inactiveTrackColor: kbackgrounColor,
                        thumbColor: MaterialStateProperty.resolveWith<Color?>(
                            (states) => kprimaryColor),
                        value: emailNotification,
                        activeColor: kbackgrounColor,
                        trackOutlineColor:
                            MaterialStateProperty.resolveWith<Color?>(
                                (states) => ksecondaryColor2),
                        onChanged: (value) {
                          emailNotification = value;
                          setState(() {});
                          print(emailNotification);
                        },
                      ),
                    ],
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
                                  'assets/inAppNotificationPreferences.png'),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 6.0.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  H3Regular(text: Controller.getTag('email')),
                                  ParaRegular(
                                      text: Controller.getTag(
                                          'receive_emails_with_new_ads_that_match')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        inactiveTrackColor: kbackgrounColor,
                        thumbColor: MaterialStateProperty.resolveWith<Color?>(
                            (states) => kprimaryColor),
                        value: emailNotification2,
                        activeColor: kbackgrounColor,
                        trackOutlineColor:
                            MaterialStateProperty.resolveWith<Color?>(
                                (states) => ksecondaryColor2),
                        onChanged: (value) {
                          emailNotification2 = value;
                          setState(() {});
                          print(emailNotification2);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // cancel button
                SizedBox(
                  width: 159.04.w,
                  height: 47.h,
                  child: MainButton(
                    text: Controller.getTag('cancel'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    isFilled: false,
                    textColor: ksecondaryColor,
                  ),
                ),
                // update button

                SizedBox(
                  height: 47.h,
                  width: 204.63.w,
                  child: MainButton(
                      text: Controller.getTag('update_notifications'),
                      onTap: () async {
                        Navigator.pop(context);
                        var result = await context
                            .read<MySavedSearchProvider>()
                            .updateSearchNotification(
                              context,
                              emailNotification: emailNotification,
                              inAppNotification: emailNotification2,
                              title: widget.searchName,
                              category: widget.searchValue,
                              searchId: widget.searchId,
                            );
                        if (result is! String) {
                          if (result['success'] == true) {
                            DisplayMessage(
                                context: context,
                                isTrue: true,
                                message: Controller.languageChange(
                                    english: result['message'],
                                    arabic: result['message_ar']));
                            await context
                                .read<MySavedSearchProvider>()
                                .getMySavedSearches(context);
                          } else {
                            DisplayMessage(
                                context: context,
                                isTrue: false,
                                message: result['error'] ??
                                    Controller.languageChange(
                                        english: result['message'],
                                        arabic: result['message_ar']));
                          }
                        } else {
                          DisplayMessage(
                              context: context,
                              isTrue: false,
                              message: result.toString());
                        }
                      }),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }
}
