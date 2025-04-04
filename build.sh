#!/bin/bash

#This Build use:
# Bun.js to bundle and minify javascript (https://bun.sh/)
# tdewolff/minify to minify html, css and json (https://github.com/tdewolff/minify)

version="$1"

# 创建构建目录
if [[ ! -d "./extension" ]]; then
    mkdir ./extension
fi

# 复制图片资源
if [[ ! -d "./extension/images" ]]; then
    cp -dr ./src/images ./extension
fi

# 构建和压缩 JavaScript
bun build ./src/main.js --outdir ./extension --minify-whitespace
if [[ $? == 0 ]]; then
    echo JS build and minify
fi

# 复制其他文件
cp ./src/index.html ./extension/
cp ./src/style.css ./extension/
cp ./src/manifest.json ./extension/

minify --html-keep-end-tags -o ./extension/index.html ./src/index.html
if [[ $? == 0 ]]; then
    echo index.html minified success
fi

minify -o ./extension/style.css ./src/style.css
if [[ $? == 0 ]]; then
    echo index.css minified success
fi

minify -o ./extension/manifest.json ./src/manifest.json
if [[ $? == 0 ]]; then
    echo manifest.json minified success
fi

if [[ "$version" != "" ]]; then
    cd ./extension
    zip  "history-quick-view-v$version.zip" ./* ./images/*
    cd ../
    mv ./extension/"history-quick-view-v$version.zip" ./zips
fi
