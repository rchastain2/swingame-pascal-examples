# Changelog

Changes made to this copy of SwinGame, on top of commit 73f3fe2 ("DOCS: EOL message") of https://github.com/macite/swingame.

## Unreleased

### Changed

- Resource files in `CoreSDK/test/Resources` are renamed in lowercase with hyphens (for example `ball_small.png` becomes `ball-small.png` and `SpaceInvaders.txt` becomes `space-invaders.txt`). References in bundles, panels, animations and howto programs are updated accordingly.
- The file dialog (`CoreSDK/src/sgUserInterface.pas`) loads the `file-dialog.txt` bundle instead of `FileDialog.txt`.

### Removed

- Everything that is not needed to build the SDL2 backend and the Pascal units, except the `CoreSDK/howto` examples: templates, tools, prebuilt libraries, test programs and their resources. Only `CoreSDK/test/SwinGame.pas` is kept from the test directory.

### Fixed

- `TangentPoints` (`CoreSDK/src/sgGeometry.pas`) returned the points diametrically opposite to the tangent points, on the far side of the circle. The vector used in the computation now goes from the center of the circle to the point, instead of the reverse.
