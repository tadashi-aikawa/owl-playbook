# owl-playbook

Windows と Linux の環境構築用スクリプト群です。
自分向けに完全カスタマイズしています。

各種同期設定は **mnt 配下** に集約されます。

```console
git clone git@github.com:tadashi-aikawa/owl-playbook.git
```

**⚠ 注意**

- 現在サポートしている Linux 環境は Ubuntu on WSL2 だけです
- ubuntu や lubuntu はサポートから外しました
  - 過去のコミットに情報は残っていますので必要あれば参考にしてください

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

## 🐧 Linux setup (WSL2)

Windows の Ubuntu on WSL2 にのみ対応しています。

### 事前準備

以下の記事などを参考に Ansible を実行するための環境構築をしてください。

- [WSL2 でつくる快適な Ubuntu 環境](https://blog.mamansoft.net/2020/07/02/efficient-wsl2-with-ubuntu/)
- [WSL2 でつくる快適な Ubuntu 環境 Ⅱ](https://blog.mamansoft.net/2020/07/26/efficient-wsl2-with-ubuntu2/)

### 環境構築

`linux/ansible/.secret/local.yaml`を作成してください

```yaml
ansible_become_pass: your_password
```

`linux/ansible`ディレクトリで以下コマンドを実行します。

```console
make wsl
```

以下の理由で一度失敗します

- npm に PATH が通っていない
- broot の初期設定ができていない

以下の方法で原因を解消します

- shell にログインしなおす
- `broot`コマンドを実行して`~/.config/broot`を作成する

もう一度実行すれば OK

```console
make wsl
```

bash-it のテーマを変更する場合は`.bashrc`の変更が必要です

```bash
export BASH_IT_THEME='maman'
```
