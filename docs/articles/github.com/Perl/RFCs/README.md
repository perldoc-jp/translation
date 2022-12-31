# Perl/RFCs/README の翻訳

この文書は、[Perl/RFCs/README](https://github.com/Perl/RFCs/README.md)を翻訳したものです。

<!-- original
This repository is for *Requests For Comments* - proposals to change the Perl language.
-->

このリポジトリは、**リクエスト・フォー・コメンツ**です。 - Perl言語を変更するための提案

<!-- original
Right now, we're [trialling the process](docs/process.md). If you would like to submit a feature request, please [email an *elevator pitch*](mailto:perl5-porters@perl.org) - a short message with 4 paragraphs:
-->

現在、私たちは[このプロセスを試しています](https://github.com/Perl/RFCs/docs/process.md)。機能要求を送る場合は、次の4項目を簡潔にまとめた[エレベーターピッチをメール](mailto:perl5-porters@perl.org)してください。

<!-- original
1. Here is a problem
2. Here is the syntax that I'm proposing
3. Here are the benefits of this
4. Here are potential problems
-->

1. どこが問題か
2. 提案する構文
3. そのメリット
4. 潜在的な問題点

<!-- original
and if a "paragraph" is 1 sentence, great.
-->

この"項目"が、1文なら素敵です。

<!-- original
That will be enough to make it obvious whether the idea is
-->

このようにすることで、そのアイデアが次のいずれかであることが明確になります。

<!-- original
0) actually a **bug** - a change we'd also consider back porting to maintenance releases (so should be a opened as [*Report a Perl 5 bug*](https://github.com/Perl/perl5/issues/new/choose))
0) worth drafting an RFC for
0) better on CPAN first
0) "nothing stops you putting it on CPAN, but it doesn't seem viable"
-->


0) 実際に**バグ**である - メンテナンスリリースへの変更も考慮すべき変更（そのため、*[Report a Perl 5 bug*](https://github.com/Perl/perl5/issues/new/choose)のようにオープンであるべき）
0) RFCを作成する価値がある
0) まずCPANに置いた方が良い
0) "CPANに置くことを止められないが、実現できるとは思えない"

<!-- original
You don't need to subscribe to the list to send an idea (or see updates). By keeping all discussion there during the trial, we can see if the process works as hoped, and fix the parts that don't.
-->

アイデアの送付（や更新を閲覧）するためにメーリングリストを購読する必要はありません。検討期間中に全ての議論をそこで行うことで、プロセスが期待通りに動くかどうか確認でき、またそうでない部分は修正できます。

<!-- original
Please **don't** submit ideas as *issues* or *PRs* on this repository. (We can disable issues, but not PRs). Please follow the instructions above.
-->

このリポジトリの**issues**や**PRs**に、でアイデアを**送らないでください**。（issuesの無効化はできますが、PRはできません。）上記の手順でお願いします。

<!-- original
These files describe the process we are trialling
-->

次のファイルには、試験中のこのRFCsのプロセスについて記載しています。

<!-- original
* [motivation.md](docs/motivation.md) - why do we want to do something
* [process.md](docs/process.md) - the initial version of the process
* [template.md](docs/template.md) - the RFC template
* [future.md](docs/future.md) - how we see the process evolving
* [others.md](docs/others.md) - what others do (or did), and what we can learn from them
-->

* [motivation.md](docs/motivation.md) - 何がしたいのか
* [process.md](docs/process.md) - このプロセスの初期バージョン
* [template.md](docs/template.md) - このRFCのテンプレート
* [future.md](docs/future.md) - このプロセスの今後のイメージ
* [others.md](docs/others.md) - what others do (or did), and what we can learn from them

<!-- original
## The Tracker
-->

## トラッカー

<!-- original
The status of proposals is tracked in "[the RFC
Tracker](https://docs.google.com/spreadsheets/d/1hVOS7ePuLbVkYcf5S-e_eAodj4izm9Cj7AVs25HvngI)",
a Google Sheets spreadsheet.  Keep up to date there!
-->

提案のステータスは、次のスプレッドシートで追跡できます。[the RFC
Tracker](https://docs.google.com/spreadsheets/d/1hVOS7ePuLbVkYcf5S-e_eAodj4izm9Cj7AVs25HvngI) ここで最新の情報を入手しましょう！
