import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/favourite.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/getCategoryListing.dart';
import 'package:lisit_mobile_app/Screens/AuthScreens/loginScreen/loginScreen.dart';
import 'package:lisit_mobile_app/Screens/detailsScreen/detailsScreen.dart';
import 'package:lisit_mobile_app/Screens/filters/filterValues.dart';
import 'package:lisit_mobile_app/Screens/filters/filtersScreen.dart';
import 'package:lisit_mobile_app/Screens/search/savedSearch/widget/noSearchResultFound.dart';
import 'package:lisit_mobile_app/Screens/search/savedSearch/widget/savesearchValue.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';
import 'package:lisit_mobile_app/widgets/AdMob/AdMobBanner.dart';
import 'package:url_launcher/url_launcher.dart';

import '../detailsScreen/widget/contactButton.dart';

class SearchItemsScreen extends StatefulWidget {
  var categoryTitle;
  String? searchedItem;
  SearchItemsScreen(
      {super.key, this.searchedItem, required this.categoryTitle});

  @override
  State<SearchItemsScreen> createState() => _SearchItemsScreenState();
}

class _SearchItemsScreenState extends State<SearchItemsScreen> {
  final List<String> sortList = [
    Controller.getTag('new_to_old'),
    Controller.getTag('old_to_new'),
    Controller.getTag('high_to_low'),
    Controller.getTag('low_to_high'),
  ];

