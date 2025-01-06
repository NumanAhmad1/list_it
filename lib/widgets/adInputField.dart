import 'package:lisit_mobile_app/const/lib_all.dart';

class AdInputField extends StatelessWidget {
  String title;
  TextInputType keybordType;
  bool isHelperText;
  Function(String) onChanged;
  TextEditingController? controller;
  bool? isRequiredCheck;
  AdInputField({
    super.key,
    this.isRequiredCheck = false,
    this.isHelperText = false,
    required this.title,
    required this.keybordType,
    required this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          width: 350.w,
          height: 48.h,
          decoration: BoxDecoration(
            border: Border.all(
              width: 2.w,
              color: isRequiredCheck! ? kredColor : khelperTextColor,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ParaRegular(text: title),
              SizedBox(
                height: 25.h,
                child: TextField(
                  onChanged: onChanged,
                  keyboardType: keybordType,
                  controller: controller,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: Controller.getLanguage().toString().toLowerCase() == "english"
                        ? GoogleFonts.montserrat().fontFamily
                        : GoogleFonts.tajawal().fontFamily,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).primaryColor,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10.w, right: 10.w),
                    label: isHelperText ? null : ParaRegular(text: title),
                    hintText: isHelperText ? title : '',
                    hintStyle: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: Controller.getLanguage().toString().toLowerCase() == "english"
                          ? GoogleFonts.montserrat().fontFamily
                          : GoogleFonts.tajawal().fontFamily,
                      fontWeight: FontWeight.w400,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isRequiredCheck!)
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: ParaRegular(
              text:
                  '${title == 'Price' ? Controller.getTag('the_minimum_valid_price_is_2000_AED') : title == 'Kilometers' ? Controller.getTag('the_minimum_valid_mileage_is_0_KM') : '${Controller.getTag('please_enter_a_valid')} $title'}',
              color: kredColor,
            ),
          )
      ],
    );
  }
}
