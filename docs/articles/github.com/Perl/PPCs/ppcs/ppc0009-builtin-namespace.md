# Perl/PPCs/ppcs/ppc0009 Namespace for Builtin Functions の翻訳

この文書は、[Perl/PPCs/ppcs/ppc0009-builtin-namespace](https://github.com/Perl/PPCs/blob/main/ppcs/ppc0009-builtin-namespace.md)を翻訳したものです。

原題は「Namespace for Builtin Functions」です。

# Namespace for Builtin Functions

(組み込み関数の名前空間)

## Preamble

翻訳注: こちらは、原文の情報です。

    Author:  Paul Evans <PEVANS>
    Sponsor:
    ID:      0009
    Status:  Implemented

## Abstract

要求された関数をコアインタプリタが直接提供する仕組みを定める

<!-- original
Define a mechanism by which functions can be requested, for functions that are provided directly by the core interpreter.
-->

## Motivation

現在のperlでは、ユーティリティ関数を要求するには、`use`文を使って、ユーティリティモジュール(これらのいくつかはPerlのコアとして同封され、CPANにはより多くのユーティリティモジュールがあります。)からいくつかのシンボルを要求するか、名前づけられた関数を`use feature`プラグマモジュールで有効化します。

<!-- original
The current way used to request utility functions in the language is the `use` statement, to either request some symbols be imported from a utility module (some of which are shipped with perl core; many more available on CPAN), or to enable some as named features with the `use feature` pragma module.
-->

    use List::Util qw( first any sum );
    use Scalar::Util qw( refaddr reftype );
    use feature qw( say fc );
    ...

この場合、`say`や`fc`はコアインタプリタで提供されていますが、それ以外の関数はディスクの別のファイルかからロードされます。`Scalar::Util`や`List::Util`モジュールは、たまたまPerlのコアとしても同封されるデュアルライフモジュールですが、CPANには多くのモジュールがあります。

<!-- original
In this case, `say` and `fc` are provided by the core interpreter but everything else comes from other files loaded from disk. The `Scalar::Util` and `List::Util` modules happen to be dual-life shipped with core perl, but many others exist on CPAN.
-->

この文書では、よく利用される関数を言語の一部として提供するための新たな仕組みを提案します。

<!-- original
This document proposes a new mechanism for providing commonly-used functions that should be considered part of the language:
-->


    use builtin qw( reftype );
    say "The reference type of ref is ", reftype($ref);

or

    # on a suitably-recent perl version
    say "The reference type of ref is ", builtin::reftype($ref);


**Note:** この提案の主な関心ごとは、これらの関数を提供する全体的な**仕組み**です。提供されるべき全ての関数の詳細な一覧の提案はしません。まずは、アイデア全体を試すために、いくつかの有力な候補の関数から始めます。安定が確かめられれば、ケースバイケースで関数の追加を検討します。PPCのプロセスを利用するかどうかは、ケースによります。いずれにせよ、言語が進化するにつれ、この関数の一覧が継続的にメンテナンスされ、リリースごとに関数が追加されることを期待しています。


<!-- original
**Note:** This proposal largely concerns itself with the overal *mechanism* used to provide these functions, and expressly does not go into a full detailed list of individual proposed functions that ought to be provided. A short list is given containing a few likely candidates to start with, in order to experiment with the overall idea. Once found stable, it is expected that more functions can be added on a case-by-case basis; perhaps by using the PPC process or not, as individual cases require. In any case, it is anticipated that this list would be maintained on an ongoing basis as the language continues to evolve, with more functions being added at every release.
-->

## Rationale

perlでは、長年に渡って、中置演算子やキーワードのコントロールフローなどの真に新しい文法がたびたび追加されてきました。一方、正規の関数の進歩は、少なくとも正規の関数として動作しそうな演算子の進歩は、ほとんどありませんでした。関数を追加するには、`use feature`の仕組みを利用して実現してきました。この仕組みには留意すべき2つの問題点があります:

<!-- original
While true syntax additions such as infix operators or control-flow keywords have often been added to perl over the years, there has been little advancement in regular functions - or at least, operators that appear to work as regular functions. Where they have been added, the `use feature` mechanism has been used to enable them. This has two notable downsides:
-->

* コントロールフローや新しい文法に関する名付けられた機能(`try`や`postderef`など)なのか、端に正規の関数に見えるキーワード(`fc`など)を追加するのか、混同してしまう。

<!-- original
* It confuses users, by conflating the control-flow or true-syntax named features (such as `try` or `postderef`), with ones that simply add keywords that look and feel like regular functions (such as `fc`).
-->

* `feature`はインタプリタの一部であるコア同封のモジュールのため、CPANとのデュアルライフにできません。そのため新しく追加された関数を古いperlに提供することは簡単にできません。

<!-- original
* Because `feature` is a core-shipped module that is part of the interpreter it cannot be dual-life shipped to CPAN, so newly-added functions cannot easily be provided to older perls.
-->

これまで正規の関数を言語のコアに追加することはあまりなく、[Scalar::Util](https://metacpan.org/pod/Scalar::Util)のようなコアに同封されるデュアルライフモジュールに関数を追加する仕組みが好まれていました。これにも問題点がないわけではないです。局所的に関数をインポートすることはできますが、ほとんどのモジュールでこれを行いません。代わりに、呼び出し側でパッケージレベルのインポートを行います。これでは、インポートされたユーティリティ関数が読み出し側の名前空間で全て見えてしまいます。これは呼び出し側がメソッドつきのクラスを提供するとき特に問題になります。

<!-- original
As there have not been many new regular functions added to the core language itself, the preferred mechanism thus far has been to add functions to core-shipped dual-life modules such as [Scalar::Util](https://metacpan.org/pod/Scalar::Util). This itself is not without its downsides. Although it is possible to import functions lexically, almost no modules do this; instead opting on a package-level import into the caller. This has the effect of making every imported utility function visible from the caller's namespace - which can be especially problematic if the caller is attempting to provide a class with methods:
-->

    package A::Class {
      use List::Util 'sum';
      ...
    }

    say A::Class->new->sum(1, 2, 3);  # うっかり見えてしまっているメソッド

この結果は大きな数字が出力されます。なぜなら、List::Util::sum() 関数は4つの引数で呼び出されます。つまり、インスタンスリファレンスの数値と、引数で与えられた3つの小さな数値の足し算になるからです。


<!-- original
This will result in some large number being printed, because the List::Util::sum() function will be invoked with four arguments 
- the numerical value of the new instance reference, in addition to the three small integers given.
-->

この問題に関連して、perlに名前付きの演算子を加える場合、非常に複雑で多くの手順が必要です。例えば、レキサーやパーサー、オペコードのコアリストの更新などです。新しい正規の関数を提供したい実装者にとって、これは高い参入障壁です。

<!-- original
A related issue here is that the process of adding new named operators to the perl language is very involved and requires a lot of steps - many updates to the lexer, parser, core list of opcodes, and so on. This creates a high barrier-to-entry for any would-be implementors who wish to provide a new regular function.
-->


## Specification

この文書では、以下の通り、コアperlに2つの主要コンポーネントの実装を提案します。

<!-- original
This document proposes an implementation formed from two main components as part of core perl:
-->

* 1. `builtin::`という新たな名前空間。これは、`perl`インタプリタで常に利用できます。（言い換えれば、既存の`CORE::`や`Internals::`といった名前空間と似た働きをします。)

<!-- original
1. A new package namespace, `builtin::`, which is always available in the `perl` interpreter (and thus acts in a similar fashion to the existing `CORE::` and `Internals::` namespaces).
-->


* 2. `use builtin`という新たなプラグマモジュール。これは、buitin名前空間から呼び出したスコープに局所的に関数をインポートします。

<!-- original
2. A new pragma module, `use builtin`, which lexically imports functions from the builtin namespace into its calling scope.
-->

名前付きプラグマモジュールは現在、通常のモジュールと同じファイルインポートの仕組みで実装されています。なので、`builtin.pm` ファイルの作成が少なくとも必要で、おそらく `&builtin::import` 関数自身の実装になります。これにより、3つ目のコンポーネントを以下の通り作成することができます。

<!-- original
As named pragma modules are currently implemented by the same file import mechanism as regular modules, this necessitates the creation of a `builtin.pm` file to contain at least part of the implementation - perhaps the `&builtin::import` function itself. This being the case, a third component can be created:
-->

* 3. `builtin.pm`という新たなモジュール。これは、`builtin`と呼ばれるデュアルライフなCPANモジュールとして配布し、加えて、提供する関数のXS実装も含みます。

<!-- original
3. A new module `builtin.pm` which can be dual-life shipped as a CPAN distribution called `builtin`, to additionally contain an XS implementation of the provided functions.
-->

このコンポーネントの組み合わせで、次の特性を持ちます。

<!-- original
This combination of components has the following properties:
-->

* 新しい名前空間を使うことで、十分に新しいperlコードでは提供される関数を完全修飾の形で利用できます。

<!-- original
* By use of the new package namespace, code written for a sufficiently-new version of perl can already make use of the provided functions by their fully-qualified name:
-->

    say "The reference type of anonymous arrays is ", builtin::reftype([]);

* 普通の名前付き関数として動作する関数をインポートするコードが書けます。これは、`Scalar::Util`といったユーティリティモジュールのおなじみの方法と似ています。

<!-- original
* Code can be written which imports these functions to act as regular named functions, in a similar way familiar from utility modules like `Scalar::Util`:
-->

    use builtin 'reftype';
    say "The reference type of anonymous arrays is ", reftype([]);


* 名前つき関数は局所的に呼び出し元のブロックにインポートされます。呼び出し元のパッケージのシンボリックへのインポートではありません。これは伝統的なユーティリティ関数モジュールたちと異なる振る舞いですが、`feature`や`strict`、`warnings`といった他のプラグマモジュールの期待により近いです。全体として、小文字の名前が特別なプラグマモジュールであることを示唆するので、妥当な振る舞いだと思います。

<!-- original
* Named functions are imported lexically into the calling block, not symbolically into the calling package. This does differ from the behaviour of traditional utility function modules, but more closely matches the expectations from other pragma modules such as `feature`, `strict` and `warnings`. Overall it is felt this is justified by its lowercase name suggesting its status as a special pragma module.
-->

* オブジェクトクラスがうっかり名前付きのメソッドとして公開しないです。

<!-- original
* Object classes do not inadvertantly expose them all as named methods:
-->

    package A::Class {
      use builtin 'sum';
      ...
    }

    say A::Class->new->sum(1, 2, 3);  # "method not found"という例外が発生する

<!-- original
    package A::Class {
      use builtin 'sum';
      ...
    }

    say A::Class->new->sum(1, 2, 3);  # results in the usual "method not found" exception behaviour
-->

この文書では、実際に提供する関数のセットについて完全に議論することは望んでいませんが、プロセスと仕組みのを理解するために、初期のセットは必要です。デザインが不明瞭な新しい関数を提案するよりも、CPANのコアモジュールで広く利用されている既存の関数を単にコピーすることをおすすめします。

<!-- original
Although this document does not wish to fully debate the set of functions actually provided, some initial set is required in order to bootstrap the process and experiment with the mechanism. Rather than proposing any new functions with unclear design, I would recommend sticking simply to copying existing widely-used functions that already ship with core perl in utility modules:
-->

* From `Scalar::Util`, copy `blessed`, `refaddr`, `reftype`, `weaken`, `isweak`.

* From `Internals`, copy `getcwd` (because it is used by some core unit tests, and it would be nice to remove it from the `Internals` namespace where it ought never have been in the first place).

## Backwards Compatibility

この提案は、新しい名前空間や新しいプラグマモジュールを追加することを除けば、新しい文法や振る舞いの変更をしません。以前のバージョンのperlには `builtin::` 名前空間と `use builtin` プラグマモジュールがないので、既存のコードがこれらを利用を期待して書かれていることはないでしょう。従って、互換性の懸念はなさそうです。

<!-- original
This proposal does not introduce any new syntax or behavioural change, aside from a new namespace for functions and a new pragma module. As previous perl versions do not have a `builtin::` namespace nor a `use builtin` pragma module, no existing code will be written expecting to make use of them. Thus there is not expected to be any compability concerns.
-->

関連する点として、`builtin.pm`プラグマモジュールとそれが含むべき関数のポリフィル実装をデュアルライフとして配布すれば、この新たな仕組みを使って書かれたコードは、古いバージョンのperlでも部分的にサポートされCPANに配布できるようになります。プラグマはただのモジュールとして動作するので、`use builtin ...`と書いたコードは、デュアルライフの`builtin`モジュールをインストールしていれば、古いバージョンのperlでも意図したとおり動作するはずです。

<!-- original
As a related note, by creating a dual-life distribution containing the `builtin.pm` pragma module along with a polyfill implementation of any functions it ought to contain, this can be shipped to CPAN in order to allow code written using this new mechanism to be at least partly supported by older perl versions. Because the pragma still works as a regular module, code written using the `use builtin ...` syntax would work as intended on older versions of perl if the dual-life `builtin` distribution is installed.
-->

## Security Implications

組み込み関数の仕組み自体には、セキュリティ上の影響は想定していません。ですが、追加される個々の関数については、個別に検討が必要です。

<!-- original
There are none anticipated security implications of the builtin function mechanism itself. However, individual functions that are added will have to be considered individually.
-->

## Examples

## Prototype Implementation

None yet.

## Future Scope

この提案では、この仕組みでの提供される関数の具体的なリストについては踏み込んでいないので、この点が今後の主な議題です。提案として、以下のコメントを残しておきます。

<!-- original
As this proposal does not go into a full list of what specific functions might be provided by the mechanism, this is the main area to address in future. As a suggestion, I would make the following comments:
-->

* `Scalar::Util`の関数はほとんど候補として考えて良いと思います

<!-- original
* Most of the `Scalar::Util` functions should be candidates
-->

* `List::Util`の関数で、高階関数として動作しない関数もほとんど候補に含められると思います。例えば、`sum`, `max`, `pairs`, `uniq`, `head` などです。`reduce`のような高階関数やその特殊化である`first`や`any`は、"第一引数が関数ブロックのようなもの"をコンパイル時にパースする振る舞いになるので、候補にはならないと思います。

<!-- original
* Most of the `List::Util` functions that do not act as higher-order functionals can probably be included. This would be functions like `sum`, `max`, `pairs`, `uniq`, `head`, etc. The higher-order functionals such as `reduce` or its specialisations like `first` and `any` would not be candidates, because of their "block-like function as first argument" parsing behaviour at compiletime.
-->

* `POSIX`のインメモリデータユーティリティとして動作する`ceil`や`floor`は候補だと思います。一方、オペレーティングシステムと対話する関数の大部分を追加することを勧めません。

<!-- original
* Some of the `POSIX` functions that act abstractly as in-memory data utilities, such as `ceil` and `floor`. I would not recommend adding the bulk of the operating system interaction functions from POSIX.
-->

* 新しい名前付き関数を提案するような他のPPCやPre-PPCの議論は、このモジュールの良い候補になると思います。このPPCを参照しながら、提案のメリットを検討できます。この文書を書いた時点では、コアサポートのboolean型(PPC 0008)や新たなモジュールローディング関数(PPC 0006)が候補になりそうです。

<!-- original
* There are other PPCs or Pre-PPC discussions that suggest adding new named functions that would be good candidates for this module. They can be considered on their own merit, by reference to this PPC. At time of writing this may include new functions to handle core-supported boolean types (PPC 0008) or the new module-loading function (PPC 0006).
-->

* 関数の安定したセットが定まったら、`feature.pm`と同様にバージョン番号つきのバンドルを検討してください。

<!-- original
* Once a stable set of functions is defined, consider creating version-numbered bundles in a similar theme to those provided by `feature.pm`:
-->

    use builtin ':5.40';  # imports all those functions defined by perl v5.40

* バージョン番号つきのバンドルができれば、 以下のコードのように`use VERSION`文法で有効にすべきか検討してください。

<!-- original
* Once version-numbered bundles exist, consider whether the main `use VERSION` syntax should also enable them; i.e.
-->

    use v5.40;  # Does this imply  use builtin ':5.40'; ?

## Rejected Ideas

### Multiple Namespaces

最初の議論では、`string::`や`ref::`といった複数の名前空有間を検討していました。ですが、これは非常に複雑で、多くの新しい関数を招待していしまいそうだったため、却下しました。すべての正規の関数を単一の名前空間をいれることで、提供する関数の数を制限する一定の圧力が生まれます。

<!-- original
An initial discussion had been to consider giving multiple namespaces for these functions to live in, such as `string::` or `ref::`. That was eventually rejected as being overly complex, and inviting a huge number of new functions. By sticking to a single namespace for all regular functions, we apply a certain amount of constraining pressure to limit the number of such functions that are provided.
-->

## Open Issues

### Package Name

これらの関数を提供するパッケージ名は何か？

この議論では、`builtin::`を利用しました。他に`function::`や`std::`などが候補として提案されています。

<!-- original
What is the package name these functions are provided in?

The discussion above used `builtin::`. Other proposed suggestions include `function::` or `std::`.
-->

### Pragma Module Name

この局所的なインポートをするプラグマモジュール名は何か？

この議論では、パッケージ名に合わせ、`use buitin`を利用しました。技術的には、パッケージ名に合わせる必要はないです。特に、実装中や初期の利用時に問題であることがわかれば、パッケージ名を合わせず、同じ単語の複数形を使用できます。

<!-- original
What is the module name for the lexical-import pragma?

The discussion above used `use builtin`, to match the package name. Technically it does not have to match the package name. In particular, if during implementation or initial use it is found to be problematic that the name does match, the import module could use a plural form of the same word; as
-->

    use builtins qw( function names here );

### Version Numbering

`builtin`プラグマモジュールのバージョン番号をどうするか？

これは、古いperl向けのポリフィルをデュアルライフモジュールとして配布することを考えるとき、特に興味深いものになります。

バージョン番号は、ポリフィルの関数を提供するperl自身のバージョンとあわせるべきケースがありますです。従って、コードは次のように書けます。

<!-- original
How to version number the `builtin` pragma module?

This becomes an especially interesting when considering the dual-life module distribution provided as a polyfill for older perls.

A case can be made that its version number should match the version of perl itself for which it provides polyfill functions. Thus, code could write:
-->

    use builtin v5.40;
    # perl v5.40のbuiltinの関数が全て利用可能になる

<!-- original
    use builtin v5.40;
    # and now all the builtin:: functions from perl v5.40 are available
-->

これは、一見、魅力的に見えますが、このようなポリフィルのデュアルライフの実装がバグを含んでいたとき、後のリビジョンを必要とするかもしれません。

<!-- original
This does initially seem attractive, until one considers the possibility that a dual-life implementation of these polyfills might contain bugs that require later revisions to fix. How would the version numbering of the dual-life distribution reflect the fact that the implementation contains a bugfix on top of these?
-->

### Polyfill for Unavailable Semantics

新しいperlにどのように組み込み関数を提供するかという問題とは直接関係ありませんが、古いperl向けのポリフィルがデュアルライフのCPANモジュールとして提供されいて、もし古いperlが提供された関数のセマンティックをサポートできないとき、どうすべきかという問題が出てきます。現在の提案のように`Scalar::Util`のような既存のコードからコピーしてくる場合は、この問題を引き起こしませんが、追加されるいくつかのPPCを検討した場合、より複雑なエッジケースに遭遇します。

<!-- original
While not directly related to the question of how to provide builtin functions to new perls, by offering to provide a dual-life module on CPAN as a polyfill for older perl releases, the question arises on what to do if older perls cannot support the semantics of a provided function. The current suggestion of copying existing functions out of places like `Scalar::Util` does not cause this problem, but when we consider some of the additional PPCs we run into some more complex edge-cases.
-->

例えば、PPC 0008では、`true`や`false`といった言語レベルの真偽値を返す新たな関数の追加と、`isbool`という与えられた値が真偽値であるか判定する関数を提案しています。古いperlに対して、最初の2つの関数を提供することは簡単ですが、後者はポリフィルすることはできません。なぜなら、古いperlでは、"これが真偽値か？"という問いに意味がないからです。こういった状況を処理する方法はいくつかあります。

<!-- original
For example, PPC 0008 proposes adding new functions `true` and `false` to provide real language-level boolean values, and an `isbool` predicate function to enquire whether a given value has boolean intention. The first two can be easily provided on older perls, but polyfilling this latter function is not possible, because the question of "does this value have boolean intention?" is not a meaningful question to ask on such perls. There are a number of possible ways to handle this situation:
-->

* 1. シンボルのインポートを拒否する。 例えば、`use builtin 'isbool'`は、コンパイル時に失敗する

<!-- original
1. Refuse to import the symbol - `use builtin 'isbool'` would fail at compiletime
-->

* 2. インポートするが、実行を拒否する。例えば、`if( isbool $x ) { ... }`は例外を投げる

<!-- original
2. Import, but refuse to invoke the function - `if( isbool $x ) { ... }` would throw an exception
-->

* 3. 意味はあるが不正確な回答をする。例えば、`isbool $x`は、"boolean intention"の概念がここではないので、常に偽を返す。

<!-- original
3. Give a meaningful but inaccurate answer - `isbool $x` would always return false, as the concept of "boolean intention" does not exist here
-->

それぞれ正しい振る舞いだと主張できます。このPPCが、この問いに直接回答する必要はありませんが、少なくとも追加されるポリフィル関数はこういった問題が認められており、全てのポリフィル関数はこの問題に関して可能な限り一貫した振る舞いになることが望まれるでしょう。

<!-- original
Each of these could be argued as the correct behaviour. While it is not directly a question this PPC needs to answer, it is at least acknowledged that some added polyfill functions would have this question, and it would be encouraged that all polyfilled functions should attempt to act as consistently as reasonably possible in this regard.
-->

## Copyright

Copyright (C) 2021, Paul Evans.

This document and code and documentation within it may be used, redistributed and/or modified under the same terms as Perl itself.
