[% WRAPPER 'layout.html'  WITH title='翻訳の作法' description="Perlのドキュメントの翻訳における一般的なルールとperldoc.jpで表示される上でのルール。" header_title='Perlドキュメントの翻訳の作法' %]
<h1>翻訳の作法</h1>

<p>
Perlのドキュメントを翻訳する上での留意事項を書いています。翻訳したい方は、一度目を通していただけると良いかと思います。<br />
特にプロジェクトに特化した内容ではありませんが、Japanized Perl Resources Project(通称JPRP)をベースにしています。また、<a href="http://search.cpan.org/~argrath/Pod-L10N-0.07/lib/Pod/L10N/Format.pod">Pod::L10N 対応フォーマット仕様</a>も参考にしています。<br />
</p>

<ul class="pod_toc">
<li><a href="#dir">ディレクトリ構成</a></li>
<li><a href="#abstract_pod">podの抽出方法</a></li>
<li><a href="#charset">文字コード</h3></li>
<li><a href="#translation_lines">翻訳文の行数</h3></li>
<li><a href="#leave_original">原文の残し方</a></li>
<li><a href="#code_translation">コード部分の翻訳</h3></li>
<li><a href="#head1_translation">=head1の翻訳</a></li>
<li><a href="#link_translation">L&lt;...&gt;の翻訳</a></li>
<li><a href="#item_translation">=itemの翻訳</a></li>
<li><a href="#html">HTML形式の翻訳についての特別な処理</a></li>
<li><a href="#md">Markdown形式の翻訳についての特別な処理</a></li>
<li><a href="#info">連絡先の記述</a></li>
<li><a href="#info2author">翻訳することについての著者への報告</a></li>
<li><a href="#not_specified">決まっていないこと</a></li>
<li><a href="#inro2translation">翻訳したことの報告</a></li>
<li><a href="#translation_table">対訳表</a></li>
<li><a href="#see_also">JPRPの参考文書</a></li>
</ul>

<h2 id="dir">ディレクトリ構成</h2>

<h3>コアドキュメント</h3>
<pre>
docs/perl/バージョン/ファイル名.pod
</pre>
<h3>モジュール</h3>
<pre>
docs/modules/モジュール名-バージョン/
</pre>
<p>
以下に、モジュールの tar.gz を展開し、各.pm を .pod に変更します。
<p>

<h4>その他</h3>
pod / html / md いずれでも構いません。以下のように配置してください。
<pre>
docs/articles/perl/名前.pod
docs/articles/ドメイン/パス/ファイル名.html
docs/articles/ドメイン/パス/ファイル名.md
</pre>
<p>
具体的には、以下のようになります。
</p>
<pre>
/docs/articles/perl/perlunicook.pod
/docs/articles/perl.com/pub/2012/06/perlunicook-further-resources.html
</pre>

<h2 id="abstract_pod">podの抽出方法</h2>
<pre>
% perldoc -u Test::More
% perldoc -u Test/More.pm
</pre>
<p>
のようにすることで、pod を抽出することができます。
</p>

<h2 id="charset">文字コード</h3>
<p>
やむをえない事情がない限りは 文字コードはutf-8にしてください。<br />
pod ファイルの先頭で、以下のように、encoding を指定します。
</p>
<pre>
=encoding utf8
</pre>

<h2 id="translation_lines">翻訳文の行数</h3>
<p>
英語の文章の順番と日本語の文章の順番は違いますが、行数はある程度合わせた方が良いです。<br />
英語が数行にわたって書かれている場合、日本語訳も数行に分けて書いたほうが良いです。
</p>
<pre>
Similar to C<%+>, this variable allows access to the named capture buffers
in the last successful match in the currently active dynamic scope. To
each capture buffer name found in the regular expression, it associates a
reference to an array containing the list of values captured by all
buffers with that name (should there be several of them), in the order
where they appear.
</pre>
<p>原文が上記のようであれば、(行数が違いますが)以下のように複数行で書きます。</p>
<pre>
C&lt;%+&gt; と同様、この変数は現在アクティブな動的スコープで最後に成功した
マッチングの名前付き捕捉バッファへのアクセスを可能にします。
正規表現中に捕捉バッファ名が現れるごとに、その名前のバッファ全てで
(複数あるでしょう)捕捉されている値のリストを出現順で含む配列への
リファレンスと関連付けられます。
</pre>
<p>
翻訳文をバージョンアップした際に、diff を見てチェックする場合などがありますが、その際に一行にまとめていると diff が見辛くなります。
</p>

<h2 id="leave_original">原文の残し方</h2>
ファイル内に原文を残す場合は、
<pre>
<div style="color:blue">
=begin original

原文...

