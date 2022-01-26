import 'dart:ui';
import 'package:flame/game.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'components/world_collidable.dart';
import 'helpers/map_loader.dart';
import 'components/world.dart';
import 'helpers/direction.dart';
import 'components/player.dart';
import 'components/enemies.dart';
import 'package:flame/components.dart';
import 'controller/socket_controller.dart';

class RayWorldGame extends FlameGame with HasCollidables {
  final Player _player = Player();
  final Enemies _enemies = Enemies();
  final World _world = World();
  final SocketController _socketController = Get.put(SocketController());

  @override
  // ignore: must_call_super
  Future<void>? onLoad() async {
    print(_socketController.socket.value);
    print(_socketController.socketID.value);
    _socketController.socket.value?.on('data', (data) {
      print(data);
    });
    await add(_world);
    await add(_player);
    await add(_enemies);
    addWorldCollision();

    _player.position = _world.size / 2;
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
