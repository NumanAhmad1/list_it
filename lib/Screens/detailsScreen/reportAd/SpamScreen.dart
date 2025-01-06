import 'package:flutter/foundation.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/getUserProfile.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class SpamScreen extends StatefulWidget {
  var title;
  String adId;
  SpamScreen({required this.title, super.key, required this.adId});

  @override
  State<SpamScreen> createState() => _SpamScreenState();
}

class _SpamScreenState extends State<SpamScreen> {
  int _value = 0;
  TextEditingController reportController = TextEditingController();

  bool isSpamScreen = false;

  checkForSpamScreen(String title) {
    print(widget.adId);
    if (title.contains('Spam')) {
      isSpamScreen = true;
    } else {
      isSpamScreen = false;
    }
  }

  @override
  void initState() {
    checkForSpamScreen(widget.title['ReportType']);
    setState(() {});

    // TODO: implement initState
    super.initState();
  }

  List spamList = [
    Controller.getTag('it_is_against_the_list_it_terms'),
    Controller.getTag('web_links_in_description_is_not_allowed'),
    Controller.getTag('"image(s)_violates_terms_of_list_it'),
    Controller.getTag('the_price_seems_to_be_inaccuarate'),
    Controller.getTag('its_contents_are_offensive'),
    Controller.getTag('other'),
  ];

  Map<String, dynamic> reportAdData = {};
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon Arrow Backward
                  SizedBox(
                      height: 24.h,
                      width: 24.w,
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child:
                            Icon(Icons.arrow_back_ios_new_rounded))),
                  // Text Widget
                  H2Bold(text: Controller.getTag('Report this listing')),
                  const SizedBox.shrink(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: const Divider(
                      thickness: 0.5,
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        H3semi(
                          text:
                              '${Controller.getTag('what_kind_of')} ${widget.title['ReportType'].toString().toLowerCase()} ${Controller.getTag('is it')}',
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 25.h),
                        if (isSpamScreen)
                          SizedBox(
                            height: 229.h,
                            width: 357.w,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _value = 1;
                                    });
                                  },
                                  child: SizedBox(
                                    height: 25.h,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 19.h,
                                          width: 19.w,
                                          child: Radio(
                                              activeColor: kprimaryColor,
                                              value: 1,
                                              groupValue: _value,
                                              onChanged: (value) {
                                                setState(() {
                                                  _value = value!;
                                                });
                                              }),
                                        ),
                                        SizedBox(width: 12.w),
                                        SizedBox(
                                            child:
                                                H3semi(text: '${spamList[0]}'))
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _value = 2;
                                    });
                                  },
                                  child: SizedBox(
                                    height: 25.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 19.h,
                                          width: 19.w,
                                          child: Radio(
                                              activeColor: kprimaryColor,
                                              value: 2,
                                              groupValue: _value,
                                              onChanged: (value) {
                                                setState(() {
                                                  _value = value!;
                                                });
                                              }),
                                        ),
                                        const SizedBox(width: 12),
                                        SizedBox(
                                          child: H3semi(
                                            text: '${spamList[1]}',
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _value = 3;
                                    });
                                  },
                                  child: SizedBox(
                                    height: 25.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 19.h,
                                          width: 19.w,
                                          child: Radio(
                                              activeColor: kprimaryColor,
                                              value: 3,
                                              groupValue: _value,
                                              onChanged: (value) {
                                                setState(() {
                                                  _value = value!;
                                                });
                                              }),
                                        ),
                                        const SizedBox(width: 12),
                                        SizedBox(
                                            child:
                                                H3semi(text: '${spamList[2]}'))
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _value = 4;
                                    });
                                  },
                                  child: SizedBox(
                                    height: 25.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 19.h,
                                          width: 19.w,
                                          child: Radio(
                                              activeColor: kprimaryColor,
                                              value: 4,
                                              groupValue: _value,
                                              onChanged: (value) {
                                                setState(() {
                                                  _value = value!;
                                                });
                                              }),
                                        ),
                                        const SizedBox(width: 12),
                                        SizedBox(
                                            child:
                                                H3semi(text: '${spamList[3]}'))
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _value = 5;
                                    });
                                  },
                                  child: SizedBox(
                                    height: 25.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 19.h,
                                          width: 19.w,
                                          child: Radio(
                                              activeColor: kprimaryColor,
                                              value: 5,
                                              groupValue: _value,
                                              onChanged: (value) {
                                                setState(() {
                                                  _value = value!;
                                                });
                                              }),
                                        ),
                                        const SizedBox(width: 12),
                                        SizedBox(
                                            child:
                                                H3semi(text: '${spamList[4]}'))
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _value = 6;
                                    });
                                  },
                                  child: SizedBox(
                                    height: 25.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 19.h,
                                          width: 19.w,
                                          child: Radio(
                                              activeColor: kprimaryColor,
                                              value: 6,
                                              groupValue: _value,
                                              onChanged: (value) {
                                                setState(() {
                                                  _value = value!;
                                                });
                                              }),
                                        ),
                                        const SizedBox(width: 12),
                                        SizedBox(
                                            child:
                                                H3semi(text: '${spamList[5]}'))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: 357.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 25.h,
                          ),
                          H3Regular(
                            text:
                                '${Controller.getTag('please_tell_us_why_you_believe_this_is')} ${widget.title['ReportType'].toString().toLowerCase()}',
                            color: const Color(0XFFA6A6A6),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2.0),
                            child: Container(
                              height: 120.h,
                              width: 356.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.r),
                                border: Border.all(
                                  color: const Color(0XFFA6A6A6),
                                  width: 0.5.w,
                                ),
                              ),
                              child: TextField(
                                controller: reportController,
                                onChanged: (value) {
                                  reportAdData['message'] = value;
                                },
                                keyboardType: TextInputType.multiline,
                                maxLines: 15,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(2.r),
                                      borderSide: BorderSide(
                                        color: const Color(0XFFA6A6A6),
                                        width: 0.5.w,
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.r),
                                    borderSide: BorderSide(
                                      color: const Color(0XFFA6A6A6),
                                      width: 0.5.w,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (isSpamScreen)
                            Center(
                              child: H3Regular(
                                text:
                                    Controller.getTag('you_have_to_choose_to_report_this_as_spam'),
                                color: const Color(0XFFA6A6A6),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Center(
                    child: SizedBox(
                      width: 333.w,
                      child: context.select(
                        (GetUserProfile value) => value.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : MainButton(
                                text: 'Submit Report',
                                onTap: () async {
                                  reportAdData['priority'] =
                                      widget.title['ReportPriority'];
                                  reportAdData['type'] =
                                      widget.title['ReportType'];
                                  if (widget.title['ReportType'] == 'Spam') {
                                    if (_value > 0) {
                                      reportAdData['kind'] =
                                          spamList[_value - 1];
                                    }
                                  }
                                  Map<String, dynamic> selectedDataForReport = {
                                    'adId': widget.adId,
                                    'report': reportAdData,
                                  };

                                  await context.read<GetUserProfile>().reportAd(
                                      context,
                                      userReportedMapData:
                                          selectedDataForReport);
                                  if (!context.mounted) return;
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
