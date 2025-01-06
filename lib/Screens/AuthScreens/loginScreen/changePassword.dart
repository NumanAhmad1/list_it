import 'dart:developer';

import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/siginApiCall.dart';
import 'package:lisit_mobile_app/Controller/Providers/validations/authValidation.dart';
import 'package:lisit_mobile_app/Screens/AuthScreens/signupScreen/widget/signUpInputTextField.dart';
import 'package:lisit_mobile_app/Screens/bottomNavigationBar/bottomNavigationBarScreen.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';
import 'package:lisit_mobile_app/main.dart';

import 'widgets/passwordVerificationMessage.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({
    super.key,
  });

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final providerValue = Provider.of<AuthValidation>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // AppBar
          Container(
            width: 1.sw,
            height: 90.h,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: ksearchFieldColor),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // back icon
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back_ios_new_rounded)),

                  //Notification title

                  H2Bold(text: Controller.getTag('change_password')),

                  // trash icon button

                  const SizedBox.shrink(),
                ],
              ),
            ),
          ),

          // body

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    signUpInputTextField(
                      isPasswordError: providerValue.errorInPassword,
                      keyBoardType: TextInputType.visiblePassword,
                      helperText: Controller.getTag('old_password'),
                      controller: oldPasswordController,
                      icon: const Text(''),
                      isPassword: true,
                      showEyeIcon: true,
                    ),
                    signUpInputTextField(
                      onChange: (value) {
                        print(value);
                        providerValue.isPasswordCompliant(value);
                      },
                      keyBoardType: TextInputType.visiblePassword,
                      helperText: Controller.getTag('new_password'),
                      controller: newPasswordController,
                      icon: const Text(''),
                      isPassword: true,
                      showEyeIcon: true,
                    ),
                    if (newPasswordController.text.isNotEmpty)
                      Column(
                        children: [
                          Row(
                            children: [
                              ParaRegular(
                                  text:
                                      '${Controller.getTag('password_strength')}: '),
                              ParaRegular(
                                text: !providerValue.errorInNewPassword
                                    ? Controller.getTag('weak')
                                    : Controller.getTag('strong'),
                                color: !providerValue.errorInNewPassword
                                    ? kredColor
                                    : kredText,
                              ),
                            ],
                          ),
                          PasswordVerificationMessage(
                            text: Controller.getTag('at_least_7_characters'),
                            isTrue: providerValue.hasMinLength,
                          ),
                          PasswordVerificationMessage(
                            text: Controller.getTag('have_one_capital_letter'),
                            isTrue: providerValue.hasUppercase,
                          ),
                          PasswordVerificationMessage(
                            text: Controller.getTag('have_at_least_one_number'),
                            isTrue: providerValue.hasDigits,
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 30.h),
                            child: PasswordVerificationMessage(
                              text: Controller.getTag(
                                  'have_at_least_one_special_character'),
                              isTrue: providerValue.hasSpecialCharacters,
                            ),
                          ),
                        ],
                      ),
                    signUpInputTextField(
                      keyBoardType: TextInputType.visiblePassword,
                      helperText: Controller.getTag('confirm_password'),
                      controller: confirmPasswordController,
                      icon: const Text(''),
                      isPassword: true,
                      showEyeIcon: true,
                    ),
                    if (providerValue.errorInConfirmPassword)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ParaRegular(
                            text: Controller.getTag('password_mismatch'),
                            color: kredColor,
                          ),
                        ],
                      ),

                    SizedBox(
                      height: 30.h,
                    ),

                    SizedBox(
                      height: 47.h,
                      child: Provider.of<SiginApiCall>(context)
                              .isChangePasswordLoading
                          ? const CircularProgressIndicator()
                          : MainButton(
                              text: Controller.getTag('submit'),
                              onTap: () async {
                                if (providerValue.hasSpecialCharacters &&
                                    providerValue.hasDigits &&
                                    providerValue.hasUppercase &&
                                    providerValue.hasMinLength) {
                                  log('true');
                                  if (newPasswordController.text
                                          .trim()
                                          .toString() ==
                                      confirmPasswordController.text
                                          .trim()
                                          .toString()) {
                                    var result = await context
                                        .read<SiginApiCall>()
                                        .changePassword(context,
                                            oldPassword: oldPasswordController
                                                .text
                                                .trim(),
                                            newPassword: newPasswordController
                                                .text
                                                .trim(),
                                            confirmPassword:
                                                confirmPasswordController.text
                                                    .trim());
                                    if (result is! String) {
                                      if (result['success'] == true) {
                                        DisplayMessage(
                                            context: context,
                                            isTrue: true,
                                            message: Controller.languageChange(
                                                english: result['message'],
                                                arabic: result['message_ar']));
                                        if (!context.mounted) return;

                                        Controller.logoutUser(context);
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BottomNavigationBarScreen()),
                                            (route) => false);
                                      } else {
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
                                  } else {
                                    DisplayMessage(
                                        context: context,
                                        isTrue: false,
                                        message: 'Passwords not match');
                                  }
                                }
                              },
                            ),
                    ),

                    // body column  end
                  ],
                ),
              ),
            ),
          ),

          //column1 end
        ],
      ),
    );
  }
}
