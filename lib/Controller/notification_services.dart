import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/GetAllChatsUser.dart';
import 'package:lisit_mobile_app/Screens/chat/chatScreen.dart';
import 'package:lisit_mobile_app/Screens/chat/messagesScreen.dart';
import 'package:lisit_mobile_app/Screens/detailsScreen/detailsScreen.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';
import 'package:lisit_mobile_app/main.dart';

class NotificationServices {
  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<String> getAPNToken() async {
    if (Platform.isIOS) {
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken != null) {
        print("APN: $apnsToken");
        return apnsToken;
      } else {
        await Future<void>.delayed(
          const Duration(
            seconds: 3,
          ),
        );
        apnsToken = await messaging.getAPNSToken();
        if (apnsToken != null) {
          print("APN: $apnsToken");
          return apnsToken;
        }
        return "No Token";
      }
    } else {
      return "No Token";
    }
  }

  //function to initialise flutter local notification plugin to show notifications for android when app is active
  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
      // handle interaction when app is active for android
      handleMessage(context, message);
    });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      if (message.notification != null) {
        print('Notification Title: ${message.notification!.title}');
        print('Notification Body: ${message.notification!.body}');
      }
    });
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      if (kDebugMode) {
        print("notifications title:${notification!.title}");
        print("notifications body:${notification.body}");
        print('count:${android!.count}');
        print('data:${message.data.toString()}');
      }

      if (Platform.isIOS) {
        forgroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      }
    });

    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Future<void> _firebaseMessagingBackgroundHandler(
  //     RemoteMessage message) async {
  //   // Handle your background message here
  //   print('Handling a background message: ${message.messageId}');
  // }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      //appsetting.AppSettings.openNotificationSettings();
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message) async {
    log("Called initLocal : ");
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
      showBadge: true,
      playSound: true,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
      sound: channel.sound,
      //     sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
      //  icon: largeIconPath
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        // Controller.languageChange(english: message.data['title'], arabic: message.data['title_ar']),
        // Controller.languageChange(english: message.data['body'], arabic: message.data['body_ar']),
        notificationDetails,
      );
    });
  }

  //function to get device token on which we will send the notifications
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      // if(isLoggedIn)
      // {
      //   fcmToken = event.toString();
      //   ApiServices.updateFCM(prefs!.getString(AppConstants.userEmail)!, fcmToken).then((value){
      //     print(value);
      //   });
      // }
      event.toString();
      if (kDebugMode) {
        print('refresh');
      }
    });
  }

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage(BuildContext context) async {
    // when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) async {
    if (message.data['type'] == 'chat') {
      var userdata = context.read<GetAllChatsUser>();
      await userdata.getAllChatsUser(context);
      for (var i = 0; i < userdata.allChatsUser.length; i++) {
        // log('reid from notififcation: ${message.data['refId']}');
        // log('toId from notififcation: ${message.data['toId']}');
        // log('reid from api: ${userdata.allChatsUser[i].refid}');
        // log('toId from api: ${userdata.allChatsUser[i].to}');
        // log('user Id: ${Controller.getUserId()}');

        if (userdata.allChatsUser[i].refid == '${message.data['refId']}' &&
            userdata.allChatsUser[i].to == '${message.data['toId']}') {
          // log('true-----------');
          String adName = '';
          String location = '';
          String imageUrl = '';
          String price = '';
          (userdata.allChatsUser[i].ad).forEach((element) {
            String e = element.adname.toString();
            String ev = element.value.toString();
            if (e == 'Add Pictures') {
              imageUrl = ev.toString().split(',')[0].toString();
            } else if (e == 'Add Location') {
              location = ev.toString().split('_')[0].toString();
            } else if (e == 'Price') {
              price = ev;
            } else if (e == 'Title') {
              adName = ev;
            }
          });
          Navigator.push(
            navKey.currentState!.context,
            MaterialPageRoute(
              builder: (contexxt) => MessageScreen(
                adName: '$adName',
                userName: '${userdata.allChatsUser[i].user[0].name}',
                refId: '${message.data['refId']}',
                toId: '${message.data['toId']}',
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
    if (message.data['type'] == 'ad') {
      Navigator.push(
          navKey.currentState!.context,
          MaterialPageRoute(
              builder: (context) =>
                  DetailsScreen(tag: '1', carId: '${message.data['refId']}')));
    }
  }

  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
