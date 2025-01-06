import 'package:lisit_mobile_app/const/lib_all.dart';

class SelectOptionForSecondAdScreen extends StatefulWidget {
  bool isOptional;
  String dropDownValue;
  List dropdownlist;
  SelectOptionForSecondAdScreen(
      {required this.isOptional,
      required this.dropDownValue,
      required this.dropdownlist,
      super.key});

  @override
  State<SelectOptionForSecondAdScreen> createState() =>
      _SelectOptionForSecondAdScreenState();
}

class _SelectOptionForSecondAdScreenState
    extends State<SelectOptionForSecondAdScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: 350.w,
      height: 48.h,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2.w,
          color: khelperTextColor,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 11.w),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            if (widget.isOptional)
              Positioned(right: 50.w, child: ParaRegular(text: '*${Controller.getTag('optional')}')),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                  child: DropdownButton(
                    icon: const Icon(Icons.keyboard_arrow_down_outlined),
                    underline: const Text(''),
                    value: widget.dropDownValue,
                    items: widget.dropdownlist.map((e) {
                      return DropdownMenuItem(
                        value: e.toString(),
                        child: SizedBox(
                          width: 300.w,
                          child: ParaRegular(
                            text: e.toString(),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      widget.dropDownValue = newValue.toString();
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
