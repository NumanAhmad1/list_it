import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/GetAllChatsUser.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/myNotificationData.dart';
import 'package:lisit_mobile_app/Screens/chat/messagesScreen.dart';
import 'package:lisit_mobile_app/Screens/detailsScreen/detailsScreen.dart';
import 'package:lisit_mobile_app/Screens/notification/widget/noNotifications.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';
import 'package:lisit_mobile_app/widgets/noInternet.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  getNotificationData() async {
    await context.read<MyNotificationData>().getMyNotification(context);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getNotificationData();
    });
    // TODO: implement initState
    super.initState();
  }

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
                      child: Icon(Icons.arrow_back_ios_new_rounded)),

                  //Notification title

                  H2Bold(text: Controller.getTag('notification')),

                  // trash icon button

                  const SizedBox.shrink(),
                ],
              ),
            ),
          ),
          // NoNotification(),
          // saved search card

          Consumer<MyNotificationData>(builder: (context, value, child) {
            return Expanded(
              child: value.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : value.error.isNotEmpty
                      ? value.error == 'No Internet Connection'
                          ? const NoInternet()
                          : H2Bold(text: '${value.error}')
                      : value.notificationsDataList.isEmpty
                          ? const NoNotification()
                          : ListView.builder(
                              itemCount: value.notificationsDataList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () async {
                                    if (value.notificationsDataList[index]
                                                ['RefType']
                                            .toString()
                                            .toLowerCase() ==
                                        'ad') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailsScreen(
                                                      tag: '$index',
                                                      carId: value
                                                          .notificationsDataList[
                                                              index]['RefId']
                                                          .toString())));
                                    }

                                    if (value.notificationsDataList[index]
                                                ['RefType']
                                            .toString()
                                            .toLowerCase() ==
                                        'chat') {
                                      var userdata =
                                          context.read<GetAllChatsUser>();
                                      await userdata.getAllChatsUser(context);
                                      for (var i = 0;
                                          i < userdata.allChatsUser.length;
                                          i++) {
                                        if (userdata.allChatsUser[i].refid
                                                    .trim() ==
                                                '${value.notificationsDataList[index]['RefId']}'
                                                    .trim() &&
                                            userdata.allChatsUser[i].to
                                                    .trim() ==
                                                '${value.notificationsDataList[index]['CreatedBy']}'
                                                    .trim()) {
                                          log('true------------------------');
                                          String adName = '';
                                          String location = '';
                                          String imageUrl = '';
                                          String price = '';
                                          (userdata.allChatsUser[i].ad)
                                              .forEach((element) {
                                            String e =
                                                element.adname.toString();
                                            String ev =
                                                element.value.toString();
                                            if (e == 'Add Pictures') {
                                              imageUrl = ev
                                                  .toString()
                                                  .split(',')[0]
                                                  .toString();
                                            } else if (e == 'Add Location') {
                                              location = ev
                                                  .toString()
                                                  .split('_')[0]
                                                  .toString();
                                            } else if (e == 'Price') {
                                              price = ev;
                                            } else if (e == 'Title') {
                                              adName = ev;
                                            }
                                          });

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (contexxt) =>
                                                  MessageScreen(
                                                adName: '$adName',
                                                userName:
                                                    '${userdata.allChatsUser[i].user[0].name}',
                                                refId:
                                                    '${value.notificationsDataList[index]['RefId']}',
                                                toId:
                                                    '${value.notificationsDataList[index]['CreatedBy']}',
                                                location: '$location',
                                                imageUrl: '$imageUrl',
                                                price: '$price',
                                                profileImage:
                                                    '${userdata.allChatsUser[i].user[0].profilePicture}',
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    }
                                    await context
                                        .read<MyNotificationData>()
                                        .markAsReadNotification(context,
                                            notificationId:
                                                '${value.notificationsDataList[index]['ID']}');
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 20.h),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    width: 1.sw,
                                    height: 99.h,
                                    decoration: BoxDecoration(
                                      color: value.notificationsDataList[index]
                                              ['IsRead']
                                          ? kbackgrounColor
                                          : kprimaryColor2,
                                      borderRadius: BorderRadius.circular(6.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              khelperTextColor.withOpacity(0.2),
                                          blurRadius: 8.r,
                                        )
                                      ],
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // card image
                                        Container(
                                          alignment: Alignment.center,
                                          height: 50.h,
                                          width: 50.w,
                                          decoration: BoxDecoration(
                                            color: ksearchFieldColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: SizedBox(
                                            height: 24.h,
                                            width: 24.w,
                                            child: Center(
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "${value.notificationsDataList[index]['NotifyPhoto']}",
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    const Center(
                                                        child: Icon(Icons
                                                            .error_outline)),
                                              ),
                                            ),
                                          ),
                                        ),

                                        //card data

                                        SizedBox(
                                          width: 250.w,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 10.w, right: 10.w),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                H3semi(
                                                  text:
                                                      '${Controller.languageChange(english: '${value.notificationsDataList[index]['Subject']}', arabic: '${value.notificationsDataList[index]['SubjectAr']}')}',
                                                  maxLines: 1,
                                                ),
                                                ParaRegular(
                                                  text:
                                                      '${Controller.languageChange(english: '${value.notificationsDataList[index]['Body']}', arabic: '${value.notificationsDataList[index]['BodyAr']}')}',
                                                  maxLines: 2,
                                                ),
                                                ParaRegular(
                                                  text:
                                                      '${Controller.formatDateTime(value.notificationsDataList[index]['CreatedAt'])}',
                                                  color: kprimaryColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        // more icon

                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            PopupMenuButton(
                                                surfaceTintColor:
                                                    kbackgrounColor,
                                                color: kbackgrounColor,
                                                padding: EdgeInsets.zero,
                                                itemBuilder: (context) {
                                                  return [
                                                    if (!value
                                                            .notificationsDataList[
                                                        index]['IsRead'])
                                                      PopupMenuItem(
                                                          onTap: () async {
                                                            await context
                                                                .read<
                                                                    MyNotificationData>()
                                                                .markAsReadNotification(
                                                                    context,
                                                                    notificationId:
                                                                        '${value.notificationsDataList[index]['ID']}');
                                                          },
                                                          child: ParaRegular(
                                                              text: Controller
                                                                  .getTag(
                                                                      'mark_read'))),
                                                    PopupMenuItem(
                                                        onTap: () async {
                                                          await context
                                                              .read<
                                                                  MyNotificationData>()
                                                              .removeNotification(
                                                                  context,
                                                                  notificationId:
                                                                      '${value.notificationsDataList[index]['ID']}');
                                                        },
                                                        child: ParaRegular(
                                                            text: Controller.getTag(
                                                                'remove_notification'))),
                                                  ];
                                                }),
                                            // GestureDetector(
                                            //   onTap: () {

                                            //   },
                                            //   child: Padding(
                                            //     padding:
                                            //         EdgeInsets.only(top: 12.h),
                                            //     child: const Icon(
                                            //         Icons.more_horiz_rounded),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
            );
          }),

          //column1 end
        ],
      ),
    );
  }
}
