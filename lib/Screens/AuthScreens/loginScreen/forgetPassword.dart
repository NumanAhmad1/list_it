import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/verifyOTP.dart';
import 'package:lisit_mobile_app/Controller/Providers/validations/authValidation.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

import '../../bottomNavigationBar/bottomNavigationBarScreen.dart';
import '../signupScreen/widget/signUpInputTextField.dart';
import 'otpVerification.dart';

class ForgetPassword extends StatefulWidget {
  ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var errorInEmail = Provider.of<AuthValidation>(context).errorInEmail;
    validation() {
      print('before "$errorInEmail');
      context
          .read<AuthValidation>()
          .validateEmail(emailController.text.toString());
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
                  H1Bold(text: Controller.getTag('forget_password')),
                  H3Regular(
                    text: Controller.getTag('enter_email_to_reset_password'),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 32.h,
            ),

            // email input field

            signUpInputTextField(
              isEmailError: Provider.of<AuthValidation>(context).errorInEmail,
              keyBoardType: TextInputType.emailAddress,
              helperText: Controller.getTag('email_address'),
              controller: emailController,
              icon: Icon(
                Icons.email_outlined,
                color: khelperTextColor,
              ),
              isPassword: false,
            ),

            SizedBox(
              height: 20.h,
            ),

            //text
            H3Regular(
              text: Controller.getTag('this_email_address_will_be_used_to_create_a_new_password'),
              textAlign: TextAlign.center,
            ),

            SizedBox(
              height: 40.h,
            ),
            // signup button
            context.select(
              (VerifyOTP val) => val.isresending
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : MainButton(
                      text: Controller.getTag('reset_password'),
                      onTap: () async {
                        validation();

                        if (!Provider.of<AuthValidation>(context, listen: false)
                            .errorInEmail) {
                          Provider.of<AuthValidation>(context, listen: false)
                              .errorInEmail = false;
                          Provider.of<AuthValidation>(context, listen: false)
                              .errorInPassword = false;
                          print('after calling:$errorInEmail');
                          var result = await context
                              .read<VerifyOTP>()
                              .getResendOTP(
                                  email:
                                      emailController.text.trim().toString());
                          if (result is! String) {
                            if (result['success'] == true) {
                              DisplayMessage(
                                  context: context,
                                  isTrue: true,
                                  message: Controller.languageChange(
                                      english: result['message'],
                                      arabic: result['message_ar']
                                  )
                              );
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OTPVerification(
                                            isForgotPassword: true,
                                            isSignUp: false,
                                            email: emailController.text
                                                .trim()
                                                .toString(),
                                          )));
                            } else {
                              DisplayMessage(
                                  context: context,
                                  isTrue: false,
                                  message: Controller.languageChange(
                                      english: result['message'],
                                      arabic: result['message_ar']
                                  )
                              );
                            }
                          } else {
                            DisplayMessage(
                                context: context,
                                isTrue: false,
                                message: result.toString());
                          }
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
