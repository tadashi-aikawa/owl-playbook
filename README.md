owl-playbook
============

WindowsとLinuxの環境構築用スクリプト群です。
自分向けに完全カスタマイズしています。

各種同期設定は **mnt配下** に集約されます。


Windows setup
-------------

### 初回

初回だけいくつか準備が必要です。
2回目以降は必要ありません。

#### 必要なツールのインストール

1. [Chocolatey](https://chocolatey.org/)
2. [Scoop](https://github.com/lukesampson/scoop)

#### 依存packageインストール

1. 管理者モードでコマンドプロンプトを立ち上げて`owl-playbook\windows\chocolatey`ディレクトリに移動
2. `install.bat`を実行
3. `owl-playbook\windows\scoop`ディレクトリに移動
4. `install.bat`を実行
5. Intellij IDEAを立ち上げてライセンスを通す
6. VS Codeを起動する
7. `mnt\windows\cmder\config\user-ConEmu.xml`を別途用意する (TODO: symlinkしないところに用意してgit管理)

これで以降の構成管理に必要なツールおよび環境変数が設定されます。
5と6はsymbolic linkが参照するディレクトリ構成作成のために必要です。

#### `2回目以降`を実行

少し下のセクションに従って下さい。


#### 後処理

gowlを使ってowl-playbookを再取得しましょう。
今ある場所は初回だけで適切ではないため。


### 2回目以降

1. 管理者モードでCmderを立ち上げて`owl-playbook\windows`ディレクトリに移動
2. `provision.bat`を実行


Ubuntu simple setup
-------------------

### 前提

以下がインストールされていること

* [Vagrant](https://www.vagrantup.com/)
  * I use `2.1.2`
* [Virtualbox](https://www.virtualbox.org/)
  * I use `5.2.18 r124319`

本プロジェクトでWindowsのセットアップをしていればインストールされています。


### 実行

```
$ cd linux/ubuntu-simple
$ vagrant up --provision
$ vagrant ssh
$ sh /mnt/ubuntu-simple/user-provision.sh
```

`.bashrc`の最後に`. ~/.bashrc.org`を追加します。 (TODO: 冪等性を持つ仕組みを作りたい)
