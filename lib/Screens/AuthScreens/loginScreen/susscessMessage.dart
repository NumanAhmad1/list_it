import 'package:lisit_mobile_app/Screens/AuthScreens/loginScreen/loginWithEmail.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class SuccessMessage extends StatelessWidget {
  const SuccessMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: 386.w,
        height: 345.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r), color: kbackgrounColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // icon image

            SizedBox(
              height: 100.h,
              width: 100.w,
              child: Image.asset(
                'assets/successIcon.png',
                fit: BoxFit.contain,
              ),
            ),

            // Congratulation text

            H1Bold(text: Controller.getTag('Congratulation')),

            // text

            H3Regular(
              text: Controller.getTag('your_account_password_has_successfully_changed'),
              textAlign: TextAlign.center,
            ),

            //login button

            SizedBox(
              height: 64.h,
              width: 145.w,
              child: MainButton(
                text: Controller.getTag('login'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return LoginWithEmail();
                  }));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
