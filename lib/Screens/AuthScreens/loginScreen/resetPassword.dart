import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/verifyOTP.dart';
import 'package:lisit_mobile_app/Controller/Providers/validations/authValidation.dart';
import 'package:lisit_mobile_app/Screens/AuthScreens/loginScreen/widgets/passwordVerificationMessage.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';
import '../signupScreen/widget/signUpInputTextField.dart';
import 'susscessMessage.dart';

class ResetPassword extends StatefulWidget {
  String email;
  ResetPassword({super.key, required this.email});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AuthValidation>(context, listen: false).errorInEmail = false;
    Provider.of<AuthValidation>(context, listen: false).errorInPassword = false;
    Provider.of<AuthValidation>(context, listen: false).errorInName = false;
  }

  @override
  Widget build(BuildContext context) {
    var value = Provider.of<AuthValidation>(context, listen: true);
    validation() {
      value.validateEmail(passwordController.text.toString());
      value.validatePassword(confirmPasswordController.text.toString());
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
                  H1Bold(text: Controller.getTag('reset_password')),
                  H3Regular(
                    text: Controller.getTag(
                        'enter_new_password_to_access_the_account'),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 32.h,
            ),

            signUpInputTextField(
              onChange: (newValue) {
                value.isPasswordCompliant(newValue);
              },
              isPasswordError: value.errorInPassword,
              keyBoardType: TextInputType.visiblePassword,
              showEyeIcon: true,
              helperText: Controller.getTag('new_password'),
              controller: passwordController,
              icon: Icon(
                Icons.lock_outline_rounded,
                color: khelperTextColor,
              ),
              isPassword: true,
            ),
            if (passwordController.text.isNotEmpty)
              Column(
                children: [
                  Row(
                    children: [
                      ParaRegular(
                          text: '${Controller.getTag('password_strength')}: '),
                      ParaRegular(
                        text: !(value.hasDigits &&
                                value.hasMinLength &&
                                value.hasSpecialCharacters &&
                                value.hasUppercase)
                            ? Controller.getTag('weak')
                            : Controller.getTag('strong'),
                        color: !(value.hasDigits &&
                                value.hasMinLength &&
                                value.hasSpecialCharacters &&
                                value.hasUppercase)
                            ? kredColor
                            : kredText,
                      ),
                    ],
                  ),
                  PasswordVerificationMessage(
                    text: Controller.getTag('at_least_7_characters'),
                    isTrue: value.hasMinLength,
                  ),
                  PasswordVerificationMessage(
                    text: Controller.getTag('have_one_capital_letter'),
                    isTrue: value.hasUppercase,
                  ),
                  PasswordVerificationMessage(
                    text: Controller.getTag('have_at_least_one_number'),
                    isTrue: value.hasDigits,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 30.h),
                    child: PasswordVerificationMessage(
                      text: Controller.getTag(
                          'have_at_least_one_special_character'),
                      isTrue: value.hasSpecialCharacters,
                    ),
                  ),
                ],
              ),
            SizedBox(
              height: 20.h,
            ),

            //password input field

            signUpInputTextField(
              isPasswordError: value.errorInPassword,
              keyBoardType: TextInputType.visiblePassword,
              showEyeIcon: true,
              helperText: Controller.getTag('confirm_password'),
              controller: confirmPasswordController,
              icon: Icon(
                Icons.lock_outline_rounded,
                color: khelperTextColor,
              ),
              isPassword: true,
            ),
            SizedBox(
              height: 20.h,
            ),

            // signup button
            context.select(
              (VerifyOTP val) => val.isResetingPassword
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : MainButton(
                      text: '${Controller.getTag('confirm')}',
                      onTap: () async {
                        var value = context.read<AuthValidation>();
                        print((value.hasDigits &&
                            value.hasMinLength &&
                            value.hasLowercase &&
                            value.hasSpecialCharacters &&
                            value.hasUppercase));
                        print('d${value.hasDigits}');
                        print('l${value.hasMinLength}');
                        print('s${value.hasSpecialCharacters}');
                        print('U${value.hasUppercase}');
                        print('lo${value.hasLowercase}');

                        if ((value.hasDigits &&
                            value.hasMinLength &&
                            value.hasSpecialCharacters &&
                            value.hasUppercase)) {
                          value.errorInEmail = false;
                          value.errorInPassword = false;
                          var result = await context
                              .read<VerifyOTP>()
                              .getResetPassword(
                                  context,
                                  email: widget.email,
                                  password:
                                      passwordController.text.trim().toString(),
                                  confirmPassword: confirmPasswordController
                                      .text
                                      .trim()
                                      .toString());
                          if (result is! String) {
                            if (result['success'] == true) {
                              DisplayMessage(
                                  context: context,
                                  isTrue: true,
                                  message: Controller.languageChange(
                                      english: result['message'],
                                      arabic: result['message_ar']));
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return SuccessMessage();
                                  });

                              value.hasDigits = false;
                              value.hasLowercase = false;
                              value.hasMinLength = false;
                              value.hasSpecialCharacters = false;
                              value.hasUppercase = false;
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
                                message: result);
                          }
                        }

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const BottomNavigationBarScreen(),
                        //   ),
                        // );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
