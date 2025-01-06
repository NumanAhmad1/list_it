import 'dart:developer';

import 'package:lisit_mobile_app/Controller/Providers/data/getCategory.dart';
import 'package:lisit_mobile_app/Screens/AdsScreen/carAd/carAdOne.dart';
import 'package:lisit_mobile_app/Screens/AdsScreen/carAd/carAdTwo.dart';
import 'package:lisit_mobile_app/Screens/AuthScreens/loginScreen/loginScreen.dart';
import 'package:lisit_mobile_app/Screens/vinNumber/vinNumberFirst.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class Motors extends StatefulWidget {
  const Motors({super.key});

  @override
  State<Motors> createState() => _MotorsState();
}

class _MotorsState extends State<Motors> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  bool checkToken = false;

  Future getData() async {
    Provider.of<GetCategory>(context, listen: false).subCategoryiesList.clear();

    bool isTokenTrue = await context.read<GetCategory>().checkToken(context);

    if (isTokenTrue) {
      await context.read<GetCategory>().getCategories(context, parentId: '0');
    } else {
      log('isToken is false');
      checkToken = true;
      DisplayMessage(
          context: context,
          isTrue: false,
          message: Controller.getTag('login_to_continue'));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    log('$checkToken');
    return checkToken
        ? LoginScreen()
        : WillPopScope(
            onWillPop: () async {
              final categoryProvider = context.read<GetCategory>();

              if (categoryProvider.subCategoryiesList.length == 1 ||
                  categoryProvider.subCategoryiesList.isEmpty) {
                categoryProvider.subCategoryiesList.clear();
                Navigator.pop(context);
                return true;
              } else {
                print(
                    'this is subcategories: ${categoryProvider.subCategoryiesList}');
                await categoryProvider.goToPreviousCategory(context);
                return false;
              }
            },
            child: Scaffold(
              body: Consumer<GetCategory>(builder: (context, data, child) {
                Future<bool> onWillPopCallback() async {
                  final categoryProvider = context.read<GetCategory>();

                  // print(object)

                  if (categoryProvider.subCategoryiesList.length == 1 ||
                      categoryProvider.subCategoryiesList.isEmpty) {
                    categoryProvider.subCategoryiesList.clear();
                    return true; // Allow the screen to pop
                  } else {
                    await categoryProvider.goToPreviousCategory(context);
                    return false; // Prevent the screen from popping immediately
                  }
                }

                return Column(
                  children: [
                    SizedBox(
                      height: 50.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () async {
                              print('is back');
                              bool canPop = await onWillPopCallback();
                              if (canPop) {
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              color: kbackgrounColor,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 13.w, vertical: 7.h),
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                ),
                              ),
                            )),
                        H2Bold(text: Controller.getTag('motors')),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 13.w),
                          child: const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    H3semi(text: Controller.getTag('select_category')),
                    // SizedBox(
                    //   height: 20.h,
                    // ),
                    Expanded(
                      child: data.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : data.error.isNotEmpty
                              ? Center(child: H2Bold(text: '${data.error}'))
                              : data.categoryiesList.isEmpty
                                  ? Center(
                                      child: H2Bold(
                                          text: Controller.getTag('no_data')))
                                  : ListView.builder(
                                      itemCount: data.categoryiesList.length,
                                      itemBuilder: (context, index) {
                                        final value =
                                            data.categoryiesList[index];
                                        return MotorsCategory(
                                            title: Controller.languageChange(
                                                english: value.name,
                                                arabic: value.nameAr),
                                            onTap: () {
                                              data.goNexCategory(
                                                  data.categoryiesList[index]);
                                              data.subCategoryiesList
                                                  .forEach((element) {
                                                log(element.name);
                                              });
                                              // data.subCategoryiesList.forEach((element) {
                                              //   print('CategoryName: ${element.name}');
                                              // });
                                              if (data.categoryiesList[index]
                                                      .id ==
                                                  135) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        VINNumberFirst(
                                                            categoryName:
                                                                'Cars'),
                                                    //     CarAdOne(
                                                    //   lastCategoreyNameAr: data
                                                    //       .categoryiesList[
                                                    //           index]
                                                    //       .nameAr,
                                                    //   lastCategoreyName: data
                                                    //       .categoryiesList[
                                                    //           index]
                                                    //       .name,
                                                    // ),
                                                  ),
                                                );
                                              } else if (value.isParent) {
                                                data.getCategories(context,
                                                    parentId:
                                                        value.id.toString());
                                              } else if (value.isParent ==
                                                      false &&
                                                  value.isActive == true) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CarAdTwo(
                                                      lastCategoryNameAr: data
                                                          .subCategoryiesList[1]
                                                          .nameAr,
                                                      lastCategoryName: data
                                                          .subCategoryiesList[1]
                                                          .name,
                                                      categoryId:
                                                          value.id.toString(),
                                                      ListingSummary: [],
                                                    ),
                                                  ),
                                                );
                                              }
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) => MotorCycleAdFirst(
                                              //       categoryName: 'MotorCycle',
                                              //     ),
                                              //   ),
                                              // );
                                            });
                                      },
                                    ),
                    ),

                    // MotorsCategory(
                    //     title: 'Motorcycles',
                    //     onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => MotorCycleAdFirst(
                    //       categoryName: 'MotorCycle',
                    //     ),
                    //   ),
                    // );
                    // }),
                    // MotorsCategory(
                    //   title: 'Heavy Vehicles',
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => HeavyVehiclesAdOne(
                    //           categoryName: 'Heavy Vehicles',
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                  ],
                );
              }),
            ),
          );
  }

  MotorsCategory({
    required String title,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        margin: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.w, color: ksearchFieldColor),
          ),
        ),
        height: 38.h,
        width: 1.sw,
        child: H3semi(text: title),
      ),
    );
  }
}
