import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class NoChat extends StatelessWidget {
  const NoChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 297.h,
          width: 356.w,
          child: Image.asset(
            'assets/noChat.png',
            // fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          width: 1.sw,
          height: 22.h,
        ),
        SizedBox(
            width: 325.w,
            child: H2semi(
              text: Controller.getTag('looks_like_you_don’t_have_any_chat_messages_yet'),
              textAlign: TextAlign.center,
            )),
      ],
    );
  }
}
