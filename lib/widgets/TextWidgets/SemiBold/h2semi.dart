import 'package:lisit_mobile_app/const/lib_all.dart';

class H2semi extends StatelessWidget {
  String text;
  Color? color;

  int maxLines;
  TextAlign textAlign;
  H2semi({
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
      text,
      style: TextStyle(
        fontSize: 18.sp,
        fontFamily: Controller.getLanguage().toString().toLowerCase() == "english"
            ? GoogleFonts.montserrat().fontFamily
            : GoogleFonts.tajawal().fontFamily,
        fontWeight: FontWeight.w600,
        color: defaultColor,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
