import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/GetAllChatsUser.dart';
import 'package:lisit_mobile_app/Screens/chat/widget/noChat.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

import 'messagesScreen.dart';
import 'widget/chatTile.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    print(
        "this is the required socket url ${CallApi.baseUrl.replaceFirst("https", "wss").replaceRange(CallApi.baseUrl.length - 6, null, "")}");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
    user = context.read<GetAllChatsUser>().allChatsUser;
    print("User list length");
    print(user.length);
    completeUser = user;
    // TODO: implement initState
    super.initState();
  }

  List user = [];
  List adList = [];
  List<bool> chatSelect = [];
  bool isEdit = false;

  String query = "";
  List completeUser = [];
  getData() async {
    await context.read<GetAllChatsUser>().getAllChatsUser(context);
  }

  void filterSearchResults(String queryUpdate) {
    setState(() {
      query = queryUpdate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        /// Delete and Mark as read
        bottomNavigationBar: isEdit
            ? Container(
                height: 50.h,
                width: 1.sw,
                color: kbackgrounColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    /// Delete Button
                    GestureDetector(
                        onTap: () {
                          for (int i = 0; i < chatSelect.length; i++) {
                            if (chatSelect[i]) {
                              print(user[i].user[0].name);
                              print("User ID: ${user[i].to}");
                              print("Ref ID: ${user[i].refid}");
                            }
                          }
                        },
                        child: H2Bold(
                          text: Controller.getTag('delete'),
                          color: kprimaryColor,
                        )),

                    /// Mark as read button
                    GestureDetector(
                        onTap: () {
                          print(chatSelect);
                        },
                        child: H2Bold(
                          text: Controller.getTag('mark_read'),
                          color: kprimaryColor,
                        )),
                  ],
                ),
              )
            : Container(
                height: 0,
              ),
        appBar: AppBar(
          // actions: [
          //   GestureDetector(
          //     onTap: (){
          //       for(int i = 0; i < chatSelect.length; i++){
          //         chatSelect[i] = false;
          //       }
          //       setState(() {
          //         isEdit = !isEdit;
          //       });
          //     },
          //     child: Padding(
          //       padding: EdgeInsets.all(17.0.w),
          //       child: H3semi(text: isEdit? "Cancel" : "Edit", color: kprimaryColor,),
          //     ),
          //   ),
          // ],
          surfaceTintColor: kbackgrounColor,
          title: H2Bold(
            text: Controller.getTag('chat'),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Consumer<GetAllChatsUser>(
              builder: (context, userChatValue, child) {
            user = userChatValue.allChatsUser;
            adList = userChatValue.adDataList;

            List temp = [];
            List addTemp = [];
            for (int i = 0; i < user.length; i++) {
              (context.read<GetAllChatsUser>().adDataList[i] as List)
                  .forEach((e) {
                if (e['name'] == 'Title') {
                  String title = Controller.languageChange(
                      english: e['value'], arabic: e['value_ar']);
                  if (user[i]
                          .user[0]
                          .name
                          .toString()
                          .toLowerCase()
                          .contains(query.toLowerCase()) ||
                      title.toLowerCase().contains(query.toLowerCase())) {
                    print(title);
                    temp.add(user[i]);
                    addTemp.add(adList[i]);
                  }
                }
              });
            }
            user = temp;
            adList = addTemp;
            return userChatValue.isLoading
                ? Container(
                    alignment: Alignment.center,
                    height: 0.7.sh,
                    child: const CircularProgressIndicator(),
                  )
                : user.isEmpty
                    ? Padding(
                        padding: EdgeInsets.only(top: 0.25.sh),
                        child: const NoChat(),
                      )
                    : Column(
                        children: [
                          //appbar section

                          SizedBox(
                            height: 30.h,
                          ),

                          // search field for chat

                          Container(
                            alignment: Alignment.centerLeft,
                            width: 356.w,
                            height: 42.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(62.r),
                              border: Border.all(
                                width: 1.w,
                                color: khelperTextColor,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  height: 25.h,
                                  child: TextField(
                                    onChanged: (text) {
                                      // print(text);
                                      filterSearchResults(text);
                                    },
                                    // textAlign: TextAlign.left,
                                    textAlignVertical: TextAlignVertical.center,
                                    // keyboardType: keybordType,
                                    // controller: controller,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontFamily:
                                          GoogleFonts.montserrat().fontFamily,
                                      fontWeight: FontWeight.w600,
                                      color: ksecondaryColor,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      prefixIcon: Icon(
                                        Icons.search_rounded,
                                        color: kprimaryColor,
                                      ),
                                      // label: ParaRegular(text: title),
                                      hintText:
                                          '${Controller.getTag('search_here')}..',
                                      hintStyle: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: Controller.getLanguage()
                                                    .toString()
                                                    .toLowerCase() ==
                                                "english"
                                            ? GoogleFonts.montserrat()
                                                .fontFamily
                                            : GoogleFonts.notoKufiArabic()
                                                .fontFamily,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // chat tile

                          SizedBox(
                            height: isEdit ? 590.h : 640.h,
                            child: ListView.builder(
                                itemCount: user.length,
                                itemBuilder: (context, index) {
                                  final data = user[index];
                                  String title = '';
                                  String imageUrl = '';
                                  String price = '';
                                  String location = '';
                                  String adCreatedOn = '';

                                  adList[index].forEach((e) {
                                    if (e['name'] == 'Title') {
                                      title = Controller.languageChange(
                                          english: e['value'],
                                          arabic: e['value_ar']);
                                      if (DateTime.now()
                                              .difference(DateTime.parse(
                                                  e['created_at'].toString()))
                                              .inHours <
                                          24) {
                                        adCreatedOn =
                                            "${DateTime.now().difference(DateTime.parse(e['created_at'].toString())).inHours.toString()} ${Controller.getTag('hours_ago')}";
                                      } else {
                                        adCreatedOn =
                                            "${DateTime.now().difference(DateTime.parse(e['created_at'].toString())).inDays.toString()} ${Controller.getTag('days_ago')}";
                                      }
                                    } else if (e['name'] == 'Add Pictures') {
                                      imageUrl =
                                          e['value'].toString().split(",")[0];
                                    } else if (e['name'] == 'Price') {
                                      price = e['value'].toString();
                                    } else if (e['name'] == 'Add Location') {
                                      location = Controller.languageChange(
                                          english: e['value'],
                                          arabic: e['value_ar']);
                                    }
                                  });
                                  if (chatSelect.length < user.length) {
                                    chatSelect.add(false);
                                  }
                                  var details;
                                  return Dismissible(
                                    key: Key(index.toString()),
                                    confirmDismiss: (direction) async {
                                      showModalBottomSheet(
                                          isScrollControlled:
                                          true,
                                          backgroundColor:
                                          kbackgrounColor,
                                          shape:
                                          const BeveledRectangleBorder(),
                                          context:
                                          context,
                                          builder:
                                              (context) {
                                            return Container(
                                              padding: EdgeInsets.only(bottom: 22.h, top: 21.h, right: 30.w, left: 30.w),
                                              width: 415.w,
                                              height: 234.h,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  /// Title and close button
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                          width: 0.79.sw,
                                                          child: H2semi(
                                                            text: "${Controller.getTag('chat_about_to_delete')} ${data.user.isNotEmpty ? data.user[0].name : ""}.",
                                                            textAlign: TextAlign.start,
                                                          )),
                                                      Transform.rotate(
                                                          angle: 40,
                                                          child: GestureDetector(
                                                              onTap: () {
                                                                Navigator.pop(context);
                                                              },
                                                              child: const Icon(Icons.add)))
                                                    ],
                                                  ),

                                                  const Divider(
                                                    color: Color(0xFFEBEBEB),
                                                  ),

                                                  /// Dialog message
                                                  H3Regular(text: Controller.getTag('sure_delete')),

                                                  const Divider(
                                                    color: Color(0xFFEBEBEB),
                                                  ),

                                                  /// Cancel and Block trigger button
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                          height: 50.h,
                                                          width: 153.w,
                                                          child: MainButton(
                                                            text: Controller.getTag('cancel'),
                                                            onTap: () {
                                                              Navigator.pop(context);
                                                              return false;
                                                            },
                                                            isFilled: false,
                                                            textColor: ksecondaryColor,
                                                          )),
                                                      SizedBox(
                                                          height: 50.h,
                                                          width: 153.w,
                                                          child: MainButton(
                                                              text: Controller.getTag('delete'),
                                                              onTap: () async {
                                                                print("to : ${data.to}\nrefid : ${data.refid}");

                                                                /// Delete Api call
                                                                await context.read<GetAllChatsUser>().deleteChatsUser(data.to ?? "", data.refid ?? "", context).then((value) {
                                                                  DisplayMessage(context: context, isTrue: value.toString().toLowerCase().contains("error") ? false : true, message: value);
                                                                  context.read<GetAllChatsUser>().getAllChatsUser(context);
                                                                });
                                                                Navigator.pop(context);
                                                                return true;
                                                              })),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    secondaryBackground: Container(
                                      alignment: Alignment.centerRight,
                                      color: Colors.red,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 0.08.sw),
                                        child: H2Bold(text: Controller.getTag('delete'), color: Colors.white,),
                                      ),
                                    ),
                                    background: Container(
                                      alignment: Alignment.centerLeft,
                                      color: Colors.red,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 0.08.sw),
                                        child: H2Bold(text: Controller.getTag('delete'), color: Colors.white,),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          child: Row(
                                            children: [
                                              if (isEdit)
                                                Checkbox(
                                                    activeColor: kprimaryColor,
                                                    value: chatSelect[index],
                                                    onChanged: (val) {
                                                      setState(() {
                                                        chatSelect[index] =
                                                            val ?? false;
                                                      });
                                                    }),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 15.h),
                                                child: SizedBox(
                                                  width: isEdit ? 0.85.sw : 1.sw,

                                                  /// Chat Tile
                                                  child: GestureDetector(
                                                    onTapDown: (d) {
                                                      details = d;
                                                    },

                                                    /// On Long Press
                                                    // onLongPress: () {
                                                    //   showMenu(
                                                    //     elevation: 10,
                                                    //     context: context,
                                                    //     items: <PopupMenuEntry<
                                                    //         String>>[
                                                    //       PopupMenuItem<String>(
                                                    //           child:
                                                    //               GestureDetector(
                                                    //                   onTap:
                                                    //                       () async {
                                                    //                     showModalBottomSheet(
                                                    //                         isScrollControlled:
                                                    //                             true,
                                                    //                         backgroundColor:
                                                    //                             kbackgrounColor,
                                                    //                         shape:
                                                    //                             const BeveledRectangleBorder(),
                                                    //                         context:
                                                    //                             context,
                                                    //                         builder:
                                                    //                             (context) {
                                                    //                           return Container(
                                                    //                             padding: EdgeInsets.only(bottom: 22.h, top: 21.h, right: 30.w, left: 30.w),
                                                    //                             width: 415.w,
                                                    //                             height: 234.h,
                                                    //                             child: Column(
                                                    //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    //                               crossAxisAlignment: CrossAxisAlignment.stretch,
                                                    //                               children: [
                                                    //                                 /// Title and close button
                                                    //                                 Row(
                                                    //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    //                                   children: [
                                                    //                                     SizedBox(
                                                    //                                         width: 0.79.sw,
                                                    //                                         child: H2semi(
                                                    //                                           text: "${Controller.getTag('chat_about_to_delete')} ${data.user.isNotEmpty ? data.user[0].name : ""}.",
                                                    //                                           textAlign: TextAlign.start,
                                                    //                                         )),
                                                    //                                     Transform.rotate(
                                                    //                                         angle: 40,
                                                    //                                         child: GestureDetector(
                                                    //                                             onTap: () {
                                                    //                                               Navigator.pop(context);
                                                    //                                             },
                                                    //                                             child: const Icon(Icons.add)))
                                                    //                                   ],
                                                    //                                 ),
                                                    //
                                                    //                                 const Divider(
                                                    //                                   color: Color(0xFFEBEBEB),
                                                    //                                 ),
                                                    //
                                                    //                                 /// Dialog message
                                                    //                                 H3Regular(text: Controller.getTag('sure_delete')),
                                                    //
                                                    //                                 const Divider(
                                                    //                                   color: Color(0xFFEBEBEB),
                                                    //                                 ),
                                                    //
                                                    //                                 /// Cancel and Block trigger button
                                                    //                                 Row(
                                                    //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    //                                   children: [
                                                    //                                     SizedBox(
                                                    //                                         height: 50.h,
                                                    //                                         width: 153.w,
                                                    //                                         child: MainButton(
                                                    //                                           text: Controller.getTag('cancel'),
                                                    //                                           onTap: () {
                                                    //                                             Navigator.pop(context);
                                                    //                                             Navigator.pop(context);
                                                    //                                           },
                                                    //                                           isFilled: false,
                                                    //                                           textColor: ksecondaryColor,
                                                    //                                         )),
                                                    //                                     SizedBox(
                                                    //                                         height: 50.h,
                                                    //                                         width: 153.w,
                                                    //                                         child: MainButton(
                                                    //                                             text: Controller.getTag('delete'),
                                                    //                                             onTap: () async {
                                                    //                                               print("to : ${data.to}\nrefid : ${data.refid}");
                                                    //
                                                    //                                               await context.read<GetAllChatsUser>().deleteChatsUser(data.to ?? "", data.refid ?? "", context).then((value) {
                                                    //                                                 DisplayMessage(context: context, isTrue: value.toString().toLowerCase().contains("error") ? false : true, message: value);
                                                    //                                                 context.read<GetAllChatsUser>().getAllChatsUser(context);
                                                    //                                               });
                                                    //
                                                    //                                               Navigator.pop(context);
                                                    //                                               Navigator.pop(context);
                                                    //                                             })),
                                                    //                                   ],
                                                    //                                 )
                                                    //                               ],
                                                    //                             ),
                                                    //                           );
                                                    //                         });
                                                    //                   },
                                                    //                   child:
                                                    //                       ParaBold(
                                                    //                     text: Controller
                                                    //                         .getTag(
                                                    //                             'delete'),
                                                    //                   ))),
                                                    //     ],
                                                    //     position:
                                                    //         RelativeRect.fromLTRB(
                                                    //             details
                                                    //                 .globalPosition
                                                    //                 .dx,
                                                    //             details
                                                    //                 .globalPosition
                                                    //                 .dy,
                                                    //             0,
                                                    //             0),
                                                    //   );
                                                    // },
                                                    child: ChatTile(
                                                      lastMessage: '${title}',
                                                      name:
                                                          '${data.user.isNotEmpty ? data.user[0].name : ""}',
                                                      hy: '${data.lastchat.isNotEmpty ? data.lastchat[0].message : ""}',
                                                      avatar: CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: data.user[0]
                                                            .profilePicture,
                                                        errorWidget:
                                                            (context, s, o) {
                                                          return Center(
                                                              child: Text(
                                                                  "${data.user.isNotEmpty ? data.user[0].name[0] : ""}",
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                    fontSize:
                                                                        28.sp,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  )));
                                                        },
                                                        placeholder:
                                                            (context, s) {
                                                          return const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        },
                                                      ),
                                                      date: DateFormat('dd:MMM').format(data.lastchat[0].messagetime),
                                                          // '${data.lastchat[0].messagetime.day}/${data.lastchat[0].messagetime.month}/${data.lastchat[0].messagetime.year}\n${data.lastchat[0].messagetime.hour}:${data.lastchat[0].messagetime.minute}',
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    MessageScreen(
                                                                      adName:
                                                                          '$title',
                                                                      adTime:
                                                                          adCreatedOn,
                                                                      userName:
                                                                          '${data.user.isNotEmpty ? data.user[0].name : ""}',
                                                                      refId:
                                                                          '${data.refid ?? ""}',
                                                                      toId:
                                                                          '${data.to ?? ""}',
                                                                      price:
                                                                          price,
                                                                      imageUrl:
                                                                          imageUrl,
                                                                      profileImage: data
                                                                          .user[0]
                                                                          .profilePicture,
                                                                      location:
                                                                          location,
                                                                    )));
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Divider()
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ],
                      );
          }),
        ),
      ),
    );
  }
}
