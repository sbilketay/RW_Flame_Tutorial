import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketController extends GetxController {
  Rxn<String> socketID = Rxn<String>();
  Rxn<IO.Socket> socket = Rxn<IO.Socket>();
  RxBool connected = false.obs;
}
