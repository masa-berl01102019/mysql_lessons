<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Comment extends Model
{
    // データの挿入が可能になるように$fillableの設定
    protected $fillable = ['body'];

    // commentモデルとpostモデルの関係性を定義
    // $comment->postでアクセス出来るようにしたい
    public function post(){
      return $this->belongsTo('App\Post');
    }
}
