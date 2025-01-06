import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/favourite.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/siginApiCall.dart';
import 'package:lisit_mobile_app/Screens/AuthScreens/loginScreen/loginScreen.dart';
import 'package:lisit_mobile_app/Screens/AuthScreens/signupScreen/signupScreen.dart';
import 'package:lisit_mobile_app/Screens/menu/widget/myAccoutTile.dart';
import 'package:lisit_mobile_app/Screens/selectCity/selectCityCard.dart';
import 'package:lisit_mobile_app/Screens/selectLanguage/selectLanguage.dart';
import 'package:lisit_mobile_app/Screens/support/supportScreen.dart';
import 'package:lisit_mobile_app/Screens/termsAndConditions/privacyPolicy.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';
import 'package:lisit_mobile_app/main.dart';
import 'package:lisit_mobile_app/services/localProvider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../myAdsScreen/myAdsScreen.dart';
import '../profile/profileScreen.dart';
import '../search/savedSearch/savedSearch.dart';
import '../termsAndConditions/termandcondition.dart';
import '../verifyNumber/enterNumber.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    Controller.getLogin();
    Controller.getUserGmail();
    Controller.getUserName();
    Controller.getUserPhotoUrl();
    Controller.getUserToken();
    Controller.getisUserVerified();
    // TODO: implement initState
    super.initState();
  }

  rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    log('menue build is called');
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50.h,
            ),
            Controller.isLoggedIn
                ?
                //profile section
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Container(
                      width: 1.sw,
                      height: 163.h,
                      decoration: BoxDecoration(
                        color: kprimaryColor2,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                            callback: rebuild,
                                          )));
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //profile avatar
                                  Padding(
                                    padding: EdgeInsets.only(top: 15.h),
                                    child: SizedBox(
                                      height: 50.h,
                                      child: Row(
                                        children: [
                                          Container(
                                            clipBehavior: Clip.hardEdge,
                                            height: 68.h,
                                            width: 68.w,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: Controller
                                                      .getUserPhotoUrl() ??
                                                  'N/A',
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Image.asset(
                                                      'assets/personImage.png'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // user name

                                  Padding(
                                    padding: EdgeInsets.only(top: 15.h),
                                    child: SizedBox(
                                      height: 90.h,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 255.w,
                                              child: H1Regular(
                                                text:
                                                    '${Controller.getTag('greetings')} ${Controller.getUserName()}',
                                              ),
                                            ),
                                            SizedBox(
                                              width: 250.w,
                                              child: H3Regular(
                                                  text: Controller
                                                          .getUserGmail() ??
                                                      'N/A'),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (!Controller.getisUserVerified())
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return EnterNumber();
                                    });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 29.94.h,
                                width: 321.w,
                                decoration: BoxDecoration(
                                  color: kbackgrounColor,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    H3semi(
                                      text: Controller.getTag('verify_your_number'),
                                      color: ksecondaryColor2,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    SvgPicture.asset(
                                        'assets/unVerifiedTeck.svg'),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              clipBehavior: Clip.hardEdge,
                              height: 77.h,
                              width: 77.w,
                              decoration: BoxDecoration(
                                color: kprimaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'assets/personImage.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 13.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  H1Regular(text: Controller.getTag('hi_there')),
                                  ParaRegular(
                                      text: Controller.getTag('sign_in_for_options')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 15.h),
                        child: SizedBox(
                          height: 32.h,
                          child: MainButton(
                            text: Controller.getTag('login'),
                            onTap: () {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()))
                                  .whenComplete(() => setState(() {}));
                            },
                            isFilled: false,
                            textColor: kprimaryColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 30.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ParaBold(text: Controller.getTag('dont_have_account')),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpScreen()));
                              },
                              child: ParaBold(
                                text: Controller.getTag('create_account'),
                                color: kprimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 0.5,
                      ),
                    ],
                  ),

            // // my account
            if (Controller.isLoggedIn)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                child: H2semi(
                  text: Controller.getTag('my_account'),
                  color: ksecondaryColor2,
                ),
              ),

            // //profile screen

            if (Controller.isLoggedIn)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MyAccountTile(
                      title: Controller.getTag('profile'),
                      icon: Image.asset('assets/profileIcon.png'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              callback: rebuild,
                            ),
                          ),
                        );
                      },
                    ),
                    MyAccountTile(
                      title: Controller.getTag('my_ads'),
                      icon: Image.asset('assets/table.png'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyAdsScreen(),
                          ),
                        );
                      },
                    ),
                    MyAccountTile(
                      title: Controller.getTag('my_saved_searches'),
                      icon: Image.asset('assets/searchCheck.png'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SavedSearch(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            const Divider(
              thickness: 0.5,
            ),
            //settings
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  H2Regular(
                    text: Controller.getTag('settings'),
                    color: ksecondaryColor2,
                  ),
                  MyAccountTile(
                    title: Controller.getTag('city'),
                    icon: Image.asset('assets/navigation.png'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SelectCityCard();
                        },
                      );
                    },
                  ),
                  MyAccountTile(
                    title: Controller.getTag('language'),
                    icon: Image.asset('assets/globe.png'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SelectLanguageCard();
                        },
                      ).whenComplete(() => rebuild());
                    },
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 0.5,
            ),
            // others
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  H2Regular(
                    text: Controller.getTag('others'),
                    color: ksecondaryColor2,
                  ),
                  MyAccountTile(
                    title: Controller.getTag('support'),
                    icon: Image.asset('assets/messagesSquare.png'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SupportScreen(),
                        ),
                      );
                    },
                  ),
                  MyAccountTile(
                    title: Controller.getTag('get_in_touch'),
                    icon: Image.asset('assets/mail.png'),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: const BeveledRectangleBorder(),
                              contentPadding: EdgeInsets.zero,
                              insetPadding:
                                  EdgeInsets.symmetric(horizontal: 20.w),
                              content: Container(
                                height: 311.h,
                                width: 1.sw,
                                color: kbackgrounColor,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Container(
                                    //   color: Colors.blue,
                                    //   child: Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.end,
                                    //     children: [
                                    // GestureDetector(
                                    //     onTap: () {
                                    //       Navigator.pop(context);
                                    //     },
                                    //     child: const Icon(Icons.close)),
                                    //     ],
                                    //   ),
                                    // ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 40.w,
                                        ),
                                        Container(
                                          clipBehavior: Clip.hardEdge,
                                          height: 50.h,
                                          width: 50.w,
                                          decoration: const BoxDecoration(),
                                          child: Image.asset(
                                            'assets/mailIcon.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w),
                                              child: const Icon(Icons.close),
                                            )),
                                      ],
                                    ),
                                    H2semi(text: Controller.getTag('get_in_touch')),
                                    H3Regular(
                                        text: Controller.getTag('duration')),
                                    SizedBox(
                                      width: 319.w,
                                      child: MainButton(
                                        text: '${dotenv.env['helpMail']}',
                                        onTap: () async {
                                          if (!await launchUrl(
                                            Uri.parse("mailto:${dotenv.env['helpMail']}?subject=Need help"),
                                            mode:
                                                LaunchMode.externalApplication,
                                          )) {
                                            throw Exception(
                                                'Could not launch request.url');
                                          }
                                          if (!context.mounted) return;
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),

                                    /// Or Email Us at

                                    // Controller.getLanguage().toString().toLowerCase() == "english"
                                    //     ? Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.center,
                                    //   children: [
                                    //     H3Regular(text: Controller.getTag('email_us_at')),
                                    //     H3Regular(
                                    //       text: ' customersupport@listit.com',
                                    //       color: kprimaryColor,
                                    //     ),
                                    //     SizedBox(
                                    //       height: 10.h,
                                    //     ),
                                    //   ],
                                    // )
                                    //     : Column(
                                    //   mainAxisAlignment:
                                    //   MainAxisAlignment.center,
                                    //   children: [
                                    //     H3Regular(text: Controller.getTag('email_us_at')),
                                    //     H3Regular(
                                    //       text: ' customersupport@listit.com',
                                    //       color: kprimaryColor,
                                    //     ),
                                    //     SizedBox(
                                    //       height: 10.h,
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  ),
                  MyAccountTile(
                    title: Controller.getTag('terms_and_conditions'),
                    icon: Image.asset('assets/listChecks.png'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Termandcondition()));
                    },
                  ),
                  MyAccountTile(
                    title: Controller.getTag('privacy_policy'),
                    icon: Image.asset('assets/privacyPolicyIconMenu.png'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrivacyPolicy()));
                    },
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 0.5,
            ),

            // logout button

            if (Controller.isLoggedIn)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: MyAccountTile(
                  title: Controller.getTag('logout'),
                  icon: Image.asset('assets/logOut.png'),
                  onTap: () async {
                    await CallApi.postApi(
                        context,
                        isInsideData: false,
                        parametersList: {},
                        isAdmin: false,
                        token: Controller.getUserToken(),
                        endPoint: "/user/logout");
                    await prefs?.clear();
                    if (!context.mounted) return;
                    context.read<Favourite>().favouriteIdList.clear();
                    context.read<Favourite>().favouriteDataList.clear();
                    context.read<Favourite>().favouriteList.clear();
                    // Controller.saveLogin(isLogin: false);
                    print('prefs is cleared');

                    print(Controller.getLogin());

                    print(Controller.isLoggedIn);
                    context.read<LocalProvider>().setLocal();
                    setState(() {});
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
