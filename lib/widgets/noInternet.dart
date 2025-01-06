import 'package:lisit_mobile_app/const/lib_all.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.7.sh,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 257.h,
            width: 255.w,
            child: Image.asset('assets/noInternetImage.png'),
          ),
          SizedBox(
            height: 22.h,
          ),
          H2semi(text: Controller.getTag('no_internet')),
        ],
      ),
    );
  }
}
