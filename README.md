owl-playbook
============

WindowsとLinuxの環境構築用スクリプト群です。
自分向けに完全カスタマイズしています。

各種同期設定は **mnt配下** に集約されます。

```
$ git clone git@github.com:tadashi-aikawa/owl-playbook.git
```


Windows setup
-------------

### 事前準備

以下のツールをインストールしてください。

1. [Scoop](https://github.com/lukesampson/scoop)
2. [PowerShell](https://github.com/PowerShell/PowerShell/releases) (v7以降)

### 依存packageインストール

`windows`ディレクトリ配下の`install.ps1`をPowerShellで実行してください。

| ディレクトリ | 概要                        |
| ------------ | --------------------------- |
| scoop        | Scoopでインストールするもの |
| npm          | npmでインストールするもの   |
| go           | goでインストールするもの    |

インストールパッケージに変更があったときは再実行しましょう。

### 各種設定の反映

#### 初回のみ

`IntelliJ IDEA`と`VS Code`は事前に1度起動しておいてください。
設定構成を作成するためです。

ライセンス認証も通しておいてください。

#### 設定反映

管理者モードで`provision.bat`を実行してください。

- [ ] `ps1`ファイルに置き換えたい


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

