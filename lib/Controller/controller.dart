import 'dart:developer';
import 'dart:convert' as convert;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/favourite.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';
import 'package:lisit_mobile_app/main.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import 'Providers/data/GetChatMessages.dart';

class Controller {
  static bool isLoggedIn = false;
  static String? userName;
  static String? userGmail;
  static String? userPhotoUrl;
  static String? userId;
  static String? userToken;
  static bool? isUserActive;
  static bool? isUserVerified;
  static String? userAccountType;
  static bool? isNumberVerified;
  static bool refreshTimer = false;
  static String refId = "";
  static String toId = "";

  static List<String> socketRoom = [];
  static String urlSoc =
      "${CallApi.baseUrl.replaceFirst("https", "wss").replaceRange(CallApi.baseUrl.length - 6, null, "")}";
  // static String urlSoc = "wss://api.listit.ae";

  // static String urlSoc = "http://192.168.100.73:80";
  static IO.Socket socket = IO.io(
    Uri.parse(urlSoc).toString(),
    OptionBuilder()
        .setTransports(['websocket']) // for Flutter or Dart VM
        .disableAutoConnect() // disable auto-connection
        // .setPath("/")
        .build(),
  );

  /// Socket IO
  static initializeSocket(context) {
    print("UserID : ${Controller.getUserId()}");
    try {
      // var ws = await WebSocket.connect('ws://192.168.100.73/socket.io');
      // ws.listen((event) {
      //   print(event);
      // });
      socket.connect();
      socket.onConnect((_) {
        socket.emit('joinroom', {"userid": Controller.getUserId()});
        log('Connection established: ${socket.opts}');
      });
      socket.onConnectError((err) => log("Connection Error : $err"));
      socket.onError((err) => log("Error : $err"));
      socket.on('receive', (data) {
        log("receive data : ${data['Refid']} ${data['To']}");
        refId = data['Refid'];
        toId = data['To'];
        socket.emit('joinroom', {"userid": Controller.getUserId()});
        GetChatMessages().getChatMessages(data['Refid'], data['To'], context);
      });
      socket.on('connectedrooms', (data) {
        log("connected data : ${data.toString().replaceAll("{", "").replaceAll("}", "").split(",")}");
        socketRoom =
            data.toString().replaceAll("{", "").replaceAll("}", "").split(",");
        log("Socket rooms ${socketRoom[0]}");
      });
      socket.on('chatusers', (data) => log("user data : $data"));
      socket.onDisconnect((e) {
        log('disconnect');
        log(e);
      });
    } catch (e) {
      log("Socket error :");
      log(e.toString());
    }
  }

  static late Box _box;

  static Future<void> init() async {
    await Hive.openBox('myBox');
    _box = Hive.box('myBox');
  }

  static void saveFirstInstall() async {
    await _box.put('isFirstInstall', true);
  }

  static bool getFirstInstall() {
    return _box.get('isFirstInstall', defaultValue: false);
  }

//save firebase fcm token
  static saveFcmToken({required String fcmToken}) async {
    await fcmPrefs!.setString('fcmToken', fcmToken);
  }

  //get fcm token

  static getFcmToken() {
    String? fcmToken = fcmPrefs!.getString('fcmToken');

    return fcmToken ?? '';
  }

  //save City

  static saveCity({required String City}) async {
    await prefs!.setString('City', City);
  }

  //get City

  static getCity() {
    String? City = prefs?.getString('City');
    return City;
  }

  //save Language

  static saveLanguage({required String language}) async {
    await prefs!.setString('language', language);
  }

  // static Future<void> getCSRF(context) async {

  //   var endPoint = "/protected"; // The endpoint to get CSRF token
  //   var response = await CallApi.getApi(context,
  //       parametersMap: {}, isAdmin: false, endPoint: endPoint);

  //   log("Response: $response");

  //   // Extract CSRF token from the response
  //   csrf = response['csrf_token'];
  //   log("CSRF Token: $csrf");

