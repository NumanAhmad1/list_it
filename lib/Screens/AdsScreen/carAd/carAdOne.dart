import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/addSummary.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/adsInputField.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/getDetailsbyVin.dart';
import 'package:lisit_mobile_app/Models/addSummaryModel.dart';
import 'package:lisit_mobile_app/Models/adsInputFieldsModel.dart';
import 'package:lisit_mobile_app/Screens/AdsScreen/carAd/carAdTwo.dart';
import 'package:lisit_mobile_app/Screens/AdsScreen/carAd/widget/discardAdwidget.dart';
import 'package:lisit_mobile_app/Screens/AdsScreen/carAd/widget/extraCheckBox.dart';
import 'package:lisit_mobile_app/Screens/AdsScreen/carAd/widget/selectOptionforAd.dart';
import 'package:lisit_mobile_app/Screens/AdsScreen/carAd/widget/yearSelector.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class CarAdOne extends StatefulWidget {
  String lastCategoreyName;
  String lastCategoreyNameAr;
  CarAdOne(
      {super.key,
      required this.lastCategoreyName,
      required this.lastCategoreyNameAr});

  @override
  State<CarAdOne> createState() => _CarAdOneState();
}

class _CarAdOneState extends State<CarAdOne> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData().then((value) {
        Map data = context.read<GetDetailsbyVin>().carData;
        List<AdsInputFieldsModel> fieldsLength =
            context.read<AdsInputField>().adsInputFieldListSummary;
        data.forEach((key, value) {
          for (var i = 0; i < fieldsLength.length; i++) {
            if (fieldsLength[i].categoryFieldName.toLowerCase() ==
                key.toString().toLowerCase()) {
              context.read<AdsInputField>().addSelectedItem(
                  newItem: AddSummaryModel(
                      name: fieldsLength[i].categoryFieldName,
                      nameAr: fieldsLength[i].categoryFieldNameArabic,
                      value: value,
                      valueAr: value,
                      field: fieldsLength[i].categoryTypeName),
                  valuesList:
                      context.read<AdsInputField>().carAdOneSelectedValuesList);
            }
          }
        });
      });
    });

    categoryName = widget.lastCategoreyName;
    categoryNameAr = widget.lastCategoreyNameAr;

    if (Controller.getEmirate() != null) {
      Provider.of<AdsInputField>(context, listen: false).addSelectedItem(
          newItem: AddSummaryModel(
              name: 'Emirates',
              nameAr: '${Controller.getTag('emirates')}',
              value: '${Controller.getEmirate()}',
              valueAr: '${Controller.getEmirate()}',
              field: 'Dropdown'),
          valuesList: Provider.of<AdsInputField>(context, listen: false)
              .carAdOneSelectedValuesList);
    }

    // TODO: implement initState
    super.initState();
  }

  String categoryName = '';
  String categoryNameAr = '';

  Future getData() async {
    await Provider.of<AdsInputField>(context, listen: false)
        .getInputFields(context, categoryId: '135', pageId: '1');

    isRequiredCheckList = Provider.of<AdsInputField>(context, listen: false)
        .adsInputFieldListSummary
        .map((e) => false)
        .toList();
  }

  List controllerList = [];
  List<bool> isRequiredCheckList = [];

  final ImagePicker picker = ImagePicker();

  getImages({required AdsInputFieldsModel data}) async {
    // Pick multiple images.
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isNotEmpty) {
      data.attributes =
          images.map((e) => File(e.path)).toList() as List<Attribute>;
      setState(() {});
    }
    print(images);
    print(data.attributes);
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // leading: GestureDetector(
        //     onTap: () {
        //       Navigator.pop(context);
        //     },
        //     child: const Icon(Icons.keyboard_arrow_left_outlined)),
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
                        fromCarAdOne: true,
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
      body: SingleChildScrollView(
        child: Consumer<AdsInputField>(builder: (context, value, child) {
          return value.isLoading
              ? Container(
                  height: 0.9.sh,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator())
              : value.adsInputFieldListSummary.isEmpty
                  ? Center(child: H2Bold(text: Controller.getTag('no_data')))
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Column(
                              children: List.generate(
                                value.adsInputFieldListSummary.length,
                                (index) {
                                  final data =
                                      value.adsInputFieldListSummary[index];
                                  controllerList = List.generate(
                                      value.adsInputFieldListSummary.length,
                                      (i) => TextEditingController());

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
                                      //         arabic: data
                                      //             .categoryFieldNameArabic));
                                      String dropdownSelectedValue() {
                                        String dropDownValue =
                                            Controller.languageChange(
                                                english: data.categoryFieldName,
                                                arabic: data
                                                    .categoryFieldNameArabic);
                                        int existingIndex = value
                                            .carAdOneSelectedValuesList
                                            .indexWhere((item) =>
                                                item.name ==
                                                Controller.languageChange(
                                                    english:
                                                        data.categoryFieldName,
                                                    arabic: data
                                                        .categoryFieldNameArabic));

                                        if (existingIndex != -1) {
                                          // Item with the same name already exists, overwrite it
                                          dropDownValue = Controller.languageChange(
                                              english: value
                                                  .carAdOneSelectedValuesList[
                                                      existingIndex]
                                                  .value,
                                              arabic: value
                                                  .carAdOneSelectedValuesList[
                                                      existingIndex]
                                                  .valueAr);
                                        } else {
                                          // Item with the same name doesn't exist, add the new item

                                          dropDownValue =
                                              Controller.languageChange(
                                                  english:
                                                      data.categoryFieldName,
                                                  arabic: data
                                                      .categoryFieldNameArabic);
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
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.h),
                                        child: SelectOptionForAd(
                                          adsInputFieldList:
                                              value.adsInputFieldListSummary,
                                          attributesList: data.attributes,
                                          isRequiredCheck: isRequiredCheckList,
                                          data: data,
                                          selectedOptionsList:
                                              value.carAdOneSelectedValuesList,
                                          index: index,
                                          dropdownName:
                                              Controller.languageChange(
                                                  english:
                                                      data.categoryFieldName,
                                                  arabic: data
                                                      .categoryFieldNameArabic),
                                          dropDownValue:
                                              dropdownSelectedValue(),
                                          dropdownlist: dropdownList,
                                        ),
                                      );

                                    case "6":
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.h),
                                        child: AdInputField(
                                            isRequiredCheck:
                                                isRequiredCheckList[index],
                                            // value
                                            //                 .carAdTwoSelectedValuesList
                                            //                 .any((item) =>
                                            //                     item.name ==
                                            //                     '${data.categoryFieldName}[${data.attributes[attributesIndex].attributeName}]')
                                            controller: value
                                                    .carAdOneSelectedValuesList
                                                    .any((e) {
                                              if (e.name ==
                                                  Controller.languageChange(
                                                      english: data
                                                          .categoryFieldName,
                                                      arabic: data
                                                          .categoryFieldNameArabic)) {
                                                controllerList[index] =
                                                    Controller.languageChange(
                                                        english:
                                                            e.value.toString(),
                                                        arabic: e.valueAr
                                                            .toString());
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
                                              // isRequiredCheckList[index] =
                                              //     false;
                                              // final cursorPosition =
                                              //     controllerList[index]
                                              //         .selection
                                              //         .baseOffset;
                                              // setState(() {});
                                              // controllerList[index].selection =
                                              //     TextSelection.fromPosition(
                                              //         TextPosition(
                                              //             offset:
                                              //                 cursorPosition));
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
                                                      .carAdOneSelectedValuesList);
                                            },
                                            title: Controller.languageChange(
                                                english: data.categoryFieldName,
                                                arabic: data
                                                    .categoryFieldNameArabic),
                                            // controller: TextEditingController(),
                                            keybordType: TextInputType.number),
                                      );

                                    case "1":
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.h),
                                        child: AdInputField(
                                            isRequiredCheck:
                                                isRequiredCheckList[index],
                                            controller: value
                                                    .carAdOneSelectedValuesList
                                                    .any((e) {
                                              if (e.name ==
                                                  data.categoryFieldName) {
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
                                              // isRequiredCheckList[index] =
                                              //     false;
                                              // final cursorPosition =
                                              //     controllerList[index]
                                              //         .selection
                                              //         .baseOffset;
                                              // setState(() {});
                                              // controllerList[index].selection =
                                              //     TextSelection.fromPosition(
                                              //         TextPosition(
                                              //             offset:
                                              //                 cursorPosition));
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
                                                      .carAdOneSelectedValuesList);

                                              // setState(() {});
                                            },
                                            title: Controller.languageChange(
                                                english: data.categoryFieldName,
                                                arabic: data
                                                    .categoryFieldNameArabic),
                                            // controller: TextEditingController(),
                                            keybordType: TextInputType.text),
                                      );

                                    case "3":
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.h),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            H2semi(
                                                text: Controller.languageChange(
                                                    english:
                                                        data.categoryFieldName,
                                                    arabic: data
                                                        .categoryFieldNameArabic)),
                                            for (int index = 0;
                                                index < data.attributes.length;
                                                index++)
                                              RadioListTile(
                                                  title: H3semi(
                                                      text: Controller
                                                          .languageChange(
                                                              english: data
                                                                  .attributes[
                                                                      index]
                                                                  .attributeName,
                                                              arabic: data
                                                                  .attributes[
                                                                      index]
                                                                  .attributeNameAr)),
                                                  value:
                                                      Controller.languageChange(
                                                          english: data
                                                              .attributes[index]
                                                              .attributeName,
                                                          arabic: data
                                                              .attributes[index]
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
                                                            .carAdOneSelectedValuesList);
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
                                        height: 300.h,
                                        width: 1.sw,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            H2semi(
                                                text: Controller.languageChange(
                                                    english:
                                                        data.categoryFieldName,
                                                    arabic: data
                                                        .categoryFieldNameArabic)),
                                            Expanded(
                                              child: GridView.builder(
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    childAspectRatio:
                                                        0.45.sw / 24.h,
                                                  ),
                                                  itemCount:
                                                      data.attributes.length,
                                                  itemBuilder: (context,
                                                      attributesIndex) {
                                                    print(
                                                        'check boxes length: ${data.attributes.length}');
                                                    print(
                                                        'checkboxes selected values: ${Controller.languageChange(english: value.carAdOneSelectedValuesList[index].value, arabic: value.carAdOneSelectedValuesList[index].valueAr)}');
                                                    return SizedBox(
                                                      width: 0.45.sw,
                                                      child: ExtraCheckBox(
                                                          selectedOptionsList: value
                                                              .carAdOneSelectedValuesList,
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
                                                          isChecked: false),
                                                    );
                                                  }),
                                            ),
                                          ],
                                        ),
                                      );

                                    case "7":
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.h),
                                        alignment: Alignment.topLeft,
                                        height: 210.h,
                                        width: 350.w,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3.r),
                                          border: Border.all(
                                            width: 1,
                                            color: ksecondaryColor2,
                                          ),
                                        ),
                                        child: TextField(
                                          controller: value
                                                  .carAdOneSelectedValuesList
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
                                            value.addSelectedItem(
                                                newItem: AddSummaryModel(
                                                    name:
                                                        data.categoryFieldName,
                                                    nameAr: data
                                                        .categoryFieldNameArabic,
                                                    value: newValue,
                                                    valueAr: newValue,
                                                    field:
                                                        data.categoryTypeName),
                                                valuesList: value
                                                    .carAdOneSelectedValuesList);
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
                                                : GoogleFonts.tajawal()
                                                    .fontFamily,
                                            fontWeight: FontWeight.w400,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: Controller.getTag(
                                                'describe_your_cars'),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                      );

                                    case "8":
                                      return GestureDetector(
                                        onTap: () async {
                                          await getImages(data: data);
                                          print(data.attributes);
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.h),
                                          width: 350.w,
                                          height: 48.h,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 2.w,
                                              color: khelperTextColor,
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
                                              H3semi(
                                                  text: Controller.getTag(
                                                      'add_pictures')),
                                            ],
                                          ),
                                        ),
                                      );

                                    case "9":
                                      String dropdownSelectedValue() {
                                        String dropDownValue =
                                            Controller.languageChange(
                                                english: data.categoryFieldName,
                                                arabic: data
                                                    .categoryFieldNameArabic);
                                        int existingIndex = value
                                            .carAdOneSelectedValuesList
                                            .indexWhere((item) =>
                                                item.name ==
                                                Controller.languageChange(
                                                    english:
                                                        data.categoryFieldName,
                                                    arabic: data
                                                        .categoryFieldNameArabic));

                                        if (existingIndex != -1) {
                                          // Item with the same name already exists, overwrite it
                                          dropDownValue = value
                                              .carAdOneSelectedValuesList[
                                                  existingIndex]
                                              .value.toString();
                                        } else {
                                          // Item with the same name doesn't exist, add the new item
                                          dropDownValue =
                                              Controller.languageChange(
                                                  english:
                                                      data.categoryFieldName,
                                                  arabic: data
                                                      .categoryFieldNameArabic);
                                        }

                                        return dropDownValue;
                                      }
                                      return YearSelector(
                                        isRequiredCheck: isRequiredCheckList,
                                        data: data,
                                        selectedOptionsList:
                                            value.carAdOneSelectedValuesList,
                                        index: index,
                                        dropDownValue: dropdownSelectedValue(),
                                      );

                                    // case "9":
                                    //   int currentYear = DateTime.now().year;
                                    //
                                    //   List<String> dropdownList = List.generate(
                                    //           currentYear - 1970 + 1,
                                    //           (index) =>
                                    //               (1970 + index).toString())
                                    //       .reversed
                                    //       .toList();
                                    //   dropdownList.insert(
                                    //       0,
                                    //       Controller.languageChange(
                                    //           english: data.categoryFieldName,
                                    //           arabic: data
                                    //               .categoryFieldNameArabic));
                                    //   String dropdownSelectedValue() {
                                    //     String dropDownValue =
                                    //         Controller.languageChange(
                                    //             english: data.categoryFieldName,
                                    //             arabic: data
                                    //                 .categoryFieldNameArabic);
                                    //     int existingIndex = value
                                    //         .carAdOneSelectedValuesList
                                    //         .indexWhere((item) =>
                                    //             item.name ==
                                    //             Controller.languageChange(
                                    //                 english:
                                    //                     data.categoryFieldName,
                                    //                 arabic: data
                                    //                     .categoryFieldNameArabic));
                                    //
                                    //     if (existingIndex != -1) {
                                    //       // Item with the same name already exists, overwrite it
                                    //       dropDownValue = Controller.languageChange(
                                    //           english: value
                                    //               .carAdOneSelectedValuesList[
                                    //                   existingIndex]
                                    //               .value,
                                    //           arabic: value
                                    //               .carAdOneSelectedValuesList[
                                    //                   existingIndex]
                                    //               .valueAr);
                                    //     } else {
                                    //       // Item with the same name doesn't exist, add the new item
                                    //       dropDownValue =
                                    //           Controller.languageChange(
                                    //               english:
                                    //                   data.categoryFieldName,
                                    //               arabic: data
                                    //                   .categoryFieldNameArabic);
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
                                    //     padding: EdgeInsets.symmetric(
                                    //         vertical: 10.h),
                                    //     child: SelectOptionForAd(
                                    //       attributesList: [],
                                    //       isRequiredCheck: isRequiredCheckList,
                                    //       data: data,
                                    //       selectedOptionsList:
                                    //           value.carAdOneSelectedValuesList,
                                    //       index: index,
                                    //       dropdownName:
                                    //           Controller.languageChange(
                                    //               english:
                                    //                   data.categoryFieldName,
                                    //               arabic: data
                                    //                   .categoryFieldNameArabic),
                                    //       dropDownValue:
                                    //           dropdownSelectedValue(),
                                    //       dropdownlist: dropdownList,
                                    //     ),
                                    //   );
                                    default:
                                      return Center(
                                        child: H2Bold(
                                            text: '${data.categoryTypeId}'),
                                      );
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: MainButton(
                                isLoading: Provider.of<AddSummary>(context,
                                        listen: true)
                                    .isLoading,
                                text: Controller.getTag('next'),
                                onTap: () {
                                  for (int i = 0;
                                      i < value.adsInputFieldListSummary.length;
                                      i++) {
                                    if (value.adsInputFieldListSummary[i]
                                            .isRequired ==
                                        true) {
                                      bool containField =
                                          value.carAdOneSelectedValuesList.any(
                                        (element) {
                                          if (element.name ==
                                              value.adsInputFieldListSummary[i]
                                                  .categoryFieldName) {
                                            if (element.name == 'Price') {
                                              if (int.parse(element.value
                                                      .toString()) <
                                                  2000) {
                                                return false;
                                              } else {
                                                return true;
                                              }
                                            } else if (element.name == 'Year') {
                                              if (element.value.length != 4) {
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
                                            } else if (element.name ==
                                                'Title') {
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
                                  print(
                                      'called before: ${isRequiredCheckList}');

                                  if (!isRequiredCheckList.contains(true)) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CarAdTwo(
                                          isFromCarAdOne: true,
                                          lastCategoryNameAr: categoryNameAr,
                                          lastCategoryName: categoryName,
                                          categoryId: '135',
                                          ListingSummary:
                                              value.carAdOneSelectedValuesList,
                                        ),
                                      ),
                                    );
                                  } else {
                                    DisplayMessage(
                                        context: context,
                                        isTrue: false,
                                        message: Controller.getTag(
                                            'please_fill_in_all_mandatory_fields'));
                                  }

                                  // print('this is field list');
                                  // value.carAdOneSelectedValuesList
                                  //     .forEach((element) {
                                  //   print('name:${element.name}');
                                  //   print('field:${element.value}');
                                  // });

                                  // print('this is selected value list');
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
        }),
      ),
    );
  }
}

