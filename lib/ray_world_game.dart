import 'dart:ui';
import 'package:flame/game.dart';
import 'components/world_collidable.dart';
import 'helpers/map_loader.dart';
import 'components/world.dart';
import 'helpers/direction.dart';
import 'components/player.dart';
import 'package:flame/components.dart';

class RayWorldGame extends FlameGame with HasCollidables {
  final Player _player = Player();
  final World _world = World();

  @override
  // ignore: must_call_super
  Future<void>? onLoad() async {
    await add(_world);
    await add(_player);
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
