import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Controller/controller.dart';

class H1Bold extends StatelessWidget {
  String text;
  Color? color;
  int maxLines;
  H1Bold({
    required this.text,
    this.color,
    super.key,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor = color ?? Theme.of(context).primaryColor;
    return Text(
      maxLines: maxLines,
      text,
      style: TextStyle(
        fontSize: 22.sp,
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
