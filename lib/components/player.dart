import 'dart:convert';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import '../controller/socket_controller.dart';
import '../helpers/direction.dart';
import 'world_collidable.dart';

class Player extends SpriteAnimationComponent
    with HasGameRef, Hitbox, Collidable {
  Player() : super(size: Vector2.all(50.0)) {
    addHitbox(HitboxRectangle());
    debugMode = true;
  }
  Direction _collisionDirection = Direction.none;
  bool _hasCollided = false;
  Direction direction = Direction.none;

  final SocketController _socketController = Get.put(SocketController());

  final double _playerSpeed = 300.0;
  final double _animationSpeed = 0.15;
  late final SpriteAnimation _runDownAnimation,
      _runUpAnimation,
      _runLeftAnimation,
      _runRightAnimation,
      _standingAnimation;

  @override
  void update(double delta) {
    super.update(delta);
    movePlayer(delta);
  }

  void movePlayer(double delta) {
    switch (direction) {
      case Direction.down:
        if (canPlayerMoveDown()) {
          animation = _runDownAnimation;
          moveDown(delta);
        }
        break;
      case Direction.right:
        if (canPlayerMoveRight()) {
          animation = _runRightAnimation;
          moveRight(delta);
        }
        break;
      case Direction.left:
        if (canPlayerMoveLeft()) {
          animation = _runLeftAnimation;
          moveLeft(delta);
        }
        break;
      case Direction.up:
        if (canPlayerMoveUp()) {
          animation = _runUpAnimation;
          moveUp(delta);
        }
        break;
      case Direction.none:
        animation = _standingAnimation;
        break;
    }
  }

  void moveDown(double delta) {
    final sendData =
        json.encode([position.x.toString(),position.y.toString(), _socketController.socketID.value]);

    _socketController.socket.value?.emit('position', sendData);
    position.add(Vector2(0, delta * _playerSpeed));
  }

  void moveUp(double delta) {
    final sendData =
        json.encode([position.x.toString(),position.y.toString(), _socketController.socketID.value]);
    _socketController.socket.value?.emit('position', sendData);
    position.add(Vector2(0, -delta * _playerSpeed));
  }

  void moveLeft(double delta) {
    final sendData =
        json.encode([position.x.toString(),position.y.toString(), _socketController.socketID.value]);
    _socketController.socket.value?.emit('position', sendData);
    position.add(Vector2(-delta * _playerSpeed, 0));
  }

  void moveRight(double delta) {
    final sendData =
        json.encode([position.x.toString(),position.y.toString(), _socketController.socketID.value]);
    _socketController.socket.value?.emit('position', sendData);
    position.add(Vector2(delta * _playerSpeed, 0));
  }

  bool canPlayerMoveUp() {
    if (_hasCollided && _collisionDirection == Direction.up) {
      return false;
    }
    return true;
  }

  bool canPlayerMoveDown() {
    if (_hasCollided && _collisionDirection == Direction.down) {
      return false;
    }
    return true;
  }

  bool canPlayerMoveLeft() {
    if (_hasCollided && _collisionDirection == Direction.left) {
      return false;
    }
    return true;
  }

  bool canPlayerMoveRight() {
    if (_hasCollided && _collisionDirection == Direction.right) {
      return false;
    }
    return true;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _loadAnimations().then((value) => animation = _standingAnimation);
    position = gameRef.size / 2;
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = SpriteSheet(
        image: await gameRef.images.load('player_spritesheet.png'),
        srcSize: Vector2(29.0, 32.0));

    _standingAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 1);
    _runDownAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 4);
    _runLeftAnimation =
        spriteSheet.createAnimation(row: 1, stepTime: _animationSpeed, to: 4);
    _runUpAnimation =
        spriteSheet.createAnimation(row: 2, stepTime: _animationSpeed, to: 4);
    _runRightAnimation =
        spriteSheet.createAnimation(row: 3, stepTime: _animationSpeed, to: 4);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);

    if (other is WorldCollidable) {
      if (!_hasCollided) {
        _hasCollided = true;
        _collisionDirection = direction;
      }
    }
  }

  @override
  void onCollisionEnd(Collidable other) {
    super.onCollisionEnd(other);
    _hasCollided = false;
  }
}
