import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';
import 'package:lisit_mobile_app/widgets/popularCarCard.dart';

import '../../Controller/Providers/data/homeScreenData.dart';
import '../search/searchedItemsScreen.dart';

class HomeScreen1 extends StatefulWidget {
  const HomeScreen1({super.key});

  @override
  State<HomeScreen1> createState() => _HomeScreen1State();
}

class _HomeScreen1State extends State<HomeScreen1> {
  TextEditingController searchController = TextEditingController();
  bool searchValue = false;

  getHomeData() async {
    await context.read<HomeScreenData1>().getHomeData(context);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getHomeData();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: kbackgrounColor,
        backgroundColor: kbackgrounColor,
        centerTitle: true,
        title: SizedBox(
            // width: 90.w,
            height: 35.h,
            child: Image.asset(
              'assets/logo.png',
            )),
      ),
      body: ListView(
        children: [
          ///home screen image
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 220.h,
                width: 1.sw,
                child: Image.asset(
                  'assets/homeScreen.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 0.85.sw,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    H1Bold(
                      text: 'UAE’s Trusted Marketplace',
                      color: kbackgrounColor,
                    ),
                    Row(
                      children: [
                        H2Bold(
                          text: 'Search',
                          color: kbackgrounColor,
                        ),
                      ],
                    ),
                    // search field

                    Container(
                      padding: EdgeInsets.all(10.w),
                      height: 80.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: ksecondaryColor.withOpacity(0.5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 0.6.sw,
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
                                            ))).whenComplete(
                                    () => searchController.clear());
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
                          SizedBox(
                            width: 10.w,
                          ),
                          SizedBox(
                              width: 70.w,
                              height: 50.h,
                              child: MainButton(
                                  text: 'Search',
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SearchItemsScreen(
                                                  categoryTitle: '',
                                                  searchedItem:
                                                      '${searchController.text.trim().toString()}',
                                                ))).whenComplete(
                                        () => searchController.clear());
                                  })),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
            child: H2Bold(
              text: 'Let us help you find what you are looking for!',
              maxLines: 2,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      ksecondaryColor, // Set your desired background color
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r), // button's shape
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      color: kprimaryColor,
                    ),
                    SizedBox(
                      height: 35.h,
                      child: VerticalDivider(
                        thickness: 2,
                        color: kprimaryColor,
                      ),
                    ),
                    H3Bold(
                      text: 'I want to buy',
                      color: kbackgrounColor,
                    )
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      ksecondaryColor, // Set your desired background color
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r), // button's shape
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                        height: 24.h,
                        width: 24.w,
                        child: Image.asset('assets/flageIcon.png')),
                    SizedBox(
                      height: 35.h,
                      child: VerticalDivider(
                        thickness: 2,
                        color: kprimaryColor,
                      ),
                    ),
                    H3Bold(
                      text: 'I want to sell',
                      color: kbackgrounColor,
                    )
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            child: H2Regular(text: 'Browse By Category'),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    height: 80.h,
                    width: 120.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Image.asset(
                      'assets/catCar.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  H2Bold(
                    text: 'Cars',
                    color: kbackgrounColor,
                  )
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    height: 80.h,
                    width: 120.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Image.asset(
                      'assets/carBike.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  H2Bold(
                    text: 'Bikes',
                    color: kbackgrounColor,
                  )
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    height: 80.h,
                    width: 120.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Image.asset(
                      'assets/catHeavyVehcle.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  H2Bold(
                    text: 'Heavy Vehicles',
                    color: kbackgrounColor,
                  )
                ],
              ),
            ],
          ),

          /// Featured listing
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: DottedBorder(
              color: kprimaryColor,
              radius: Radius.circular(10.r),
              strokeWidth: 3.w,
              dashPattern: const [8, 2],
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Column(
                  children: [
                    H2Bold(text: 'Featured Listings'),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Consumer<HomeScreenData1>(
                          builder: (context, homeValue, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ...List.generate(homeValue.categoriesList.length,
                                (i) {
                              return InkWell(
                                onTap: () {
                                  homeValue.generateAdsList(
                                      homeValue.categoriesList[i]['_id']);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 10.w),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5.h, horizontal: 10.w),
                                  decoration: BoxDecoration(
                                      color: homeValue.categoriesList[i]
                                                  ['_id'] ==
                                              homeValue.selectedCategoryName
                                          ? kprimaryColor
                                          : null,
                                      borderRadius: BorderRadius.circular(20.r),
                                      border: Border.all(color: kprimaryColor)),
                                  child: ParaRegular(
                                      color: homeValue.categoriesList[i]
                                                  ['_id'] ==
                                              homeValue.selectedCategoryName
                                          ? kbackgrounColor
                                          : null,
                                      text: homeValue.categoriesList[i]['_id']),
                                ),
                              );
                            }),
                          ],
                        );
                      }),
                    ),
                    SizedBox(
                      height: 275.h,
                      child: Consumer<HomeScreenData1>(
                          builder: (context, homeValue, child) {
                        return homeValue.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  ...List.generate(homeValue.adsList.length,
                                      (i) {
                                    String title = '';
                                    String image = '';
                                    String price = '';
                                    String distance = '';
                                    for (var j = 0;
                                        j < homeValue.adsList.length;
                                        j++) {
                                      final data1 =
                                          homeValue.adsList[j]['data'];
                                      for (var i = 0; i < data1.length; i++) {
                                        final data = data1[i];
                                        if (data['name']
                                                .toString()
                                                .toLowerCase() ==
                                            'title') {
                                          title = Controller.languageChange(
                                              english: data['value'],
                                              arabic: data['value_ar']);

                                          print('/////////////////////////');
                                          print('$title');
                                          continue;
                                        }
                                        if (data['name']
                                                .toString()
                                                .toLowerCase() ==
                                            'price') {
                                          price = Controller.languageChange(
                                              english: data['value'],
                                              arabic: data['value_ar']);
                                          print('$price');
                                          continue;
                                        }
                                        if (data['name']
                                                .toString()
                                                .toLowerCase() ==
                                            'add pictures') {
                                          image = data['value']
                                              .toString()
                                              .split(',')[0];
                                          continue;
                                        }
                                        if (data['name']
                                                    .toString()
                                                    .toLowerCase() ==
                                                'milage' ||
                                            data['name']
                                                    .toString()
                                                    .toLowerCase() ==
                                                'kilometers') {
                                          distance = Controller.languageChange(
                                              english: data['value'],
                                              arabic: data['value_ar']);
                                          continue;
                                        }
                                      }
                                    }
                                    return Padding(
                                      padding: EdgeInsets.only(left: 5.w),
                                      child: PopularCarCard(
                                          carImage: image,
                                          showFavouriteButton: false,
                                          title: title,
                                          price:
                                              '${Controller.getTag('aed')} ${price}',
                                          distanceTravel:
                                              '${distance} . ${distance} km',
                                          isDistanceTravelRequired: true),
                                    );
                                  }),
                                ],
                              );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: H2Bold(text: 'Browse by Brand'),
              ),
            ],
          ),

          Consumer<HomeScreenData1>(builder: (context, homeValue, child) {
            return SizedBox(
              height: 130.h,
              child: CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 10 / 4,
                  viewportFraction: 0.4,
                  enlargeFactor: 0.4,
                  enlargeCenterPage: true,
                  height: 400.0,
                ),
                items: List.generate(homeValue.featuredBrands.length, (index) {
                  final imageUrl = homeValue.featuredBrands[index]['Picture'];
                  return SvgPicture.network(
                    imageUrl,
                    placeholderBuilder: (context) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    // Check for presence of filter element (basic detection)
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }
}
