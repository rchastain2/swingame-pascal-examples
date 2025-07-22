#!/bin/bash

# Builds and installs the SwinGame library on Linux.

pushd swingame/Backend/SGSDL2/projects/bash/

rm -fv libsgsdl2.so

clang++ -shared -fPIC -std=c++11 \
-Weverything -Wno-padded -Wno-missing-prototypes -Wno-c++98-compat \
-lSDL2 -lSDL2_mixer -lSDL2_image -lSDL2_gfx -lSDL2_ttf -lSDL2_net \
`sdl2-config --cflags` `curl-config --cflags` -lcurl \
-I../../../Core/include/ -I../../../Core/src/ ../../../SGSDL2/src/*.cpp ../../../Core/src/*.cpp \
-o libsgsdl2.so -g

sudo install libsgsdl2.so -t /usr/lib/

mkdir -p ../../../../CoreSDK/staticlib/sdl2/linux
cp -fv libsgsdl2.so ../../../../CoreSDK/staticlib/sdl2/linux

popd

file /usr/lib/libsgsdl2.so

sudo ldconfig
