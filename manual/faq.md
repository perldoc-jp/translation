# FAQ

## 翻訳への参加について

### コミット権限をもらうには？

[コミット権限のリクエスト](https://github.com/perldoc-jp/wg-perl-document/issues/28)を参照してください。

PR を送ってもしれっと追加してもらえるようです！

### 英語はあまり得意ではないのですが翻訳に参加できますか？

他の人が訳したものの査読（誤変換のチェックやわかりやすい日本語への修正）など様々な作業があるので是非参加してください。

### 翻訳について、オリジナルの著者への報告は必要ですか？

ほとんどの CPAN モジュールが改変と再配布が許可されているライセンスなので、元々のドキュメントの著者に翻訳の報告をする必要はありません。ライセンスが不明な場合や、改変と再配布が許可されていないライセンスの場合には、著者に連絡を取ってください。

## 翻訳作業に関して

### 翻訳の流れはどのようになっていますか？

翻訳の基本的な流れは次の通りです。

1. すでに翻訳が存在するかどうかは [https://perldoc.jp/](https://perldoc.jp/) で検索する
2. 翻訳の修正や追加
  - このリポジトリの書き込み権限がない方は、[この translation](https://github.com/perldoc-jp/translation) を fork して PR を送る。
  - このリポジトリの書き込み権限がある方は、PRを送るか、あるいは、直接修正をしてください。
  - 詳しくは、[チュートリアル](https://github.com/perldoc-jp/translation/blob/master/manual/translation-tutorial.md)を参照ください。

以上です。PRがマージされたら、perldoc.jpに反映されます。

[翻訳作業自体の作法はこちらに詳細なドキュメント](https://github.com/perldoc-jp/translation/blob/master/manual/translation-manners.md)があります。

### 質問はどこでできますか？

Discordの翻訳チャンネルを気軽にご利用ください。https://discord.gg/bSJtUYPGcb

### 訳語の対訳表はありますか？

次を参照してください。
-  https://github.com/perldoc-jp/translation/blob/master/manual/translation-table.md

### 文字コードは何を使えばいいですか？

新規で追加する場合は、UTF-8を利用してください。
既存のファイルを編集する場合、そのファイルの文字コードにあわせてください。

### モジュール作成者に翻訳物の公開の是非について問い合わせるべきですか？

モジュールのライセンス次第です。Perl モジュールは Perl と同じライセンス（ Artistic License と GPL のデュアルライセンス）を適用されることが多く、それらのライセンスであれば翻訳物の公開はライセンス上許可されています。ですから、許可を得る必要はありません。ただ、翻訳したことを伝えることはやった方が望ましいです。


## 翻訳への要望

### 翻訳して欲しいモジュールがあるんですけど、そのようなリクエストは受け付けてますか？

要望はDiscordで声をかけてみてください。運が良ければ誰かが訳してくれることでしょう。但し、誰も訳してくれなかったからといって怒らないでね。
他には、次のようなDiscussionに参加するのも手です。

- [翻訳したら良さそうなCPANモジュールについて](https://github.com/perldoc-jp/translation/discussions/39)

### 誤字を見つけたのですがどうすればよいですか？

ぜひプルリクエストを送ってください！コミット権限があれば、勝手に修正して大丈夫です。

## 成果物に関して

### 翻訳された文章はどこで閲覧できますか？

[perldoc.jp](https://perldoc.jp/)を参照するか、このリポジトリを参照してください。

### 翻訳された文章の全文検索は行えますか？

2023年10月現在、全文検索の機能は提供されていません。Googleなどの検索エンジンでドメイン指定で perldoc.jp などを対象に検索してみてください。

## その他

### Japanized Perl Resources Project(JPRP)とは何ですか？

2023年9月まで利用されていた翻訳プロジェクトです。現在は利用していません。
[Japanized Perl Resources Project (JPRP)](https://perldocjp.osdn.jp/)