=end original
</div>
</pre>
<p>
のように、=begin original 〜 =end original で囲みます。<br />
</p>
<p>
HTMLの場合は、原文がかこまれているタグのクラス名を original としてください。
</p>
<pre>
<div style="color:blue">&lt;h1 class="original"&gt;Title&lt;/h1&gt;</div>&lt;h1&gt;タイトル&lt;/h1&gt;
<div style="color:blue">&lt;div class="original"&gt;
原文
&lt;/div&gt;</div>&lt;div&gt;
翻訳文
&lt;/div&gt;
</pre>
<p>
ただし、=head を訳す場合は、=head の次に( )で翻訳文を入れてください。<br />
※ =head NAME は、そのままにしてください。
</p>
<pre>
=head Version Ranges

(バージョンの範囲)
</pre>
<h2 id="code_translation">コード部分の翻訳</h3>

コード部分は訳さずそのまま残しておいた方が良いです。<br />
下記の赤色の部分はコード部分ですが、これらは、originalには含みません。<br />
※ただし、コード部分のコメントを翻訳し、原文を残したい場合は、originalブロックに含めても構いません(が、コメント部分くらいであれば、オリジナルを残さなくても良いかと思います)。
<pre>
=head1 SYNOPSIS
<div style="color:blue">
=begin original

The following is example of usage of Hoge.
Example1:

=end original
</div>
Hogeの使い方の例です。
例1:
<div style="color:red">
 $hoge = Hoge->new;
 $hoge->foo;
</div>
<div style="color:blue">
=begin original

Example2:

=end original
</div>
例2:
<div style="color:red">
 $result =  $hoge->bar
 print $result->to_string;
</div>
=head1 DESCRIPTION

</pre>

<h2 id="head1_translation">=headの翻訳</h2>
<p>
NAME, SYNOPSYS, DESCRIPTION などですが、代表的なものは、perldoc.jpでは、自動的に翻訳されて表示されます。<br />
翻訳される場合原文をそのままにして、下に（）で書いてください。<br />
perldoc.jp では、表示時に()部分を=headの英文と置き換えています。
※ただし、<i>=head1 NAME</i>はPODのパーサーに取って重要なものとなりますので、こちらのみ訳さずにそのままにして、()も書かないでください。
</p>
<pre>
=head1 NAME

=begin original

GreatModule - great module

=end original

GreatModule - 偉大なモジュール

=head1 STRUCTURE

(構造)

=head2 OPTIONAL FIELDS

(オプションのフィールド)

=head
</pre>
<p>
以下の代表的なものは、perldoc.jpでは日本語に置換されて表示されます。
</p>
<table>
<tr><td>NAME</td><td>名前</td></tr>
<tr><td>SYNOPSIS</td><td>概要</td></tr>
<tr><td>DESCRIPTION</td><td>説明</td></tr>
<tr><td>OPTIONS</td><td>オプション</td></tr>
<tr><td>METDODS</td><td>メソッド</td></tr>
<tr><td>FUNCTIONS</td><td>関数</td></tr>
<tr><td>EXAMPLE</td><td>例</td></tr>
<tr><td>AUTDOR</td><td>作者</td></tr>
<tr><td>COPYRIGHT & LICENSE</td><td>コピーライト & ライセンス</td></tr>
<tr><td>BUGS</td><td>バグ</td></tr>
<tr><td>CAUTION</td><td>警告</td></tr>
<tr><td>ACKNOWLEDGEMENTS</td><td>謝辞</td></tr>
<tr><td>SUPPORT</td><td>サポート</td></tr>
</table>

<h2 id="link_translation">L&lt;...&gt;の翻訳</h2>
<p>
<i>L&lt;/STRUCTURE&gt;</i> のような POD内リンクについては、perldoc.jp では英語のままでも、英語を翻訳しても、いずれでも正しい場所へリンクされます。<br />
ただし、<i>L&lt;CPAN::Meta::Spec/optional_features&gt;</i> のような同じ文書内に含まれないリンクに関しては翻訳されると正しい場所にリンクできなくなります。<br />
※他のPOD表示ツールで日本語に翻訳されたリンクが正しく動くかはわかりません(たぶん、動きません)。
</p>

<h2 id="item_translation">=itemの翻訳</h2>
=item を =begin original 〜 =end original で囲むと、PODのパースに失敗する場合があります。以下のように回避できます。
<h3>(a) =item の下に ()で訳文を入れる</h3>
<p>
=head1と同様に、()で訳文を入れる方法です。
</p>
<pre>
=over 8

=item test

(テスト)
<div style="color:blue">
=begin original

original sentence.

=end original
</div>
翻訳文章
</pre>

<h3>(b) =item を訳文にして、その下に原文を書く</h3>
<p>
もしくは、原文→訳文の順番が逆になりますが、=item を訳文にして、その下に、=begin original 〜 =end original で原文を( )で囲んでも良いかも知れません。
ただし、モジュールがアップデートされた時のことを考えるとあまりいい方法ではありません。
</p>
<pre>
=over 8

=item テスト

=begin original

(test)

=end original

<div style="color:blue">
=begin original

original sentence.

=end original
</div>
翻訳文章
</pre>

