import 'dart:async';
import 'package:flame/components.dart';

import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/painting.dart';

import 'package:starlance/game/enemy_manager.dart';
import 'package:starlance/game/knows_game_size.dart';
import 'package:starlance/game/player.dart';

class Starlance extends FlameGame with HasCollisionDetection {
  late SpriteSheet _spriteSheet;
  late Player player;
  late EnemyManager enemies;

  @override
  FutureOr<void> onLoad() async {
    // Load the sprite sheet.
    await images.load("spritsheet.png");

    // Create the sprite sheet.
    _spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: images.fromCache("spritsheet.png"),
      columns: 8,
      rows: 6,
    );
    final joystick = JoystickComponent(
      size: 50,
      knob: SpriteComponent(
        size: Vector2.all(100),
        sprite: _spriteSheet.getSpriteById(28),
      ),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    // Create the player.
    player = Player(
      joystick,
      _spriteSheet.getSpriteById(17),
      Vector2(64, 64),
      canvasSize / 2,
    );

    // Set the player's anchor to the center of the screen.
    player.anchor = Anchor.center;

    // Prepare the player to be added to the game.
    prepare(player);

    // Add the player to the game.
    add(player);

    // Create the enemy manager.
    enemies = EnemyManager(spriteSheet: _spriteSheet);

    // Prepare the enemy manager to be added to the game.
    prepare(enemies);

    // Add the enemy manager to the game.
    add(enemies);
    add(joystick);
  }

  // Prepare a component to be added to the game.
  void prepare(Component c) {
    if (c is KnowsGameSize) {
      c.onGameResize(size);
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    children.whereType<KnowsGameSize>().forEach((component) {
      component.onGameResize(this.size);
    });
  }
}
