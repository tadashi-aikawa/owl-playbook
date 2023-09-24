# owl-playbook

Windows と Linux の個人的な環境構築用スクリプト群です。

各種同期設定は **mnt 配下** に集約されます。

```console
git clone https://github.com/tadashi-aikawa/owl-playbook.git
```

## 💻 Windows setup

### 事前準備

以下のツールをインストールしてください。

1. [Scoop](https://github.com/lukesampson/scoop)
2. [PowerShell](https://github.com/PowerShell/PowerShell/releases) (v7 以降)

### 依存 package インストール

`windows`ディレクトリ配下の`install.ps1`を PowerShell で実行してください。

| ディレクトリ | 概要                         |
| ------------ | ---------------------------- |
| scoop        | Scoop でインストールするもの |
| npm          | npm でインストールするもの   |
| go           | go でインストールするもの    |

インストールパッケージに変更があったときは再実行しましょう。

### 各種設定の反映

#### 初回のみ

`IntelliJ IDEA`と`VS Code`は事前に 1 度起動しておいてください。
設定構成を作成するためです。

ライセンス認証も通しておいてください。

#### 設定反映

管理者モードで`provision.bat`を実行してください。

- [ ] `ps1`ファイルに置き換えたい

## 🐧 Linux setup

### 事前準備

VMを使う場合は[Multipass]などを使ってログインした状態から始めてください。

```console
multipass launch --name ubuntu-sandbox --cpus 2 --memory 4G --disk 10GB
multipass exec ubuntu-sandbox -- bash
```

```console
. ./linux/provision.sh
```

[Multipass]: https://multipass.run/
