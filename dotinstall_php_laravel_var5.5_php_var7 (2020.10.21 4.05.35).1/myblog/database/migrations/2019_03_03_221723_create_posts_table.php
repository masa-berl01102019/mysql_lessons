<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreatePostsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */

    // マイグレーションで行いたい処理
    public function up()
    {
        // 自動的にmodel名の複数系のtableを作成してくれてidとtimestampsがデフォルトで設定される
        Schema::create('posts', function (Blueprint $table) {
            // 主キーで連番でidが作成される
            $table->increments('id');
            $table->string('title');
            $table->text('body');
            // created_at と updated_at というcolumnを作成してくれて作成日時と更新日時を自動で管理してくれる
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */

    // up()の処理を巻き戻すための処理
    public function down()
    {
        Schema::dropIfExists('posts');
    }
}
