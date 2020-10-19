owl-playbook
============

WindowsとLinuxの環境構築用スクリプト群です。
自分向けに完全カスタマイズしています。

各種同期設定は **mnt配下** に集約されます。

```
$ git clone git@github.com:tadashi-aikawa/owl-playbook.git
```

### 注意

* 現在サポートしているLinux環境はUbuntu on WSL2だけです
* ubuntuやlubuntuはサポートから外しました
    * 過去のコミットに情報は残っていますので必要あれば参考にしてください


💻 Windows setup
----------------

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


🐧 Linux setup (WSL2)
---------------------

WindowsのUbuntu on WSL2にのみ対応しています。

### 事前準備

以下の記事などを参考にAnsibleを実行するための環境構築をしてください。

* [WSL2でつくる快適なUbuntu環境](https://blog.mamansoft.net/2020/07/02/efficient-wsl2-with-ubuntu/)
* [WSL2でつくる快適なUbuntu環境Ⅱ](https://blog.mamansoft.net/2020/07/26/efficient-wsl2-with-ubuntu2/)

### 環境構築

`linux/ansible`ディレクトリで以下コマンドを実行します。

```
$ make wsl
```
