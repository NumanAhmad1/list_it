import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/favourite.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/getUserProfile.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/getCarDetails.dart';
import 'package:lisit_mobile_app/Screens/AuthScreens/loginScreen/loginScreen.dart';
import 'package:lisit_mobile_app/Screens/detailsScreen/dealerAllAds.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';
import 'package:lisit_mobile_app/widgets/popularCarCard.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/AdMob/AdMobBanner.dart';
import '../chat/messagesScreen.dart';
import 'reportAd/reportListing.dart';
import 'widget/contactButton.dart';
import 'widget/detailScreenDetailTile.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailsScreen extends StatefulWidget {
  String tag;
  String carId;
  DetailsScreen({
    required this.tag,
    required this.carId,
    super.key,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  void initState() {
    final ctrl = Provider.of<GetCarDetails>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctrl.getCarDetails(context, id: widget.carId);
      context.read<Favourite>().checkFavourite(id: widget.carId);
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getProfileData();
    super.didChangeDependencies();
  }

  getProfileData() async {
    await context.read<GetUserProfile>().getUserProfile(context);
    await context
        .read<GetCarDetails>()
        .getAddress(context.read<GetCarDetails>().location);
  }

  double itemHeight = 360.0.h;
  int scrolledIndex = 0;
  int listLength = 0;
  ScrollController _scrollController = ScrollController();

  Completer<GoogleMapController> _controller = Completer();
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  bool isShowMoreTitleClicked = false;

  @override
  Widget build(BuildContext context) {
    bool isFavourite = context.select(
        (Favourite isFav) => isFav.favouriteIdList.contains(widget.carId));

    print('this is the is favourite $isFavourite');

    return Scaffold(
      body: SizedBox(
        width: 1.sw,
        child: Consumer<GetCarDetails>(builder: (context, provider, child) {
          var formatBid = NumberFormat("#,###,###");
          var id = provider.createdBy;
          return provider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : provider.detailsKey.isEmpty
                  ? H2Bold(text: Controller.getTag('no_data'))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          padding: EdgeInsets.only(top: 25.h),
                          duration: const Duration(milliseconds: 300),
                          width: 1.sw,
                          height: scrolledIndex > 1 ? 95.h : 0.h,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: ksearchFieldColor),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 10.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // back icon
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 14.h, right: 5.w),
                                    child: const Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                    ),
                                  ),
                                ),

                                //profile title

                                Container(
                                  alignment: Controller.getLanguage()
                                              .toString()
                                              .toLowerCase() ==
                                          'english'
                                      ? Alignment.topLeft
                                      : Alignment.topRight,
                                  width: 283.w,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      H2Bold(
                                        text:
                                            '${formatBid.format(int.parse("${provider.price}"))} ${Controller.getTag('aed')}',
                                        // text: '${provider.price} AED',
                                        color: kprimaryColor,
                                        maxLines: 1,
                                      ),
                                      H3semi(
                                        text: '${provider.title}',
                                        maxLines: 1,
                                      )
                                    ],
                                  ),
                                ),

                                Container(
                                  alignment: Alignment.center,
                                  width: 80.w,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (Controller.getUserId() !=
                                          provider.createdBy['_id'])
                                        GestureDetector(
                                          onTap: () async {
                                            if (Controller.getLogin()) {
                                              await context
                                                  .read<Favourite>()
                                                  .addToFavourite(
                                                    context,
                                                    addId: widget.carId,
                                                  );
                                            } else {
                                              DisplayMessage(
                                                  context: context,
                                                  isTrue: false,
                                                  message: Controller.getTag(
                                                      'login_to_continue'));
                                              showModalBottomSheet(
                                                  shape:
                                                      const BeveledRectangleBorder(),
                                                  barrierColor: kbackgrounColor,
                                                  backgroundColor:
                                                      kbackgrounColor,
                                                  isScrollControlled: true,
                                                  context: context,
                                                  builder: (context) {
                                                    return LoginScreen(
                                                      data: [
                                                        'detailScreen',
                                                        'favourite',
                                                        widget.carId
                                                      ],
                                                    );
                                                  });
                                            }
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 38.h,
                                            width: 38.w,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: kbackgrounColor,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black38,
                                                  blurRadius: 4.sp,
                                                  offset: const Offset(0.5, 1),
                                                  blurStyle: BlurStyle
                                                      .normal, // Shadow position
                                                ),
                                              ],
                                            ),
                                            child: context.select(
                                                (Favourite isFav) => isFav
                                                        .isAddedToFavourite
                                                    ? Icon(
                                                        Icons.favorite,
                                                        size: 24.sp,
                                                        color: kredColor,
                                                      )
                                                    : Icon(
                                                        Icons.favorite_border,
                                                        size: 24.sp,
                                                        color: kprimaryColor,
                                                      )),
                                          ),
                                        ),
                                      GestureDetector(
                                        onTap: () async {
                                          await Share.share(
                                              '${dotenv.env['shareableLink']}${provider.adLink}/${widget.carId}');
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 38.h,
                                          width: 38.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: kbackgrounColor,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black38,
                                                blurRadius: 4.sp,
                                                offset: const Offset(0.5, 1),
                                                blurStyle: BlurStyle
                                                    .normal, // Shadow position
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            Icons.share,
                                            color: ksecondaryColor,
                                            size: 24.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        PageStorage(
                          bucket: PageStorageBucket(),
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (notification) {
                              setState(() {
                                scrolledIndex =
                                    (_scrollController.position.pixels +
                                            300.h) ~/
                                        itemHeight;
                              });
                              return true;
                            },
                            child: Expanded(
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                child: Column(
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        // image

                                        SizedBox(
                                          width: 1.sw,
                                          height: 360.h,
                                          child: Hero(
                                            tag: widget.tag,
                                            child: provider.images.isEmpty
                                                ? const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  )
                                                : GestureDetector(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          backgroundColor:
                                                              ksecondaryColor,
                                                          shape:
                                                              const BeveledRectangleBorder(),
                                                          isScrollControlled:
                                                              true,
                                                          context: context,
                                                          builder: (context) {
                                                            return StatefulBuilder(
                                                                builder: (BuildContext
                                                                        context,
                                                                    StateSetter
                                                                        setState) {
                                                              return Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            30.h),
                                                                height: 1.sh,
                                                                width: 1.sw,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                                                                            child:
                                                                                Icon(
                                                                              Icons.close,
                                                                              color: kbackgrounColor,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          268.h,
                                                                      width:
                                                                          1.sw,
                                                                      child:
                                                                          CarouselSlider(
                                                                        items: List
                                                                            .generate(
                                                                          provider
                                                                              .images
                                                                              .length,
                                                                          (index) =>
                                                                              CachedNetworkImage(
                                                                            imageUrl:
                                                                                provider.images[index],
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            width:
                                                                                1.sw,
                                                                            height:
                                                                                360.h,
                                                                            placeholder: (context, error) =>
                                                                                const Center(
                                                                              child: CircularProgressIndicator(),
                                                                            ),
                                                                            errorWidget: (context, url, error) =>
                                                                                Center(
                                                                              child: Image.asset("assets/placeholderImage.png"),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        options:
                                                                            CarouselOptions(
                                                                          initialPage:
                                                                              provider.imageIndex + 1,
                                                                          onPageChanged:
                                                                              (imageIndex, reaseon) {
                                                                            provider.changeImage(imageIndex);
                                                                            setState(() {});
                                                                          },
                                                                          aspectRatio:
                                                                              1 / 1,
                                                                          viewportFraction:
                                                                              1,
                                                                          enlargeCenterPage:
                                                                              true,
                                                                          enableInfiniteScroll:
                                                                              true,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: 15
                                                                              .w,
                                                                          vertical:
                                                                              10.h),
                                                                      child:
                                                                          ParaRegular(
                                                                        text:
                                                                            '${Controller.getTag('showing')} ${provider.imageIndex + 1} / ${provider.images.length == 0 ? 1 : provider.images.length}',
                                                                        color:
                                                                            kbackgrounColor,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            });
                                                          });
                                                    },
                                                    child: CarouselSlider(
                                                      items: List.generate(
                                                        provider.images.length,
                                                        (index) =>
                                                            CachedNetworkImage(
                                                          imageUrl: provider
                                                              .images[index]
                                                              .replaceAll(
                                                                  '[', "")
                                                              .replaceAll(
                                                                  "]", ""),
                                                          fit: BoxFit.cover,
                                                          width: 1.sw,
                                                          height: 360.h,
                                                          placeholder: (context,
                                                                  error) =>
                                                              const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Center(
                                                            child: Image.asset(
                                                                "assets/placeholderImage.png"),
                                                          ),
                                                        ),
                                                      ),
                                                      options: CarouselOptions(
                                                        onPageChanged:
                                                            (imageIndex,
                                                                reaseon) {
                                                          provider.changeImage(
                                                              imageIndex);
                                                        },
                                                        aspectRatio: 1 / 1,
                                                        viewportFraction: 1,
                                                        enlargeCenterPage: true,
                                                        enableInfiniteScroll:
                                                            true,
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ),

                                        //Back button

                                        Positioned(
                                          top: 30.h,
                                          left: Controller.getLanguage()
                                                      .toString()
                                                      .toLowerCase() ==
                                                  'english'
                                              ? 20.w
                                              : null,
                                          right: Controller.getLanguage()
                                                      .toString()
                                                      .toLowerCase() ==
                                                  'english'
                                              ? null
                                              : 20.w,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Icon(
                                              Icons.arrow_back_ios_new_rounded,
                                              size: 40.h,
                                              color: kprimaryColor,
                                            ),
                                          ),
                                        ),

                                        // favourite button
                                        if (Controller.getUserId() !=
                                            provider.createdBy['_id'])
                                          Positioned(
                                            bottom: -12.h,
                                            right: Controller.getLanguage()
                                                        .toString()
                                                        .toLowerCase() ==
                                                    'english'
                                                ? 72.w
                                                : null,
                                            left: Controller.getLanguage()
                                                        .toString()
                                                        .toLowerCase() ==
                                                    'english'
                                                ? null
                                                : 72.w,
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 38.h,
                                              width: 38.w,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: kbackgrounColor,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black38,
                                                    blurRadius: 4.sp,
                                                    offset:
                                                        const Offset(0.5, 1),
                                                    blurStyle: BlurStyle
                                                        .normal, // Shadow position
                                                  ),
                                                ],
                                              ),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  if (Controller.getLogin()) {
                                                    await context
                                                        .read<Favourite>()
                                                        .addToFavourite(
                                                          context,
                                                          addId: widget.carId,
                                                        );
                                                  } else {
                                                    DisplayMessage(
                                                        context: context,
                                                        isTrue: false,
                                                        message: Controller.getTag(
                                                            'login_to_continue'));
                                                    showModalBottomSheet(
                                                        shape:
                                                            const BeveledRectangleBorder(),
                                                        barrierColor:
                                                            kbackgrounColor,
                                                        backgroundColor:
                                                            kbackgrounColor,
                                                        isScrollControlled:
                                                            true,
                                                        context: context,
                                                        builder: (context) {
                                                          return LoginScreen(
                                                            data: [
                                                              'detailScreen',
                                                              'favourite',
                                                              widget.carId
                                                            ],
                                                          );
                                                        });
                                                  }
                                                },
                                                child: context.select(
                                                    (Favourite isFav) => isFav
                                                            .isAddedToFavourite
                                                        ? Icon(
                                                            Icons.favorite,
                                                            size: 24.sp,
                                                            color: kredColor,
                                                          )
                                                        : Icon(
                                                            Icons
                                                                .favorite_border,
                                                            size: 24.sp,
                                                            color:
                                                                kprimaryColor,
                                                          )),
                                                //  Icon(
                                                //   Icons.favorite_border,
                                                //   size: 18.sp,
                                                //   color: kprimaryColor,
                                                // ),
                                                // Icon(
                                                //   Icons.favorite,
                                                // color: context.select(
                                                //     (Favourite isFav) =>
                                                //         isFav.isAddedToFavourite
                                                //             ? kredColor
                                                //             : kprimaryColor),
                                                //   size: 18.sp,
                                                // ),
                                              ),
                                            ),
                                          ),

                                        // share button

                                        Positioned(
                                          bottom: -12.h,
                                          right: Controller.getLanguage()
                                                      .toString()
                                                      .toLowerCase() ==
                                                  'english'
                                              ? 28.w
                                              : null,
                                          left: Controller.getLanguage()
                                                      .toString()
                                                      .toLowerCase() ==
                                                  'english'
                                              ? null
                                              : 28.w,
                                          child: GestureDetector(
                                            onTap: () async {
                                              await Share.share(
                                                  '${dotenv.env['shareableLink']}${provider.adLink}/${widget.carId}');
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 38.h,
                                              width: 38.w,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: kbackgrounColor,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black38,
                                                    blurRadius: 4.sp,
                                                    offset:
                                                        const Offset(0.5, 1),
                                                    blurStyle: BlurStyle
                                                        .normal, // Shadow position
                                                  ),
                                                ],
                                              ),
                                              child: Icon(
                                                Icons.share,
                                                color: ksecondaryColor,
                                                size: 24.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 14.h,
                                          left: 30.w,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.w,
                                                vertical: 10.h),
                                            child: ParaRegular(
                                              text:
                                                  '${provider.imageIndex + 1} / ${provider.images.length}',
                                              color: kbackgrounColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    //
                                    Container(
                                      margin: EdgeInsets.only(top: 15.h),
                                      width: 1.sw,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            width: 2.w,
                                            color: khelperTextColor,
                                          ),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 25.w),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 20.h),
                                              child: H2semi(
                                                text:
                                                    '${formatBid.format(int.parse("${provider.price}"))} ${Controller.getTag('aed')}',
                                                color: kredText,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                isShowMoreTitleClicked =
                                                    !isShowMoreTitleClicked;
                                                setState(() {});
                                              },
                                              child: H1semi(
                                                maxLines: isShowMoreTitleClicked
                                                    ? 2000
                                                    : 2,
                                                text: '${provider.title}',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // details

                                    Container(
                                      height: 400.h,
                                      width: 1.sw,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            width: 2.w,
                                            color: ksecondaryColor2,
                                          ),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Details Text
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 17.h,
                                                // bottom: 10.h,
                                              ),
                                              child: H2semi(
                                                  text: Controller.getTag(
                                                      'details')),
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: provider
                                                      .detailsKey.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final key = provider
                                                        .detailsKey[index];
                                                    var value = provider
                                                        .detailsValue[index];
                                                    if (key == 'Kilometers') {
                                                      value = formatBid.format(
                                                          int.parse(
                                                              "${provider.detailsValue[index]}"));
                                                    }
                                                    return DetailsScreenDetailTile(
                                                      title: key,
                                                      property: value,
                                                    );
                                                  }),
                                            ),

                                            // show full details button

                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                        backgroundColor:
                                                            kbackgrounColor,
                                                        shape:
                                                            const BeveledRectangleBorder(),
                                                        context: context,
                                                        builder: (context) {
                                                          return Container(
                                                            color:
                                                                kbackgrounColor,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        25.w),
                                                            height: 0.95.sh,
                                                            width: 1.sw,
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      top: 10.h,
                                                                      bottom:
                                                                          10.h),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      const SizedBox
                                                                          .shrink(),
                                                                      H2Bold(
                                                                          text:
                                                                              Controller.getTag('details')),
                                                                      GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              const Icon(Icons.close))
                                                                    ],
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: ListView
                                                                      .builder(
                                                                          itemCount: provider
                                                                              .detailsKey
                                                                              .length,
                                                                          itemBuilder:
                                                                              (context, i) {
                                                                            var key1 =
                                                                                provider.detailsKey[i];
                                                                            var value1 =
                                                                                provider.detailsValue[i];
                                                                            if (key1 ==
                                                                                'Kilometers') {
                                                                              value1 = formatBid.format(int.parse("${provider.detailsValue[i]}"));
                                                                            }
                                                                            return DetailsScreenDetailTile(
                                                                              title: key1,
                                                                              property: value1,
                                                                            );
                                                                          }),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 5.h, bottom: 7.h),
                                                    child: H3semi(
                                                      text: Controller.getTag(
                                                          'show_more_details'),
                                                      color: kredText,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // descriptions

                                    if (provider.description.isNotEmpty)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 25.w),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              width: 2.w,
                                              color: ksecondaryColor2,
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 14.h,
                                                bottom: 13.h,
                                              ),
                                              child: H2semi(
                                                  text: Controller.getTag(
                                                      'Description')),
                                            ),
                                            SizedBox(
                                              height: 33.h,
                                              child: ParaRegular(
                                                text: '${provider.description}',
                                                maxLines: 500,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 10.h,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                        backgroundColor:
                                                            kbackgrounColor,
                                                        shape:
                                                            const BeveledRectangleBorder(),
                                                        context: context,
                                                        builder: (context) {
                                                          return Container(
                                                            color:
                                                                kbackgrounColor,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        25.w),
                                                            height: 0.95.sh,
                                                            width: 1.sw,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      top: 15.h,
                                                                      bottom:
                                                                          10.h),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      const SizedBox
                                                                          .shrink(),
                                                                      Expanded(
                                                                        child:
                                                                            H2Bold(
                                                                          text:
                                                                              Controller.getTag('Description'),
                                                                          maxLines:
                                                                              600,
                                                                        ),
                                                                      ),
                                                                      GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              const Icon(Icons.close))
                                                                    ],
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    child:
                                                                        H2Regular(
                                                                      text:
                                                                          '${provider.description}',
                                                                      maxLines:
                                                                          500,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 7.h),
                                                      child: H3semi(
                                                        text: Controller.getTag(
                                                            'show_full_description'),
                                                        color: kredText,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    // dealer details

                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 25.w,
                                      ),
                                      height: 125.h,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            width: 2.w,
                                            color: ksecondaryColor2,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 20.h),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                ParaRegular(
                                                    text: Controller.getTag(
                                                        'posted_by')),
                                                SizedBox(
                                                  height: 6.h,
                                                ),
                                                SizedBox(
                                                  width: 58.w,
                                                  child: Container(
                                                    clipBehavior: Clip.hardEdge,
                                                    height: 58.h,
                                                    width: 58.w,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.r),
                                                    ),
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          '${provider.createdBy['profilePicture']}',
                                                      placeholder: (c, b) =>
                                                          const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                        'assets/personErrorImage.png',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12.w,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 20.h, top: 40.h),
                                            child: SizedBox(
                                              // width: 184.w,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  H2semi(
                                                      text:
                                                          '${provider.createdBy['name']}'),
                                                  GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        DealerAllAds(
                                                                          name:
                                                                              '${provider.createdBy['name']}',
                                                                          picture:
                                                                              '${provider.createdBy['profilePicture']}',
                                                                          dealerId:
                                                                              '${provider.createdBy['_id']}',
                                                                        )));
                                                      },
                                                      child: ParaSemi(
                                                        text: Controller.getTag(
                                                            'view_all_ads'),
                                                        color: kprimaryColor,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Location

                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 25.w,
                                      ),
                                      height: 287.h,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            width: 2.w,
                                            color: ksecondaryColor2,
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 24.h),
                                            child: H2semi(
                                                text: Controller.getTag(
                                                    'location')),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              bottom: 24.h,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on_outlined,
                                                  color: ksecondaryColor2,
                                                  size: 17.sp,
                                                ),
                                                SizedBox(
                                                  width: 345.w,
                                                  child: ParaRegular(
                                                    maxLines: 1,
                                                    text:
                                                        '${provider.location}',
                                                    color: ksecondaryColor2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 169.h,
                                            width: 371.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 4.sp,
                                                  offset: const Offset(0.5, 1),
                                                  blurStyle: BlurStyle
                                                      .normal, // Shadow position
                                                ),
                                              ],
                                            ),
                                            child: GoogleMap(
                                              mapToolbarEnabled: false,
                                              compassEnabled: false,
                                              zoomControlsEnabled: false,
                                              zoomGesturesEnabled: false,
                                              mapType: MapType.terrain,
                                              markers: {
                                                Marker(
                                                  markerId: MarkerId("Sydney"),
                                                  position: LatLng(
                                                      provider.latitude,
                                                      provider.longitude),
                                                  infoWindow: InfoWindow(
                                                    title:
                                                        "${provider.location}",
                                                  ), // InfoWindow
                                                ),
                                              },
                                              onMapCreated: _onMapCreated,
                                              initialCameraPosition:
                                                  CameraPosition(
                                                target: LatLng(
                                                    provider.latitude,
                                                    provider.longitude),
                                                zoom: 15.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    //image
                                    Container(
                                      clipBehavior: Clip.hardEdge,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 25.w,
                                        vertical: 20.h,
                                      ),
                                      height: 290.h,
                                      width: 1.sw,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            width: 2.w,
                                            color: ksecondaryColor2,
                                          ),
                                        ),
                                      ),
                                      child: AdMobBanner(0.9.sw, 290.h),
                                    ),

                                    //Similar ads
                                    if (provider.similarAdsIds.isNotEmpty)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 25.w),
                                        width: 1.sw,
                                        height: 378.h,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              width: 2.w,
                                              color: ksecondaryColor2,
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            H2semi(
                                                text: Controller.getTag(
                                                    'similar_ads')),
                                            SizedBox(
                                              height: 295.h,
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: provider
                                                      .similarAds.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var formatBid =
                                                        NumberFormat(
                                                            "#,###,###");
                                                    // String adId = provider
                                                    String title = '';
                                                    String picture = '';
                                                    String price = '';

                                                    // distance travel is not required in the description screen just push a dumy value is will not be shown on the screen.

                                                    (provider.similarAds[index]
                                                            as List)
                                                        .forEach((e) {
                                                      if (e['name'] ==
                                                          'Title') {
                                                        title = Controller
                                                            .languageChange(
                                                                english:
                                                                    e['value'],
                                                                arabic: e[
                                                                    'value_ar']);
                                                      } else if (e['name']
                                                          .contains(
                                                              'Pictures')) {
                                                        picture = (e['value']
                                                                .toString()
                                                                .replaceAll(
                                                                    '[', "")
                                                                .replaceAll(
                                                                    "]", ""))
                                                            .split(',')[0];
                                                      } else if (e['name'] ==
                                                          'Price') {
                                                        price = formatBid
                                                            .format(int.parse(
                                                                "${provider.price}"));
                                                        ;
                                                      }
                                                    });

                                                    return Padding(
                                                      padding: EdgeInsets.only(
                                                        right: 10.w,
                                                      ),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      DetailsScreen(
                                                                          tag:
                                                                              '${provider.similarAdsIds[index]}',
                                                                          carId:
                                                                              '${provider.similarAdsIds[index]}')));
                                                        },
                                                        child: PopularCarCard(
                                                          showFavouriteButton:
                                                              false,
                                                          // adId: ,
                                                          carImage:
                                                              '${picture}',
                                                          title: '${title}',
                                                          price:
                                                              '${Controller.getTag('aed')} ${price}',
                                                          distanceTravel:
                                                              'distanceTravel',
                                                          isDistanceTravelRequired:
                                                              false,
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (Controller.getLogin()) {
                                                      if (provider.createdBy[
                                                              '_id'] !=
                                                          Controller
                                                              .getUserId()) {
                                                        if (context
                                                            .read<
                                                                GetUserProfile>()
                                                            .reportedAds
                                                            .contains(
                                                                widget.carId)) {
                                                          DisplayMessage(
                                                              context: context,
                                                              isTrue: false,
                                                              message: Controller
                                                                  .getTag(
                                                                      'already_reported_this_ad'));
                                                        } else {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ReportListing(
                                                                            adId:
                                                                                widget.carId,
                                                                          )));
                                                        }
                                                      } else {
                                                        DisplayMessage(
                                                            context: context,
                                                            isTrue: false,
                                                            message: Controller
                                                                .getTag(
                                                                    "you_can't_report_your_own_ad"));
                                                      }
                                                    } else {
                                                      DisplayMessage(
                                                          context: context,
                                                          isTrue: false,
                                                          message:
                                                              Controller.getTag(
                                                                  'login_to_continue'));
                                                      showModalBottomSheet(
                                                          shape:
                                                              const BeveledRectangleBorder(),
                                                          barrierColor:
                                                              kbackgrounColor,
                                                          backgroundColor:
                                                              kbackgrounColor,
                                                          isScrollControlled:
                                                              true,
                                                          context: context,
                                                          builder: (context) {
                                                            return LoginScreen(
                                                              data: const [
                                                                'detailScreen',
                                                                'reportAd',
                                                              ],
                                                            );
                                                          });
                                                    }
                                                  },
                                                  child: Controller
                                                                  .getLanguage()
                                                              .toString()
                                                              .toLowerCase() ==
                                                          'english'
                                                      ? Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 20.w,
                                                              height: 20.h,
                                                              child:
                                                                  Image.asset(
                                                                'assets/reportFlag.png',
                                                                fit: BoxFit
                                                                    .cover,
                                                                color:
                                                                    kredColor,
                                                              ),
                                                            ),
                                                            H3semi(
                                                              text:
                                                                  ' ${Controller.getTag('report_this_ad')}',
                                                              color: kredColor,
                                                            ),
                                                          ],
                                                        )
                                                      : Row(
                                                          children: [
                                                            H3semi(
                                                              text:
                                                                  ' ${Controller.getTag('report_this_ad')}',
                                                              color: kredColor,
                                                            ),
                                                            SizedBox(
                                                              width: 20.w,
                                                              height: 20.h,
                                                              child:
                                                                  Image.asset(
                                                                'assets/reportFlag.png',
                                                                fit: BoxFit
                                                                    .cover,
                                                                color:
                                                                    kredColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
        }),
      ),
      bottomNavigationBar: !context
              .select((GetCarDetails value) => value.isYours)
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 15.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ContactButtons(
                    buttonIcon: Transform.flip(
                      flipX:
                          Controller.getLanguage().toString().toLowerCase() ==
                                  'english'
                              ? false
                              : true,
                      child: SvgPicture.asset(
                        'assets/phone.svg',
                        color: kprimaryColor,
                      ),
                    ),
                    buttonText: Controller.getTag('call'),
                    onTap: () async {
                      if (Controller.getLogin()) {
                        if (!await launchUrl(
                          Uri.parse(
                              "tel:${context.read<GetCarDetails>().createdBy['phoneNumber']}"),
                          mode: LaunchMode.externalApplication,
                        )) {
                          throw Exception('Could not launch request.url');
                        }
                      } else {
                        DisplayMessage(
                            context: context,
                            isTrue: false,
                            message: Controller.getTag('login_to_continue'));
                        showModalBottomSheet(
                            shape: const BeveledRectangleBorder(),
                            barrierColor: kbackgrounColor,
                            backgroundColor: kbackgrounColor,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return LoginScreen(
                                data: [
                                  'detailScreen',
                                  'call',
                                  context
                                      .read<GetCarDetails>()
                                      .createdBy['phoneNumber']
                                ],
                              );
                            });
                      }
                    },
                  ),
                  ContactButtons(
                    buttonIcon: Transform.flip(
                      flipX:
                          Controller.getLanguage().toString().toLowerCase() ==
                                  'english'
                              ? false
                              : true,
                      child: SvgPicture.asset(
                        'assets/message.svg',
                        color: kprimaryColor,
                      ),
                    ),
                    buttonText: Controller.getTag('chat'),
                    onTap: () {
                      if (Controller.getLogin()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MessageScreen(
                                      adName:
                                          '${context.read<GetCarDetails>().title}',
                                      userName:
                                          '${context.read<GetCarDetails>().createdBy['name']}',
                                      refId:
                                          '${context.read<GetCarDetails>().adId}',
                                      toId:
                                          '${context.read<GetCarDetails>().createdBy['_id']}',
                                      price:
                                          '${context.read<GetCarDetails>().price}',
                                      location:
                                          '${context.read<GetCarDetails>().location}',
                                      imageUrl:
                                          '${context.read<GetCarDetails>().images[0]}',
                                      profileImage: '',
                                    )));
                      } else {
                        DisplayMessage(
                            context: context,
                            isTrue: false,
                            message: Controller.getTag('login_to_continue'));
                        showModalBottomSheet(
                            shape: const BeveledRectangleBorder(),
                            barrierColor: kbackgrounColor,
                            backgroundColor: kbackgrounColor,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return LoginScreen(
                                data: const [
                                  'detailScreen',
                                  'chat',
                                ],
                              );
                            });
                      }
                    },
                  ),
                  ContactButtons(
                    buttonIcon: Transform.flip(
                      flipX:
                          Controller.getLanguage().toString().toLowerCase() ==
                                  'english'
                              ? false
                              : true,
                      child: Image.asset(
                        'assets/whatsapp.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    buttonText: '',
                    onTap: () async {
                      if (Controller.getLogin()) {
                        if (Platform.isAndroid) {
                          // add the [https]
                          launchUrl(Uri.parse(
                              "https://wa.me/${context.read<GetCarDetails>().createdBy['phoneNumber']}/?text="));
                        } else {
                          // add the [https]
                          launchUrl(Uri.parse(
                              "https://wa.me/${context.read<GetCarDetails>().createdBy['phoneNumber']}/?text=")); // new line
                        }
                      } else {
                        DisplayMessage(
                            context: context,
                            isTrue: false,
                            message: Controller.getTag('login_to_continue'));
                        showModalBottomSheet(
                            shape: const BeveledRectangleBorder(),
                            barrierColor: kbackgrounColor,
                            backgroundColor: kbackgrounColor,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return LoginScreen(
                                data: const [
                                  'detailScreen',
                                  'chat',
                                ],
                              );
                            });
                      }
                    },
                  ),
                ],
              ),
            )
          : SizedBox(
              height: 20.h,
            ),
    );
  }
}
