@extends('layouts.default')

@section('title','New Post')

@section('content')
 <h1>
   <a href="{{url('/')}}" class="header-menu">Back</a>
   New Post
 </h1>
 <form action="{{ url('/posts') }}" method="post" >
   {{ csrf_field() }}
   {{-- Laravelでは悪意のある不正な投稿を防ぐためにデフォルトでCSRF対策が施されていて、
        フォームにはそのためのトークンを仕込む必要がある
        上記のように{{ csrf_field() }} とすればOK --}}
   <p>
     <input type="text" name="title" placeholder="enter title" value="{{ old('title') }}">
     {{-- エラーが出てフォームに戻る際に入力した文字を保持しておきたいのでvalueにold()ヘルパー関数をつかう --}}
     @if($errors->has('title'))
     <span class="error">{{ $errors->first('title') }}</span>
     @endif
     {{-- 上記はtitleに関して$errorがあった場合にエラーがなくなるまで$errors->first('title')で最初のものだけを表示しなさいということ --}}
   </p>
   <p>
     <textarea name="body" placeholder="enter body" >{{ old('body') }}</textarea>
     @if($errors->has('body'))
     <span class="error">{{ $errors->first('body') }}</span>
     @endif
   </p>
   <p>
     <input type="submit" value="Add">
   </p>
 </form>
@endsection
