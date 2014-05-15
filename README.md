IPL 座席表
---

* [3100/IplApi](https://bitbucket.org/3100/iplapi) のAPIを利用します。

# 開発方針

開発時には `guard` と `sprockets` を用いて、最終コードを自動生成するようにしています。

* `coffee-script` から `javascript`
* `sass` から `css`
* `slim` から `html`

`src` フォルダを監視し、 `public` フォルダに変換ファイルを配置します。

# 準備

IplApiのURLを環境変数`IPL_API_URL`で設定します。

## DHCPでの運用

IplApiも同マシン上で運用している場合の例

.bashrcや.zshrcなどで
~~~
IP=`ifconfig eth0|grep inet|awk '{print $2}'|cut -d: -f2`
export IPL_API_URL="$IP:9291"
~~~

等としておくと便利かもしれません。

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
