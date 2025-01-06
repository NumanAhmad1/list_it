import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/updateProfile.dart';
import 'package:lisit_mobile_app/Screens/bottomNavigationBar/bottomNavigationBarScreen.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';
import 'package:lisit_mobile_app/main.dart';

import '../AuthScreens/loginScreen/changePassword.dart';
import '../notificationPreferences/notificationPreferences.dart';
import 'editProfileScreen.dart';

class ProfileScreen extends StatefulWidget {
  Function()? callback;
  ProfileScreen({super.key, this.callback});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // bool showName = false;
  // bool showNumber = false;
  @override
  void initState() {
    Controller.getLogin();
    Controller.getUserGmail();
    Controller.getUserName();
    Controller.getUserPhotoUrl();
    // TODO: implement initState
    super.initState();
  }

  rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    log('profile screen is called');
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

                    //profile title

                    GestureDetector(
                        onTap: () {
                          // print(
                          //     'profile image: ${Controller.getUserPhotoUrl()}');
                          // print('profile image: ${Controller.getUserToken()}');
                        },
                        child: H2Bold(text: Controller.getTag('profile'))),

                    const SizedBox.shrink(),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 30.h,
            ),

            // profle Data Section

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                children: [
                  Container(
                    height: 163.h,
                    width: 1.sw,
                    decoration: BoxDecoration(
                      color: kbackgrounColor,
                      borderRadius: BorderRadius.circular(5.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 1.sp,
                          offset: Offset(1, 2), // Shadow position
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 7.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              H3semi(
                                text: Controller.getTag('personal_details'),
                                color: ksecondaryColor2,
                              ),
                              //profile edit button
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfileScreen(
                                        callbackMenue: widget.callback,
                                        callbackProfile: rebuild,
                                      ),
                                    ),
                                  ).whenComplete(() {
                                    setState(() {});
                                  });
                                },
                                child: H3semi(
                                  text: Controller.getTag('edit'),
                                  color: kredText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //profile avatar

                            Container(
                              margin: EdgeInsets.only(left: 30.w, right: 15.w),
                              clipBehavior: Clip.hardEdge,
                              height: 68.h,
                              width: 68.w,
                              decoration: BoxDecoration(
                                color: kprimaryColor2,
                                shape: BoxShape.circle,
                              ),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: Controller.getUserPhotoUrl() ?? 'N/A',
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  'assets/personImage.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // profle data
                            SizedBox(
                              height: 110.h,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //Name
                                  SizedBox(
                                    width: 270.w,
                                    child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 20.h,
                                          width: 20.h,
                                          child:
                                              Image.asset('assets/person.png'),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 8.w, right: 8.w),
                                          child: SizedBox(
                                            width: 225.w,
                                            child: H3Regular(
                                                text:
                                                    '${Controller.getUserName()}'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //email
                                  SizedBox(
                                    width: 270.w,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 20.h,
                                          width: 20.h,
                                          child: Image.asset('assets/mail.png'),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 8.w, right: 8.w),
                                          child: SizedBox(
                                            width: 215.w,
                                            child: H3Regular(
                                                maxLine: 1,
                                                text:
                                                    '${Controller.getUserGmail()}'),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 16.h,
                                          width: 16.w,
                                          child: Image.asset(
                                            'assets/completedGreenTeck.png',
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  //phone
                                  if (Controller.getUserPhoneNumber() != null)
                                    SizedBox(
                                      width: 270.w,
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 20.h,
                                            width: 20.h,
                                            child: Image.asset(
                                                'assets/profilePhone.png'),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 8.w),
                                            child: SizedBox(
                                              width: 225.w,
                                              child: H3Regular(
                                                  text:
                                                      '${Controller.getUserPhoneNumber() ?? 'N/A'}'),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 16.h,
                                            width: 16.w,
                                            child: Image.asset(
                                              'assets/completedGreenTeck.png',
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  //faceBook
                                  // SizedBox(
                                  //   width: 270.w,
                                  //   child: Row(
                                  //     // mainAxisAlignment: MainAxisAlignment.start,
                                  //     children: [
                                  //       SizedBox(
                                  //         height: 20.h,
                                  //         width: 20.h,
                                  //         child: Image.asset(
                                  //             'assets/facebook.png'),
                                  //       ),
                                  //       Padding(
                                  //         padding: EdgeInsets.only(left: 8.w),
                                  //         child: SizedBox(
                                  //           width: 225.w,
                                  //           child: H3Regular(text: 'Facebook'),
                                  //         ),
                                  //       ),
                                  //       SizedBox(
                                  //         height: 16.h,
                                  //         width: 16.w,
                                  //         child: Image.asset(
                                  //           'assets/incompletedIcon.png',
                                  //           fit: BoxFit.fill,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // SizedBox(
                  //   height: 30.h,
                  // ),

                  // Address

                  // Container(
                  //   padding: EdgeInsets.symmetric(horizontal: 15.w),
                  //   height: 52.h,
                  //   width: 1.sw,
                  //   decoration: BoxDecoration(
                  //     color: kbackgrounColor,
                  //     borderRadius: BorderRadius.circular(6.r),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.black12,
                  //         blurRadius: 1.sp,
                  //         offset: const Offset(1, 2), // Shadow position
                  //       ),
                  //     ],
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       SizedBox(
                  //         width: 130.w,
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Icon(
                  //               Icons.location_on_outlined,
                  //               color: ksecondaryColor2,
                  //             ),
                  //             H2Regular(text: 'Addresses'),
                  //           ],
                  //         ),
                  //       ),
                  //       Icon(
                  //         Icons.keyboard_arrow_right_rounded,
                  //         color: ksecondaryColor2,
                  //       )
                  //     ],
                  //   ),
                  // ),

                  SizedBox(
                    height: 30.h,
                  ),

                  //Account Settings

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    height: 212.h,
                    width: 1.sw,
                    decoration: BoxDecoration(
                      color: kbackgrounColor,
                      borderRadius: BorderRadius.circular(6.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 1.sp,
                          offset: const Offset(1, 2), // Shadow position
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //account setting text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            H3Regular(
                              text: Controller.getTag('account_settings'),
                              color: khelperTextColor,
                            ),
                          ],
                        ),

                        // notification preferences

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NotificationPreferences()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //icon
                              SizedBox(
                                width: 290.w,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 24.h,
                                      width: 24.h,
                                      child: Image.asset(
                                        'assets/notificationPreferences.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                    // tilte
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.w),
                                      child: H2Regular(
                                        text: Controller.getTag(
                                            'notification_preferences'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //icon
                              const Icon(Icons.arrow_forward_ios_rounded),
                            ],
                          ),
                        ),

                        //change password

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChangePassword()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //icon
                              SizedBox(
                                width: 290.w,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 24.h,
                                      width: 24.h,
                                      child: Image.asset(
                                        'assets/changePassword.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                    // tilte
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.w),
                                      child: H2Regular(
                                        text: Controller.getTag(
                                            'change_password'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //icon
                              const Icon(Icons.arrow_forward_ios_rounded),
                            ],
                          ),
                        ),

                        //Delete account

                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //icon
                              SizedBox(
                                width: 290.w,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 24.h,
                                      width: 24.h,
                                      child: Image.asset(
                                        'assets/deleteAccont.png',
                                        fit: BoxFit.cover,
                                        color: kprimaryColor,
                                      ),
                                    ),

                                    // Delete Account
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            shape:
                                                const BeveledRectangleBorder(),
                                            backgroundColor: kbackgrounColor,
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) {
                                              return SizedBox(
                                                height: 232.h,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 30.w,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          H2semi(
                                                              text: Controller
                                                                  .getTag(
                                                                      'are_you_sure')),
                                                          GestureDetector(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Icon(
                                                                  Icons.close)),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(
                                                      thickness: 0.5,
                                                    ),
                                                    H3Regular(
                                                        text: Controller.getTag(
                                                            'sure_delete')),
                                                    const Divider(
                                                      thickness: 0.5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        SizedBox(
                                                          width: 155.w,
                                                          height: 64.h,
                                                          child: MainButton(
                                                            text: Controller
                                                                .getTag(
                                                                    'cancel'),
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            isFilled: false,
                                                            textColor:
                                                                ksecondaryColor,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 155.w,
                                                          height: 64.h,
                                                          child: context.select(
                                                            (UpdateProfile
                                                                    value) =>
                                                                value.isLoading
                                                                    ? Center(
                                                                        child:
                                                                            CircularProgressIndicator(),
                                                                      )
                                                                    : MainButton(
                                                                        text: Controller.getTag(
                                                                            'okay'),
                                                                        onTap:
                                                                            () async {
                                                                          var result = await context.read<UpdateProfile>().updateUser(
                                                                              context,
                                                                              profileData: {
                                                                                "isActive": false
                                                                              });

                                                                          if (result['success'] ==
                                                                              true) {
                                                                            DisplayMessage(
                                                                                context: context,
                                                                                isTrue: true,
                                                                                message: Controller.languageChange(english: result['message'], arabic: result['message_ar']));
                                                                            prefs!.clear();
                                                                          }
                                                                          Navigator.pushAndRemoveUntil(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => BottomNavigationBarScreen()),
                                                                              (route) => false);
                                                                        },
                                                                      ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10.w),
                                        child: H2Regular(
                                          text: Controller.getTag(
                                              'delete_account'),
                                          color: kredText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //icon
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: kredText,
                              ),
                            ],
                          ),
                        ),
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
