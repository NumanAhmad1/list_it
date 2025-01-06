// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:lisit_mobile_app/const/lib_all.dart';

// class ImageSlider extends StatefulWidget {
//   List imageList = [];
//   int indexValue = 1;
//   int initialImage = 1;
//   ImageSlider({super.key});

//   @override
//   State<ImageSlider> createState() => _ImageSliderState();
// }

// class _ImageSliderState extends State<ImageSlider> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 30.h),
//       height: 1.sh,
//       width: 1.sw,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Padding(
//                   padding:
//                       EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
//                   child: Icon(
//                     Icons.close,
//                     color: kbackgrounColor,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 268.h,
//             width: 1.sw,
//             child: CarouselSlider(
//               items: List.generate(
//                 widget.imageList.length,
//                 (index) => CachedNetworkImage(
//                   imageUrl: widget.imageList[widget.indexValue],
//                   fit: BoxFit.cover,
//                   width: 1.sw,
//                   height: 360.h,
//                   placeholder: (context, error) => const Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                   errorWidget: (context, url, error) => Icon(
//                     Icons.error_outline,
//                     color: kbackgrounColor,
//                   ),
//                 ),
//               ),
//               options: CarouselOptions(
//                 initialPage: provider.imageIndex + 1,
//                 onPageChanged: (imageIndex, reaseon) {
//                   provider.changeImage(imageIndex);
//                 },
//                 aspectRatio: 1 / 1,
//                 viewportFraction: 1,
//                 enlargeCenterPage: true,
//                 enableInfiniteScroll: true,
//               ),
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
//             child: ParaRegular(
//               text:
//                   'Showing ${widget.indexValue + 1} / ${provider.images.length == 0 ? 1 : provider.images.length}',
//               color: kbackgrounColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
