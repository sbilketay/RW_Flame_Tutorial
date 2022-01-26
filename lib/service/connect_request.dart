import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:nanoid/nanoid.dart';
import '../controller/socket_controller.dart';
import '../models/server_response.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final SocketController _socketController = Get.put(SocketController());

final IO.Socket socketInit = IO.io(dotenv.env['SOCKET_URL'],
    IO.OptionBuilder().setTransports(['websocket']).build());

Future<void> connectServer() async {
  try {
    final _socketId = nanoid(30) + ' - ' + dotenv.env['SECRET_KEY'].toString();

    final jsonData = await Dio().post(dotenv.env['SOCKET_URL']! + '/connect/',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        }),
        data: {'requestId': _socketId});

    final ServerResponse returnResult =
        ServerResponse.fromJson(jsonData.data as Map<String, dynamic>);

    // Connection status
    _socketController.connected.value = true;
    // Socket Initializing
    _socketController.socket.value = socketInit;
    // Set socket Id
    _socketController.socketID.value = returnResult.result;
  } catch (e) {
    if (e is DioError) {
      print(e.type.toString() + ' ' + e.error.toString());
    } else {
      print(e);
    }
  }
}
