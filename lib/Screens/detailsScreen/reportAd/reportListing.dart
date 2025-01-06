import 'package:lisit_mobile_app/Controller/Providers/data/adReport.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

import 'SpamScreen.dart';

class ReportListing extends StatefulWidget {
  String adId;
  ReportListing({super.key, required this.adId});

  @override
  State<ReportListing> createState() => _ReportListingState();
}

class _ReportListingState extends State<ReportListing> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    await context.read<AdReport>().reportConfig(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                          height: 24.h,
                          width: 24.w,
                          child: Icon(Icons.arrow_back_ios_new_rounded)),
                    ),
                    H2Bold(text: Controller.getTag('report_this_listing')),
                    const SizedBox.shrink(),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: const Divider(),
                ),
                SingleChildScrollView(
                  child: Consumer<AdReport>(builder: (context, value, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        context.read<AdReport>().resportConfigList.length,
                        (index) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SpamScreen(
                                  adId: widget.adId,
                                  title: value.resportConfigList[index],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            color: kbackgrounColor,
                            height: 75.h,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                H3semi(
                                    text:
                                        "${value.resportConfigList[index]['ReportType']}"),
                                Padding(
                                  padding: EdgeInsets.only(top: 20.h),
                                  child: const Divider(
                                    thickness: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).toList(),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
