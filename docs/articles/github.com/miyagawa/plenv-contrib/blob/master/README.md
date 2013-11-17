# plenv-contrib の翻訳

この文書は、[plenv-contrib の README](https://github.com/miyagawa/plenv-contrib/blob/master/README.md)を翻訳したものです。

## plenv-contrib

<!-- original
Add missing commands (for perlbrew users) to [plenv](https://github.com/tokuhirom/plenv)
-->

(perlbrew ユーザーのために)[plenv](https://github.com/tokuhirom/plenv) に存在しないコマンドを加えます。

<!-- original
## Install
-->

## インストール

```
git clone git://github.com/miyagawa/plenv-contrib.git ~/.plenv/plugins/plenv-contrib/
```

<!-- original
## Usage
-->

## 使い方

### exec-all

<!-- original
Runs specified command for all installed plenv versions, a la `perlbrew exec`.
-->

全てのインストールされた plenv バージョン用に特定のコマンドを実行します。`perlbrew exec` 風に。 

```
> plenv exec-all prove t/foo.t
```

### lib

<!-- original
Manages local::lib paths for each perl version.
-->

それぞれの perl のバージョン用に local::lib パスを管理します。

```
> plenv lib list
> plenv lib create chocolate
> plenv lib create 5.16.3@vanilla
> plenv lib delete chocolate
```

<!-- original
local::lib name is local to the current perl.
-->

local::lib の名前は現在の perl のローカルです。

### use

<!-- original
Launches a new shell with specified plenv version. Use the `@lib` syntax to specify the local::lib name created with `plenv lib`.
-->

特定の plenv バージョンと一緒に新しいシェルを立ち上げげます。 `@lib` シンタックスを使って、 `plenv lib` で作られた local::lib の名前を指定します。

```
> plenv use 5.18.0
> plenv lib create 5.16.3@nobita
> plenv use 5.16.3@nobita
```
