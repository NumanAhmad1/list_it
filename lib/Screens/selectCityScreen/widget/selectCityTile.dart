import 'package:lisit_mobile_app/const/lib_all.dart';

class SelectCityTile extends StatelessWidget {
  String cityName;
  Function() onTap;
  SelectCityTile({
    required this.cityName,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 5.h),
        child: Container(
          width: 1.sw,
          height: 41.h,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 17.w),
                child: H3semi(
                  text: cityName,
                  color: ksecondaryColor,
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
