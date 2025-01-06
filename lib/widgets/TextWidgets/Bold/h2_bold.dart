import 'package:lisit_mobile_app/const/lib_all.dart';

class H2Bold extends StatelessWidget {
  String text;
  Color? color;
  int maxLines;
  TextAlign textAlign;
  H2Bold({
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
    required this.text,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor = color ?? Theme.of(context).primaryColor;
    return Text(
      maxLines: maxLines,
      textAlign: textAlign,
      text,
      style: TextStyle(
        fontSize: 16.sp,
        fontFamily: Controller.getLanguage().toString().toLowerCase() == "english"
            ? GoogleFonts.montserrat().fontFamily
            : GoogleFonts.tajawal().fontFamily,
        fontWeight: FontWeight.w700,
        color: defaultColor,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
