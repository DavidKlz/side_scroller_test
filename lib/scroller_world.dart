import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';
import 'package:side_scroller_test/character.dart';
import 'package:side_scroller_test/side_scroller_game.dart';

class ScrollerWorld extends World with HasGameRef<SideScrollerGame> {
  Character character = Character(anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() async {
    character.position = Vector2(game.size.x * 0.1, game.size.y - 48);
    final parallax = await game.loadParallaxComponent(
      [
        ParallaxImageData('plx-1.png'),
        ParallaxImageData('plx-2.png'),
        ParallaxImageData('plx-3.png'),
        ParallaxImageData('plx-4.png'),
        ParallaxImageData('plx-5.png'),
      ],
      baseVelocity: Vector2(2, 0),
      repeat: ImageRepeat.repeat,
      velocityMultiplierDelta: Vector2(3, 0),
    );

    final parallaxGround = await game.loadParallaxComponent(
      [
        ParallaxImageData('ground.png'),
      ],
      fill: LayerFill.none,
      baseVelocity: Vector2(25, 0),
      repeat: ImageRepeat.repeatX,
      velocityMultiplierDelta: Vector2(25, 0),
    );

    addAll([
      parallax,
      parallaxGround,
      character,
    ]);

    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    character.position = Vector2(size.x * 0.1, size.y - 48);
  }
}
