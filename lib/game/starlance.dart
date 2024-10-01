import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:starlance/game/bullet.dart';
import 'package:starlance/game/enemy.dart';
import 'package:starlance/game/enemy_manager.dart';
import 'package:starlance/game/knows_game_size.dart';
import 'package:starlance/game/player.dart';

class Starlance extends FlameGame with PanDetector, TapDetector {
  // The position on the screen where the joystick is.
  Offset? _pointerStartPosition;

  // The current position of the joystick.
  Offset? _pointerCurrentPosition;

  // The distance from the joystick position to the edge of the screen that is
  // considered part of the joystick.
  final double _joystickRadius = 60;

  // The distance from the joystick position to the edge of the screen that is considered the dead zone.
  final double _deadZoneRadius = 10;

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

    // Create the player.
    player = Player(
      _spriteSheet.getSpriteById(17),
      Vector2(64, 64),
      canvasSize / 2,
    );

    // Set the player's anchor to the center of the screen.
    player.anchor = Anchor.center;

    // Add the player to the game.
    add(player);

    // Create the enemy manager.
    enemies = EnemyManager(spriteSheet: _spriteSheet);

    // Add the enemy manager to the game.
    add(enemies);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw the joystick if it is visible.
    if (_pointerStartPosition != null) {
      final Offset pointerStartPositionOffset =
          Offset(_pointerStartPosition!.dx, _pointerStartPosition!.dy);
      canvas.drawCircle(pointerStartPositionOffset, _joystickRadius,
          Paint()..color = Colors.grey.withAlpha(100));
    }

    // Draw the joystick's current position if it is visible.
    if (_pointerCurrentPosition != null) {
      var delta = _pointerCurrentPosition! - _pointerStartPosition!;
      if (delta.distance > _joystickRadius) {
        delta = _pointerStartPosition! +
            (Vector2(delta.dx, delta.dy).normalized() * _joystickRadius)
                .toOffset();
      } else {
        delta = _pointerCurrentPosition!;
      }
      canvas.drawCircle(delta, 20, Paint()..color = Colors.grey.withAlpha(100));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Get all the bullets in the game.
    final bullets = children.whereType<Bullet>();

    // Check if any of the bullets have hit any of the enemies.
    for (final enemy in enemies.children.whereType<Enemy>()) {
      if (enemy.isRemoved) continue;
      for (final bullet in bullets) {
        if (bullet.isRemoved) continue;
        if (enemy.containsPoint(bullet.absolutePosition)) {
          enemy.removeFromParent();
          bullet.removeFromParent();
          break;
        }
      }
    }
  }

  @override
  void onPanStart(DragStartInfo info) {
    // Set the start and current positions of the joystick when the user starts
    // dragging.
    _pointerStartPosition = info.eventPosition.global.toOffset();
    _pointerCurrentPosition = info.eventPosition.global.toOffset();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    // Set the current position of the joystick when the user is dragging.
    _pointerCurrentPosition = info.eventPosition.global.toOffset();
    var delta = _pointerCurrentPosition! - _pointerStartPosition!;
    if (delta.distance > _deadZoneRadius) {
      player.setMoveDirection(Vector2(delta.dx, delta.dy));
    } else {
      player.setMoveDirection(Vector2.zero());
    }
  }

  @override
  void onPanEnd(DragEndInfo info) {
    // Reset the joystick when the user stops dragging.
    _pointerStartPosition = null;
    _pointerCurrentPosition = null;
    player.setMoveDirection(Vector2.zero());
  }

  @override
  void onPanCancel() {
    // Reset the joystick when the user cancels the drag gesture.
    _pointerStartPosition = null;
    _pointerCurrentPosition = null;
    player.setMoveDirection(Vector2.zero());
  }

  @override
  void onTap() {
    super.onTap();
    Bullet bullet = Bullet(
      _spriteSheet.getSpriteById(28),
      Vector2(64, 64),
      player.position,
    );
    bullet.anchor = Anchor.center;
    add(bullet);
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
