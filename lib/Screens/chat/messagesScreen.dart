import 'dart:convert';
import 'dart:developer';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/GetChatMessages.dart';
import 'package:lisit_mobile_app/Screens/chat/widget/chat_bubble.dart';
import 'package:lisit_mobile_app/Screens/detailsScreen/detailsScreen.dart';
import 'package:lisit_mobile_app/const/constColors.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:lisit_mobile_app/widgets/TextWidgets/Regular/paraRegular.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:photo_view/photo_view.dart';
import 'package:path_provider/path_provider.dart';

class MessageScreen extends StatefulWidget {
  MessageScreen(
      {super.key,
      required this.adName,
      required this.userName,
      required this.refId,
      required this.toId,
      required this.location,
      required this.imageUrl,
      required this.price,
      required this.profileImage,
      this.adTime});

  String refId;
  String toId;
  String? adTime;
  String userName;
  String adName;
  String imageUrl;
  String profileImage;
  String price;
  String location;

  TextEditingController controller = TextEditingController();

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<GetChatMessages>()
          .getChatMessages(widget.refId, widget.toId, context);
      context.read<GetChatMessages>().initializeSocketFromProvider(context);
      context
          .read<GetChatMessages>()
          .getBlockedStatus(widget.refId, widget.toId, context)
          .then((value) => blocked = value);
    });
    context.read<GetChatMessages>().socket.on("get_typing", (data) {
      log("Typing Received : ${data}");
      log(Controller.getUserId());
      if (data['From'].toString().trim() != Controller.getUserId()) {
        if (data['TypingStatus'].toString().contains('start')) {
          setState(() {
            isTypingStatus = true;
          });
        } else {
          setState(() {
            isTypingStatus = false;
          });
        }
      }
    });
    _getDir();
    super.initState();
  }

  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    path = "${appDirectory.path}/recording.m4a";
    isLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    context.read<GetChatMessages>().disconnectSocket();
    // TODO: implement dispose
    super.dispose();
  }

  bool isTyping = false;
  bool isTypingStatus = false;
  final picker = ImagePicker();

  XFile? image;
  List<XFile> images = [];

  bool blocked = false;
  String? path;
  String? musicFile;
  bool isRecording = false;
  bool isRecordingCompleted = false;
  bool isLoading = true;
  late Directory appDirectory;

  bool isChatSelect = false;
  int chatSelectCount = 0;
  List<bool> selected = [];
  List<String> chatSelectId = [];

  RecorderController recorderController = RecorderController();

  getImageFileGallery() async {
    List<XFile>? file = await picker.pickMultiImage();

    if (file.isNotEmpty) {
      for (int i = 0; i < file.length; i++) {
        image = file[i];
        images.add(image!);
      }
      setState(() {});
    }
  }

  void _startOrStopRecording() async {
    try {
      if (isRecording) {
        recorderController.reset();

        path = await recorderController.stop(false);

        if (path != null) {
          XFile f = XFile(path!);
          images = [f];
          isRecordingCompleted = true;
          debugPrint(path);
          debugPrint("Recorded file size: ${File(path!).lengthSync()}");
          sendMessage();
        }
      } else {
        await recorderController.record(path: path); // Path is optional
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  getImageFile() async {
    XFile? file = await picker.pickImage(source: ImageSource.camera);

    if (file != null) {
      image = file;
      images.add(image!);
      setState(() {});
    }
  }

  sendMessage() async {
    print("sendMessage called");
    setState(() {
      isTyping = false;
    });
    String room = "";
    if (widget.controller.text.trim().isNotEmpty || images.isNotEmpty) {
      for (int i = 0;
          i < context.read<GetChatMessages>().socketRoom.length;
          i++) {
        if (context
                .read<GetChatMessages>()
                .socketRoom[i]
                .contains(widget.refId) &&
            context
                .read<GetChatMessages>()
                .socketRoom[i]
                .contains(widget.toId) &&
            context
                .read<GetChatMessages>()
                .socketRoom[i]
                .contains(Controller.getUserId() ?? "")) {
          room = context.read<GetChatMessages>().socketRoom[i].split(":")[0];
          break;
        }
      }
      if (widget.controller.text.isNotEmpty || images.isNotEmpty) {
        log('this is room: $room');
        if (room.isEmpty) {
          var attachedImages;
          if (images.isNotEmpty) {
            var request = http.MultipartRequest(
              "POST",
              Uri.parse('${CallApi.baseUrl}/files/upload'),
            );

            request.headers.addAll(
                {'Request-Source': Platform.isAndroid ? 'Android' : 'iOS'});
            for (int i = 0; i < images.length; i++) {
              request.files.add(
                await http.MultipartFile.fromPath(
                  'files',
                  images[i].path,
                ),
              );
            }

            try {
              final response = await request.send();
              if (response.statusCode == 201) {
                print('Images uploaded successfully');
                final jsonResponse = await response.stream.bytesToString();
                print('this is the response for imageUpoad: $jsonResponse');
                final decodedResponse = json.decode(jsonResponse);
                print(
                    'this is the decoded response: ${decodedResponse['data']}');
                attachedImages = decodedResponse['data'].toString().split(",");
                setState(() {
                  images = [];
                });
              } else {
                print(
                    'Failed to upload images. Status code: ${response.statusCode}');
              }
            } catch (e) {
              print('Error uploading images: $e');
            }
          }
          context.read<GetChatMessages>().disconnectSocket();
          context.read<GetChatMessages>().sendChatMessage(
              widget.refId,
              widget.toId,
              widget.controller.text.isEmpty
                  ? " "
                  : widget.controller.text.trim(),
              attachedImages == null
                  ? ""
                  : attachedImages
                      .toString()
                      .replaceAll("[", "")
                      .replaceAll("]", ""),
              context);
          // room = "${widget.refId} - ${Controller.getUserId()} - ${widget.toId}";
          Future.delayed(Duration(seconds: 2), () {
            context
                .read<GetChatMessages>()
                .initializeSocketFromProvider(context);
            context
                .read<GetChatMessages>()
                .getChatMessages(widget.refId, widget.toId, context);
          });
        }
        // log('this is room after: $room');
        else {
          var attachedImages;
          if (images.isNotEmpty) {
            var request = http.MultipartRequest(
              "POST",
              Uri.parse('${CallApi.baseUrl}/files/upload'),
            );
            request.headers.addAll(
                {'Request-Source': Platform.isAndroid ? 'Android' : 'iOS'});

            for (int i = 0; i < images.length; i++) {
              request.files.add(
                await http.MultipartFile.fromPath(
                  'files',
                  images[i].path,
                ),
              );
            }

            try {
              final response = await request.send();
              if (response.statusCode == 201) {
                print('Images uploaded successfully');
                final jsonResponse = await response.stream.bytesToString();
                print('this is the response for imageUpoad: $jsonResponse');
                final decodedResponse = json.decode(jsonResponse);
                print(
                    'this is the decoded response: ${decodedResponse['data']}');
                attachedImages = decodedResponse['data'].toString().split(",");
                setState(() {
                  images = [];
                });
              } else {
                print(
                    'Failed to upload images. Status code: ${response.statusCode}');
              }
            } catch (e) {
              print('Error uploading images: $e');
            }
          }

          String room = "";
          for (int i = 0;
              i < context.read<GetChatMessages>().socketRoom.length;
              i++) {
            if (context
                    .read<GetChatMessages>()
                    .socketRoom[i]
                    .contains(widget.refId) &&
                context
                    .read<GetChatMessages>()
                    .socketRoom[i]
                    .contains(widget.toId) &&
                context
                    .read<GetChatMessages>()
                    .socketRoom[i]
                    .contains(Controller.getUserId() ?? "")) {
              room =
                  context.read<GetChatMessages>().socketRoom[i].split(":")[0];
              break;
            }
          }
          context.read<GetChatMessages>().socket.emit("set_typing", {
            "refid": widget.refId,
            "to": widget.toId,
            "roomName": room.trim(),
            "from": Controller.userId,
            "typingStatus": "end"
          });
          context.read<GetChatMessages>().sendMessageToSocket({
            "message": widget.controller.text.isEmpty
                ? " "
                : widget.controller.text.trim(),
            "refid": widget.refId,
            "to": widget.toId,
            "roomName": room.trim(),
            "from": Controller.userId,
            "attachment": attachedImages == null
                ? ""
                : attachedImages
                    .toString()
                    .replaceAll("[", "")
                    .replaceAll("]", ""),
          });
        }
        // context
        //     .read<GetChatMessages>()
        //     .getChatMessages(widget.refId, widget.toId);
      }
    }
    widget.controller.text = "";
  }

  updateBlocked() {
    context
        .read<GetChatMessages>()
        .getBlockedStatus(widget.refId, widget.toId, context)
        .then((value) {
      setState(() {
        blocked = value;
      });
    });
  }

  triggerBlock() async {
    await context
        .read<GetChatMessages>()
        .blockUser(widget.toId, !context.read<GetChatMessages>().blockedStatus,
            context)
        .then((value) {
      if (value is! String) {
        if (value['success']) {
          DisplayMessage(
              context: context,
              isTrue: true,
              message: Controller.languageChange(
                  english: value['message'], arabic: value['message_ar']));
        } else {
          DisplayMessage(
              context: context,
              isTrue: false,
              message: Controller.languageChange(
                  english: value['message'], arabic: value['message_ar']));
        }
        context
            .read<GetChatMessages>()
            .getChatMessages(widget.refId, widget.toId, context);
      }
    });
    updateBlocked();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: isChatSelect
          ? Padding(
              padding: EdgeInsets.only(bottom: 20.0.h),
              child: Container(
                height: 50.h,
                width: 1.sw,
                color: kbackgrounColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    /// Delete Button
                    GestureDetector(
                        onTap: () async {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: kbackgrounColor,
                              shape: const BeveledRectangleBorder(),
                              context: context,
                              builder: (context) {
                                return Container(
                                  padding: EdgeInsets.only(
                                      bottom: 22.h,
                                      top: 21.h,
                                      right: 30.w,
                                      left: 30.w),
                                  width: 415.w,
                                  height: 234.h,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      /// Title and close button
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                              width: 0.79.sw,
                                              child: H2semi(
                                                text:
                                                    "${Controller.getTag('before_delete_statement')} ${widget.userName}",
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
                                      H3Regular(
                                          text:
                                              Controller.getTag('sure_delete')),

                                      const Divider(
                                        color: Color(0xFFEBEBEB),
                                      ),

                                      /// Cancel and Block trigger button
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                              height: 50.h,
                                              width: 153.w,
                                              child: MainButton(
                                                text:
                                                    Controller.getTag('cancel'),
                                                onTap: () {
                                                  for (int i = 0;
                                                      i < selected.length;
                                                      i++) {
                                                    selected[i] = false;
                                                  }
                                                  setState(() {
                                                    isChatSelect = false;
                                                    chatSelectId = [];
                                                    chatSelectCount = 0;
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                isFilled: false,
                                                textColor: ksecondaryColor,
                                              )),
                                          SizedBox(
                                              height: 50.h,
                                              width: 153.w,
                                              child: MainButton(
                                                  text: Controller.getTag(
                                                      'delete'),
                                                  onTap: () async {
                                                    await context
                                                        .read<GetChatMessages>()
                                                        .deleteChats(
                                                            chatSelectId,
                                                            context)
                                                        .then((value) {
                                                      DisplayMessage(
                                                          context: context,
                                                          isTrue:
                                                              value['success'],
                                                          message: Controller
                                                              .languageChange(
                                                                  english: value[
                                                                      'message'],
                                                                  arabic: value[
                                                                      'message_ar']));
                                                      for (int i = 0;
                                                          i < selected.length;
                                                          i++) {
                                                        selected[i] = false;
                                                      }
                                                      setState(() {
                                                        isChatSelect = false;
                                                        chatSelectId = [];
                                                        chatSelectCount = 0;
                                                      });
                                                      context
                                                          .read<
                                                              GetChatMessages>()
                                                          .getChatMessages(
                                                              widget.refId,
                                                              widget.toId,
                                                              context);
                                                    });
                                                    Navigator.pop(context);
                                                  })),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
                        child: H2Bold(
                          text: Controller.getTag('delete'),
                          color: kprimaryColor,
                        )),

                    /// Cancel read button
                    GestureDetector(
                        onTap: () {
                          for (int i = 0; i < selected.length; i++) {
                            selected[i] = false;
                          }
                          setState(() {
                            isChatSelect = false;
                            chatSelectId = [];
                            chatSelectCount = 0;
                          });
                        },
                        child: H2Bold(
                          text: Controller.getTag('cancel'),
                          color: kprimaryColor,
                        )),
                  ],
                ),
              ),
            )
          : Container(
              height: 0,
            ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0.h),
        child: Column(
          children: [
            //appbar section
            Container(
              width: 1.sw,
              height: 110.h,
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
                    SizedBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // back icon
                          GestureDetector(
                              onTap: () {
                                String room = "";
                                for (int i = 0;
                                    i <
                                        context
                                            .read<GetChatMessages>()
                                            .socketRoom
                                            .length;
                                    i++) {
                                  if (context
                                          .read<GetChatMessages>()
                                          .socketRoom[i]
                                          .contains(widget.refId) &&
                                      context
                                          .read<GetChatMessages>()
                                          .socketRoom[i]
                                          .contains(widget.toId) &&
                                      context
                                          .read<GetChatMessages>()
                                          .socketRoom[i]
                                          .contains(
                                              Controller.getUserId() ?? "")) {
                                    room = context
                                        .read<GetChatMessages>()
                                        .socketRoom[i]
                                        .split(":")[0];
                                    break;
                                  }
                                }
                                context
                                    .read<GetChatMessages>()
                                    .socket
                                    .emit("set_typing", {
                                  "refid": widget.refId,
                                  "to": widget.toId,
                                  "roomName": room.trim(),
                                  "from": Controller.userId,
                                  "typingStatus": "end"
                                });
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                              )),

                          // profile avatar
                          Padding(
                            padding:
                                EdgeInsets.only(left: 20.0.w, right: 20.0.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      clipBehavior: Clip.hardEdge,
                                      height: 50.h,
                                      width: 50.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kprimaryColor,
                                      ),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: widget.profileImage,
                                        errorWidget: (context, s, o) {
                                          return Center(
                                              child: Text(
                                                  "${widget.userName.isNotEmpty ? widget.userName[0] : ""}",
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 28.sp,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  )));
                                        },
                                        placeholder: (context, s) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 5.h,
                                      child: Container(
                                        height: 8.h,
                                        width: 8.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: kprimaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 15.w, right: 15.w),
                                  child: SizedBox(
                                    height: 66.h,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        H2semi(text: '${widget.userName}'),
                                        if (isTypingStatus)
                                          ParaRegular(
                                              text:
                                                  "${Controller.getTag("typing")}..."
                                              // Controller.getTag('active_now')
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isChatSelect)
                      Padding(
                        padding: EdgeInsets.only(bottom: 18.0.h),
                        child: H3semi(
                          text:
                              "${Controller.getTag('selected')} $chatSelectCount",
                          color: kprimaryColor,
                        ),
                      ),
                    SizedBox(
                      height: 55.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // GestureDetector(
                          //     onTap: () {},
                          //     child: const Icon(
                          //       Icons.more_vert_sharp,
                          //     )),
                          PopupMenuButton(
                            offset: Offset(-20.w, 40.h),
                            icon: Icon(
                              Icons.more_vert_sharp,
                              color: kprimaryColor,
                            ),
                            itemBuilder: (_) => <PopupMenuItem<String>>[
                              PopupMenuItem<String>(
                                  onTap: () async {
                                    /// Bottom Sheet for Block and Unblock
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: kbackgrounColor,
                                        shape: const BeveledRectangleBorder(),
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            padding: EdgeInsets.only(
                                                bottom: 22.h,
                                                top: 21.h,
                                                right: 30.w,
                                                left: 30.w),
                                            width: 415.w,
                                            height: 234.h,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                /// Title and close button
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    H2semi(
                                                        text: context
                                                                    .read<
                                                                        GetChatMessages>()
                                                                    .blockedStatus &&
                                                                context
                                                                        .read<
                                                                            GetChatMessages>()
                                                                        .blockedBy ==
                                                                    "me"
                                                            ? Controller.getTag(
                                                                'unblock_statement')
                                                            : Controller.getTag(
                                                                "about_to_block")),
                                                    Transform.rotate(
                                                        angle: 40,
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Icon(
                                                                Icons.add)))
                                                  ],
                                                ),

                                                const Divider(
                                                  color: Color(0xFFEBEBEB),
                                                ),

                                                /// Dialog message
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    H3Regular(
                                                        text: context
                                                                    .read<
                                                                        GetChatMessages>()
                                                                    .blockedStatus &&
                                                                context
                                                                        .read<
                                                                            GetChatMessages>()
                                                                        .blockedBy ==
                                                                    "me"
                                                            ? Controller.getTag(
                                                                'unblocking_this_ person_will_allow_for_messaging_you.')
                                                            : Controller.getTag(
                                                                'sure_block')),
                                                  ],
                                                ),

                                                const Divider(
                                                  color: Color(0xFFEBEBEB),
                                                ),

                                                /// Cancel and Block trigger button
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                        height: 50.h,
                                                        width: 153.w,
                                                        child: MainButton(
                                                          text:
                                                              Controller.getTag(
                                                                  'cancel'),
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          isFilled: false,
                                                          textColor:
                                                              ksecondaryColor,
                                                        )),
                                                    SizedBox(
                                                        height: 50.h,
                                                        width: 153.w,
                                                        child: MainButton(
                                                            text: context
                                                                        .read<
                                                                            GetChatMessages>()
                                                                        .blockedStatus &&
                                                                    context
                                                                            .read<
                                                                                GetChatMessages>()
                                                                            .blockedBy ==
                                                                        "me"
                                                                ? Controller
                                                                    .getTag(
                                                                        'unblock')
                                                                : Controller
                                                                    .getTag(
                                                                        'block'),
                                                            onTap: () {
                                                              triggerBlock();
                                                              Navigator.pop(
                                                                  context);
                                                            })),
                                                  ],
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  child: context
                                              .read<GetChatMessages>()
                                              .blockedStatus &&
                                          context
                                                  .read<GetChatMessages>()
                                                  .blockedBy ==
                                              "me"
                                      ? ParaBold(
                                          text: Controller.getTag('unblock'),
                                        )
                                      : ParaBold(
                                          text: Controller.getTag('block'),
                                        )),
                            ],
                            onSelected: (index) async {},
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // body

            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DetailsScreen(tag: "1", carId: widget.refId)));
              },
              child: Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 15.h),
                child: Container(
                  height: 130.h,
                  width: 1.sw,
                  decoration: BoxDecoration(
                    color: kbackgrounColor,
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8.sp,
                        spreadRadius: 0,
                        offset: Offset(0, 8.h),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          // image

                          Padding(
                            padding: EdgeInsets.only(left: 15.w),
                            child: Container(
                              height: 88.w,
                              width: 88.w,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: widget.imageUrl
                                    .replaceAll('[', "")
                                    .replaceAll("]", ""),
                                errorWidget: (context, s, o) {
                                  return Center(
                                      child: Text(
                                          "${Controller.getTag('loading')}"));
                                },
                                placeholder: (context, s) {
                                  return Image.asset(
                                    'assets/placeholderImage.png',
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(left: 12.w, right: 12.w),
                            child: SizedBox(
                              width: 210.w,
                              height: 88.w,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //title

                                  ParaSemi(
                                    text: '${widget.adName}',
                                    maxLines: 2,
                                  ),

                                  //price

                                  ParaRegular(
                                    text:
                                        "${Controller.getTag('aed')} ${widget.price}",
                                  ),

                                  // location

                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                      ),
                                      SizedBox(
                                        width: 180.w,
                                        child: ParaRegular(
                                          text: widget.location
                                              .split('_')[0]
                                              .toString(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // time

                          Padding(
                            padding: EdgeInsets.only(right: 6.w, left: 6.w),
                            child: ParaRegular(text: "${widget.adTime ?? ""}"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// Chat Area
            Expanded(child:
                Consumer<GetChatMessages>(builder: (context, value, child) {
              return ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  scrollDirection: Axis.vertical,
                  // reverse: true,
                  itemCount: value.allChatsMessages.length,
                  itemBuilder: (context, index) {
                    String url = "";
                    for (int i = 0;
                        i <
                            value.allChatsMessages[index].message
                                .split(" ")
                                .length;
                        i++) {
                      if (value.allChatsMessages[index].message
                              .split(" ")[i]
                              .contains("https://") ||
                          value.allChatsMessages[index].message
                              .split(" ")[i]
                              .contains("http://")) {
                        url =
                            value.allChatsMessages[index].message.split(" ")[i];
                      }
                    }
                    List<String> attachments = [];
                    if (value.allChatsMessages[index].attachment != "" &&
                        value.allChatsMessages[index].attachment.toString() !=
                            "null") {
                      log("path to file attachments ${value.allChatsMessages[index].attachment}");
                      attachments = value.allChatsMessages[index].attachment
                          .replaceAll("[", "")
                          .replaceAll("]", "")
                          .split(",");
                    }
                    if (selected.length < value.allChatsMessages.length) {
                      selected.add(false);
                    }
                    return Column(
                      children: [
                        if (index == value.allChatsMessages.length - 1 ||
                            value.allChatsMessages[index].messagetime.day !=
                                value.allChatsMessages[index + 1].messagetime
                                    .day)
                          ParaRegular(
                              text:
                                  "${DateFormat("EEEE dd, yyyy").format(value.allChatsMessages[index].messagetime)}"),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 30.h, horizontal: 10.w),
                          child: value.allChatsMessages[index].to != widget.toId
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // avatar

                                    Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Container(
                                          clipBehavior: Clip.hardEdge,
                                          height: 50.h,
                                          width: 50.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: kprimaryColor,
                                          ),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: widget.profileImage,
                                            errorWidget: (context, s, o) {
                                              return Center(
                                                  child: Text(
                                                      "${widget.userName.isNotEmpty ? widget.userName[0] : ""}",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: 28.sp,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      )));
                                            },
                                            placeholder: (context, s) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            },
                                          ),
                                        ),
                                        Positioned(
                                          top: 5.h,
                                          child: Container(
                                            height: 12.h,
                                            width: 12.w,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 2.w,
                                                  color: kbackgrounColor),
                                              shape: BoxShape.circle,
                                              color: kprimaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // message

                                    Container(
                                      width: value.allChatsMessages[index]
                                                  .message.length >
                                              50
                                          ? 0.7.sw
                                          : null,
                                      margin: EdgeInsets.only(
                                          left: 10.w, right: 10.w),
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w, vertical: 12.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.r),
                                          topRight: Radius.circular(20.r),
                                          bottomRight: Radius.circular(20.r),
                                        ),
                                        color: ksearchFieldColor,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          attachments.isNotEmpty
                                              ? attachments[0].contains("m4a")
                                                  ? WaveBubble(
                                                      index: index,
                                                      path: attachments[0],
                                                      isSender: false,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                      appDirectory:
                                                          appDirectory,
                                                    )
                                                  : SizedBox(
                                                      width:
                                                          attachments.length > 1
                                                              ? 210.w
                                                              : 105.w,
                                                      child: Wrap(
                                                        children: List.generate(
                                                            attachments.length,
                                                            (imageIndex) =>
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .all(4.0
                                                                          .sp),
                                                                  child: Stack(
                                                                    clipBehavior:
                                                                        Clip.hardEdge,
                                                                    alignment:
                                                                        Alignment
                                                                            .topRight,
                                                                    children: [
                                                                      Container(
                                                                        clipBehavior:
                                                                            Clip.hardEdge,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20.r),
                                                                        ),
                                                                        width:
                                                                            97.w,
                                                                        height:
                                                                            97.w,
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return AlertDialog(
                                                                                    backgroundColor: Colors.transparent,
                                                                                    surfaceTintColor: Colors.transparent,
                                                                                    insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
                                                                                    contentPadding: EdgeInsets.zero,
                                                                                    content: CachedNetworkImage(
                                                                                      fit: BoxFit.cover,
                                                                                      imageUrl: attachments[imageIndex].trim(),
                                                                                      imageBuilder: (context, imageProvider) => SizedBox(
                                                                                        height: 1.2.sw,
                                                                                        width: 1.sw,
                                                                                        child: PhotoView(
                                                                                          backgroundDecoration: BoxDecoration(color: Colors.transparent),
                                                                                          imageProvider: imageProvider,
                                                                                        ),
                                                                                      ),
                                                                                      errorWidget: (context, s, o) {
                                                                                        return Center(child: Image.asset("assets/placeholderImage.png"));
                                                                                      },
                                                                                      placeholder: (context, s) {
                                                                                        return const Center(
                                                                                          child: CircularProgressIndicator(),
                                                                                        );
                                                                                      },
                                                                                    ),
                                                                                  );
                                                                                });
                                                                          },
                                                                          child:
                                                                              CachedNetworkImage(
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            imageUrl:
                                                                                attachments[imageIndex].trim(),
                                                                            errorWidget: (context,
                                                                                s,
                                                                                o) {
                                                                              return Center(child: Image.asset("assets/placeholderImage.png"));
                                                                            },
                                                                            placeholder:
                                                                                (context, s) {
                                                                              return const Center(
                                                                                child: CircularProgressIndicator(),
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )),
                                                      ),
                                                    )
                                              : Container(),
                                          if (url.contains("https://") ||
                                              url.contains("http://"))
                                            SizedBox(
                                                width: 0.7.sw,
                                                child:
                                                    AnyLinkPreview(link: url)),
                                          H3semi(
                                            text:
                                                '${value.allChatsMessages[index].message}',
                                            maxLines: 100,
                                          ),
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: ParaRegular(
                                                text: value
                                                    .allChatsMessages[index]
                                                    .messagetime
                                                    .toLocalTimeString()
                                                // text:
                                                //     "${DateFormat('hh:mm a').format(value.allChatsMessages[index].messagetime)} "
                                                ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: selected[index] ? 10.sp : 0),
                                  decoration: BoxDecoration(
                                      color: selected[index]
                                          ? kprimaryColor2
                                          : Colors.transparent,
                                      borderRadius:
                                          BorderRadius.circular(10.r)),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // message

                                      GestureDetector(
                                        onTap: () {
                                          if (isChatSelect) {
                                            setState(() {
                                              selected[index] =
                                                  !selected[index];
                                              if (!chatSelectId.contains(value
                                                  .allChatsMessages[index]
                                                  .id)) {
                                                chatSelectId.add(value
                                                    .allChatsMessages[index]
                                                    .id);
                                                chatSelectCount++;
                                                print(chatSelectId);
                                              } else {
                                                chatSelectId.removeWhere(
                                                    (element) =>
                                                        element.contains(value
                                                            .allChatsMessages[
                                                                index]
                                                            .id));
                                                chatSelectCount--;
                                                print(chatSelectId);
                                                if (chatSelectId.isEmpty) {
                                                  isChatSelect = false;
                                                }
                                              }
                                            });
                                          }
                                        },
                                        onLongPress: () {
                                          setState(() {
                                            isChatSelect = true;
                                            selected[index] = !selected[index];
                                            if (!chatSelectId.contains(value
                                                .allChatsMessages[index].id)) {
                                              chatSelectId.add(value
                                                  .allChatsMessages[index].id);
                                              chatSelectCount++;
                                              print(chatSelectId);
                                            } else {
                                              chatSelectId.removeWhere(
                                                  (element) => element.contains(
                                                      value
                                                          .allChatsMessages[
                                                              index]
                                                          .id));
                                              chatSelectCount--;
                                              print(chatSelectId);
                                            }
                                          });
                                        },
                                        child: Container(
                                          width: value.allChatsMessages[index]
                                                      .message.length >
                                                  50
                                              ? 0.7.sw
                                              : null,
                                          margin: EdgeInsets.only(
                                              left: 10.w, right: 10.w),
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.w, vertical: 12.h),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20.r),
                                              topRight: Radius.circular(20.r),
                                              bottomLeft: Radius.circular(20.r),
                                            ),
                                            color: kprimaryColor2,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              attachments.isNotEmpty
                                                  ? attachments[0]
                                                          .contains("m4a")
                                                      ? WaveBubble(
                                                          index: index,
                                                          path: attachments[0],
                                                          isSender: true,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                          appDirectory:
                                                              appDirectory,
                                                        )
                                                      : SizedBox(
                                                          width: attachments
                                                                      .length >
                                                                  1
                                                              ? 210.w
                                                              : 105.w,
                                                          child: Wrap(
                                                            children:
                                                                List.generate(
                                                                    attachments
                                                                        .length,
                                                                    (imageIndex) =>
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.all(4.0.sp),
                                                                          child:
                                                                              Stack(
                                                                            clipBehavior:
                                                                                Clip.hardEdge,
                                                                            alignment:
                                                                                Alignment.topRight,
                                                                            children: [
                                                                              Container(
                                                                                clipBehavior: Clip.hardEdge,
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(20.r),
                                                                                ),
                                                                                width: 97.w,
                                                                                height: 97.w,
                                                                                child: GestureDetector(
                                                                                  onTap: () {
                                                                                    showDialog(
                                                                                        context: context,
                                                                                        builder: (context) {
                                                                                          return AlertDialog(
                                                                                            backgroundColor: Colors.transparent,
                                                                                            surfaceTintColor: Colors.transparent,
                                                                                            contentPadding: EdgeInsets.zero,
                                                                                            insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
                                                                                            content: CachedNetworkImage(
                                                                                              fit: BoxFit.cover,
                                                                                              imageBuilder: (context, imageProvider) => SizedBox(
                                                                                                height: 1.2.sw,
                                                                                                width: 1.sw,
                                                                                                child: PhotoView(
                                                                                                  backgroundDecoration: BoxDecoration(color: Colors.transparent),
                                                                                                  imageProvider: imageProvider,
                                                                                                ),
                                                                                              ),
                                                                                              imageUrl: attachments[imageIndex].trim(),
                                                                                              errorWidget: (context, s, o) {
                                                                                                return Center(child: Image.asset("assets/placeholderImage.png"));
                                                                                              },
                                                                                              placeholder: (context, s) {
                                                                                                return const Center(
                                                                                                  child: CircularProgressIndicator(),
                                                                                                );
                                                                                              },
                                                                                            ),
                                                                                          );
                                                                                        });
                                                                                  },
                                                                                  child: CachedNetworkImage(
                                                                                    fit: BoxFit.cover,
                                                                                    imageUrl: attachments[imageIndex].trim(),
                                                                                    errorWidget: (context, s, o) {
                                                                                      return Center(child: Image.asset("assets/placeholderImage.png"));
                                                                                    },
                                                                                    placeholder: (context, s) {
                                                                                      return const Center(
                                                                                        child: CircularProgressIndicator(),
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                          ),
                                                        )
                                                  : Container(),
                                              if (url.contains("https://") ||
                                                  url.contains("http://"))
                                                SizedBox(
                                                    width: 0.7.sw,
                                                    child: AnyLinkPreview(
                                                        link: url)),
                                              H3semi(
                                                text: value
                                                    .allChatsMessages[index]
                                                    .message,
                                                color: kprimaryColor,
                                                maxLines: 100,
                                              ),
                                              Align(
                                                alignment: Alignment.bottomLeft,
                                                child: ParaRegular(
                                                    text: value
                                                        .allChatsMessages[index]
                                                        .messagetime
                                                        .toLocalTimeString()),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),

                                      // avatar

                                      Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Container(
                                            clipBehavior: Clip.hardEdge,
                                            height: 50.h,
                                            width: 50.w,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: kprimaryColor,
                                            ),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  Controller.getUserPhotoUrl(),
                                              errorWidget: (context, s, o) {
                                                return Center(
                                                    child: Text(
                                                        "${Controller.getUserName().isNotEmpty ? Controller.getUserName()[0] : ""}",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize: 28.sp,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        )));
                                              },
                                              placeholder: (context, s) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              },
                                            ),
                                          ),
                                          Positioned(
                                            top: 5.h,
                                            child: Container(
                                              height: 12.h,
                                              width: 12.w,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 2.w,
                                                    color: kbackgrounColor),
                                                shape: BoxShape.circle,
                                                color: kprimaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    );
                  });
            })),

            // Input Field

            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 15.h),
              child: SizedBox(
                width: 1.sw,
                child: !Provider.of<GetChatMessages>(context).blockedStatus
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28.r),
                              color: ksearchFieldColor.withOpacity(0.3),
                            ),
                            width: 331.w,
                            child: Column(
                              children: [
                                Wrap(
                                  children: List.generate(
                                      images.length,
                                      (index) => Padding(
                                            padding: EdgeInsets.all(4.0.sp),
                                            child: Stack(
                                              clipBehavior: Clip.hardEdge,
                                              alignment: Alignment.topRight,
                                              children: [
                                                Container(
                                                    clipBehavior: Clip.hardEdge,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.r),
                                                    ),
                                                    width: 97.w,
                                                    height: 97.w,
                                                    child: Image.file(
                                                      File(images[index].path),
                                                      fit: BoxFit.cover,
                                                    )),
                                                GestureDetector(
                                                  onTap: () {
                                                    images.removeAt(index);
                                                    setState(() {});
                                                  },
                                                  child: Padding(
                                                      padding: EdgeInsets.all(
                                                          10.0.sp),
                                                      child: Transform.rotate(
                                                        angle: 40,
                                                        child: Icon(
                                                          Icons
                                                              .add_circle_outline_rounded,
                                                          color: const Color(
                                                              0xFF575A5E),
                                                          size: 24.sp,
                                                        ),
                                                      )),
                                                )
                                              ],
                                            ),
                                          )),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 8.0.h),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        constraints: const BoxConstraints(
                                          maxHeight: 200.0,
                                        ),
                                        width: 200.w,
                                        child: AnimatedSwitcher(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          child: isRecording
                                              ? AudioWaveforms(
                                                  enableGesture: true,
                                                  size: Size(
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2,
                                                      50),
                                                  recorderController:
                                                      recorderController,
                                                  waveStyle: WaveStyle(
                                                    waveColor: kprimaryColor,
                                                    extendWaveform: true,
                                                    showMiddleLine: false,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                    color: Colors.transparent,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 18),
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15),
                                                )
                                              : TextField(
                                                  controller: widget.controller,
                                                  onChanged: (c) {
                                                    String room = "";
                                                    for (int i = 0;
                                                        i <
                                                            context
                                                                .read<
                                                                    GetChatMessages>()
                                                                .socketRoom
                                                                .length;
                                                        i++) {
                                                      if (context
                                                              .read<
                                                                  GetChatMessages>()
                                                              .socketRoom[i]
                                                              .contains(widget
                                                                  .refId) &&
                                                          context
                                                              .read<
                                                                  GetChatMessages>()
                                                              .socketRoom[i]
                                                              .contains(widget
                                                                  .toId) &&
                                                          context
                                                              .read<
                                                                  GetChatMessages>()
                                                              .socketRoom[i]
                                                              .contains(Controller
                                                                      .getUserId() ??
                                                                  "")) {
                                                        room = context
                                                            .read<
                                                                GetChatMessages>()
                                                            .socketRoom[i]
                                                            .split(":")[0];
                                                        break;
                                                      }
                                                    }
                                                    setState(() {
                                                      if (c.isEmpty) {
                                                        setState(() {
                                                          isTyping = false;
                                                        });
                                                        log("not typing");
                                                        context
                                                            .read<
                                                                GetChatMessages>()
                                                            .socket
                                                            .emit(
                                                                "set_typing", {
                                                          "refid": widget.refId,
                                                          "to": widget.toId,
                                                          "roomName":
                                                              room.trim(),
                                                          "from":
                                                              Controller.userId,
                                                          "typingStatus": "end"
                                                        });
                                                      } else {
                                                        isTyping = true;
                                                        log("typing");
                                                        context
                                                            .read<
                                                                GetChatMessages>()
                                                            .socket
                                                            .emit(
                                                                "set_typing", {
                                                          "refid": widget.refId,
                                                          "to": widget.toId,
                                                          "roomName":
                                                              room.trim(),
                                                          "from":
                                                              Controller.userId,
                                                          "typingStatus":
                                                              "start"
                                                        });
                                                      }
                                                    });
                                                  },
                                                  onSubmitted: (message) {
                                                    sendMessage();
                                                  },
                                                  maxLines: null,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                    hintStyle: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontFamily: Controller
                                                                      .getLanguage()
                                                                  .toString()
                                                                  .toLowerCase() ==
                                                              "english"
                                                          ? GoogleFonts
                                                                  .montserrat()
                                                              .fontFamily
                                                          : GoogleFonts
                                                                  .notoKufiArabic()
                                                              .fontFamily,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    hintText: Controller.getTag(
                                                        'send_message'),
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            left: 10.w),
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          // attachment icon
                                          !isTyping
                                              ? Transform.rotate(
                                                  angle: 45 * math.pi / 180,
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      await getImageFileGallery();
                                                    },
                                                    child: Icon(
                                                      Icons.attach_file_rounded,
                                                      color: ksecondaryColor2,
                                                    ),
                                                  ))
                                              : Container(),

                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          // location icon
                                          !isTyping
                                              ? GestureDetector(
                                                  onTap: () {
                                                    /// Bottom Sheet for Block and Unblock
                                                    showModalBottomSheet(
                                                        isScrollControlled:
                                                            true,
                                                        backgroundColor:
                                                            kbackgrounColor,
                                                        shape:
                                                            const BeveledRectangleBorder(),
                                                        context: context,
                                                        builder: (context) {
                                                          return Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        22.h,
                                                                    top: 21.h,
                                                                    right: 30.w,
                                                                    left: 30.w),
                                                            width: 415.w,
                                                            height: 234.h,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .stretch,
                                                              children: [
                                                                /// Title and close button
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    H2semi(
                                                                        text: Controller.getTag(
                                                                            'ready_for_meetup')),
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
                                                                  color: Color(
                                                                      0xFFEBEBEB),
                                                                ),

                                                                /// Dialog message
                                                                H3Regular(
                                                                    text: Controller
                                                                        .getTag(
                                                                            'share_location')),

                                                                const Divider(
                                                                  color: Color(
                                                                      0xFFEBEBEB),
                                                                ),

                                                                /// Cancel and Block trigger button
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    /// Cancel Button
                                                                    SizedBox(
                                                                        height: 50
                                                                            .h,
                                                                        width: 153
                                                                            .w,
                                                                        child:
                                                                            MainButton(
                                                                          text:
                                                                              Controller.getTag('cancel'),
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          isFilled:
                                                                              false,
                                                                          textColor:
                                                                              ksecondaryColor,
                                                                        )),

                                                                    /// Share Button
                                                                    SizedBox(
                                                                        height: 50
                                                                            .h,
                                                                        width:
                                                                            153.w,
                                                                        child: MainButton(
                                                                            text: Controller.getTag('share'),
                                                                            onTap: () {
                                                                              showDialog(
                                                                                  context: context,
                                                                                  builder: (context) {
                                                                                    return AlertDialog(
                                                                                      insetPadding: EdgeInsets.symmetric(vertical: 0.4.sw),
                                                                                      contentPadding: EdgeInsets.zero,
                                                                                      content: FlutterLocationPicker(
                                                                                        circleRadius: 0,
                                                                                        trackMyPosition: true,

                                                                                        // countryFilter: "ae",
                                                                                        onPicked: (PickedData pickedData) {
                                                                                          print(pickedData.addressData);
                                                                                          widget.controller.text = "https://www.google.com/maps/@${pickedData.latLong.latitude},${pickedData.latLong.longitude},18z";
                                                                                          print("https://www.google.com/maps/@${pickedData.latLong.latitude},${pickedData.latLong.longitude},18z");
                                                                                          print(pickedData.latLong.latitude);
                                                                                          print(pickedData.latLong.longitude);
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                      ),
                                                                                    );
                                                                                  }).whenComplete(() => Navigator.pop(context));
                                                                            })),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  child: Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      color: ksecondaryColor2),
                                                )
                                              : Container(),

                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          // camera icon
                                          !isTyping
                                              ? GestureDetector(
                                                  onTap: () async {
                                                    await getImageFile();
                                                  },
                                                  child: Icon(
                                                      Icons.camera_alt_outlined,
                                                      color: ksecondaryColor2),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 15.0.h),
                            child: Container(
                              alignment: Alignment.center,
                              height: 42.75.h,
                              width: 42.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: kprimaryColor,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if (isTyping ||
                                      images.isNotEmpty ||
                                      widget.controller.text.isNotEmpty) {
                                    sendMessage();
                                  } else {
                                    _startOrStopRecording();
                                  }
                                },
                                child: Icon(
                                  isTyping || images.isNotEmpty
                                      ? Icons.send
                                      : isRecording
                                          ? Icons.stop
                                          : Icons.mic,
                                  color: kbackgrounColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : ParaRegular(
                        text: context.read<GetChatMessages>().blockedBy == "me"
                            ? Controller.getTag('unblock_suggession')
                            : "${Controller.getTag('blocked_by')} ${widget.userName}",
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension DateTimeFormatting on DateTime {
  /// Converts the `DateTime` to local time and formats it as specified.
  String toLocalTimeString({String format = 'hh:mm a'}) {
    // Convert to local and format
    return DateFormat(format).format(this.toLocal());
  }
}
