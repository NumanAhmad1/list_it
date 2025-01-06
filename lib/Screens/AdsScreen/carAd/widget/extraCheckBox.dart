import 'dart:developer';

import 'package:lisit_mobile_app/Controller/Providers/data/adsInputField.dart';
import 'package:lisit_mobile_app/Models/addSummaryModel.dart';
import 'package:lisit_mobile_app/Models/adsInputFieldsModel.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class ExtraCheckBox extends StatefulWidget {
  String label;
  bool isChecked;
  int attributeIndex;
  int mainListIndex;
  List<AddSummaryModel> selectedOptionsList;
  AdsInputFieldsModel data;
  ExtraCheckBox({
    required this.mainListIndex,
    required this.label,
    required this.isChecked,
    required this.attributeIndex,
    required this.data,
    required this.selectedOptionsList,
    super.key,
  });

  @override
  State<ExtraCheckBox> createState() => _ExtraCheckBoxState();
}

class _ExtraCheckBoxState extends State<ExtraCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 24.w,
          height: 24.h,
          child: Checkbox(
            activeColor: kprimaryColor,
            value: widget.isChecked,
            onChanged: (value) {
              widget.isChecked = value!;

              if (value == true) {
                Provider.of<AdsInputField>(context, listen: false)
                    .addSelectedItem(
                        newItem: AddSummaryModel(
                            // Extras[Front Wheel Drive]
                            name:
                                '${widget.data.categoryFieldName}[${widget.data.attributes[widget.attributeIndex].attributeName}]',
                            nameAr:
                                '${widget.data.categoryFieldNameArabic}[${widget.data.attributes[widget.attributeIndex].attributeNameAr}]',
                            value: 'true',
                            valueAr: 'true',
                            field: widget.data.categoryTypeName),
                        valuesList: widget.selectedOptionsList);
              } else {
                for (var i = 0;
                    i <
                        Provider.of<AdsInputField>(context, listen: false)
                            .editAdSelectedValuesList
                            .length;
                    i++) {
                  if (Provider.of<AdsInputField>(context, listen: false)
                          .editAdSelectedValuesList[i]
                          .field ==
                      'Checkboxes') {
                    if (Provider.of<AdsInputField>(context, listen: false)
                        .editAdSelectedValuesList[i]
                        .value
                        .toString()
                        .contains(widget.data.attributes[widget.attributeIndex]
                            .attributeName)) {
                      if (Provider.of<AdsInputField>(context, listen: false)
                          .editAdSelectedValuesList[i]
                          .value
                          .toString()
                          .contains(
                              "${widget.data.attributes[widget.attributeIndex].attributeName},")) {
                        Provider.of<AdsInputField>(context, listen: false)
                            .editAdSelectedValuesList[i]
                            .value = Provider.of<AdsInputField>(context,
                                listen: false)
                            .editAdSelectedValuesList[i]
                            .value
                            .toString()
                            .replaceAll(
                                "${widget.data.attributes[widget.attributeIndex].attributeName},",
                                "");
                      } else {
                        Provider.of<AdsInputField>(context, listen: false)
                                .editAdSelectedValuesList[i]
                                .value =
                            Provider.of<AdsInputField>(context, listen: false)
                                .editAdSelectedValuesList[i]
                                .value
                                .toString()
                                .replaceAll(
                                    widget
                                        .data
                                        .attributes[widget.attributeIndex]
                                        .attributeName,
                                    "");
                      }

                      Provider.of<AdsInputField>(context, listen: false)
                          .editAdSelectedValuesList[i]
                          .valueAr
                          .toString()
                          .replaceAll(
                              '${widget.data.attributes[widget.attributeIndex].attributeNameAr},',
                              '');
                    }
                  }
                }
                Provider.of<AdsInputField>(context, listen: false)
                    .addSelectedItem(
                        newItem: AddSummaryModel(
                            // Extras[Front Wheel Drive]
                            name:
                                '${widget.data.categoryFieldName}[${widget.data.attributes[widget.attributeIndex].attributeName}]',
                            nameAr:
                                '${widget.data.categoryFieldNameArabic}[${widget.data.attributes[widget.attributeIndex].attributeNameAr}]',
                            value: 'false',
                            valueAr: 'false',
                            field: widget.data.categoryTypeName),
                        valuesList: widget.selectedOptionsList);
              }
              setState(() {});
            },
          ),
        ),
        SizedBox(
          width: 5.w,
        ),
        ParaSemi(
          text: widget.label,
        ),
      ],
    );
  }
}

class Feature {
  final bool available;
  final String name;

  const Feature(this.available, this.name);
}
