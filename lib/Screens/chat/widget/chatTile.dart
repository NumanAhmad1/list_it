import 'package:lisit_mobile_app/const/lib_all.dart';

class ChatTile extends StatelessWidget {
  String lastMessage;
  String name;
  Widget avatar;
  String hy;
  String date;
  Function() onTap;
  ChatTile({
    required this.lastMessage,
    required this.name,
    required this.hy,
    required this.avatar,
    required this.date,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          color: Colors.transparent,
          height: 55.h,
          // width: 1.sw,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: Row(
                  children: [
                    // avatar

                    Container(
                      clipBehavior: Clip.hardEdge,
                      height: 50.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kprimaryColor,
                      ),
                      child: avatar,
                    ),

                    // person data
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: SizedBox(
                        height: 55.h,
                        width: 170.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ParaSemi(
                              text: lastMessage,
                              maxLines: 1,
                            ),
                            // name
                            ParaSemi(
                              text: name,
                              maxLines: 1,
                            ),
                            // hy text

                            ParaRegular(
                              text: hy,
                              color: khelperTextColor,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // data

              SizedBox(
                height: 55.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ParaRegular(
                      text: date,
                      color: khelperTextColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
