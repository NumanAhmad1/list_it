import 'package:lisit_mobile_app/const/lib_all.dart';

class H1semi extends StatelessWidget {
  String text;
  Color? color;
  int maxLines;
  H1semi({
    required this.text,
    this.color,
    this.maxLines = 1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor = color ?? Theme.of(context).primaryColor;
    return Text(
      maxLines: maxLines,
      text,
      style: TextStyle(
        fontSize: 24.sp,
        fontFamily:
            Controller.getLanguage().toString().toLowerCase() == "english"
                ? GoogleFonts.montserrat().fontFamily
                : GoogleFonts.tajawal().fontFamily,
        fontWeight: FontWeight.w600,
        color: defaultColor,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
