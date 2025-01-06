import 'dart:developer';

import 'package:lisit_mobile_app/Controller/Providers/data/getCategoryListing.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/getCities.dart';
import 'package:lisit_mobile_app/Screens/filters/filterValues.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class AdvanceFilters extends StatefulWidget {
  String category;
  AdvanceFilters({super.key, required this.category});

  @override
  State<AdvanceFilters> createState() => _AdvanceFiltersState();
}

class _AdvanceFiltersState extends State<AdvanceFilters> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    await context
        .read<GetCategoryListing>()
        .getCategoryFieldsFilter(context, category: widget.category);

    if (context.read<FilterValues>().selectedFilterData.isNotEmpty) {
      var selectedFilterData = context.read<FilterValues>().selectedFilterData;
      if (selectedFilterData != null && selectedFilterData['Title'] != null) {
        enteredKeywordController.text =
            selectedFilterData['Title'].toString().replaceAll('%', '');
      }
      if (selectedFilterData != null && selectedFilterData['Price'] != null) {
        List val = context
            .read<FilterValues>()
            .selectedFilterData['Price']
            .toString()
            .split('->');
        if (val[0] != val[1]) {
          minimumPriceController.text = val[0];
          maximumPriceController.text = val[1];
        } else {
          minimumPriceController.text = val[0];
        }
      }
      if (selectedFilterData != null && selectedFilterData['Year'] != null) {
        List val = context
            .read<FilterValues>()
            .selectedFilterData['Year']
            .toString()
            .split('->');

        if (val[0] != val[1]) {
          minimumYearController.text = val[0];
          maximumYearController.text = val[1];
        } else {
          minimumYearController.text = val[0];
        }
      }

      if (selectedFilterData != null &&
          selectedFilterData['Kilometer'] != null) {
        List val = context
            .read<FilterValues>()
            .selectedFilterData['Kilometer']
            .toString()
            .split('->');
        if (val[0] != val[1]) {
          minimumKilometerController.text = val[0];
          maximumKilometerController.text = val[1];
        } else {
          minimumKilometerController.text = val[0];
        }
      }
    }

    // resetFilters();
  }

  String minPriceCrontroller = '';
  String maxPriceController = '';
  String minYearCrontroller = '';
  String maxYearController = '';
  String minkilometerCrontroller = '';
  String maxkilometerController = '';
  String keywordController = '';

  TextEditingController minimumPriceController = TextEditingController();
  TextEditingController maximumPriceController = TextEditingController();
  TextEditingController minimumYearController = TextEditingController();
  TextEditingController maximumYearController = TextEditingController();
  TextEditingController minimumKilometerController = TextEditingController();
  TextEditingController maximumKilometerController = TextEditingController();
  TextEditingController enteredKeywordController = TextEditingController();

  Map<String, dynamic> selectedFilterData = {};

  resetFilters() {
    minPriceCrontroller = '';
    maxPriceController = '';
    minYearCrontroller = '';
    maxYearController = '';
    minkilometerCrontroller = '';
    maxkilometerController = '';
    keywordController = '';
    context.read<FilterValues>().selectedFilterData.clear();
    context.read<FilterValues>().selectedFilterData['Emirates'] =
        context.read<FilterValues>().results['Emirates'];
    context.read<FilterValues>().selectedFilterData['Category'] =
        context.read<FilterValues>().results['Category'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GetCategoryListing>(builder: (context, value, child) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 1.sw,
                height: 90.h,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: ksearchFieldColor),
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // back icon
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                          )),

                      //filter title

                      H2Bold(text: Controller.getTag('filter')),

                      //reset buton

                      GestureDetector(
                        onTap: () {
                          resetFilters();
                        },
                        child: H2Bold(
                          text: Controller.getTag('reset'),
                          color: kprimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      isDismissible: false,
                      context: context,
                      builder: (context) {
                        return SelectCarsForAdvanceFilter();
                      });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: SizedBox(
                    height: 75.h,
                    width: 1.sw,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        H3semi(text: Controller.getTag('category')),
                        SizedBox(
                          child: Row(
                            children: [
                              H3Regular(
                                  text: context.select((FilterValues value) =>
                                          value.selectedFilterData[
                                              'Category']) ??
                                      ''),
                              // '${context.select((FilterValues value) => value.results['Emirates'])}'),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(
                thickness: 0.5,
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SelectCitiesForAdvanceFilter();
                      });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: SizedBox(
                    height: 60.h,
                    width: 1.sw,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        H3semi(text: Controller.getTag('emirates')),
                        SizedBox(
                          child: Row(
                            children: [
                              H3Regular(
                                  text: context.select((FilterValues value) =>
                                          value.selectedFilterData[
                                              'Emirates']) ??
                                      ''),
                              // '${context.select((FilterValues value) => value.results['Emirates'])}'),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const Divider(
                thickness: 0.5,
              ),
              //price

              SizedBox(
                height: 101.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: H3semi(
                          text:
                              '${Controller.getTag('price')} (${Controller.getTag('aed')})'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 165.w,
                            child: AdInputField(
                              onChanged: (value) {
                                minPriceCrontroller = value;
                                context.read<FilterValues>().selectedFilterData[
                                    'Price'] = maxPriceController
                                        .isEmpty
                                    ? '${minPriceCrontroller}->${minPriceCrontroller}'
                                    : '${value}->${maxPriceController}';
                                // maxPriceController = value;
                              },
                              isHelperText: true,
                              controller: minimumPriceController,
                              keybordType: TextInputType.number,
                              title: Controller.getTag('min'),
                            ),
                          ),
                          SizedBox(
                            width: 165.w,
                            child: AdInputField(
                              onChanged: (value) {
                                maxPriceController = value;
                                context.read<FilterValues>().selectedFilterData[
                                    'Price'] = maxPriceController
                                        .isEmpty
                                    ? '${minPriceCrontroller}->${minPriceCrontroller}'
                                    : '${minPriceCrontroller}->${value}';
                                // maxPriceController = value;
                              },
                              isHelperText: true,
                              controller: maximumPriceController,
                              keybordType: TextInputType.number,
                              title: Controller.getTag('max'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 0.5,
                    ),
                  ],
                ),
              ),

              //Year

              SizedBox(
                height: 101.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: H3semi(text: Controller.getTag('year')),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 165.w,
                            child: AdInputField(
                              onChanged: (value) {
                                minYearCrontroller = value;
                                context.read<FilterValues>().selectedFilterData[
                                    'Year'] = maxYearController
                                        .isEmpty
                                    ? '${minYearCrontroller}->${minYearCrontroller}'
                                    : '${value}->${maxYearController}';
                                // maxPriceController = value;
                              },
                              isHelperText: true,
                              controller: minimumYearController,
                              keybordType: TextInputType.number,
                              title: Controller.getTag('min'),
                            ),
                          ),
                          SizedBox(
                            width: 165.w,
                            child: AdInputField(
                              onChanged: (value) {
                                maxYearController = value;
                                context.read<FilterValues>().selectedFilterData[
                                    'Year'] = maxYearController
                                        .isEmpty
                                    ? '${minYearCrontroller}->${minYearCrontroller}'
                                    : '${minYearCrontroller}->${value}';
                                // maxPriceController = value;
                              },
                              isHelperText: true,
                              controller: maximumYearController,
                              keybordType: TextInputType.number,
                              title: Controller.getTag('max'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 0.5,
                    ),
                  ],
                ),
              ),

              //Kilometer

              SizedBox(
                height: 101.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: H3semi(text: Controller.getTag('kilometer')),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 165.w,
                            child: AdInputField(
                              onChanged: (value) {
                                minkilometerCrontroller = value;
                                context
                                        .read<FilterValues>()
                                        .selectedFilterData['Kilometer'] =
                                    maxkilometerController.isEmpty
                                        ? '${value}->${value}'
                                        : '${value}->${maxkilometerController}';
                                // minimumPriceController = value;
                              },
                              isHelperText: true,
                              controller: minimumKilometerController,
                              keybordType: TextInputType.number,
                              title: Controller.getTag('min'),
                            ),
                          ),
                          SizedBox(
                            width: 165.w,
                            child: AdInputField(
                              onChanged: (value) {
                                maxkilometerController = value;
                                context.read<FilterValues>().selectedFilterData[
                                    'Kilometer'] = maxkilometerController
                                        .isEmpty
                                    ? '${minkilometerCrontroller}->${minkilometerCrontroller}'
                                    : '${minkilometerCrontroller}->${value}';
                                // maxPriceController = value;
                              },
                              isHelperText: true,
                              controller: maximumKilometerController,
                              keybordType: TextInputType.number,
                              title: Controller.getTag('max'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 0.5,
                    ),
                  ],
                ),
              ),
              //search item

              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 20.h),
                      child: H3semi(text: Controller.getTag('keyword')),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: SizedBox(
                        width: 354.w,
                        child: AdInputField(
                          onChanged: (value) {
                            keywordController = value;
                            context
                                .read<FilterValues>()
                                .selectedFilterData['Title'] = '%$value';
                            // searchItemController = value;
                          },
                          isHelperText: true,
                          controller: enteredKeywordController,
                          keybordType: TextInputType.name,
                          title: Controller.getTag('search_keyword'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      // child: const Divider(),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: value.filtersDropdownsList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            backgroundColor: kbackgrounColor,
                            // barrierColor: kbackgrounColor,
                            context: context,
                            builder: (context) {
                              log('this is dropdownvlaue list : ++++++++++${value.dropdownValuesList[index]}');
                              return FilterDropDown(
                                  englishDropdownName:
                                      value.filtersDropdownsList[index]
                                          ['categoryFieldName'],
                                  selectedFilteredData: selectedFilterData,
                                  dropdownName:
                                      '${Controller.languageChange(english: value.filtersDropdownsList[index]['categoryFieldName'], arabic: value.filtersDropdownsList[index]['categoryFieldNameArabic'])}',
                                  dropdownList:
                                      value.dropdownValuesList[index]);
                            });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(
                            thickness: 0.5,
                          ),
                          Container(
                            color: kbackgrounColor,
                            margin: EdgeInsets.symmetric(horizontal: 20.w),
                            height: 60.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                H3semi(
                                    text:
                                        '${Controller.languageChange(english: value.filtersDropdownsList[index]['categoryFieldName'], arabic: value.filtersDropdownsList[index]['categoryFieldNameArabic'])}'),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              SizedBox(
                height: 100.h,
              ),
            ],
          ),
        );
      }),
      floatingActionButton: context.select(
        (GetCategoryListing v) => v.isLoading
            ? Container(
                alignment: Alignment.center,
                height: 64.h,
                child: const CircularProgressIndicator(),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40.w,
                  ),
                  SizedBox(
                    width: 0.7.sw,
                    child: MainButton(
                        text: Controller.getTag('show_result'),
                        onTap: () async {
                          if (context
                                  .read<FilterValues>()
                                  .selectedFilterData['Emirates'] ==
                              'All Cities') {
                            context
                                .read<FilterValues>()
                                .selectedFilterData['Emirates'] = "";
                          }
                          log('${context.read<FilterValues>().selectedFilterData}');

                          context
                              .read<GetCategoryListing>()
                              .convertSearchToSave(
                                  searchMap: context
                                      .read<FilterValues>()
                                      .selectedFilterData);

                          await context
                              .read<GetCategoryListing>()
                              .getCategoryListing(context,
                                  parametersMap: context
                                      .read<FilterValues>()
                                      .selectedFilterData);
                          if (!context.mounted) return;
                          context.read<GetCategoryListing>().applyFilter();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }),
                  ),
                  SizedBox(
                    width: 30.w,
                  ),
                ],
              ),
      ),
    );
  }
}