  @override
  void initState() {
    context.read<GetCategoryListing>().page = 1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FilterValues>().results['Category'] = widget.categoryTitle;
      if (widget.searchedItem == null) {
        getData();
        log('Api is called ');
        print(widget.searchedItem);
      } else {
        getSearchData();
        print(widget.searchedItem);
        log('searched item is null');
      }
    });

    super.initState();
  }

  getData() async {
    if (widget.categoryTitle is String) {
      context
          .read<GetCategoryListing>()
          .convertSearchToSave(searchMap: {'Category': widget.categoryTitle});
      await context.read<GetCategoryListing>().getCategoryListing(context,
          parametersMap: {'Category': widget.categoryTitle});
    } else {
      context
          .read<GetCategoryListing>()
          .convertSearchToSave(searchMap: widget.categoryTitle);
      await context
          .read<GetCategoryListing>()
          .getCategoryListing(context, parametersMap: widget.categoryTitle);
    }
  }

  getSearchData() async {
    context
        .read<GetCategoryListing>()
        .convertSearchToSave(searchMap: {'Title': '%${widget.searchedItem}'});
    await context.read<GetCategoryListing>().getCategoryListing(context,
        parametersMap: {'Title': '%${widget.searchedItem}'});
  }

  loadData(bool? isFromSort) async {
    if (widget.categoryTitle is String) {
      context
          .read<GetCategoryListing>()
          .convertSearchToSave(searchMap: {'Category': widget.categoryTitle});
      await context.read<GetCategoryListing>().loadMore(context, isFromSort,
          parametersMap: {'Category': widget.categoryTitle});
    } else {
      context
          .read<GetCategoryListing>()
          .convertSearchToSave(searchMap: widget.categoryTitle);
      await context
          .read<GetCategoryListing>()
          .loadMore(context, isFromSort, parametersMap: widget.categoryTitle);
    }
  }

  loadSearchData(bool? isFromSort) async {
    context
        .read<GetCategoryListing>()
        .convertSearchToSave(searchMap: {'Title': '%${widget.searchedItem}'});
    await context.read<GetCategoryListing>().loadMore(context, isFromSort,
        parametersMap: {'Title': '%${widget.searchedItem}'});
  }

  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    log('this is searched Item: ${widget.categoryTitle}');
    log('this is modified searched value: ${context.read<GetCategoryListing>().searchedValue}');
    return WillPopScope(
      onWillPop: () async {
        if (context.read<GetCategoryListing>().data.isNotEmpty) {
          log('list is cleared');
          context.read<GetCategoryListing>().data.clear();
          context.read<GetCategoryListing>().removeFilter();
          return true;
        } else {
          context.read<GetCategoryListing>().removeFilter();

          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: H2Bold(text: Controller.getTag('search')),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
          ),
          child: Column(
            children: [
              //filter
              Container(
                margin: EdgeInsets.symmetric(vertical: 25.h),
                height: 30.h,
                width: 1.sw,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: kbackgrounColor,
                            shape: const BeveledRectangleBorder(),
                            context: context,
                            builder: (context) {
                              return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: SaveSearchValue());
                            });
                      },
                      child: SizedBox(
                        child: Row(
                          children: [
                            Icon(
                              Icons.bookmark_border_outlined,
                              color: ksecondaryColor2,
                            ),
                            H2semi(
                              text: ' ${Controller.getTag('save')}',
                              color: ksecondaryColor2,
                            )
                          ],
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: ksecondaryColor2,
                      thickness: 2.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FiltersScreen()));
                      },
                      child: SizedBox(
                        child: Row(
                          children: [
                            SizedBox(
                              height: 24.h,
                              width: 24.w,
                              child: Image.asset(
                                'assets/filterImage.png',
                                fit: BoxFit.cover,
                                color: context.select(
                                    (GetCategoryListing value) =>
                                        value.isFilterApplied
                                            ? kprimaryColor
                                            : ksecondaryColor2),
                              ),
                            ),
                            H2semi(
                              text: ' ${Controller.getTag('filter')}',
                              color: context.select(
                                  (GetCategoryListing value) =>
                                      value.isFilterApplied
                                          ? kprimaryColor
                                          : ksecondaryColor2),
                            )
                          ],
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: ksecondaryColor2,
                      thickness: 2.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                padding: EdgeInsets.only(
                                  left: 30.w,
                                  top: 20.h,
                                  bottom: 20.h,
                                  right: 30.w,
                                ),
                                color: kbackgrounColor,
                                width: 1.sw,
                                height: 410.h,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20.h),
                                      child: H2semi(
                                          text: Controller.getTag('sort')),
                                    ),
                                    SizedBox(
                                      height: 301.h,
                                      child: ListView.builder(
                                          itemCount: sortList.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () async {
                                                context
                                                    .read<GetCategoryListing>()
                                                    .changeSortSelectionIndex(
                                                        index: index);
                                                context
                                                        .read<FilterValues>()
                                                        .results['Category'] =
                                                    widget.categoryTitle;
                                                if (widget.searchedItem ==
                                                    null) {
                                                  loadData(true);
                                                  log('Api is called ');
                                                  print(widget.searchedItem);
                                                } else {
                                                  loadSearchData(true);
                                                  print(widget.searchedItem);
                                                  log('searched item is null');
                                                }
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                height: 58.22.h,
                                                // margin: EdgeInsets.only(
                                                //     right: 24.w),
                                                decoration: BoxDecoration(
                                                  color: kbackgrounColor,
                                                  border: Border(
                                                    top: BorderSide(
                                                        color: khelperTextColor
                                                            .withOpacity(0.3)),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    H3semi(
                                                      text: sortList[index],
                                                      color: ksecondaryColor2,
                                                    ),
                                                    if (index ==
                                                        Provider.of<GetCategoryListing>(
                                                                context)
                                                            .sortSelectionIndex)
                                                      Icon(
                                                        Icons.check,
                                                        color: kprimaryColor,
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      child: SizedBox(
                        child: Row(
                          children: [
                            SizedBox(
                              height: 24.h,
                              width: 24.w,
                              child: Image.asset(
                                'assets/sortImage.png',
                                fit: BoxFit.cover,
                                color: ksecondaryColor2,
                              ),
                            ),
                            H2semi(
                              text: ' ${Controller.getTag('sort')}',
                              color: ksecondaryColor2,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox.shrink(),
                  ],
                ),
              ),

              // google ad

              Padding(
                padding: EdgeInsets.only(bottom: 15.h),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: AdMobBanner(0.9.sw, 143.h),

                  // SizedBox(
                  //   height: 143.h,
                  //   width: 1.sw,
                  //   child: Image.asset(
                  //     'assets/googleAdImage.png',
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                ),
              ),

              // searched Item

              Consumer<GetCategoryListing>(builder: (context, value, child) {
                return Expanded(
                  child: value.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : value.data.isEmpty
                          ? const Center(
                              child: NoSearchResultFound(),
                            )
                          : RefreshIndicator(
                              color: kprimaryColor,
                              onRefresh: () async {
                                context
                                    .read<FilterValues>()
                                    .results['Category'] = widget.categoryTitle;
                                if (widget.searchedItem == null) {
                                  getData();
                                  log('Api is called ');
                                  print(widget.searchedItem);
                                } else {
                                  getSearchData();
                                  print(widget.searchedItem);
                                  log('searched item is null');
                                }
                              },
                              child: ListView.builder(
                                controller: _controller
                                  ..addListener(() async {
                                    try {
                                      if (_controller.position.pixels >
                                          _controller.position.maxScrollExtent -
                                              89.h) {
                                        if (value.totalRecord >
                                            value.data.length) {
                                          if (value.isLoadMore == false) {
                                            log('${value.data.length}');
                                            log('${value.totalRecord}');

                                            log('data');

                                            context
                                                    .read<FilterValues>()
                                                    .results['Category'] =
                                                widget.categoryTitle;
                                            if (widget.searchedItem == null) {
                                              loadData(false);
                                              log('Api is called ');
                                              print(widget.searchedItem);
                                            } else {
                                              loadSearchData(false);
                                              print(widget.searchedItem);
                                              log('searched item is null');
                                            }
                                          }
                                        }
                                      }
                                    } catch (e) {
                                      print('Error: $e');
                                    }
                                  }),
                                itemCount: value.data.length,
                                itemBuilder: (context, index) {
                                  String price = '';
                                  String title = '';
                                  String year = '';
                                  String milleage = '';
                                  String location = '';
                                  String picture = '';
                                  String brandName = '';
                                  String date = value.data[index]['created_at'];
                                  String id = value.data[index]['_id'];
                                  String createdbyId =
                                      (value.data[index]['created_by'] as List)
                                              .isNotEmpty
                                          ? value.data[index]['created_by'][0]
                                              ['_id']
                                          : '';
                                  String phoneNumber = '';

                                  (value.data[index]['data'] as List)
                                      .forEach((e) {
                                    if (e['name'].contains('Pictures')) {
                                      picture = e['value']
                                          .toString()
                                          .replaceAll("]", "")
                                          .replaceAll("[", "");
                                    } else if (e['name'] == 'Title') {
                                      title = Controller.languageChange(
                                          english: e['value'],
                                          arabic: e['value_ar']);
                                    } else if (e['name'] == 'Year') {
                                      year = e['value'].toString();
                                    } else if (e['name'] == 'Kilometers') {
                                      milleage = e['value'].toString();
                                    } else if (e['name'].contains('Location')) {
                                      location = e['value'];
                                    } else if (e['name'] == 'Price') {
                                      price = e['value'].toString();
                                    } else if (e['name'] == 'Make') {
                                      brandName = Controller.languageChange(
                                          english: e['value'],
                                          arabic: e['value_ar']);
                                    } else if (e['name'] == 'Phone Number') {
                                      phoneNumber = e['value'].toString();
                                    }
                                  });

                                  // final data = value.categoryListing[index];
                                  List<Widget> images = [];

                                  images = picture
                                      .split(',')
                                      .map(
                                        (e) => CachedNetworkImage(
                                          imageUrl: e,
                                          fit: BoxFit.cover,
                                          width: 366.w,
                                          height: 178.h,
                                          placeholder: (context, error) =>
                                              const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  "assets/placeholderImage.png"),
                                        ),
                                      )
                                      .toList();
                                  // bool isFavourite = context.read<Favourite>().isAddedToFavourite;
                                  return Builder(builder: (context) {
                                    bool isFavourite = context.select(
                                        (Favourite isFav) =>
                                            isFav.favouriteIdList.contains(id));
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 15.h),
                                      width: 394.w,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        color: kbackgrounColor,
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
                                      child: Column(
                                        children: [
                                          // main ad card
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailsScreen(
                                                            tag:
                                                                'popularCar${index}',
                                                            carId: id,
                                                          )));
                                            },
                                            child: Container(
                                              clipBehavior: Clip.hardEdge,
                                              height: 355.h,
                                              width: 367.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  //image
                                                  Stack(
                                                    alignment:
                                                        Alignment.topRight,
                                                    children: [
                                                      Container(
                                                        clipBehavior:
                                                            Clip.hardEdge,
                                                        width: 366.w,
                                                        height: 178.h,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r),
                                                        ),
                                                        child: CarouselSlider(
                                                          items: images,
                                                          options:
                                                              CarouselOptions(
                                                            viewportFraction: 1,
                                                            enlargeCenterPage:
                                                                true,
                                                            enableInfiniteScroll:
                                                                true,
                                                          ),
                                                        ),
                                                      ),
                                                      if (createdbyId !=
                                                          Controller
                                                              .getUserId())
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (Controller
                                                                .getLogin()) {
                                                              await context
                                                                  .read<
                                                                      Favourite>()
                                                                  .addToFavourite(
                                                                    context,
                                                                    addId: id,
                                                                  );
                                                            } else {
                                                              DisplayMessage(
                                                                  context:
                                                                      context,
                                                                  isTrue: false,
                                                                  message: Controller
                                                                      .getTag(
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
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return LoginScreen(
                                                                      data: [
                                                                        'searchedItemScreen',
                                                                        'favourite',
                                                                        id
                                                                      ],
                                                                    );
                                                                  });
                                                            }
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        13.w,
                                                                    vertical:
                                                                        15.h),
                                                            height: 28.h,
                                                            width: 28.w,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: khelperTextColor
                                                                  .withOpacity(
                                                                      0.7),
                                                            ),
                                                            child: Icon(
                                                              Icons.favorite,
                                                              size: 16.sp,
                                                              color: isFavourite
                                                                  ? kredColor
                                                                  : kprimaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 173.h,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width: 270.w,
                                                              child: H2semi(
                                                                maxLines: 2,
                                                                text:
                                                                    '${Controller.getTag('aed')} ${price}',
                                                                color: kredText,
                                                              ),
                                                            ),
                                                            ParaRegular(
                                                              text:
                                                                  '${Controller.formatDateTime(date)}',
                                                            )
                                                          ],
                                                        ),
                                                        H3semi(
                                                            text: '${title}'),
                                                        ParaRegular(
                                                            text:
                                                                '${Controller.getTag('brand')} ${brandName}'),
                                                        Row(
                                                          children: [
                                                            ParaRegular(
                                                                text:
                                                                    '${Controller.getTag('year')}: ${year}'),
                                                            SizedBox(
                                                              width: 10.w,
                                                            ),
                                                            ParaRegular(
                                                                text:
                                                                    '${Controller.getTag('mileage')}: ${milleage}'),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .location_on_outlined,
                                                              color:
                                                                  khelperTextColor,
                                                            ),
                                                            SizedBox(
                                                              width: 10.w,
                                                            ),
                                                            SizedBox(
                                                              width: 280.w,
                                                              child:
                                                                  ParaRegular(
                                                                text:
                                                                    '${location.toString().split("_")[0].toString()}',
                                                                maxLines: 2,
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

                                          //horizintal divider

                                          SizedBox(
                                            width: 366.w,
                                            child: Divider(
                                              color: ksecondaryColor,
                                            ),
                                          ),

                                          // call button

                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          3.r),
                                                  child: SizedBox(
                                                    height: 40.h,
                                                    width: 40.h,
                                                    child: Image.asset(
                                                      'assets/searchedItemBottomImage.png',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 8.h),
                                                  child: SizedBox(
                                                    height: 40.h,
                                                    width: 99.w,
                                                    child: ContactButtons(
                                                      buttonIcon:
                                                          SvgPicture.asset(
                                                        'assets/phone.svg',
                                                        color: kprimaryColor,
                                                      ),
                                                      buttonText:
                                                          Controller.getTag(
                                                              'call'),
                                                      onTap: () async {
                                                        if (!await launchUrl(
                                                          Uri.parse(
                                                              "tel:${phoneNumber}"),
                                                          mode: LaunchMode
                                                              .externalApplication,
                                                        )) {
                                                          throw Exception(
                                                              'Could not launch request.url');
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                                },
                              ),
                            ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
