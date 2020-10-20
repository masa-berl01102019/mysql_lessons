<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

// ルーティング
// どのURLでどんな処理をするか設定すること
// Route::アクセス方法('URL','コントローラー名@アクション名);の形で記載する

// 記事の一覧を表示
Route::get('/','PostsController@index');
// 上記は'/'(home画面)にgetでアクセスした場合にPostControllerのindexメソッドを実行するという意味

// 記事の詳細画面を表示
// Route::get('/posts/{id}','PostsController@show');
// 上記は'192.168.33.10:8000/posts/{id}'(記事のidをパラメータ)にgetでアクセスした場合にPostControllerのshowメソッドを実行するという意味
// パラメータを渡す際は{値}の形で渡す
// Implicit Bindingでルーティング作成する方法
Route::get('/posts/{implicit}','PostsController@show')->where('implicit','[0-9]+');

// 記事の新規作成画面
Route::get('/posts/create','PostsController@create');
// ルーティングの注意事項
// ルーティングは先に書かれたものが優先されるため '/posts/create' でアクセスすると '/posts/{post}' に create が来たと判断されて
// 上の方に書かれている、 'PostsController@show' の show アクションが実行されてしまう
//
// ＜そうならないようにするための方法＞
//
// 1. 'PostsController@create' を先に書いてしまう方法
//     * 順番を考えるのが面倒なので、 where() を使って値のルールを決める方法がよく使われる
//
// 2. '/posts/{post}' のルーティングのpostに関しては正規表現を使って数字しかダメだと書く方法
//       ex) Route::get('/posts/{implicit}','PostsController@show')->where('implicit','[0-9]+');
//     * 上記のように正規表現を使っておけば '/posts/create' でアクセスしたら '/posts/{post}' の post は数字限定なので
//       '/posts/{post}' のルーティングには該当しないで、次のルーティングにヒットして create アクションが実行されるという仕組み

// formで渡ってきた新規投稿の保存
Route::post('/posts','PostsController@store');
//create.blade.phpからformで method="post" action="{{url('/posts')}}"に合わせてルーティングの作成

// 投稿一覧から記事の編集画面
Route::get('/posts/{implicit}/edit','PostsController@edit');

// 投稿の更新
Route::patch('/posts/{implicit}','PostsController@update');
//edit.blade.phpからformで method_field('patch') action="{{ url('/posts',$post->id) }}"に合わせてルーティングの作成

//投稿の削除
Route::delete('/posts/{implicit}','PostsController@destroy');
//index.blade.phpからformで method_field('delete') action="{{ url('/posts',$post->id) }}"に合わせてルーティングの作成

//コメントの投稿
Route::post('/posts/{implicit}/comments','CommentsController@store');
//show.blade.phpからformで method="post" action('CommentsController@store',$post)に合わせてルーティングの作成

//コメントの削除
Route::delete('/posts/{implicit}/comments/{comment}','CommentsController@destroy');
//show.blade.phpからformで method_field('delete') action('CommentsController@destroy',[$post,$comment])に合わせてルーティングの作成


// end
