import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/favourite.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class PopularCarCard extends StatelessWidget {
  String title;
  String price;
  String distanceTravel;
  String carImage;
  bool isDistanceTravelRequired;
  String? adId;
  bool showFavouriteButton;
  String createdById;
  PopularCarCard({
    required this.carImage,
    this.createdById = '',
    required this.showFavouriteButton,
    this.adId,
    required this.title,
    required this.price,
    required this.distanceTravel,
    required this.isDistanceTravelRequired,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: kbackgrounColor, color: kbackgrounColor,

      // padding: EdgeInsets.only(bottom: 10.h),
      // clipBehavior: Clip.hardEdge,
      // alignment: Alignment.center,
      // // height: 230.h,
      // width: 183.w,
      // margin: EdgeInsets.only(bottom: 5.h),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(10.r),
      //   color: kbackgrounColor,
      //   // color: Colors.blue,
      //   boxShadow: [
      //     BoxShadow(
      //       offset: Offset(0, 3),
      //       blurRadius: 8,
      //       spreadRadius: -1,
      //       color: khelperTextColor,
      //     ),
      //   ],
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          //card image
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                height: 178.h,
                width: 175.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: carImage.replaceAll('[', "").replaceAll("]", ""),
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Image.asset("assets/placeholderImage.png"),
                  ),
                ),
              ),
              if (createdById != Controller.getUserId())
                if (showFavouriteButton)
                  GestureDetector(
                    onTap: () async {
                      if (Controller.getLogin()) {
                        await context.read<Favourite>().addToFavourite(
                              context,
                              addId: adId.toString(),
                            );
                      } else {
                        DisplayMessage(
                            context: context,
                            isTrue: false,
                            message: Controller.getTag('login_to_continue'));
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(
                          horizontal: 13.w, vertical: 15.h),
                      height: 28.h,
                      width: 28.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: khelperTextColor.withOpacity(0.7),
                      ),
                      child: Icon(
                        Icons.favorite,
                        size: 16.sp,
                        color: context.select((Favourite valu) => valu
                                .favouriteIdList
                                .any((element) => element == adId)
                            ? kredColor
                            : ksecondaryColor2),
                      ),
                    ),
                  ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 10.w),
            width: 175.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                H3semi(
                  text: title,
                  maxLines: 1,
                ),
                SizedBox(
                  height: 8.h,
                ),
                ParaRegular(text: price),
                SizedBox(
                  height: 8.h,
                ),
                if (isDistanceTravelRequired) ParaRegular(text: distanceTravel),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
