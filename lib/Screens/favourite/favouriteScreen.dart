import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/favourite.dart';
import 'package:lisit_mobile_app/Screens/detailsScreen/detailsScreen.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

import 'widget/dialogeForDeleteFavourite.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
    getData();
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    await context.read<Favourite>().getFavouriteList(null, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: H2Bold(text: Controller.getTag('favorites')),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<Favourite>(builder: (context, value, child) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
          ),
          child: value.isFavLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : value.favouriteDataList.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 346.w,
                          height: 194.h,
                          child: Image.asset(
                            'assets/emptyFav.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 27.h, bottom: 17.h),
                          child:
                              H2semi(text: Controller.getTag('no_favorites')),
                        ),
                        H3Regular(
                          text: Controller.getTag('use_favorite_icon'),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: value.favouriteDataList.length,
                      itemBuilder: (context, index) {
                        String image = '';
                        String price = '';
                        String title = '';
                        String location = '';
                        String description = '';
                        String date = '';
                        String id = '';
                        String make = '';
                        id = value.favouriteDataList[index]['_id'];
                        date = value.favouriteDataList[index]['created_at'];

                        (value.favouriteDataList[index]['data'] as List)
                            .forEach((e) {
                          if (e['name'] == 'Title') {
                            title = Controller.languageChange(
                                english: e['value'], arabic: e['value_ar']);
                          } else if (e['name'].contains('Pictures')) {
                            image = (e['value']
                                    .toString()
                                    .replaceAll("[", "")
                                    .replaceAll("]", ""))
                                .split(',')[0];
                          } else if (e['name'].contains('Description')) {
                            description = Controller.languageChange(
                                english: e['value'], arabic: e['value_ar']);
                          } else if (e['name']
                              .toString()
                              .toLowerCase()
                              .contains('location')) {
                            location = Controller.languageChange(
                                english: e['value'].toString().split('_')[0],
                                arabic: e['value_ar'].toString().split('_')[0]);
                          } else if (e['name'] == 'Price') {
                            price = e['value'].toString();
                          } else if (e['name']
                              .toString()
                              .toLowerCase()
                              .contains('make')) {
                            make = e['value'].toString();
                          }
                        });
                        return Container(
                          width: 394.w,
                          height: 372.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
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
                          child: Column(
                            children: [
                              Container(
                                clipBehavior: Clip.hardEdge,
                                height: 355.h,
                                width: 367.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //image
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => DetailsScreen(
                                                    tag:
                                                        'fav${Random().nextInt(1000)}',
                                                    carId: id)));
                                      },
                                      child: Container(
                                        clipBehavior: Clip.hardEdge,
                                        width: 366.w,
                                        height: 178.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: image,
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Center(
                                                  child: Icon(Icons
                                                      .error_outline_outlined)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 173.h,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailsScreen(
                                                              tag:
                                                                  'fav${Random().nextInt(1000)}',
                                                              carId: id)));
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                H2semi(
                                                  text:
                                                      '${Controller.getTag('aed')} ${price}',
                                                  color: kredText,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                DetailsScreen(
                                                                    tag:
                                                                        'fav${Random().nextInt(1000)}',
                                                                    carId:
                                                                        id)));
                                                  },
                                                  child: ParaRegular(
                                                    text:
                                                        '${Controller.formatDateTime(date)}',
                                                    color: kredText,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailsScreen(
                                                              tag:
                                                                  'fav${Random().nextInt(1000)}',
                                                              carId: id)));
                                            },
                                            child: SizedBox(
                                              width: 1.sw,
                                              child: H3semi(
                                                text: '${title}',
                                                maxLines: 2,
                                              ),
                                            ),
                                          ),
                                          if (make.isNotEmpty && make != 'null')
                                            ParaRegular(
                                                text:
                                                    '${Controller.getTag('brand')} : $make'),
                                          ParaRegular(
                                              text:
                                                  '${Controller.getTag('details')} :'),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailsScreen(
                                                              tag:
                                                                  'fav${Random().nextInt(1000)}',
                                                              carId: id)));
                                            },
                                            child: SizedBox(
                                                width: 1.sw,
                                                child: ParaRegular(
                                                  text: '${description}',
                                                  maxLines: 2,
                                                )),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(
                                                Icons.location_on_outlined,
                                                color: ksecondaryColor2,
                                              ),
                                              Expanded(
                                                child: ParaRegular(
                                                  text: '  ${location}',
                                                  maxLines: 2,
                                                ),
                                              ),
                                              const SizedBox.shrink(),
                                              const SizedBox.shrink(),
                                              const SizedBox.shrink(),
                                              const SizedBox.shrink(),
                                              const SizedBox.shrink(),
                                              const SizedBox.shrink(),
                                              const SizedBox.shrink(),
                                              const SizedBox.shrink(),
                                              const SizedBox.shrink(),
                                              const SizedBox.shrink(),
                                              const SizedBox.shrink(),
                                              const SizedBox.shrink(),
                                              const SizedBox.shrink(),
                                              const SizedBox.shrink(),
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return DialogForDeleteFavourite(
                                                        data: value
                                                                .favouriteDataList[
                                                            index],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.delete_rounded,
                                                  color: kprimaryColor,
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
                            ],
                          ),
                        );
                      }),
        );
      }),
    );
  }
}
