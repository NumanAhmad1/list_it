import 'package:lisit_mobile_app/Controller/Providers/data/getDetailsbyVin.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

import '../AdsScreen/carAd/carAdOne.dart';

class VINNumberFirst extends StatefulWidget {
  String categoryName;
  VINNumberFirst({required this.categoryName, super.key});

  @override
  State<VINNumberFirst> createState() => _VINNumberFirstState();
}

class _VINNumberFirstState extends State<VINNumberFirst> {
  TextEditingController vinController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: ksecondaryColor,
            )),
        title: H2Bold(text: Controller.getTag('motors')),
        centerTitle: true,
        surfaceTintColor: kbackgrounColor,
        foregroundColor: kbackgrounColor,
        backgroundColor: kbackgrounColor,
      ),
      body: SingleChildScrollView(
        child: Consumer<GetDetailsbyVin>(builder: (context, value, child) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Column(
              children: [
                SizedBox(height: 50.h),
                // title auto fill your
                SizedBox(
                  width: 261.w,
                  child: H3Bold(text: Controller.getTag('autofill_from_vin')),
                ),
                SizedBox(height: 43.h),
                // sub title what is a VIN
                GestureDetector(
                  onTap: () {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            content: Container(
                              height: 726.h,
                              width: 386.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                color: kbackgrounColor,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 33.h,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Icon(Icons.close)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 26.h,
                                    ),
                                    H2Bold(text: Controller.getTag('get_vin')),
                                    SizedBox(
                                      height: 30.h,
                                    ),
                                    H3Regular(
                                        text: Controller.getTag(
                                            'chassis_info_statement')),
                                    SizedBox(
                                      height: 30.h,
                                    ),
                                    H2semi(
                                        text: Controller.getTag('where_find')),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    H3Regular(
                                        text: Controller.getTag(
                                            'on_vehicle_registration')),
                                    // SizedBox(
                                    //   height: 21.h,
                                    // ),

                                    // image
                                    SizedBox(
                                      height: 138.h,
                                      width: 335.w,
                                      child: Image.asset(
                                        'assets/vin_details.png',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 22.h,
                                    ),
                                    H3Regular(
                                        text: Controller.getTag(
                                            'on_vehicle_registration')),
                                    // SizedBox(
                                    //   height: 21.h,
                                    // ),
                                    SizedBox(
                                      height: 162.h,
                                      width: 289.w,
                                      child: Image.asset(
                                          'assets/vinInfoWindShield.png'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  child: H3Regular(
                    text: Controller.getTag('get_vin'),
                    color: kprimaryColor,
                  ),
                ),

                SizedBox(height: 49.h),
                // image
                SizedBox(
                  height: 138.h,
                  width: 335.w,
                  child: Image.asset(
                    'assets/vin_details.png',
                  ),
                ),
                SizedBox(height: 30.h),
                // vin textfield

                AdInputField(
                  isRequiredCheck: false,
                  onChanged: (value) {},
                  title: Controller.getTag('enter_vin'),
                  controller: vinController,
                  keybordType: TextInputType.streetAddress,
                ),

                SizedBox(height: 17.h),
                // this number will not show on your ad

                H3Regular(
                    text: Controller.getTag(
                        'this_number_will_not_show_on_your_ad')),

                SizedBox(height: 35.h),
                // auto fill button

                SizedBox(
                  height: 47.h,
                  child: value.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : MainButton(
                          text: Controller.getTag('autofill_car_details'),
                          onTap: () async {
                            await context
                                .read<GetDetailsbyVin>()
                                .getCarDataByVin(context,
                                    carVin:
                                        '${vinController.text.trim().toString()}')
                                .then((valuee) {
                              if (value.error.isEmpty) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CarAdOne(
                                              lastCategoreyNameAr: 'Cars',
                                              lastCategoreyName: 'Cars',
                                            )));
                              } else {
                                DisplayMessage(
                                    context: context,
                                    isTrue: false,
                                    message: value.error.toString());
                              }
                            });
                          },
                        ),
                ),
                SizedBox(height: 24.h),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CarAdOne(
                                  lastCategoreyNameAr: 'Cars',
                                  lastCategoreyName: 'Cars',
                                )));
                  },
                  child: H3semi(
                    text: Controller.getTag('fill_detail_manually'),
                    color: kprimaryColor,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
