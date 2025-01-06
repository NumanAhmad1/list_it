// import 'package:lisit_mobile_app/Screens/AdsScreen/carAd/widget/extraCheckBox.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/getCategoryListing.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/getCities.dart';
import 'package:lisit_mobile_app/Screens/filters/advanceFilter.dart';
import 'package:lisit_mobile_app/Screens/filters/filterValues.dart';
import 'package:lisit_mobile_app/Screens/search/searchedItemsScreen.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

import 'selectCategoryScreen.dart';
import 'selectCity.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  String minimumPriceController = '';
  String maxPriceController = '';
  String searchItemController = '';
  bool isVerifiedUser = false;
  String neighborhood = 'All Cities';

  FilterValues searchItem = FilterValues();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<GetCities>()
          .getCities(context, teldaSeparatedFilterValues: "Category~Emirates");
      minimumPricecontroller.text =
          context.read<FilterValues>().results['Price'];
      keywordcontroller.text = context.read<FilterValues>().results['Title'];
      searchItemController = keywordcontroller.text;
    });
    // TODO: implement initState
    super.initState();
  }

  TextEditingController keywordcontroller = TextEditingController();
  TextEditingController minimumPricecontroller = TextEditingController();
  TextEditingController maximunPricecontroller = TextEditingController();
  // TextEditingController keywordcontroller = TextEditingController();
  // TextEditingController keywordcontroller = TextEditingController();

  resetFilters() {
    minimumPriceController = '';
    maxPriceController = '';
    searchItemController = '';
    context.read<FilterValues>().results.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
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

          //body
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // all cities
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          shape: const BeveledRectangleBorder(),
                          barrierColor: kbackgrounColor,
                          backgroundColor: kbackgrounColor,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return SizedBox(
                                height: 0.95.sh, child: SelectCity());
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
                            H3semi(text: Controller.getTag('city')),
                            SizedBox(
                              child: Row(
                                children: [
                                  H3Regular(
                                      text:
                                          '${context.select((FilterValues value) => value.results['Emirates'])}'),
                                  const Icon(Icons.arrow_forward_ios_rounded)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(),

                  // Category
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          shape: const BeveledRectangleBorder(),
                          barrierColor: kbackgrounColor,
                          backgroundColor: kbackgrounColor,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return SizedBox(
                                height: 1.sh, child: SelectCategoryScreen());
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
                                      text:
                                          '${context.select((FilterValues value) => value.results['Category'] is Map ? value.results['Category']['Category'] : value.results['Category'])}'),
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
                  const Divider(),

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
                                    minimumPriceController = value;
                                    minimumPriceController = value;
                                  },
                                  isHelperText: true,
                                  controller: minimumPricecontroller,
                                  keybordType: TextInputType.number,
                                  title: Controller.getTag('min'),
                                ),
                              ),
                              SizedBox(
                                width: 165.w,
                                child: AdInputField(
                                  onChanged: (value) {
                                    maxPriceController = value;
                                  },
                                  isHelperText: true,
                                  // controller: maxPriceController,
                                  keybordType: TextInputType.number,
                                  title: Controller.getTag('max'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
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
                                searchItemController = value;
                                context.read<FilterValues>().results['Title'] =
                                    value;
                              },
                              isHelperText: true,
                              controller: keywordcontroller,
                              keybordType: TextInputType.name,
                              title: Controller.getTag('search_keyword'),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.only(
                        //       right: 20.w, left: 20.w, top: 10.h),
                        //   child: Row(
                        //     children: [
                        //       Container(
                        //         alignment: Alignment.center,
                        //         height: 25.h,
                        //         // width: 71.w,
                        //         padding: EdgeInsets.symmetric(
                        //           horizontal: 7.w,
                        //         ),
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(11.5.r),
                        //           border: Border.all(color: ksecondaryColor),
                        //         ),
                        //         child: Row(
                        //           children: [
                        //             ParaRegular(
                        //               text: 'Honda',
                        //             ),
                        //             GestureDetector(
                        //               onTap: () {},
                        //               child: Container(
                        //                 margin: EdgeInsets.only(
                        //                     left: 5.w,
                        //                     right: 5.w,
                        //                     top: 2.h,
                        //                     bottom: 2.h),
                        //                 alignment: Alignment.center,
                        //                 clipBehavior: Clip.hardEdge,
                        //                 // height: 12.h,
                        //                 // width: 12.w,
                        //                 decoration: BoxDecoration(
                        //                     shape: BoxShape.circle,
                        //                     border: Border.all(
                        //                         color: ksecondaryColor)),
                        //                 child: Icon(
                        //                   Icons.close,
                        //                   size: 12.sp,
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: const Divider(),
                        ),
                      ],
                    ),
                  ),

                  // //Neighborhood
                  // GestureDetector(
                  //   onTap: () {
                  //     showModalBottomSheet(
                  //         shape: const BeveledRectangleBorder(),
                  //         barrierColor: kbackgrounColor,
                  //         backgroundColor: kbackgrounColor,
                  //         isScrollControlled: true,
                  //         context: context,
                  //         builder: (context) {
                  //           return SizedBox(height: 1.sh, child: SelectCity());
                  //         });
                  //   },
                  //   child: Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: 20.w),
                  //     child: SizedBox(
                  //       height: 75.h,
                  //       width: 1.sw,
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           H3semi(text: 'Neighborhood '),
                  //           SizedBox(
                  //             child: Row(
                  //               children: [
                  //                 H3Regular(text: '$neighborhood'),
                  //                 const Icon(Icons.keyboard_arrow_right_rounded)
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const Divider(),

                  // Padding(
                  //   padding:
                  //       EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       H3semi(text: 'Showed ads by verified users'),
                  //       SizedBox(
                  //         width: 24.w,
                  //         height: 24.h,
                  //         child: Checkbox(
                  //           activeColor: kprimaryColor,
                  //           value: isVerifiedUser,
                  //           onChanged: (value) {
                  //             isVerifiedUser = value!;

                  //             setState(() {});
                  //           },
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const Divider(),

                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.w, vertical: 35.h),
                    child: SizedBox(
                      height: 47.h,
                      width: 350.w,
                      // Show 34,000
                      child: context.select(
                        (GetCategoryListing val) => val.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : MainButton(
                                text: 'Results',
                                onTap: () async {
                                  var emirates = context
                                              .read<FilterValues>()
                                              .results['Emirates'] ==
                                          'All Cities'
                                      ? context
                                          .read<FilterValues>()
                                          .results['Emirates'] = ''
                                      : context
                                              .read<FilterValues>()
                                              .results['Emirates'] ??
                                          '';
                                  Map<String, dynamic> searchItem = {
                                    'Emirates': emirates,
                                    'Category': context
                                            .read<FilterValues>()
                                            .results['Category'] is Map
                                        ? context
                                            .read<FilterValues>()
                                            .results['Category']['Category']
                                        : context
                                            .read<FilterValues>()
                                            .results['Category'],
                                    'Price': minimumPriceController.isEmpty &&
                                            maxPriceController.isEmpty
                                        ? ""
                                        : maxPriceController.isEmpty
                                            ? "${minimumPriceController}->${minimumPriceController}"
                                            : "${minimumPriceController}->${maxPriceController}",
                                    'Title': '%${searchItemController}',
                                  };
                                  print('search item from filter: $searchItem');
                                  // Navigator.pushReplacement(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             SearchItemsScreen(
                                  //                 categoryTitle: searchItem)));
                                  context
                                      .read<GetCategoryListing>()
                                      .convertSearchToSave(
                                          searchMap: searchItem);
                                  await context
                                      .read<GetCategoryListing>()
                                      .getCategoryListing(context,
                                          parametersMap: searchItem);
                                  if (!context.mounted) return;
                                  context
                                      .read<GetCategoryListing>()
                                      .applyFilter();
                                  Navigator.pop(context);
                                }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
