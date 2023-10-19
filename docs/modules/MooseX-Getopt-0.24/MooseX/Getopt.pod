=head1 NAME

MooseX::Getopt - コマンドライン引数を処理するためのロール

=head1 SYNOPSIS

  ## In your class
  package My::App;
  use Moose;

  with 'MooseX::Getopt';

  has 'out' => (is => 'rw', isa => 'Str', required => 1);
  has 'in'  => (is => 'rw', isa => 'Str', required => 1);

  # ... rest of the class here

  ## in your script
  #!/usr/bin/perl

  use My::App;

  my $app = My::App->new_with_options();
  # ... rest of the script here

  ## on the command line
  % perl my_app_script.pl -in file.input -out file.dump

=head1 DESCRIPTION

このロールはコマンドライン引数からオブジェクトを生成するための代替コンストラクタを提供します。

このモジュールはオブジェクトのアトリビュートの定義を元に可能な限り自然にコマンドライン引数からその値の初期値を設定します。アトリビュートの名前はコマンドライン引数の名前となり、そのアトリビュートに型制約がある場合はそれを使用してC<Getopt::Long>の設定がなされます。

この挙動についてさらに細かい設定を行いたい場合はL<MooseX::Getopt::Meta::Attribute::Trait>か、:<MooseX::Getopt::Meta::Attribute>を参照してください。

特定のアトリビュートをコマンドライン引数から設定I<不可能>にしたい場合はL<MooseX::Getopt::Meta::Attribute::Trait::NoGetopt>かL<MooseX::Getopt::Meta::Attribute::NoGetopt>を参照してください。

また、デフォルトではアンダースコア（「_」）で始まるアトリビュートはアトリビュートのメタクラスにL<MooseX::Getopt::Meta::Attribute>が指定されていない限りはコマンドラインからの処理がされません。そのようなアトリビュートのアクセッサもアンダースコア付きにしたくない場合は以下のようにできます：

  # 読み込み／書き込みアトリビュートの場合
  has '_foo' => (accessor => 'foo', ...);

  # 読み込み専用アトリビュートの場合
  has '_bar' => (reader => 'bar', ...);

このようにすることでGetoptは--foo引数を適用しなくなりますが、C<foo>メソッドは使用できるようになります。

もし該当クラスがL<MooseX::SimpleConfig>のようなL<MooseX::ConfigFromFile>ベースの設定ファイルを使うロールを使用している場合は、L<MooseX::Getopt>のC<new_with_options>はC<--configfile>引数（もしくはconfigfileアトリビュートに渡された値）に指定された内容を読み込みます。

オプションはコマンドライン、設定ファイル、そしてC<new_with_options>に渡された引数の順番で適用されます。

=head2 サポートされる型制約

=over 4

=item I<Bool>

I<Bool>型はL<Getopt::Long>の論理値オプションとして認識されます。以下のような場合

  has 'verbose' => (is => 'rw', isa => 'Bool');

はL<Getopt::Long>のC<verbose!>と同等として扱われ、以下のようなコマンドライン引数として指定できるようになります：

  % my_script.pl --verbose
  % my_script.pl --noverbose

=item I<Int>, I<Float>, I<Str>

これらの型はそれぞれGetopt::LongのC<=i>、C<=f>、C<=s>として処理されます。

=item I<ArrayRef>

I<ArrayRef>型は複数回指定可能な引数として処理されます。例えば以下の場合、

  has 'include' => (
      is      => 'rw',
      isa     => 'ArrayRef',
      default => sub { [] }
  );

C<Getopt::Long>にはC<includes=s@>として扱われ、以下のようにコマンドラインから指定することが可能になります：

  % my_script.pl --include /usr/lib --include /usr/local/lib

=item I<HashRef>

I<HashRef>型はGetopt::Longのハッシュ型引数として扱われ、C<名前=値>のペアを指定できるようになります。例えば以下の場合、

  has 'define' => (
      is      => 'rw',
      isa     => 'HashRef',
      default => sub { {} }
  );

C<Getopt::Long>にはC<define=s%>として扱われ、以下のようにコマンドラインから指定することが可能になります：

  % my_script.pl --define os=linux --define vendor=debian

=back

=head2 カスタム型制約

カスタムな型制約を引数スペックにマップする事も可能です。まず以下のように型制約を作成します：

  use Scalar::Util qw(looks_like_number);
  subtype 'ArrayOfInts' # 整数リスト
      => as 'ArrayRef'
      => where { scalar (grep { looks_like_number($_) } @$_)  };

その後、引数スペックへのマッピングを登録します：

  MooseX::Getopt::OptionTypeMap->add_option_type_to_map(
      'ArrayOfInts' => '=i@'
  );

このようにすることでこの型を使ったアトリビュートは新たに登録された引数スペックを使うようになります。

  has 'nums' => (
      is      => 'ro',
      isa     => 'ArrayOfInts',
      default => sub { [0] }
  );

上記アトリビュートは、以下のコマンドライン引数から取得可能になります：

  % my_script.pl --nums 5 --nums 88 --nums 199

この例は非常にシンプルな物ですが、ちょっと想像力を使えば複雑なバリデーションを絡めた引数も設定することができます。注意すべき点はGetopt::Longのバリデーションとアトリビュートのバリデーションをうまくバランスを保って組み合わせる事です。

もちろん、より良い例があればドキュメントに追加しますのでお知らせください :)

=head2 型制約の推測

上記「サポートされる型制約」の項で紹介した型のsubtypeとしてカスタムな型制約を登録し、なおかつ明示的に引数スペックへのマッピングを登録しない場合、L<MooseX::Getopt>は親の型の引数マッピングを使用します。

例えば、上記例のようにC<ArrayOfInts>型を定義し、引数スペックをC<OptionTypeMap>に登録しない場合は普通のC<ArrayRef>型と同様の処理（C<=@s>）がなされます。

=head1 メソッド

=over 4

=item B<new_with_options (%params)>

引数C<@ARGV>からオブジェクトのアトリビュート初期値を受け取り、新規にオブジェクトを作成します。C<%params>にデフォルト値を指定します（C<@ARGV>の値が指定されている場合はそちらを優先します）。

任意の引数C<argv>にリストへのリファレンスを指定することによりC<@ARGV>の代わりに使用される値を指定することができます。

L<Getopt::Long/GetOptions>の処理が（無効な引数などの理由で）失敗した場合はC<new_with_options>は例外を投げます。

システムにL<Getopt::Long::Descriptive>がインストールされていて、以下のコマンドライン引数が渡された場合は、使用法を出力した後プログラムを終了します：

  --?
  --help
  --usage

それぞれのアトリビュートのドキュメントははC<documentation>オプションをアトリビュートに指定することによって指定することができます。

システムにGetopt::Long::Descriptiveがインストールされている場合はC<usage>引数もC<new>に渡されます。

=item B<ARGV>

このアクセッサはC<new_with_options>が呼ばれた時点のC<@ARGV>のコピーへのリファレンスを保持します。

=item B<extra_argv>

このアクセッサはL<Getopt::Long>が処理できなかったC<@ARGV>の「余り」を保持します。C<@ARGV>本体は変更されません。

=item B<meta>

ロールのメタオブジェクトを返します。

=back

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Stevan Little E<lt>stevan@iinteractive.comE<gt>

Brandon L. Black, E<lt>blblack@gmail.comE<gt>

Yuval Kogman, E<lt>nothingmuch@woobling.orgE<gt>

=head1 CONTRIBUTORS

Ryan D Johnson, E<lt>ryan@innerfence.comE<gt>

Drew Taylor, E<lt>drew@drewtaylor.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2007-2008 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut