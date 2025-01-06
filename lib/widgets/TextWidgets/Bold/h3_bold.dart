import 'package:lisit_mobile_app/const/lib_all.dart';

class H3Bold extends StatelessWidget {
  String text;
  Color? color;
  H3Bold({
    required this.text,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor = color ?? Theme.of(context).primaryColor;
    return Text(
      maxLines: 2,
      text,
      style: TextStyle(
        fontSize: 14.sp,
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
