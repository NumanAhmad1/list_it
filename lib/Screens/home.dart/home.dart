import 'dart:math';

import 'package:intl/intl.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/favourite.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/getUserProfile.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/getCategory.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/getCategoryListing.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/homeScreenData.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/myNotificationData.dart';
import 'package:lisit_mobile_app/Controller/controller.dart';
import 'package:lisit_mobile_app/Controller/notification_services.dart';
import 'package:lisit_mobile_app/Screens/AuthScreens/loginScreen/loginScreen.dart';
import 'package:lisit_mobile_app/Screens/verifyNumber/enterNumber.dart';
import 'package:lisit_mobile_app/Screens/verifyNumber/finalMessage.dart';
import 'package:lisit_mobile_app/widgets/noData.dart';
import 'package:lisit_mobile_app/widgets/noInternet.dart';
import 'package:lisit_mobile_app/widgets/popularCarCard.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

import '../detailsScreen/detailsScreen.dart';
import '../notification/notificationScreen.dart';
import '../search/searchedItemsScreen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
      Controller.getisUserVerified();
    });
    // TODO: implement initState
    super.initState();
  }

  var notificationServices = NotificationServices();

  Future getData() async {
    if (!context.mounted) return;
    await context.read<HomeScreenData>().getHomeData(context);
    if (!context.mounted) return;

    await context.read<Favourite>().getFavouriteList(null, context);
    print('this is fav id: ${context.read<Favourite>().favouriteIdList}');
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();

    await context.read<MyNotificationData>().getMyNotification(context);
    if (Controller.getLogin() != true) {
      context.read<Favourite>().favouriteIdList.clear();
      context.read<Favourite>().favouriteDataList.clear();
      context.read<Favourite>().favouriteList.clear();
    }
  }

  rebuild() {
    setState(() {});
  }

  bool searchValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: kbackgrounColor,
        backgroundColor: kbackgrounColor,
        title: SizedBox(
            // width: 90.w,
            height: 35.h,
            child: Image.asset(
              'assets/logo.png',
            )),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: RefreshIndicator(
          color: kprimaryColor,
          onRefresh: () async {
            await getData();
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 8.h),
            child:
                Consumer<HomeScreenData>(builder: (context, mainValue, child) {
              return Column(
                children: [
                  // SizedBox(
                  //   height: 70.h,
                  // ),
                  // search field and icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // search field

                      SizedBox(
                        width: 326.w,
                        height: 74.h,
                        child: TextField(
                          controller: searchController,
                          onChanged: (v) {
                            if (v.trim().toString().isEmpty) {
                              searchValue = false;
                            } else {
                              searchValue = true;
                            }
                            setState(() {});
                          },
                          onSubmitted: (value) {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchItemsScreen(
                                              categoryTitle: '',
                                              searchedItem:
                                                  '${searchController.text.trim().toString()}',
                                            )))
                                .whenComplete(() => searchController.clear());
                          },
                          decoration: InputDecoration(
                            hintText: Controller.getTag('search_listit'),
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: Controller.getLanguage()
                                          .toString()
                                          .toLowerCase() ==
                                      "english"
                                  ? GoogleFonts.montserrat().fontFamily
                                  : GoogleFonts.notoKufiArabic().fontFamily,
                              fontWeight: FontWeight.w400,
                              color: khelperTextColor,
                            ),
                            suffixIcon: searchValue
                                ? GestureDetector(
                                    onTap: () {
                                      searchController.clear();
                                      searchValue = false;
                                      setState(() {});
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: khelperTextColor,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            prefixIcon: Icon(
                              Icons.search,
                              color: khelperTextColor,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: ksearchFieldColor,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide.none,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),

                      // notification icon

                      GestureDetector(
                        onTap: () async {
                          bool isTokenTrue = await context
                              .read<GetCategory>()
                              .checkToken(context);

                          if (isTokenTrue) {
                            if (!context.mounted) return;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NotificationScreen(),
                              ),
                            );
                          } else {
                            if (!context.mounted) return;
                            DisplayMessage(
                                context: context,
                                isTrue: false,
                                message:
                                    Controller.getTag('login_to_continue'));
                            showModalBottomSheet(
                                shape: const BeveledRectangleBorder(),
                                barrierColor: kbackgrounColor,
                                backgroundColor: kbackgrounColor,
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return LoginScreen();
                                });
                          }
                        },
                        child: SizedBox(
                          child: Stack(
                            alignment: Alignment.topRight,
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  bool isTokenTrue = await context
                                      .read<GetCategory>()
                                      .checkToken(context);

                                  if (isTokenTrue) {
                                    if (!context.mounted) return;

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NotificationScreen(),
                                      ),
                                    );
                                  } else {
                                    if (!context.mounted) return;
                                    DisplayMessage(
                                        context: context,
                                        isTrue: false,
                                        message: Controller.getTag(
                                            'login_to_continue'));
                                    showModalBottomSheet(
                                        shape: const BeveledRectangleBorder(),
                                        barrierColor: kbackgrounColor,
                                        backgroundColor: kbackgrounColor,
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) {
                                          return LoginScreen();
                                        });
                                  }
                                },
                                child: Icon(
                                  Icons.notifications_none,
                                  size: 35.w,
                                ),
                              ),
                              if (context.select((MyNotificationData value) =>
                                  value.notificationsDataList.any(
                                      (element) => element['IsRead'] == false)))
                                Positioned(
                                  top: 5.h,
                                  right: 1.w,
                                  child: Container(
                                    height: 16.67.h,
                                    width: 16.67.w,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kprimaryColor,
                                        border: Border.all(
                                          width: 2.w,
                                          color: kbackgrounColor,
                                        )),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  //verify your number

                  SizedBox(
                    height: 20.h,
                  ),
                  if ((Controller.getLogin() ?? false))
                    if (!(Controller.getisUserVerified() ?? false))
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => EnterNumber(
                                    callback: rebuild,
                                  ));
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20.h),
                          clipBehavior: Clip.hardEdge,
                          height: 130.h,
                          width: 369.w,
                          decoration: BoxDecoration(
                            color: kbackgrounColor,
                            borderRadius: BorderRadius.circular(6.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4.sp,
                                offset: const Offset(0.5, 1),
                                blurStyle: BlurStyle.normal, // Shadow position
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // icon image
                              Container(
                                width: 89.w,
                                height: 130.h,
                                decoration: ShapeDecoration(
                                  color: kprimaryColor2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(6.r),
                                      bottomLeft: Radius.circular(6.r),
                                    ),
                                  ),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Stack(children: [
                                    SvgPicture.asset(
                                      'assets/verifyMobileNumber.svg',
                                      width: 24.w,
                                      height: 24.h,
                                    ),
                                  ]),
                                ),
                              ),
                              Container(
                                width: 280.w,
                                decoration: BoxDecoration(
                                  color: kbackgrounColor,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(6.r),
                                    topRight: Radius.circular(6.r),
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      H3semi(
                                          text: Controller.getTag(
                                              'verify_mobile_number')),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 211.w,
                                            child: ParaRegular(
                                                text: Controller.getTag(
                                                    'verify_number_before_ad')),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 30.sp,
                                          ),
                                        ],
                                      ),
                                      ParaSemi(
                                        text: Controller.getTag('get_started'),
                                        color: kprimaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                  // recently looked car
                  if (context.select((HomeScreenData value) =>
                      value.recentlyLookedAt.isNotEmpty))
                    GestureDetector(
                      onTap: () {
                        // print(context.read<HomeScreenData>().recentlyLookedAt);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchItemsScreen(
                                      categoryTitle: context
                                          .read<HomeScreenData>()
                                          .recentlyLookedAt,
                                    )));
                      },
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        width: 369.w,
                        height: 61.h,
                        margin: EdgeInsets.only(bottom: 10.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                          color: kbackgrounColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4.sp,
                              offset: const Offset(0.5, 1),
                              blurStyle: BlurStyle.normal, // Shadow position
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // icon image
                            Container(
                              width: 89.w,
                              height: 61.h,
                              decoration: ShapeDecoration(
                                color: kprimaryColor2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6.r),
                                    bottomLeft: Radius.circular(6.r),
                                  ),
                                ),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                child: Stack(children: [
                                  SvgPicture.asset(
                                    'assets/homeScreenCarLogo.svg',
                                    width: 24.w,
                                    height: 24.h,
                                  ),
                                ]),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              width: 280.w,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      H3semi(
                                          text: Controller.getTag(
                                              'your_saved_searches')),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 30.sp,
                                      ),
                                    ],
                                  ),
                                  // ParaRegular(text: 'Motor > Cars'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // popular cars text
                  mainValue.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : mainValue.error.isNotEmpty
                          ? mainValue.error == 'No Internet Connection'
                              ? const NoInternet()
                              : Center(
                                  child: H2Bold(
                                  text: "${mainValue.error}",
                                  maxLines: 9,
                                ))
                          : mainValue.categoryNameList.isEmpty
                              ? const NoData()
                              : SizedBox(
                                  height:
                                      360.h * mainValue.categoryNameList.length,
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        mainValue.categoryNameList.length,
                                    itemBuilder: (context, mainIndex) {
                                      var formatBid = NumberFormat("#,###,###");
                                      List<Widget> itemsList = [];

                                      for (int i = 0;
                                          i <
                                              mainValue
                                                  .categoryDataList[mainIndex]
                                                  .length;
                                          i++) {
                                        String id = mainValue
                                                .categoryDataList[mainIndex][i]
                                            ['_id'];
                                        String createdById = mainValue
                                                .categoryDataList[mainIndex][i]
                                            ['created_by'][0]['_id'];

                                        String title = '';
                                        String picture = '';
                                        String price = '';
                                        String year = '';
                                        String distance = '';

                                        (mainValue.categoryDataList[mainIndex]
                                                [i]['data'] as List)
                                            .forEach((e) {
                                          if (e['name'] == 'Title') {
                                            title = Controller.languageChange(
                                                english: e['value'],
                                                arabic: e['value_ar']);
                                          } else if (e['name']
                                              .contains('Pictures')) {
                                            picture =
                                                (Controller.languageChange(
                                                        english: e['value'],
                                                        arabic: e['value_ar']))
                                                    .split(',')[0];
                                          } else if (e['name'] == 'Year') {
                                            year = Controller.languageChange(
                                                english: e['value'],
                                                arabic: e['value_ar']);
                                          } else if (e['name'] ==
                                                  'Kilometers' ||
                                              e['name'] == 'Milage') {
                                            distance =
                                                Controller.languageChange(
                                                    english: e['value'],
                                                    arabic: e['value_ar']);
                                          } else if (e['name'] == 'Price') {
                                            price = formatBid.format(int.parse(
                                                "${Controller.languageChange(english: e['value'], arabic: e['value_ar'])}"));
                                            ;
                                          }
                                        });

                                        itemsList.add(Padding(
                                          padding: EdgeInsets.only(
                                            right: 16.w,
                                          ),
                                          child: Hero(
                                            tag:
                                                'popularCar${Random().nextInt(1000) / i}',
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailsScreen(
                                                      carId: id,
                                                      tag: 'popularCar$i',
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: PopularCarCard(
                                                createdById: createdById,
                                                showFavouriteButton: true,
                                                adId: id,
                                                carImage: '${picture}',
                                                title: '${title}',
                                                price:
                                                    '${Controller.getTag('aed')} ${price}',
                                                distanceTravel:
                                                    '${year} . ${distance} km',
                                                isDistanceTravelRequired: true,
                                              ),
                                            ),
                                          ),
                                        ));
                                      }
                                      return Column(
                                        mainAxisSize: MainAxisSize
                                            .min, // Set mainAxisSize to MainAxisSize.min
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SearchItemsScreen(
                                                    categoryTitle:
                                                        '${mainValue.categoryNameList[mainIndex].toString().split('|')[0]}',
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                H2Bold(
                                                    text:
                                                        '${Controller.getTag('popular_in')} ${Controller.languageChange(english: mainValue.categoryNameList[mainIndex].toString().split('|')[0], arabic: mainValue.categoryNameList[mainIndex].toString().split('|')[1])}'),
                                                Icon(
                                                  Icons.arrow_forward_rounded,
                                                  size: 30.sp,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 16.h,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 20.h),
                                            child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children: itemsList,
                                                )),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
