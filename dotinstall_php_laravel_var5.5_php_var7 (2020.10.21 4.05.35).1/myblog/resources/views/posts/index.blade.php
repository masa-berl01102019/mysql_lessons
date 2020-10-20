@extends('layouts.default')
{{-- 上記は@extends('ファイル名')でlayoutフォルダのdefault.blade.phpを継承するという意味
     「;」はいらないので注意 --}}

@section('title')
  Blog Posts
@endsection
{{-- 上記は@section('title')と@endsectionの間に埋め込みたい値を書いて@yield('title')と対応する形にする
     埋め込みたい値が短い場合は@section('title','Blog Posts')と書いてもいい --}}

 @section('content')
   <h1>
     <a href="{{url('/posts/create')}}" class="header-menu">New Post</a>
     Blog Posts
   </h1>
   <ul>
     {{-- bladeでのコメントの書き方
          bladeでは@foreachのように@制御文の形で条件分岐等が出来る * 最後にセミコロンが要らないことに注意が必要
              bladeでは{{ }}で囲えばエスケープが出来る--}}
     {{-- @foreach($posts as $post)
           <li><a href="">{{ $post->title }}</a></li>
          @endforeach --}}

     @forelse($posts as $post)
       {{-- 記事の一覧から記事の詳細へリンクを貼る方法
            ①ルーティングの設計通りにURLを指定する方法
            <li><a href="/posts/{{$post->id}}">{{ $post->title }}</a></li>
            ②url()を使ってURLを作成する方法
            <li><a href="{{ url('/posts',$post->id) }}">{{ $post->title }}</a></li>
            ③action()を使ってURLを生成する方法
            <li><a href="{{ action('PostsController@show',$post->id) }}">{{ $post->title }}</a></li> --}}
       <li>
         <a href="{{ action('PostsController@show', $post) }}">{{ $post->title }}</a>
         <a href="{{ action('PostsController@edit', $post) }}" class="edit">[Edit]</a>
         <a href="#" class="del" data-id="{{ $post->id }}">[×]</a>
         {{-- 削除処理の場合は単なるリンクの場合にアクセスしただけで削除になってしまうのでリンク先はダミー(#)にしておいてformで送信する --}}
         <form method="post" action="{{ url('/posts',$post->id) }}" id="form_{{ $post->id }}">
           {{ csrf_field() }}
           {{ method_field('delete') }}
         </form>
       </li>
     @empty
       <li>No posts yet</li>
     @endforelse
       {{-- 上記の @forelse~@empty~@endforelseはforeachで回す配列がない場合に@empty以下が表示されるようになる書き方
            参考URL:https://blog.capilano-fw.com/?p=405#i-2 --}}
   </ul>
   <script src="/js/main.js"></script>
 @endsection
