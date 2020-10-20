<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Post;
use App\Http\Requests\PostRequest;

class PostsController extends Controller
{
    public function index(){
      // データベースから値を引っ張ってくる方法
      // コントローラーからデータベースのデータにアクセスするにはEloquentの命令を使えばいい(多分tinkerでの命令の仕方と一緒)
      // $変数 = 名前空間\モデルのクラスメソッド::Eloquentの命令の形でデータを取得して変数に格納する
      // $posts = \App\Post::all(); //名前空間が長くなりがちなのでuseを使用して下記のように書く
      // 記事を全件取得
      // $posts = Post::all();
      // 作成日時の新しい順に並べ替えて取得
      // $posts = Post::orderBy('created_at','desc')->get(); // Laravelではlatest()で下記のように書き換えることも出来る
      $posts = Post::latest()->get();
      // $posts = []; // 値を空にした場合のデバック

      // dd();を使ったデバック
      // dd();dump die の略で結果を出力してその場で処理を終了してくれるlaravelで用意されている便利関数
      // 配列形式にして出力して値が渡ってきてるかデバック
      // dd($posts->toArray());

      // return "Hello";

      // viewの表示方法
      // return view('posts.index');
      // view('フォルダ名.アクション名に対応したview名');でviewを呼び出せる
      // フォルダの区切り文字は「.」であることに注意
      // 上記はview/posts/index.blade.phpを指定するという意味

      // 抽出した値をviewに渡す方法
      // view();の第二引数に連想配列形式で値を渡す
      // 下記は$postsの内容をviewの中でpostsという名前で使うことが出来るという意味
      // return view('posts.index',['posts' => $posts]);
      // 上記は下記のように書き換えることも出来る
      return view('posts.index')->with('posts',$posts);
    }

    // public function show($id){
    //   // ルーティングから渡ってきたURLのパラメータは引数として受け取れる
    //
    //   // $post = Post::find($id);
    //   // 上記のままでもいいが、もし値が渡って来なかった場合に例外を返せるように下記の命令をつかう
    //   $post = Post::findOrFail($id);
    //
    //   return view('posts.show',['post',$post]);
    // }

    // Implicit Bindingを使ったルーティング
    public function show(Post $implicit){
      return view('posts.show',['post'=>$implicit]);
    }

    public function create(){
      return view('posts.create');
    }

    public function store(PostRequest $request){
       // formでpost型で送信されたものは Request型で渡ってくるので$requestで引数として受ける
      // PostRequestにバリデーションを記載した場合はRequest型からPostRequest型にデータ型を変更する

      // validate()でpostされたものを検証
      // $this->validate($request,[
      //   'title'=>'required|min:3',
      //   'body'=>'required'
      // ]);
      // バリデーションに引っかかるとhome画面に戻らず自動的入力画面に差し戻してくれる

      // postモデルのインスタンス作成
      $post = new Post();
      // postの各項目に$requestの値を代入
      $post->title = $request->title;
      $post->body = $request->body;
      // postの保存
      $post->save();
      // 保存後はhome画面にredirectする
      return redirect('/');
    }

    public function edit(Post $implicit){
      return view('posts.edit',['post'=>$implicit]);
    }

    public function update(PostRequest $request, Post $implicit){ // 引数の受け方注意
      // PostRequestにバリデーションを記載した場合はRequest型からPostRequest型にデータ型を変更する
      // $this->validate($request,[
      //   'title'=>'required|min:3',
      //   'body'=>'required'
      // ]);

      // 渡された$postを使うのでインスタンスは作成しなくていい
      // $post = new Post();
      $post = $implicit; // 引数で$postでうければ左記はかかなくていい
      $post->title = $request->title;
      $post->body = $request->body;
      $post->save();
      return redirect('/');
    }

    public function destroy(Post $implicit){
      $post = $implicit;
      $post->delete();
      return redirect('/');
    }


}
