import 'package:lisit_mobile_app/const/lib_all.dart';

class ParaSemi extends StatelessWidget {
  String text;
  Color? color;
  int maxLines;
  TextAlign textAlign;
  ParaSemi({
    required this.text,
    this.color,
    this.maxLines = 2,
    this.textAlign = TextAlign.start,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor = color ?? Theme.of(context).primaryColor;
    return Text(
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      text,
      style: TextStyle(
        fontSize: 12.sp,
        fontFamily: Controller.getLanguage().toString().toLowerCase() == "english"
            ? GoogleFonts.montserrat().fontFamily
            : GoogleFonts.tajawal().fontFamily,
        fontWeight: FontWeight.w600,
        color: defaultColor,
      ),
    );
  }
}
