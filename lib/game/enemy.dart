import 'dart:math';

import 'package:flame/components.dart';
import 'package:starlance/game/knows_game_size.dart';

/// An enemy that moves down the screen.
class Enemy extends SpriteComponent with KnowsGameSize {
  /// The speed at which the enemy moves.
  double speed = 250;

  /// Constructs an enemy with a [sprite], [size] and [position].
  Enemy(
    Sprite? sprite,
    Vector2? size,
    Vector2? position,
  ) : super(sprite: sprite, size: size, position: position) {
    angle = pi;
  }

  /// Updates the enemy's position by moving it down the screen.
  ///
  /// This is called every frame and the [dt] parameter is used to
  /// calculate how much to move the enemy based on the frame time.
  @override
  void update(double dt) {
    super.update(dt);
    position += Vector2(0, 1) * speed * dt;

    if (position.y > gamesize.y) {
      removeFromParent();
    }
  }
}
