import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/verifyOTP.dart';
import 'package:lisit_mobile_app/Screens/AuthScreens/loginScreen/changePassword.dart';
import 'package:lisit_mobile_app/Screens/AuthScreens/loginScreen/loginWithEmail.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

import '../../bottomNavigationBar/bottomNavigationBarScreen.dart';
import '../signupScreen/widget/signUpInputTextField.dart';
import 'resetPassword.dart';

class OTPVerification extends StatefulWidget {
  String email;
  bool isForgotPassword;
  bool isSignUp;
  OTPVerification({
    super.key,
    required this.email,
    required this.isForgotPassword,
    required this.isSignUp,
  });

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  TextEditingController firstNumber = TextEditingController();
  TextEditingController secondNumber = TextEditingController();
  TextEditingController thirdNumber = TextEditingController();
  TextEditingController fourthNumber = TextEditingController();
  TextEditingController fifthNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
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
                  H1Bold(text: Controller.getTag('opt_verification')),
                  H3Regular(
                    textAlign: TextAlign.center,
                    text: Controller.getTag(
                        'enter_the_code_you_have_received_on_your_phone_number'),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 32.h,
            ),

            // email input field

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 1 verification field
                Container(
                  alignment: Alignment.bottomCenter,
                  width: 40.18.w,
                  height: 40.18.h,
                  decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 2.w, color: ksecondaryColor2)),
                  ),
                  child: TextField(
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    controller: firstNumber,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      label: ParaRegular(text: ''),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // 2 verification field
                Container(
                  alignment: Alignment.bottomCenter,
                  width: 40.18.w,
                  height: 40.18.h,
                  decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 2.w, color: ksecondaryColor2)),
                  ),
                  child: TextField(
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        FocusScope.of(context).previousFocus();
                      } else if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    controller: secondNumber,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      label: ParaRegular(text: ''),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // 3 verification field
                Container(
                  alignment: Alignment.bottomCenter,
                  width: 40.18.w,
                  height: 40.18.h,
                  decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 2.w, color: ksecondaryColor2)),
                  ),
                  child: TextField(
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        FocusScope.of(context).previousFocus();
                      } else if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    controller: thirdNumber,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      label: ParaRegular(text: ''),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // 4 verification field
                Container(
                  alignment: Alignment.bottomCenter,
                  width: 40.18.w,
                  height: 40.18.h,
                  decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 2.w, color: ksecondaryColor2)),
                  ),
                  child: TextField(
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        FocusScope.of(context).previousFocus();
                      } else if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    controller: fourthNumber,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      label: ParaRegular(text: ''),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // 5 verification field
                Container(
                  alignment: Alignment.bottomCenter,
                  width: 40.18.w,
                  height: 40.18.h,
                  decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 2.w, color: ksecondaryColor2)),
                  ),
                  child: TextField(
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        FocusScope.of(context).previousFocus();
                      } else if (value.length == 1) {
                        FocusScope.of(context).unfocus();
                      }
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    controller: fifthNumber,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      label: ParaRegular(text: ''),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 40.h,
            ),
            // signup button
            context.select(
              (VerifyOTP value) => value.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : MainButton(
                      text: Controller.getTag('verify'),
                      onTap: () async {
                        var provider =
                            Provider.of<VerifyOTP>(context, listen: false);

                        var result = await provider.getVerifyOTP(context,
                            code:
                                '${firstNumber.text.trim()}${secondNumber.text.trim().toString()}${thirdNumber.text.trim().toString()}${fourthNumber.text.trim().toString()}${fifthNumber.text.trim().toString()}',
                            email: widget.email);
                        if (result is! String) {
                          if (result['success'] == true) {
                            DisplayMessage(
                                context: context,
                                isTrue: true,
                                message: Controller.languageChange(
                                    english: result['message'],
                                    arabic: result['message_ar']));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => widget.isForgotPassword
                                      ? ResetPassword(
                                          email: widget.email,
                                        )
                                      : LoginWithEmail(),
                                ));
                          } else if (result['success'] == false) {
                            DisplayMessage(
                                context: context,
                                isTrue: false,
                                message: result['message'] == null
                                    ? result['error']
                                    : Controller.languageChange(
                                        english: result['message'],
                                        arabic: result['message_ar']));
                          }
                        } else {
                          DisplayMessage(
                              context: context,
                              isTrue: false,
                              message: result.toString());
                        }
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ResetPassword(),
                        //   ),
                        // );
                      },
                    ),
            ),

            SizedBox(
              height: 20.h,
            ),

            // text

            H3Regular(
              textAlign: TextAlign.center,
              text: Controller.getTag(
                  "can't_find_code_if_you_can't_see_the_email,_check_your_spam_folder_or_resend_the_email.if_ you_are_still_have_trouble."),
            ),

            SizedBox(
              height: 30.h,
            ),
            context.select(
              (VerifyOTP resendValue) => resendValue.isresending
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        H3Regular(
                            text: Controller.getTag("don't_receive_code")),
                        GestureDetector(
                          onTap: () async {
                            var result = await Provider.of<VerifyOTP>(context,
                                    listen: false)
                                .getResendOTP(email: widget.email);
                            if (result is! String) {
                              if (result['success'] == true) {
                                DisplayMessage(
                                    context: context,
                                    isTrue: true,
                                    message: Controller.languageChange(
                                        english: result['message'],
                                        arabic: result['message_ar']));
                              } else if (result['success'] == false) {
                                DisplayMessage(
                                    context: context,
                                    isTrue: false,
                                    message: Controller.languageChange(
                                        english: result['message'],
                                        arabic: result['message_ar']));
                              }
                            } else {
                              DisplayMessage(
                                  context: context,
                                  isTrue: false,
                                  message: result.toString());
                            }
                          },
                          child: H3Regular(
                            text: ' ${Controller.getTag('resend_code')}',
                            color: kprimaryColor,
                          ),
                        )
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
