import 'package:lisit_mobile_app/const/lib_all.dart';

class HeavyVechilesAdThird extends StatefulWidget {
  const HeavyVechilesAdThird({super.key});

  @override
  State<HeavyVechilesAdThird> createState() => _HeavyVechilesAdThirdState();
}

class _HeavyVechilesAdThirdState extends State<HeavyVechilesAdThird> {
  List selectedImages = [];
  final ImagePicker picker = ImagePicker();
  getImages() async {
    // Pick multiple images.
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isEmpty || images != null) {
      selectedImages = images.map((e) => File(e.path)).toList();
    }
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController kilometersController = TextEditingController();

  List<String> usageList = [
    'Usage',
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
    'Option 5',
  ];
  String usagedropDownValue = 'Usage';

  List<String> yearList = [
    'Year',
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
    'Option 5',
  ];
  String yeardropDownValue = 'Year';

  List<String> sellertypeList = [
    'Seller type',
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
    'Option 5',
  ];
  String sellertypedropDownValue = 'Seller type';

  List<String> warrantyList = [
    'Warranty',
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
    'Option 5',
  ];
  String warrantydropDownValue = 'Warranty';

  List<String> finalDriveSystemList = [
    'Final Drive System',
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
    'Option 5',
  ];
  String finalDriveSystemdropDownValue = 'Final Drive System';

  List<String> wheelsList = [
    'Wheels',
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
    'Option 5',
  ];
  String wheelsdropDownValue = 'Wheels';

  List<String> manufacturerList = [
    'Manufacturer',
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
    'Option 5',
  ];
  String manufacturerdropDownValue = 'Manufacturer';

  List<String> engineSizeList = [
    'Engine Size',
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
    'Option 5',
  ];
  String engineSizedropDownValue = 'Engine Size';

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
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: ksearchFieldColor),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                H2Bold(text: TextName.youAreAlmostThere),
                SizedBox(
                  width: 353.w,
                  child: H3semi(text: TextName.includeAsMuchDetailsAndPictures),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    H3Regular(
                      text: 'Sport Bike > Super Bike',
                      color: kprimaryColor2,
                    ),
                  ],
                ),

                SizedBox(
                  height: 45.h,
                ),

                AdInputField(
                  onChanged: (value) {},
                  title: 'Title',
                  // controller: titleController,
                  keybordType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 40.h,
                ),
                GestureDetector(
                  onTap: () async {
                    await getImages();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 350.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.w,
                        color: khelperTextColor,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/camera.svg'),
                        SizedBox(
                          width: 5.w,
                        ),
                        H3semi(text: TextName.addPictures),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                AdInputField(
                  onChanged: (value) {},
                  title: 'Phone Number',
                  // controller: phoneNumberController,
                  keybordType: TextInputType.phone,
                ),
                SizedBox(
                  height: 40.h,
                ),
                AdInputField(
                  onChanged: (value) {},
                  title: 'Price',
                  // controller: priceController,
                  keybordType: TextInputType.number,
                ),

                SizedBox(
                  height: 40.h,
                ),

                //describe you car

                Container(
                  alignment: Alignment.topLeft,
                  height: 210.h,
                  width: 350.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.r),
                    border: Border.all(
                      width: 1,
                      color: ksecondaryColor2,
                    ),
                  ),
                  child: TextField(
                    maxLines: 15,
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).primaryColor,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Describe Your Sports Bike',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 40.h,
                ),
                SelectOptionForSecondAdScreen(
                  isOptional: false,
                  dropDownValue: usagedropDownValue,
                  dropdownlist: usageList,
                ),
                SizedBox(
                  height: 40.h,
                ),
                AdInputField(
                  onChanged: (value) {},
                  title: 'Kilometers',
                  // controller: kilometersController,
                  keybordType: TextInputType.number,
                ),
                SizedBox(
                  height: 40.h,
                ),

                //year

                SelectOptionForSecondAdScreen(
                    isOptional: false,
                    dropDownValue: yeardropDownValue,
                    dropdownlist: yearList),
                SizedBox(
                  height: 40.h,
                ),

                //seller type
                SelectOptionForSecondAdScreen(
                    isOptional: false,
                    dropDownValue: sellertypedropDownValue,
                    dropdownlist: sellertypeList),
                SizedBox(
                  height: 40.h,
                ),

                //warrenty

                SelectOptionForSecondAdScreen(
                    isOptional: false,
                    dropDownValue: warrantydropDownValue,
                    dropdownlist: warrantyList),
                SizedBox(
                  height: 40.h,
                ),

                //final drive system

                SelectOptionForSecondAdScreen(
                    isOptional: false,
                    dropDownValue: finalDriveSystemdropDownValue,
                    dropdownlist: finalDriveSystemList),
                SizedBox(
                  height: 40.h,
                ),

                //wheels

                SelectOptionForSecondAdScreen(
                    isOptional: false,
                    dropDownValue: wheelsdropDownValue,
                    dropdownlist: wheelsList),
                SizedBox(
                  height: 40.h,
                ),

                //manufacturer

                SelectOptionForSecondAdScreen(
                    isOptional: false,
                    dropDownValue: manufacturerdropDownValue,
                    dropdownlist: manufacturerList),
                SizedBox(
                  height: 40.h,
                ),

                //engine size

                SelectOptionForSecondAdScreen(
                    isOptional: false,
                    dropDownValue: engineSizedropDownValue,
                    dropdownlist: engineSizeList),
                SizedBox(
                  height: 40.h,
                ),

                // map image

                Padding(
                  padding: EdgeInsets.all(10.w),
                  child: SizedBox(
                    child: Image.asset('assets/locationMap.png'),
                  ),
                ),

                // next button
                Padding(
                  padding: EdgeInsets.only(top: 30.h, bottom: 20.h),
                  child: SizedBox(
                      height: 47.h,
                      child: MainButton(text: 'Next', onTap: () {})),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
