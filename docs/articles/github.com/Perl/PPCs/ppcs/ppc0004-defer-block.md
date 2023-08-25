# Perl/PPCs/ppcs/ppc0004 defer block の翻訳

この文書は、[Perl/PPCs/ppcs/ppc0004-defer-block](https://github.com/Perl/PPCs/blob/main/ppcs/ppc0004-defer-block.md)を翻訳したものです。

原題は、「Deferred block syntax」です

# Deferred block syntax

(遅延ブロック構文)

## Preämble 序文

翻訳注：こちらは原文の情報です。

    Author:  Paul Evans <PEVANS>
    Sponsor:
    ID:      0004
    Status:  Implemented

## Abstract 要約

<!-- original
Add a new control-flow syntax written as `defer { BLOCK }` which enqueues a block of code for later execution, when control leaves its surrounding scope for whatever reason.
-->

`defer { BLOCK }`と記述する新たな制御フロー構文を追加します。この構文は、コードブロックを遅延実行するため、キューにコードブロックを追加し、スコープを抜けた際にそのコードブロックを実行します。

## Motivation 動機

<!-- original
Sometimes a piece of code performs some sort of "setup" operation, that requires a corresponding "teardown" to happen at the end of its task. Control flow such as exception throwing, or loop controls, means that it cannot always be written in a simple style such as
-->

コードの"セットアップ"操作を行い、そのタスクの終わりに"後処理"が必要になることがあります。例外が投げられた時やループ文の時の制御フローを考慮すると、常に次のコードのように簡潔には書けません。

    {
      setup();
      operation();
      teardown();
    }

<!-- original
as in this case, if the `operation` function throws an exception the teardown does not take place. Traditional solutions to this often rely on allocating a lexical variable and storing an instance of some object type with a `DESTROY` method, so this runs the required code as a result of object destruction caused by variable cleanup. There are no in-core modules to automate this process, but the CPAN module `Scope::Guard` is among the more popular choices.

It would be nice to offer a native core syntax for this common behaviour. A simple `defer { BLOCK }` syntax removes from the user any requirement to think about storing the guard object in a lexical variable, or worry about making sure it really does get released at the right time.

This syntax has already been implemented as a CPAN module, [`Syntax::Keyword::Defer`](https://metacpan.org/pod/Syntax::Keyword::Defer). This PPC formalizes an attempt implement the same in core.
-->

このコードの場合、もし、`operation`関数が例外を投げると、後処理が行われません。これに対する伝統的な解決策は、`DESTROY`メソッドを持つ何らかのオブジェクトをレキシカル変数に割り当て、変数のクリーンアップ時のオブジェクト破壊時に必要なコードを実行するというものです。このプロセスを自動的に行うモジュールはコアにはありませんが、CPANモジュールの`Scope::Guard`はよく取られる選択肢です。

この一般的な振る舞いがネイティブのコアの構文として提供できれば良さそうです。`defer { BLOCK }`と書くだけで良ければ、ガードオブジェクトをレキシカル変数に保存することや、適切なタイミングに本当にリリースされたか心配する必要がなくなります。

この構文は、[`Syntax::Keyword::Defer`](https://metacpan.org/pod/Syntax::Keyword::Defer)として、CPANモジュールとして既に実装されています。このPPCによって、コアで同じ実装を試みることを正式化しています。


## Rationale 提案理由

<!-- original
((TODO - I admit I'm not very clear on how to split my wording between the Motivation section, and this one))

The name "defer" comes from a collection of other languages. Near-identical syntax is provided by Swift, Zig, Jai, Nim and Odin. Go does define a `defer` keyword that operates on a single statement, though its version defers until the end of the containing function, not just a single lexical block. I did consider this difference, but ended up deciding that a purely-lexical scoped nature is cleaner and more "Perlish", overriding the concerns that it differs from Go.
-->

((TODO - 動機の段落とこの段落の言葉を私は明確に区別できてないです。))

"defer"という命名は、他の言語から取っています。Swift、Zig、Jai、NimやOdinとほぼ同じ構文が提供されています。Goは、単一のステートメントに作用する`defer`キーワードを定めていますが、Goでは、単一のレキシカルブロックではなく、deferを含んだ関数の終わりまで処理を遅延します。私はこの違いを考えましたが、このGoとの違いの懸念よりも、純粋なレキシカルスコープの性質の方が明確で、より"Perlish"だと判断しました。


## Specification 仕様

<!-- original
A new lexically-scoped feature bit, requested as
-->

新たなレキシカルスコープの特性は、以下のようにして要求されます。

    use feature 'defer';

<!-- original
enables new syntax, spelled as
-->

これにより新たな構文が有効になり、以下のように利用できます。

    defer { BLOCK }

<!-- original
This syntax stands alone as a full statement; much as e.g. a `while` loop does. The deferred block may contain one or multiple statements.

When the `defer` statement is encountered during regular code execution, nothing immediately happens. The contents of the block are stored by the perl interpreter, enqueued to be invoked at some later time, when control exits the block this `defer` statement is contained within.

If multiple `defer` statements appear within the same block, the are eventually executed in LIFO order; that is, the most recently encountered is the first one to run:
-->

この構文は、`while`ループなどと同様に、完全にステートメントとして独立しています。遅延実行されるブロックは、一つもしくは複数のステートメントを含みます。

通常のコード実行中に、`defer`ステートメントがあったら、すぐには何も起こりません。ブロックの内容はperlインタプリンターによって保存され、この`defer`ステートメントが含まれるブロックから制御を抜ける際に、遅延呼び出しされるようにキューに追加されます。

もし同じブロックで、複数の`defer`ステートメントがあった場合、LIFOの順で実行されます。つまり、次のコードのように、最も最近遭遇したコードが、最初に実行されます。

    {
      setup1();
      defer { say "This runs second"; teardown1(); }
    
      setup2();
      defer { say "This runs first"; teardown2(); }
    }

<!-- original
`defer` statements are only "activated" if the flow of control actually encounters the line they appear on (as compared to `END` phaser blocks which are activated the moment they have been parsed by the compiler). If the `defer` statement is never reached, then its deferred code will not be invoked:
-->

`defer`ステートメントは、その行が、実際に制御フローで現れた時のみ"活性化"されます。(コンパイラが解析すれば活性化される`END`ブロックとは異なります。) もし、`defer`ステートメントに到達しない場合、遅延されたコードは呼び出されません。

    while(1) {
      defer { say "This will happen"; }
      last;
      defer { say "This will *NOT* happen"; }
    }

<!-- original
((TODO: It is currently not explicitly documented, but naturally falls out of the current implementation of both the CPAN and the in-core versions, that the same LIFO stack that implements `defer` also implements other things such as `local` modifications; for example:
-->

*((TODO: 現時点では明確にドキュメント化されていませんが、CPANバージョンとコアバージョンの両方の現状の実装から自然と次のことが導かれます。`defer`が実装しているLIFOスタックによって、`local`による変更など他のものも実装しています。例えば、次のコードをみてください。

    our $var = 1;
    {
      defer { say "This prints 1: $var" }
    
      local $var = 2;
      defer { say "This prints 2: $var" }
    }

<!-- original
((I have no strong thoughts yet on whether to specify and document - and thus guarantee - this coïncidence, or leave it unsaid.))
-->

((この偶然の一致を、ドキュメントに明記し保証するか、このまま言わないでおくか、私はまだ強い意見を持っていません。))


<!-- original
Non-local control flow (`next/last/redo`, `goto`, `return`) is not permitted to cross the boundary of the `defer` block
-->

非ローカルな制御フロー（`next/last/redo`、`goto`や`return`)が、`defer`ブロックの境界を超えようとすることは許可されません。

    foreach my $item (@things) {
      defer { last; }  ## This is NOT permitted
    }

<!-- original
Attempts to do this will throw an exception, likely worded something about
-->

もしこれを試みた場合、例外が発生します。おそらく次のようなエラーメッセージでしょう。

```
Attempting to 'last' out of a 'defer' block is not permitted at FILE line LINE.
```

<!-- original
Of course, nonlocal control flow is permitted entirely *within* the `defer` block; we only prohibit control flow that attempts to leave the block:
-->

もちろん、非ローカルな制御フローであっても、`defer`ブロックの中に全て完結するのであれば、許可されます。ブロックを抜けようとする場合のみ禁止します。

    {
      defer {
        foreach my $i ( 1 .. 10 ) {
          last if $i == 5;  ## This is permitted
        }
      }
    }

<!-- original
The one exception to this (pardon the pun) is that exceptions thrown from within the `defer` block propagate out to the caller.

For example, in
-->

これのただ一つの例外は、`defer`ブロックの中で例外が発生(言葉遊びで失礼)した時に、呼び出し元に伝搬することです。

例えば、次の例をみてください。

    sub f {
      defer { die "This is thrown\n"; }
    }
    
    f();

<!-- original
the caller will see the exception being thrown in the same way as if it appeared in a regular (non-`defer`red) block.

It is currently unspecified what happens if a `defer` block throws an exception while unwinding the stack because of an exception.
-->

呼び出し元は、通例のブロック(`defer`ではないブロック)で例外が発生したのと同じように見えます。

現在、スタックが展開されている最中に、`defer`ブロックで例外が発生した時の動作は未定義です。

    {
      defer { die "Exception A\n"; }
      die "Exception B\n";
    }

<!-- original
In this case, the caller will definitely see *an* exception thrown from the code, but there is currently no guarantee whether that will be A, B, or some third kind of thing that is a combination of the two. This is intentionally left as scope for future expansion; at such time perl ever gains true object-like core exceptions, then it can be represented by some kind of "double exception" condition.
-->

このケースにおいて、呼び出し元は、このコードから例外が投げられることを確実に見ることになりますが、その例外が、A、B、あるいはこの2つの例外の組み合わせのような別の何かとなるか現時点では保証はありません。これは将来の拡張性のため意図的に保留しています。もし、perlが真のオブジェクト型のコアの例外を持つことになったら、その際には、"二重例外"のような何かで表現できるかもしれません。

## Backwards Compatibility 後方互換性

<!-- original
The new syntax `defer { BLOCK }` is guarded by a lexical feature guard. A static analyser that is not aware of that feature guard would get confused into thinking this is indirect call syntax; though this is no worse than basically any other feature-guarded keyword that controls a block (e.g. `try/catch`).

For easy compatibility on older Perl versions, the CPAN implementation already mentioned above can be used. If this PPC succeeds at adding it as core syntax, a `Feature::Compat::Defer` module can be created for it in the same style as [`Feature::Compat::Try`](https://metacpan.org/pod/Feature::Compat::Try).
-->

この新たな`defer { BLOCK }` 構文は、レキシカルフィーチャーガードで守られます。フィーチャーガードを認識しない静的解析器の場合、間接呼び出し構文と誤解するかもしれませんが、これは`try/catch`といったブロックを制御するフィーチャーガードで保護された他のキーワードと大差ありません。

古いPerlバージョンとの簡単な互換性のために、上記で言及したCPANの実装が利用できます。もし、このPPCが、コア構文に追加することに成功したら、`Feature::Compat::Defer`モジュールを、[`Feature::Compat::Try`](https://metacpan.org/pod/Feature::Compat::Try)と同様の形で作れます。

## Security Implications セキュリティへの影響

<!-- original
None foreseen.
-->

予想されるものはありません。


## Examples 例

<!-- original
A couple of small code examples are quoted above. Further, from the docs of `Syntax::Keyword::Defer`:
-->

いくつかの小さなコードは上述の通りです。他には、`Syntax::Keyword::Defer`のドキュメントからも引用できます。

    use feature 'defer';

    {
      my $dbh = DBI->connect( ... ) or die "Cannot connect";
      defer { $dbh->disconnect; }
    
      my $sth = $dbh->prepare( ... ) or die "Cannot prepare";
      defer { $sth->finish; }
    
      ...
    }

## Prototype Implementation プロトタイプ実装

<!-- original
CPAN module `Syntax::Keyword::Defer` as already mentioned.

In addition, I have a mostly-complete branch of bleadperl (somewhat behind since I haven't updated it for the 5.34 release yet) at

  https://github.com/leonerd/perl5/tree/defer

I'm not happy with the way I implemented it yet (don't look at how I abused an SVOP to store the deferred optree) - it needs much tidying up and fixing for the various things I learned while writing the CPAN module version.
-->

既に言及されているCPANモジュールの`Syntax::Keyword::Defer`があります。
加えて、breadperlにほぼ完全なブランチがあります。(まだ5.34のリリースに関する更新を行ってないためいくらか遅れてます)

  https://github.com/leonerd/perl5/tree/defer

私はまだ実装に満足していません(遅延されたOP木を保存するために、SVOPを乱用したのを見ないでほしいです)。私がCPANモジュールを書く間に学んだ様々なことを踏まえて、修正し、整理する必要があります。


## Future Scope 将来の見込み

<!-- original
If this PPC becomes implemented, it naturally follows to enquire whether the same mechanism that powers it could be used to add a `finally` clause to the `try/catch` syntax added in Perl 5.34. This remains an open question: while it doesn't any new ability, is the added expressive power and familiarity some users will have enough to justify there now being two ways to write the same thing?

Additionally, once `defer` exists and if core exceptions ever gain some sort of metadata or object-like representation beyond simple strings, then the double-exception case mentioned above can be addressed.
-->

このPPCが実装された場合、Perl 5.34で追加された`try/catch`構文に`finally`句を追加するために、この同じ仕組みを利用するかどうかという疑問が自然に沸きます。この問は未解決です。つまり、新たな能力ではなく、新たな表現力と一部のユーザが慣れた方法であることが、同じ事を書くのに2つのやり方を持たせるに足る正当な理由かどうか？

加えて、コアの例外が、単なる文字列ではなく、メタデータやオブジェクトのような表現力を持つようであれば、`defer`は上述された二重例外のケースに対処できるようになります。

## Rejected Ideas 却下されたアイデア

<!-- original
On the subject of naming, this was originally called `LEAVE {}`, which was rejected because its semantics don't match the Raku language feature of the same name. It was then renamed to `FINALLY {}` where it was implemented on CPAN. This has been rejected too on grounds that it's too similar to the proposed `try/catch/finally`, and it shouldn't be a SHOUTY PHASER BLOCK. All the SHOUTY PHASER BLOCKS are declarations, activated by their mere presence at compiletime, whereas `defer {}` is a statement which only takes effect if dynamic execution actually encounters it. The p5p mailing list and the CPAN module's RT queue both contain various other rejected naming ideas, such as UNWIND, UNSTACK, CLEANUP, to name three. 

Another rejected idea is that of conditional enqueue:
-->

名称について言えば、元々は`LEAVE {}`と呼んでいました。ですが、Raku言語の同名のものと意味が一致しないため却下されました。その後、CPANで実装された時、`FINALLY {}`と改名されました。ですが、`try/catch/finally`と似すぎているため、また、SHOUTY PHASER BLOCKであるべきではないといった理由で却下されました。全てのSHOUTY PHASER BLOCKは宣言であり、コンパイル時に単に存在するだけで、活性化されます。一方、`defer {}`は実行時に実際に遭遇した場合のみ効果を発揮します。p5pのメーリングリストやそのCPANモジュールのRTには、UNWIND、UNSTACK、CLEANUPといった様々な却下された命名案が残っています。

他に却下されたアイデアは、次のコードのような条件つきのキューです。

    defer if (EXPR) { BLOCK }

<!-- original
as this adds quite a bit of complication to the grammar, for little benefit. As currently the grammar requires a brace-delimited block to immediately follow the `defer` keyword, it is possible that other ideas - such as this one - could be considered at a later date however.
-->

これは複雑な文法になる一方、利点があまりないため却下されました。現在の文法だと、`defer`キーワードに続くブロックは、ブレースで区切られている必要がありますが、こういった別のアイデアは、後日、考慮する可能性があります。

## Open Issues 

<!-- original
Design-wise I don't feel there are any remaining unresolved questions.

Implementation-wise the code still requires some work to finish it off; it is not yet in a merge-ready state.
-->

設計面では、未解決の問題はなさそうです。

実装面では、まだ作業すべきことがあり、まだマージできる状態ではありません。

## Copyright

Copyright (C) 2021, Paul Evans.

This document and code and documentation within it may be used, redistributed and/or modified under the same terms as Perl itself.
