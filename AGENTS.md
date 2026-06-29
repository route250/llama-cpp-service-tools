# llama.cpp service tool

llama.cppの最新ソースからビルドしてサービスに登録するやつ

## directorys

以下のディレクトリで運用する

/usr/local/llama.cpp
   bin: llama.cppの実行バイナリへのシンボリックリンク
   llama-{os}-bXXXX-bin/ llama.cppの実行バイナリ。githubのtagがbXXXX
   llama-{os}-bYYYY-bin/ llama.cppの実行バイナリ。githubのtagがbYYYY
   service/llamacpp.service : サービスユニットファイル
   service/llamacpp-ctl.sh  : サービス起動停止用シェルスクリプト
   scripts/
      sync-to-last-tag.sh : build/llama.cppを最新tagにするスクリプト
      build.sh : ビルドするスクリプト
      install.sh : binのシンボリックリンクを最新にしてサービスインストールするスクリプト
      update.sh : syncしてbuildしてinstallするスクリプト
      utils.sh : 各スクリプトから sourceされる共通関数
   build/  : ビルド用 .gitignoreしておく
       llama.cpp : githubのリポジトリ
   dist/ : コンパイル結果置き場
       llama.cpp-{os}-bXXXX.tar.gz
       llama.cpp-{os}-bYYYY.tar.gz
    tmp/ .gitignoreしとく

### utils.sh
  - os名を取得(ubuntu22 ubuntu24 ubuntu26 or rhel8, rhel9)
  - gitコマンドチェック

### sync-to-last-tag.sh

  - gitコマンドチェック
  - build/llama.cppが存在してgitリポジトリじゃなかったら削除
  - build/llama.cppが存在してなかったらclone
  - gitのtagsから、b[0-9]+の最新を探す
  - リポジトリを tagsの最新にする

### build.sh

  - build/llama.cppでビルドする
  - ビルドしたら、llama-cliとllama-serverが実行できるかチェック
  - llama-cli --versionからバージョン b[0-9]+を取得
  - tmp/llama-bXXXX-binディレクトリを作成。存在してたら消して作り直し
  - 実行ファイルをtmp/llama-{os}-bXXXX-bin/にコピー
  - cd tmp; tar -zcf llama.cpp-{os}-bXXXX-bin.tar.gz
  - llama.cpp-{os}-bXXXX-bin.tar.gzをdistに移動
  - tmp/llama-bXXXX-binディレクトリを削除

### install.sh

  - distから、{os}に合致する最新版のtar.gzを取得
  - /usr/local/llama.cppに展開
  - sudo systemctl stop llamacpp
  - binのシンボリックリンクを作り直し
  - sudo mkdir -p /usr/local/lib/systemc/system
  - sudo service/llamacpp.serviceを/usr/local/lib/systemc/systemにシンボリックリンク
  - sudo systemctl reload-daemon
  - sudo systemctl enable --now llamacpp
  - sudo systemctl status llamacpp


### update.sh
   sync, build, installをじゅんに呼び出す
