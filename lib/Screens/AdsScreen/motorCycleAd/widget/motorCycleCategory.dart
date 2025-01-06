import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class MotorCycleCategory extends StatefulWidget {
  String title;
  MotorCycleCategory({required this.title, super.key});

  @override
  State<MotorCycleCategory> createState() => _MotorCycleCategoryState();
}

class _MotorCycleCategoryState extends State<MotorCycleCategory> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: SizedBox(
        height: 41.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  H3semi(
                    text: widget.title,
                    color: ksecondaryColor,
                  ),
                  SizedBox(
                    height: 22.h,
                    width: 22.w,
                    child: const Icon(
                      Icons.keyboard_arrow_right_outlined,
                    ),
                  )
                ],
              ),
            ),
            Divider(
              color: khelperTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
