import 'package:lisit_mobile_app/const/lib_all.dart';

class MyAccountTile extends StatelessWidget {
  Widget icon;
  String title;
  Function() onTap;
  MyAccountTile({
    required this.title,
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
        ),
        height: 44.h,
        width: 1.sw,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              // width: 200.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 22.h,
                    width: 22.w,
                    child: icon,
                  ),
                  SizedBox(
                    width: 11.w,
                  ),
                  H3Regular(
                    text: title,
                    color: ksecondaryColor,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: ksecondaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
