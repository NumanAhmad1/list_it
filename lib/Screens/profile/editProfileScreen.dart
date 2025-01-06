import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/addSummary.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/updateProfile.dart';
import 'package:lisit_mobile_app/Screens/verifyNumber/enterNumber.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

class EditProfileScreen extends StatefulWidget {
  Function()? callbackProfile;
  Function()? callbackMenue;
  EditProfileScreen({
    this.callbackProfile,
    this.callbackMenue,
    super.key,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  bool showNameField = false;
  bool showNumberField = false;
  String photoUrl = '';
  List userName = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userName = Controller.getUserName().toString().split(' ');
    mobileNumberController.text = Controller.getUserPhoneNumber();
    print(userName);

    firstNameController.text = userName[0] ?? '';
    lastNameController.text = userName.last == userName[0] ? '' : userName.last;
    photoUrl = Controller.getUserPhotoUrl();
    print('last name');
    print(userName.last);
    print(firstNameController.text);
    print(lastNameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //appbar section
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

                    //Edit profile title

                    H2Bold(text: Controller.getTag('edit_profile')),

                    const SizedBox.shrink(),
                  ],
                ),
              ),
            ),

            //body section

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(
                    height: 15.h,
                  ),
                  // profile image
                  GestureDetector(
                    onTap: () async {
                      var result =
                          await context.read<AddSummary>().uploadImage();

                      if (result is String && result.isNotEmpty) {
                        photoUrl = result;
                        setState(() {});
                        var isupdated = await context
                            .read<UpdateProfile>()
                            .updateUser(context, profileData: {
                          "name":
                              "${firstNameController.text.trim()} ${lastNameController.text.trim()}",
                          "profilePicture": result,
                        });

                        log(result);
                        log('${isupdated}');

                        if (isupdated['success'] == true) {
                          await Controller.saveUserName(
                              userName: isupdated['data']['Name']);
                          await Controller.saveUserPhotoUrl(
                              userPhotoUrl: isupdated['data']
                                  ['ProfilePicture']);
                          DisplayMessage(
                              context: context,
                              isTrue: true,
                              message: Controller.languageChange(
                                  english: isupdated['message'],
                                  arabic: isupdated['message_ar']));
                          widget.callbackMenue!();
                          widget.callbackProfile!();
                        } else {
                          DisplayMessage(
                              context: context,
                              isTrue: false,
                              message: context.read<UpdateProfile>().error);
                        }
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            clipBehavior: Clip.hardEdge,
                            height: 87.h,
                            width: 87.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              // color: kprimaryColor,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: photoUrl ?? 'N/A',
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/personImage.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // edit button
                          Container(
                            clipBehavior: Clip.hardEdge,
                            height: 29.h,
                            width: 29.h,
                            decoration: BoxDecoration(
                              color: kprimaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 1.w,
                                color: kbackgrounColor,
                              ),
                            ),
                            child: Icon(
                              Icons.edit_outlined,
                              color: kbackgrounColor,
                              size: 18.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),

                  AnimatedContainer(
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(),
                    height: showNameField ? 310.h : 53.h,
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Name text

                        Container(
                          height: 53.h,
                          width: 1.sw,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: khelperTextColor),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              H3semi(text: Controller.getTag('name')),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ParaRegular(
                                    text: firstNameController.text.isNotEmpty
                                        ? '${firstNameController.text.trim()} '
                                            '${lastNameController.text.trim()}'
                                        : 'N/A',
                                    color: ksecondaryColor2,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showNameField = !showNameField;
                                      setState(() {});
                                    },
                                    child: Icon(
                                      showNameField
                                          ? Icons.close
                                          : Icons.edit_outlined,
                                      color: ksecondaryColor2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // first name field
                        if (showNameField)
                          SizedBox(
                            width: 1.sw,
                            height: 70.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                H3semi(text: Controller.getTag('first_name')),
                                Container(
                                  // padding: EdgeInsets.only(left: 10.w),
                                  alignment: Alignment.centerLeft,
                                  height: 36.h,
                                  width: 1.sw,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.r),
                                    border: Border.all(
                                      color: ksecondaryColor2,
                                    ),
                                  ),
                                  child: TextField(
                                    keyboardType: TextInputType.name,
                                    controller: firstNameController,
                                    onChanged: (value) {
                                      firstNameController.text = value;
                                      setState(() {});
                                    },
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // last name field
                        if (showNameField)
                          SizedBox(
                            width: 1.sw,
                            height: 70.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                H3semi(text: Controller.getTag('last_name')),
                                Container(
                                  // padding: EdgeInsets.only(left: 10.w),
                                  alignment: Alignment.centerLeft,
                                  height: 36.h,
                                  width: 1.sw,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.r),
                                    border: Border.all(
                                      color: ksecondaryColor2,
                                    ),
                                  ),
                                  child: TextField(
                                    keyboardType: TextInputType.name,
                                    controller: lastNameController,
                                    onChanged: (value) {
                                      lastNameController.text = value;
                                      setState(() {});
                                    },
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Update name button
                        if (showNameField)
                          SizedBox(
                            height: 47.h,
                            child: context.select(
                              (UpdateProfile value) => value.isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : MainButton(
                                      text: Controller.getTag('update_name'),
                                      onTap: () async {
                                        var isupdated = await context
                                            .read<UpdateProfile>()
                                            .updateUser(context, profileData: {
                                          "name":
                                              "${firstNameController.text.trim()} ${lastNameController.text.trim()}",
                                          "profilePicture": photoUrl,
                                        });

                                        print(
                                            'this is updated data: $isupdated');
                                        // print(isupdated['data']['Name']);

                                        if (isupdated != null) {
                                          if (isupdated['success'] == true) {
                                            await Controller.saveUserName(
                                                userName: isupdated['data']
                                                    ['Name']);
                                            await Controller.saveUserPhotoUrl(
                                                userPhotoUrl: isupdated['data']
                                                    ['ProfilePicture']);
                                            DisplayMessage(
                                                context: context,
                                                isTrue: true,
                                                message:
                                                    Controller.languageChange(
                                                        english: isupdated[
                                                            'message'],
                                                        arabic: isupdated[
                                                            'message_ar']));

                                            widget.callbackMenue!();
                                            widget.callbackProfile!();
                                          } else {
                                            DisplayMessage(
                                                context: context,
                                                isTrue: false,
                                                message:
                                                    Controller.languageChange(
                                                        english: isupdated[
                                                            'message'],
                                                        arabic: isupdated[
                                                            'message_ar']));
                                          }
                                        } else {
                                          DisplayMessage(
                                              context: context,
                                              isTrue: false,
                                              message: "404: Page not found");
                                        }
                                      },
                                      isFilled: false,
                                      textColor: kprimaryColor,
                                    ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Number text
                  // Number text
                  SizedBox(
                    height: 40.h,
                  ),
                  AnimatedContainer(
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(),
                    curve: Curves.easeIn,
                    height: showNumberField ? 150.h : 53.h,
                    width: 1.sw,
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 1.sw,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: khelperTextColor),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              H3semi(text: Controller.getTag('mobile_number')),
                              if (showNumberField)
                                SizedBox(
                                    width: 244.w,
                                    child: ParaRegular(
                                        text: Controller.getTag(
                                            'mobile_number_to_verify'))),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ParaRegular(
                                    text:
                                        '${mobileNumberController.text.trim()}',
                                    color: ksecondaryColor2,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showNumberField = !showNumberField;
                                      setState(() {});
                                    },
                                    child: Icon(
                                      showNumberField
                                          ? Icons.close
                                          : Icons.edit_outlined,
                                      color: ksecondaryColor2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // if (showNumberField)
                        // Container(
                        //   // padding: EdgeInsets.only(left: 10.w),
                        //   alignment: Alignment.bottomLeft,
                        //   // height: 36.h,
                        //   width: 1.sw,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(4.r),
                        //     border: Border.all(
                        //       color: ksecondaryColor2,
                        //     ),
                        //   ),
                        //   child: TextField(
                        //     textAlign: TextAlign.left,
                        //     textAlignVertical: TextAlignVertical.center,
                        //     keyboardType: TextInputType.phone,
                        //     controller: mobileNumberController,
                        //     onChanged: (value) {
                        //       mobileNumberController.text = value;
                        //       setState(() {});
                        //     },
                        //     decoration: InputDecoration(
                        //       contentPadding: EdgeInsets.only(left: 10.w),
                        //       hintText: '+971 5x xxx xxxx',
                        //       // helperText: '+971 5x xxx xxxx',
                        //       enabledBorder: const OutlineInputBorder(
                        //         borderSide: BorderSide.none,
                        //       ),
                        //       focusedBorder: const OutlineInputBorder(
                        //         borderSide: BorderSide.none,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        AnimatedOpacity(
                            opacity: showNumberField ? 1 : 0,
                            duration: const Duration(seconds: 1),
                            child: SizedBox(
                              height: 47.h,
                              child: MainButton(
                                  text: Controller.getTag('verify_number'),
                                  onTap: () {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) {
                                          return EnterNumber();
                                        });
                                  }),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
