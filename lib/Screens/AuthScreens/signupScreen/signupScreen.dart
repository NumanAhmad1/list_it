import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/registerUser.dart';
import 'package:lisit_mobile_app/Controller/Providers/validations/authValidation.dart';
import 'package:lisit_mobile_app/Screens/AuthScreens/loginScreen/loginScreen.dart';
import 'package:lisit_mobile_app/Screens/AuthScreens/loginScreen/otpVerification.dart';
import 'package:lisit_mobile_app/Screens/AuthScreens/loginScreen/widgets/passwordVerificationMessage.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';
import 'package:lisit_mobile_app/widgets/mainButton.dart';

import '../../bottomNavigationBar/bottomNavigationBarScreen.dart';
import 'widget/signUpInputTextField.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController fullNameController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    var value = Provider.of<AuthValidation>(context, listen: true);
    validation() {
      value.validateEmail(emailController.text.toString());
      value.validatePassword(passwordController.text.toString());
      value.validateName(fullNameController.text.toString());
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 23.w),
          child: Column(
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
                    H1Bold(text: Controller.getTag('sign_up')),
                    H3Regular(
                      text: Controller.getTag('find_your_dream_car!'),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 32.h,
              ),
              //Name input field

              signUpInputTextField(
                isNameError: value.errorInName,
                keyBoardType: TextInputType.name,
                helperText: Controller.getTag('full_name'),
                icon: Icon(
                  Icons.person_2_outlined,
                  color: khelperTextColor,
                ),
                controller: fullNameController,
                isPassword: false,
              ),

              // email input field

              signUpInputTextField(
                isEmailError: value.errorInEmail,
                keyBoardType: TextInputType.emailAddress,
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
                onChange: (newValue) {
                  print(value);
                  value.isPasswordCompliant(newValue);
                },
                isPasswordError: value.errorInPassword,
                keyBoardType: TextInputType.visiblePassword,
                showEyeIcon: true,
                helperText: Controller.getTag('password'),
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
                            text:
                                '${Controller.getTag('password_strength')}: '),
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
              // signup button
              context.select(
                (RegisterUser val) => val.isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : MainButton(
                        text: Controller.getTag('sign_up'),
                        onTap: () async {
                          validation();
                          var provider =
                              Provider.of<RegisterUser>(context, listen: false);

                          var result = await provider.registerUser(
                            context,
                            email: emailController.text.trim().toString(),
                            password: passwordController.text.trim().toString(),
                            name: fullNameController.text.trim().toString(),
                          );

                          if ((value.hasDigits &&
                              value.hasMinLength &&
                              value.hasSpecialCharacters &&
                              value.hasUppercase)) {
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
                                    builder: (context) => OTPVerification(
                                      isForgotPassword: false,
                                      isSignUp: true,
                                      email: emailController.text
                                          .trim()
                                          .toString(),
                                    ),
                                  ),
                                );
                                value.hasDigits = false;
                                value.hasLowercase = false;
                                value.hasMinLength = false;
                                value.hasSpecialCharacters = false;
                                value.hasUppercase = false;
                              } else {
                                DisplayMessage(
                                    context: context,
                                    isTrue: false,
                                    message: Controller.languageChange(english: result['message'].toString(), arabic: result['message_ar'].toString()));
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

              Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    H3semi(
                        text:
                            '${Controller.getTag('already_have_account_sign_in').split(Controller.languageChange(english: "?", arabic: "؟"))[0]}'
                            '${Controller.languageChange(english: "?", arabic: "؟")} '),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: H3semi(
                        text: Controller.getTag('already_have_account_sign_in')
                            .split(Controller.languageChange(
                                english: "?", arabic: "؟"))[1],
                        color: kprimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
