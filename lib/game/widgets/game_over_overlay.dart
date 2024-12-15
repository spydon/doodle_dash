// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:doodle_dash/game/doodle_dash.dart';
import 'package:doodle_dash/game/widgets/widgets.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

// Overlay that pops up when the game ends
class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay(this.game, {super.key});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Game Over',
                style: Theme.of(context).textTheme.displayMedium!.copyWith(),
              ),
              const WhiteSpace(height: 50),
              ScoreDisplay(
                game: game,
                isLight: true,
              ),
              const WhiteSpace(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  (game as DoodleDash).resetGame();
                },
                style: ButtonStyle(
                  minimumSize: WidgetStateProperty.all(
                    const Size(200, 75),
                  ),
                  textStyle: WidgetStateProperty.all(
                      Theme.of(context).textTheme.titleLarge,),
                ),
                child: const Text('Play Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
