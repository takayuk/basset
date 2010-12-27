次の動作をするbatchfileを作れば動きます

1-A：sr_methodでcore内のノードを出力
1-B：select_coreでlabel-listからcore内のリンクを取り除いて新たなlabel-listを生成
2-A：sr_methodで新たに生成したlabel-listからcore内のノードを出力
2-B：select_coreでlabel-listからcore内のリンクを取り除いて新たなlabel-listを生成

以下同様でSRコミュニティが抽出できます


以下のプログラムで構成されています

------------------------------------------------------------------------
・sr_method 
SR法の根幹です。

使い方：
./sr_method 入力データ（label-list）　出力データ(core内のノードリスト)

------------------------------------------------------------------------

・make_namelist
ノードリストからNamelistを作成します

使い方：
./make_namelist 入力データ1（core内のノードリスト）入力データ2（Namelist）　出力データ(core内の名前のリスト)

------------------------------------------------------------------------
 
・select_core

label-listからcore内のリンクを除いて新たなlabel-listを生成します

使い方
./select_core 入力データ1（core内のノードリスト）　入力データ2（label-list）　出力データ（新たなlabel-list）

------------------------------------------------------------------------

・make-batch 

batchfileを作成します。

使い方
./make-batch 出力データ（batchfile）

------------------------------------------------------------------------

後はあまり関係ないと思います
・make_grouplist 
・init_grouplist 
・convert_grouplist_sr
------------------------------------------------------------------------

追記
・batchfileを動かせば（./batchfile）、label-listから勝手にCoreを抽出する仕組みになっているのでそちらを参考にするのがよいかと思います
・makeですべてのプログラムがコンパイルできます