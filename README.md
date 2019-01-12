owl-playbook
============

WindowsとLinuxの環境構築用スクリプト群です。

自分向けに完全カスタマイズしています。


Windows setup
-------------

### 準備

初回だけいくつか準備が必要です。

#### 必要なツールのインストール

1. [Chocolatey](https://chocolatey.org/)
2. [Scoop](https://github.com/lukesampson/scoop)

#### 依存packageインストール

1. 管理者モードでコマンドプロンプトを立ち上げて`owl-playbook\windows\chocolatey`ディレクトリに移動
2. `install.bat`を実行


### 使い方

初回以降に構成を変更した場合はこの手順です。

1. 管理者モードでCmderを立ち上げて`owl-playbook\windows`ディレクトリに移動
2. `provision.bat`を実行


Ubuntu setup
------------

### Requirements

* [Vagrant](https://www.vagrantup.com/)
  * I use `2.1.2`
* [Virtualbox](https://www.virtualbox.org/)
  * I use `5.2.18 r124319`

You can install above tools by `provision.bat`.

### Provisioning VM (Only once)

```
$ cd vagrant/ubuntu-gui
$ vagrant up --provision
```

### Usage

```
$ make-run-???
```

