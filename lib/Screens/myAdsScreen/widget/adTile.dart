import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/deleteMyAd.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class AdTile extends StatefulWidget {
  String title;
  String price;
  String lastDate;
  bool isSelected;
  Widget image;
  String status;
  String adId;
  Function() onTap;
  AdTile({
    required this.adId,
    required this.image,
    required this.title,
    required this.price,
    required this.lastDate,
    required this.isSelected,
    required this.onTap,
    required this.status,
    super.key,
  });

  @override
  State<AdTile> createState() => _AdTileState();
}

class _AdTileState extends State<AdTile> {
  @override
  Widget build(BuildContext context) {
    log('ads status ${widget.status}');
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          color: kbackgrounColor,
          borderRadius: BorderRadius.circular(6.r),
          boxShadow: [
            BoxShadow(
              blurRadius: 8.w,
              color: khelperTextColor.withOpacity(0.2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox.shrink(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // check box
                // if (widget.status != 'Deleted')
                !widget.status.toLowerCase().toString().contains('delete')
                    ? Checkbox(
                        activeColor: kprimaryColor,
                        value: widget.isSelected,
                        onChanged: (value) {
                          context
                              .read<DeleteMyAdProvider>()
                              .addIdtoSelectedList(adId: widget.adId);
                          // widget.isSelected = value!;
                          // setState(() {});
                        },
                      )
                    : SizedBox(
                        width: 26.w,
                      ),

                GestureDetector(
                  onTap: widget.onTap,
                  child: SizedBox(
                    child: Row(
                      children: [
                        //image
                        Container(
                          clipBehavior: Clip.hardEdge,
                          width: 87.w,
                          height: 88.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: widget.image,
                        ),
                        //data
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          width: 202.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // title
                              H3semi(text: widget.title),

                              // under review button
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(vertical: 5.h),
                                padding: EdgeInsets.symmetric(horizontal: 3.w),
                                height: 14.h,
                                width: 67.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.r),
                                  color: kredText.withOpacity(
                                    0.2,
                                  ),
                                ),
                                child: Text(
                                  '${widget.status}',
                                  style: TextStyle(
                                    fontSize: 8.sp,
                                    fontFamily:
                                        GoogleFonts.montserrat().fontFamily,
                                    color: kredText,
                                  ),
                                ),
                              ),

                              // price

                              ParaRegular(
                                text: widget.price,
                              ),

                              // Data

                              SizedBox(
                                width: 200.w,
                                child: ParaRegular(
                                  maxLines: 2,
                                  text:
                                      '${Controller.getTag('last_updated')} : ${widget.lastDate}',
                                  color: ksecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Icons

                        const Icon(Icons.arrow_forward_ios_rounded),
                      ],
                    ),
                  ),
                ),
                const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
