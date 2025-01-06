import 'package:lisit_mobile_app/Controller/Providers/data/adsInputField.dart';
import 'package:lisit_mobile_app/Models/addSummaryModel.dart';
import 'package:lisit_mobile_app/Models/adsInputFieldsModel.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class SelectOptionForAd extends StatefulWidget {
  String dropdownName;
  List isRequiredCheck;
  String dropDownValue;
  int index;
  List dropdownlist;
  List<Attribute>? attributesList;
  List<AddSummaryModel> selectedOptionsList;
  AdsInputFieldsModel data;
  List<AdsInputFieldsModel> adsInputFieldList;
  SelectOptionForAd(
      {required this.dropdownName,
      required this.isRequiredCheck,
      required this.dropDownValue,
      required this.dropdownlist,
      required this.index,
      required this.selectedOptionsList,
      required this.data,
      this.adsInputFieldList = const [],
      this.attributesList,
      super.key});

  @override
  State<SelectOptionForAd> createState() => _SelectOptionForAdState();
}


class _SelectOptionForAdState extends State<SelectOptionForAd> {
  String dropdownSelectedValue = '';



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
if(widget.dropDownValue.isNotEmpty && widget.dropDownValue != widget.dropdownName){
  context.read<AdsInputField>().updateList(
      adsInputFieldList: widget.adsInputFieldList,
      attributeId: widget.adsInputFieldList.isNotEmpty
          ? widget
          .attributesList![widget.dropdownlist
          .indexOf(widget.dropDownValue) -
          1]
          .attribuiteId
          : null,
      reloadCategoryFieldId: widget
          .adsInputFieldList.isNotEmpty
          ? widget
          .attributesList![widget.dropdownlist
          .indexOf(widget.dropDownValue) -
          1]
          .reloadCategoryfieldId
          : null);
}
print("<---------------------------------------->");
    print('These are selected Values');
    print("Category: ${widget.dropdownName}");
    print("value from outside: ${widget.dropDownValue}");
    print("dropdown value inside: $dropdownSelectedValue");


  }

  @override
  Widget build(BuildContext context) {
    print('%%%%%%%%%%%%%%%%%%%%%%');
    print('dropdown name: ${widget.dropdownName}');
    print('dropdown value: ${widget.dropDownValue}');
    print('ignor condition ; ${context.select(
            (AdsInputField dependentValue) => dependentValue
            .dependentControls
            .any((element) =>
        element.toString() ==
            widget.data.categoryFieldId.toString()))}');
    print('ignor condition with addtion: ${(context.select(
            (AdsInputField dependentValue) => dependentValue
            .dependentControls
            .any((element) =>
        element.toString() ==
            widget.data.categoryFieldId.toString())) && widget.dropdownName != widget.dropDownValue)}');
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          width: 350.w,
          height: 48.h,
          decoration: BoxDecoration(
            border: Border.all(
              width: 2.w,
              color: context.select((AdsInputField dependentValue) =>
                      dependentValue.dependentControls.any((element) =>
                          element.toString() ==
                          widget.data.categoryFieldId.toString()))
                  ? ksearchFieldColor
                  : widget.isRequiredCheck.isNotEmpty &&
                          widget.isRequiredCheck[widget.index]
                      ? kredColor
                      : khelperTextColor,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 11.w),
            child: Stack(
              alignment:
                  Controller.getLanguage().toString().toLowerCase() == 'english'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
              children: [
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: context.select((AdsInputField dependentValue) =>
                          dependentValue.dependentControls.any((element) =>
                              element.toString() ==
                              widget.data.categoryFieldId.toString()))
                      ? ksearchFieldColor
                      : ksecondaryColor,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // if (dropdownSelectedValue.isNotEmpty)
                    //   ParaRegular(text: widget.dropdownName),
                    SizedBox(
                      height: 20.h,
                      child: IgnorePointer(
                        ignoring: context.select(
                            (AdsInputField dependentValue) => dependentValue
                                .dependentControls
                                .any((element) =>
                                    element.toString() ==
                                    widget.data.categoryFieldId.toString())),
                        child: DropdownButton(
                          icon: const SizedBox.shrink(),
                          underline: const Text(''),
                          value:
                              widget.dropdownlist.contains(widget.dropDownValue)
                                  ? widget.dropDownValue
                                  : widget.dropdownlist[0],
                          items: widget.dropdownlist.map((e) {
                            return DropdownMenuItem(
                              value: e.toString(),
                              child: SizedBox(
                                width: 330.w,
                                child: H3semi(
                                  text: e.toString(),
                                  color: context.select(
                                          (AdsInputField dependentValue) =>
                                              dependentValue.dependentControls
                                                  .any((element) =>
                                                      element.toString() ==
                                                      widget
                                                          .data.categoryFieldId
                                                          .toString()))
                                      ? ksearchFieldColor
                                      : ksecondaryColor,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            String newValueAr = '';
                            widget.attributesList!.forEach((element) {
                              if (element.attributeName == newValue) {
                                newValueAr = element.attributeNameAr;
                              }
                            });
                            widget.dropDownValue = newValue.toString();
                            dropdownSelectedValue = newValue.toString();
                            Provider.of<AdsInputField>(context, listen: false)
                                .addSelectedItem(
                                    newItem: AddSummaryModel(
                                        // Extras[Front Wheel Drive]
                                        name: widget.data.categoryFieldName,
                                        nameAr:
                                            widget.data.categoryFieldNameArabic,
                                        value: newValue.toString(),
                                        valueAr: newValueAr,
                                        field: widget.data.categoryTypeName),
                                    valuesList: widget.selectedOptionsList);

                            widget.isRequiredCheck[widget.index] = false;
                            context.read<AdsInputField>().updateList(
                                adsInputFieldList: widget.adsInputFieldList,
                                attributeId: widget.adsInputFieldList.isNotEmpty
                                    ? widget
                                        .attributesList![widget.dropdownlist
                                                .indexOf(newValue.toString()) -
                                            1]
                                        .attribuiteId
                                    : null,
                                reloadCategoryFieldId: widget
                                        .adsInputFieldList.isNotEmpty
                                    ? widget
                                        .attributesList![widget.dropdownlist
                                                .indexOf(newValue.toString()) -
                                            1]
                                        .reloadCategoryfieldId
                                    : null);

                            setState(() {});
                          },
                        ),
                      ),
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
