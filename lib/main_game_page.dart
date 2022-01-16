import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'ray_world_game.dart';
import 'helpers/direction.dart';
import 'helpers/joypad.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MainGamePage extends StatefulWidget {
  const MainGamePage({Key? key}) : super(key: key);

  @override
  MainGameState createState() => MainGameState();
}

class MainGameState extends State<MainGamePage> {
  late IO.Socket socket;

  void initSocket() {
    socket = IO.io('http://95.217.9.198:3000',
        IO.OptionBuilder().setTransports(['websocket']).build());

    socket.connect();
  }
  RayWorldGame game = RayWorldGame();

  void onJoypadDirectionChanged(Direction direction) {
    game.onJoypadDirectionChanged(direction);
  }

  @override
  void initState() {
    super.initState();
    initSocket();
    game.socket(socket);
    socket.on('data', (dynamic data) => print(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
        body: Stack(
          children: [
            GameWidget(game: game),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Joypad(onDirectionChanged: onJoypadDirectionChanged),
              ),
            )
          ],
        ));
  }
}
