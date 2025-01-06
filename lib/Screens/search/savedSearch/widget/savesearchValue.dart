import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/getCategoryListing.dart';
import 'package:lisit_mobile_app/const/constColors.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class SaveSearchValue extends StatefulWidget {
  const SaveSearchValue({super.key});

  @override
  State<SaveSearchValue> createState() => _SaveSearchValueState();
}

class _SaveSearchValueState extends State<SaveSearchValue> {
  TextEditingController searchNameController = TextEditingController();
  bool notifyMe = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 552.h,
      color: kbackgrounColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30.h,
              width: 1.sw,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox.shrink(),
                  SizedBox.shrink(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                      child: const Icon(Icons.close),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 165.h,
              width: 168.w,
              child: Image.asset('assets/savednew2.png'),
            ),
            SizedBox(
              height: 20.h,
            ),
            H2semi(text: Controller.getTag('Search Saved!')),
            SizedBox(
              height: 20.h,
            ),
            SizedBox(
              width: 307.w,
              child: H3Regular(
                text: Controller.getTag(
                    'access_your_saved_searches_from_the_side_menu.'),
                maxLine: 2,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            SizedBox(
              height: 55.h,
              width: 362.w,
              child: TextField(
                controller: searchNameController,
                decoration: InputDecoration(
                  label: Text(Controller.getTag('name_your_search')),
                  labelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: Controller.getLanguage().toString().toLowerCase() == "english"
                        ? GoogleFonts.montserrat().fontFamily
                        : GoogleFonts.tajawal().fontFamily,
                    fontWeight: FontWeight.w400,
                  ),
                  hintText: Controller.getTag('text_type_here'),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                children: [
                  Checkbox(
                      activeColor: kprimaryColor,
                      value: notifyMe,
                      onChanged: (value) {
                        notifyMe = value!;
                        setState(() {});
                      }),
                  GestureDetector(
                      onTap: () {
                        notifyMe = !notifyMe;

                        setState(() {});
                      },
                      child: ParaRegular(
                          text: Controller.getTag('email_me_when_ads_match_this_search'))),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 50.h,
                  width: 150.w,
                  child: MainButton(
                    text: Controller.getTag('cancel'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    isFilled: false,
                    textColor: ksecondaryColor2,
                  ),
                ),
                SizedBox(
                    height: 50.h,
                    width: 150.w,
                    child: MainButton(
                      text: Controller.getTag('ok'),
                      onTap: () async {
                        // if (!context.mounted) return;
                        // Navigator.pop(context);
                        context
                            .read<GetCategoryListing>()
                            .saveYourSearch(context,
                                searchValue: context
                                    .read<GetCategoryListing>()
                                    .searchedValue,
                                searchName:
                                    searchNameController.text.trim().toString(),
                                notifyMe: notifyMe)
                            .then((result) {
                          if (result is Map) {
                            DisplayMessage(
                                context: context,
                                isTrue: true,
                                message: Controller.languageChange(
                                    english: result['message'],
                                    arabic: result['message_ar']));
                            if (!context.mounted) return;
                            Navigator.pop(context);
                          } else {
                            DisplayMessage(
                                context: context,
                                isTrue: false,
                                message: result.toString());
                            if (!context.mounted) return;
                            Navigator.pop(context);
                          }
                        });
                      },
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
