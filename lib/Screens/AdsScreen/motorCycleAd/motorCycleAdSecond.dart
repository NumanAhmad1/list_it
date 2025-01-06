import 'package:lisit_mobile_app/Screens/AdsScreen/motorCycleAd/motorCycleAdthrid.dart';
import 'package:lisit_mobile_app/Screens/AdsScreen/motorCycleAd/widget/motorCycleCategory.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class MotorCycleAdSecond extends StatefulWidget {
  String selectedCategoryName;
  MotorCycleAdSecond({required this.selectedCategoryName, super.key});

  @override
  State<MotorCycleAdSecond> createState() => _MotorCycleAdSecondState();
}

class _MotorCycleAdSecondState extends State<MotorCycleAdSecond> {
  List categoryList = [
    'Hyper sports',
    'Super bike',
    'Super sports',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: H2Bold(text: TextName.placeAnAd),
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.keyboard_arrow_left_outlined)),
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: const Icon(Icons.close),
              ))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: ksearchFieldColor),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 33.h,
              ),
              H3semi(text: '${TextName.chooseTheRightCategoryForYourAd}:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  H3Regular(text: '...>Motors>${widget.selectedCategoryName}'),
                ],
              ),
              SizedBox(
                height: 45.h,
              ),
              Divider(
                color: khelperTextColor,
              ),
              SizedBox(
                height: 936.h,
                child: ListView.builder(
                    itemCount: categoryList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MotorCycleAddThird()));
                          },
                          child:
                              MotorCycleCategory(title: categoryList[index]));
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
