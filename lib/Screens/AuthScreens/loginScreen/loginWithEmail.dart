import 'dart:developer';

import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/favourite.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/siginApiCall.dart';
import 'package:lisit_mobile_app/Controller/Providers/validations/authValidation.dart';
import 'package:lisit_mobile_app/Screens/AuthScreens/signupScreen/signupScreen.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

import '../../bottomNavigationBar/bottomNavigationBarScreen.dart';
import '../signupScreen/widget/signUpInputTextField.dart';
import 'forgetPassword.dart';

class LoginWithEmail extends StatefulWidget {
  dynamic data;
  LoginWithEmail({super.key, this.data});

  @override
  State<LoginWithEmail> createState() => _LoginWithEmailState();
}

class _LoginWithEmailState extends State<LoginWithEmail> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AuthValidation>(context, listen: false).errorInEmail = false;
    Provider.of<AuthValidation>(context, listen: false).errorInPassword = false;
    Provider.of<AuthValidation>(context, listen: false).errorInName = false;
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   emailController.dispose();
  //   passwordController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var value = Provider.of<AuthValidation>(context, listen: true);
    validation() {
      value.validateEmail(emailController.text.toString());
      value.validatePassword(passwordController.text.toString());
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 23.w),
        child: ListView(
          children: [
            SizedBox(
              height: 30.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // close icon

                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                  ),
                ),

                // logo image
                SizedBox(
                  width: 85.91.w,
                  height: 32.28.h,
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 132.h,
                ),
              ],
            ),

            SizedBox(
              height: 28.h,
            ),

            // signup text

            SizedBox(
              child: Column(
                children: [
                  H1Bold(text: Controller.getTag('login')),
                  // H3Regular(
                  //   text: 'Find your dream car!',
                  // ),
                ],
              ),
            ),

            SizedBox(
              height: 32.h,
            ),

            // email input field

            signUpInputTextField(
              keyBoardType: TextInputType.emailAddress,
              isEmailError: value.errorInEmail,
              helperText: Controller.getTag('email_address'),
              controller: emailController,
              icon: Icon(
                Icons.email_outlined,
                color: khelperTextColor,
              ),
              isPassword: false,
            ),

            //password input field

            signUpInputTextField(
              keyBoardType: TextInputType.visiblePassword,
              isPasswordError: value.errorInPassword,
              showEyeIcon: true,
              helperText: Controller.getTag('password'),
              controller: passwordController,
              icon: Icon(
                Icons.lock_outline_rounded,
                color: khelperTextColor,
              ),
              isPassword: true,
            ),
            SizedBox(
              height: 20.h,
            ),

            //forgot password

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: () {
                      value.errorInEmail = false;
                      value.errorInPassword = false;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgetPassword(),
                        ),
                      );
                    },
                    child: H3Regular(
                      text: Controller.getTag('forget_password'),
                      color: kprimaryColor,
                    )),
              ],
            ),
            SizedBox(
              height: 40.h,
            ),

            // login button
            context.select(
              (SiginApiCall val) => val.isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : MainButton(
                      text: Controller.getTag('login'),
                      onTap: () async {
                        validation();

                        if (!value.errorInEmail && !value.errorInPassword) {
                          value.errorInEmail = false;
                          value.errorInPassword = false;

                          bool isLogin = await context
                              .read<SiginApiCall>()
                              .signInWithEmail(context,
                                  email: emailController.text,
                                  password: passwordController.text);

                          log(isLogin.toString());

                          if (isLogin) {
                            if (Controller.getisUserActive() != true) {
                              DisplayMessage(
                                  context: context,
                                  isTrue: false,
                                  message: Controller.languageChange(
                                      english: Provider.of<SiginApiCall>(
                                              context,
                                              listen: false)
                                          .emailResponse['message'],
                                      arabic: Provider.of<SiginApiCall>(context,
                                              listen: false)
                                          .emailResponse['message_ar']));
                            } else {
                              if (widget.data != null) {
                                if (widget.data[0] == 'detailScreen') {
                                  if (widget.data[1] == 'favourite') {
                                    if (!context.mounted) return;
                                    await context
                                        .read<Favourite>()
                                        .addToFavourite(
                                          context,
                                          addId: widget.data[2],
                                        );
                                    if (!context.mounted) return;
                                    Navigator.pop(context);
                                  } else {
                                    if (!context.mounted) return;
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }
                                }
                                if (widget.data[0] == 'favouriteScreen') {
                                  if (!context.mounted) return;

                                  widget.data[1]();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                                if (widget.data[0] == 'chatScreen') {
                                  if (!context.mounted) return;
                                  widget.data[1]();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                                if (widget.data[0] == 'searchedItemScreen') {
                                  if (widget.data[1] == 'favourite') {
                                    if (!context.mounted) return;
                                    await context
                                        .read<Favourite>()
                                        .addToFavourite(
                                          context,
                                          addId: widget.data[2],
                                        );
                                    if (!context.mounted) return;
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  } else {
                                    if (!context.mounted) return;
                                    Navigator.pop(context);
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
                            DisplayMessage(
                                context: context,
                                isTrue: false,
                                message: Controller.languageChange(
                                    english: Provider.of<SiginApiCall>(context,
                                            listen: false)
                                        .emailResponse['message'],
                                    arabic: Provider.of<SiginApiCall>(context,
                                            listen: false)
                                        .emailResponse['message_ar']));
                          }
                        } else {
                          DisplayMessage(
                              context: context,
                              isTrue: false,
                              message: Controller.languageChange(
                                  english: Provider.of<SiginApiCall>(context,
                                          listen: false)
                                      .emailResponse['message'],
                                  arabic: Provider.of<SiginApiCall>(context,
                                          listen: false)
                                      .emailResponse['message_ar']));
                        }
                      },
                    ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 40.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  H2Bold(
                      text: '${Controller.getTag("don't_have_an_account")} '),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: H2Bold(
                      text: '${Controller.getTag('create_account')} ',
                      color: kprimaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
