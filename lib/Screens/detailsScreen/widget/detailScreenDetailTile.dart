import 'package:lisit_mobile_app/const/lib_all.dart';

class DetailsScreenDetailTile extends StatelessWidget {
  String title;
  String property;
  DetailsScreenDetailTile({
    required this.title,
    required this.property,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: 180.w,
                    child: ParaBold(
                      text: title,
                      maxLines: 10,
                    )),
                SizedBox(
                    width: 180.w,
                    child: ParaSemi(
                      text: property,
                      maxLines: 10,
                      color: ksecondaryColor2,
                    )),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
