import 'dart:developer';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'Controller/Providers/data/TermsAndConditions.dart';
import 'l10n/l10n.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/GetChatMessages.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/adReport.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/favourite.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/getUserProfile.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/registerUser.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/siginApiCall.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/updateProfile.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/verifyNumber.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/verifyOTP.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/deleteMyAd.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/getCarDetails.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/getCities.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/getDealerAds.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/getDetailsbyVin.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/homeScreenData.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/myAds.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/myNotificationData.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/mySavedSearches.dart';
import 'package:lisit_mobile_app/Controller/Providers/validations/authValidation.dart';
import 'package:lisit_mobile_app/Controller/notification_services.dart';
import 'package:lisit_mobile_app/Screens/bottomNavigationBar/bottomNavigationBarScreen.dart';
import 'package:lisit_mobile_app/Screens/filters/filterValues.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';
import 'package:lisit_mobile_app/services/localProvider.dart';
import 'Controller/Providers/data/GetAllChatsUser.dart';
import 'Controller/Providers/data/addSummary.dart';
import 'Controller/Providers/data/adsInputField.dart';
import 'Controller/Providers/data/getCategory.dart';
import 'Controller/Providers/data/getCategoryListing.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// import 'package: localization_i18n_arb/110n/110n.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
String csrf = '';
SharedPreferences? prefs;
Map? tags;
GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
SharedPreferences? fcmPrefs;
String? fcmToken;
String? apnToken;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await dotenv.load(fileName: ".env");
  // log("test env ------------------------ ${dotenv.env['baseUrl']}");
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.android,
    ).whenComplete(() {
      print("completedAppInitialize");
    });
  } else if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      name: 'listIt',
      options: DefaultFirebaseOptions.ios,
    ).whenComplete(() async {
      print("completedAppInitialize");
    });
  }

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  observer.analytics.logAppOpen();

  await Hive.initFlutter();

  // Hive.init(Directory.current.path);
  await Controller.init(); // Initialize Hive

  if (Platform.isIOS) {
    apnToken = await FirebaseMessaging.instance.getAPNSToken();
    if (apnToken != null) {
      print("APN Token: $apnToken");
    } else {
      await Future<void>.delayed(
        const Duration(
          seconds: 3,
        ),
      );
      apnToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnToken != null) {
        print("APN Token: $apnToken");
      }
    }
  } else {
    print("APN Token: $apnToken");
  }
  fcmToken = await FirebaseMessaging.instance.getToken();
  print("fcmToken: $fcmToken");
  prefs = await SharedPreferences.getInstance();
  fcmPrefs = await SharedPreferences.getInstance();

  Controller.saveFcmToken(fcmToken: fcmToken ?? '');
  Controller.getFcmToken();
  // log('${Controller.getFcmToken()}');

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Controller.initializeSocket();

  // bool isTokenTrue = await GetCategory().checkToken();

  // log('this is token: $isTokenTrue');

  log('this is firstInstall aan: ${Controller.getFirstInstall()}');
  if (Controller.getFirstInstall() != true) {
    log('this is firstInstall a: ${Controller.getFirstInstall()}');

    prefs?.clear();
    log('this is firstInstall a c: ${Controller.getFirstInstall()}');

    Controller.saveFirstInstall();
    log('this is firstInstall a s: ${Controller.getFirstInstall()}');
  }
  log('this is firstInstall a b: ${Controller.getFirstInstall()}');

  // if (!isTokenTrue) {
  //   prefs!.clear();
  // }
  // try {
  //   IO.Socket socket = IO.io('http://192.168.100.73:8081/socket.io/',
  //     <String,dynamic>{
  //     'autoConnect':false,
  //     'transports':['websocket'],
  //     },
  //   );
  //   socket.connect();
  //   socket.onConnect((_) {
  //     print('Connection established');
  //     socket.emit('chat', 'test');
  //   });
  //   socket.onConnectError((err)=>print(err));
  //   socket.onError((err)=>print(err));
  //   socket.on('chat', (data) => print(data));
  //   socket.onDisconnect((e) {
  //     print('disconnect');
  //     print(e);
  //   });

  // }
  // catch(e){
  //   print("Socket error :");
  //   print(e);
  // }
  // socket.on('fromServer', (_) => print(_));
  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle your background message here
  print('Handling a background message: ${message.messageId}');
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getUserProfile() async {
    Controller.getLanguageTags(context);

    await GetUserProfile().getUserProfile(context);
    if (Controller.getisUserActive() != true) {
      prefs!.clear();
    }
  }

  // This widget is the root of your application.
  @override
  void initState() {
    refereshJWTToken();
    var notificationServices = NotificationServices();
    notificationServices.requestNotificationPermission();
    getUserProfile();
    if (Platform.isIOS) {
      notificationServices.getAPNToken().then((value) {
        if (value != "No Token") {
          notificationServices.getDeviceToken().then((value) {
            fcmToken = value;
            print("FCM : $fcmToken");
            // if (isLoggedIn) {
            //   ApiServices.updateFCM(
            //           prefs!.getString(AppConstants.userEmail)!, fcmToken)
            //       .then((value) {
            //     print(value);
            //   });
            // }

            // if (kDebugMode) {
            //   print('device token');
            //   print(value);
            // }
          });
        } else {
          print(value);
        }
      });
    } else {
      notificationServices.getDeviceToken().then((value) {
        fcmToken = value;
        //   if (isLoggedIn) {
        //     ApiServices.updateFCM(
        //             prefs!.getString(AppConstants.userEmail)!, fcmToken)
        //         .then((value) {
        //       print(value);
        //     });
        //   }

        //   if (kDebugMode) {
        //     print('device token');
        //     print(value);
        //   }
      });
    }

    // TODO: implement initState
    super.initState();
  }

  refereshJWTToken() async {
    // Controller.getCSRF(context);
    log('calling api referesh');
    await CallApi.refereshToken(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => AuthValidation()),
        ChangeNotifierProvider(create: (c) => GetCategory()),
        ChangeNotifierProvider(create: (c) => AdsInputField()),
        ChangeNotifierProvider(create: (c) => AddSummary()),
        ChangeNotifierProvider(create: (c) => GetAllChatsUser()),
        ChangeNotifierProvider(create: (c) => GetChatMessages()),
        ChangeNotifierProvider(create: (c) => GetCategoryListing()),
        ChangeNotifierProvider(create: (c) => GetCarDetails()),
        ChangeNotifierProvider(create: (c) => SiginApiCall()),
        ChangeNotifierProvider(create: (c) => HomeScreenData()),
        ChangeNotifierProvider(create: (c) => RegisterUser()),
        ChangeNotifierProvider(create: (c) => VerifyOTP()),
        ChangeNotifierProvider(create: (c) => Favourite()),
        ChangeNotifierProvider(create: (c) => MyAds()),
        ChangeNotifierProvider(create: (c) => UpdateProfile()),
        ChangeNotifierProvider(create: (c) => UpdateProfile()),
        ChangeNotifierProvider(create: (c) => VerifyNumber()),
        ChangeNotifierProvider(create: (c) => FilterValues()),
        ChangeNotifierProvider(create: (c) => GetCities()),
        ChangeNotifierProvider(create: (c) => AdReport()),
        ChangeNotifierProvider(create: (c) => GetUserProfile()),
        ChangeNotifierProvider(create: (c) => GetDealerAds()),
        ChangeNotifierProvider(create: (c) => MyNotificationData()),
        ChangeNotifierProvider(create: (c) => DeleteMyAdProvider()),
        ChangeNotifierProvider(create: (c) => MySavedSearchProvider()),
        ChangeNotifierProvider(create: (c) => GetDetailsbyVin()),
        ChangeNotifierProvider(create: (c) => LocalProvider()),
        ChangeNotifierProvider(create: (c) => TermsAndConditions()),
        ChangeNotifierProvider(create: (c) => HomeScreenData1()),
      ],
      child: ScreenUtilInit(
          designSize: const Size(414, 896),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, child) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Consumer<LocalProvider>(builder: (context, value, child) {
                return MaterialApp(
                  navigatorKey: navKey,
                  debugShowCheckedModeBanner: false,
                  locale: value.locale,
                  supportedLocales: L10n.all,
                  localizationsDelegates: const [
                    AppLocalizations.delegate, // Add this line
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  title: 'ListIt',
                  themeMode: ThemeMode.light,
                  theme: CustomTheme.lightTheme,
                  darkTheme: CustomTheme.darkTheme,
                  home: const BottomNavigationBarScreen(),
                );
              }),
            );
          }),
    );
  }
}
