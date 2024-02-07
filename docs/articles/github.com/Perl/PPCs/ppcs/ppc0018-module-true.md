# モジュールの最後の真値は不要に

この文書は [PPCs/ppcs
/ppc0018-module-true.md](https://github.com/Perl/PPCs/blob/main/ppcs/ppc0018-module-true.md) を翻訳したものです。

原題は「No Longer Require a True Value at the End of a Module」です。

## Preamble 序文

翻訳注：以下は原文のママです。

    Author:  Curtis "Ovid" Poe <curtis.poe@gmail.com>
    Sponsor:
    ID:      0018
    Status:  Draft

## Abstract 要約

 <!-- original
This PPC proposes a feature which, when used, eliminates the need to end a Perl
module with the conventional "1" or other true value. 
-->

このPPC提案は、Perlのモジュールの末尾を伝統的に "1" や他の真の値で終わらせる必要をなくすものです。

## Motivation 動機

<!-- original
Eliminate the need for a true value at the end of a Perl file.
-->

Perlファイルの末尾を真値で終わらせる必要をなくします。

## Rationale 提案理由

<!-- original
There's no need to have a true value be hard-coded in our files that we
`use`. Further, newer programmers can get confused because sometimes code
_doesn't_ end with a true value but nonetheless compiles just fine because
_something_ in the code returned a true value and the code compiles as a
side-effect.
-->

`use` するときに、ファイルに真値をハードコードする必要性はありません。さらに、新参者の
プログラマーは真値でコードが _終了しない_ にもかかわらず、真値を返す _なにかしら_ が
副作用でコードをコンパイルできてしまうことで混乱します。

## Specification 仕様

<!-- original
First, a new `feature` is added:
-->

まず、新しい `feature` が追加されます：

```perl
use feature 'module_true';
```

<!-- original
Then, *whenever* a module is loaded with `require` (or an equivalent, like
`use`), the "croak if false" test is skipped if the `module_true` feature was
in effect at the last statement executed in the required module.
-->

そうして、`require` (あるいは同等の `use` など)でモジュールがロードされた時は *いつでも*、requireされたモジュール内で実行されている最後のステートメントで`module_true`フィーチャーが
有効ならば、"croak if false（偽ならcroakする）"テストをスキップします。


## Backwards Compatibility 後方互換性

<!-- original
There are no compatibility concerns I'm aware of because we're only suggesting
changing behaviour in the presence of a newly-added feature that is not
present in any existing code.
-->

私の気づく範囲で互換性の問題はありません。なぜなら既存のコードにはない新しいfeatureを追加して
振る舞いを変えることを提案しているにすぎないからです。

## Security Implications セキュリティ懸念

<!-- original
None expected.
-->

予想されるものはありません。

## Examples

<!-- original
Imagine this module:
-->

下記のモジュールを想像してください：

```perl
package Demo1;
use feature 'module_true';

sub import {
  warn "You imported a module!\n";
}
```

<!-- original
When loaded by `require` or `use` anywhere in perl, this would import
successfully, despite the lack of a true value at the end.

This module shows an (almost certainly never useful) way to croak anyway:
-->

perlのどこでも`require`または`use`によってロードされる時、このインポートは成功し、
末尾の真値がなくても関係ありません。

このモジュールは（ほとんど確実に役に立たない）croakする方法を示します。


```perl
package Demo2;
use feature 'module_true';

return 1 if $main::test_1;
return 0 if $main::test_2;

{
  no feature 'module_true';
  return 0 if $main::test_3;
}
```

<!-- original
In this example, the only case in which requiring Demo2 would fail is if
`$main::test_3` was true.  The previous `return 0 if $main::test_2` would still
be within the scope of the `module_true` feature, so the return value would be
ignored.  When `0` is returned outside the effect of `module_true`, though, the
old behavior of testing the return value is back in effect.
-->

こちらの例では、Demo2のrequireが失敗する唯一のケースは、`$main::test_3` が真のときです。
すぐ前の `return 0 if $main::test_2` では、依然として `module_true` feature のスコープの
範囲内なので、戻り値は無視されます。しかし、`module_true` の効果の範囲外で `0` が返される時、
古い振る舞いである戻り値のチェック機能が復帰します。

## Prototype Implementation 試験実装

<!-- original
There is a prototype implementation at [true](https://metacpan.org/pod/true).
-->
試験実装はこちらです。 [true](https://metacpan.org/pod/true)


## Future Scope 今後の展望

<!-- original
Due to this being a named feature, this can eventually be the default behavior
when `use v5.XX;` is used.
-->

名前付きfeatureになるので、`use v5.XX;` が使用された時のデフォルトの挙動に含まれることになります。

## Rejected Ideas　却下された案

<!-- original

It's been discussed that we should return the package name instead. This
supports:

-->

戻り値にパッケージ名を返すべきかどうかが議論されました。これは以下をサポートします。

```perl
my $obj = (require Some::Object::Class)->new;
```

<!-- original
However, per haarg:
-->

しかしながら、haag曰く：


<!-- original
> Changing the return value of require seems like a separate issue from what
> this PPC wants to address.
>
> If you wanted require to always return the same value, and for that value to
> come from the file, you need a new location to store these values. This
> would probably mean a new superglobal to go along with %INC. And it would
> usually be useless because most modules return 1. I don't think this is a
> very good idea.
>
> If you wanted require to always return the package name, it's a separate
> issue from this PPC because that means ignoring the return value from the
> file. It also presents a problem because require doesn't actually take
> package names.  It takes file path fragments. Foo::Bar is translated to
> "Foo/Bar.pm" at parse time. This would then need to be converted back to a
> package name, or do something else. I don't think this is a good idea
> either.
>
> Instead, it's probably best addressed with a builtin::load or similar
> routine that accepts a package as a string. This has been discussed in the
> past, and solves other problems. Module::Runtime has a use_module function
> that behaves like this, returning the package name.
-->

> requireの戻り値を変えることは、このPPCで取り扱いたい内容とは別の問題に見えます。
> 
> もしつねにrequireが同じ値を返すのを望み、その値がファイルから来るのなら、その値を
> 保存する別の場所が必要です。これはおそらく %INCと共に新たなスーパーグローバルな変数で
> あることを意味します。ほとんどのモジュールは1を返すので、そのようなものは大抵不要です。
> 私は良いアイディアだとは思いません。
> 
> もしつねに"require"がパッケージ名を返すように望むなら、このPPCとは別の問題です。
> なぜならファイルからの戻り値を無視することを意味するからです。requireは実際は
> パッケージ名をとらないので、問題も生じます。それはファイルパスの断片を取得します。
> Foo::Bar は、パース時に "Foo/Bar.pm" に翻訳されます。そうしてこれはパッケージ名に
> 戻される必要があるか、その他の場合もあります。いずれにしろ良い考えではないと思います。
> 
> 代わりに、builtin::load あるいはそれと同様のパッケージを文字列として受け入れる
> サブルーチンで対処するのがおそらく最善でしょう。過去に議論されてきたことであり、
> 他の問題を解決もします。Module::Runtime はこのように振る舞う use_module関数を
> 持っていて、パッケージ名を返します。


<!-- original
Thus, we prefer simply returning `true` (or `1`).
-->

そうして、我々は単に  `true` (または`1`)を返すことを選びました。

## Copyright

Copyright (C) 2022, Curtis "Ovid" Poe

This document and code and documentation within it may be used, redistributed
and/or modified under the same terms as Perl itself.
