import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/favourite.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class DialogForDeleteFavourite extends StatefulWidget {
  var data;
  DialogForDeleteFavourite({
    required this.data,
    super.key,
  });

  @override
  State<DialogForDeleteFavourite> createState() =>
      _DialogForDeleteFavouriteState();
}

class _DialogForDeleteFavouriteState extends State<DialogForDeleteFavourite> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: 200.w,
          height: 110.h,
          decoration: BoxDecoration(
            color: kbackgrounColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: Container(
                  alignment: Alignment.center,
                  width: 180.w,
                  child: H3semi(
                    maxLines: 3,
                    text: Controller.getTag(
                        'are_you_sure_you_want_to_remove_this_Ad_from_your_favorites'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                clipBehavior: Clip.hardEdge,
                height: 28.h,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.w, color: khelperTextColor),
                  ),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 124.w,
                        decoration: BoxDecoration(
                          color: kbackgrounColor,
                          border: Border(
                            right: BorderSide(
                              width: 1.w,
                              color: khelperTextColor,
                            ),
                          ),
                        ),
                        child: H3semi(
                          text: Controller.getTag('cancel'),
                          color: kprimaryColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        var ctrl = context.read<Favourite>();
                        ctrl.addToFavourite(context,
                            addId: widget.data['_id'], fromFavourite: false);
                        ctrl.favouriteDataList.remove(widget.data);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 125.w,
                        color: kbackgrounColor,
                        alignment: Alignment.center,
                        child: H3semi(
                          text: Controller.getTag('delete'),
                          color: kredText,
                        ),
                      ),
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
