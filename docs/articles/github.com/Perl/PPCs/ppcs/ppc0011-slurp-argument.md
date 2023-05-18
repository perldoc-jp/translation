# Perl/PPCs/ppcs/ppc0011 Command-line flag for slurping の翻訳

この文書は、[Perl/PPCs/ppcs/ppc0011-slurp-argument](https://github.com/Perl/PPCs/blob/main/ppcs/ppc0011-slurp-argument.md)を翻訳したものです。

原題は「Command-line flag for slurping」です。

# Command-line flag for slurping

（ファイルを一気に全部読むコマンドラインフラグ）

## Preamble

翻訳注: こちらは、原文の情報です。

    Author: Tomasz Konojacki <me@xenu.pl>
    Sponsor:
    ID: 0011
    Status: Implemented

## Abstract

新たなコマンドラインフラグ `perl`, `-g` の導入。それは `$/` に `undef` をセットして
slurp mode を有効にします。`-0777` のシンプルなエイリアスです。

<!-- original
Introduce a new command-line flag for `perl`, `-g`, which sets `$/` to `undef`,
and thus enables slurp mode. It is a simpler alias for `-0777`.
-->

## Motivation

ファイルを行ごとに読むかわりに、一気に全部読み込む "Slurping" はワンライナーで
とてもよくある操作です。なので専用のものを持つことに値します。

<!-- original
Slurping (i.e. reading a whole file at once, instead of line by line) is a very
common operation in one-liners, and therefore it deserves its own dedicated
flag.
-->

## Rationale

現在のところ、ワンライナーにおいて `-0777` がもっとも一般的な slurp mode を有効にする方法です。
これは `-0number` オプションの特別なやり方です。`number` が `0o377` より大きい場合、`$/`
に `undef` がセットされて slurp modeが有効になります。

<!-- original
Currently, `-0777` is the most common way to enable slurp mode in one-liners.
It's a special case of `-0number`. When `number` is above `0o377` it sets `$/`
to `undef`, which enables slurp mode.
-->

`-0number` オプションは以下のような問題に苦しみます。

- 入力値のセパレータが8進数で示されないといけないのはきわめて普通ではありません。

- `$/` にさまざまなキャラクターがセットできすぎます。ユーザーが `undef` or `"\n"`
  以外の値を必要とするのは稀です。

- slurp modeを有効にするのはもっとも一般的です。マジックナンバーは隠されます。

slurp modeのフラグがあれば、ユーザーは特殊性のある `-0number` を避けられます。

<!-- original
`-0number` suffers from the following problems:

- The input record separator has to be specified with an octal number, which is
  very unusual.

- It's overly general, it can set `$/` to any character. Users rarely need
  values other than `undef` or `"\n"`.

- Its most common use, enabling slurp mode, is a special case hidden behind
  a magic number.

A dedicated flag for slurping would allow users to avoid the peculiarities of
`-0number`.
-->

## Specification

`-g` は `-0777` と完全に等価です。

<!-- original
`-g` is an alias for `-0777`, they are completely equivalent.
-->

## Backwards Compatibility

後方互換を破ることはないと思います。 `perl -g` は現在は fatal error になります。

<!-- original
No breakage is expected. `perl -g` is currently a fatal error.
-->

## Security Implications

（セキュリティへの影響）

ないはず。

<!-- original
Hopefully none.
-->

## Examples

    # collapse consecutive newlines:
    perl -i -gpE 's/\n+/\n/g' file.txt

## Future Scope

## Rejected Ideas

（採用しなかった案）

- `--slurp` という長いフラグはPerlがいまはサポートせず、この PPC の範囲外です。

- `-R`, `-o` という `-g` より良さそうな別の文字も採用しませんでした。
  残念ながら、もっとも自然な選択だと思われる `-s` は[すでに使われています](https://perldoc.perl.org/5.34.0/perlrun#-s)。

<!-- original
- Long flag, e.g. `--slurp`. Perl currently doesn't support long flags and
  adding them would be beyond the scope of this PPC.

- Alternative spellings of the flag, e.g. `-R`, `-o`. The author believes none
  of them are better or worse than `-g`. Unfortunately, the most natural choice,
  `-s`, [is already taken](https://perldoc.perl.org/5.34.0/perlrun#-s).
-->

## Open Issues

## Copyright

Copyright (C) 2021 Tomasz Konojacki

This document and code and documentation within it may be used, redistributed
and/or modified under the same terms as Perl itself.
