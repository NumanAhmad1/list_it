import 'package:lisit_mobile_app/const/lib_all.dart';

class H3Regular extends StatelessWidget {
  String text;
  Color? color;
  int maxLine;
  TextAlign textAlign;
  H3Regular({
    required this.text,
    this.color,
    this.maxLine = 3,
    this.textAlign = TextAlign.start,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor = color ?? Theme.of(context).primaryColor;
    return Text(
      textAlign: textAlign,
      maxLines: maxLine,
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontFamily: Controller.getLanguage().toString().toLowerCase() == "english"
            ? GoogleFonts.montserrat().fontFamily
            : GoogleFonts.tajawal().fontFamily,
        fontWeight: FontWeight.w400,
        color: defaultColor,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
