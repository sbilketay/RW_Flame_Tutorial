import 'dart:convert';
import 'dart:ui';
import 'package:flame/game.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'components/world_collidable.dart';
import 'helpers/map_loader.dart';
import 'components/world.dart';
import 'helpers/direction.dart';
import 'components/player.dart';
import 'package:flame/components.dart';
import 'controller/socket_controller.dart';
import 'components/enemies.dart';

class RayWorldGame extends FlameGame with HasCollidables {
  final Player _player = Player();
  final World _world = World();
  final SocketController _socketController = Get.put(SocketController());

  @override
  // ignore: must_call_super
  Future<void>? onLoad() async {
    await add(_world);
    await add(_player);
    addWorldCollision();
    _socketController.socket.value?.on('load-player', (players) {
      players.forEach((player) async {
        if (player == _socketController.socketID.value) return;
        final Enemies _enemy = Enemies();
        await add(_enemy);
        _enemy.position = Vector2.random() * 2000;

        _socketController.socket.value?.on('data', (pos) {
          final x = double.parse(json.decode(pos.toString())[0].toString());
          final y = double.parse(json.decode(pos.toString())[1].toString());
          final playerId = json.decode(pos.toString())[2] ?? '';
          _enemy.updatePos(Vector2(x, y));
        });
      });
    });
    _player.position = Vector2.random() * 2000;

    camera.followComponent(
      _player,
      worldBounds: Rect.fromLTRB(0, 0, _world.size.x, _world.size.y),
    );
  }

  void onJoypadDirectionChanged(Direction direction) {
    _player.direction = direction;
  }

  void addWorldCollision() async =>
      (await MapLoader.readRayWorldCollisionMap()).forEach((rect) {
        add(WorldCollidable()
          ..position = Vector2(rect.left, rect.top)
          ..width = rect.width
          ..height = rect.height);
      });
}
