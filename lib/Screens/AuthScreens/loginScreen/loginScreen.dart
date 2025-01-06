import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/favourite.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/siginApiCall.dart';
import 'package:lisit_mobile_app/Screens/AuthScreens/signupScreen/signupScreen.dart';
import 'package:lisit_mobile_app/Screens/bottomNavigationBar/bottomNavigationBarScreen.dart';
import 'package:lisit_mobile_app/Screens/termsAndConditions/privacyPolicy.dart';
import 'package:lisit_mobile_app/Screens/termsAndConditions/termandcondition.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';
import 'package:lisit_mobile_app/services/googleSignin.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'loginWithEmail.dart';
import 'widgets/loginMainButton.dart';

class LoginScreen extends StatelessWidget {
  dynamic data;
  LoginScreen({super.key, this.data});

  Future<GoogleSignInAccount?> signIn() async {
    final user = await GoogleSignInApi.login();

    print('$user');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 30.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox.shrink(),

                // logo image
                SizedBox(
                  width: 85.91.w,
                  height: 32.28.h,
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),

                // close icon

                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                  ),
                ),
              ],
            ),

            // main login screen image
            SizedBox(
              width: 307.92.w,
              height: 243.99.h,
              child: Image.asset(
                'assets/loginScreen.png',
                fit: BoxFit.cover,
              ),
            ),

            // login text
            H1Bold(text: Controller.getTag('login')),

            // facebook button

            // if(false)
            // LoginMainButton(
            //   image: 'assets/faceBookLogo.png',
            //   title: Controller.getTag('continue_with_facebook'),
            //   onTap: () async {
            //     bool isSignIn =
            //         await context.read<SiginApiCall>().signInWithFacebook();
            //     if (isSignIn == true) {
            //       if (Controller.getisUserActive() != true) {
            //         DisplayMessage(
            //             context: context,
            //             isTrue: false,
            //             message: Controller.getTag('user_is_deactivated'));
            //       } else {
            //         if (data != null) {
            //           if (data[0] == 'detailScreen') {
            //             if (data[1] == 'favourite') {
            //               if (!context.mounted) return;
            //               await context.read<Favourite>().addToFavourite(
            //                     addId: data[2],
            //                   );
            //               if (!context.mounted) return;
            //               Navigator.pop(context);
            //             } else {
            //               if (!context.mounted) return;
            //               Navigator.pop(context);
            //             }
            //             if (data[0] == 'favouriteScreen') {
            //               if (!context.mounted) return;
            //               Navigator.pop(context);
            //               data[1]();
            //             }
            //             if (data[0] == 'chatScreen') {
            //               if (!context.mounted) return;
            //               Navigator.pop(context);
            //               data[1]();
            //             }
            //             if (data[0] == 'searchedItemScreen') {
            //               if (data[1] == 'favourite') {
            //                 if (!context.mounted) return;
            //                 await context.read<Favourite>().addToFavourite(
            //                       addId: data[2],
            //                     );
            //                 if (!context.mounted) return;
            //                 Navigator.pop(context);
            //               } else {
            //                 if (!context.mounted) return;
            //                 Navigator.pop(context);
            //               }
            //             }
            //           } else {
            //             if (!context.mounted) return;
            //             Navigator.pushAndRemoveUntil(
            //                 context,
            //                 MaterialPageRoute(
            //                     builder: (context) =>
            //                         BottomNavigationBarScreen()),
            //                 (route) => false);
            //           }
            //         }
            //       } else {
            //         if (!context.mounted) return;
            //         DisplayMessage(
            //             context: context,
            //             isTrue: false,
            //             message: '${Controller.getTag('continue_with_facebook')} ${Controller.getTag('failed')}');
            //       }
            //     },
            //   ),

            // google button

            LoginMainButton(
              image: 'assets/googleLogo.png',
              title: Controller.getTag('continue_with_google'),
              onTap: () async {
                bool isSignIn = await context
                    .read<SiginApiCall>()
                    .signInWithGoogle(context);
                if (isSignIn == true) {
                  if (Controller.getisUserActive() != true) {
                    DisplayMessage(
                        context: context,
                        isTrue: false,
                        message: Controller.getTag('user_is_deactivated'));
                  } else {
                    if (data != null) {
                      if (data[0] == 'detailScreen') {
                        if (data[1] == 'favourite') {
                          if (!context.mounted) return;
                          await context.read<Favourite>().addToFavourite(
                                context,
                                addId: data[2],
                              );
                          if (!context.mounted) return;
                          Navigator.pop(context);
                        } else {
                          if (!context.mounted) return;
                          Navigator.pop(context);
                        }
                      }
                      if (data[0] == 'favouriteScreen') {
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        data[1]();
                      }
                      if (data[0] == 'chatScreen') {
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        data[1]();
                      }
                      if (data[0] == 'searchedItemScreen') {
                        if (data[1] == 'favourite') {
                          if (!context.mounted) return;
                          await context.read<Favourite>().addToFavourite(
                                context,
                                addId: data[2],
                              );
                          if (!context.mounted) return;
                          Navigator.pop(context);
                        } else {
                          if (!context.mounted) return;
                          Navigator.pop(context);
                        }
                      }
                    } else {
                      if (!context.mounted) return;
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BottomNavigationBarScreen()),
                          (route) => false);
                    }
                  }
                } else {
                  if (!context.mounted) return;
                  DisplayMessage(
                      context: context,
                      isTrue: false,
                      message:
                          '${Controller.getTag('continue_with_google')} ${Controller.getTag('failed')}');
                }
              },
            ),

            // iphone login

            if (Platform.isIOS)
              LoginMainButton(
                image: 'assets/appleLogo.png',
                title: Controller.getTag('continue_with_apple'),
                onTap: () async {
                  bool isSignIn = await context
                      .read<SiginApiCall>()
                      .signInWithApple(context);
                  if (isSignIn == true) {
                    if (Controller.getisUserActive() != true) {
                      DisplayMessage(
                          context: context,
                          isTrue: false,
                          message: Controller.getTag('user_is_deactivated'));
                    } else {
                      if (data != null) {
                        if (data[0] == 'detailScreen') {
                          if (data[1] == 'favourite') {
                            if (!context.mounted) return;
                            await context.read<Favourite>().addToFavourite(
                                  context,
                                  addId: data[2],
                                );
                            if (!context.mounted) return;
                            Navigator.pop(context);
                          } else {
                            if (!context.mounted) return;
                            Navigator.pop(context);
                          }
                        }
                        if (data[0] == 'favouriteScreen') {
                          if (!context.mounted) return;
                          Navigator.pop(context);
                          data[1]();
                        }
                        if (data[0] == 'chatScreen') {
                          if (!context.mounted) return;
                          Navigator.pop(context);
                          data[1]();
                        }
                        if (data[0] == 'searchedItemScreen') {
                          if (data[1] == 'favourite') {
                            if (!context.mounted) return;
                            await context.read<Favourite>().addToFavourite(
                                  context,
                                  addId: data[2],
                                );
                            if (!context.mounted) return;
                            Navigator.pop(context);
                          } else {
                            if (!context.mounted) return;
                            Navigator.pop(context);
                          }
                        }
                      } else {
                        if (!context.mounted) return;
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BottomNavigationBarScreen()),
                            (route) => false);
                      }
                    }
                  } else {
                    if (!context.mounted) return;
                    DisplayMessage(
                        context: context,
                        isTrue: false,
                        message:
                            '${Controller.getTag('continue_with_apple')} ${Controller.getTag('failed')}');
                  }
                },
              ),

            // email login

            LoginMainButton(
              image: 'assets/emailLogo.png',
              title: Controller.getTag('continue_with_email'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginWithEmail(
                      data: data,
                    ),
                  ),
                );
              },
            ),

            // don't account text

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                H2semi(text: Controller.getTag('dont_have_account')),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpScreen()));
                  },
                  child: H2semi(
                    text: " ${Controller.getTag('create_account')}",
                    color: kprimaryColor,
                  ),
                ),
              ],
            ),

            Wrap(
              alignment: WrapAlignment.center,
              children: [
                H2Regular(
                    text:
                        '${Controller.getTag('by_logging_in_I_agree_to_the')} '),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Termandcondition()));
                  },
                  child: H2Bold(
                    text: Controller.getTag('terms_and_conditions'),
                    color: kprimaryColor,
                  ),
                ),
                H2Regular(text: ' ${Controller.getTag('and')}'),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PrivacyPolicy()));
                  },
                  child: H2Bold(
                    text: ' ${Controller.getTag('privacy_policy')}',
                    color: kprimaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
