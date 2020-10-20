@extends('layouts.default')

@section('title','Edit Post')

@section('content')
 <h1>
   <a href="{{url('/')}}" class="header-menu">Back</a>
   Edit post
 </h1>
 <form action="{{ url('/posts',$post->id) }}" method="post" >
   {{ csrf_field() }}
   {{ method_field('patch') }}
   {{-- 上記のように元のデータを編集する際にはurlにpostのidを渡してmethod_field('patch')とする --}}
   <p>
     <input type="text" name="title" placeholder="enter title" value="{{ old('title',$post->title) }}">
     {{-- old()は第一引数の値がなければ第二引数の値をデフォルトで設定できる？？ --}}
     @if($errors->has('title'))
     <span class="error">{{ $errors->first('title') }}</span>
     @endif
   </p>
   <p>
     <textarea name="body" placeholder="enter body" >{{ old('body',$post->body) }}</textarea>
     @if($errors->has('body'))
     <span class="error">{{ $errors->first('body') }}</span>
     @endif
   </p>
   <p>
     <input type="submit" value="Update">
   </p>
 </form>
@endsection
