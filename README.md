# liberty-watson

Technology Showcaseで実施するデモのサンプル・プロジェクトです。
DevOpsの考え方を取り入れ，ローカルのテスト実行からクラウド上のOCP（OpenShift Continer Platform）へのデプロイまでの標準手順をしめしています。
デモを実施するShowcaseのクラウド上に，この環境を常に置いておく必要はありません。
必要なときにデプロイ作業をおこなえば，短時間で動作確認済みの環境が使えるようになります。

以下のコマンドなどで「liberty-watson」とされている部分は，適宜，プロジェクトの名前に置き換えます。

## ローカルでのコンテナを使わない実行

このサンプルプロジェクトでは，WebSphere Liberty上で実行するWebアプリケーションを提供します。
クラウド上のWatsonサービスに接続し，ピザの注文を行うサイトのデモをおこなうことができます。

アプリケーションならびにWebSphere Libertyの実行環境は，Mavenのプロジェクトとして定義されています。
pom.xmlならびにsrcディレクトリ以下がその実体です。

[JDK](https://developer.ibm.com/languages/java/semeru-runtimes/downloads/)ならびに[Mavenが導入](https://www.google.com/search?q=Maven+%E5%B0%8E%E5%85%A5)されている環境にcheckoutし，コマンドラインから以下のように実行すると，ローカルのPC上でアプリケーションをテスト実行することができます。

```
% mvn liberty:run
```

必要なLibertyの導入イメージなども，全て[Mavenのセントラルレポジトリから自動的にダウンロード](https://search.maven.org/search?q=com.ibm.websphere.appserver.runtime)されます。

`http://localhost:9080/`にアクセスすることで，アプリケーションが正常に実行されているかを確認できます。
サーバーを停止するにはCtrl＋Cをキーボードから入力します。

## ローカルでのコンテナイメージ作成とテスト

コンテナイメージを作成し，手元のコンテナ環境で実行をテストします。
[podmanコマンド](https://www.google.com/search?q=podman+%E5%B0%8E%E5%85%A5)が使用できるようにセットアップされていることが前提です。

Dockerfileがコンテナイメージを作成するためのソースファイルです。
このDockerfileは，マルチステージビルドをおこなうようになっており，Mavenをつかってソースからアプリケーションを作成する作業もコンテナ上で実施するようになっています。
つまりビルド専用のMavenのはいったコンテナを使用してアプリケーションのwarを作成し，それを実際に使用するLibertyのコンテナにコピーしています。
そのため，このステップから実施する場合には，JDKやMavenは不要です。

コマンドラインから以下のように実行すると，コンテナのイメージが作成されます。
ここで指定している「1.0-SNAPSHOT」というタグのバージョンは，pom.xmlに定義されたバージョンをそのまま使用しています。
pom.xmlを更新した場合などは，適宜バージョンを変更します。

```
% podman build -t liberty-watson:1.0-SNAPSHOT .
```

LibertyのコンテナイメージはDocker HubからPullされ，その上にアプリケーションを導入するようになっています。
また，このイメージは起動するとコンテナ内で9080番ポートをLISTENします。

作成したイメージを，ローカルのpodman上で起動します。コマンドラインから以下のように実行します。
コンテナの9080番ポートをローカル環境の9080番ポートに接続しています。

```
% podman run -d -p 9080:9080 liberty-watson:1.0-SNAPSHOT
```

`http://localhost:9080/`にアクセスすることで，アプリケーションが正常に実行されているかを確認できます。
サーバーを停止するには`podman ps`を実行してCONTAINER IDを調べ，`podman stop <CONTAINER ID>`，`podman rm <CONTAINER ID>`を実行します。

独自のデモを作成する場合には，ローカルで実行可能なコンテナイメージを作成するDockerfileを開発し，同様にイメージをビルドしテスト実行できるようにします。

## S2Iを使用してOCP環境にデプロイする

コンテナイメージをOCP上にデプロイし，デモを実施できるようにします。
[ocコマンド](https://cloud.ibm.com/docs/openshift?topic=openshift-openshift-cli&locale=ja)が使用できるようにセットアップされていることが前提です。

ブラウザで[IBMクラウド](https://cloud.ibm.com/)にログインし，リソースリストのクラスター一覧から，デモをおこなうOpenShift環境を開きます。
画面から，「OpenShift Webコンソール」を開きます。
Webコンソールの右上，自分のアカウント名をクリックしたプルダウンメニューから「Copy Login Command」を開きます。
「oc login --token=〜」から始まるコマンドをコピーし，コマンドプロンプトから入力してocコマンドを使用できるようにします。

デモを実行するProjectを作成します。

```
% oc new-project liberty-watson
```

もしくは，既存のプロジェクトを使用する場合は，そのProjectを選択します。

```
% oc project liberty-watson
```

このプロジェクトのように，GitHub上にソースコードが公開されている場合は，そのURLを指定してS2Iでアプリケーションを作成します。

```
% oc new-app https://github.com/takakiyo/liberty-watson --strategy=docker
```

カレントディレクトリにソースコードが展開されている場合は，以下のようにしてアプリケーションを作成します。

```
% oc new-app . --strategy=docker
```

これにより，OCP上にImageStreamTag，BuildConfig，Deployment，Serviceが作成されます。

new-appを実行した直後にPodの一覧を表示すると，コンテナイメージをビルドするためのPodが立ち上がっていることが確認できます。


```
% oc get pod
NAME                                      READY   STATUS    RESTARTS   AGE
liberty-watson-1-build                    1/1     Running   0          63s
```

このPodのログを表示して，ビルドが正常に実行するかを確認します。
ビルドが完了すると，コマンドプロンプトに復帰します。

```
% oc logs liberty-watson-1-build -f
```

Podが正しくデプロイされ，起動されている（AVAILABLEが0ではない）ことを確認します。

```
% oc get deploy
NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
liberty-watson           1/1     1            1           6m26s
```

サービスを確認し，ClusterIPで公開されていることを確認します。

```
% oc get svc
NAME             TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
liberty-watson   ClusterIP   172.21.55.189   <none>        9080/TCP,9443/TCP   7m50s
```

サービスを外部からアセスできるようにExposeします。

```
% oc expose svc liberty-watson
route.route.openshift.io/liberty-watson exposed
```

作成されたRouteを確認します。

```
% oc get route
NAME             HOST/PORT                                                                                                                         PATH   SERVICES         PORT       TERMINATION   WILDCARD
liberty-watson   liberty-watson-liberty-watson.xxxx-xxxxxxxxxxxx-tokyo-1-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-0000.jp-tok.containers.appdomain.cloud          liberty-watson   9080-tcp                 None
```

HOSTに表示されたURLにブラウザでアクセスすると，作成したアプリケーションを利用することができます。
このとき，サーバーにhttpsではなく，httpでアクセスしないとつながりません。
最近のブラウザは，プロトコルを指定せずにサーバー名を指定した場合，デフォルトでhttpsで接続しに行くため注意が必要です。

## デモ実施後の環境の消去

Route，Service，Deployment，BuildConfig，ImageStreamTagの順に削除していきます。

```
% oc delete route liberty-watson
% oc delete svc liberty-watson
% oc delete deploy liberty-watson
% oc delete buildconfig liberty-watson
% oc delete imagestreamtag liberty-watson:latest
```

# 独自のデモを作成する場合

デモを実施するDockerfileを開発してください。

上にも記載されていますが，実際に使用するコンテナイメージの作成はS2Iを使用してOCP上で実行されるため，ビルドに外部のツールを使用しないようにすることが必要です。
イメージの作成に外部ツールが必要な場合は，そのツールを含んだビルド用のイメージを使用する，マルチステージビルドのDockerfileを作成してください。

Dockerfileで指定するベースイメージは，可能な限りUBI（Red Hat Universal Base Image）を使用したものにしてください。
Ubuntuベースなどのイメージを使用した場合は，デプロイ時に権限の設定に失敗するなど，正常に利用できない可能性があります。
