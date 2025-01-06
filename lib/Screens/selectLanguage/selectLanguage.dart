import 'package:lisit_mobile_app/const/lib_all.dart';
import 'package:lisit_mobile_app/services/localProvider.dart';

class SelectLanguageCard extends StatefulWidget {
  const SelectLanguageCard({
    super.key,
  });

  @override
  State<SelectLanguageCard> createState() => _SelectLanguageCardState();
}

class _SelectLanguageCardState extends State<SelectLanguageCard> {
  @override
  void initState() {
    print('init is called');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        clipBehavior: Clip.hardEdge,
        height: 191.h,
        width: 386.w,
        decoration: BoxDecoration(
          color: kbackgrounColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
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
                  H1semi(text: Controller.getTag('language')),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.close))
                ],
              ),
            ),

            //english
            GestureDetector(
              onTap: () {
                context.read<LocalProvider>().englishLoading();
                Controller.saveLanguage(language: 'English');
                setState(() {});
                context.read<LocalProvider>().setLocal();
              },
              child: Container(
                padding: EdgeInsets.only(left: 27.w, right: 20.w),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('English',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                        overflow: TextOverflow.ellipsis,
                      ),),
                    if (Controller.getLanguage() == 'English')
                      Icon(
                        Icons.check,
                        color: kprimaryColor,
                      ),
                  ],
                ),
              ),
            ),

            //Arabi
            GestureDetector(
              onTap: () {
                context.read<LocalProvider>().arabicLoading();
                Controller.saveLanguage(language: 'Arabic');
                setState(() {});
                context.read<LocalProvider>().setLocal();
              },
              child: Container(
                padding: EdgeInsets.only(left: 27.w, right: 20.w),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('عربی',
                        style: TextStyle(
                      fontSize: 18.sp,
                      fontFamily: GoogleFonts.tajawal().fontFamily,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                      overflow: TextOverflow.ellipsis,
                    ),),
                    if (Controller.getLanguage() == 'Arabic')
                      Icon(
                        Icons.check,
                        color: kprimaryColor,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
