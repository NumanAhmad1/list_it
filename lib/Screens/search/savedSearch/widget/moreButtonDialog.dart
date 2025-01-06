import 'package:lisit_mobile_app/Controller/Providers/data/mySavedSearches.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class MoreButtonDialog extends StatefulWidget {
  String searchId;
  String searchTitle;
  String searchCategory;
  String searchImage;
  String searchName;
  String searchValue;
  bool emailNotification;
  bool inAppnotification;
  MoreButtonDialog({
    required this.searchId,
    required this.searchTitle,
    required this.searchCategory,
    required this.searchImage,
    required this.searchName,
    required this.searchValue,
    required this.emailNotification,
    required this.inAppnotification,
    super.key,
  });

  @override
  State<MoreButtonDialog> createState() => _MoreButtonDialogState();
}

class _MoreButtonDialogState extends State<MoreButtonDialog> {
  TextEditingController updateTitleController = TextEditingController();
  @override
  void initState() {
    if (widget.searchTitle != null) {
      updateTitleController.text = widget.searchTitle;
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.only(bottom: 40.h),
      alignment: Alignment.bottomCenter,
      contentPadding: EdgeInsets.zero,
      content: Container(
        clipBehavior: Clip.hardEdge,
        height: 191.h,
        width: 386.w,
        decoration: BoxDecoration(
          color: kbackgrounColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 27.w, right: 20.w),
              height: 50.h,
              width: 1.sw,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 0.5.w,
                    color: ksecondaryColor2,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  H2semi(text: Controller.getTag('more')),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.close))
                ],
              ),
            ),

            //rename search
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: kbackgrounColor,
                    shape: const BeveledRectangleBorder(),
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          height: 0.55.sh,
                          width: 1.sw,
                          color: kbackgrounColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 20.h, left: 10.w, right: 10.w),
                                child: H2semi(text: Controller.getTag('rename_search')),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: 20.h, left: 10.w, right: 10.w),
                                child: H2semi(
                                    text: Controller.getTag(
                                        'edit_the_title_of_your_saved_searches')),
                              ),
                              const Divider(),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 30.h,
                                    left: 10.w,
                                    right: 10.w,
                                    bottom: 40.h),
                                child: H2semi(text: '${widget.searchCategory}'),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: 20.h, left: 10.w, right: 10.w),
                                child: H2semi(
                                    text: Controller.getTag(
                                        'rename_your_search')),
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(horizontal: 20.w),
                                height: 60.h,
                                width: 1.sw,
                                decoration: BoxDecoration(
                                  border: Border.all(color: khelperTextColor),
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: TextField(
                                  controller: updateTitleController,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 15.h),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 20.h, bottom: 20.h),
                                child: const Divider(),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                      height: 40.h,
                                      width: 140.w,
                                      child: MainButton(
                                          isFilled: false,
                                          textColor: kprimaryColor,
                                          text: Controller.getTag('cancel'),
                                          onTap: () {
                                            Navigator.pop(context);
                                          })),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.w),
                                    child: SizedBox(
                                        height: 40.h,
                                        width: 140.w,
                                        child: MainButton(
                                            text: Controller.getTag(
                                                'update_title'),
                                            onTap: () async {
                                              var result = await context
                                                  .read<MySavedSearchProvider>()
                                                  .updateSearchNotification(
                                                    context,
                                                    emailNotification: widget
                                                        .emailNotification,
                                                    inAppNotification: widget
                                                        .inAppnotification,
                                                    title: updateTitleController
                                                        .text,
                                                    category:
                                                        widget.searchValue,
                                                    searchId: widget.searchId,
                                                  );
                                              if (result is! String) {
                                                if (result['success'] == true) {
                                                  await context
                                                      .read<
                                                          MySavedSearchProvider>()
                                                      .getMySavedSearches(
                                                          context);
                                                  DisplayMessage(
                                                      context: context,
                                                      isTrue: true,
                                                      message: Controller
                                                          .languageChange(
                                                              english: result[
                                                                  'message'],
                                                              arabic: result[
                                                                  'message_ar']));
                                                  Navigator.pop(context);
                                                } else {
                                                  DisplayMessage(
                                                      context: context,
                                                      isTrue: false,
                                                      message: result[
                                                              'error'] ??
                                                          Controller.languageChange(
                                                              english: result[
                                                                  'message'],
                                                              arabic: result[
                                                                  'message_ar']));
                                                }
                                              } else {
                                                DisplayMessage(
                                                    context: context,
                                                    isTrue: false,
                                                    message: result.toString());
                                              }
                                            })),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: Container(
                padding: EdgeInsets.only(left: 27.w, right: 20.w),
                alignment: Alignment.centerLeft,
                height: 45.h,
                width: 1.sw,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 0.5.w,
                      color: ksearchFieldColor,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 20.w),
                      child: Icon(
                        Icons.edit_outlined,
                        color: ksecondaryColor,
                        size: 20.sp,
                      ),
                    ),
                    H3semi(text: Controller.getTag('rename_search')),
                  ],
                ),
              ),
            ),

            // //share search
            // GestureDetector(
            //   onTap: () {},
            //   child: Container(
            //     padding: EdgeInsets.only(left: 27.w, right: 20.w),
            //     alignment: Alignment.centerLeft,
            //     height: 45.h,
            //     width: 1.sw,
            //     decoration: BoxDecoration(
            //       border: Border(
            //         bottom: BorderSide(
            //           width: 0.5.w,
            //           color: ksearchFieldColor,
            //         ),
            //       ),
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: [
            //         Padding(
            //           padding: EdgeInsets.only(right: 20.w),
            //           child: Icon(
            //             Icons.share_outlined,
            //             color: ksecondaryColor,
            //             size: 20.sp,
            //           ),
            //         ),
            //         H3semi(text: 'Share this search'),
            //       ],
            //     ),
            //   ),
            // ),

            //delete
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                await context
                    .read<MySavedSearchProvider>()
                    .deleteSearch(context, searchId: widget.searchId);
                await context
                    .read<MySavedSearchProvider>()
                    .getMySavedSearches(context);
              },
              child: Container(
                padding: EdgeInsets.only(left: 27.w, right: 20.w),
                alignment: Alignment.centerLeft,
                height: 45.h,
                width: 1.sw,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 0.5.w,
                      color: ksearchFieldColor,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 20.w),
                      child: Icon(
                        Icons.delete_outline_outlined,
                        color: ksecondaryColor,
                        size: 20.sp,
                      ),
                    ),
                    H3semi(text: Controller.getTag('delete')),
                    // Icon(
                    //   Icons.check,
                    //   color: kprimaryColor,
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
