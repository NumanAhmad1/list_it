import 'package:lisit_mobile_app/const/lib_all.dart';

class ParaRegular extends StatelessWidget {
  String text;
  Color? color;
  int maxLines;
  TextAlign textAlign;
  ParaRegular({
    required this.text,
    this.maxLines = 2,
    this.textAlign = TextAlign.start,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor = color ?? Theme.of(context).primaryColor;
    return Text(
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      text,
      style: TextStyle(
        fontSize: 12.sp,
        fontFamily: Controller.getLanguage().toString().toLowerCase() == "english"
            ? GoogleFonts.montserrat().fontFamily
            : GoogleFonts.tajawal().fontFamily,
        fontWeight: FontWeight.w400,
        color: defaultColor,
      ),
    );
  }
}
