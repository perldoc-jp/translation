# 翻訳の作法

Perlのドキュメントを翻訳する上での留意事項を書いています。翻訳したい方は、一度目を通していただけると良いかと思います。

## ディレクトリ構成

翻訳する種別によって、翻訳データを置く場所が異なります。次のルールに従って配置してください。

### perlのコアドキュメントの場合

    docs/perl/バージョン/ファイル名.pod

    e.g.
    docs/perl/5.38.0/perl.pod
    docs/perl/5.36.0/perl5360delta.pod

### モジュールの場合

    docs/modules/モジュール名-バージョン/

    e.g.
    docs/modules/Acme-Bleach-1.12/Bleach.pod
    docs/modules/Furl-0.24/lib/Furl.pod

### その他の場合

    docs/articles/perl/名前.pod
    docs/articles/ドメイン/パス/ファイル名.html
    docs/articles/ドメイン/パス/ファイル名.md

    e.g.
    docs/articles/github.com/Perl/PPCs/ppcs/ppc0004-defer-block.md
    docs/articles/github.com/miyagawa/plenv-contrib/blob/master/README.md

ファイル拡張子は、pod / html / md いずれでも構いません。

## 文字コード

やむをえない事情がない限りは 文字コードはutf-8にしてください。
pod ファイルの先頭で、以下のように、encoding を指定します。

    https://github.com/perldoc-jp/translation/blob/46f76c1e285d7bc046baa20b3292a5da93402c5f/docs/perl/5.38.0/perl.pod?plain=1#L1-L3

## 翻訳文の行数

英語の文章の順番と日本語の文章の順番は違いますが、行数はある程度合わせた方が良いです。
英語が数行にわたって書かれている場合、日本語訳も数行に分けて書いたほうが良いです。

    Similar to C<%+>, this variable allows access to the named capture buffers
    in the last successful match in the currently active dynamic scope. To
    each capture buffer name found in the regular expression, it associates a
    reference to an array containing the list of values captured by all
    buffers with that name (should there be several of them), in the order
    where they appear.

原文が上記のようであれば、(行数が違いますが)以下のように複数行で書きます。

    C&lt;%+&gt; と同様、この変数は現在アクティブな動的スコープで最後に成功した
    マッチングの名前付き捕捉バッファへのアクセスを可能にします。
    正規表現中に捕捉バッファ名が現れるごとに、その名前のバッファ全てで
    (複数あるでしょう)捕捉されている値のリストを出現順で含む配列への
    リファレンスと関連付けられます。

翻訳文をバージョンアップした際に、diff を見てチェックする場合などがありますが、その際に一行にまとめていると diff が見辛くなります。

## 原文の残し方

ファイル内に原文を残す場合は、

    =begin original

    perl - The Perl 5 language interpreter

    =end original

のように、`=begin original`と`=end original`で原文を囲みます。

HTMLの場合は、原文がかこまれているタグのクラス名を original としてください。

    <code>
     <h1 class="original">Learn Perl in about 2 hours 30 minutes</h1>
     <h1>2時間半で学ぶPerl</h1>
    </code>

=head を訳す場合は、=head の次に( )で翻訳文を入れてください。ただし、`=head NAME`は、そのままにしてください。

    =head Version Ranges

    (バージョンの範囲)

## コード部分の翻訳

コード部分は訳さずそのまま残しておいた方が良いです。<br />
下記のコード部分ですが、これらは、originalには含みません。<br />
※ただし、コード部分のコメントを翻訳し、原文を残したい場合は、originalブロックに含めても構いません(が、コメント部分くらいであれば、オリジナルを残さなくても良いかと思います)。

    =head1 SYNOPSIS

    =begin original

    The following is example of usage of Hoge.
    Example1:

    =end original

    Hogeの使い方の例です。
    例1:

         $hoge = Hoge->new;
         $hoge->foo;


## headの翻訳

NAME, SYNOPSYS, DESCRIPTION などですが、代表的なものは、perldoc.jpでは、自動的に翻訳されて表示されます。
翻訳される場合原文をそのままにして、下に（）で書いてください。
perldoc.jp では、表示時に()部分を=headの英文と置き換えています。
※ただし、`=head1 NAME`はPODのパーサーに取って重要なものとなりますので、こちらのみ訳さずにそのままにして、()も書かないでください。

    =head1 NAME

    =begin original

    GreatModule - great module

    =end original

    GreatModule - 偉大なモジュール

    =head1 STRUCTURE

    (構造)

    =head2 OPTIONAL FIELDS

    (オプションのフィールド)

以下の代表的なものは、perldoc.jpでは日本語に置換されて表示されます。

