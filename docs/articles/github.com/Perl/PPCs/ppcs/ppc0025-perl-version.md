
# Perl 5 is Perl

(Perl 5はPerlです)

(訳注: (TBR)がついている段落は「みんなの自動翻訳＠TexTra」による
機械翻訳です。)

## Preamble

    Author:  Aristotle Pagaltzis <pagaltzis@gmx.de>
    ID:      0025
    Status:  Draft

## Abstract

<!-- original
There is no Perl&#160;6 looming any more, so the only thing “Perl” now refers to is Perl&#160;5. That has also forever been the language that people mean when they say just “Perl” rather than specifying “Perl&#160;5”. There were earlier versions of Perl, but they are ancient history. All the history that created a distinction between “Perl” and “Perl&#160;5” has fallen away while nobody was paying conscious attention.
-->

Perl&#160;6はもはや存在しないので、「Perl」が現在参照している唯一のものはPerl&#160;5です。
これはまた、「Perl&#160;5」を指定するのではなく、単に「Perl」と言うときに人々が意味する言語でもあります。
Perlの初期のバージョンもありましたが、それらは古代の歴史です。
「Perl」と「Perl&#160;5」の区別を生み出したすべての歴史は、誰も意識的に注意を払っていない間に消え去りました。
(TBR)

<!-- original
The interpreter already identifies itself as “perl 5, version 40, subversion 0”. We should just drop the 5 and make it official.
-->

インタプリタはすでに「perl 5, version 40, subversion 0」として識別されています。
5を削除して正式なものにすべきです。
(TBR)

## Motivation

<!-- original
Perl is in need of a future.
-->

Perlには未来が必要です。
(TBR)

<!-- original
30 years ago on October 17, 1994, it turned 5.0.
-->

30年前の1994年10月17日に5.0人になりました。
(TBR)

<!-- original
In its early years Perl went through versions rapidly. 1.0 came out in December 1987, less than 7 years earlier. Up to Perl&#160;4 (itself just a release of Perl&#160;3 re-badged for the convenience of the first Camel book), Perl had been a different, distinct, earlier language, in the sense that code written in it would be structured differently. This early Perl was not well suited to programming in the large.
-->

初期の頃、Perlは急速にバージョンを上げました。
1.0は1987年12月にリリースされましたが、それは7年も前のことではありませんでした。
Perl&#160;4(それ自体は、最初のCamelブックの利便性のために再バッジされたPerl&#160;3のリリースにすぎません)まで、Perlは、そこで書かれたコードが異なる構造になるという意味で、異なった、独特の初期の言語でした。
この初期のPerlは、大規模なプログラミングにはあまり適していませんでした。
(TBR)

<!-- original
Perl&#160;5 changed that. It expanded the power of the language drastically and enabled the creation of CPAN. In so doing it also broke compatibility in some small ways, famously breaking some older Perl poetry.
-->

Perl&#160;5はそれを変えました。
それは言語の力を劇的に拡大し、CPANの作成を可能にしました。
そうすることで、いくつかの小さな点で互換性を破壊し、いくつかの古いPerlの詩を破ったことで有名です。
(TBR)

