# これは何?

chef-solo を使って munin をインストールしてみただけです。
勉強とか説明を兼ねています。

* ローカルマシンで試す方法
* リモートのマシンへ設定する方法

# ローカルマシンで試す方法

vagrant, VirtualBox を使用します。

* [chef](http://www.opscode.com/chef/) をインストールする
* [Virtual Box](https://www.virtualbox.org/) をインストールする
* [vagrant をインストールする](http://www.vagrantup.com)
* [vagrant-omnibus](https://github.com/schisamo/vagrant-omnibus) をインストールする
* このリポジトリをクローンする
* librarian-chef install を実行する
* vagrant up する
* 5分程度待つ
* munin のページにアクセスする


## chef をインストールする

rubygems でインストールできます。

```
gem install chef
```

## Virtual Box をインストールする

[Virtual Box](https://www.virtualbox.org/) をインストールします。インストール済みの場合は気にしなくて大丈夫です。

## vagrant をインストールする

http://downloads.vagrantup.com/ からダウンロードできます。
Gem でインストールできるものはバージョンがかなり古く、本リポジトリに記載していることは実行できないので注意してください。


## [vagrant-omnibus](https://github.com/schisamo/vagrant-omnibus) をインストールする

```
vagrant plugin install vagrant-omnibus
```

`vagrant up` した際に chef-solo のインストールをしてくれます。
ローカルでテストする際には knife-solo を使いたくないのでこうしています。


## このリポジトリをクローンする

本リポジトリをクローンしてカレントディレクトリを変更します。

```
git clone git@github.com:eiel/cookbook-munin-example
cd cookbook-munin-example
```


## librarian-chef install を実行する

依存している cookbook を取得します。

```
gem install librarian-chef
librarian-chef install
```


## vagrant up する

仮想マシンを起動します。
この時に chef-solo が実行され recipe の `munin` が実行されるように `Vagrantfile` に記述しています。


## 5分程度待つ

munin の実行が5分おきになっているため、ファイルが生成されるのに5分程度待つ必要があります。

## munin のページにアクセスする

virtualbox の仮想マシンにアクセスする方法を用意していないので、`vagrant ssh` を利用します。

```
vagrant ssh -- -L 4000:localhost:80
```

`--` の後に ssh のオプションを指定できるのでこれを利用しています。

http://localhost:4000/munin にアクセスするとグラフが見れると思います。
Basic認証のパスワードは

* user: foo
* password: bar

にしてあります。


# どこか別のマシンに設定をする

knife-solo を使います。

* knife-solo のインストール
* ssh できるようにする
* リモートサーバに chef-solo をインストールする
* リモートサーバに設定を反映
* リモートサーバにアクセスする

## knife-solo のインストール

```
gem install knife-solo chef librarian-chef
```

## ssh できるようにする

リモートサーバに `ssh` できるようにしておく必要があります。
またログインしたユーザが `sudo` をパスワードなしで実行できる必要があります。


## リモートサーバに chef-solo をインストールする

knife solo prepare を使うと簡単できます。

```
knife solo prepare test.korinkan.co.jp
```

## リモートサーバに対し実行したいレシピを指定する

chef はレシピという単位でサーバに反映できます。

実行するレシピをデフォルトでは何も指定されていません。
作成したレシピを指定するには `nodes` ディレクトリに `knife solo prepare` した際に `ホスト名.json` ファイルが作成されます。
これを編集します。

例

```
{"run_list" : ["munin"]}
```

## リモートサーバにアクセスする

`http://ホスト名/munin/` にアクセスすると munin のページが表示できます。

Basic認証のデフォルトのユーザ名は

* user: foo
* password: bar

に設定してあります。

## Basic認証のユーザ名、パスワードを変更したい場合

この`munin` レシピは munin.users という attributes で Basic 認証できるユーザを登録できるようにしています。

`nodes/ホスト名.json` で変更できるようにしています。
`munin.users` という値にリストで格納するとその値を使います。

例

```
{
    "run_list" : ["munin"],
    "munin": {
        "users": [
            {
                "user" : "hoge",
                "password" : "mogu"
            }
        ]
    }
}
```

# 参考文献

* [入門Chef Solo - Infrastructure as Code - 達人出版会](http://tatsu-zine.com/books/chef-solo)
* [今っぽい Vagrant + Chef Solo チュートリアル - taiki45 - Qiita](http://qiita.com/taiki45/items/b46a2f32248720ec2bae)
* [Available Vagrant Plugins - mitchellh/vgarnt - GitHub](https://github.com/mitchellh/vagrant/wiki/Available-Vagrant-Plugins)
* [Chef Solo Porovisoner - VagrantDocs](http://docs.vagrantup.com/v2/provisioning/chef_solo.html)
