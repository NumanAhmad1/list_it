import 'package:lisit_mobile_app/Controller/Providers/data/getCities.dart';
import 'package:lisit_mobile_app/Screens/motors/motors.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

import '../AdsScreen/carAd/carAdOne.dart';
import 'widget/selectCityTile.dart';

class SelectCityScreen extends StatefulWidget {
  SelectCityScreen({super.key});

  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  getEmirateData() async {
    if (context.read<GetCities>().cities.isEmpty) {
      await context
          .read<GetCities>()
          .getCities(context, teldaSeparatedFilterValues: "Category~Emirates");
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getEmirateData();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 1.sh,
        color: kbackgrounColor,
        child: Consumer<GetCities>(builder: (context, value, child) {
          return Column(
            children: [
              SizedBox(
                height: 50.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
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
              SizedBox(
                height: 560.h,
                child: ListView.builder(
                    itemCount: value.cities.length,
                    itemBuilder: (context, index) {
                      String cityName = Controller.languageChange(
                          english: value.cities[index]['value'],
                          arabic: value.cities[index]['value_ar']);
                      return SelectCityTile(
                        cityName: cityName,
                        onTap: () async {
                          await Controller.saveEmirate(emirate: cityName);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Motors(),
                              //  PlaceAdFirst(
                              //   city: ciytName[index],
                              // ),
                            ),
                          );
                        },
                      );
                    }),
              ),
            ],
          );
        }),
      ),
    );
  }
}