  //   // Store the CSRF token for future requests (optional)
  //   final storage = FlutterSecureStorage();
  //   await storage.write(key: 'csrf_token', value: csrf);
  // }
  //get language

  static getLanguage() {
    String? language = prefs?.getString('language');
    return language ?? 'English';
  }

  // //first Install

  // static saveFirstInstall() async {
  //   await prefs?.setBool('isFirstLogin', true);
  // }

  // static getFirstInstall() {
  //   bool? firstLogin = prefs?.getBool('isFirstLogin');

  //   return firstLogin;
  // }

  /// Socket IO
  static sendMessageToSocket(dynamic msg) {
    refId = "";
    toId = "";
    log("Send to Socket : ${msg}");
    socket.emit('send', msg);
    Future.delayed(const Duration(seconds: 5), () {
      return true;
    });
  }

  //save isNumber verified
  static saveIsNumberVerified({required bool isNumberVerifend}) async {
    await prefs!.setBool("isNumberVerified", isNumberVerifend);
  }

  //get verified number

  static getIsVerifiedNumber() {
    bool? isNumVerified = prefs!.getBool('isNumberVerified');
    isNumberVerified = isNumVerified;
    return isNumVerified;
  }

  //save isNumber verified
  static saveEmirate({required String emirate}) async {
    await prefs!.setString("emirate", emirate);
  }

  //get verified number

  static getEmirate() {
    String? isNumVerified = prefs!.getString('emirate');
    return isNumVerified;
  }
// save login

  static saveIsUserVerified({required bool isUserVerifend}) async {
    await prefs!.setBool("isUserVerified", isUserVerifend);
  }

  // get login

  static getisUserVerified() {
    bool? isuserverified = prefs?.getBool('isUserVerified');
    isUserVerified = isuserverified ?? false;
    return isuserverified;
  }
  // save isUserActive

  static saveIsUserActive({required bool isUserActive}) async {
    await prefs!.setBool("isUserActive", isUserActive);
  }

  // get isUserActive

  static getisUserActive() {
    bool? getIsUserActive = prefs?.getBool('isUserActive');
    return getIsUserActive;
  }

// save userId

  static saveUserAccountType({required String userAccountType}) async {
    await prefs!.setString('userAccountType', userAccountType);
  }
  // get userId

  static getUserAccountType() {
    String? getUserAccountType = prefs?.getString('userAccountType');
    return getUserAccountType;
  }
// save userToken

  static saveUserToken({required String userToken}) async {
    await prefs!.setString('userToken', userToken);
  }
  // get userToken

  static getUserToken() {
    String? getUserToken = prefs?.getString('userToken');
    userToken = getUserToken;
    return getUserToken;
  }
  // save email notification

  static saveUserEmailNotification({required bool emailNotification}) async {
    await prefs!.setBool('emailNotification', emailNotification);
  }
  // get email notification

  static getUserEmailNotification() {
    bool? emailNotification = prefs?.getBool('emailNotification');
    return emailNotification;
  }

  // save MobileNotification

  static saveUserMobileNotification({required bool mobileNotification}) async {
    await prefs!.setBool('mobileNotification', mobileNotification);
  }
  // get MobileNotification

  static getUserMobileNotification() {
    bool? getUsersMobileNotification = prefs?.getBool('mobileNotification');
    return getUsersMobileNotification;
  }

  // save fcmNotificaiton

  static saveUserFcmNotification({required bool fcmNotification}) async {
    await prefs!.setBool('fcmNotification', fcmNotification);
  }

  // get userId

  static getUserFcmNotification() {
    bool? getUserFcmNotifications = prefs?.getBool('fcmNotification');
    return getUserFcmNotifications;
  }

// save userId

  static saveUserId({required String userId}) async {
    await prefs!.setString('userId', userId);
  }
  // get userId

  static getUserId() {
    String? getUserId = prefs?.getString('userId');
    userId = getUserId;
    return getUserId;
  }
// save PhotoUrl

