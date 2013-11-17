# plenv の翻訳

この文書は、[plenv の README](http://github.com/tokuhirom/plenv/blob/master/README.md)を翻訳したものです。

# NAME

<!-- original
plenv - perl binary manager
-->

plenv - perl バイナリマネージャー

# SYNOPSIS

    plenv help

    # list available perl versions
    plenv install --list

    # install perl5 binary
    plenv install 5.16.2 -Dusethreads

    # execute command on current perl
    plenv exec ack

    # change global default perl to 5.16.2
    plenv global 5.16.2

    # change local perl to 5.14.0
    plenv local 5.14.0

    # run this command after install cpan module, contains executable script.
    plenv rehash

    # install cpanm to current perl
    plenv install-cpanm

    # migrate modules(install all installed modules for 5.8.9 to 5.16.2 environment.)
    plenv migrate-modules 5.8.9 5.16.2

    # locate a program file in the plenv's path
    plenv which cpanm

    # display version
    plenv --version

<!-- original
# DESCRIPTION
-->
# 概要

<!-- original

Use plenv to pick a Perl version for your application and guarantee
that your development environment matches production. Put plenv to work
with [Carton](http://github.com/miyagawa/carton/) for painless Perl upgrades and bulletproof deployments.
-->

plenv を使って アプリケーション用のPerlのバージョンを選び、 開発環境と
プロダクションが一致するようにします。痛みのない Perl のアップグレードと防弾のデプロイメントのために、
[Carton](http://github.com/miyagawa/carton/) と一緒に plenv を置きましょう。

# plenv vs. perlbrew

<!-- original
Like perlbrew, plenv installs perls under your home directory and lets you install modules locally, and allows you to switch to arbitrary perl versions on your shell.
-->

perlbrew のように、plenve は ホームディレクトリ以下に 複数のperl をインストールし、モジュールをローカルにインストールします。そして、シェルで任意のPerlのバージョンに切り替えて使えます。

<!-- original
Unlike perlbrew, plenv is implemented in bash, and provides simple shell script wrappers (called "shims") for each perl executable files. It doesn't export any shell functions that switches `PATH` before running commands.
-->

perlbrew と違って、plenv は、bash に実装されます。それぞれの perl の実行ファイル用に("shims" とよばれる)単純なシェルスクリプトラッパーを提供します。コマンドを実行する前に `PATH` を変更するような、どのようなシェル関数もエクスポートしません。

<!-- original
Unlike perlbrew, plenv allows you to set local perl version per directory, using `.perl-version` file.
-->
perlbrew と違い、plevn は、ディレクトリ毎に、ローカルの perl のバージョンをセットできます。`.perl-version` ファイルを使います。

<!-- original
Unlike perlbrew, plenv doesn't provide built-in local::lib integrations, but [plenv-contrib](https://github.com/miyagawa/plenv-contrib) implements `use` and `lib` commands for a replacement.
-->

perlbrew と違って、plenv は、ビルトインの local::lib インテグレーションを提供しません。ですが、[plenv-contrib](https://github.com/miyagawa/plenv-contrib) が、 その代わりに、`use` と `lib` コマンドを実装します。

<!-- original
## INSTALLATION
-->

## インストール

<!-- original
**Compatibility note**: plenv is _incompatible_ with perlbrew. Please make
  sure to fully uninstall perlbrew and remove any references to it from
  your shell initialization files before installing plenv.
-->

**互換性の注意**: plenv は perlbrew と _非互換_ です。 plenvをインストールする前に
  perlbrew を完全にアンストールし、シェルの初期化ファイルから
  perlbrewに関連するものをすべて削除してください。

<!-- original
If you're on Mac OS X, consider
[installing with Homebrew](#homebrew-on-mac-os-x).
-->

Mac OS X 上で plenv を動かす場合、
[Homebrew で インストール](#homebrew-on-mac-os-x)することを考慮してください。

<!-- original
### Basic GitHub Checkout
-->
### 基本の Github チェックアウト

<!-- original
This will get you going with the latest version of plenv and make it
easy to fork and contribute any changes back upstream.
-->

最新バージョンの plenv を使い、簡単にフォークでき、どのような変更も
アップストリームに貢献するのが簡単になります。

<!-- original
1. Check out plenv into `~/.plenv`.

2. Add `~/.plenv/bin` to your `$PATH` for access to the `plenv`
   command-line utility.

    ~~~ sh
    $ echo 'export PATH="$HOME/.plenv/bin:$PATH"' >> ~/.bash_profile
    ~~~
    
    **Ubuntu note**: Modify your `~/.profile` instead of `~/.bash_profile`.

    **Zsh note**: Modify your `~/.zshrc` file instead of `~/.bash_profile`.

3. Add `plenv init` to your shell to enable shims and autocompletion.

    ~~~ sh
    $ echo 'eval "$(plenv init -)"' >> ~/.bash_profile
    ~~~

    _Same as in previous step, use `~/.profile` on Ubuntu, `~/.zshrc` for Zsh._

4. Restart your shell as a login shell so the path changes take effect.
    You can now begin using plenv.

    ~~~ sh
    $ exec $SHELL -l
    ~~~

5. Install [perl-build](https://github.com/tokuhirom/perl-build),
   which provides an `plenv install` command that simplifies the
   process of installing new Perl versions.

    ~~~
    $ git clone git://github.com/tokuhirom/Perl-Build.git ~/.plenv/plugins/perl-build/
    $ plenv install 5.18.0
    ~~~

   As an alternative, you can download and compile Perl yourself into
   `~/.plenv/versions/`.

6. Rebuild the shim executables. You should do this any time you
   install a new Perl executable (for example, when installing a new
   Perl version, or when installing a cpanm that provides a command).

    ~~~
    $ plenv rehash
    ~~~

-->

1. plenv を `~/.plenv` にチェックアウトします。

    ~~~ sh
    $ git clone git://github.com/tokuhirom/plenv.git ~/.plenv
    ~~~

2. `~/.plenv/bin` を `$PATH` に追加して、`plenv` コマンドラインユーティリティに
   アクセス出来るようにします。

    ~~~ sh
    $ echo 'export PATH="$HOME/.plenv/bin:$PATH"' >> ~/.bash_profile
    ~~~

    **Ubuntu 用メモ**: `~/.bash_profile` の代わりに `~/.profile` を変更してください。

    **Zsh 用メモ**: `~/.bash_profile` の代わりに `~/.zshrc` ファイルを変更してください。

3. shims と自動補完を有効にするために `plenv init` をシェル に追加します。

    ~~~ sh
    $ echo 'eval "$(plenv init -)"' >> ~/.bash_profile
    ~~~

    _前のステップ同様、Ubuntu では、`~/.profile`、Zsh では、`~/.zshrc`を使ってください。_

4. ログインシェルをリスタートすると、パスの変更が有効になります。
    これで、plenv を使い始められます。

    ~~~ sh
    $ exec $SHELL -l
    ~~~

5. [perl-build](https://github.com/tokuhirom/perl-build) をインストールします。
   新しい Perl のバージョンをインストールするプロセスを簡略した
   `plenv install` コマンドを提供します。

    ~~~
    $ git clone git://github.com/tokuhirom/Perl-Build.git ~/.plenv/plugins/perl-build/
    $ plenv install 5.18.0
    ~~~

   代替として、~/.plenv/versions/ に、 自分で Perl をダウンロードして、
   コンパイルすることもできます。

6. shim 実行ファイルをリビルドします。新しい Perl の実行ファイルを
   インストールした時にはいつでも、これをするべきです。
   (例えば、新しいPerlのバージョンをインストールした時、または、
   コマンドを提供するcpanm をインストールした時)

    ~~~
    $ plenv rehash
    ~~~

<!-- original
#### Upgrading
-->

#### アップグレード

<!-- original
If you've installed plenv manually using git, you can upgrade your
installation to the cutting-edge version at any time.
-->

plenv を git を使って手でインストールしているなら、最先端のバージョンに
いつでもいアップグレードできます。

~~~ sh
$ cd ~/.plenv
$ git pull
~~~

<!-- original
To use a specific release of plenv, check out the corresponding tag:
-->
plenv の特定のリリースを使いたいなら、一致するタグをチェックアウトします:

~~~ sh
$ cd ~/.plenv
$ git fetch
$ git checkout 2.0.0
~~~

<!-- original
### Homebrew on Mac OS X
-->

### Mac OS X で Homebrew 

<!-- original
You can also install plenv using the
[Homebrew](http://mxcl.github.com/homebrew/) package manager on Mac OS
X.
-->

Mac OS X では、plenv を [Homebrew](http://mxcl.github.com/homebrew/) 
パッケージマネージャを使ってインストールすることもできます。

~~~
$ brew update
$ brew install plenv
$ brew install perl-build
~~~

<!-- original
To later update these installs, use `upgrade` instead of `install`.
-->

後で、これらのインストールをアップデートする場合、 `install` の代わりに、`upgrade` を使います。

<!-- original
Afterwards you'll still need to add `eval "$(plenv init -)"` to your
profile as stated in the caveats. You'll only ever have to do this
once.
-->

その後、警告があるなら、自分の profile に、`eval "$(plenv init -)"` を
追加する必要があるでしょう。これは一回のみ必要です。

<!-- original
### Neckbeard Configuration
-->

### Neckbeard 設定

<!-- original
Skip this section unless you must know what every line in your shell
profile is doing.
-->

shell の profile の各行が何をしているかを知りたくなければ、このセクションは
飛ばしてください。

<!-- original
`plenv init` is the only command that crosses the line of loading
extra commands into your shell. Here's what `plenv init` actually does:
-->

`plenv init` はシェルに特別なコマンドをロードする行を埋め込む唯一のコマンドです。
`plenv init` は、実際には次のことをします。


<!-- original

1. Sets up your shims path. This is the only requirement for plenv to
   function properly. You can do this by hand by prepending
   `~/.plenv/shims` to your `$PATH`.

2. Installs autocompletion. This is entirely optional but pretty
   useful. Sourcing `~/.plenv/completions/plenv.bash` will set that
   up. There is also a `~/.plenv/completions/plenv.zsh` for Zsh
   users.

3. Rehashes shims. From time to time you'll need to rebuild your
   shim files. Doing this automatically makes sure everything is up to
   date. You can always run `plenv rehash` manually.

4. Installs the sh dispatcher. This bit is also optional, but allows
   plenv and plugins to change variables in your current shell, making
   commands like `plenv shell` possible. The sh dispatcher doesn't do
   anything crazy like override `cd` or hack your shell prompt, but if
   for some reason you need `plenv` to be a real script rather than a
   shell function, you can safely skip it.

-->


1. shims パスをセットアップします。plevn を適切に関数にするのに必要なだけです。
   手でするには、`$PATH`の先頭に`~/.plenv/shims`を追加してください。

2. 自動補完をインストールします。これは完全にオプションですが、非常に便利です。
   `~/.plenv/completions/plenv.bash`　を実行することで、セットアップされます。
   Zsh ユーザー用にも、`~/.plenv/completions/plenv.zsh` があります。

3. shims をrehashします。その時々で、shim ファイルをリビルドする必要があります。
   これにより、自動的に全てが確実に最新になります。手で行うなら、`plenv rehash` 
   を走らせることができます。

4. sh ディスパッチャをインストールします。この小さいものはオプションです。ですが、
   plenv と プラグインが、現在のシェルの変数を変更するのを許します。
   `plenv shell`のようなコマンドを可能にします。 sh ディスパッチャは
   `cd` をオーバーライドするようなクレイジーなことを何もしませんし、シェルの
   プロンプトをハックすることもしません。何らかの理由で、`plenv`をシェル関数ではなく、
   実際のスクリプトとして必要ならば、安全にこれをスキップできます。


<!-- original
Run `plenv init -` for yourself to see exactly what happens under the
hood.
-->

`plenv init -` を実行すると、フードの下で実際に何が行われてるかを見ることが
できます。

<!-- original
# DEPENDENCIES
-->

# 依存

    * Perl 5.8.1+
    * bash
    * curl(If you want to use plenv install-cpanm)

<!-- original
## Command Reference
-->

## コマンドリファレンス

<!-- original
Like `git`, the `plenv` command delegates to subcommands based on its
first argument. The most common subcommands are:
-->

`git`のように、`plenv` コマンドは第一引数でサブコマンドにデリゲートします。
最も一般的なサブコマンドは:

### plenv local

<!-- original
Sets a local application-specific perl version by writing the version
name to a `.perl-version` file in the current directory. This version
overrides the global version, and can be overridden itself by setting
the `PLENV_VERSION` environment variable or with the `plenv shell`
command.
-->

カレントディレクトリの `.perl-version` ファイルでローカルアプリケーション
指定のperlのバージョンをセットします。このバージョンはグローバルのバージョン
を上書きします。`PLENV_VERSION`環境変数をセットし、 `plenv shell`コマンド
を使うことで、それ自身を上書きできます。

    $ plenv local 5.8.2

<!-- original
When run without a version number, `plenv local` reports the currently
configured local version. You can also unset the local version:
-->

バージョン番号無しで実行すると、`plenv local` は現在の設定された
ローカルのバージョンを報告します。localのバージョン指定を外すこともできます:

    $ plenv local --unset

<!-- original
Previous versions of plenv stored local version specifications in a
file named `.plenv-version`. For backwards compatibility, plenv will
read a local version specified in an `.plenv-version` file, but a
`.perl-version` file in the same directory will take precedence.
-->

前のバージョンの plenv は ローカルバージョンの指定を`.plenv-version`
という名前のファイルに保存していました。後方互換のために、plenv は
`.plenv-version` に指定されたローカルのバージョンを読みますが、
同じディレクトリにある`.perl-version` ファイルがあれば、優先されます。

### plenv global

<!-- original
Sets the global version of perl to be used in all shells by writing
the version name to the `~/.plenv/version` file. This version can be
overridden by an application-specific `.perl-version` file, or by
setting the `PLENV_VERSION` environment variable.
-->

`~/.plenv/version` ファイルにバージョン名を書いて、全てのシェルが使う
グローバルの perl のバージョンをセットします。このバージョンは、
アプリーケーション指定の `.perl-version` ファイルか、
 `plenv_VERSION` 環境変数で、オーバーライドできます。

    $ plenv global 5.8.2


<!-- original
The special version name `system` tells plenv to use the system perl
(detected by searching your `$PATH`).
-->

特別なバージョンの名前である `system` は、システムの perl を使うように
plenv に教えます(`$PATH` を検索して見つけます)。

<!-- original
When run without a version number, `plenv global` reports the
currently configured global version.
-->

バージョン番号無しで実行すると、`plenv global` は、現在設定されている
グローバルのバージョンを報告します。

### plenv shell

<!-- original
Sets a shell-specific perl version by setting the `plenv_VERSION`
environment variable in your shell. This version overrides
application-specific versions and the global version.
-->

shell 指定の perl のバージョンを `plenv_VERSION` を設定することで
シェルにセットできます。アプリケーション指定のバージョンとグローバルの
バージョンを上書きします。

    $ plenv shell 5.8.2

<!-- original
When run without a version number, `plenv shell` reports the current
value of `plenv_VERSION`. You can also unset the shell version:
-->

バージョン番号なしで実行すると、`plenv shell` は、現在の `plenv_VERSION`
の値を報告します。シェルのバージョンを外すこともできます:

    $ plenv shell --unset

<!-- original
Note that you'll need plenv's shell integration enabled (step 3 of
the installation instructions) in order to use this command. If you
prefer not to use shell integration, you may simply set the
`PLENV_VERSION` variable yourself:
-->

このコマンドを使うためには、plenv のシェル組み込みを有効にしている必要
があることに注意してください(インストール指示のステップ3)。
シェル組み込みを使いたくなければ、単純に `PLENV_VERSIIN` 変数を
自分でセットすれば良いです:


    $ export PLENV_VERSION=5.8.2

### plenv versions

<!-- original
Lists all perl versions known to plenv, and shows an asterisk next to
the currently active version.
-->

plenvに知られている、全ての perl のバージョンをリストし、現在のアクティブな
バージョンをアスタリスクで示します。

    $ plenv versions
      system
      5.12.0
      5.14.0
      5.16.1
      5.16.2
      5.17.11
      5.17.7
      5.17.8
      5.18.0
      5.18.0-RC3
      5.18.0-RC4
    * 5.19.0 (set by /home/tokuhirom/.plenv/version)
      5.6.2
      5.8.1
      5.8.2
      5.8.3
      5.8.5
      5.8.9

### plenv version

<!-- original
Displays the currently active perl version, along with information on
how it was set.
-->

現在のアクティブなバージョンを表示します。どのようにセットしたかによります。

    $ plenv version
    5.19.0 (set by /home/tokuhirom/.plenv/version)

### plenv rehash

<!-- original
Installs shims for all perl executables known to plenv (i.e.,
`~/.plenv/versions/*/bin/*`). Run this command after you install a new
version of perl, or install a cpanm that provides commands.
-->

全ての perl の実行ファイル用(つまり、`~/.plenv/versions/*/bin/*`)に、
shims をインストールします. 新しいバージョンの perl を
インストールした後に、このコマンドを実行してください。
または、コマンドを提供する cpanm をインストールします。

    $ plenv rehash

### plenv which

<!-- original
Displays the full path to the executable that plenv will invoke when
you run the given command.
-->

与えられたコマンドを実行するときに、plenv が呼び出す
実行ファイルのフルパスを表示します。

    $ plenv which cpanm
    /home/tokuhirom/.plenv/versions/5.19.0/bin/cpanm

### plenv whence

<!-- original
Lists all perl versions with the given command installed.
-->

与えられたコマンドがインストールされている全ての perl の バージョンをリストします。

    $ plenv whence plackup
    5.17.11
    5.17.7
    5.18.0
    5.18.0-RC4
    5.19.0

# FAQ

<!-- original

- How can I install cpanm?

    Try to use following command.

        % plenv install-cpanm

    This command install cpanm to current environment.

    - What should I do for installing the module which I used for new Perl until now? 
    You can use ` migrate-modules ` subcommand.

        % plenv migrate-modules 5.8.2 5.16.2

    It make a list of installed modules in 5.8.2, and install the newest versions of these modules
    to 5.16.2 environment. Note that because the module version won't necessarily be the same between
    the two versions, there maybe changes that affect compatibility, dependencies or other behaviors
    your applications depend on.

    You can reuse installed modules from a binary-compatible perl version
    directly without reinstalling. For example, if you have installed lots of
    modules in 5.18.1 and install a variant of 5.18.1 with dtrace support,
    you might not want to migrate all those modules.

- How can I enable -g option without slowing down binary?

    Use following command.

        % plenv install 5.16.2 -DDEBUGGING=-g

-->

- どのように cpanm をインストールできますか?

    次のコマンドを使ってください。

       % plenv install-cpanm

    このコマンドは cpanm を現在の環境にインストールします。

    - 新しい Perl のために、今まで使っていたモジュールをインストールするにはどうするべきですか？

        % plenv migrate-modules 5.8.2 5.16.2

    5.8.2 にインストールされているモジュールのリストを作り、これらのモジュールの最新のバージョンを
    5.16.2 の環境へインストールします。2つのバージョンの間でモジュールのバージョンが必ずしも
    同じではないので、互換性か依存かアプリケーションが依存する他の振る舞いに影響がある変更があるかもしれません。

    バイナリ互換性のある perl バージョンからインストールされたモジュールを、再インストールなしに、
    直接再利用することができます。例えば、5.18.1 でたくさんのモジュールをインストールしていて、
    dtrace をサポートする別の 5.18.1  をインストールする場合、全てのこれらのモジュールを
    移植したくないでしょう。

        % plenv install 5.18.1 -Dusedtrace --as 5.18.1-dtrace
        % plenv shell 5.18.1-dtrace
        % PERL5LIB=$(PLENV_VERSION=5.18.1 perl -e'print join ":",@INC') perl <command>


- どうすれば、バイナリの速度を落とさずに、 -g  オプションを有効に出来ますか？

    次のコマンドを使ってください。

        % plenv install 5.16.2 -DDEBUGGING=-g

<!-- original
# BUG REPORTING
-->
# バグレポート

Plese use github issues: [http://github.com/tokuhirom/plenv/](http://github.com/tokuhirom/plenv/).

<!-- original
# AUTHOR
-->
# 著者

Tokuhiro Matsuno <tokuhirom AAJKLFJEF@ GMAIL COM>

# SEE ALSO

[App::perlbrew](http://search.cpan.org/perldoc?App::perlbrew) provides same feature. But plenv provides project local file: __ .perl-version __.

Most of part was inspired from [rbenv](https://github.com/sstephenson/rbenv).

<!-- original
# LICENSE
-->
# ライセンス

<!-- original
## plenv itself
-->
## plenv 自身

Copyright (C) Tokuhiro Matsuno

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

## rbenv

<!-- original
plenv uses rbenv code
-->

plenv は rbenv のコードを使っています。

    (The MIT license)

    Copyright (c) 2013 Sam Stephenson

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
