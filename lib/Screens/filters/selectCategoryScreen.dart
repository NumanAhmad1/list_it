import 'package:lisit_mobile_app/Controller/Providers/data/getCategory.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/getCities.dart';
import 'package:lisit_mobile_app/Screens/filters/advanceFilter.dart';
import 'package:lisit_mobile_app/Screens/filters/filterValues.dart';
import 'package:lisit_mobile_app/Screens/filters/filtersScreen.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class SelectCategoryScreen extends StatefulWidget {
  const SelectCategoryScreen({super.key});

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kbackgrounColor,
      child: SafeArea(
        child: Scaffold(
          body: Consumer<GetCities>(builder: (context, value, child) {
            return Column(
              children: [
                SizedBox(
                  height: 40.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox.shrink(),
                    H2Bold(text: Controller.getTag('motors')),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: const Icon(Icons.close),
                        )),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                H3semi(
                    text: Controller.getTag(
                        'select_the_area_that_best_suits_your_ad')),
                SizedBox(
                  height: 40.h,
                ),
                value.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : value.error.isNotEmpty
                        ? Center(
                            child: H2Bold(text: value.error.toString()),
                          )
                        : Expanded(
                            child: ListView.builder(
                                itemCount: value.categories.length,
                                itemBuilder: (context, index) {
                                  return MotorsCategory(
                                      title: Controller.languageChange(
                                          english: value.categories[index]
                                              ['name'],
                                          arabic: value.categories[index]
                                              ['name_ar']),
                                      onTap: () {
                                        context
                                            .read<FilterValues>()
                                            .updateCategory(
                                                keyword: Controller
                                                    .languageChange(
                                                        english:
                                                            value
                                                                    .categories[
                                                                index]['name'],
                                                        arabic: value
                                                                .categories[
                                                            index]['name_ar']),
                                                key: 'Category');
                                        context
                                            .read<FilterValues>()
                                            .selectValue(
                                                value: 'Category',
                                                dropdownList: value.categories,
                                                index: index);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AdvanceFilters(
                                                      category: context
                                                          .read<FilterValues>()
                                                          .results['Category'],
                                                    )));
                                        // Navigator.pop(context);
                                      });
                                }),
                          ),
              ],
            );
          }),
        ),
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
