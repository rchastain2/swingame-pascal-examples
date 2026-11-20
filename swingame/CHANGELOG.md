# Changelog

Changes made to this copy of SwinGame, on top of commit 73f3fe2 ("DOCS: EOL message") of https://github.com/macite/swingame.

## Unreleased

### Changed

- Resource files in `CoreSDK/test/Resources` are renamed in lowercase with hyphens (for example `ball_small.png` becomes `ball-small.png` and `SpaceInvaders.txt` becomes `space-invaders.txt`). References in bundles, panels, animations and howto programs are updated accordingly.
- The howto programs that no longer compiled are ported to the current API (`OptionToScreen`, `OptionPartBmp`, `OptionDrawTo`, `CollideCircleTriangle`, list regions, `Num0Key`..`Num9Key`, `CreateServer`, `OpenConnection`, `SendMessageTo`, `HasMessages`). `HowToCreateP2P`, which was already broken, is rewritten with the same panels.
- The howto programs use the `arial.ttf` font file instead of the missing `Arial` font name.
- `ReadMe.md` is renamed `README.md` and starts with a note describing this copy.
- The file dialog (`CoreSDK/src/sgUserInterface.pas`) loads the `file-dialog.txt` bundle instead of `FileDialog.txt`.

### Removed

- Everything that is not needed to build the SDL2 backend and the Pascal units, except the `CoreSDK/howto` examples: templates, tools, prebuilt libraries, test programs and their resources. Only `CoreSDK/test/SwinGame.pas` is kept from the test directory.

### Fixed

- `TangentPoints` (`CoreSDK/src/sgGeometry.pas`) returned the points diametrically opposite to the tangent points, on the far side of the circle. The vector used in the computation now goes from the center of the circle to the point, instead of the reverse.
