import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/deleteMyAd.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/getCarDetails.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/myAds.dart';
import 'package:lisit_mobile_app/Screens/AdsScreen/carAd/editAdScreen.dart';
import 'package:lisit_mobile_app/Screens/detailsScreen/detailsScreen.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';
import 'package:lisit_mobile_app/widgets/noAdsinMyAds.dart';

import 'widget/adTile.dart';

class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({super.key});

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
  int selectedScreen = 0;

  bool isAdSelected = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    await context.read<MyAds>().getMainAds(context);
  }

  String adCategory = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MyAds>(builder: (context, value, child) {
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
                        child: const Icon(Icons.arrow_back_ios_rounded)),

                    //Edit profile title

                    H2Bold(text: Controller.getTag('my_ads')),

                    // trash icon button
                    value.dataList.isNotEmpty && !adCategory.contains('delete')
                        ? GestureDetector(
                            onTap: () async {
                              if (context
                                  .read<DeleteMyAdProvider>()
                                  .selectedAdIds
                                  .isNotEmpty) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const AlertDialog(
                                          //
                                          contentPadding: EdgeInsets.zero,
                                          content: DeleteYourAd());
                                    });
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.w),
                              child: Icon(
                                Icons.delete_outline_outlined,
                                color: kredText,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            // value.isLoading
            //     ? Container(
            //         height: 0.8.sh,
            //         alignment: Alignment.center,
            //         child: const CircularProgressIndicator())
            //     // : value.dataList.isEmpty
            //     //     ? const NoAdsInMyAds()
            //     :
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 20.h,
                    left: 10.w,
                    // bottom: 30.h,
                  ),
                  child: SizedBox(
                    width: 1.sw,
                    height: 40.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        value.adStatusList.length,
                        (index) => GestureDetector(
                          onTap: () async {
                            selectedScreen = index;
                            adCategory = value.adStatusList[index].status
                                .toString()
                                .toLowerCase();
                            setState(() {});
                            await value.getAds(context,
                                adStatus: value.adStatusList[index].status
                                    .toString()
                                    .toLowerCase());
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.w),
                            alignment: Alignment.center,
                            height: 40.h,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                            ),
                            decoration: BoxDecoration(
                              color: selectedScreen == index
                                  ? kprimaryColor2
                                  : kbackgrounColor,
                              borderRadius: BorderRadius.circular(115.r),
                              border: Border.all(color: kredText),
                            ),
                            child: ParaRegular(
                              text:
                                  '${Controller.languageChange(english: value.adStatusList[index].status, arabic: Controller.getTag(value.adStatusList[index].status.toLowerCase()))} (${value.adStatusList[index].count.toString()})',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // // verify phone number
                // if (!Controller.getisUserVerified())
                //   GestureDetector(
                //     onTap: () {
                //       showDialog(
                //           context: context,
                //           builder: (context) {
                //             return EnterNumber();
                //           });
                //     },
                //     child: Container(
                //       clipBehavior: Clip.hardEdge,
                //       height: 130.h,
                //       width: 369.w,
                //       decoration: BoxDecoration(
                //         color: kbackgrounColor,
                //         borderRadius: BorderRadius.circular(6.r),
                //         boxShadow: [
                //           BoxShadow(
                //             color: Colors.black12,
                //             blurRadius: 4.sp,
                //             offset: const Offset(0.5, 1),
                //             blurStyle:
                //                 BlurStyle.normal, // Shadow position
                //           ),
                //         ],
                //       ),
                //       child: Row(
                //         children: [
                //           // icon image
                //           Container(
                //             width: 89.w,
                //             height: 130.h,
                //             decoration: ShapeDecoration(
                //               color: kprimaryColor2,
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.only(
                //                   topLeft: Radius.circular(6.r),
                //                   bottomLeft: Radius.circular(6.r),
                //                 ),
                //               ),
                //             ),
                //             child: Container(
                //               alignment: Alignment.center,
                //               child: Stack(children: [
                //                 SvgPicture.asset(
                //                   'assets/verifyMobileNumber.svg',
                //                   width: 24.w,
                //                   height: 24.h,
                //                 ),
                //               ]),
                //             ),
                //           ),
                //           Container(
                //             width: 280.w,
                //             decoration: BoxDecoration(
                //               color: kbackgrounColor,
                //               borderRadius: BorderRadius.only(
                //                 bottomRight: Radius.circular(6.r),
                //                 topRight: Radius.circular(6.r),
                //               ),
                //             ),
                //             child: Padding(
                //               padding: EdgeInsets.symmetric(
                //                   horizontal: 10.w),
                //               child: Column(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceEvenly,
                //                 crossAxisAlignment:
                //                     CrossAxisAlignment.start,
                //                 children: [
                //                   H3semi(
                //                       text:
                //                           'Verify your Mobile number'),
                //                   Row(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment
                //                             .spaceBetween,
                //                     children: [
                //                       SizedBox(
                //                         width: 211.w,
                //                         height: 37.h,
                //                         child: ParaRegular(
                //                             text:
                //                                 'Verify your number before posting an ad'),
                //                       ),
                //                       const Icon(Icons
                //                           .arrow_forward_rounded),
                //                     ],
                //                   ),
                //                   ParaSemi(
                //                     text: 'Get Started',
                //                     color: kprimaryColor,
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),

                //Ads Tile
                value.adsLoading
                    ? Container(
                        height: 0.5.sh,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      )
                    : value.dataList.isEmpty
                        ? NoAdsInMyAds(
                            noAdText: selectedScreen,
                          )
                        : SizedBox(
                            height: Controller.getisUserVerified()
                                ? 603.h + 130.h
                                : 603.h,
                            child: Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: ListView.builder(
                                  // shrinkWrap: true,
                                  itemCount: value.dataList.length,
                                  itemBuilder: (context, i) {
                                    var data = value.dataList[i];
                                    String id = data['_id'];
                                    String image = '';
                                    String title = '';
                                    String price = '';
                                    String status = data['status'];
                                    String date = data['created_at'];

                                    (data['data'] as List).forEach((e) {
                                      if (e['name'] == 'Title') {
                                        title = e['value'];
                                      } else if (e['name']
                                          .contains('Pictures')) {
                                        image =
                                            e['value'].toString().split(',')[0];
                                      } else if (e['name'] == 'Price') {
                                        price = e['value'].toString();
                                      }
                                    });

                                    return Stack(
                                      alignment: Controller.getLanguage()
                                                  .toString()
                                                  .toLowerCase() ==
                                              'english'
                                          ? Alignment.topRight
                                          : Alignment.topLeft,
                                      children: [
                                        AdTile(
                                            adId: id,
                                            status: status,
                                            image: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: image
                                                    .replaceAll('[', "")
                                                    .replaceAll("]", ""),
                                                placeholder: (context, url) =>
                                                    const Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                errorWidget: (context, s, o) =>
                                                    const Center(
                                                      child: Icon(Icons
                                                          .error_outline_outlined),
                                                    )),
                                            title: '${title}',
                                            price:
                                                '${Controller.getTag('aed')} ${price}',
                                            lastDate:
                                                '${Controller.formatDateTime(date)}',
                                            isSelected: Provider.of<
                                                    DeleteMyAdProvider>(context)
                                                .selectedAdIds
                                                .any(
                                                    (element) => element == id),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailsScreen(
                                                              tag: 'tag$i',
                                                              carId: id)));
                                            }),
                                        // if (status.toLowerCase() != 'active')
                                        Provider.of<GetCarDetails>(context)
                                                .isLoading
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    top: 5.h,
                                                    right: 30.w,
                                                    left: 30.w),
                                                child: Icon(
                                                  Icons.edit,
                                                  color: kprimaryColor,
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () async {
                                                  await context
                                                      .read<GetCarDetails>()
                                                      .getCarDetails(context,
                                                          id: id);

                                                  String categoryId = context
                                                      .read<GetCarDetails>()
                                                      .categorId;
                                                  if (!context.mounted) return;
                                                  if (categoryId.isNotEmpty &&
                                                      categoryId != 'null') {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditAdScreen(
                                                                  id: id,
                                                                  categoryId:
                                                                      categoryId,
                                                                )));
                                                  }
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 5.h,
                                                      right: 30.w,
                                                      left: 30.w),
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: kprimaryColor,
                                                  ),
                                                ),
                                              ),
                                      ],
                                    );
                                  }),
                            ),
                          ),

                // screens[selectedScreen],

                //column2 end
              ],
            ),

            //column1 end
          ],
        );
      }),
    );
  }
}

