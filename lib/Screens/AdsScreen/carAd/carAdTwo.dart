import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/addSummary.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/adsInputField.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/getCategory.dart';
import 'package:lisit_mobile_app/Models/addSummaryModel.dart';
import 'package:lisit_mobile_app/Screens/AdsScreen/carAd/widget/discardAdwidget.dart';
import 'package:lisit_mobile_app/Screens/AdsScreen/carAd/widget/extraCheckBox.dart';
import 'package:lisit_mobile_app/Screens/AdsScreen/carAd/widget/selectOptionforAd.dart';
import 'package:lisit_mobile_app/Screens/AdsScreen/carAd/widget/yearSelector.dart';
import 'package:lisit_mobile_app/Screens/motors/AdLastScreen.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class CarAdTwo extends StatefulWidget {
  String lastCategoryName;
  String lastCategoryNameAr;
  String categoryId;
  bool isFromCarAdOne;
  List<AddSummaryModel> ListingSummary;
  CarAdTwo({
    super.key,
    required this.ListingSummary,
    required this.categoryId,
    required this.lastCategoryName,
    required this.lastCategoryNameAr,
    this.isFromCarAdOne = false,
  });

  @override
  State<CarAdTwo> createState() => _CarAdTwoState();
}

class _CarAdTwoState extends State<CarAdTwo>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool showMore = true;
  String categoryName = '';
  String categoryNameAr = '';

  List<AddSummaryModel> summaryList = [];
  TextEditingController controller = TextEditingController();

  List addSelectedImageList = [];

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
      if (Controller.getEmirate() != null && widget.isFromCarAdOne != true) {
        Provider.of<AdsInputField>(context, listen: false).addSelectedItem(
            newItem: AddSummaryModel(
                name: 'Emirates',
                nameAr: Controller.getTag('emirates'),
                value: '${Controller.getEmirate()}',
                valueAr: '${Controller.getEmirate()}',
                field: 'Dropdown'),
            valuesList: Provider.of<AdsInputField>(context, listen: false)
                .carAdTwoSelectedValuesList);
      }
    });

    summaryList = widget.ListingSummary;
    categoryName = widget.lastCategoryName;
    categoryNameAr = widget.lastCategoryNameAr;
    // TODO: implement initState
    super.initState();
  }

  List controllerList = [];
  List<bool> isRequiredCheckList = [];

  Future getData() async {
    await Provider.of<AdsInputField>(context, listen: false)
        .getInputFields(context, categoryId: widget.categoryId, pageId: '2');
    isRequiredCheckList = Provider.of<AdsInputField>(context, listen: false)
        .adsInputFieldListDetails
        .map((e) => false)
        .toList();
    await Provider.of<AdsInputField>(context, listen: false).getLocation();
    controller.text =
        Provider.of<AdsInputField>(context, listen: false).completeAddress;
  }

  List<String> uploadedImgeLink = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        shadowColor: Colors.white,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: H2Bold(text: Controller.getTag('place_ad')),
        centerTitle: true,
        actions: [
          GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    shape: const BeveledRectangleBorder(),
                    context: context,
                    builder: (context) {
                      return DiscardAdWidget(
                        fromCarAdOne: widget.isFromCarAdOne,
                      );
                    });
              },
              child: Padding(
                padding: EdgeInsets.only(right: 15.w),
                child: const Icon(Icons.close),
              ))
        ],
        // elevation: 1,
      ),
      body: Container(
        height: 0.9.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 1.w,
              color: ksearchFieldColor,
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Consumer<AdsInputField>(builder: (context, value, child) {
              controllerList = List.generate(
                  value.adsInputFieldListDetails.length,
                  (i) => TextEditingController());
              return value.isLoading
                  ? Container(
                      alignment: Alignment.center,
                      height: 0.9.sh,
                      child: const CircularProgressIndicator())
                  : Column(
                      children: [
                        SizedBox(
                          height: 30.h,
                        ),
                        // you are almost there
                        H1Bold(text: Controller.getTag('almost_there')),
                        SizedBox(
                          height: 12.h,
                        ),
                        // include as much
                        Container(
                          alignment: Alignment.center,
                          width: 356.w,
                          child: H2Regular(
                              text: Controller.getTag('ad_post_guideline')),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),

                        // listing summary
                        if (summaryList.isNotEmpty)
                          Container(
                            margin: EdgeInsets.only(bottom: 10.h),
                            padding: EdgeInsets.only(
                                top: 25.h,
                                right: 20.w,
                                left: 20.w,
                                bottom: 18.h),
                            width: 390.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.r),
                              color: ksearchFieldColor,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    H2Bold(
                                        text: Controller.getTag(
                                            'listing_summary')),
                                    GestureDetector(
                                      onTap: () {
                                        // Navigator.pop(context);
                                      },
                                      child: H2Bold(
                                        text: Controller.getTag('edit'),
                                        color: kredText,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: List.generate(
                                    summaryList.length,
                                    (index) =>
                                        summaryList[index].field != 'Dropdown'
                                            ? Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5.h),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 200.w,
                                                      child: H3Regular(
                                                          text: Controller.languageChange(
                                                              english:
                                                                  summaryList[
                                                                          index]
                                                                      .name,
                                                              arabic:
                                                                  summaryList[
                                                                          index]
                                                                      .nameAr)),
                                                    ),
                                                    SizedBox(
                                                      child: H3semi(
                                                          text: Controller.languageChange(
                                                              english:
                                                                  summaryList[
                                                                          index]
                                                                      .value,
                                                              arabic:
                                                                  summaryList[
                                                                          index]
                                                                      .valueAr)),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Column(
                          children: List.generate(
                            value.adsInputFieldListDetails.length,
                            (index) {
                              log('${value.adsInputFieldListDetails.length}');
                              log('${isRequiredCheckList.length}');

                              final data =
                                  value.adsInputFieldListDetails[index];
                              switch (data.categoryTypeId) {
                                case "2":
                                  var dropdownList = value
                                      .dropdownValuesList[index]
                                      .toSet()
                                      .toList();
                                  // var dropdownList = data.attributes
                                  //     .map((e) => Controller.languageChange(
                                  //         english: e.attributeName,
                                  //         arabic: e.attributeNameAr))
                                  //     .toSet()
                                  //     .toList();
                                  // dropdownList.insert(
                                  //     0,
                                  //     Controller.languageChange(
                                  //         english: data.categoryFieldName,
                                  //         arabic:
                                  //             data.categoryFieldNameArabic));
                                  String dropdownSelectedValue() {
                                    String dropDownValue =
                                        Controller.languageChange(
                                            english: data.categoryFieldName,
                                            arabic:
                                                data.categoryFieldNameArabic);
                                    int existingIndex = value
                                        .carAdTwoSelectedValuesList
                                        .indexWhere((item) =>
                                            item.name ==
                                            Controller.languageChange(
                                                english: data.categoryFieldName,
                                                arabic: data
                                                    .categoryFieldNameArabic));

                                    if (existingIndex != -1) {
                                      // Item with the same name already exists, overwrite it
                                      dropDownValue = Controller.languageChange(
                                          english: value
                                              .carAdTwoSelectedValuesList[
                                                  existingIndex]
                                              .value,
                                          arabic: value
                                              .carAdTwoSelectedValuesList[
                                                  existingIndex]
                                              .valueAr);
                                    } else {
                                      // Item with the same name doesn't exist, add the new item

                                      dropDownValue = Controller.languageChange(
                                          english: data.categoryFieldName,
                                          arabic: data.categoryFieldNameArabic);
                                    }

                                    return dropDownValue;
                                  }
                                  // Add data.categoryFieldName at the 0th index
                                  return Padding(
                                    key: PageStorageKey<String>(
                                        Controller.languageChange(
                                            english: data.categoryFieldName,
                                            arabic: data
                                                .categoryFieldNameArabic)), // Use an appropriate key
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    child: SelectOptionForAd(
                                      adsInputFieldList:
                                          value.adsInputFieldListDetails,
                                      attributesList: data.attributes,
                                      isRequiredCheck: isRequiredCheckList,
                                      data: data,
                                      selectedOptionsList:
                                          value.carAdTwoSelectedValuesList,
                                      index: index,
                                      dropdownName: Controller.languageChange(
                                          english: data.categoryFieldName,
                                          arabic: data.categoryFieldNameArabic),
                                      dropDownValue: dropdownSelectedValue(),
                                      dropdownlist: dropdownList,
                                    ),
                                  );

                                case "6":
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    child: AdInputField(
                                        isRequiredCheck:
                                            isRequiredCheckList.isNotEmpty
                                                ? isRequiredCheckList[index]
                                                : false,
                                        controller: value
                                                .carAdTwoSelectedValuesList
                                                .any((e) {
                                          if (e.name ==
                                              Controller.languageChange(
                                                  english:
                                                      data.categoryFieldName,
                                                  arabic: data
                                                      .categoryFieldNameArabic)) {
                                            controllerList[index] =
                                                Controller.languageChange(
                                                    english: e.value,
                                                    arabic: e.valueAr);
                                            return true;
                                          } else {
                                            return false;
                                          }
                                        })
                                            ? TextEditingController(
                                                text: controllerList[index]
                                                    .toString())
                                            : null,
                                        onChanged: (newValue) {
                                          // isRequiredCheckList[index] = false;
                                          // final cursorPosition =
                                          //     controllerList[index]
                                          //         .selection
                                          //         .baseOffset;
                                          // setState(() {});
                                          // controllerList[index].selection =
                                          //     TextSelection.fromPosition(
                                          //         TextPosition(
                                          //             offset: cursorPosition));
                                          value.addSelectedItem(
                                              newItem: AddSummaryModel(
                                                  name: data.categoryFieldName,
                                                  nameAr: data
                                                      .categoryFieldNameArabic,
                                                  value: newValue.toString(),
                                                  valueAr: newValue.toString(),
                                                  field: data.categoryTypeName),
                                              valuesList: value
                                                  .carAdTwoSelectedValuesList);
                                        },
                                        title: Controller.languageChange(
                                            english: data.categoryFieldName,
                                            arabic:
                                                data.categoryFieldNameArabic),
                                        // controller: TextEditingController(),
                                        keybordType: TextInputType.number),
                                  );

                                case "1":
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    child: AdInputField(
                                        isRequiredCheck:
                                            isRequiredCheckList.isNotEmpty
                                                ? isRequiredCheckList[index]
                                                : false,
                                        controller: value
                                                .carAdTwoSelectedValuesList
                                                .any((e) {
                                          if (e.name ==
                                              Controller.languageChange(
                                                  english:
                                                      data.categoryFieldName,
                                                  arabic: data
                                                      .categoryFieldNameArabic)) {
                                            controllerList[index] =
                                                Controller.languageChange(
                                                    english: e.value,
                                                    arabic: e.valueAr);
                                            return true;
                                          } else {
                                            return false;
                                          }
                                        })
                                            ? TextEditingController(
                                                text: controllerList[index])
                                            : null,
                                        onChanged: (newValue) {
                                          // isRequiredCheckList[index] = false;
                                          // final cursorPosition =
                                          //     controllerList[index]
                                          //         .selection
                                          //         .baseOffset;
                                          // setState(() {});
                                          // controllerList[index].selection =
                                          //     TextSelection.fromPosition(
                                          //         TextPosition(
                                          //             offset: cursorPosition));
                                          value.addSelectedItem(
                                              newItem: AddSummaryModel(
                                                  name: data.categoryFieldName,
                                                  nameAr: data
                                                      .categoryFieldNameArabic,
                                                  value: newValue,
                                                  valueAr: newValue,
                                                  field: data.categoryTypeName),
                                              valuesList: value
                                                  .carAdTwoSelectedValuesList);

                                          // setState(() {});
                                        },
                                        title: Controller.languageChange(
                                            english: data.categoryFieldName,
                                            arabic:
                                                data.categoryFieldNameArabic),
                                        // controller: TextEditingController(),
                                        keybordType: TextInputType.name),
                                  );

                                case "3":
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        H2semi(
                                            text: Controller.languageChange(
                                                english: data.categoryFieldName,
                                                arabic: data
                                                    .categoryFieldNameArabic)),
                                        for (int index = 0;
                                            index < data.attributes.length;
                                            index++)
                                          RadioListTile(
                                              title: H3semi(
                                                  text:
                                                      Controller.languageChange(
                                                          english: data
                                                              .attributes[index]
                                                              .attributeName,
                                                          arabic: data
                                                              .attributes[index]
                                                              .attributeNameAr)),
                                              value: Controller.languageChange(
                                                  english: data
                                                      .attributes[index]
                                                      .attributeName,
                                                  arabic: data.attributes[index]
                                                      .attributeNameAr),
                                              groupValue:
                                                  data.categoryFieldName,
                                              onChanged: (newValue) {
                                                data.categoryFieldName =
                                                    newValue!;
                                                value.addSelectedItem(
                                                    newItem: AddSummaryModel(
                                                        name: data
                                                            .categoryFieldName,
                                                        nameAr: data
                                                            .categoryFieldNameArabic,
                                                        value: newValue,
                                                        valueAr: newValue,
                                                        field: data
                                                            .categoryTypeName),
                                                    valuesList: value
                                                        .carAdTwoSelectedValuesList);
                                                //         .value =
                                                // data.attributes[index]
                                                //     .systemValue;
                                                // setState(() {});
                                                setState(() {});
                                              }),
                                      ],
                                    ),
                                  );

                                case "4":
                                  return SizedBox(
                                    height: showMore == true
                                        ? 300.h
                                        : (double.parse((24 *
                                                            value
                                                                .adsInputFieldListDetails[
                                                                    index]
                                                                .attributes
                                                                .length)
                                                        .toString())
                                                    .h /
                                                2) +
                                            48.h,
                                    width: 1.sw,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              H2semi(
                                                  text: Controller.languageChange(
                                                      english: data
                                                          .categoryFieldName,
                                                      arabic: data
                                                          .categoryFieldNameArabic)),
                                              GestureDetector(
                                                onTap: () {
                                                  showMore = !showMore;
                                                  setState(() {});
                                                },
                                                child: H3semi(
                                                  text: showMore == true
                                                      ? Controller.getTag(
                                                          'show_more')
                                                      : Controller.getTag(
                                                          'show_less'),
                                                  color: kprimaryColor,
                                                ),
                                              )
                                            ],
                                          ),
                                          Expanded(
                                            child: GridView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  childAspectRatio:
                                                      0.45.sw / 24.h,
                                                ),
                                                itemCount: showMore
                                                    ? data.attributes.length >
                                                            22
                                                        ? 22
                                                        : data.attributes.length
                                                    : data.attributes.length,
                                                itemBuilder:
                                                    (context, attributesIndex) {
                                                  return SizedBox(
                                                    width: 0.45.sw,
                                                    child: ExtraCheckBox(
                                                      selectedOptionsList: value
                                                          .carAdTwoSelectedValuesList,
                                                      mainListIndex: index,
                                                      data: data,
                                                      attributeIndex:
                                                          attributesIndex,
                                                      label: Controller.languageChange(
                                                          english: data
                                                              .attributes[
                                                                  attributesIndex]
                                                              .attributeName,
                                                          arabic: data
                                                              .attributes[
                                                                  attributesIndex]
                                                              .attributeNameAr),
                                                      isChecked: value
                                                          .carAdTwoSelectedValuesList
                                                          .any((item) =>
                                                              item.name ==
                                                              '${data.categoryFieldName}[${data.attributes[attributesIndex].attributeName}]'),
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );

                                case "7":
                                  return Container(
                                    alignment: Alignment.topLeft,
                                    height: 210.h,
                                    width: 350.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.r),
                                      border: Border.all(
                                        width: 1,
                                        color: isRequiredCheckList.isNotEmpty &&
                                                isRequiredCheckList[index]
                                            ? kredColor
                                            : khelperTextColor,
                                      ),
                                    ),
                                    child: TextField(
                                      controller: value
                                              .carAdTwoSelectedValuesList
                                              .any((e) {
                                        if (e.name ==
                                            Controller.languageChange(
                                                english: data.categoryFieldName,
                                                arabic: data
                                                    .categoryFieldNameArabic)) {
                                          controllerList[index] =
                                              Controller.languageChange(
                                                  english: e.value,
                                                  arabic: e.valueAr);
                                          return true;
                                        } else {
                                          return false;
                                        }
                                      })
                                          ? TextEditingController(
                                              text: controllerList[index])
                                          : null,
                                      onChanged: (newValue) {
                                        // isRequiredCheckList[index] = false;
                                        // final cursorPosition =
                                        //     controllerList[index]
                                        //         .selection
                                        //         .baseOffset;
                                        // setState(() {});
                                        // controllerList[index].selection =
                                        //     TextSelection.fromPosition(
                                        //         TextPosition(
                                        //             offset: cursorPosition));
                                        if (newValue.contains('http//:') ||
                                            newValue.contains('https//:') ||
                                            newValue.contains('.com') ||
                                            newValue.contains('http')) {
                                          DisplayMessage(
                                              context: context,
                                              isTrue: false,
                                              message: Controller.getTag(
                                                  "please_don't_add_any_external_links"));
                                        } else {
                                          value.addSelectedItem(
                                              newItem: AddSummaryModel(
                                                  name: data.categoryFieldName,
                                                  nameAr: data
                                                      .categoryFieldNameArabic,
                                                  value: newValue,
                                                  valueAr: newValue,
                                                  field: data.categoryTypeName),
                                              valuesList: value
                                                  .carAdTwoSelectedValuesList);
                                        }
                                      },
                                      maxLines: 15,
                                      keyboardType: TextInputType.multiline,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontFamily: Controller.getLanguage()
                                                    .toString()
                                                    .toLowerCase() ==
                                                "english"
                                            ? GoogleFonts.montserrat()
                                                .fontFamily
                                            : GoogleFonts.tajawal().fontFamily,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            top: 20.h, right: 10.w, left: 10.w),
                                        hintText: Controller.getTag(
                                            'describe_your_cars'),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  );

                                case "8":
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          String response = await context
                                              .read<AddSummary>()
                                              .uploadNewPhotos();

                                          if (response.isNotEmpty) {
                                            if (addSelectedImageList.isEmpty) {
                                              addSelectedImageList = response
                                                  .toString()
                                                  .split(',')
                                                  .map((e) => e)
                                                  .toList();
                                            } else {
                                              addSelectedImageList.addAll(
                                                  response
                                                      .toString()
                                                      .split(','));
                                            }

                                            // uploadedImgeLink =
                                            //     response.split(',');
                                            // value.addSelectedItem(
                                            //     newItem: AddSummaryModel(
                                            //         name:
                                            //             data.categoryFieldName,
                                            //         nameAr: data
                                            //             .categoryFieldNameArabic,
                                            //         value: response,
                                            //         valueAr: response,
                                            //         field:
                                            //             data.categoryTypeName),
                                            //     valuesList: value
                                            //         .carAdTwoSelectedValuesList);
                                          } else {
                                            print('failed');
                                          }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10.h),
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.h),
                                          width: 350.w,
                                          height: 48.h,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 2.w,
                                              color: isRequiredCheckList
                                                          .isNotEmpty &&
                                                      isRequiredCheckList[index]
                                                  ? kredColor
                                                  : khelperTextColor,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/camera.svg'),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Provider.of<AddSummary>(context)
                                                      .isImageUploading
                                                  ? SizedBox(
                                                      height: 20.h,
                                                      width: 20.w,
                                                      child: const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                    )
                                                  : H3semi(
                                                      text: Controller.getTag(
                                                          'add_pictures')),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 20.w, left: 10.w),
                                          child: Row(
                                            children: List.generate(
                                              addSelectedImageList.length,
                                              (index) => Stack(
                                                alignment: Alignment.topRight,
                                                children: [
                                                  Container(
                                                    clipBehavior: Clip.hardEdge,
                                                    margin: EdgeInsets.only(
                                                        bottom: 10.h,
                                                        left: 10.w),
                                                    height: 173.h,
                                                    width: 173.w,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.r),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color:
                                                              Color(0x19000000),
                                                          blurRadius: 10,
                                                          offset: Offset(0, 10),
                                                          spreadRadius: 0,
                                                        )
                                                      ],
                                                    ),
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          addSelectedImageList[
                                                              index],
                                                      placeholder:
                                                          (context, url) =>
                                                              const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Center(
                                                              child: Icon(Icons
                                                                  .error_outline)),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      addSelectedImageList
                                                          .removeAt(index);
                                                      log('$index');
                                                      setState(() {});
                                                    },
                                                    child: Icon(
                                                      Icons.close,
                                                      color: kbackgrounColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );

                                case "9":
                                  String dropdownSelectedValue() {
                                    String dropDownValue =
                                        Controller.languageChange(
                                            english: data.categoryFieldName,
                                            arabic:
                                                data.categoryFieldNameArabic);
                                    int existingIndex = value
                                        .carAdTwoSelectedValuesList
                                        .indexWhere((item) =>
                                            item.name ==
                                            Controller.languageChange(
                                                english: data.categoryFieldName,
                                                arabic: data
                                                    .categoryFieldNameArabic));

                                    if (existingIndex != -1) {
                                      // Item with the same name already exists, overwrite it
                                      dropDownValue = value
                                          .carAdTwoSelectedValuesList[
                                              existingIndex]
                                          .value;
                                    } else {
                                      // Item with the same name doesn't exist, add the new item
                                      dropDownValue = Controller.languageChange(
                                          english: data.categoryFieldName,
                                          arabic: data.categoryFieldNameArabic);
                                    }

                                    return dropDownValue;
                                  }
                                  return YearSelector(
                                    isRequiredCheck: isRequiredCheckList,
                                    data: data,
                                    selectedOptionsList:
                                        value.carAdTwoSelectedValuesList,
                                    index: index,
                                    dropDownValue: dropdownSelectedValue(),
                                  );

                                // case "9":
                                //   int currentYear = DateTime.now().year;
                                //
                                //   List<String> dropdownList = List.generate(
                                //           currentYear - 1970 + 1,
                                //           (index) => (1970 + index).toString())
                                //       .reversed
                                //       .toList();
                                //   dropdownList.insert(
                                //       0,
                                //       Controller.languageChange(
                                //           english: data.categoryFieldName,
                                //           arabic:
                                //               data.categoryFieldNameArabic));
                                //   String dropdownSelectedValue() {
                                //     String dropDownValue =
                                //         Controller.languageChange(
                                //             english: data.categoryFieldName,
                                //             arabic:
                                //                 data.categoryFieldNameArabic);
                                //     int existingIndex = value
                                //         .carAdTwoSelectedValuesList
                                //         .indexWhere((item) =>
                                //             item.name ==
                                //             Controller.languageChange(
                                //                 english: data.categoryFieldName,
                                //                 arabic: data
                                //                     .categoryFieldNameArabic));
                                //
                                //     if (existingIndex != -1) {
                                //       // Item with the same name already exists, overwrite it
                                //       dropDownValue = value
                                //           .carAdTwoSelectedValuesList[
                                //               existingIndex]
                                //           .value;
                                //     } else {
                                //       // Item with the same name doesn't exist, add the new item
                                //       dropDownValue = Controller.languageChange(
                                //           english: data.categoryFieldName,
                                //           arabic: data.categoryFieldNameArabic);
                                //     }
                                //
                                //     return dropDownValue;
                                //   }
                                //   // Add data.categoryFieldName at the 0th index
                                //   return Padding(
                                //     key: PageStorageKey<String>(
                                //         Controller.languageChange(
                                //             english: data.categoryFieldName,
                                //             arabic: data
                                //                 .categoryFieldNameArabic)), // Use an appropriate key
                                //     padding:
                                //         EdgeInsets.symmetric(vertical: 10.h),
                                //     child: SelectOptionForAd(
                                //       attributesList: [],
                                //       isRequiredCheck: isRequiredCheckList,
                                //       data: data,
                                //       selectedOptionsList:
                                //           value.carAdTwoSelectedValuesList,
                                //       index: index,
                                //       dropdownName: Controller.languageChange(
                                //           english: data.categoryFieldName,
                                //           arabic: data.categoryFieldNameArabic),
                                //       dropDownValue: dropdownSelectedValue(),
                                //       dropdownlist: dropdownList,
                                //     ),
                                //   );
                                case "10":

                                  // Add data.categoryFieldName at the 0th index
                                  return SizedBox(
                                    height: 70.h,
                                    child: Padding(
                                      key: PageStorageKey<String>(
                                          Controller.languageChange(
                                              english: data.categoryFieldName,
                                              arabic: data
                                                  .categoryFieldNameArabic)), // Use an appropriate key
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.h, horizontal: 30.w),
                                      child: GooglePlaceAutoCompleteTextField(
                                        focusNode: focusNode,
                                        textStyle: TextStyle(
                                          fontSize: 14.sp,
                                          fontFamily: Controller.getLanguage()
                                                      .toString()
                                                      .toLowerCase() ==
                                                  "english"
                                              ? GoogleFonts.montserrat()
                                                  .fontFamily
                                              : GoogleFonts.tajawal()
                                                  .fontFamily,
                                          fontWeight: FontWeight.w600,
                                          color: ksecondaryColor,
                                        ),
                                        boxDecoration: BoxDecoration(
                                          border: Border.all(
                                            width: 2.w,
                                            color: isRequiredCheckList
                                                        .isNotEmpty &&
                                                    isRequiredCheckList[index]
                                                ? kredColor
                                                : khelperTextColor,
                                          ),
                                        ),
                                        textEditingController: controller,

                                        googleAPIKey: "",
                                        inputDecoration: InputDecoration(
                                          // labelText: 'Add Location',
                                          hintText:
                                              Controller.getTag('add_location'),
                                          contentPadding: EdgeInsets.only(
                                              right: 0.w, left: 10.w),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                        ),

                                        // debounceTime: 800 // default 600 ms,
                                        countries: [
                                          'ae',
                                        ], // optional by default null is set
                                        isLatLngRequired:
                                            true, // if you required coordinates from place detail
                                        getPlaceDetailWithLatLng: (prediction) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          value.getLatLangFromAdress(
                                              prediction: prediction);
                                          // this method will return latlng with place detail
                                        }, // this callback is called when isLatLngRequired is true
                                        itemClick: (prediction) {
                                          focusNode.unfocus();

                                          controller.text =
                                              prediction.description!;
                                          controller.selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: prediction
                                                          .description!
                                                          .length));
                                        },
                                        // if we want to make custom list item builder
                                        itemBuilder:
                                            (context, index, prediction) {
                                          return Container(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.location_on),
                                                const SizedBox(
                                                  width: 7,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                        "${prediction.description ?? ""}"))
                                              ],
                                            ),
                                          );
                                        },
                                        seperatedBuilder: const Divider(),
                                        isCrossBtnShown: true,
                                        containerHorizontalPadding: 0,
                                      ),
                                    ),
                                  );
                                // case "10":

                                //   // Add data.categoryFieldName at the 0th index
                                //   return Padding(
                                //     key: PageStorageKey<String>(data
                                //         .categoryFieldName), // Use an appropriate key
                                //     padding:
                                //         EdgeInsets.symmetric(vertical: 10.h),
                                //     child: Container(
                                //       alignment: Alignment.centerLeft,
                                //       width: 350.w,
                                //       height: 48.h,
                                //       decoration: BoxDecoration(
                                //         border: Border.all(
                                //           width: 2.w,
                                //           color:
                                //               isRequiredCheckList.isNotEmpty &&
                                //                       isRequiredCheckList[index]
                                //                   ? kredColor
                                //                   : khelperTextColor,
                                //         ),
                                //       ),
                                //       child: H3semi(
                                //         text: '${value.completeAddress}',
                                //         maxLines: 1,
                                //       ),
                                //     ),
                                //   );
                                default:
                                  return Center(
                                    child: H2Bold(
                                        text: Controller.getTag('no_data')),
                                  );
                              }
                            },
                          ),
                        ),

                        SizedBox(
                          width: 380.w,
                          child: H3Regular(
                              text: Controller.getTag('confirm_details')),
                        ),
                        // next button
                        Padding(
                          padding: EdgeInsets.only(top: 30.h, bottom: 20.h),
                          child: SizedBox(
                            height: 47.h,
                            child: MainButton(
                              text: Controller.getTag('next'),
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                if (addSelectedImageList.isNotEmpty) {
                                  value.addSelectedItem(
                                      newItem: AddSummaryModel(
                                          name: 'Add Pictures',
                                          nameAr:
                                              Controller.getTag('add_pictures'),
                                          value: addSelectedImageList.join(','),
                                          valueAr:
                                              addSelectedImageList.join(','),
                                          field: 'File'),
                                      valuesList:
                                          value.carAdTwoSelectedValuesList);
                                }
                                value.addSelectedItem(
                                    newItem: AddSummaryModel(
                                        name: 'Add Location',
                                        nameAr:
                                            Controller.getTag('add_location'),
                                        value:
                                            '${controller.text}_${value.latitude}_${value.longitude}',
                                        valueAr:
                                            '${controller.text}_${value.latitude}_${value.longitude}',
                                        field: 'Location'),
                                    valuesList:
                                        value.carAdTwoSelectedValuesList);

                                value.selectedValueList = [
                                  ...summaryList,
                                  ...value.carAdTwoSelectedValuesList
                                ];
                                value.carAdTwoSelectedValuesList.forEach((e) {
                                  print(e.name);
                                  print(e.field);
                                  print(e.value);
                                  print(e.valueAr);
                                });

                                for (int i = 0;
                                    i < value.adsInputFieldListDetails.length;
                                    i++) {
                                  if (value.adsInputFieldListDetails[i]
                                          .isRequired ==
                                      true) {
                                    bool containField =
                                        value.carAdTwoSelectedValuesList.any(
                                      (element) {
                                        if (element.name ==
                                            value.adsInputFieldListDetails[i]
                                                .categoryFieldName) {
                                          if (element.name == 'Price') {
                                            if (int.parse(
                                                    element.value.toString()) <
                                                2000) {
                                              return false;
                                            } else {
                                              return true;
                                            }
                                          } else if (element.name == 'Year') {
                                            if (element.value
                                                    .toString()
                                                    .length !=
                                                4) {
                                              return false;
                                            } else {
                                              return true;
                                            }
                                          } else if (element.name ==
                                              'Kilometers') {
                                            if (element.value
                                                    .toString()
                                                    .length >
                                                15) {
                                              return false;
                                            } else {
                                              return true;
                                            }
                                          } else if (element.name ==
                                              'Phone Number') {
                                            if (element.value
                                                        .toString()
                                                        .length <
                                                    7 ||
                                                element.value
                                                        .toString()
                                                        .length >
                                                    15) {
                                              return false;
                                            } else {
                                              return true;
                                            }
                                          } else if (element.name == 'Title') {
                                            if (element.value
                                                        .toString()
                                                        .length <
                                                    2 ||
                                                element.value
                                                        .toString()
                                                        .length >
                                                    60) {
                                              return false;
                                            } else {
                                              return true;
                                            }
                                          } else {
                                            return true;
                                          }
                                        } else {
                                          return false;
                                        }
                                      },
                                    );
                                    if (containField) {
                                      isRequiredCheckList[i] = false;
                                    } else {
                                      isRequiredCheckList[i] = true;
                                    }
                                  }
                                  setState(() {});
                                }

                                print(isRequiredCheckList);
                                log('next is pressed');
                                setState(() {});
                                if (!isRequiredCheckList.contains(true)) {
                                  log('not contains true');
                                  if (context
                                          .read<GetCategory>()
                                          .subCategoryiesList
                                          .length >
                                      2) {
                                    for (var i = 2;
                                        i <
                                            context
                                                .read<GetCategory>()
                                                .subCategoryiesList
                                                .length;
                                        i++) {
                                      value.selectedValueList.add(
                                          AddSummaryModel(
                                              name: 'Sub Category ${i - 1}',
                                              nameAr: '${i - 1} الفئة الفرعية',
                                              value: context
                                                  .read<GetCategory>()
                                                  .subCategoryiesList[i]
                                                  .name,
                                              valueAr: context
                                                  .read<GetCategory>()
                                                  .subCategoryiesList[i]
                                                  .nameAr,
                                              field: 'subcategory'));
                                    }
                                  }
                                  value.selectedValueList.insert(
                                      0,
                                      AddSummaryModel(
                                          name: 'Category',
                                          nameAr: 'فئة',
                                          value: categoryName,
                                          valueAr: categoryNameAr,
                                          field: 'category'));
                                  for (var item in value.selectedValueList) {
                                    if (item.field == 'Number') {
                                      item.value =
                                          int.parse(item.value.toString());
                                      item.valueAr =
                                          int.parse(item.valueAr.toString());
                                    }
                                  }
                                  String allSubCategoriesName = '';
                                  String mainCategoryName =
                                      categoryName.replaceAll(' ', '-');
                                  String adTitle = '';
                                  String adEmirate = '';
                                  int adPrice = 0;

                                  for (var i = 2;
                                      i <
                                          context
                                              .read<GetCategory>()
                                              .subCategoryiesList
                                              .length;
                                      i++) {
                                    allSubCategoriesName +=
                                        '/${context.read<GetCategory>().subCategoryiesList[i].name}'
                                            .replaceAll(' ', '-');
                                  }

                                  for (var i = 0;
                                      i < value.selectedValueList.length;
                                      i++) {
                                    if (value.selectedValueList[i].name ==
                                        'Title') {
                                      adTitle = value.selectedValueList[i].value
                                          .toString()
                                          .replaceAll(' ', '-');
                                    }
                                    if (value.selectedValueList[i].name ==
                                        'Emirates') {
                                      adEmirate = value
                                          .selectedValueList[i].value
                                          .toString()
                                          .replaceAll(' ', '-');
                                    }

                                    if (value.selectedValueList[i].name ==
                                        'Price') {
                                      adPrice = int.parse(value
                                          .selectedValueList[i].value
                                          .toString());
                                    }
                                  }

                                  value.selectedValueList.add(
                                    AddSummaryModel(
                                        name: "ad_link",
                                        nameAr: "رابط الإعلان",
                                        value:
                                            "${adEmirate}/${mainCategoryName}${allSubCategoriesName}/${adTitle}",
                                        valueAr:
                                            "${adEmirate}/${mainCategoryName}${allSubCategoriesName}/${adTitle}",
                                        field: "link"),
                                  );
                                  value.selectedValueList.add(AddSummaryModel(
                                      name: "meta_title",
                                      nameAr: "عنوان الفوقية",
                                      value:
                                          "Check out ${adTitle} for sale in ${adEmirate} selling for AED ${adPrice}. Find great ${allSubCategoriesName} listings in UAE at Listit.ae",
                                      valueAr:
                                          "Check out ${adTitle} for sale in ${adEmirate} selling for AED ${adPrice}. Find great ${allSubCategoriesName} listings in UAE at Listit.ae",
                                      field: "meta_title"));

                                  value.selectedValueList.add(AddSummaryModel(
                                      name: "meta_description",
                                      nameAr: "ميتا الوصف",
                                      value:
                                          "Check this Ad ${adTitle} selling for AED ${adPrice} in ${adEmirate}. Checkout all Listings of ${mainCategoryName} in ${allSubCategoriesName} in ${adEmirate}. Listit.ae helps you buy, sell all kinds of motors, cars, bikes, boats, trucks in <city> and across UAE. Want to sell something in ${adEmirate}, just list your item today at Listit completely FREE!",
                                      valueAr:
                                          "Check this Ad ${adTitle} selling for AED ${adPrice} in ${adEmirate}. Checkout all Listings of ${mainCategoryName} in ${allSubCategoriesName} in ${adEmirate}. Listit.ae helps you buy, sell all kinds of motors, cars, bikes, boats, trucks in <city> and across UAE. Want to sell something in ${adEmirate}, just list your item today at Listit completely FREE!",
                                      field: "meta_description"));

                                  value.selectedValueList.add(AddSummaryModel(
                                      name: "img_alt_text",
                                      nameAr: "عنوان الفوقية",
                                      value:
                                          "${adTitle} in ${allSubCategoriesName} in ${adEmirate} at AED ${adPrice}",
                                      valueAr:
                                          "${adTitle} in ${allSubCategoriesName} in ${adEmirate} at AED ${adPrice}",
                                      field: "img_alt_text"));

                                  value.carAdTwoSelectedValuesList
                                      .forEach((element) {
                                    log('${element.name}');
                                    log('${element.value}');

                                    log('${element.field}');
                                  });

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdLastScreen(
                                        selectedValueList:
                                            value.selectedValueList,
                                      ),
                                    ),
                                  );

                                  FocusManager.instance.primaryFocus?.unfocus();
                                } else {
                                  DisplayMessage(
                                      context: context,
                                      isTrue: false,
                                      message: Controller.getTag(
                                          'please_fill_in_all_mandatory_fields'));
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    );
            });
          }),
        ),
      ),
    );
  }
}
