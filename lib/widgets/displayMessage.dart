import 'package:lisit_mobile_app/const/lib_all.dart';

DisplayMessage(
    {required BuildContext context, required bool isTrue, required message}) {
  FToast().init(context);
  Widget toast = Container(
    clipBehavior: Clip.hardEdge,
    height: 64.h,
    width: 1.sw,
    decoration: BoxDecoration(
      color: isTrue ? kprimaryColor : kredColor,
      borderRadius: BorderRadius.circular(10.r),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 13.w),
          child: Icon(
            Icons.close,
            color: kbackgrounColor,
          ),
        ),
        SizedBox(
          width: 0.7.sw,
          child: ParaSemi(
            text: message,
            color: kbackgrounColor,
            maxLines: 3,
          ),
        ),
      ],
    ),
  );

  FToast().showToast(
    child: toast,
    gravity: ToastGravity.TOP,
    toastDuration: const Duration(seconds: 2),
  );
}

// import 'package:lisit_mobile_app/const/lib_all.dart';

// DisplayMessage(BuildContext context, String message, bool isTrue) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       duration: const Duration(seconds: 1),
//       padding: EdgeInsets.zero,
//       margin: EdgeInsets.only(
//         bottom: 0.80.sh,
//         left: 20.w,
//         right: 20.w,
//         top: 0.10.sh,
//       ),
//       behavior: SnackBarBehavior.floating,
//       content: Container(
//         clipBehavior: Clip.hardEdge,
//         height: 64.h,
//         width: 1.sw,
//         decoration: BoxDecoration(
//           color: isTrue ? kprimaryColor : kredColor,
//           borderRadius: BorderRadius.circular(10.r),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 13.w),
//               child: Icon(
//                 Icons.close,
//                 color: kbackgrounColor,
//               ),
//             ),
//             ParaSemi(
//               text: message,
//               color: kbackgrounColor,
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
