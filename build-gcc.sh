#!/bin/sh

# Variables for the build
export PREFIX="$HOME/opt/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"

# Variables for the script
BINUTILS_URL=https://ftp.gnu.org/gnu/binutils/binutils-2.31.tar.xz
GCC_URL=https://ftp.gnu.org/gnu/gcc/gcc-8.2.0/gcc-8.2.0.tar.xz

TMP_DIR=~/cross_tmp

# Can be c,c++
LANGS=c

CURRPWD=$PWD

if [ -d "$TMP_DIR" ]; then
    echo "::: '$TMP_DIR' already exists! Remove that before running this script."
    #exit 1
fi

mkdir $TMP_DIR
cd $TMP_DIR

echo "::: Downloading binutils from $BINUTILS_URL..."
wget $BINUTILS_URL -O binutils.tar.xz

echo "::: Downloading GCC from $GCC_URL"
wget $GCC_URL -O gcc.tar.xz

echo "::: Extracting archives (this might take a while!)..."
echo " :::: 1/2 binutils"
tar -xf binutils.tar.xz
echo " :::: 2/2 gcc"
tar -xf gcc.tar.xz

echo "::: Starting binutils build..."
mkdir binutils-build
cd binutils-build

../binutils-2.31/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make
make install

cd ..

echo "::: Starting GCC build..."
mkdir gcc-build
cd gcc-build

../gcc-8.2.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=$LANGS --without-headers
make all-gcc
make all-target-libgcc
make install-gcc
make install-target-libgcc

echo "::: Done!"

cd $CURRPWD
