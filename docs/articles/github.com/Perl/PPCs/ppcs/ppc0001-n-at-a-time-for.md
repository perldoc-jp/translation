# Perl/PPCs/ppcs/ppc0001 N-at-a-time with for　の翻訳

この文書は、[Perl/PPCs/ppcs/ppc0001-n-at-a-time-for](https://github.com/Perl/PPCs/blob/main/ppcs/ppc0001-n-at-a-time-for.md)を翻訳したものです。

原題は、「Multiple-alias syntax for foreach」です

# Multiple-alias syntax for foreach

（foreachに対する複数エイリアス記法）

## Preamble 序文

翻訳注：こちらは原文の情報です。

    Author:
    Sponsor: Nicholas Clark <nick@ccl4.org>
    ID:      0001
    Status:  Implemented

## Abstract 要約

現行では不正な記法である `for my ($key, $value) (%hash) { ... }` を実装し、
ハッシュに対して一度に2個の要素の取得を行います。 - これによりどのようなリストに対しても、
一度にＮ個の要素が取得できるよう一般化します。

<!-- original
Implement the currently illegal syntax `for my ($key, $value) (%hash) { ... }` to act as two-at-a-time iteration over hashes. This approach is not specific to hashes - it generalises to n-at-a-time over any list.
-->

## Motivation 動機

each関数は実装の詳細に問題があるため一般的には非推奨ですが、
次のようにもっとも"わかりやすく(pretty)"、簡潔な、ループ文の書き方です：

<!-- original
The `each` function is generally discouraged due to implementation details, but is still the most "pretty" and concise way to write such a loop:
-->

    while (my ($key, $value) = each %hash) { ... }

代替案として、forループ文で１ループ毎に、複数の要素を取得する書き方が考えられます。

<!-- original
An alternative to this would be a syntax to alias multiple items per iteration in a `for` loop.
-->

    for my ($key, $value) (%hash) { ... }

これを"バンドラー(bundler)"として一般化し、指定された変数の個数と同じ数だけ要素を抜き出すようにしたらどうでしょう。例えば：

<!-- original
This generalizes as a "bundler" - to alias a number of elements from the list equal to the number of variables specified. Such as:
-->

    for my ($foo, $bar, $baz) (@array) {
        # $foo, $bar, and $baz are the next three elements of @array,
        # or undef if overflowed


## Rationale 提案理由

ハッシュのキーと値に対する反復時の現行の記法：

<!-- original
The existing syntax to iterate over the keys and values of a hash:
-->

    while (my ($key, $value) = each %hash) { ... }

これにはいくつかの問題があります。

<!-- original
suffers from several problems
-->

* 正確さのため、ハッシュの内部状態が”クリーン”であることを仮定している - 頑健性のため、無効コンテキストで 'keys %hash' をして、はじめに繰り返し演算の初期化をしなければならない
* 初心者に説明するのが難しい - ここで何が起こっているか説明するには
  - リストへの要素割り当て規則
  - 空のリストは偽であり、空でないリストは真であること
  - ハッシュは内部的イテレーターを持っていること
* イテレーターを混乱させることなく、反復の内部でハッシュを修正することができない

<!-- original
* For correctness it assumes that the internal state of the hash being "clean" - to be robust one should reset the iterator first with `keys %hash;` in void context
* It's hard to teach to beginners - to understand what is going on here one needs to know
  - list assignment
  - empty lists are false; non-empty lists are true
  - that the hash holds an internal iterator
* You can't modify the hash inside the loop without confusing the iterator
-->

次のように２行で書くことは<b>できます</b>：

<!-- original
You *can* write it in two lines as
-->

    for my $k (keys %hash) {
        my $v = $hash{$h};
        ...
    }

（もし `%hash` が実際に複雑な表現であなたが二回評価したくないなら３行）

<!-- original
(three if `%hash` is actually a complex expression you don't want to evaluate twice)
-->

しかし、ワンライナーを書くに当たっては明らかに良い方法ではありません。

配列において、より一般的な *N個の要素を同時に* 反復する際には、単純で包括的な解決策はありません。
例えば、 **破壊的** に **配列** を反復することはできます。 

<!-- original
but that's not perceived as an obvious "win" over the one-liner.

The more general *n-at-a-time* iteration of an array problem doesn't have a simple generic solution. For example, you can **destructively** iterate an **array**:
-->

    while (@list) {
        my ($x, $y, $z) = splice @list, 0, 3;
        ...
    }

（上述の*3*は明示的に記述される必要があり、レキシカルの数から導き出すことはできない）。

<!-- original
(with that *3* needing to be written out explicitly - it can't derived from the number of lexicals)
-->

リストにたいして次のように非破壊的に反復することができます：

<!-- original
You can iterate over an list non-destructively like this:
-->

    my @temp = qw(Ace Two Three Four Five Six Seven Eight Nine Ten Jack Queen King);
    for (my $i = 0; $i < @temp; $i += 3) {
        my ($foo, $bar, $baz) = @temp[$i .. $i + 2];
        print "$foo $bar $baz\n";
    }

しかしこれは、

* 冗長である
* 正しく書くのが難しい
* 3回性を3つの場所で繰り返している
* リストに対して一時的配列（すなわちコピー）が必要
* すべての値のレキシカルへのコピーもしている

提案した文法は、これらの問題のすべてを解決します。

<!-- original
but that

* is verbose
* is hard to get right
* repeats the three-ness in three places
* needs a temporary array (hence a copy) for a list
* also copies all the values into the lexicals

The proposed syntax solves all of these problems.
-->

## Specification 仕様

```diff
diff --git a/pod/perlsyn.pod b/pod/perlsyn.pod
index fe511f052e..490119d00e 100644
--- a/pod/perlsyn.pod
+++ b/pod/perlsyn.pod
@@ -282,6 +282,14 @@ The following compound statements may be used to control flow:

     PHASE BLOCK

+As of Perl 5.36, you can iterate over multiple values at a time by specifying
+a list of lexicals within parentheses
+
+    no warnings "experimental::for_list";
+    LABEL for my (VAR, VAR) (LIST) BLOCK
+    LABEL for my (VAR, VAR) (LIST) BLOCK continue BLOCK
+    LABEL foreach my (VAR, VAR) (LIST) BLOCK
+    LABEL foreach my (VAR, VAR) (LIST) BLOCK continue BLOCK
+
 If enabled by the experimental C<try> feature, the following may also be used

     try BLOCK catch (VAR) BLOCK
@@ -549,6 +557,14 @@ followed by C<my>.  To use this form, you must enable the C<refaliasing>
 feature via C<use feature>.  (See L<feature>.  See also L<perlref/Assigning
 to References>.)

+As of Perl 5.36, you can iterate over a list of lexical scalars n-at-a-time.
+If the size of the LIST is not an exact multiple of number of iterator
+variables, then on the last iteration the "excess" iterator variables are
+undefined values, much like if you slice beyond the end of an array.  You
+can only iterate over scalars - unlike list assignment, it's not possible to
+use C<undef> to signify a value that isn't wanted.  This is a limitation of
+the current implementation, and might be changed in the future.
+
 Examples:

     for (@ary) { s/foo/bar/ }
@@ -574,6 +590,17 @@ Examples:
         # do something which each %hash
     }

+    foreach my ($foo, $bar, $baz) (@list) {
+        # do something three-at-a-time
+    }
+
+    foreach my ($key, $value) (%hash) {
+        # iterate over the hash
+        # The hash is eagerly flattened to a list before the loop starts,
+        # but as ever keys are copies, values are aliases.
+        # This is the same behaviour as for $var (%hash) {...}
+    }
+
 Here's how a C programmer might code up a particular algorithm in Perl:

     for (my $i = 0; $i < @ary1; $i++) {
```

## Backwards Compatibility 後方互換性

新しい文法は現存するPerlでは文法エラーになります。次のようなエラーメッセージが生成されます：

`Missing $ on loop variable at /home/nick/test/three-at-a-time.pl line 4.`

静的ツールは文法エラーとして認識できるはずですが、変更を加えない限りよりよい診断は得られないでしょう。

提案した実装には、`B::Deparse`, `B::Concise`, `Devel::Cover`, `Devel::NYTProf`, `Perl::Critic` で新しい文法をうまく扱うためのテストとパッチが含まれています。

よりバージョンの古いPerlではこの文法を再現することができないと思います。将来的にどんなAPIをパーサーに追加すればそれが可能になるのかわからず、なんらかのAPIを加えられたとして、それが脆弱であるかどうかと、まさに現在の実装ときつく連結しているかどうかはわかりません。

<!-- original
The new syntax is a syntax error on existing Perls. It generates this error message

`Missing $ on loop variable at /home/nick/test/three-at-a-time.pl line 4.`

Existing static tooling should be able to recognise it as a syntax error, but without changes wouldn't be able to give any better diagnostics.

The proposed implementation has tests and patches for `B::Deparse` and `B::Concise`. `Devel::Cover`, `Devel::NYTProf` and `Perl::Critic` handle the new syntax just fine.

I don't think that we have any way to emulate this syntax for earlier Perls. I don't have any feel for what sort of API we would need to add to the parser to make it possible in the future, and whether any API we could add would be fragile and tightly coupled to the exact current implementation.
-->

## Security Implications

この変更で、脆弱性を呈したり類似する問題は起こりそうにないと思われます。

<!-- original
We don't think that this change is likely to cause CVEs or similar problems.
-->

## Examples 例

Motivationに記載の例で十分かと思います。

<!-- original
The examples in the *Motivation* seem sufficient.
-->

## Prototype Implementation プロトタイプ実装

See https://github.com/nwc10/perl5/commits/smoke-me/nicholas/pp_iter

## Future Scope 将来の見込み

### スカラーのリストに`undef`を許容する

    for my ($a, undef, $c) (1 .. 9) { ... }

"この値は無視して"という意味にundefを割り当てることは、リスト割り当ての一般化として妥当です。また、`foreach`に対して（今回の提案で **あるいは** 後日に）実装することは、安全な文法ですし、いくつかの特異なケースにおいては役に立ちそうです。しかし、それを **持たない** としても、提案の基本的な有用性は損なわれません。 
*一度に N 個* の `foreach` のもっとも簡単な実装は、もし正確に *n* 個のスカラーがあれば、 `for` ループそれ自体のなかですべて宣言されることです。というのは、この方法で隣接するPadスロットを占領するからです。

これは、optreeの中に一つだけ特別な整数値があることを意味し、一度に *N* 個であること **と** ターゲット変数のアドレスの計算の両方に使われます。`undef` をその混合物に加えると、明らかに単純で分かりやすい実装を締めだしてしまいます。

もし、複雑にすることなく `undef` を加える良い方法をみつけたら、その時はそれをふくめることを検討すべきです。

<!-- original
It's a reasonable generalisation of list assignment, where you can assign to undef to mean "ignore this value". It's also safe syntax to implement for `foreach` (either as part of this proposal, **or** at a later date), and likely will be useful in some specific cases. But **not** having it doesn't hinder the utility of the basic proposal.

The easiest implementation of *n-at-a-time* `foreach` is if there are exactly *n* scalars, all declared in the `for` loop itself, because this way they occupy adjacent Pad slots. This means that there is only one extra integer to store in the optree, which used both to calculate the *n*-at-a-time **and** the addresses of the target variables. adding `undef` to the mix rules out an obvious simple, clear implementation.

If we discover that there is a good way to add `undef` without much increased complexity, then we should consider doing this.
-->

## Rejected Ideas 却下されたアイディア

<!-- original
    ### Permit @array or %hash in the list of lexicals
-->

### レキシカルのリストの中に@array または %hashを許容する

    for my ($key, $value, %rest) (%hash) { ... }
    for my ($first, $second, @rest) (@array) {... }

記法的に、これらはすべて動作しますし、すべてのレキシカルは隣接したPadスロットに置かれるという仮定に違反はしません。
しかし、ランタイムに複雑さが増えます。
*一度に 1 スカラー* から *一度に n スカラー* へと一般化することは、ほぼ、C言語の `for` ループを（動作している）既存のコードの中に付け足すだけです。

これらを実装するということは、基本的におかしな書き方である下記のようなプログラムのためにコードを追加することを意味します。

<!-- original
Syntactically these all "work", and don't violate the assumption that all lexicals are in adjacent Pad slots. But it would add complexity to the runtime. Generalising *1 scalar at a time* to *n at a time* is mostly just adding a C `for` loop around some existing (known working) code.

Implementing these would mean adding code for what is basically a funky way of writing
-->

    { my ($key, $value, %rest) = %hash; ... }
    { my ($first, $second, @rest) = @array; ... }


    { my ($key, $value, %rest) = %hash; ... }
    { my ($first, $second, @rest) = @array; ... }

### `my` 同様に `our` を許容する 

<!-- original
### Permit `our` as well as `my`
-->

`my` の代わりに `our` を使っても記法的には問題ありません。すなわち、下記をパースすることができます： 

<!-- original
Using `our` instead of `my` works in the grammar. ie we can parse this:
-->

    for our ($foo, $bar, $baz) (@array) {

しかし、実装はずっと複雑になります。それぞれのパッケージ変数は一対の GV と RV2GV オプションをレキシカルの中にエイリアス化のために設定する必要があり、私たちはENTERITERに与えるリストを生成し、Padsを設定するためにそのリストを処理する必要があります。その複雑さは労力に見合いません。

<!-- original
However, the implementation would be far more complex. Each package variable
would need a pair of GV and RV2GV ops to set it up for aliasing in a lexical,
meaning that we'd need to create a list to feed into ENTERITER, and have it
process that list to set up Pads. This complexity isn't worth it.
-->

### パース可能な別の記法（Father Chrysostomos氏提案）

<!-- original
### Alternative parsable syntaxes suggested by Father Chrysostomos
-->

この記法が提案された2017年、Father Chrysostomos氏は一つ目に加えて、そのあとの２つも現行ではエラーになりパース出来ないことを観察しています。

<!-- original
When this syntax was suggested in 2017, Father Chrysostomos observed that in addition to the first syntax, the next two are also currently errors and could be parsed:
-->

    for my ($key, $value) (%hash) { ... }
    for my $key, my $value (%hash) { ... }
    for $foo, $bar (%hash) { ... }

氏は、パースできない不正な記法は次のものだけだと記しました。

<!-- original
He notes that it's only this illegal syntax that could not be parsed:
-->

    for ($foo, $bar) (%hash) { ... } # syntax error

https://www.nntp.perl.org/group/perl.perl5.porters/2017/04/msg243856.html

厳密には、私たちは次のものもパース出来ません：

<!-- original

https://www.nntp.perl.org/group/perl.perl5.porters/2017/04/msg243856.html

Strictly we also can't parse this:
-->

    for (my $key, my $value) (%hash) { ... }

これは、 `for` のなかで次に類似するような記法の選択を提供できないことを意味します：

<!-- original
meaning that we can't offer choice of syntax in `for` analogous to:
-->

    (my $foo, my $bar, my $baz) = @ARGV
    my ($foo, $bar, $baz) = @ARGV

これは同じoptreeにパースされます。

<!-- original
which parse to the same optree.
-->

しかし、この２行は  **同一ではありません**。

<!-- original
However, these two lines are **not the same**:
-->

    my $key, my $value = @pair;
    my ($key, $value) = @pair;

したがって、私たちは次のような別の記法を提供すべきではありません：

<!-- original
hence we should not offer the alternative syntax:
-->

    for my $key, my $value (%hash) { ... }

実装上の問題から、私たちはレキシカルのみを扱いたいです。このことは次のものを除外します：

<!-- original
For implementation reasons we only want to handle lexicals. This rules out:
-->

    for $foo, $bar (%hash) { ... }

このように、これらの可能な別の記法は提供されるべきではありません。

<!-- original
So these alternative possible syntaxes should not be offered.
-->

### feature guardの後ろにおかれるべきですか？

<!-- original 
### Should this be behind a feature guard? 
-->

新しい記法はかつてはエラーであったように、あるいは以前には似たような状況でfeature guardを使わなかったように、いまは必要ないと考えます。

<!-- original
As the new syntax was previously an error, and previously in similar situations we have not used a feature guard, we don't think that we should this time.
-->

## Open Issues

## Copyright

Copyright (C) 2021, Nicholas Clark

This document and code and documentation within it may be used, redistributed and/or modified under the same terms as Perl itself.

