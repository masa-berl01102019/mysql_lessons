<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Post;
use App\Comment;

class CommentsController extends Controller
{
    public function store(Request $request, Post $implicit){
      // 引数はform送信されているのでRequest型の$requestと紐づけられているPost型の$implicit(postのid)の２つ *postモデルにアクセスするのでuseを忘れない
      $this->validate( $request,[
        'body'=>'required'
      ]);
      $post = $implicit;
      // 下記のように直接インスタンス作成時に引数に連想配達の形で渡せる *Commentモデルにアクセスするのでuseを忘れない
      $comment = new Comment(['body' => $request->body]);
      // Post.phpで実装した$post->commments()で$postに紐づけしつつ、save()にcommentsのデータを引数に渡して保存
      $post->comments()->save($comment);
      // 違うコントローラーに対してリダイレクトをかける時はaction()を使う必要がある *showの場合はidを指定しないといけないので忘れずに渡す
      return redirect()->action('PostsController@show',$implicit);
    }

    public function destroy(Post $implicit,Comment $comment){
      $comment->delete();
      // もとの画面に戻るだけだったらredirect()->back()とすればいい
      return redirect()->back();
    }

}
