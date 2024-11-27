import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:side_scroller_test/scroller_world.dart';

class SideScrollerGame extends FlameGame with KeyboardEvents, HasKeyboardHandlerComponents {
  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    camera.viewfinder.anchor = Anchor.topLeft;
    world = ScrollerWorld();

    return super.onLoad();
  }
}