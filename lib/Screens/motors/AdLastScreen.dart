import 'dart:developer';

import 'package:lisit_mobile_app/Controller/Providers/data/GetAllChatsUser.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/addSummary.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/adsInputField.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/getCategory.dart';
import 'package:lisit_mobile_app/Models/addSummaryModel.dart';
import 'package:lisit_mobile_app/Screens/myAdsScreen/myAdsScreen.dart';
import 'package:lisit_mobile_app/Screens/termsAndConditions/termandcondition.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class AdLastScreen extends StatefulWidget {
  List<AddSummaryModel> selectedValueList;
  AdLastScreen({super.key, required this.selectedValueList});

  @override
  State<AdLastScreen> createState() => _AdLastScreenState();
}

class _AdLastScreenState extends State<AdLastScreen> {
  List extra = [];
  List extraAr = [];
  List extraValueAr = [];
  List extraValue = [];

  extracExtras() {
    for (int i = 0; i < widget.selectedValueList.length; i++) {
      var value = widget.selectedValueList[i];
      var valueAr = widget.selectedValueList[i];
      if (value.name.contains('[') && value.name.contains(']')) {
        var name = value.name.split('[');
        var nameAr = valueAr.nameAr.split('[');
        if (extra.contains(name[0])) {
          for (int j = 0; j < extra.length; j++) {
            if (name[0] == extra[j]) {
              extraValue[j] += ',${name[1].replaceAll(']', '')}';
              extraValueAr[j] += ',${nameAr[1].replaceAll(']', '')}';
            }
          }
        } else {
          extra.add(name[0]);
          extraAr.add(nameAr[0]);
          extraValue.add(name[1].replaceAll(']', ''));
          extraValueAr.add(nameAr[1].replaceAll(']', ''));
        }
      }
    }

    for (var i = 0; i < widget.selectedValueList.length; i++) {
      if (widget.selectedValueList[i].field == 'Checkboxes') {
        widget.selectedValueList.removeAt(i);
        i--;
      }
    }

    if (extra.isNotEmpty) {
      widget.selectedValueList.add(AddSummaryModel(
          name: extra[0],
          nameAr: extraAr[0],
          value: extraValue.join(', '),
          valueAr: extraValueAr.join(', '),
          field: 'Checkboxes'));
    }
  }

  @override
  void initState() {
    extracExtras();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    extra.clear();
    extraAr.clear();
    extraValue.clear();
    extraValueAr.clear();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //appbar section
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

                    //profile title

                    H2Bold(text: Controller.getTag('place_ad')),

                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: const Icon(Icons.close),
                        )),
                  ],
                ),
              ),
            ),

            //body
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 23.h,
                    ),
                    H2Bold(
                      text: Controller.getTag(
                          'we_review_all_ads_to_keep_everyone_on_list_it_safe_and_happy.'),
                      maxLines: 3,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 35.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        H2semi(text: Controller.getTag('ad_not_live')),
                      ],
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    SizedBox(
                      width: 365.w,
                      child:
                          H2semi(text: Controller.getTag('ad_not_live_rule_1')),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    SizedBox(
                      width: 365.w,
                      child:
                          H2semi(text: Controller.getTag('ad_not_live_rule_2')),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    SizedBox(
                      width: 365.w,
                      child:
                          H2semi(text: Controller.getTag('ad_not_live_rule_3')),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    SizedBox(
                      width: 365.w,
                      child:
                          H2semi(text: Controller.getTag('ad_not_live_rule_4')),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    SizedBox(
                      width: 365.w,
                      child:
                          H2semi(text: Controller.getTag('ad_not_live_rule_5')),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        H3Regular(text: Controller.getTag('more_info_guide')),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Termandcondition()));
                          },
                          child: H3semi(
                            text: Controller.getTag('terms_and_conditions'),
                            color: kprimaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MainButton(
                          isLoading: Provider.of<AddSummary>(context).isLoading,
                          text: Controller.getTag('yes_agree'),
                          onTap: () async {
                            // log('before');
                            // widget.selectedValueList.forEach((e) {
                            //   print(e.field);
                            //   print(e.name);
                            //   print(e.value);
                            // });
                            // extracExtras();
                            // log('after');
                            // widget.selectedValueList.forEach((e) {
                            //   print(e.field);
                            //   print(e.name);
                            //   print(e.value);
                            // });
                            // print('object');

                            // print(extra);
                            // print(extraValue);
                            // print(extraAr);
                            // print(extraValueAr);
                            // extraValue.forEach((element) {
                            //   print(element);
                            // });

                            widget.selectedValueList.forEach((element) {
                              log('${element.name}');
                              log('${element.value}');

                              log('${element.field}');
                            });

                            await context
                                .read<AddSummary>()
                                .postAddSummary(
                                    context
                                        .read<GetCategory>()
                                        .subCategoryiesList[1]
                                        .id,
                                    context
                                        .read<GetCategory>()
                                        .subCategoryiesList
                                        .last
                                        .id,
                                    context,
                                    widget.selectedValueList)
                                .then((value) {
                              log(value);
                              if (value.contains(
                                  'Summary and Details added successfully')) {
                                context
                                    .read<AdsInputField>()
                                    .carAdOneSelectedValuesList
                                    .clear();
                                context
                                    .read<AdsInputField>()
                                    .carAdTwoSelectedValuesList
                                    .clear();
                                context
                                    .read<AdsInputField>()
                                    .carAdOneSelectedValuesList
                                    .clear();
                                context
                                    .read<AdsInputField>()
                                    .carAdTwoSelectedValuesList
                                    .clear();
                                context
                                    .read<AdsInputField>()
                                    .selectedValueList
                                    .clear();

                                DisplayMessage(
                                    context: context,
                                    isTrue: true,
                                    message: value);
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyAdsScreen()),
                                    (route) =>
                                        route.isFirst || route.isCurrent);
                              } else {
                                DisplayMessage(
                                    context: context,
                                    isTrue: false,
                                    message: value);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
