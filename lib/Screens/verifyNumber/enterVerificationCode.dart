import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/verifyNumber.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

import 'finalMessage.dart';

class EnterVerificationCode extends StatefulWidget {
  Function()? callback;
  String mobileNumber;

  EnterVerificationCode({
    this.callback,
    required this.mobileNumber,
    super.key,
  });

  @override
  State<EnterVerificationCode> createState() => _EnterVerificationCodeState();
}

class _EnterVerificationCodeState extends State<EnterVerificationCode> {
  TextEditingController firstNumber = TextEditingController();

  TextEditingController secondNumber = TextEditingController();

  TextEditingController thirdNumber = TextEditingController();

  TextEditingController fourthNumber = TextEditingController();

  TextEditingController fifthNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        height: 520.h,
        width: 386.w,
        decoration: BoxDecoration(
          color: kbackgrounColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 67.h,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.close)),
                ],
              ),
              H1Regular(text: Controller.getTag('verify_your_number')),
              SizedBox(
                height: 40.h,
              ),
              H3Regular(
                  textAlign: TextAlign.center,
                  text: Controller.getTag('activate_via_number_otp')),
              SizedBox(
                height: 20.h,
              ),
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

              // submit button
              SizedBox(
                width: 333.w,
                height: 47.h,
                child: context.select(
                  (VerifyNumber verifyCode) => verifyCode.isValidateCode
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : MainButton(
                          text: Controller.getTag('submit'),
                          onTap: () async {
                            String code =
                                "${firstNumber.text}${secondNumber.text}${thirdNumber.text}${fourthNumber.text}${fifthNumber.text}";

                            log(code);
                            if (code.length == 5) {
                              var result = await context
                                  .read<VerifyNumber>()
                                  .validateNumber(context,
                                      code: code, number: widget.mobileNumber);

                              if (result is! String) {
                                log('${result}');
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
                                        return FinalMessage(
                                          callBack: widget.callback,
                                        );
                                      });
                                } else {
                                  DisplayMessage(
                                      context: context,
                                      isTrue: false,
                                      message: result['error']);
                                }
                              } else {
                                DisplayMessage(
                                    context: context,
                                    isTrue: false,
                                    message: result);
                              }
                            } else {
                              DisplayMessage(
                                  context: context,
                                  isTrue: false,
                                  message: Controller.getTag(
                                      'please_enter_the_correct_passcode'));
                            }
                          },
                        ),
                ),
              ),

              SizedBox(
                height: 20.h,
              ),

              // resend code text
              context.select(
                (VerifyNumber verifyNum) => verifyNum.isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : GestureDetector(
                        onTap: () async {
                          var result = await context
                              .read<VerifyNumber>()
                              .sendCodeToNumber(context,
                                  number: widget.mobileNumber);

                          if (result is! String) {
                            if (result['success'] == true) {
                              DisplayMessage(
                                  context: context,
                                  isTrue: true,
                                  message: Controller.languageChange(
                                      english: result['message'],
                                      arabic: result['message_ar']));
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
                        },
                        child: H3Regular(
                          text: Controller.getTag('resend_code'),
                          color: kprimaryColor,
                        ),
                      ),
              ),

              SizedBox(
                height: 40.h,
              ),

              // text

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: Controller.getTag('signup_agree'),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily:
                        Controller.getLanguage().toString().toLowerCase() ==
                                "english"
                            ? GoogleFonts.montserrat().fontFamily
                            : GoogleFonts.notoKufiArabic().fontFamily,
                    fontWeight: FontWeight.w400,
                    color: ksecondaryColor,
                    overflow: TextOverflow.ellipsis,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // navigate to desired screen
                        },
                      text: ' ${Controller.getTag('terms_and_conditions')}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily:
                            Controller.getLanguage().toString().toLowerCase() ==
                                    "english"
                                ? GoogleFonts.montserrat().fontFamily
                                : GoogleFonts.notoKufiArabic().fontFamily,
                        fontWeight: FontWeight.w400,
                        color: kprimaryColor,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextSpan(
                      text: ' ${Controller.getTag('and')}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily:
                            Controller.getLanguage().toString().toLowerCase() ==
                                    "english"
                                ? GoogleFonts.montserrat().fontFamily
                                : GoogleFonts.notoKufiArabic().fontFamily,
                        fontWeight: FontWeight.w400,
                        color: ksecondaryColor,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // navigate to desired screen
                        },
                      text: ' ${Controller.getTag('privacy_policy')}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily:
                            Controller.getLanguage().toString().toLowerCase() ==
                                    "english"
                                ? GoogleFonts.montserrat().fontFamily
                                : GoogleFonts.notoKufiArabic().fontFamily,
                        fontWeight: FontWeight.w400,
                        color: kprimaryColor,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 67.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
