import 'package:lisit_mobile_app/Controller/Providers/data/getCities.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class SelectCityCard extends StatefulWidget {
  const SelectCityCard({
    super.key,
  });

  @override
  State<SelectCityCard> createState() => _SelectCityCardState();
}

class _SelectCityCardState extends State<SelectCityCard> {
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
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Consumer<GetCities>(builder: (context, value, child) {
        return Container(
          clipBehavior: Clip.hardEdge,
          height: 560.h,
          width: 1.sw,
          decoration: BoxDecoration(
            color: kbackgrounColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: value.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    //language title
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 27.w, right: 20.w),
                      height: 70.h,
                      width: 1.sw,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 0.5.w,
                            color: ksearchFieldColor,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          H1semi(text: Controller.getTag('city')),
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.close))
                        ],
                      ),
                    ),

                    //english
                    Expanded(
                      child: ListView.builder(
                          itemCount: value.cities.length,
                          itemBuilder: (context, index) {
                            String cityName = Controller.languageChange(
                                english: value.cities[index]['value'],
                                arabic: value.cities[index]['value_ar']);
                            return GestureDetector(
                              onTap: () {
                                Controller.saveCity(City: cityName);
                                setState(() {});
                              },
                              child: Container(
                                padding:
                                    EdgeInsets.only(left: 27.w, right: 20.w),
                                alignment: Alignment.centerLeft,
                                height: 60.h,
                                width: 1.sw,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 0.5.w,
                                      color: ksearchFieldColor,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    H2semi(text: '${cityName}'),
                                    if (Controller.getCity() == cityName)
                                      Icon(
                                        Icons.check,
                                        color: kprimaryColor,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
        );
      }),
    );
  }
}
