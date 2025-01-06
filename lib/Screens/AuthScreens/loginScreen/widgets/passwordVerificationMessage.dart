import 'package:lisit_mobile_app/const/lib_all.dart';

class PasswordVerificationMessage extends StatelessWidget {
  String text;
  bool isTrue;
  PasswordVerificationMessage({
    required this.isTrue,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 15.h,
          width: 15.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isTrue ? kprimaryColor : kredColor,
          ),
        ),
        ParaRegular(
          text: '  $text',
          color: isTrue ? kprimaryColor : kredColor,
        )
      ],
    );
  }
}
