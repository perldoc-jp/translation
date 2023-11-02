# 翻訳のチュートリアル

[翻訳作業の作法や手順はこちらに詳細なドキュメントがあります](https://perldoc.jp/manners) が、もっとざっくりしたチュートリアルがあってもいいかなということで、CPANモジュールのPODを翻訳する場合の作業内容をステップ・バイ・ステップで書きくだしてみたいと思います。

ちなみに、There's more than one way to do it. ということで、ステップごとにやり方は複数あります。ここに書いているのはあくまでひとつの例ということで、あらかじめご了承ください。

## 翻訳のターゲットを決める

さて、Perlモジュールの総本山といえば [meta::cpan](https://metacpan.org/)です。

今回は、[Feature::Compat::Class](https://metacpan.org/pod/Feature::Compat::Class) を翻訳したときの手順を紹介します。

## リポジトリをクローン

まず、[translation](https://github.com/perldoc-jp/translation) に行って、リポジトリをクローンします。

```
$ git clone git@github.com:perldoc-jp/translation.git
$ cd translation
```

以降の作業では、基本的にリポジトリのホームディレクトリにいる前提で説明をします。

## モジュールを手元にインストールする

まず、PODはモジュールの更新とあわせてどんどん編集されるので、オンラインのものを参照して翻訳していると途中から違うバージョンになっていたりして混乱してしまいます。そのような事態を避けるために、翻訳するモジュールは手元に持ってきます。

モジュールを手元に持ってくる方法はいくつかありますが、[cpanm](https://metacpan.org/dist/App-cpanminus/view/bin/cpanm) コマンドや [cpm](https://metacpan.org/dist/App-cpm/view/script/cpm) コマンドでサクッとインストールしてしまうのが簡単です。

```
$ cpanm -L local Feature::Compat::Class
```

上記のコマンドで、`local/lib/perl5/` ディレクトリに `Feature::Compat::Class` がインストールされているかと思います。

翻訳するPODが含まれる `.pm` ファイルの実パスは `local/lib/perl5/Feature/Compat/Class.pm` です。

translationリポジトリの `local` ディレクトリは .gitignore に記載されているのでモジュールを自由にインストールできます。

### POD を抜き出す

翻訳対象がファイル丸ごとPODの `.pod` ファイルの場合はそのままコピーすれば良いのですが、たいていの場合は `.pm` ファイルに含まれる POD を抜き出して翻訳します。今回もそのパターンです。

PODを抜き出すために `perldoc` コマンドを利用します。perldoc は Perlコアに含まれているのでみなさん実行可能ですね？

ちなみに、`cpanm -L local` したモジュールを `perldoc` で表示するには `PERL5LIB` 環境変数にパスを設定する必要があります。

```
$ PERL5LIB=local/lib/perl5 perldoc -u Feature::Compat::Class
```

perldoc の `-u` オプションは、PODをレンダリングせずに生で表示するオプションです。

さて、無事 POD が表示出来るのが確認できたら、翻訳作業ファイルとして書き出しましょう。今回のファイルパスは `docs/modules/Feature-Compat-Class-0.05/Class.pod` です。

```
$ PERL5LIB=local/lib/perl5 perldoc -u Feature::Compat::Class > docs/modules/Feature-Compat-Class-0.05/Class.pod
```

翻訳ファイルの配置ルールについては、こちらの [翻訳の作法](https://perldoc.jp/manners) に詳しいです。

### PODの初期状態でコミットする

pod を抜き出して配置したら、そこで一度コミットしてしまいましょう。

これは必須の作業ではありませんが、作業内容を明確にするために一度コミットしてしまうのをおすすめします。

## PODファイルの先頭に文字コード指定を追加する

翻訳作業では多くの場合 ASCII から日本語に変換することになるので、PODファイルの先頭に `=encoding utf8` を追加して文字コードが UTF-8 であることを宣言します。もちろん、日本語は UTF-8 で書きます。

### 不要な `=cut` を削除する

モジュールのPODから翻訳する場合、PODとソースコードを切り替えるために `=cut` が書かれていることがありますが、`.pod` ファイルとして翻訳する際はファイル全体がPODになるので `=cut` は不要です。一括で削除してしまいましょう。


## 翻訳対象を囲う

原文を残すために、翻訳対象となる原文を `=begin original` と `=end original` で囲んでいきます。

基本的にブロックごとに囲めばOKですが、コード部分やマークアップされる部分をどうするかなど細かい部分はこちらの [翻訳の作法](https://perldoc.jp/manners#code_translation) に詳しくあります。

一気に翻訳対象をブロックごとに囲んだら、再びコミットします。例えば、[こんな感じのコミット](https://github.com/perldoc-jp/translation/pull/16/commits/867ece182d5e37a856412ae496cd773f25df76ba) になります。

翻訳の都度、ブロックごとに囲みながら作業しても良いのですが、おそらく最初に一気にやってしまった方が翻訳作業に集中しやすいと思います。

## いよいよ翻訳

さて、ここまででやっと翻訳作業の事前準備が終わりました。

`=begin original` と `=end original` で囲んだブロックごとにどんどん翻訳していきましょう！

## 翻訳が終わったらPR作成

リポジトリに push する権限がなければ forkして PR を送るか、権限があればそのまま PR を作りましょう。

よしなにレビューリクエストもするといいと思います！

PRが整ったらいよいよマージです！おつかれさまでした！

## 参考PR

最後になりましたが、[Feature::Compat::Classを翻訳したときのPRはこちら](https://github.com/perldoc-jp/translation/pull/16) です。けしてきれいなPRではないですが、こんな感じで進むのねーというのを見てもらうのにいいかなと思います。

