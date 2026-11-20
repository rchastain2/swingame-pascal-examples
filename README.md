# SwinGame Pascal examples

Pascal examples for the [SwinGame library](https://github.com/macite/swingame).

## Requirements

[Free Pascal](https://www.freepascal.org/) 3.2, Clang, SDL2 (with mixer, image, gfx, ttf, net), libpng and libcurl. On Debian or Ubuntu:

```bash
sudo apt install fpc clang libsdl2-dev libsdl2-mixer-dev libsdl2-image-dev libsdl2-gfx-dev libsdl2-ttf-dev libsdl2-net-dev libpng-dev libcurl4-openssl-dev
```

## Build

Build the library once, then any example:

```bash
git clone https://github.com/rchastain2/swingame-pascal-examples.git
cd swingame-pascal-examples
bash build-library.sh
cd amethyst
make
./demo
```

## Contents

| | |
|---|---|
| [Amethyst](amethyst) | Animation |
| [Balls](balls) | Bouncing balls with elastic collisions |
| [Bear](bear) | Animation |
| [Geometry](geometry) | Interactive demonstrations of the geometry functions |
| [Josephus](josephus) | Josephus problem |
| [Racing](racing) | C64 style racing game |

![Amethyst](amethyst/screenshot.png) ![Balls](balls/screenshot.png) ![Bear](bear/screenshot.png) ![Geometry](geometry/screenshot.png) ![Josephus](josephus/screenshot.png) ![Racing](racing/screenshot.png)
