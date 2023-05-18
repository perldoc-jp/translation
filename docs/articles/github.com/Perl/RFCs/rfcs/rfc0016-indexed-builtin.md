# Perl/PPCs/ppcs/ppc0016-indexed-builtin の翻訳

この文書は、[Perl/PPCs/ppcs/ppc0016-indexed-builtin](https://github.com/Perl/PPCs/blob/main/ppcs/ppc0016-indexed-builtin.md)を翻訳したものです。

原題は「A built-in for getting index-and-value pairs from a list」です。

# A built-in for getting index-and-value pairs from a list

（リストからインデックスと値のペアを取得するビルトイン関数）

## Preamble

訳注: こちらは、原文の情報です。

    Author:  Ricardo Signes <rjbs@semiotic.systems>
    Sponsor:
    ID:      0016
    Status:  Implemented

## Abstract

この PPC は、不連続なリストの値とそのインデックスのための新しいビルトイン `indexed` を
提案します。これは キー/バリュー操作を簡単にします。

<!-- original
This PPC proposes `indexed`, a new builtin for interleaving a list of values
with their index in that list.  Among other things, this makes key/value
iteration on arrays easy.
-->

## Motivation

v5.36.0で n-at-a-time foreach が加わりました。簡単にリストのインデックス/バリューの
ペアを取得できるようになり、ペアでイテレーションすることも簡単になりました。

<!-- original
With v5.36.0 poised to add n-at-a-time foreach, easily getting a list of
index/value pairs from an array makes iteration over the pairs also becomes
easy.
-->

## Rationale

もし、インデックスとバリューをイテレーションする場面ではこう書きます:

<!-- original
If we start with the specific case of iterating over the indexes and values of
an array using two-target foreach, we might write this:
-->

```perl
for my ($i, $value) (%array[ keys @array ]) {
  say "$i == $value";
}
```

これは悪くありませんが、ちょっと冗長です。もし対象の array が構造上深いとこうします:

<!-- original
This is tolerable, but a bit verbose.  If we bury our target array deep in a
structure, we get this:
-->

```perl
for my ($i, $value) ($alpha->{beta}->[0]->%[ keys $alpha->{beta}->[0]->@* ]) {
  say "$i == $value";
}
```

これはよくないですね。

`indexed` があればこう書きます。

<!-- original
This is pretty bad.

With `indexed`, we write this:
-->

```perl
for my ($i, $value) (indexed $alpha->{beta}->[0]->@*) {
  say "$i == $value";
}
```

これはたぶんたくさんのものを追加しなくてもできるほど簡単かもしれない。

<!-- original
This is probably about as simple as this can get without some significant new
addition to the language.
-->

## Specification

    indexed LIST

`indexed` はリストを引数にします。

スカラーコンテキストでは `indexed` は引数のリストのエントリー数を返します。`keys` や `values` と
似ています。これはあたらしい "scalar" カテゴリーで warning されません。

<!-- original
`indexed` takes a list of arguments.

In scalar context, `indexed` evalutes to the number of entries in its argument,
just like `keys` or `values`.  This is useless, and issues a warning in the new
"scalar" category:
-->

    Useless use of indexed in scalar context

無効コンテキストでは、`Useless use of %s in void context` というワーニングが
出ます。

リストコンテキストでは、`indexed LIST` は2倍の長さのリストとして、ゼロからはじまる
整数値と合わせて評価されます。全ての値はコピーです。`values ARRAY` と違います。
(もし LISTが確かに array なら、arrayを変更するためにこのインデックスが使えます！)

（翻訳注: `values ARRAY` はコピーではなく実体が返るので、LISTの値を変更するなら
`values ARRAY` で取り出した値を変更すれば良いということ。`indexed LIST` はコピーが返る）

<!-- original
In void context, the `Useless use of %s in void context` warning is issued.

In list context, `indexed LIST` evalutes to a list twice the size of the list,
meshing the values with a list of integers starting from zero.  All values are
copies, unlike `values ARRAY`.  (If your LIST was actually an array, you can
use the index to modify the array that way!)
-->

## Backwards Compatibility

後方互換性に関してこれといった懸念はありません。`indexed` はリクエストされたときのみ
インポートされます。静的解析ツールは更新が必要になります。

古い Perl で indexed を使えるようにする機能は提供可能ですが、最適ではないでしょう。

<!-- original
There should be no significant backwards compatibility concerns.  `indexed`
will be imported only when requested.  Static analysis tools may need to be
updated.

A polyfill for indexed can be provided for older perls, but may not be as
optimizable.
-->

## Security Implications

特になし

<!-- original
Nothing specific predicted.
-->

## Examples

（**Rationale** にある例を見てください。）

`keys` と `values` のドキュメントにも `indexed` を参照するように更新されることを
期待します。また、`for` のドキュメントにもノートを追加します。

n-at-a-time foreach が実験段階でなくなるとき、`each` のドキュメントで
`indexed` による `for my (...) (...)` を新しい `each` として言及するべきです。

<!-- original
(See the examples under **Rationale**.)

I expect that docs for `keys` and `values` will be updated to reference
`indexed` as well, and we'll add a note about it to the documentation on `for`
and possibly pair slices.

When n-at-a-time foreach is no longer experimental, we should refer to the
combination of `for my (...) (...)` with `indexed` as forming an alternative to
`each` in the documentation for `each`.
-->

## Prototype Implementation

None.

## Future Scope

予定通り完了

<!-- original
I believe this will be complete as is.
-->

## Rejected Ideas

ハッシュやアレイリテラルで `keys` と `values` を組み合わせて呼ぶような `kv` の置き換え。

何も省略しないスライス文の置き換え。

<!-- original
This proposal replaces one for `kv` which could be called on hash or array
literals to act like a combination of `keys` and `values`.

That proposal replaced one for a slice syntax that evaluated to a slice that
omitted nothing.
-->

## Open Issues

None?

## Copyright

Copyright (C) 2021, Ricardo Signes.

This document and code and documentation within it may be used, redistributed
and/or modified under the same terms as Perl itself.
