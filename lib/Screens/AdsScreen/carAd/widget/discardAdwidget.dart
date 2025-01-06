import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/adsInputField.dart';
import 'package:lisit_mobile_app/Screens/motors/motors.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class DiscardAdWidget extends StatefulWidget {
  bool fromCarAdOne;
  bool? fromEditScreen;
  DiscardAdWidget({super.key, this.fromCarAdOne = false});

  @override
  State<DiscardAdWidget> createState() => _DiscardAdWidgetState();
}

class _DiscardAdWidgetState extends State<DiscardAdWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 234.h,
      color: kbackgrounColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: SizedBox(
              height: 50.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox.shrink(),
                  H2semi(text: Controller.getTag('discard')),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.close)),
                ],
              ),
            ),
          ),
          const Divider(),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 28.w),
            height: 50.h,
            child: H3Regular(text: Controller.getTag('leave_page')),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 140.w,
                height: 58.h,
                child: MainButton(
                  text: Controller.getTag('cancel'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  isFilled: false,
                  textColor: ksecondaryColor2,
                ),
              ),
              SizedBox(
                width: 24.w,
              ),
              SizedBox(
                width: 100.w,
                height: 58.h,
                child: MainButton(
                  text: Controller.getTag('ok'),
                  onTap: () {
                    if (widget.fromEditScreen == true) {
                      context
                          .read<AdsInputField>()
                          .editAdSelectedValuesList
                          .clear();
                    }
                    if (widget.fromCarAdOne) {
                      context
                          .read<AdsInputField>()
                          .carAdOneSelectedValuesList
                          .clear();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else {
                      context
                          .read<AdsInputField>()
                          .carAdOneSelectedValuesList
                          .clear();
                      context
                          .read<AdsInputField>()
                          .carAdTwoSelectedValuesList
                          .clear();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }
}
