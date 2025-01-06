import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/mySavedSearches.dart';
import 'package:lisit_mobile_app/Screens/search/savedSearch/widget/noSavedSearches.dart';
import 'package:lisit_mobile_app/Screens/search/searchedItemsScreen.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';
import 'package:lisit_mobile_app/widgets/noInternet.dart';

import 'widget/moreButtonDialog.dart';
import 'widget/notificationButtonDialog.dart';

class SavedSearch extends StatefulWidget {
  const SavedSearch({super.key});

  @override
  State<SavedSearch> createState() => _SavedSearchState();
}

class _SavedSearchState extends State<SavedSearch> {
  bool emailNotification = false;

  Future getSavedSearch() async {
    await context
        .read<MySavedSearchProvider>()
        .getMySavedSearches(context)
        .then((value) {
      context.read<MySavedSearchProvider>().initsavedSearch();
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getSavedSearch();
    });

    // TODO: implement initState
    super.initState();
  }

  Map<String, String> convertStringToMap(String inputString) {
    Map<String, String> resultMap = {};

    // Splitting the string by "~" to get key-value pairs
    List<String> pairs = inputString.split("~");

    // Iterating through each pair
    for (String pair in pairs) {
      // Splitting each pair by ":" to separate key and value
      List<String> keyValue = pair.split(":");
      String key = keyValue[0].trim();
      String value = keyValue.length > 1
          ? keyValue[1].trim()
          : ''; // If value is empty, set it to empty string
      resultMap[key] = value;
    }

    return resultMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MySavedSearchProvider>(builder: (context, value, child) {
        return Column(
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

                    //Edit profile title

                    AnimatedContainer(
                        width: value.isSearchClicked ? 0 : null,
                        duration: const Duration(seconds: 1),
                        child: H2Bold(
                            text: Controller.getTag('my_saved_searches'))),

                    // trash icon button
                    AnimatedContainer(
                      height: 40.h,
                      duration: const Duration(seconds: 1),
                      decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide())),
                      width: value.isSearchClicked ? 300.w : 0,
                      child: TextField(
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Search',
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                        ),
                        onChanged: (query) {
                          value.savedSearchFunction(query: query);
                        },
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        value.changesearchclick();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: Icon(
                          value.isSearchClicked
                              ? Icons.close
                              : Icons.search_rounded,
                        ),
                      ),
                    ),
                    // const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            // NoSavedSearches(),
            // saved search card
            Expanded(
              child: value.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : value.error.isNotEmpty
                      ? value.error == 'No Internet Connection'
                          ? SizedBox(
                              height: 0.7.sh,
                              child: const Center(child: NoInternet()))
                          : Center(
                              child: H2Bold(
                                text: value.error.toString(),
                              ),
                            )
                      : value.searchedSaveSearchTitle.isEmpty
                          ? SizedBox(
                              height: 0.6.sh,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 279.h,
                                    width: 189.w,
                                    child:
                                        Image.asset('assets/mySavedSearch.png'),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  H2semi(
                                      text: Controller.getTag(
                                          'you_have_no_saved_searches_yet')),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  H3Regular(
                                      text: Controller.getTag(
                                          'saving_a_search_helps_you_find_your_item_faster')),
                                ],
                              ))
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: value.searchedSaveSearchTitle.length,
                              itemBuilder: (context, index) {
                                var data = value.searchedSaveSearchTitle[index];
                                Map<String, dynamic> searchedData = {};
                                searchedData = convertStringToMap(
                                    data['Value'].toString());

                                log('$searchedData');
                                String category = '';
                                String catValue = data['Value']
                                    .toString()
                                    .replaceAll('%', '');
                                List catValueList = catValue.split('~');
                                for (var cat in catValueList) {
                                  if (cat
                                      .toString()
                                      .toLowerCase()
                                      .contains('category')) {
                                    // log('${cat}');
                                    List categoryValues =
                                        cat.toString().split(':');
                                    log('${cat}');
                                    if (categoryValues.isNotEmpty) {
                                      category += '${categoryValues[1]}';
                                    }
                                  }
                                  if (cat
                                      .toString()
                                      .toLowerCase()
                                      .contains('title')) {
                                    List titleValues =
                                        cat.toString().split(':');
                                    if (titleValues.isNotEmpty) {
                                      category += titleValues[1];
                                    }
                                  }
                                }

                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 20.h),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  width: 1.sw,
                                  height: 118.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.r),
                                    color: kbackgrounColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            khelperTextColor.withOpacity(0.2),
                                        blurRadius: 8.r,
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // row for category
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SearchItemsScreen(
                                                            categoryTitle:
                                                                searchedData,
                                                          )));
                                            },
                                            child: SizedBox(
                                              width: 275.w,
                                              child: ParaRegular(
                                                text: '${category}',
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SearchItemsScreen(
                                                            categoryTitle:
                                                                searchedData,
                                                          )));
                                            },
                                            child: SizedBox(
                                              width: 56.w,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  //notification icon button

                                                  GestureDetector(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          backgroundColor:
                                                              kbackgrounColor,
                                                          shape:
                                                              const BeveledRectangleBorder(),
                                                          context: context,
                                                          builder: (context) {
                                                            return NotificationButtonDialog(
                                                              searchId:
                                                                  data['Id'],
                                                              searchTitle:
                                                                  '${data['Name']}',
                                                              searchCategory:
                                                                  category,
                                                              searchImage: '',
                                                              searchName:
                                                                  '${data['Name']}',
                                                              searchValue:
                                                                  '${data['Value']}',
                                                              emailNotification:
                                                                  data[
                                                                      'NotifyEmail'],
                                                              inAppnotification:
                                                                  data[
                                                                      'NotifyMobile'],
                                                            );
                                                          });
                                                    },
                                                    child: SizedBox(
                                                      height: 24.h,
                                                      width: 24.w,
                                                      child: Image.asset(
                                                        'assets/notificationPreferences.png',
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                  // more button
                                                  GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return MoreButtonDialog(
                                                              searchId:
                                                                  data['Id'],
                                                              searchTitle:
                                                                  '${data['Name']}',
                                                              searchCategory:
                                                                  category,
                                                              searchImage: '',
                                                              searchName:
                                                                  '${data['Name']}',
                                                              searchValue:
                                                                  '${data['Value']}',
                                                              emailNotification:
                                                                  data[
                                                                      'NotifyEmail'],
                                                              inAppnotification:
                                                                  data[
                                                                      'NotifyMobile'],
                                                            );
                                                          });
                                                    },
                                                    child: SizedBox(
                                                      width: 24.w,
                                                      height: 24.h,
                                                      child: Icon(
                                                        Icons.more_vert_rounded,
                                                        color: ksecondaryColor2,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // row for title

                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SearchItemsScreen(
                                                        categoryTitle:
                                                            searchedData,
                                                      )));
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            H3semi(
                                              text: '${data['Name']}',
                                              maxLines: 1,
                                            ),
                                            // Container(
                                            //   margin: EdgeInsets.only(left: 5.w),
                                            //   alignment: Alignment.center,
                                            //   padding: EdgeInsets.symmetric(
                                            //       horizontal: 5.w),
                                            //   height: 14.h,
                                            //   decoration: BoxDecoration(
                                            //     borderRadius:
                                            //         BorderRadius.circular(7.r),
                                            //     color: kprimaryColor,
                                            //   ),
                                            //   child: Text(
                                            //     '5426 new ads',
                                            //     style: TextStyle(
                                            //       fontSize: 8.sp,
                                            //       fontWeight: FontWeight.w700,
                                            //       color: kbackgrounColor,
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),

                                      // city button

                                      // Container(
                                      //   padding: EdgeInsets.symmetric(
                                      //       horizontal: 5.w),
                                      //   height: 14.h,
                                      //   decoration: BoxDecoration(
                                      //     borderRadius:
                                      //         BorderRadius.circular(7.r),
                                      //     color: ksecondaryColor2,
                                      //   ),
                                      //   child: Text(
                                      //     'Dubai',
                                      //     style: TextStyle(
                                      //       fontSize: 8.sp,
                                      //       fontWeight: FontWeight.w400,
                                      //       color: kbackgrounColor,
                                      //     ),
                                      //   ),
                                      // ),

                                      //date
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SearchItemsScreen(
                                                        categoryTitle:
                                                            searchedData,
                                                      )));
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ParaRegular(
                                                text:
                                                    '${Controller.getTag('saved')} : ${Controller.formatDateTime(data['Time'])}'),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 20.w),
                                              height: 39.h,
                                              width: 76.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(3.r),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 4.r,
                                                    color: khelperTextColor
                                                        .withOpacity(0.2),
                                                  ),
                                                ],
                                              ),
                                              child: Image.asset(
                                                  'assets/savedSearchImage.png'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
            ),

            //column1 end
          ],
        );
      }),
    );
  }
}