  static saveUserPhotoUrl({required String userPhotoUrl}) async {
    await prefs!.setString('userPhotoUrl', userPhotoUrl);
  }
  // get PhotoUrl

  static getUserPhotoUrl() {
    String? getUserPhotoUrl = prefs?.getString('userPhotoUrl');
    userPhotoUrl = getUserPhotoUrl;
    return getUserPhotoUrl;
  }

// save gmail

  static saveUserGmail({required String userGmail}) async {
    await prefs!.setString('userGmail', userGmail);
  }
  // get gmail

  static getUserGmail() {
    String? getUserGmail = prefs?.getString('userGmail');
    userGmail = getUserGmail;
    return getUserGmail;
  }

  // save userPhoneNumber

  static saveUserPhoneNumber({required String userPhoneNumber}) async {
    await prefs!.setString('userPhoneNumber', userPhoneNumber);
  }
  // get userPhoneNumber

  static getUserPhoneNumber() {
    String? getUserGmail = prefs?.getString('userPhoneNumber');
    userGmail = getUserGmail;
    return getUserGmail;
  }

  // save userName

  static saveUserName({required String userName}) async {
    await prefs!.setString('userName', userName);
  }
  // get userName

  static getUserName() {
    String? getUserName = prefs?.getString('userName');
    userName = getUserName;
    return getUserName;
  }
  // save login

  static saveLogin({required bool isLogin}) async {
    await prefs?.setBool("isLoggedIn", isLogin);
  }

  // get login

  static getLogin() {
    bool? isLoggIn = prefs?.getBool('isLoggedIn') ?? false;
    isLoggedIn = isLoggIn;
    return isLoggIn;
  }

  /// set language tags
  static setLanguageTags({required String tag}) async {
    await prefs?.setString("tags", tag);
  }

  /// get language tags

  static getLanguageTags(context) async {
    var endPoint = "/get-translations";
    var response = await CallApi.getApi(context,
        parametersMap: {}, endPoint: endPoint, isAdmin: false);
    if (response is Map) {
      if (response['data'] != null) {
        tags = response['data'];
        setLanguageTags(tag: tags.toString());
      } else if (prefs?.getString('tags') != null) {
        tags = convert.jsonDecode(prefs!.getString('tags')!);
      } else {
        log("Error encountered retrieving Language package");
      }
    } else if (prefs?.getString('tags') != null) {
      tags = convert.jsonDecode(prefs!.getString('tags')!);
    } else {
      log("Error encountered retrieving Language package");
    }
    return tags;
  }

  static String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} mins ago';
    }
    if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      int months = difference.inDays ~/ 30;
      return '$months months ago';
    } else {
      return DateFormat.yMMMd().format(dateTime);
    }
  }

  static String languageChange(
      {required dynamic english, required dynamic arabic}) {
    if (getLanguage() == 'English') {
      return english.toString();
    } else {
      if (arabic.toString().isNotEmpty && arabic != null) {
        return arabic.toString();
      } else {
        return english.toString();
      }
    }
  }

  static String getTag(String tag) {
    if (tags?[tag] != null) {
      return '${tags?[tag][Controller.languageChange(english: "en", arabic: "ar")] ?? ""}';
    } else {
      return "";
    }
  }

  static logoutUser(context) async {
    String langPref = getLanguage();
    await CallApi.postApi(context,
        isInsideData: false,
        parametersList: {},
        isAdmin: false,
        token: Controller.getUserToken(),
        endPoint: "/user/logout");
    await prefs?.clear();
    saveLanguage(language: langPref);
    // if (!context.mounted) return;
    // context.read<Favourite>().favouriteIdList.clear();
    // context.read<Favourite>().favouriteDataList.clear();
    // context.read<Favourite>().favouriteList.clear();
  }
}


// data:{
//   "type": chat,
//   "data": {
//     "refId":'id',
//     "toId": 'id'
//   },
// }

// data:{
//   "type": ad,
//   "data": {
//     "adId": '',
//   },
// }
