#!/bin/bash
SrcRepo="https://github.com/ggml-org/llama.cpp.git"
ScrDir="$(cd $(dirname $0);pwd)"
PrjDir="$(cd $(dirname $0)/..;pwd)"
BuildDir="$PrjDir/build"
SrcDir="$BuildDir/llama.cpp"
DistDir="$PrjDir/dist"

mkdir -p "$DistDir" "$BuildDir"

# SrcRepoをcloneする
if [ ! -d "$SrcDir/.git" ]; then
    if [ -e "$SrcDir" ]; then
        echo "INFO: remove $SrcDir"
        rm -rf "$SrcDir"
    fi
    # SrcDirが存在しなかったらclone
    echo "INFO: git clone $SrcRepo"
    (cd "$BuildDir"; git clone $SrcRepo)
    if [ ! -d "$SrcDir/.git" ]; then
        echo "ERROR: can not clone repository of llama.cpp"
        exit 1
    fi
else
    echo "INFO: git pull $SrcDir"
fi


cd "$SrcDir"

CurrentBranch="$(git status | awk '/On branch/{print $3}')"
if [ -n "$CurrentBranch" ]; then
    echo "INFO: CurrentBranch $CurrentBranch"
else
    echo "ERROR: can not get CurrentBranch"
    exit 1
fi

Tag=$(git ls-remote --tags origin 'refs/tags/b*' | sed 's|.*/||' | sort -V | tail -1)

if [ -n "$Tag" ]; then
    BranchName=branch-$Tag
    echo "INFO: Branch $BranchName"
else
    BranchName=""
    echo "ERROR: can not found tag?"
    exit 1
fi

if [ "$BranchName" == "$CurrentBranch" ]; then
    echo "INFO: no need update"
    exit 0
fi

git fetch --tags origin
if git show-ref --verify --quiet "refs/heads/$BranchName"; then
    git switch "$BranchName"
    git reset --hard "$Tag"
else
    git switch -c "$BranchName" "$Tag"
fi
ActualTag="$(git describe --tags --always)"
if [ "$ActualTag" != "$Tag" ]; then
    echo "ERROR: expected $Tag but current is $ActualTag"
    exit 1
fi

echo "***END*** $Tag"
exit 0