<h3>(c) =over 〜 =back までをすべて =begin original 〜 =end original で囲ってしまう</h3>
<p>
=over 〜 =back までの量が少ないのであれば、 =begin original 〜 =end original で全体を囲ってしまっても良いでしょう。
</p>

<pre>
<div style="color:blue">
=begin original

=over 8

=item test

original sentence.

=item test2

original sentence.

=back

=end original
</div>
=over 8

=item テスト

翻訳文章

=item テスト2

翻訳文章

=back
</pre>

<h2 id="html">HTML形式の翻訳についての特別な処理</h2>
<p>
perldoc.jpでは、HTML形式の翻訳の場合、以下の処理を行っています。
</p>
<h3>タイトル/概要の抜き出し</h3>
<p>
タイトルは、titleタグから、タイトルタグがない場合は、最初のh1タグから取得します。<br />
概要は、meta タグで description が指定されてあれば、そちらを使用します。
</p>
<h3>JavaScript, stlye、class の削除</h3>
<p>
JavaScript, style, classは削除されます。以下の class については、残されます。
</p>
<ul>
<li> original ... 原文用のブロックに使います。このclassのついたブロックは非表示になります
<li> prettyprint ... コード部分のブロックで使うとコードがハイライトされるようになります
</ul>
<h3>特殊なコメント &lt;!-- linkto: http://... --&gt;</h3>
<p>
原著者のポリシーなどで、perldoc.jp 上にホスト出来ず、原著者のサイトでホストしたいといった要望がある場合に、使ってください。<br />
翻訳文を表示する代わりに、指定のURLへリダイレクトします。
</p>

<h2 id="md">Markdown形式の翻訳についての特別な処理</h2>

<p>
perldoc.jpでは、Markdown形式の翻訳の場合、以下の処理を行っています。
</p>
<h3>タイトル/概要の抜き出し</h3>
<p>
タイトルは、最初の見出しから、概要は「翻訳」という文字のある最初の見出しがあれば、それに続く文章を概要とします。
または、「○○の翻訳」という見出しが最初にあれば、「○○」の部分をタイトルとして、それに続く文章を概要とします。
「翻訳」という文字が含まれる見出しがない場合は、最初の見出しに続く文章を概要とします。
もし、最初の見出しに「翻訳」という文字が含まれていた場合は、タイトルはその次の見出しのものを取得します。
</p>

<h3>オリジナルの文章の残し方</h3>
<p>
以下のようにコメントで囲むことで残せますが、フォーマッタがうまく処理できない場合があります。
</p>
<pre>
&lt;!-- original
original sentence
--&gt;
</pre>

<h2 id="info">連絡先の記述</h2>
<p>連絡先を書く場合は、翻訳文の最後に以下のように付記すると良いでしょう(特に決まりはありません)。</p>
<pre>
=head1 翻訳について

翻訳者：名前 (account@example.com)
</pre>
<p>
翻訳リポジトリの場所や、翻訳プロジェクトの名前やURL、誤訳の報告先などを書き足しても良いかと思います。
</p>
<h2 id="not_specified">決まっていないこと</h2>
<p>
以下の点は、特に決まっていませんが、各項目、前者の方が多いと思います。
</p>
<ul>
<li>句読点の形式 ...「、。」 or 「,.」 </li>
<li>英語と日本語の間のスペース ... 「ある word の翻訳」or 「あるwordの翻訳」</li>
<li>口語体 or 文語体 ... 「です、ます」 or 「である」</li>
</ul>
<h2 id="info2author">翻訳することについての著者への報告</h2>
<p>
ほとんどのモジュールが改変と再配布が許可されているライセンスなので、元々のドキュメントの著者に翻訳の報告をする必要はありません。<br />
ライセンスが不明な場合や、改変と再配布が許可されていないライセンスの場合には、著者に連絡を取ってください。<br />
以下のような文章で聞くと良いかと思います。
</p>
<pre>
Dear ***

I'm *** ***.
I read your document about *** at http://***.
I want to introduce it to other Japanese Perl programmers.
Now I'm translating it into Japanese.

Can I distribute the translated document
under the same terms as Perl itself?
</pre>

<h2 id="inro2translation">翻訳したことの報告</h2>
<p>
JPRPの場合、<a href="http://www.freeml.com/perldocjp/0000504">RFCメール</a>をMLに送るという方法を取っています。<br />
JPRP、gitリポジトリで翻訳された場合は、当サイトのRSSフィードで配信されます。
</p>

<h2 id="translation_table">対訳表</h2>
<p>
Perlの用語の対訳表を以下にまとめています。
</p>
<ul>
<li><a href="https://github.com/perldoc-jp/translation/blob/master/translation_table.md">対訳表</a></li>
</ul>

<h2 id="see_also">JPRPの参考文書</h2>
<p>
JPRPに関する個別の決め事などは、以下を参照してください。
</p>
<ul>
<li><a href="http://perldocjp.osdn.jp/perldocjp-faq">FAQ</a></li>
<li><a href="http://osdn.net/projects/perldocjp/docman/">その他文書</a></li>
</ul>
[% END %]
