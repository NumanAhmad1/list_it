import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lisit_mobile_app/Models/ChatMessageModel.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../../const/lib_all.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class GetChatMessages extends ChangeNotifier {
  List<ChatMessageModel> allChatsMessages = [];
  bool isLoading = false;
  bool blockedStatus = false;
  String blockedBy = "";

  Future<bool> getBlockedStatus(String refId, String toId, context) async {
    allChatsMessages = [];
    isLoading = true;
    notifyListeners();
    var endPoint = "/chat/all";

    var response = await CallApi.getApi(context,
        parametersMap: {"refid": refId, "to": toId},
        endPoint: endPoint,
        token: Controller.getUserToken(),
        isAdmin: false);
    // if (kDebugMode) {
    //   print(response['data']);
    // }

    // Change this check
    if (response['blockInfo'] is Map) {
      blockedStatus = response['blockInfo']['status'];
      blockedBy = response['blockInfo']['blocked_by'];
      notifyListeners();
      print("NotifyListener Called");
      return response['blockInfo']['status'];
      notifyListeners();
    } else {
      if (kDebugMode) {
        print('Unexpected API response format: $response');
      }
    }
    isLoading = false;
    notifyListeners();
    return false;
  }

  getChatMessages(String refId, String toId, context) async {
    blockedStatus = false;
    allChatsMessages = [];
    isLoading = true;
    notifyListeners();
    var endPoint = "/chat/all";

    var response = await CallApi.getApi(context,
        parametersMap: {"refid": refId, "to": toId},
        endPoint: endPoint,
        token: Controller.getUserToken(),
        isAdmin: false);
    if (kDebugMode) {
      print(response['data']);
    }

    // Change this check
    if (response['data'] is List<dynamic>) {
      allChatsMessages = (response['data'] as List)
          .map((json) => ChatMessageModel.fromJson(json))
          .toList()
          .reversed
          .toList();
      blockedStatus = response['blockInfo']['status'];
      blockedBy = response['blockInfo']['blocked_by'];
      print("NotifyListener Called");
      notifyListeners();
    } else {
      if (kDebugMode) {
        print('Unexpected API response format: $response');
      }
    }
    isLoading = false;
    notifyListeners();
  }

  sendChatMessage(String refId, String toId, String message, String attachment,
      context) async {
    isLoading = true;
    notifyListeners();
    var endPoint = "/chat/add";

    var response = await CallApi.postApi(context,
        isInsideData: true,
        parametersList: {
          "message": message,
          "to": toId,
          "refid": refId,
          "attachment": attachment
        },
        endPoint: endPoint,
        token: Controller.getUserToken(),
        isAdmin: false);
    if (kDebugMode) {
      print(response['data']);
    }

    // Change this check
    // if (response['data'] is List<dynamic>) {
    //   allChatsMessages = (response['data'] as List)
    //       .map((json) => ChatMessageModel.fromJson(json))
    //       .toList();
    //   notifyListeners();
    // } else {
    //   if (kDebugMode) {
    //     print('Unexpected API response format: $response');
    //   }
    // }
    isLoading = false;
    notifyListeners();
  }

  Future blockUser(String toId, bool block, context) async {
    isLoading = true;
    notifyListeners();
    var endPoint = "/user/block-user";

    var response = await CallApi.postApi(context,
        isInsideData: false,
        parametersList: {
          "Id": toId,
          "IsBlock": block,
        },
        endPoint: endPoint,
        token: Controller.getUserToken(),
        isAdmin: false);
    if (kDebugMode) {
      print(response['message']);
    }
    isLoading = false;
    notifyListeners();
    return response;
  }

  Future deleteChats(List<String> chatIds, context) async {
    isLoading = true;
    notifyListeners();
    var endPoint = "/chat/delete";

    var response = await CallApi.deleteApi(
      context,
      endPoint: endPoint,
      body: {
        "chatids": chatIds,
      },
      token: Controller.getUserToken(),
    );
    isLoading = false;
    notifyListeners();
    return response;
  }

  // //---------------------------------------//

  List<String> socketRoom = [];
  // String urlSocr = "wss://api.listit.mindzbase.tech";
  // String urlSocr = "wss://api.listit.ae";
  String urlSocr = "${dotenv.env['urlSocr']}";

  // String urlSoc = "http://192.168.100.73:80";
  IO.Socket socket = IO.io(
    Uri.parse(Controller.urlSoc).toString(),
    OptionBuilder()
        .setTransports(['websocket']) // for Flutter or Dart VM
        .disableAutoConnect() // disable auto-connection
        // .setPath("/")
        .build(),
  );

  disconnectSocket() {
    socket.disconnect();
  }

  /// Socket IO
  initializeSocketFromProvider(context) {
    if (socket.connected) {
      socket.disconnect();
    }
    print("UserID : ${Controller.getUserId()}");
    try {
      // var ws = await WebSocket.connect('ws://192.168.100.73/socket.io');
      // ws.listen((event) {
      //   print(event);
      // });
      socket.connect();
      log('socket is connected: ${socket.connected}');
      socket.onConnect((_) {
        socket.emit('joinroom', {"userid": Controller.getUserId()});
        log('Connection established: ${socket.opts}');
      });
      socket.onConnectError((err) => log("Connection Error : $err"));
      socket.onError((err) => log("Error : $err"));
      socket.on('receive', (data) {
        log('$data');
        log("receive data : ${data['Refid']} ${data['To']}");
        // refId = data['Refid'];
        // toId = data['To'];
        socket.emit('joinroom', {"userid": Controller.getUserId()});
        log('Calling api after msg');
        getChatMessages(
          '${data['Refid']}',
          '${data['To']}',
          context,
        );
      });
      socket.on('send', (data) {
        return log('$data');
      });
      socket.on('connectedrooms', (data) {
        log("connected data : ${data.toString().replaceAll("{", "").replaceAll("}", "").split(",")}");
        socketRoom =
            data.toString().replaceAll("{", "").replaceAll("}", "").split(",");
        log("Socket rooms ${socketRoom[0]}");
      });
      socket.on('chatusers', (data) => log("user data : $data"));
      socket.onDisconnect((e) {
        log('disconnect');
        log(e);
      });
    } catch (e) {
      log("Socket error :");
      log(e.toString());
    }
  }

  sendMessageToSocket(dynamic msg) {
    log("Send to Socket : ${msg}");
    socket.emit('send', msg);
  }
}
