import 'package:lisit_mobile_app/const/lib_all.dart';

class AuthValidation extends ChangeNotifier {
  bool errorInEmail = false;
  bool errorInPassword = false;
  bool errorInName = false;
  bool errorInNewPassword = false;
  bool errorInConfirmPassword = false;

  // email validation funcation

  void validateEmail(String value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    if (value.isEmpty || !regex.hasMatch(value)) {
      errorInEmail = true;
      notifyListeners();
    } else {
      errorInEmail = false;
      notifyListeners();
    }
    print("validate email : $errorInEmail");
  }

  //password validation function

  validatePassword(String value) {
    if (value.isEmpty || value.length < 7) {
      errorInPassword = true;
      notifyListeners();
    } else {
      errorInPassword = false;
      notifyListeners();
    }
    print("validate password : $errorInPassword");
  }

  // username validation function

  validateName(String value) {
    final rex = RegExp(r"^[a-zA-Z]+[a-zA-Z0-9\s]*$");

    // RegExp rex = RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    if (value.isEmpty || !rex.hasMatch(value)) {
      errorInName = true;
      notifyListeners();
    } else {
      errorInName = false;
      notifyListeners();
    }
  }

  /// function for checking validation
  ///
  bool hasUppercase = false;
  bool hasDigits = false;
  bool hasSpecialCharacters = false;
  bool hasLowercase = false;
  bool hasMinLength = false;

  isPasswordCompliant(
    String password,
  ) {
    // if (password.isEmpty) {
    //   return false;
    // }

    hasUppercase = password.contains(RegExp(r'[A-Z]'));
    notifyListeners();
    hasDigits = password.contains(RegExp(r'[0-9]'));
    print('has digit: $hasDigits');
    notifyListeners();

    hasLowercase = password.contains(RegExp(r'[a-z]'));
    notifyListeners();

    hasSpecialCharacters = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    notifyListeners();

    hasMinLength = password.length >= 8;
    notifyListeners();

    if (hasUppercase &&
        hasDigits &&
        hasLowercase &&
        hasSpecialCharacters &&
        hasMinLength) {
      errorInNewPassword = true;
      notifyListeners();
    } else {
      errorInNewPassword = false;
      notifyListeners();
    }
  }

  // confirm password

  confirmPassworValidation(String newPassword, String confirmPassword) {
    if (newPassword == confirmPassword) {
      errorInConfirmPassword = false;
      notifyListeners();
    } else {
      errorInConfirmPassword = true;
      notifyListeners();
    }
  }

  @override
  void dispose() {
     errorInEmail = false;
     errorInPassword = false;
     errorInName = false;
     errorInNewPassword = false;
     errorInConfirmPassword = false;
    // TODO: implement dispose
    super.dispose();
  }
}
