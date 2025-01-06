import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/adsInputField.dart';
import 'package:lisit_mobile_app/Models/addSummaryModel.dart';
import 'package:lisit_mobile_app/Models/adsInputFieldsModel.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class YearSelector extends StatefulWidget {
  List isRequiredCheck;
  int index;
  List<AddSummaryModel> selectedOptionsList;
  AdsInputFieldsModel data;
  String dropDownValue;
  List<Attribute>? attributesList;
  List<AdsInputFieldsModel> adsInputFieldList;
  YearSelector(
      {required this.index,
        required this.isRequiredCheck,
        this.adsInputFieldList = const [],
        required this.selectedOptionsList,
        required this.data,
        required this.dropDownValue,
        this.attributesList,
        super.key});

  @override
  State<YearSelector> createState() => _SelectOptionForAdState();
}

class _SelectOptionForAdState extends State<YearSelector> {

  bool yearSelected = false;
  String selectedYear = "";

  @override
  void initState() {
    selectedYear = widget.dropDownValue;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          width: 350.w,
          height: yearSelected?300.h:48.h,
          decoration: BoxDecoration(
            border: Border.all(
              width: 2.w,
              color: khelperTextColor,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 11.w, right: 5.w),
            child: GestureDetector(
              onTap: (){
                setState(() {
                  yearSelected = true;
                });
              },
              child: Stack(
                alignment:
                Controller.getLanguage().toString().toLowerCase() == 'english'
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                children: [
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: ksecondaryColor,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ParaRegular(text: Controller.getTag('year')),
                      !yearSelected
                          ? Container(
                            height: 44.h,
                            alignment: Alignment.centerLeft,
                            child: ParaRegular(
                                text: selectedYear.isEmpty
                                    ? Controller.languageChange(english: widget.data.categoryFieldName, arabic: widget.data.categoryFieldNameArabic)
                                    : selectedYear),
                          )
                          :SizedBox(
                        height: 295.h,
                        width: 320.w,
                        child: YearPicker(
                            firstDate: DateTime(1970),
                            lastDate: DateTime.now(),
                            selectedDate: DateTime(int.parse(selectedYear.isEmpty || selectedYear == Controller.languageChange(english: widget.data.categoryFieldName, arabic: widget.data.categoryFieldNameArabic)?"0":selectedYear)),
                            dragStartBehavior: DragStartBehavior.start,
                            onChanged: (date){
                              selectedYear = date.year.toString();
                              // String newValueAr = '';
                              // widget.attributesList!.forEach((element) {
                              //   if (element.attributeName == date.year.toString()) {
                              //     newValueAr = element.attributeNameAr;
                              //   }
                              // });
                              widget.dropDownValue = date.year.toString();
                              Provider.of<AdsInputField>(context, listen: false)
                                  .addSelectedItem(
                                  newItem: AddSummaryModel(
                                    // Extras[Front Wheel Drive]
                                      name: widget.data.categoryFieldName,
                                      nameAr:
                                      widget.data.categoryFieldNameArabic,
                                      value: selectedYear,
                                      valueAr: selectedYear,
                                      field: widget.data.categoryTypeName),
                                  valuesList: widget.selectedOptionsList);

                              widget.isRequiredCheck[widget.index] = false;

                              print(widget.isRequiredCheck[widget.index]);

                              yearSelected = false;

                              setState(() {});
                            }),
                      ),
                      // ParaRegular(
                      //   text: 'This field is mandatory',
                      //   color: kredColor,
                      // )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.isRequiredCheck[widget.index])
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: ParaRegular(
              text: Controller.getTag('this_field_is_mandatory'),
              color: kredColor,
            ),
          ),
      ],
    );
  }
}
