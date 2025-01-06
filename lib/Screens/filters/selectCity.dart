import 'package:lisit_mobile_app/Controller/Providers/data/getCities.dart';
import 'package:lisit_mobile_app/Screens/filters/filterValues.dart';
import 'package:lisit_mobile_app/Screens/filters/filtersScreen.dart';
import 'package:lisit_mobile_app/Screens/motors/motors.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

import '../selectCityScreen/widget/selectCityTile.dart';

class SelectCity extends StatelessWidget {
  SelectCity({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kbackgrounColor,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: kbackgrounColor,
            child: Consumer<GetCities>(builder: (context, value, child) {
              return Column(
                children: [
                  SizedBox(
                    height: 50.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox.shrink(),
                      H2Bold(text: Controller.getTag('select_city')),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      H3semi(text: Controller.getTag('where_place_ad')),
                    ],
                  ),

                  // city
                  SizedBox(
                    height: 30.h,
                  ),
                  value.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : value.error.isNotEmpty
                          ? Center(
                              child: H2Bold(text: value.error.toString()),
                            )
                          : SizedBox(
                              height: 560.h,
                              child: ListView.builder(
                                  itemCount: value.cities.length,
                                  itemBuilder: (context, index) {
                                    return SelectCityTile(
                                      cityName: Controller.languageChange(english: value.cities[index]['value'], arabic: value.cities[index]['value_ar']),
                                      onTap: () {
                                        context.read<FilterValues>().updateCategory(
                                            keyword:
                                            Controller.languageChange(english: value.cities[index]['value'], arabic: value.cities[index]['value_ar']),
                                            key: 'Emirates');
                                        context
                                            .read<FilterValues>()
                                            .selectValue(
                                                value: 'Emirates',
                                                dropdownList: value.cities,
                                                index: index);
                                        Navigator.pop(context);
                                      },
                                    );
                                  }),
                            ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