| NAME                  | 名前                  |
| --------------------- | --------------------- |
| SYNOPSIS              | 概要                  |
| DESCRIPTION           | 説明                  |
| OPTIONS               | オプション            |
| METDODS               | メソッド              |
| FUNCTIONS             | 関数                  |
| EXAMPLE               | 例                    |
| AUTDOR                | 作者                  |
| COPYRIGHT & LICENSE   | コピーライト & ライセンス |
| BUGS                  | バグ                  |
| CAUTION               | 警告                  |
| ACKNOWLEDGEMENTS      | 謝辞                  |
| SUPPORT               | サポート              |

## L&lt;...&gt;の翻訳

<i>L&lt;/STRUCTURE&gt;</i> のような POD内リンクについては、perldoc.jp では英語のままでも、英語を翻訳しても、いずれでも正しい場所へリンクされます。
ただし、<i>L&lt;CPAN::Meta::Spec/optional_features&gt;</i> のような同じ文書内に含まれないリンクに関しては翻訳されると正しい場所にリンクできなくなります。
※他のPOD表示ツールで日本語に翻訳されたリンクが正しく動くかはわかりません(たぶん、動きません)。

## =itemの翻訳

=item を =begin original 〜 =end original で囲むと、PODのパースに失敗する場合があります。以下のように回避できます。

(a) =item の下に ()で訳文を入れて、回避する

=head1と同様に、()で訳文を入れる方法です。

    =over 8

    =item test

    (テスト)

(b) =over 〜 =back までをすべて =begin original 〜 =end original で囲ってしまって回避する

=over 〜 =back までの量が少ないのであれば、 =begin original 〜 =end original で全体を囲ってしまっても良いでしょう。


    =begin original

    =over 8

    =item test

    original sentence.

    original sentence.

    =back

    =end original

    =over 8

    =item テスト

    翻訳文章

    =item テスト2

    翻訳文章

    =back

## 連絡先の記述

連絡先を書く場合は、翻訳文の最後に以下のように付記すると良いでしょう(特に決まりはありません)。

    =head1 翻訳について

    翻訳者：名前 (account@example.com)

翻訳リポジトリの場所や、翻訳プロジェクトの名前やURL、誤訳の報告先などを書き足しても良いかと思います。

---

## HTML形式の翻訳についての特別な処理

perldoc.jpでは、HTML形式の翻訳の場合、以下の処理を行っています。

### 1. タイトル/概要の抜き出し

タイトルは、titleタグから、タイトルタグがない場合は、最初のh1タグから取得します。<br />
概要は、meta タグで description が指定されてあれば、そちらを使用します。

### 2. JavaScript, stlye、class の削除

JavaScript, style, classは削除されます。以下の class については、残されます。

- original ... 原文用のブロックに使います。このclassのついたブロックは非表示になります
- prettyprint ... コード部分のブロックで使うとコードがハイライトされるようになります

### 3. 特殊なコメント &lt;!-- linkto: http://... --&gt;

原著者のポリシーなどで、perldoc.jp 上にホスト出来ず、原著者のサイトでホストしたいといった要望がある場合に、使ってください。
翻訳文を表示する代わりに、指定のURLへリダイレクトします。

## Markdown形式の翻訳についての特別な処理</h2>

perldoc.jpでは、Markdown形式の翻訳の場合、以下の処理を行っています。

### 1. タイトル/概要の抜き出し

タイトルは、最初の見出しから、概要は「翻訳」という文字のある最初の見出しがあれば、それに続く文章を概要とします。
または、「○○の翻訳」という見出しが最初にあれば、「○○」の部分をタイトルとして、それに続く文章を概要とします。
「翻訳」という文字が含まれる見出しがない場合は、最初の見出しに続く文章を概要とします。
もし、最初の見出しに「翻訳」という文字が含まれていた場合は、タイトルはその次の見出しのものを取得します。

### 2. オリジナルの文章の残し方

以下のようにコメントで囲むことで残せますが、フォーマッタがうまく処理できない場合があります。

<pre>
&lt;!-- original
original sentence
--&gt;
</pre>


## 決まっていないこと

以下の点は、特に決まっていませんが、各項目、前者の方が多いと思います。

- 句読点の形式 ...「、。」 or 「,.」
- 英語と日本語の間のスペース ... 「ある word の翻訳」or 「あるwordの翻訳」
- 口語体 or 文語体 ... 「です、ます」 or 「である」

## 翻訳することについての著者への報告

ほとんどのモジュールが改変と再配布が許可されているライセンスなので、元々のドキュメントの著者に翻訳の報告をする必要はありません。
ライセンスが不明な場合や、改変と再配布が許可されていないライセンスの場合には、著者に連絡を取ってください。
以下のような文章で聞くと良いかと思います。

<pre>
Dear ***

I'm *** ***.
I read your document about *** at http://***.
I want to introduce it to other Japanese Perl programmers.
Now I'm translating it into Japanese.

Can I distribute the translated document
under the same terms as Perl itself?
</pre>

