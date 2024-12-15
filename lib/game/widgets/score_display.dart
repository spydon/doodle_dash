// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:doodle_dash/game/doodle_dash.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class ScoreDisplay extends StatelessWidget {
  const ScoreDisplay({required this.game, super.key, this.isLight = false});

  final Game game;
  final bool isLight;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: (game as DoodleDash).gameManager.score,
      builder: (context, value, child) {
        return Text('Score: $value',
            style: Theme.of(context).textTheme.displaySmall,);
      },
    );
  }
}
