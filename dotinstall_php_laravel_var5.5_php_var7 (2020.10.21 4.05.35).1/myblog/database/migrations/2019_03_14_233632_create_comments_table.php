<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateCommentsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('comments', function (Blueprint $table) {
            $table->increments('id');
            // postに対して紐づける為、post_idのフィールド作成
            // $table->integer('post_id');
            // post_idは負の整数を取ることがないのでデータ型をunsignedIntegerとしてあげる
            $table->unsignedInteger('post_id');
            // commentの本文のフィールド作成 * 一行コメントの予定なのでデータ型はstringにしておく
            $table->string('body');
            $table->timestamps();
            // post_idとpostsテーブルのidを紐づけるための外部キー制約を作成
            $table->foreign('post_id')->references('id')->on('posts')->onDelete('cascade');
            // 上記はpost_idはpostテーブルのidを参照してpostが削除されたら一緒にコメントも削除しなさいという制約
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('comments');
    }
}
