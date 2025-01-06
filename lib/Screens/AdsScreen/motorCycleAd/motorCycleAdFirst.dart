// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:lisit_mobile_app/Screens/AdsScreen/motorCycleAd/widget/motorCycleCategory.dart';
// import 'package:lisit_mobile_app/const/lib_all.dart';
//
// import 'motorCycleAdSecond.dart';
//
// class MotorCycleAdFirst extends StatefulWidget {
//   String categoryName;
//   MotorCycleAdFirst({required this.categoryName, super.key});
//
//   @override
//   State<MotorCycleAdFirst> createState() => _MotorCycleAdFirstState();
// }
//
// class _MotorCycleAdFirstState extends State<MotorCycleAdFirst> {
//   List<String> categories = [
//     TextName.sportBike,
//     TextName.adventureTouring,
//     TextName.cruiserChopper,
//     TextName.offRoad,
//     TextName.scooter,
//     TextName.standardCommuter,
//     TextName.cafeRacer,
//     TextName.trike,
//     TextName.karting,
//     TextName.moPed,
//     TextName.golfCart,
//     TextName.other
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         leading: GestureDetector(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: const Icon(Icons.keyboard_arrow_left_outlined)),
//         title: H2Bold(text: TextName.placeAnAd),
//         actions: [
//           GestureDetector(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Padding(
//                 padding: EdgeInsets.only(right: 10.w),
//                 child: const Icon(Icons.close),
//               )),
//         ],
//       ),
//       body: Container(
//         padding: EdgeInsets.symmetric(horizontal: 25.w),
//         height: 1.sh,
//         width: 1.sw,
//         decoration: BoxDecoration(
//           border: Border(
//             top: BorderSide(color: ksearchFieldColor),
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 33.h,
//               ),
//               H3semi(text: '${TextName.chooseTheRightCategoryForYourAd}:'),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   H3Regular(text: '...>Motors>${widget.categoryName}'),
//                 ],
//               ),
//               SizedBox(
//                 height: 45.h,
//               ),
//               Divider(
//                 color: khelperTextColor,
//               ),
//               SizedBox(
//                 height: 936.h,
//                 child: ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: categories.length,
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => MotorCycleAdSecond(
//                                           selectedCategoryName:
//                                               categories[index],
//                                         )));
//                           },
//                           child: MotorCycleCategory(title: categories[index]));
//                     }),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }