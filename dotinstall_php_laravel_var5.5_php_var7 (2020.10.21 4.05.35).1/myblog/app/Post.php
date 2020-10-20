<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Post extends Model
{
    protected $fillable = ['title','body'];
    // 上記のコマンドでデータの挿入が可能になる

    // Commentモデルとの関係性を定義
    // $post->commentsでアクセス出来るようにしたい
    public function comments(){
      return $this->hasMany('App\Comment');
    }

}
