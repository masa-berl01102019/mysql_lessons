@extends('layouts.default')

@section('title',$post->title)

@section('content')
 <h1>
   <a href="{{url('/')}}" class="header-menu">Back</a>
   {{ $post->title }}
 </h1>
 <p>{!! nl2br(e($post->body)) !!}</p>
 {{-- 本文の方は改行が入ってくる可能性もあるので下記の手順で書く
      1. e() でエスケープをする
      2. nl2br() で改行を<br>に置き換える
      3. {!! !!}で、<br>だけエスケープをせずに表示する
      nl2br()は指定された文字列に含まれる全ての改行文字（\nなど）の前に、HTMLの改行タグ（<br />など）を挿入して値を返す
      e()は、Laravelが提供しているヘルパ関数で、やっていることは、ほぼhtmlentities関数と同じ--}}

<h2>Comments</h2>
<ul>
  @forelse($post->comments as $comment)
    <li>
      {{ $comment->body }}
      <a href="#" class="del" data-id="{{ $comment->id }}">[×]</a>
      <form method="post" action="{{ action('CommentsController@destroy',[$post,$comment]) }}" id="form_{{ $comment->id }}">
      {{-- action()の引数は[$post,$comment]の両方渡す必要がある --}}
        {{ csrf_field() }}
        {{ method_field('delete') }}
      </form>
    </li>

  @empty
    <li>No comments yet</li>
  @endforelse
</ul>

<form action="{{ action('CommentsController@store',$post) }}" method="post" >
  {{ csrf_field() }}
  <p>
    <input type="text" name="body" placeholder="enter comment" value="{{ old('body') }}">
    @if($errors->has('body'))
    <span class="error">{{ $errors->first('body') }}</span>
    @endif
  </p>
  <p>
    <input type="submit" value="Add Comment">
  </p>
</form>
<script src="/js/main.js"></script>
{{-- deleteのform送信に使うので読み込みを忘れずに --}}
@endsection
