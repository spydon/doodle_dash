// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:doodle_dash/game/doodle_dash.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

// Overlay that appears for the main menu
class MainMenuOverlay extends StatefulWidget {
  const MainMenuOverlay(this.game, {super.key});

  final Game game;

  @override
  State<MainMenuOverlay> createState() => _MainMenuOverlayState();
}

class _MainMenuOverlayState extends State<MainMenuOverlay> {
  Character character = Character.dash;

  @override
  Widget build(BuildContext context) {
    final game = widget.game as DoodleDash;

    return LayoutBuilder(
      builder: (context, constraints) {
        final characterWidth = constraints.maxWidth / 5;

        final titleStyle = (constraints.maxWidth > 830)
            ? Theme.of(context).textTheme.displayLarge!
            : Theme.of(context).textTheme.displaySmall!;

        // 760 is the smallest height the browser can have until the
        // layout is too large to fit.
        final screenHeightIsSmall = constraints.maxHeight < 760;

        return Material(
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Doodle Dash',
                      style: titleStyle.copyWith(
                        height: .8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const WhiteSpace(),
                    Align(
                      child: Text(
                        'Select your character:',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    if (!screenHeightIsSmall) const WhiteSpace(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CharacterButton(
                          character: Character.dash,
                          selected: character == Character.dash,
                          onSelectChar: () {
                            setState(() {
                              character = Character.dash;
                            });
                          },
                          characterWidth: characterWidth,
                        ),
                        CharacterButton(
                          character: Character.sparky,
                          selected: character == Character.sparky,
                          onSelectChar: () {
                            setState(() {
                              character = Character.sparky;
                            });
                          },
                          characterWidth: characterWidth,
                        ),
                      ],
                    ),
                    if (!screenHeightIsSmall) const WhiteSpace(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Difficulty:',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        LevelPicker(
                          level: game.levelManager.selectedLevel.toDouble(),
                          label: game.levelManager.selectedLevel.toString(),
                          onChanged: (value) {
                            setState(() {
                              game.levelManager.selectLevel(value.toInt());
                            });
                          },
                        ),
                      ],
                    ),
                    if (!screenHeightIsSmall) const WhiteSpace(height: 50),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          game.gameManager.character = character;
                          game.startGame();
                        },
                        style: ButtonStyle(
                          minimumSize: WidgetStateProperty.all(
                            const Size(100, 50),
                          ),
                          textStyle: WidgetStateProperty.all(
                            Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        child: const Text('Start'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class LevelPicker extends StatelessWidget {
  const LevelPicker({
    required this.level,
    required this.label,
    required this.onChanged,
    super.key,
  });

  final double level;
  final String label;
  final void Function(double) onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Slider(
        value: level,
        max: 5,
        min: 1,
        divisions: 4,
        label: label,
        onChanged: onChanged,
      ),
    );
  }
}

class CharacterButton extends StatelessWidget {
  const CharacterButton({
    required this.character,
    required this.onSelectChar,
    required this.characterWidth,
    super.key,
    this.selected = false,
  });

  final Character character;
  final bool selected;
  final void Function() onSelectChar;
  final double characterWidth;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: selected
          ? ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                const Color.fromARGB(31, 64, 195, 255),
              ),
            )
          : null,
      onPressed: onSelectChar,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image.asset(
              'assets/images/game/${character.name}_center.png',
              height: characterWidth,
              width: characterWidth,
            ),
            const WhiteSpace(height: 18),
            Text(
              character.name,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class WhiteSpace extends StatelessWidget {
  const WhiteSpace({super.key, this.height = 100});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