class FilterDropDown extends StatefulWidget {
  String dropdownName;
  String englishDropdownName;
  List dropdownList;
  Map<String, dynamic> selectedFilteredData;
  FilterDropDown({
    super.key,
    required this.selectedFilteredData,
    required this.dropdownName,
    required this.dropdownList,
    required this.englishDropdownName,
  });

  @override
  State<FilterDropDown> createState() => _FilterDropDownState();
}

class _FilterDropDownState extends State<FilterDropDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kbackgrounColor,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            height: 60.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox.shrink(),
                H2Bold(text: widget.dropdownName),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.dropdownList.length,
              itemBuilder: (context, index) {
                String isSelectedValue = '';
                widget.dropdownList.forEach((e) {
                  context
                      .read<FilterValues>()
                      .selectedFilterData
                      .forEach((key, value) {
                    if (e['attributeName'] == value) {
                      isSelectedValue = e['attributeName'];
                    }
                  });
                });
                return GestureDetector(
                  onTap: () {
                    context.read<GetCategoryListing>().updateList(
                        reloadCategoryFieldId: widget.dropdownList[index]
                                ['reloadCategoryfieldId']
                            .toString(),
                        attributeId: widget.dropdownList[index]['attributeId']
                            .toString());
                    context.read<FilterValues>().selectValueFromDropdown(
                        value: widget.englishDropdownName,
                        dropdownList: widget.dropdownList,
                        index: index);
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: Container(
                    color: kbackgrounColor,
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    height: 60.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(
                          thickness: 0.5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            H3semi(
                                text:
                                    '${Controller.languageChange(english: widget.dropdownList[index]['attributeName'], arabic: widget.dropdownList[index]['attributeNameAr'])}'),
                            if (isSelectedValue ==
                                widget.dropdownList[index]['attributeName'])
                              Icon(
                                Icons.check,
                                color: kprimaryColor,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SelectCarsForAdvanceFilter extends StatefulWidget {
  const SelectCarsForAdvanceFilter({super.key});

  @override
  State<SelectCarsForAdvanceFilter> createState() =>
      _SelectCarsForAdvanceFilterState();
}

class _SelectCarsForAdvanceFilterState
    extends State<SelectCarsForAdvanceFilter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kbackgrounColor,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            height: 60.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox.shrink(),
                H2Bold(text: Controller.getTag('select_Category')),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close)),
              ],
            ),
          ),
          Expanded(child: Consumer<GetCities>(builder: (context, value, child) {
            return ListView.builder(
                itemCount: value.categories.length,
                itemBuilder: (context, index) {
                  String isSelectedValue = '';
                  value.categories.forEach((e) {
                    context
                        .read<FilterValues>()
                        .selectedFilterData
                        .forEach((key, value) {
                      if (e['name'] == value) {
                        isSelectedValue = e['name'];
                      }
                    });
                  });

                  return GestureDetector(
                    onTap: () async {
                      context.read<FilterValues>().selectValue(
                          value: 'Category',
                          dropdownList: value.categories,
                          index: index);
                      context.read<FilterValues>().updateCategory(
                          key: 'Category',
                          keyword: value.categories[index]['name']);
                      await context
                          .read<GetCategoryListing>()
                          .getCategoryFieldsFilter(context,
                              category: context
                                  .read<FilterValues>()
                                  .selectedFilterData['Category']);

                      setState(() {});
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: kbackgrounColor,
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      height: 60.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(
                            thickness: 0.5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              H3semi(
                                  text: Controller.languageChange(
                                      english: value.categories[index]['name'],
                                      arabic: value.categories[index]
                                          ['name_ar'])),
                              // H3semi(text: widget.dropdownList[index]['value']),
                              Provider.of<GetCategoryListing>(context).isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : const SizedBox.shrink(),
                              if (isSelectedValue ==
                                  value.categories[index]['value'])
                                Icon(
                                  Icons.check,
                                  color: kprimaryColor,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          })),
        ],
      ),
    );
  }
}

class SelectCitiesForAdvanceFilter extends StatefulWidget {
  const SelectCitiesForAdvanceFilter({super.key});

  @override
  State<SelectCitiesForAdvanceFilter> createState() =>
      _SelectCitiesForAdvanceFilterState();
}

class _SelectCitiesForAdvanceFilterState
    extends State<SelectCitiesForAdvanceFilter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kbackgrounColor,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            height: 60.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox.shrink(),
                H2Bold(text: Controller.getTag('select_city')),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close)),
              ],
            ),
          ),
          Expanded(
            child: Consumer<GetCities>(
              builder: (context, value, child) {
                String isSelectedValue = '';
                value.cities.forEach((e) {
                  context
                      .read<FilterValues>()
                      .selectedFilterData
                      .forEach((key, value) {
                    if (e['value'] == value) {
                      isSelectedValue = e['value'];
                    }
                  });
                });
                return ListView.builder(
                  itemCount: value.cities.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        context.read<FilterValues>().selectValue(
                            value: 'Emirates',
                            dropdownList: value.cities,
                            index: index);

                        context.read<FilterValues>().updateCategory(
                            key: 'Emirates',
                            keyword: value.cities[index]['value']);

                        setState(() {});
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      },
                      child: Container(
                        color: kbackgrounColor,
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        height: 60.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(
                              thickness: 0.5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                H3semi(
                                    text: Controller.languageChange(
                                        english: value.cities[index]['value'],
                                        arabic: value.cities[index]
                                            ['value_ar'])),
                                // H3semi(text: widget.dropdownList[index]['value']),
                                if (isSelectedValue ==
                                    value.cities[index]['value'])
                                  Icon(
                                    Icons.check,
                                    color: kprimaryColor,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
