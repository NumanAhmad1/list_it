import 'package:lisit_mobile_app/const/lib_all.dart';

class SelectCategoryScreen extends StatefulWidget {
  const SelectCategoryScreen({super.key});

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 40.h,
          ),
          H2Bold(text: 'Category'),
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            height: 40.h,
          ),
          MotorsCategory(
              title: 'Car',
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => VINNumberFirst(
                //       categoryName: 'Car',
                //     ),
                //   ),
                // );
              }),
          MotorsCategory(
              title: 'Motorcycles',
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => MotorCycleAdFirst(
                //       categoryName: 'MotorCycle',
                //     ),
                //   ),
                // );
              }),
          MotorsCategory(
              title: 'Heavy Vehicles',
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => HeavyVehiclesAdOne(
                //       categoryName: 'Heavy Vehicles',
                //     ),
                //   ),
                // );
              }),
        ],
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
