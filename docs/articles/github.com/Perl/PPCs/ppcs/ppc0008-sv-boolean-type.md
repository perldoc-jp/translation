# Perl/PPCs/ppcs/ppc0008  Stable SV Boolean Typeの翻訳

この文書は、[Perl/PPCs/ppcs/ppc0008-sv-boolean-type](https://github.com/Perl/PPCs/blob/main/ppcs/ppc0008-sv-boolean-type.md)を翻訳したものです。

原題は「Stable SV Boolean Type」です。

# Stable SV Boolean Type

(安定したSVブーリアン型)

## Preamble

翻訳注: こちらは、原文の情報です。

    Author:  Paul Evans <PEVANS>
    Sponsor:
    ID:      0008
    Status:  Implemented

## Abstract 概要

標準的(定義済みで参照されていない)スカラーに、それにブーリアン値を表すかを追跡する機能を
追加します。　`$x == $y` などのブーリアンの式から作成された値は、後で参照された場合でも確認できる方法で変数に格納されます。

<!-- original
Add to regular (defined and non-referential) scalars the ability to track whether they represent a boolean value. Values created from boolean expressions (such as `$x == $y`) will reliably remember this fact, in a way that can be introspected even if the value is stored into a variable and retrieved later.
-->

## Motivation モチベーション

言語の相互運用性の問題から文字列や数値などの型データの区別して表現することが
必要になる場合がある。Perlの他の場所でも、この区別を追加する試みがなされています。
このPPCでは trueやfalseと言った真偽値の扱い方を表現することを検討する。


<!-- original
Language interoperability concerns sometimes lead to situations where it is necessary to represent typed data - such as strings or numbers - in a way that can be reliably distinguished. Elsewhere in Perl there are attempts to add this distinction. This PPC attempts to address how to handle values of a boolean type; values that represent a simple true-or-false nature.
-->

例えばJSONやMsgPackなどの一般に使用されるシリアル化形式は、Perlでも生成やパースが可能です。
いずれにしても、それらのフォーマットは数値や文字列とは異なる真偽値を表現することができるが、Perlは
その区別を維持できない。現在人気のある他の言語と比較する。

<!-- original
For example, JSON and MsgPack are commonly-encountered serialisation formats that Perl can generate and parse, though in both cases while the formats themselves can represent boolean truth values distinctly from numbers or strings, perl cannot preserve that distinction. Compare this to some other languages popular at the moment:
-->

```
$ python3 -c 'import json; print(json.dumps([1, "1", 1 == 1]))'
[1, "1", true]

$ nodejs -e 'console.log(JSON.stringify([1, "1", 1 == 1]))'
[1,"1",true]

$ perl -MJSON::MaybeUTF8=encode_json_utf8 -E 'say encode_json_utf8([1, "1", 1 == 1])'
[1,"1",1]
```

`JSON::PP::Boolean` のようなワークアラウンドで不足を補充するようなモジュールの傾向があります。

<!-- original
There is a tendancy for modules to make up this shortfall with workarounds like the `JSON::PP::Boolean` type:
-->

```
$ perl -MJSON::MaybeUTF8=decode_json_utf8 -MData::Dump=pp 
   -E 'say pp(decode_json_utf8($ARGV[0]))' '[1,true]'

[1, bless(do{\(my $o = 1)}, "JSON::PP::Boolean")]
```

明らかに、いくつかの解決策ではJSONエンコーディング固有のもので、例えば、
JSONとMsgPackの間のメッセージゲートウェイには適用されず、その間で何らかの変換が必要になる。
この問題に対する真のコア内ソリューションには、これらのさまざまなモジュール間のデータ処理の相互運用性に多くの利点があります。

<!-- original
Obviously such a solution is specific to JSON encoding and does not apply to, for example, message gateway between JSON and MsgPack, which would require some translation inbetween. A true in-core solution to this problem would have many benefits to interoperability of data handling between these various modules.
-->

TODO: シリアライゼーションに依存しない純粋なインコア処理についてもいくつかコメントの追加

<!-- original
((TODO: Add some comments about purely in-core handling as well that don't rely on serialisation))
-->

## Rationale 合理的な理由

## Specification 仕様

この仕様には、XSコードから見えるCコード実装の低レベルのインコアディテールと、Perlプログラムから見える高レベルのPerlビジブルディテールの2つのパートがあります。

<!-- original
There are two parts to this specification; the lower-level in-core details of the C code implementation that are visible to XS code; and the higher-level Perl-visible details that are made visible to Perl programs.
-->

### C-level Internals C言語の内部

Cレベルで、SVが真偽値を含むかどうかをテストするマクロが必要になります。

<!-- original
At the C level, SVs will require a macro to test whether they contain a boolean. 
-->

```
SvIsBOOL(sv)
```

コアとなる不死身の `PL_sv_yes` と `PL_sv_no` は `SvIsBOOL()` に対して常に真を応答し、 `sv_setsv()` やその仲間を使ってそれらからコピーして初期化した SV も同様となります。この結果、ブール値を返す演算の結果は
 `SvIsBOOL()` となり、このフラグは、引数スタック上やレキシカル、集合構造体の要素に格納された、
 その値のすべてのコピーと一緒に残ります。

<!-- original
The core immortals `PL_sv_yes` and `PL_sv_no` will always respond true to `SvIsBOOL()`, as will any SV initialised by copying from them by using `sv_setsv()` and friends. The upshot here is that the result of boolean-returning ops will be `SvIsBOOL()` and this flag will remain with any copies of that value that get made - either over the arguments stack or stored in lexicals or elements of aggregate structures.
-->

それらの `SvIsBOOL()` の値はまだ、 `SvIV` か `SvPV` のようなマクロに関する通常のセマンティックに従います。
したがって、数値的には1または0、文字列的には "1 "と""のままです（ただし、以下のFuture Scopeの項を参照してください）。

<!-- original
These `SvIsBOOL()` values will still be subject to the usual semantics regarding macros like `SvPV` or `SvIV` - so numerically they will still be 1 or 0, and stringily they will still be "1" and "" (though see the Future Scope section below).
-->

この目的のために予備の `SvFLAGS` フィールドを見つけることができるかもしれません。その場合、 `SvPOK`/`SvIOK`/etc... セットと同様のテーマでマクロを作成します。"BOOL"という単語をフルで書けないほど、最近の文字は高価ではありませんから、古いスタイルの一文字の略語は避けた方がいいでしょう。

<!-- original
It may be possible to find a spare `SvFLAGS` field for this purpose, at which point there would be macros on a theme similar to the `SvPOK`/`SvIOK`/etc.. set. I would suggest avoiding the single-letter abbreviations of the older style of code - letters aren't so expensive these days that we can't at least spell out the word "BOOL" in full.
-->

フラグビットは希少で高価なため、予備のフラグビットを見つけるのは不可能（少なくとも望まない）かもしれません。
これは、そのような boolean の `SvPVX()` スロットに特別なポインタ値を使用することで、代わりに実装することができます。`sv_setsv()` とその仲間に小さな変更を加えて、実際のポインタ値そのものをコピーするようにすれば、任意の "boolean" SV を、このフィールドのポインタの等価性によって区別できるようになり、オリジナルの "yes" と "no" 不死身のものと同じにすることが可能になるでしょう。

<!-- original
Flag bits being rare and expensive, it may turn out that finding a spare flag bit is simply impossible (or at least, undesired). This could be implemented instead by using special pointer values in the `SvPVX()` slots of such booleans. A small change to `sv_setsv()` and friends would be possible to cause it to copy the actual pointer value itself, such that any "boolean" SV can be distinguished by pointer equality of this field, to that of the original "yes" and "no" immortals.
-->


### Perl-level Interface Perlのインターフェース

インタープリタが "is a boolean"の概念を確実に保存し、少なくともXSモジュールがこれを公開できるようになれば、pureperlのコードがどのように利用できるかという疑問が残ります。どうやって真偽値を作り出し、
どうやってその値が真偽値で与えられているかをテストするのでしょうか？

<!-- original
Once the interpreter can reliably store the concept of "is a boolean" and expose this at least to XS modules, the question remains on how pureperl code can make use of it. How can boolean values be created, and how can we test if a given value is a boolean?
-->

それらの値を生成するために、いくつかのケースでは既存の真偽値の述語演算子を単純に
利用することで十分である。例えば、比較演算子である。

<!-- original
For creating such values, in many cases it is sufficient to simply use any of the existing boolean predicate operators, for example the comparison operators:
-->

```perl
my $sv = 4 > 5;  $svはSvIsBOOLを持っている
```

<!-- original
# The $sv now has SvIsBOOL 
-->


これらの値を明示的に作成するために、 `true` と `false` の2つの新しいゼロ個性関数を提供することは
有用であると考えられるでしょう。( 少なくとも同等の `!!1` や `!!0` よりも少しは意図が
明らかです ) これらは `builtin` モジュール (PPC 0009) から要求することができます。

<!-- original
It may be considered useful to provide two new zero-arity functions, `true` and `false`, to explicitly create these values (which are at least a little more obvious in intent than the equivalent `!!1` and `!!0`). These can be requested from the `builtin` module (PPC 0009):
-->

```perl
use builtin 'true', 'false';

func(1, "1", true);       # 3つの異なる値
func(0, "0", "", false);  # 4つの異なる値
```

<!-- original
# Three distinct values
# Four distinct values
-->

問題は、pureperlのコードがどのようにして値の「型」を検査し、それがこの特別なブーリアン値の1つであるかどうかを検査できるのかということです。perl coreには
このためのテストキーワードはありませんが、現在利用可能な機能に最も近いのは、新しい組み込み関数を追加することです。

<!-- original
The question remains on how pureperl code can inspect the "type" of a value to inspect if it is one of these special boolean values. While perl core doesn't have any testing keywords for this, the nearest match to currently available features may be to add a new builtin function:
-->

```perl
use builtin 'isbool';

sub distinguish($x) {
  say !isbool $x ? "not a boolean" :
              $x ? "true"          :
                   "false";
}
```

どのような解決策を考える場合も、文字列と数字の区別を強化することで発生する可能性のある、より大きな考慮事項や他のアイディアと
うまく相互作用するように設計する必要があります。

<!-- original
Whatever solution is considered here should be designed to interact well with any possible larger considerations from the fallout of stronger string-vs-number distinctions, and other ideas currently floating around.
-->

この提案の最も弱い部分であることを認めていてコメントを歓迎します（ただし、以下の「今後の展望」セクションを
最初に読んでほしい）。

<!-- original
I accept that this is the weakest part of this suggestion so far, and welcome comment here in particular (though *please* first read the "Future Scope" section below).
-->

## Backwards Compatibility 後方互換性

この提案にはいくつかの後方互換性が期待されていません。インタープリターレベルでは、現在格納されている既存の情報の意味を変えることなく、
特定のSV値に余分な情報が追加されている。新しいセマンティクスを知らないコードは、既存の値をそのまま
見続けることになります。


<!-- original
There are not expected to be any backwards compatiblity problems with this proposal. At the interpreter level, extra information is being added to certain SV values, without changing the meaning of any existing information currently stored. Code that is unaware of the new semantics will continue to see existing values unaltered.
-->

同様にPerlの構文レベルでも、新たに追加される機能は`builtin`名前空間の新関数だけです。（PPC 0009）。

<!-- original
Likewise at the Perl syntax level, the only new functionality being added consists of new functions in the `builtin` namespace (PPC 0009).
-->

## Security Implications セキュリティの意味合い

同様に、この提案は SV によって保存されている情報に余分な情報を加えるだけなので、セキュリティ上の影響があるとは予想されない。あるSVがたまたまブーリアンインテントの値を
表現しているという事実を公開することによるセキュリティ上の影響はないと思われます。


<!-- original
Likewise, as this proposal only adds extra information to that being stored by SVs, it is not anticipated there are any security implications of doing so. There is not expected to be a security effect from exposing the fact that some SVs happen to express values of boolean intent.
-->

## Examples 例

上記の埋め込みコード参照

<!-- original
(See embedded code above)
-->

## Prototype Implementation プロトタイプの実装

不滅の定数の `SvPVX()` 追跡と `SvIsBOOL()` テストマクロを使う試みを
[https://github.com/leonerd/perl5/tree/stable-bool](github.com/leonerd/perl5/tree/stable-bool) でしてみました。

<!-- original
I made an attempt at using `SvPVX()` tracking of the immortal constants and the `SvIsBOOL()` test macro, at

[https://github.com/leonerd/perl5/tree/stable-bool](github.com/leonerd/perl5/tree/stable-bool)
-->

これは、Perlバージョン5.35.4の一部としてリリースされるのに間に合うように受け入れられ、Core perlにマージされた。

<!-- original
This was accepted and merged into core perl in time to be released as part of Perl version 5.35.4.
-->

組み込み関数機構がまだ利用できないため、`true`, `false`, `isbool` の組み込み関数を提供する試みはまだない。`isbool` の回避策は 
`Scalar::Util` で提供されています。

<!-- original
There is no attempt yet to provide the `true`, `false` or `isbool` builtin functions as the builtin function mechanism is not yet available. A workaround for `isbool` is provided by `Scalar::Util`.
-->

## Future Scope 今後の展望

この提案は、性質上、「Perlの値にもっと型付け情報を与えよう」というカテゴリーに当てはまります。そのため、文字列と数値の明確な区別、Unicodeテキストとバイトバッファの
区別など、似たような性質の他のアイデアとよく合うと思うわれる。これらのアイデアをより良い形でまとめ、Perlの文法に見える形で述語検定関数を追加する方法などの
疑問を解決することができるようになるかもしれません。


<!-- original
By its nature this proposal fits in the category of "give Perl values more typing information". As such it is likely to fit well with other ideas of a similar nature - such as clearer distinction between strings and numbers, between Unicode text and byte buffers, and other concepts. It may become possible to group these ideas together in a better way, to better solve such questions as how to add predicate-test functions in a way that is visible to Perl syntax.
-->

また、ブーリアン値の文字列化の方法を変更する、字句的に保護された機能を提供することも可能である。なお、現在のPerlでは、
falseの値は空文字列となるため、出力のデバッグに若干の困難があります。おそらく `boolean` 機能の下に、あるいは独自の
機能名の下に、ブーリアン値は異なる文字列化を行うことができます。

<!-- original
It may also be possible to provide a lexically-guarded feature that alters the way that boolean values are stringified. It is noted that in Perl currently, a false value stringifies to the empty string, which leads to certain difficulties in debugging output. Perhaps under the `boolean` feature, or perhaps under its own unique feature name, boolean values could stringify differently:
-->

```perl
use feature 'boolean';

my ($x, $y) = (true, false);
print "X=$x Y=$y\n";

__END__
X=true Y=false
```

## Rejected Ideas 却下されたアイディア

現在、確実に不可能なことの1つは、既存のブーリアン値の文字列化を変更することです。主にユニットテストにおいて、現在の真偽値の文字列に依存するコードがあまりにも多く、
これを変更することはできません。これを変更すると、次のようなテストが壊れてしまいます。

<!-- original
One thing that is certainly impossible to do currently is change the stringification of existing boolean values. There is far too much code around - primarily in unit tests - which relies on the current stringification of boolean true and false values, and this cannot be modified. Doing so would break such tests as:
-->

```perl
is( somefunc(), "", 'somefunc returns false' );
```

## Open Issues 

## Copyright

Copyright (C) 2021, Paul Evans.

This document and code and documentation within it may be used, redistributed and/or modified under the same terms as Perl itself.
