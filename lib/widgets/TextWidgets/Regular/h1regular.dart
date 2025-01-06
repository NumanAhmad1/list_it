import 'package:lisit_mobile_app/const/lib_all.dart';

class H1Regular extends StatelessWidget {
  String text;
  Color? color;
  H1Regular({
    required this.text,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor = color ?? Theme.of(context).primaryColor;
    return Text(
      text,
      style: TextStyle(
        fontSize: 24.sp,
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
