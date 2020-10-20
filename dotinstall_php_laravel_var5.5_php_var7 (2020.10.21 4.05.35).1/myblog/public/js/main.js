(function(){
  'use strict';

  // delクラスのリンクの取得
  var cmds =document.getElementsByClassName('del');
  // ループ用の変数の宣言
  var i;
  // ループ処理
  for( i = 0; i < cmds.length; i++ ){
    // cmdsのi番目に対してクリックイベントを作成
    cmds[i].addEventListener('click',function(e){
      // 無名関数の引数にイベントオブジェクトを仕込んでe.preventDefault();とすることでaタグのリンク先に飛ぶという規定の動きを抑制する
      e.preventDefault();
      // confirm()で確認をとってyesの場合にtrueが返ってくるので、次の処理に移る
      if(confirm('Are you sure ?')){
        // .getElementById()でformタグのdata属性のidを取得してsubmitでフォームを送信する
        document.getElementById('form_' + this.dataset.id).submit();
      }
    });
  }
  // 上記のコマンドはindex.blade.phpでリンク先をクリックされた時にJavascriptで一旦削除していいか確認してokの場合にformを送信するという実装

})();