// import 'package:lisit_mobile_app/const/lib_all.dart';

// import 'carAdTwo.dart';
// import 'widget/selectOptionforAd.dart';

// class CarAdOne extends StatefulWidget {
//   const CarAdOne({super.key});

//   @override
//   State<CarAdOne> createState() => _CarAdOneState();
// }

// class _CarAdOneState extends State<CarAdOne> {
//   List<String> emirateList = [
//     'Select Options',
//     'Option 1',
//     'Option 2',
//     'Option 3',
//     'Option 4',
//     'Option 5',
//   ];
//   String emiratedropDownValue = 'Select Options';

//   List<String> makeModellist = [
//     'Select Options',
//     'Option 1',
//     'Option 2',
//     'Option 3',
//     'Option 4',
//     'Option 5',
//   ];
//   String makeModeldropDownValue = 'Select Options';
//   List<String> trimlist = [
//     'Select Options',
//     'Option 1',
//     'Option 2',
//     'Option 3',
//     'Option 4',
//     'Option 5',
//   ];
//   String trimdropDownValue = 'Select Options';

//   List<String> regionalSpecList = [
//     'Select Options',
//     'Option 1',
//     'Option 2',
//     'Option 3',
//     'Option 4',
//     'Option 5',
//   ];
//   String regionalSpecdropDownValue = 'Select Options';
//   TextEditingController yearController = TextEditingController();
//   TextEditingController kiloMeterController = TextEditingController();
//   TextEditingController priceController = TextEditingController();
//   TextEditingController phoneNumberController = TextEditingController();

