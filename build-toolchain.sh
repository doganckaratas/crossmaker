#!/bin/sh

JOB_COUNT=7
BINUTILS_VERSION="2.31"
GCC_VERSION="8.5.0"
export PREFIX="$PWD/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"

wget https://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VERSION}.tar.gz
wget https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz

cd ~

mkdir .binutils-build
mkdir .gcc-build

tar xvf binutils*
cd .binutils-build
../binutils-${BINUTILS_VERSION}/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make -j7
make install
cd ..

tar xvf gcc*
cd .binutils-build
../gcc-${GCC_VERSION}/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc -j${JOB_COUNT}
make all-target-libgcc -j${JOB_COUNT}
make install-gcc
make install-target-libgcc
cd ..

tar zcvf ${TARGET}-cross.tar.gz cross
rm -rf *binutils* *gcc*
