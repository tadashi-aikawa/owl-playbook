owl-playbook
============

WindowsとLinuxの環境構築用スクリプト群です。
自分向けに完全カスタマイズしています。

各種同期設定は **mnt配下** に集約されます。

サブモジュールを使用しているため`--recursive`オプションを付けてcloneしてください。

```
$ git clone git@github.com:tadashi-aikawa/owl-playbook.git --recursive
```


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
7. `windows\chocolatey\user-ConEmu.xml`を`mnt\windows\cmder\config`配下にコピー

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


### Boxの追加

`linux/lubuntu-base`をベースにして作成した`lubuntu-jp.box`を追加します。

```
$ vagrant box add "tadashi-aikawa/lubuntu-jp" lubuntu-jp.box
```

ベースイメージの作り方は以下を参考にしてください。

https://blog.mamansoft.net/2019/01/25/clean-ubuntu-infra/


### イメージの作成

`linux\lubuntu-jp`の中で以下コマンドを実行します。

```
$ vagrant up --provision
```


### 環境構築

まずはイメージにsshログインします。

```
$ vagrant ssh
# vagrant ssh-configの情報を~/.ssh/configに記載してもOK
```

Ansibleを実行して環境を構築します。

```
$ cd /mnt-ansible
$ make lubuntu-jp
```

TODO: 1度目の実行が必ずbash-language-serverで落ちるのを修正 (インストール後、.bashrcに書かれた環境変数が再設定されないため)

