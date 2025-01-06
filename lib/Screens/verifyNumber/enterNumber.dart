import 'dart:developer';

import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/verifyNumber.dart';
import 'package:lisit_mobile_app/Screens/verifyNumber/enterVerificationCode.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

import '../support/supportScreen.dart';

class EnterNumber extends StatefulWidget {
  Function()? callback;
  EnterNumber({
    this.callback,
    super.key,
  });

  @override
  State<EnterNumber> createState() => _EnterNumberState();
}

class _EnterNumberState extends State<EnterNumber> {
  String number = '';

  bool isNumberEmpty = false;

  List countryCode = ['+92', '+971', '+91'];
  String dropDownValue = '+92';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        child: Container(
          width: 386.w,
          height: 680.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: kbackgrounColor,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              children: [
                // close icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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

                // image

                SizedBox(
                  width: 186.w,
                  height: 182.h,
                  child: Image.asset(
                    'assets/safetyFirst.png',
                    fit: BoxFit.cover,
                  ),
                ),

                //text tile

                H1Regular(text: Controller.getTag('safety_first')),

                SizedBox(
                  height: 32.h,
                ),

                SizedBox(
                  width: 346.w,
                  child: H3Regular(
                      textAlign: TextAlign.center,
                      maxLine: 7,
                      text: Controller.getTag('safety_first_statement')),
                ),

                SizedBox(
                  height: 32.h,
                ),

                // number text field

                SizedBox(
                  width: 333.w,
                  height: 76.h,
                  child: Center(
                    child: IntlPhoneField(
                      pickerDialogStyle:
                          PickerDialogStyle(backgroundColor: kbackgrounColor),
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.top,
                      showCountryFlag: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      initialCountryCode: 'PK',
                      onChanged: (phone) {
                        print(phone.completeNumber);
                        number = phone.completeNumber;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 32.h,
                ),

                //send code button

                SizedBox(
                  width: 333.w,
                  height: 47.h,
                  child: context.select(
                    (VerifyNumber value) => value.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : MainButton(
                            text: Controller.getTag('send_verification_code'),
                            onTap: () async {
                              if (number.isEmpty) {
                                isNumberEmpty = true;
                                setState(() {});
                              } else {
                                isNumberEmpty = false;
                                setState(() {});
                                var result = await context
                                    .read<VerifyNumber>()
                                    .sendCodeToNumber(
                                      context,
                                      number: "$number",
                                    );

                                if (result is! String) {
                                  if (result['success'] == true) {
                                    DisplayMessage(
                                        context: context,
                                        isTrue: true,
                                        message: Controller.languageChange(
                                            english: result['message'],
                                            arabic: result['message_ar']));

                                    Navigator.pop(context);
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return EnterVerificationCode(
                                            callback: widget.callback,
                                            mobileNumber: "$number",
                                          );
                                        });
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
                                      message: result);
                                }
                              }
                            }),
                  ),
                ),

                SizedBox(
                  height: 32.h,
                ),

                //need help text

                SizedBox(
                  width: 328.w,
                  child: Column(
                    children: [
                      H3Regular(text: Controller.getTag('need_help_contact')),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SupportScreen(),
                            ),
                          );
                        },
                        child: H3Regular(
                          text: Controller.getTag('customer_support'),
                          color: kprimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                //column1 end
              ],
            ),
          ),
        ),
      ),
    );
  }
}
