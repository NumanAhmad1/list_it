import 'package:lisit_mobile_app/const/lib_all.dart';

class LoginMainButton extends StatelessWidget {
  String image;
  String title;
  Function() onTap;
  LoginMainButton({
    required this.image,
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.h,
        width: 374.w,
        decoration: BoxDecoration(
          border: Border.all(
            color: ksecondaryColor,
            width: 1.w,
          ),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // button logo
            Padding(
              padding: EdgeInsets.only(left: 27.w, right: 27.w),
              child: SizedBox(
                width: 30.w,
                height: 30.h,
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // button text
            Padding(
              padding: EdgeInsets.only(left: 17.w),
              child: H2semi(text: title),
            ),
            SizedBox(
              width: 40.w,
            ),
          ],
        ),
      ),
    );
  }
}
