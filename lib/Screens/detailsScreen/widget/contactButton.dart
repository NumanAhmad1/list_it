import 'package:lisit_mobile_app/const/lib_all.dart';

class ContactButtons extends StatelessWidget {
  String buttonText;
  Widget buttonIcon;
  Function() onTap;
  ContactButtons({
    required this.buttonIcon,
    required this.buttonText,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 50.h,
        width: 99.w,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.w,
            color: ksecondaryColor2,
          ),
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buttonIcon,
            H3Bold(text: buttonText),
          ],
        ),
      ),
    );
  }
}
