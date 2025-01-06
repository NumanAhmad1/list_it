import 'package:lisit_mobile_app/const/lib_all.dart';

class signUpInputTextField extends StatefulWidget {
  String helperText;
  TextEditingController controller;
  Widget icon;
  bool isPassword;
  bool showEyeIcon;
  bool isEmailError;
  bool isPasswordError;
  bool isNameError;
  TextInputType keyBoardType;
  void Function(String)? onChange;

  signUpInputTextField({
    required this.helperText,
    required this.controller,
    required this.icon,
    required this.isPassword,
    this.showEyeIcon = false,
    this.isEmailError = false,
    this.isPasswordError = false,
    this.isNameError = false,
    required this.keyBoardType,
    this.onChange,
    super.key,
  });

  @override
  State<signUpInputTextField> createState() => _signUpInputTextFieldState();
}

class _signUpInputTextFieldState extends State<signUpInputTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.only(
        bottom: 20.h,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.sp,
            offset: const Offset(0.5, 1),
            blurStyle: BlurStyle.normal, // Shadow position
          ),
        ],
      ),
      child: TextField(
        keyboardType: widget.keyBoardType,
        obscureText: widget.isPassword,
        controller: widget.controller,
        onChanged: widget.onChange,
        decoration: InputDecoration(
          errorStyle: TextStyle(
            fontSize: 12.sp,
            fontFamily: Controller.getLanguage().toString().toLowerCase() == "english"
                ? GoogleFonts.montserrat().fontFamily
                : GoogleFonts.notoKufiArabic().fontFamily,
            fontWeight: FontWeight.w400,
          ),
          errorText: widget.isEmailError
              ? Controller.getTag('enter_your_valid_email_address')
              : widget.isPasswordError
                  ? '${Controller.getTag('password_length_is_less_than')} 7'
                  : widget.isNameError
                      ? Controller.getTag('enter_your_full_name')
                      : null,
          suffixIcon: widget.showEyeIcon
              ? GestureDetector(
                  onTap: () {
                    // widget.showEyeIcon = !widget.showEyeIcon;
                    widget.isPassword = !widget.isPassword;

                    setState(() {});
                  },
                  child: Icon(
                    widget.isPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: khelperTextColor,
                  ),
                )
              : const SizedBox.shrink(),
          hintText: widget.helperText,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            fontFamily: Controller.getLanguage().toString().toLowerCase() == "english"
                ? GoogleFonts.montserrat().fontFamily
                : GoogleFonts.notoKufiArabic().fontFamily,
            fontWeight: FontWeight.w400,
            color: khelperTextColor,
          ),
          prefixIcon: widget.icon,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none,
          ),
          fillColor: Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              color: kredColor,
            ),
          ),
        ),
      ),
    );
  }
}
