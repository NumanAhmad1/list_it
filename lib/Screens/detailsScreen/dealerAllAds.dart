import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/getDealerAds.dart';
import 'package:lisit_mobile_app/Screens/detailsScreen/detailsScreen.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';
import 'package:lisit_mobile_app/widgets/popularCarCard.dart';

class DealerAllAds extends StatefulWidget {
  String dealerId;
  String name;
  String picture;
  DealerAllAds(
      {super.key,
      required this.dealerId,
      required this.name,
      required this.picture});

  @override
  State<DealerAllAds> createState() => _DealerAllAdsState();
}

class _DealerAllAdsState extends State<DealerAllAds> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    await context
        .read<GetDealerAds>()
        .getdealerAds(context, dealerId: widget.dealerId);
    // log('${context.read<GetDealerAds>().adsDataList}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GetDealerAds>(builder: (context, value, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 95.h,
              width: 1.sw,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 14.h, right: 15.w, left: 15.w),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 47.w,
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  height: 58.h,
                  width: 58.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: '${widget.picture}',
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/personErrorImage.png',
                      fit: BoxFit.cover,
                    ),
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                SizedBox(
                  width: 11.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    H2semi(text: '${widget.name}'),
                    ParaRegular(text: Controller.getTag('seller')),
                    ParaRegular(text: 'joined on November 2017'),
                  ],
                ),
                SizedBox(
                  width: 47.w,
                ),
              ],
            ),
            Divider(
              thickness: 1,
              color: ksecondaryColor,
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.h, right: 20.w, left: 20.w),
              child: H2semi(
                  text:
                      '${Controller.getTag('active_ads')} (${value.adsDataList.length})'),
            ),
            value.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : value.error.isNotEmpty
                    ? Center(
                        child: H2Bold(text: '${value.error}'),
                      )
                    : Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: GridView.builder(
                              itemCount: value.adsDataList.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: 20.w,
                                      crossAxisSpacing: 20.h,
                                      childAspectRatio: 175.w / 270.h,
                                      crossAxisCount: 2),
                              itemBuilder: (context, index) {
                                var formatBid = NumberFormat("#,###,###");
                                String image = '';
                                String title = '';
                                String price = '';
                                String year = '';
                                String distance = '';
                                String adId = value.adsDataList[index]['_id'];

                                (value.adsDataList[index]['data'] as List)
                                    .forEach((e) {
                                  if (e['name'] == 'Price') {
                                    price = formatBid.format(
                                        int.parse("${e['value'].toString()}"));
                                    ;
                                  } else if (e['name'] == 'Title') {
                                    title = Controller.languageChange(
                                        english: e['value'],
                                        arabic: e['value_ar']);
                                  } else if (e['name']
                                      .toString()
                                      .toLowerCase()
                                      .contains('pictures')) {
                                    image = e['value'].toString().split(',')[0];
                                  } else if (e['name'] == '') {
                                    year = e['value'].toString();
                                  } else if (e['name'] == '') {
                                    distance = e['value'].toString();
                                  }
                                });
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DetailsScreen(
                                                tag: '$index', carId: adId)));
                                  },
                                  child: PopularCarCard(
                                      showFavouriteButton: false,
                                      adId: adId,
                                      carImage: '${image}',
                                      title: '${title}',
                                      price: '${price}',
                                      distanceTravel: '${distance}',
                                      isDistanceTravelRequired: true),
                                );
                              }),
                        ),
                      ),
          ],
        );
      }),
    );
  }
}