//   List<String> insuredList = [
//     'Select Options',
//     'Yes',
//     'No',
//   ];
//   String insureddropDownValue = 'Select Options';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
// appBar: AppBar(
//   leading: GestureDetector(
//       onTap: () {
//         Navigator.pop(context);
//       },
//       child: const Icon(Icons.keyboard_arrow_left_outlined)),
//   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//   title: H2Bold(text: 'Place an ad'),
//   centerTitle: true,
//   actions: [
//     GestureDetector(
//         onTap: () {
//           Navigator.pop(context);
//         },
//         child: Padding(
//           padding: EdgeInsets.only(right: 10.w),
//           child: const Icon(Icons.close),
//         ))
//   ],
//   // elevation: 1,
// ),
//       body: Container(
//         height: 0.9.sh,
//         width: 1.sw,
//         decoration: BoxDecoration(
//           border: Border(
//             top: BorderSide(
//               width: 1.w,
//               color: ksearchFieldColor,
//             ),
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: SizedBox(
//             height: 0.9.sh,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 SelectOptionForAd(
//                   dropdownName: 'Emirate',
//                   dropDownValue: emiratedropDownValue,
//                   dropdownlist: emirateList,
//                 ),
//                 SelectOptionForAd(
//                   dropdownName: 'Make & Model',
//                   dropDownValue: makeModeldropDownValue,
//                   dropdownlist: makeModellist,
//                 ),
//                 SelectOptionForAd(
//                   dropdownName: 'Trim',
//                   dropDownValue: trimdropDownValue,
//                   dropdownlist: trimlist,
//                 ),
//                 SelectOptionForAd(
//                   dropdownName: 'Regional Spec',
//                   dropDownValue: regionalSpecdropDownValue,
//                   dropdownlist: regionalSpecList,
//                 ),
//                 AdInputField(
//                   title: 'Year',
//                   controller: yearController,
//                   keybordType: TextInputType.number,
//                 ),
//                 AdInputField(
//                   title: 'Kiliometers',
//                   controller: kiloMeterController,
//                   keybordType: TextInputType.number,
//                 ),
//                 SelectOptionForAd(
//                   dropdownName: 'Is your car insured in UAE?',
//                   dropDownValue: insureddropDownValue,
//                   dropdownlist: insuredList,
//                 ),
//                 AdInputField(
//                   title: 'Price',
//                   controller: priceController,
//                   keybordType: TextInputType.number,
//                 ),
//                 AdInputField(
//                     title: 'Phone Number',
//                     controller: phoneNumberController,
//                     keybordType: TextInputType.phone),
//                 MainButton(
//                   text: 'Next',
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => CarAdTwo(),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
