import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:side_scroller_test/side_scroller_game.dart';

enum CharacterState { idle, run, hit, jump, fall }

class Character extends SpriteAnimationGroupComponent
    with HasGameRef<SideScrollerGame>, KeyboardHandler {
  final double _gravity = 9.8;
  final double _jumpForce = 360;
  final double _terminalVelocity = 300;

  Vector2 velocity = Vector2(0, 10);
  bool hasJumped = false;
  bool isOnGround = false;
  bool gotHit = false;

  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 0;

  Character({super.position, super.anchor});

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    size = Vector2.all(64);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    accumulatedTime += dt;

    while (accumulatedTime >= fixedDeltaTime) {
      if (!gotHit) {
        _updateState();
        _updateMovement(fixedDeltaTime);
        //_checkHorizontalCollisions();
        _applyGravity(fixedDeltaTime);
        _checkVerticalCollisions();
      }

      accumulatedTime -= fixedDeltaTime;
    }
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    hasJumped = keysPressed.any(
      (element) =>
          element == LogicalKeyboardKey.arrowUp ||
          element == LogicalKeyboardKey.space ||
          element == LogicalKeyboardKey.keyW,
    );
    return super.onKeyEvent(event, keysPressed);
  }

  void _updateState() {
    CharacterState playerState = CharacterState.run;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    // check if Falling set to falling
    if (velocity.y > 0) playerState = CharacterState.fall;

    // Checks if jumping, set to jumping
    if (velocity.y < 0) playerState = CharacterState.jump;

    current = playerState;
  }

  void _updateMovement(double dt) {
    if (hasJumped && isOnGround) _jump(dt);
  }

  void _jump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _loadAllAnimations() {
    var idleAnimation = _createAnimation("idle.png", 11);
    var runAnimation = _createAnimation("run.png", 12);
    var hitAnimation = _createAnimation("hit.png", 7, loop: false);
    var jumpAnimation = _createAnimation("jump.png", 1);
    var fallAnimation = _createAnimation("fall.png", 1);

    animations = {
      CharacterState.idle: idleAnimation,
      CharacterState.run: runAnimation,
      CharacterState.hit: hitAnimation,
      CharacterState.jump: jumpAnimation,
      CharacterState.fall: fallAnimation,
    };

    current = CharacterState.run;
  }

  void _checkVerticalCollisions() {
    if (position.y >= game.size.y - 48) {
        velocity.y = 0;
        position.y = game.size.y - 48;
        isOnGround = true;
    }
  }

  _createAnimation(String image, int amount, {bool loop = true}) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(image),
      SpriteAnimationData.sequenced(
        amount: amount,
        textureSize: Vector2.all(32),
        stepTime: 0.05,
        loop: loop,
      ),
    );
  }
}
