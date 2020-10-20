{{-- blade親ページ
1. HTMLの大まかな骨組(共通部分)を親ページにひな型として作成する
2. 子ページを作成して@extends('親ページのファイル')で継承する
3. 子ページで定義した@section('名目')の中身を@yield('名目')で指定したセクションの内容を呼び出す形で使う --}}

<!DOCTYPE html>
<html lang="ja">
  <head>
    <meta charset="utf-8">
    <title>@yield('title')</title>
    <link rel="stylesheet" href="/css/styles.css">
  </head>
  <body>
    <div class="container">
      @yield('content')
    </div>
  </body>
</html>
