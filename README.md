IPL 座席表
---
[192.168.5.41:9292/ (社内のみ)](http://192.168.5.41:9292/)

* [3100/IplApi](https://bitbucket.org/3100/iplapi) のAPIを利用します。

# 開発方針

開発時には `guard` と `sprockets` を用いて、最終コードを自動生成するようにしています。

* `coffee-script` から `javascript`
* `sass` から `css`
* `slim` から `html`

`src` フォルダを監視し、 `public` フォルダに変換ファイルを配置します。

# ソースコードの生成

初回時には `bundler` を用いて必要なライブラリを導入しておく必要があります。

    bundle install

`src` フォルダの監視を開始するのは

    guard

と入力します。

既にあるファイルから最終コードを生成するには `rake` コマンドを用います。

    rake

# Test Server

開発時にはテストサーバがあると便利です。そのために `rack` を利用します。

    rackup

`-p` オプションでポートを指定することも可能です。

    rackup -p <port>
    
---
# Thanks

[zgramana / Bitbucket Ribbons — Bitbucket](https://bitbucket.org/zgramana/bitbucket-ribbons)