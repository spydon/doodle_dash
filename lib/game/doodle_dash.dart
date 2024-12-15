// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:doodle_dash/game/managers/managers.dart';
import 'package:doodle_dash/game/parallax_background.dart';
import 'package:doodle_dash/game/sprites/sprites.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

enum Character { dash, sparky }

class DoodleDash extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  DoodleDash({super.children});

  final ParallaxBackground _background = ParallaxBackground();
  LevelManager levelManager = LevelManager();
  GameManager gameManager = GameManager();
  int screenBufferSpace = 300;
  ObjectManager objectManager = ObjectManager();

  late Player player;

  @override
  Future<void> onLoad() async {
    await add(_background);

    await add(gameManager);

    overlays.add('gameOverlay');

    await add(levelManager);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameManager.isGameOver) {
      return;
    }

    if (gameManager.isIntro) {
      overlays.add('mainMenuOverlay');
      return;
    }

    if (gameManager.isPlaying) {
      checkLevelUp();

      final worldBounds = Rectangle.fromLTRB(
        0,
        camera.viewfinder.position.y - screenBufferSpace,
        size.x,
        camera.viewfinder.position.y + _background.size.y,
      );
      camera.setBounds(worldBounds);
      if (player.isMovingDown) {
        camera.setBounds(worldBounds);
      }

      final isInTopHalfOfScreen = player.position.y <= (_background.size.y / 2);
      if (!player.isMovingDown && isInTopHalfOfScreen) {
        camera.follow(player);
      }

      if (player.position.y >
          camera.viewfinder.position.y +
              _background.size.y +
              player.size.y +
              screenBufferSpace) {
        onLose();
      }
    }
  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 241, 247, 249);
  }

  void initializeGameStart() {
    setCharacter();

    gameManager.reset();

    if (children.contains(objectManager)) {
      objectManager.removeFromParent();
    }

    levelManager.reset();

    camera.setBounds(
      Rectangle.fromLTRB(
        0,
        // top of screen is 0, so negative is already off screen
        -_background.size.y,
        size.x,
        // makes sure bottom bound of game is below bottom of screen
        _background.size.y + screenBufferSpace,
      ),
    );
    camera.follow(player);

    objectManager = ObjectManager(
      minVerticalDistanceToNextPlatform: levelManager.minDistance,
      maxVerticalDistanceToNextPlatform: levelManager.maxDistance,
    );

    add(objectManager);

    objectManager.configure(levelManager.level, levelManager.difficulty);
  }

  void setCharacter() {
    player = Player(
      character: gameManager.character,
      jumpSpeed: levelManager.startingJumpSpeed,
    );
    add(player);
  }

  void startGame() {
    initializeGameStart();
    gameManager.state = GameState.playing;
    overlays.remove('mainMenuOverlay');
  }

  void resetGame() {
    startGame();
    overlays.remove('gameOverOverlay');
  }

  void onLose() {
    gameManager.state = GameState.gameOver;
    player.removeFromParent();
    overlays.add('gameOverOverlay');
  }

  void togglePauseState() {
    if (paused) {
      resumeEngine();
    } else {
      pauseEngine();
    }
  }

  void checkLevelUp() {
    if (levelManager.shouldLevelUp(gameManager.score.value)) {
      levelManager.increaseLevel();

      objectManager.configure(levelManager.level, levelManager.difficulty);

      player.jumpSpeed = levelManager.jumpSpeed;
    }
  }
}