<!-- original
In 2000, some 6 years later – almost as long as it had taken to reach 5.0 –, the need for rejuvenation led to [the inception](https://www.nntp.perl.org/group/perl.packrats/;msgid=20020729060339.GF11511%40chaos.wustl.edu) of Perl&#160;6. It is easy to see how it would have seemed obvious that Perl&#160;6 would repeat the precedent set by Perl&#160;5, just on a larger scale. Under that understanding, Perl&#160;5 was the maintenance track, the stable version, while Perl&#160;6 was the version under development. That was the future of Perl.
-->

約6年後の2000年(5.0年に到達するまでにかかった期間とほぼ同じ)、若返りの必要性がPerl&#160;6の[始まり](https://www.nntp.perl.org/group/perl.packrats/;msgid=20020729060339.GF11511%40chaos.wustl.edu)につながりました。
Perl&#160;6がPerl&#160;5によって設定された先例を、より大きな規模で繰り返すことが明らかであったことは容易に理解できます。
その理解の下では、Perl&#160;5はメンテナンストラックであり、安定したバージョンであり、Perl&#160;6は開発中のバージョンでした。
それがPerlの未来でした。
(TBR)

<!-- original
The intent was to take the version bump as an opportunity to break compatibility as widely as needed, just once, to fix deeper problems and regularize the language so as to allow it to be defined in terms of itself, laying a solid foundation that would be able to evolve without further fundamental breakage. This was to be the community’s rewrite of Perl.
-->

その意図は、バージョンアップを、必要なだけ広く、一度だけ互換性を破る機会として捉え、より深い問題を修正し、言語自体の観点から定義できるように言語を正規化し、さらなる根本的な破壊なしに進化できる強固な基盤を築くことでした。
これは、コミュニティによるPerlの書き直しでした。
(TBR)

<!-- original
It would not have been apparent at the time that this would iteratively lead to an entirely distinct language. But that’s what it did. Going back to Larry’s 2015 Tolkien talk, one might say that Perl had been Larry’s vision of Unix, and Perl&#160;6 was Larry’s vision of Perl. It is obviously a very closely related language, but in many ways also deeply different.
-->

その時点では、これが完全に異なる言語に反復的につながることは明らかではありませんでした。
しかし、それが行われました。
ラリーの2015年のトールキンの講演に戻ると、PerlはラリーのUnixに対するビジョンであり、Perl&#160;6はラリーのPerlに対するビジョンだったと言えるかもしれません。
Perlは明らかに非常に密接に関連した言語ですが、多くの点で大きく異なります。
(TBR)

<!-- original
It is not tautological that this is equally true in the other direction. Perl&#160;5 suffered significantly from attempts in the 5.10 era to adopt early designs of parts of Perl&#160;6 verbatim. Even all the way back then, the languages were too far apart for this to work. As a result, many of those features had to be (and some are even today still being) laboriously excised again from the language.
-->

これが他の方向にも同じように当てはまるというのは同語反復ではありません。
Perl&#160;5は、5.10年の時代にPerl&#160;6の一部の初期の設計を逐語的に採用しようとした試みから大きな被害を受けました。
当時でさえ、言語はあまりにも離れていたので、これを機能させることはできませんでした。
その結果、これらの機能の多くは、苦労して言語から再び削除されなければなりませんでした(一部は現在でもまだ削除されています)。
(TBR)

<!-- original
In all this meantime it became clear that not everyone was going to adopt the new language, and that the ecosystem of the existing language was going to stick around. There would continue to be interest in Perl&#160;5 evolving for the foreseeable future, even as Perl&#160;6 came into its own. Thus Perl became a family. And that was now its future.
-->

その間に、すべての人が新しい言語を採用するわけではなく、既存の言語のエコシステムが存続することが明らかになりました。
Perl&#160;6が独自のものになったとしても、Perl&#160;5が近い将来に進化することに関心があり続けます。
こうしてPerlはファミリーになりました。
そしてそれが今のPerlの未来です。
(TBR)

<!-- original
Both conceptions of Perl’s future posed problems for the outside perception of Perl&#160;5. Even in the language family framework, though Perl&#160;5 was no longer the eventually-obsolete version, it appeared as the older, wartier, outmoded flavor. (In fact, both conceptions of Perl’s future equally posed problems for the outside perception of Perl&#160;6.)
-->

Perlの将来についての両方の概念は、Perl&#160;5の外部認識に問題を引き起こしました。
言語ファミリーのフレームワークでさえ、Perl&#160;5はもはや最終的に時代遅れのバージョンではありませんでしたが、より古く、より洗練された、時代遅れのフレーバーとして現れました(実際、Perlの将来についての両方の概念は、Perl&#160;6の外部認識にも同様に問題を引き起こしました)。
(TBR)

<!-- original
The community too, mirroring the versions-then-languages themselves, bifurcated, then separated, becoming two somewhat overlapping but distinct communities.
-->

コミュニティもまた、バージョンと言語そのものを反映して、分岐し、その後分離し、やや重複しているが異なる2つのコミュニティになった。
(TBR)

<!-- original
And then, in October 2019, [Perl&#160;6 changed names](https://github.com/Raku/problem-solving/pull/89#pullrequestreview-300789072). Suddenly, it was no longer the future of Perl, in any shape, not even as the more advanced flavor.
-->

そして2019年10月、[Perl&#160;6は名前を変更しました](https://github.com/Raku/problem-solving/pull/89#pullrequestreview-300789072)。
突然、それはもはやPerlの未来ではなく、いかなる形であっても、より高度なフレーバーとしてでさえもそうではなかった。
(TBR)

<!-- original
But Perl&#160;5 is bound to being Perl. It has a present, and a 30-year-long past as Perl&#160;5, but is now again in want of a future, and needs a large correction of its outside perception.
-->

しかし、Perl&#160;5はPerlであることに縛られています。
Perl&#160;5には現在と30年の長い歴史がありますが、今は再び未来がなく、外部の認識を大きく修正する必要があります。
(TBR)

<!-- original
This void has made itself felt already. A first attempt was made to define and release a Perl&#160;7. It did not succeed – which only made Perl’s perception problem worse. And the matter has not gone away. Perl needs a future, and attempts to create one will be made until one of them succeeds.
-->

この空虚さはすでに感じられています。
Perl&#160;7を定義してリリースしようとする最初の試みが行われました。
それは成功しませんでした。
それはPerlの認識の問題を悪化させるだけでした。
そして、問題は解決していません。
Perlには未来が必要であり、そのいずれかが成功するまで、未来を作成しようとする試みが行われます。
(TBR)

## Rationale

<!-- original
Just as Raku has given up on the notion that it was going to be Perl&#160;6, the successor to Perl&#160;5, so Perl needs to give up on the notion of being Perl&#160;5, the predecessor to Perl&#160;6, and claim the name Perl back for itself.
-->

RakuがPerl&#160;5の後継であるPerl&#160;6であるという概念を放棄したように、PerlはPerl&#160;6の前身であるPerl&#160;5であるという概念を放棄し、Perlという名前を取り戻す必要があります。
(TBR)

<!-- original
We have an opportunity then to look back and recognize that Perl never did stand still. It has continued to change its present, one moment at a time, unwinding more of its story in the process. It has unassumingly been heading into its own future all along, merely obscured in this by the drawn-out separation from Raku and the necessity of clinging to being Perl&#160;5 in the meantime. From a pre-5.0 perspective, there was no reason not to keep increasing the major version number.
-->

その後、振り返って、Perlが決して立ち止まっていなかったことを認識する機会があります。
Perlは、その過程でより多くのストーリーを巻き戻しながら、一度に一瞬ずつ現在を変え続けてきました。
Perlは、Rakuとの長期にわたる分離と、その間にPerl&#160;5であることに固執する必要性によって、この中で単に隠されているだけで、最初から控えめに独自の未来に向かっていました。
5.0以前の観点からは、メジャーバージョン番号を増やし続けない理由はありませんでした。
(TBR)

<!-- original
And so that is the proposal. The next release will not be Perl&#160;5.42 but simply Perl&#160;42 – which is none other than what it really was anyway. There is no difference between them except in our self-understanding. What this is is a reclaiming of Perl’s history.
-->

これが提案です。
次のリリースはPerl&#160;5.42ではなく、単にPerl&#160;42です。
これはいずれにしても実際のものに他なりません。
私たちの自己理解以外には、それらの間に違いはありません。
これはPerlの歴史の再生です。
(TBR)

<!-- original
The pace of changes did decrease after 5.0, relative to before, but the reason was the much greater potential of its new facilities, and the realization of that potential through CPAN, which allowed the language to fill new niches without necessitating changes to its core. The reason that the transition from Perl&#160;5 to Perl&#160;6 failed to materialize when the one from Perl&#160;4 to Perl&#160;5 succeeded so thoroughly lies with their respective combinations of continuity and discontinuity. Perl&#160;5 had a real implementation fairly soon, at which point development of Perl&#160;4 ended, and despite truly being a new and more powerful language, Perl&#160;5 was almost entirely a superset of Perl&#160;4. So the community could and did simply move to Perl&#160;5 when Perl&#160;4 ended. Perl&#160;5 never came to an end because Perl&#160;6 took a long time to be implemented, and by that time it had become a different language which simply could not have absorbed the existing Perl&#160;5 community outright. Subsequent attempts have borne out this requirement for language continuity: [Kurila](https://github.com/ggoossen/kurila), [Moe](https://github.com/MoeOrganization/moe), and despite its much smaller ambitions, Perl&#160;7 too, all ultimately failed to gain traction. Meanwhile, in the perl interpreter, new internal APIs have come along and made it possible to extend the language in previously impossible ways – on CPAN, making CPAN a still more powerful venue to extend the reach of the language from outside itself. And eventually we even learned how to undo old mistakes without disruptions: by naming them with feature flags to be turned off under future feature bundles.
-->

変化のペースは5.0年以降、以前と比較して減少したが、その理由は、その新しい機能の可能性がはるかに大きいことと、CPANを通じてその可能性が実現されたことであり、CPANはそのコアを変更することなく新しいニッチを埋めることができた。
Perl&#160;4からPerl&#160;5への移行が完全に成功したときに、Perl&#160;5からPerl&#160;6への移行が実現しなかった理由は、それぞれの連続性と不連続性の組み合わせにあります。
Perl&#160;5はかなり早く実際に実装され、その時点でPerl&#160;4の開発は終了し、真に新しくより強力な言語であるにもかかわらず、Perl&#160;5はほぼ完全にPerl&#160;4のスーパーセットでした。
そのため、コミュニティはPerl&#160;4が終了したときにPerl&#160;5に移行することができ、実際に移行しました。
Perl&#160;5は、Perl&#160;6が実装されるのに長い時間がかかり、その時までに既存のPerl&#160;5コミュニティを完全に吸収することができなかった別の言語になっていたため、終了することはありませんでした。
その後の試みは、言語の継続性に対するこの要件を実証しました:[Kurila](https://github.com/ggoossen/kurila)、[Moe](https://github.com/MoeOrganization/moe)、そしてそのはるかに小さな野心にもかかわらず、Perl&#160;7も、最終的にはすべて牽引力を得ることができませんでした。
一方、Perlインタプリタでは、新しい内部APIが登場し、以前は不可能だった方法でCPAN上で言語を拡張することが可能になり、CPANは言語の範囲を外部から拡張するためのさらに強力な場所になりました。
そして最終的には、混乱することなく古い間違いを元に戻す方法さえ学びました。
将来の機能バンドルでオフにされる機能フラグで名前を付けることです。
(TBR)

<!-- original
That is the future. Perl will not have a successor. It will not break with its past. It will keep moving forward the same way it always has: sometimes with substantial changes; often with minor ones; occasionally with breaking changes, but always deliberately and circumspectly.
-->

それが未来です。
Perlには後継者がいません。
過去と決別することはありません。
これまでと同じように前進し続けます。
時には大幅な変更を加え、時には小さな変更を加え、時には破壊的な変更を加えますが、常に意図的かつ慎重に行います。
(TBR)

<!-- original
Relations between Perl and Raku may (and should, and hopefully will) adjust to each other’s new self-understanding. In time, the family should rebalance into a new equilibrium, as family systems do. Perl and Raku can and should stay in touch and take inspiration from each other, even if each needs its features designed for cohesion with its own overall design.
-->

PerlとRakuの関係は、お互いの新しい自己理解に合わせて調整される可能性があります(また、調整されるべきであり、願わくば調整されるでしょう)。
やがて、家族は、家族システムがそうであるように、新しい均衡に再調整されるべきです。
PerlとRakuは、それぞれが独自の全体的な設計との結合のために設計された機能を必要とする場合でも、連絡を取り合い、お互いからインスピレーションを得ることができ、またそうすべきです。
(TBR)

<!-- original
This type of re-versioning has some precedents:
-->

このタイプの再バージョン管理には、いくつかの先例があります。
(TBR)

<!-- original
* Java&#160;1.4 was followed by Java&#160;5. The technical details of that transition differ from what is proposed here, but even there we have a parallel between how Java&#160;5 was mostly still 1.5 internally and how this proposal deals with XS code. Lessons can be had from the unlikeliest of sources.
* For some readers, the relation between Solaris&#160;7 to SunOS&#160;5.7 and onward may come to mind (although the relationship between Solaris and SunOS in earlier versions is messier).
* Having undergone this change, our versioning cadence will match the one followed by Node.js, with a new odd and even version every year, denoting a new development and stable release. Javascript was influenced more than a little by Perl, so this is not such unlikely company as may today seem.
-->

* Java&#160;1.4の後にJava&#160;5が続きました。
この移行の技術的な詳細はここで提案されているものとは異なりますが、Java&#160;5が内部的にまだ1.5であった方法と、この提案がXSコードを処理する方法との間には類似点があります。
教訓は、最もありそうもない情報源から得ることができます。
* 一部の読者にとっては、Solaris&#160;7とSunOS&#160;5. 7以降との関係が思い浮かぶかもしれません(ただし、以前のバージョンでのSolarisとSunOSの関係はより複雑です)。
* この変更を受けて、私たちのバージョン管理ケイデンスはNode.jsに続くものと一致し、毎年新しい奇数バージョンと偶数バージョンがあり、新しい開発と安定したリリースを示しています。
JavascriptはPerlの影響を少なからず受けているので、これは今日考えられているほどありそうもない会社ではありません。
(TBR)

<!-- original
Version 42 specifically is a particularly compelling point in time at which to do this, and not just for the Douglas Adams reference which will be evident even to Perl outsiders: there are further points of significance within Perl culture too, particularly when it comes to versions: 42 happens to be 6 &times; 7; ASCII character 42 (and thus the v-string `v42`) happens to be `*`. From a technical perspective, it is also opportune to undergo this transition well before version 48, at which point the fact that `v48 eq '0'` (and `v50 eq '2'` etc.) might cause unanticipated heartburn – so it is useful to have time to have any potential fallout sorted out well ahead of that.
-->

バージョン42は、特にこれを行うのに特に説得力のある時点であり、Perlの部外者にさえ明らかになるダグラスアダムズの参照のためだけではありません。
Perl文化の中にも、特にバージョンに関しては、さらに重要なポイントがあります。
42はたまたま6&times;7;ASCII文字42(したがってv文字列`v42`)はたまたま`*`です。
技術的な観点からは、バージョン48よりもかなり前にこの移行を行うのも適切です。
バージョン48の時点では、`v48 eq'0'`(および`v50 eq'2'`)が予期しない胸やけを引き起こす可能性があるため、そのかなり前に潜在的な影響を整理する時間を持つことが有用です。
(TBR)

<!-- original
Note that among approaches for increasing the major version number of Perl, this one is least costly: because it can be implemented while leaving the `PERL_REVISION` XS symbol unchanged, it does not require updating a lot of XS code which would otherwise break. Any other approach will break all that XS code in addition to any other breakage it may cause, which almost certainly will include all of the breakage of this proposal. So if going to version 42 is not feasible due to the amount of breakage, then going to any other version will be much less feasible still, and Perl will have to remain Perl&#160;5 forever.
-->

Perlのメジャーバージョン番号を増やすためのアプローチの中で、これは最もコストがかからないことに注意してください。
これは、`PERL_REVISION`XSシンボルを変更せずに実装できるため、そうしないと壊れてしまうような多くのXSコードを更新する必要がありません。
他のアプローチは、それが引き起こす可能性のある他の破損に加えて、すべてのXSコードを破損します。
これには、ほぼ確実に、この提案の破損のすべてが含まれます。
したがって、破損の量のためにバージョン42に移行することが実行可能でない場合、他のバージョンに移行することは依然として実行可能ではなく、Perlは永遠にPerl&#160;5のままでなければなりません。
(TBR)

## Specification

<!-- original
In the next release of Perl, `perl -v` will not say “Perl 5 version 42 subversion 0” but simply “Perl version 42.0”.
-->

Perlの次のリリースでは、`perl-v`は"Perl 5 version 42 subversion 0"ではなく、単に"Perl version 42.0"と表示します。
(TBR)

<!-- original
The value of `$]` will be simply 42 and `$^V` will be equal to `v42.0`. In future, the version of Perl will only have a major and minor component. 42.1 will have `$]` as 42.001 and `$^V` as `v42.1`.
-->

`$]`の値は42となり、`$^V`は`v42.0`と等しくなります。
将来的には、Perlのバージョンにはメジャーとマイナーのコンポーネントしかありません。
42.1では、`$]`は42.001、`$^V`は`v42.1`となります。
(TBR)

<!-- original
For XS code, nothing changes at all. `PERL_REVISION` continues to exist and its value continues to be 5, forever. Only `PERL_VERSION` and `PERL_SUBVERSION` are relevant going forward.
-->

XSコードでは何も変わりません。
`PERL_REVISION`は存在し続け、その値は永遠に5のままです。
今後は`PERL_VERSION`と`PERL_SUBVERSION`のみが関連します。
(TBR)

<!-- original
A number of new environment variables are introduced which supersede existing environment variables if present:
-->

いくつかの新しい環境変数が導入され、既存の環境変数が存在する場合はそれに取って代わります。
(TBR)

<!-- original
* `PERL5LIB` → `PERL_LIB` (but cf. [Open Issues](#open-issues) regarding this one)
* `PERL5OPT` → `PERL_OPT`
* `PERL5DB` → `PERL_DB`
* `PERL5DB_THREADED` → `PERL_DB_THREADED`
* `PERL5SHELL` → `PERL_SHELL`
-->

* `PERL5LIB` → `PERL_LIB`(ただし、これに関しては[Open Issues](#open-issues)を参照)
* `PERL5OPT` → `PERL_OPT`
* `PERL5DB` → `PERL_DB`
* `PERL5DB_THREADED` → `PERL_DB_THREADED`
* `PERL5SHELL` → `PERL_SHELL`
(TBR)

<!-- original
As a result, all Perl environment variables except `PERLIO` now follow the pattern `PERL_*`.
-->

その結果、`PERLIO`を除くすべてのPerl環境変数は、パターン`PERL_*`に従うようになりました。
(TBR)

<!-- original
Finally, we edit the documentation to no longer advertise the use of a v-string on the `use VERSION` line. (Cf. [Examples](#examples))
-->

最後に、文書を編集して、`use VERSION`行でv-stringの使用をアドバタイズしないようにします([Examples](#examples)を参照)。
(TBR)

<!-- original
PAUSE and MetaCPAN must be made aware of the new versioning cadence.
-->

PAUSEとMetaCPANは、新しいバージョン管理ケイデンスを認識する必要があります。
(TBR)

<!-- original
At some point, `INSTALL_BASE` should be discouraged (though remain supported indefinitely) and supplanted by a new option which does not contain the hard-coded `perl5` segment. It should then also be made to install to a path containing the full perl version, to solve problems with switching between versions. Ideally this will be in 42.0 but it can follow later.
-->

ある時点で、`INSTALL_BASE`は(無期限にサポートされていますが)推奨されなくなり、ハードコードされた`perl5`セグメントを含まない新しいオプションに置き換えられるべきです。
その後、バージョン間の切り替えに関する問題を解決するために、完全なperlバージョンを含むパスにインストールされるようにする必要があります。
理想的には、これは42.0年になりますが、後で行うことができます。
(TBR)

## Backwards Compatibility

<!-- original
This proposal introduces no new syntax or semantics.
-->

この提案では、新しい構文やセマンティクスは導入されていない。
(TBR)

<!-- original
Adjustments will be required in code which parses the output of `perl -v`/`perl -V` and Perl code which expects `$]` and `$^V` to always be of a 5.x form, or always have three components.
-->

`perl-v`/`perl-V`の出力を解析するコードと、`$]`と`$^V`が常に5.x形式であるか、常に3つのコンポーネントを持つことを期待するPerlコードでは、調整が必要になります。
(TBR)

<!-- original
XS code is almost entirely unaffected because the `PERL_REVISION` `PERL_VERSION` `PERL_SUBVERSION` symbols continue to exist and continue to change values exactly as they have been doing all along. Only XS code which tries to reconstruct the values of `$]` or `$^V` (or some facsimile of them) from those symbols will now be incorrect and will have to be adjusted.
-->

XSコードは、`PERL_REVISION``PERL_VERSION``PERL_SUBVERSION`シンボルが存在し続け、これまでとまったく同じように値を変更し続けているため、ほとんどまったく影響を受けません。
これらのシンボルから`$]`または`$^V`の値(またはそれらの複製)を再構築しようとするXSコードのみが正しくなくなり、調整する必要があります。
(TBR)

<!-- original
Code that unsets `PERL5*` environment variables will technically become broken by this change and will have to be fixed to also unset `PERL_*`. But this breakage is not going to manifest widely in practice until sometime down the line; also, it is probably almost entirely down to `PERL5OPT` and `PERL5LIB`, as well as likely mainly being down to parts of the ecosystem which are visible to us on CPAN and can therefore be updated.
-->

`PERL5*`環境変数を設定解除するコードは、技術的にはこの変更によって破壊され、`PERL_*`も設定解除するように修正する必要があります。
しかし、この破壊はいつかまで実際に広く現れることはありません。
また、おそらくほぼ完全に`PERL5OPT`と`PERL5LIB`に依存しており、CPANで見ることができ、したがって更新できるエコシステムの一部に依存している可能性があります。
(TBR)

<!-- original
Code that cares about the paths to installed modules will have to be made aware of the new variant of `INSTALL_BASE` and its resulting directory structure, once that comes into play.
-->

インストールされたモジュールへのパスを気にするコードは、新しい種類の`INSTALL_BASE`とその結果のディレクトリ構造を認識する必要があります。
(TBR)

## Security Implications

<!-- original
There is a very marginal possibility that  code which does not expect a Perl revision other than 5 might present an opportunity for some kind of exploitation.
-->

5以外のPerlリビジョンを想定していないコードが、ある種の悪用の機会を提供する可能性はごくわずかです。
(TBR)

## Examples

`use 42;`

<!-- original
Note that a v-string is not used. A v-string is how you can write `use v5.40` rather than the less readable `use 5.040`, where the important part is noisier – namely the version, 40, rather than the more prominent revision, 5. Without the revision, the version becomes the integer part and thus no longer requires padding. The subversion becomes the fractional part behind the first dot, with no need for a second dot – however, specifying a subversion on the `use VERSION` line no longer comes up anyway, because feature bundles are not subversion-specific and Perl point releases have long since lost the longevity and prominence they had in the 5.6/5.8/5.10 era. (If you were to need to specify a subversion, then without a v-string you would still have to write e.g. `use 42.001`, which is not as nice as `use v42.1` – but this is now academic.) Thus the need for a v-string goes away in practice. This also means Perl novices are no longer immediately confronted with them.
-->

v-stringが使用されていないことに注意してください。
v-stringは、読みにくい`use 5. 40`ではなく`use v5.040`を記述する方法です。
ここでは、重要な部分はノイズが多く、つまり、より顕著なリビジョンである5ではなく、バージョン40です。
リビジョンがない場合、バージョンは整数部分になるため、パディングは必要ありません。
サブバージョンは最初のドットの後ろの小数部分になり、2番目のドットは必要ありません。
しかし、`use VERSION`行でサブバージョンを指定することは、もはや表示されません。
なぜなら、機能バンドルはサブバージョン固有ではなく、Perlのポイントリリースは5. 6/5. 8/5. 10時代のような寿命と知名度を失って久しいからです。
(サブバージョンを指定する必要がある場合、v-stringがなくても、例えば`use 42.001`と記述する必要があります。
これは`use v42.1`ほど良くありませんが、これは今では学術的です。
)したがって、v-stringの必要性は実際にはなくなります。
これは、Perlの初心者がすぐにそれらに直面しなくなったことも意味します。
(TBR)

## Prototype Implementation

<!-- original
None.
-->

ありません。
(TBR)

## Future Scope

<!-- original
Hopefully none. This proposal is a recognition that what we have long been doing has already been what Perl needed, and it was the language siblings relationship that needed to sort itself out and settle in. Perl will continue to be Perl even as the language grows and changes with the times.
-->

うまくいけばありません。
この提案は、私たちが長い間行ってきたことはすでにPerlが必要としていたことであり、それ自体を整理して定着させる必要があったのは言語の兄弟関係であったという認識です。
Perlは、言語が成長し、時代とともに変化しても、Perlであり続けるでしょう。
(TBR)

## Rejected Ideas

<!-- original
There are some alternative approaches we could take:
-->

他にもいくつかの方法があります。
(TBR)

<!-- original
1. Continue with Perl&#160;5.x indefinitely
-->

1. Perl&#160;5.xを無期限に使い続ける
(TBR)

   <!-- original
   We might decide on this option because we aren't going to change the language substantially, and there are technical complications in changing the version. But this would not address the perception issue, and the non-change nature of this approach leaves the version number issue open to renewed future challenge.
   -->

   言語を大幅に変更するつもりはなく、バージョンの変更には技術的な複雑さがあるため、このオプションを決定する可能性があります。
   しかし、これは認識の問題に対処するものではなく、このアプローチの非変更の性質により、バージョン番号の問題は将来の新たな課題に対して開かれたままになります。
   (TBR)

<!-- original
2. Move to Perl&#160;7 immediately
-->

2. すぐにPerl&#160;7に移行する
(TBR)

   <!-- original
   We might decide on this option because we are continuing to evolve the language anyway, so now that Perl&#160;6 is no longer in play, we are free to just bump the major version, and there are plenty of differences to Perl&#160;5.0 to justify a new major version. This is a viable option, but the technical costs (mainly due to XS version checking) are somewhat significant, and we take them on in exchange for nothing in particular. The outside-world optics of this would be odd, with the version finally moving beyond 5 after almost 30 years, but for no apparent reason. (Even when Perl&#160;3 was rebadged as Perl&#160;4, it was because of the Camel book.) And internally, this lack of apparent reason also leaves us with an entirely open question regarding how we should decide when to bump the version again, to 8 and beyond, putting us back in the same position regarding the version some time down the line as we are today.
   -->

   私たちがこのオプションを決定するかもしれないのは、私たちがとにかく言語を進化させ続けているので、Perl&#160;6がもはや機能しなくなった今、私たちはメジャーバージョンをバンプするだけで自由になり、新しいメジャーバージョンを正当化するためにPerl&#160;5.0とは多くの違いがあります。
   これは実行可能なオプションですが、技術的なコスト(主にXSのバージョンチェックによる)はいくらか大きく、私たちは特別なものと引き換えにそれらを引き受けます。
   これの外の世界の見方は奇妙で、バージョンは約30年後に最終的に5を超えますが、明らかな理由はありません。
   (Perl&#160;3がPerl&#160;4にバッジ変更されたときでさえ、それはCamelの本のためでした。
   )そして内部的には、この明らかな理由の欠如は、バージョンを再び8以降にバンプするタイミングをどのように決定すべきかについての完全に未解決の問題を私たちに残し、今日のように将来のバージョンに関して同じ立場に私たちを戻します。
   (TBR)

<!-- original
3. Move to Perl&#160;7 based on some headline feature (such as a new object system)
-->

3. 見出しの機能(新しいオブジェクトシステムなど)に基づいてPerl&#160;7に移行する
(TBR)

   <!-- original
   This has the same technical costs as moving to Perl&#160;7 generally, but the outside-world optics of the move are less strange. However, the feature then needs to be big enough to justify a bump in this way, lest it be perceived as a PR stunt for repackaging mostly-same-old as a major new version. And it does not set a precedent for when the version is to be bumped, opening up a future debate about whether changes are big enough to warrant a bump, and creating indirect pressure to introduce big headlining features every so often in order to justify a bump to avoid a renewed perception of stagnation. In the same vein, as already experienced before, with this type of version bump, there will be strong temptation to include breaking changes within its scope, every single time a new one happens – not just because of the seeming opportunity to clean house, but partly also because a perceived need to break certain things more easily makes the case for bumping the version.
   -->

   これには一般的にPerl&#160;7への移行と同じ技術的コストがかかりますが、この移行の外部からの見方はそれほど奇妙ではありません。
   しかし、この機能は、この方法でバンプを正当化するのに十分な大きさである必要があります。
   これは、メジャーな新バージョンとほぼ同じ古いものを再パッケージ化するためのPRスタントとして認識されないようにするためです。
   また、バージョンがバンプされる時期の先例を作るものではなく、バンプを正当化するのに十分な大きさの変更があるかどうかについての将来の議論を開き、停滞の新たな認識を避けるためにバンプを正当化するために、時々大きなヘッドライニング機能を導入する間接的な圧力を生み出します。
   同じように、以前に経験したように、このタイプのバージョンバンプでは、新しいものが発生するたびに、その範囲内に破壊的な変更を含める強い誘惑があります。
   これは、家をきれいにする機会があるように見えるからだけでなく、特定のものをより簡単に破壊する必要性が認識されているため、バージョンをバンプする理由にもなります。
   (TBR)

<!-- original
Moving to version 42 combines (hopefully the best) aspects of all of these options. It retains a lot of the technical non-cost of option 1, by being essentially indistinguishable from option 1 at the XS level. Outwardly it is closest to option 2, in that the version changes without being motivated by a particular headlining feature, but unlike option 2, it does address the optics of changing the version. It just does so in a very different way from option 3: rather than justifying the bump by making big changes to the language, it highlights the fact that important changes have already been happening and the language has already been evolving, all along.
-->

バージョン42への移行は、これらすべてのオプションの(できれば最高の)側面を組み合わせたものです。
XSレベルではオプション1と本質的に区別できないため、オプション1の技術的な非コストの多くを保持しています。
外見上はオプション2に最も近く、特定のヘッドライニング機能によって動機付けられることなくバージョンが変更されますが、オプション2とは異なり、バージョンを変更するという観点に対処します。
オプション3とはまったく異なる方法でそれを行います:言語に大きな変更を加えてバンプを正当化するのではなく、重要な変更がすでに発生しており、言語がすでに進化しているという事実を強調します。
(TBR)

## Open Issues

<!-- original
1. The environment variable superseding leaves us with an awkward priority cascade for `PERL_LIB` > `PERL5LIB` > `PERLLIB`. However, the last one of these is already mainly historical.
-->

1. 環境変数の置き換えにより、`PERL_LIB` > `PERL5LIB` > `PERLLIB`に対する厄介な優先度カスケードが残ります。
しかし、これらのうち最後のものはすでに主に歴史的なものである。
(TBR)

   <!-- original
   Maybe we want to reuse `PERLLIB` by flipping the priorities instead of introducing `PERL_LIB`. In that case maybe the counterpart to `PERL5OPT` should be named `PERLOPT`, not `PERL_OPT`, given that these two variables are somewhat complementary. But this would miss the opportunity to tidy things up into “everything is named `PERL_*` (except `PERLIO`)”.
   -->

   `PERL_LIB`を導入するのではなく、優先順位を反転させて`PERLLIB`を再利用したいと思うかもしれません。
   その場合、`PERL5OPT`に対応するものは`PERL_OPT`ではなく`PERLOPT`と名付けられるべきかもしれません。
   これら2つの変数がある程度相補的であることを考えると。
   しかし、これは物事を整理して「すべてが`PERL_*`と名付けられています(`PERLIO`を除く)」にする機会を逃すことになります。
   (TBR)

   <!-- original
   Maybe we want to just remove `PERLLIB`.
   -->

   単に`PERLLIB`を削除したいだけかもしれません。
   (TBR)

   <!-- original
   Maybe we just shrug and accept the awkwardness.
   -->

   私たちは肩をすくめて気まずさを受け入れるだけかもしれません。
   (TBR)

<!-- original
1. Something needs to be done about version.pm presuming three components to a version number:
-->

1. バージョン番号に3つのコンポーネントを仮定して、version.pmに対して何かを行う必要があります:
(TBR)

   ````
   perl -E 'say version->parse( 42.0 )->normal'
   v42.0.0
   ````

<!-- original
1. What do we do about the [perl5.git](https://github.com/Perl/perl5) repository name?
-->

1. [perl5.git](https://github.com/Perl/perl5)リポジトリ名についてはどうすればよいですか?
(TBR)

<!-- original
1. What do we do with the [perl5-porters@](mailto:perl5-porters@perl.org) list name? (Probably make it an alias and switch to a new primary list name?) The same question applies to a handful of other lists ([perl5-changes@](mailto:perl5-changes@perl.org) et al). This is anything but urgent.
-->

1. [perl5-porters@](mailto:perl5-porters@perl.org)リスト名をどうするか?(おそらくエイリアスにして、新しいプライマリリスト名に切り替えるのでしょうか?)同じ質問は、他のいくつかのリスト([perl5-changes@](mailto:perl5-changes@perl.org)など)にも当てはまります。
これは決して緊急ではありません。
(TBR)

## History / Acknowledgements

<!-- original
It all began as [a tongue-in-cheek remark on Reddit](https://www.reddit.com/r/perl/comments/1f9bbhy/other_than_raku_are_there_any_serious_plans_for_a/llvsfjc/?context=3). The details of the [Specification](#specification) owe much to Graham Knop and the [Rationale](#rationale) to Philippe Bruhat, who as co-members of the PSC both contributed to thoughts across the entire document and eventually proofread it. After weeks of deliberation, the Motivation section finally crystallized during a cold early morning walk on Nov 13, 2024 and turned into writing on a riverside bench overlooking the Rhine.
-->

すべては[Redditでの皮肉な発言](https://www.reddit.com/r/perl/comments/1f9bbhy/other_than_raku_are_there_any_serious_plans_for_a/llvsfjc/?context=3)として始まった。
[Specification](#specification)の詳細はGraham Knopに、[Rationale](#rationale)はフィリップBruhatに負うところが大きい。
彼はPSCの共同メンバーとして、文書全体の考え方に貢献し、最終的には文書を校正した。
数週間の審議の後、2024年11月13日の早朝の冷たい散歩の間に、動機のセクションは最終的に具体化し、ライン川を見下ろす川沿いのベンチで書くようになった。
(TBR)

## Copyright

Copyright (C) 2024, Aristotle Pagaltzis

This document and code and documentation within it may be used, redistributed and/or modified under the same terms as Perl itself.

<!--meta
Translate: SHIRAKATA Kentaro <argrath@ub32.org>
Status: in progress
-->