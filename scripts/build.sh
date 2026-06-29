#!/bin/bash
SrcRepo="https://github.com/ggml-org/llama.cpp.git"
ScrDir="$(cd $(dirname $0);pwd)"
PrjDir="$(cd $(dirname $0)/..;pwd)"
BuildDir="$PrjDir/build"
SrcDir="$BuildDir/llama.cpp"
DistDir="$PrjDir/dist"
WorkDir="$PrjDir/tmp"

mkdir -p "$DistDir" "$BuildDir"

# SrcRepoをcloneする
if [ ! -d "$SrcDir/.git" ]; then
    echo "ERROR: can not clone repository of llama.cpp"
    exit 1
fi

cd "$SrcDir"

Tag="$(git describe --tags --always)"

if [[ ! $Tag =~ ^b[0-9]+$ ]]; then
    echo "ERROR: can not detect version $Tag"
    exit 1
fi

echo "INFO: build $Tag"

BuildName=build-$Tag
rm -rf "$BuildName"
cmake -B $BuildName -DBUILD_SHARED_LIBS=OFF
cmake --build $BuildName --config Release -j

if [ ! -x "$BuildName/bin/llama-cli" ]; then
    echo "ERROR: can not found executable llama-cli?"
    exit 1
fi

PkgDir="llama-${Tag}-bin"
DistTGZ="$DistDir/llama-${Tag}-bin-rhel-cpu.tar.gz"
mkdir -p "$WorkDir"
rm -rf "$WorkDir/$PkgDir"
cp -pr "$BuildName/bin" "$WorkDir/$PkgDir"
(cd "$WorkDir" && tar -zcf "$DistTGZ" $PkgDir)
rm -rf "$WorkDir/$PkgDir"
