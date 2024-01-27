import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:brick_breaker/src/components/components.dart';
import 'package:brick_breaker/src/config.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BrickBreaker extends FlameGame with HasCollisionDetection, KeyboardEvents {
  BrickBreaker()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  double get width => size.x;

  double get height => size.y;
  final rand = math.Random();

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(PlayArea());

    world.add(
      Ball(
        velocity: Vector2((rand.nextDouble() - 0.5) * width, height * 0.2).normalized()
          ..scale(height / 4),
        position: size / 2,
        radius: ballRadius,
        difficultyModifier: difficultyModifier,
      ),
    );

    world.add(
      Bat(
        cornerRadius: const Radius.circular(ballRadius / 2),
        position: Vector2(width / 2, height * 0.95),
        size: Vector2(batWidth, batHeight),
      ),
    );

    await world.addAll(
      [
        for (int i = 0; i < brickColors.length; i++)
          for (int j = 1; j < 5; j++)
            Brick(
                Vector2(
                  (i + 0.5) * brickWidth + (i + 1) * brickGutter,
                  (j + 2.0) * brickHeight + j + brickGutter,
                ),
                brickColors[i])
      ],
    );

    debugMode = true;
  }

  @override
  KeyEventResult onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        world.children.query<Bat>().first.moveBy(-batStep);
      case LogicalKeyboardKey.arrowRight:
        world.children.query<Bat>().first.moveBy(batStep);
    }

    return KeyEventResult.handled;
  }
}
