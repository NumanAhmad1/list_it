import 'package:lisit_mobile_app/const/lib_all.dart';

class MainButton extends StatelessWidget {
  String text;
  Function() onTap;
  Color textColor;
  bool isFilled;
  Color fillColor;
  bool isLoading;
  MainButton({
    required this.text,
    required this.onTap,
    this.textColor = const Color(0xFFFFFFFF),
    this.isFilled = true,
    this.fillColor = const Color(0xFFA2B615),
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 366.w,
        height: 64.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: isFilled ? kprimaryColor : textColor),
          color: isFilled ? fillColor : Colors.transparent,
        ),
        child: isLoading == true
            ? Center(
                child: CircularProgressIndicator(
                  color: kbackgrounColor,
                ),
              )
            : H2Bold(
                text: text,
                color: textColor,
              ),
      ),
    );
  }
}
