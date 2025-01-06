import 'dart:developer';

import 'package:lisit_mobile_app/Controller/controller.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final picker = ImagePicker();

  XFile? image;

  getImageFile() async {
    XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      image = file;
      setState(() {});
    }
  }

  bool isNameGiven = false;
  bool isEmailGiven = false;
  bool isPhoneGiven = false;
  bool isDescriptionGiven = false;
  validateForm() {
    if (nameController.text.isEmpty) {
      isNameGiven = true;
      setState(() {});
    } else {
      isNameGiven = false;
      setState(() {});
    }
    if (emailController.text.isNotEmpty && emailController.text.contains('@')) {
      isEmailGiven = false;
      setState(() {});
    } else {
      isEmailGiven = true;
      setState(() {});
    }
    if (phoneController.text.isEmpty) {
      isPhoneGiven = true;
      setState(() {});
    } else {
      isPhoneGiven = false;
      setState(() {});
    }
    if (descriptionController.text.isEmpty) {
      isDescriptionGiven = true;
      setState(() {});
    } else {
      isDescriptionGiven = false;
      setState(() {});
    }
  }

  bool isLoading = false;

  Future contactUsApiCall() async {
    isLoading = true;
    setState(() {});
    var response = await CallApi.postApi(context,
        token: Controller.getUserToken(),
        isInsideData: true,
        parametersList: {
          'name': nameController.text.trim().toString(),
          'email': emailController.text.trim().toString(),
          'phone': phoneController.text.trim().toString(),
          'comment': descriptionController.text.trim().toString(),
        },
        isAdmin: false,
        endPoint: '/contact-us');

    isLoading = false;
    setState(() {});

    if (response is! String) {
      if (response is Map<String, dynamic>) {
        Map<String, dynamic> data = response as Map<String, dynamic>;
        if (data['success'] == true) {
          phoneController.clear();
          nameController.clear();
          emailController.clear();
          descriptionController.clear();
          DisplayMessage(
              context: context,
              isTrue: true,
              message: Controller.languageChange(
                  english: data['message'], arabic: data['message_ar']));
        } else {
          DisplayMessage(
              context: context,
              isTrue: false,
              message: data['error'] ??
                  Controller.languageChange(
                      english: data['message'], arabic: data['message_ar']));
        }
      } else {
        DisplayMessage(
            context: context,
            isTrue: false,
            message: Controller.getTag('unable_to_process_data'));
      }
    } else {
      DisplayMessage(context: context, isTrue: false, message: response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // AppBar
            Container(
              width: 1.sw,
              height: 90.h,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: ksearchFieldColor),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // back icon
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back_ios_new_rounded)),

                    //Notification title

                    H2Bold(text: Controller.getTag('support')),

                    // trash icon button

                    const SizedBox.shrink(),
                  ],
                ),
              ),
            ),

            //Support Screen body

            Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                // logo

                SizedBox(
                  width: 85.91.w,
                  height: 32.28.h,
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(
                  height: 20.h,
                ),

                // name text

                Padding(
                  padding: EdgeInsets.only(
                    left: 30.w,
                    bottom: 10.h,
                  ),
                  child: Row(
                    children: [
                      H3semi(text: '${Controller.getTag('name')} '),
                      H3semi(
                        text: '*',
                        color: kredText,
                      ),
                    ],
                  ),
                ),
                //name input field
                AdInputField(
                  controller: nameController,
                  isRequiredCheck: isNameGiven,
                  onChanged: (value) {
                    isNameGiven = false;
                    final cursorPosition = nameController.selection.baseOffset;
                    setState(() {});
                    nameController.selection = TextSelection.fromPosition(
                        TextPosition(offset: cursorPosition));
                  },
                  title: Controller.getTag('name'),
                  // controller: nameController,
                  keybordType: TextInputType.name,
                ),
                SizedBox(
                  height: 20.h,
                ),

                // email text

                Padding(
                  padding: EdgeInsets.only(
                    left: 30.w,
                    bottom: 10.h,
                  ),
                  child: Row(
                    children: [
                      H3semi(
                          text: '${Controller.getTag('your_email_address')} '),
                      H3semi(
                        text: '*',
                        color: kredText,
                      ),
                    ],
                  ),
                ),
                //Email input field
                AdInputField(
                  controller: emailController,
                  isRequiredCheck: isEmailGiven,
                  onChanged: (value) {
                    isEmailGiven = false;
                    final cursorPosition = emailController.selection.baseOffset;
                    setState(() {});
                    emailController.selection = TextSelection.fromPosition(
                        TextPosition(offset: cursorPosition));
                  },
                  title: Controller.getTag('email'),
                  // controller: emailController,
                  keybordType: TextInputType.emailAddress,
                ),

                SizedBox(
                  height: 20.h,
                ),

                // // subject text

                // Padding(
                //   padding: EdgeInsets.only(
                //     left: 30.w,
                //     bottom: 10.h,
                //   ),
                //   child: Row(
                //     children: [
                //       H3semi(text: 'Subject '),
                //       H3semi(
                //         text: '*',
                //         color: kredText,
                //       ),
                //     ],
                //   ),
                // ),
                // //Email input field
                // AdInputField(
                //   onChanged: (value) {},
                //   title: '',
                //   // controller: subjectController,
                //   keybordType: TextInputType.emailAddress,
                // ),

                // SizedBox(
                //   height: 20.h,
                // ),

                // phone text

                Padding(
                  padding: EdgeInsets.only(
                    left: 30.w,
                    bottom: 10.h,
                  ),
                  child: Row(
                    children: [
                      H3semi(text: '${Controller.getTag('phone')} '),
                      H3semi(
                        text: '*',
                        color: kredText,
                      ),
                    ],
                  ),
                ),
                //phone input field
                AdInputField(
                  controller: phoneController,
                  isRequiredCheck: isPhoneGiven,
                  onChanged: (value) {
                    isPhoneGiven = false;
                    final cursorPosition = phoneController.selection.baseOffset;
                    setState(() {});
                    phoneController.selection = TextSelection.fromPosition(
                        TextPosition(offset: cursorPosition));
                  },
                  title: Controller.getTag('phone'),
                  // controller: phoneController,
                  keybordType: TextInputType.phone,
                ),
                SizedBox(
                  height: 20.h,
                ),

                // description text

                Padding(
                  padding: EdgeInsets.only(
                    left: 30.w,
                    bottom: 10.h,
                  ),
                  child: Row(
                    children: [
                      H3semi(text: '${Controller.getTag('Description')} '),
                      H3semi(
                        text: '*',
                        color: kredText,
                      ),
                    ],
                  ),
                ),

                //Description
                Container(
                  alignment: Alignment.topLeft,
                  height: 210.h,
                  width: 350.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.r),
                    border: Border.all(
                      width: 2,
                      color: isDescriptionGiven ? kredColor : khelperTextColor,
                    ),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      isDescriptionGiven = false;
                      final cursorPosition =
                          descriptionController.selection.baseOffset;
                      setState(() {});
                      descriptionController.selection =
                          TextSelection.fromPosition(
                              TextPosition(offset: cursorPosition));
                    },
                    maxLines: 15,
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily:
                          Controller.getLanguage().toString().toLowerCase() ==
                                  "english"
                              ? GoogleFonts.montserrat().fontFamily
                              : GoogleFonts.tajawal().fontFamily,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).primaryColor,
                    ),
                    decoration: InputDecoration(
                      hintText: Controller.getTag('leave_a_message_here'),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),

                // // attacht text

                // Padding(
                //   padding: EdgeInsets.only(
                //     left: 30.w,
                //     bottom: 10.h,
                //   ),
                //   child: Row(
                //     children: [
                //       H3semi(text: 'Attachments '),
                //     ],
                //   ),
                // ),

                // //add images button
                // GestureDetector(
                //   onTap: () async {
                //     await getImageFile();
                //     print(image!.path);
                //   },
                //   child: Container(
                //     alignment: Alignment.center,
                //     width: 350.w,
                //     height: 48.h,
                //     decoration: BoxDecoration(
                //       border: RDottedLineBorder.all(
                //         width: 2.w,
                //         color: kredText,
                //       ),
                //       // border: Border.R(
                //       //   width: 2.w,
                //       //   color: khelperTextColor,
                //       // ),
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Icon(
                //           Icons.camera_alt_outlined,
                //           color: kredText,
                //         ),
                //         SizedBox(
                //           width: 5.w,
                //         ),
                //         H3semi(
                //           text: 'Add file',
                //           color: kredText,
                //         ),
                //         H3semi(
                //           text: ' or drop file here',
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 20.h,
                // ),

                SizedBox(
                  height: 52.h,
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : MainButton(
                          text: Controller.getTag('submit'),
                          onTap: () async {
                            validateForm();
                            if (isNameGiven == false &&
                                isEmailGiven == false &&
                                isPhoneGiven == false &&
                                isDescriptionGiven == false) {
                              await contactUsApiCall();
                            }
                          },
                        ),
                ),

                SizedBox(
                  height: 20.h,
                ),
              ],
            ),

            //column1 end
          ],
        ),
      ),
    );
  }
}
