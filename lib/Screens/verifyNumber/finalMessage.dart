import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/verifyNumber.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class FinalMessage extends StatefulWidget {
  Function()? callBack;
  FinalMessage({
    this.callBack,
    super.key,
  });

  @override
  State<FinalMessage> createState() => _FinalMessageState();
}

class _FinalMessageState extends State<FinalMessage> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        width: 386.w,
        height: 436.h,
        decoration: BoxDecoration(
          color: kbackgrounColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 75.h,
            ),
            // heading
            H1Regular(text: Controller.getTag('verify_your_number')),

            SizedBox(
              height: 30.h,
            ),

            // image
            SizedBox(
              height: 80.h,
              width: 80.w,
              child: Image.asset(
                'assets/lockImage.png',
                fit: BoxFit.fill,
              ),
            ),

            SizedBox(
              height: 30.h,
            ),

            //message

            H3Regular(
              text: Controller.getTag(
                  'your_number_has_been_successfully_verified'),
              textAlign: TextAlign.center,
            ),

            SizedBox(
              height: 30.h,
            ),

            // continue button

            SizedBox(
              height: 47.h,
              width: 333.w,
              child: context.select(
                (VerifyNumber num) => num.isGetProfile
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : MainButton(
                        text: Controller.getTag('continue'),
                        onTap: () async {
                          var profileResult = await context
                              .read<VerifyNumber>()
                              .getProfile(context);

                          if (profileResult is! String) {
                            Controller.saveIsNumberVerified(
                                isNumberVerifend: profileResult['data']
                                    ['IsVerified']);
                            Controller.saveIsUserVerified(
                                isUserVerifend: profileResult['data']
                                    ['IsVerified']);
                          } else {
                            DisplayMessage(
                                context: context,
                                isTrue: false,
                                message: profileResult);
                          }
                          if (widget.callBack != null) {
                            widget.callBack!();
                          }
                          Navigator.pop(context);
                        }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