class DeleteYourAd extends StatefulWidget {
  const DeleteYourAd({super.key});

  @override
  State<DeleteYourAd> createState() => _DeleteYourAdState();
}

class _DeleteYourAdState extends State<DeleteYourAd> {
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: kbackgrounColor, borderRadius: BorderRadius.circular(4.r)),
      height: 220.h,
      width: 400.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 25.h,
          ),
          H2semi(
            text: Controller.getTag('delete_selected_Ad(s)'),
            color: kprimaryColor,
          ),
          SizedBox(
            height: 25.h,
          ),
          SizedBox(
            width: 300.w,
            child: H3Regular(
                textAlign: TextAlign.center,
                text: Controller.getTag(
                    'this_action_can_not_be_undone_and_the_ad_will_be_gone_forever.')),
          ),
          SizedBox(
            height: 25.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                  height: 40.h,
                  width: 130.w,
                  child: MainButton(
                    text: Controller.getTag('cancel'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    isFilled: false,
                    textColor: ksecondaryColor,
                  )),
              SizedBox(
                  height: 40.h,
                  width: 130.w,
                  child: MainButton(
                      text: Controller.getTag('delete'),
                      onTap: () async {
                        if (context
                            .read<DeleteMyAdProvider>()
                            .selectedAdIds
                            .isNotEmpty) {
                          await context
                              .read<DeleteMyAdProvider>()
                              .deleteResponse(context);
                          // await context.read<MyAds>().getMainAds();
                          DisplayMessage(
                              context: context,
                              isTrue: true,
                              message:
                                  '${context.read<DeleteMyAdProvider>().error}');
                          await context.read<MyAds>().getMainAds(context);
                        } else {
                          DisplayMessage(
                              context: context,
                              isTrue: false,
                              message:
                                  Controller.getTag('please_select_an_ad'));
                        }
                        Navigator.pop(context);
                      })),
            ],
          ),
          SizedBox(
            height: 25.h,
          ),
        ],
      ),
    );
  }
}
