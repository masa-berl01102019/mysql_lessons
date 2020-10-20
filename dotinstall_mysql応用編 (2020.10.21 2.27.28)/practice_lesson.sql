drop database if exists test_db2;

create database test_db2;

use test_db2;

drop table if exists products;

create table products (
  id INT PRIMARY KEY AUTO_INCREMENT,
  product_name VARCHAR(140) NOT NULL,
  product_number INT UNSIGNED UNIQUE,
  price INT UNSIGNED NOT NULL,
  cost INT UNSIGNED,
  made_in CHAR(2),
  target_zone ENUM('mens', 'ladies', 'kids'),
  is_stocked BOOL DEFAULT TRUE,
  created DATETIME DEFAULT NOW(),
  updated DATETIME DEFAULT NOW() ON UPDATE NOW()
);

-- delete from products;

insert into products 
  (product_name, product_number, price, cost, made_in, target_zone, is_stocked, created)
values
  ('stretch pants'  , 17068540, 7980  , 2700 , 'KO', 'mens'  , 0 , '2019-12-5 15:54:39'),
  ('print T-shirts' , 17068541, 2980  , 1020 , 'KO', 'kids'  , 1 , '2019-6-30 11:20:47'),
  ('wool 100% setup', 17068542, 14980 , 4980 , 'JA', 'ladies', 0 , '2020-1-18 17:32:29'),
  ('color jeans'    , 17068543, 9880  , null , 'JA', 'ladies', 0 , '2018-3-17 15:38:22'),
  ('denim jacket'   , 17068544, 11980 , 3400 , 'DE', 'kids'  , 1 , '2017-9-18 16:32:25'),
  ('military jacket', 17068545, 12980 , 4070 , 'DE', 'ladies', 1 , '2020-1-30 17:21:43'),
  ('low gauge knit' , 17068546, 8980  , null , 'KO', 'mens'  , 1 , '2019-11-6 18:32:32'),
  ('hat'            , 17068547, 3980  , 1400 , 'DE', 'kids'  , 0 , '2019-7-31 12:26:22'),
  ('socks'          , 17068548, 990   , 300  , 'JA', 'mens'  , 0 , '2018-10-3 19:35:49'),
  ('long coat'      , 17068549, 17980 , 5400 , 'JA', 'mens'  , 0 , '2020-10-9 16:45:38'),
  ('mini skirt'     , 17068550, 3480  , 1230 , 'JA', 'ladies', 0 , '2019-11-4 21:29:28'),
  ('short pants'    , 17068551, 1980  , 765  , 'DE', 'kids'  , 0 , '2018-10-7 13:05:12');

/* 集計関数(COUNT,SUM,AVG,MAX,MIN)を使ったselect文 */
select count(cost) from products;
-- nullを除いた個数を調べるには上記でcount(値にnullがあるカラム)で調べることが出来る
select count(id) from products;
-- nullを含めた個数を調べたい場合には上記のようにcount(主キーもしくは＊)で調べることが出来る
select
  sum(cost), 
  avg(cost),
  max(cost),
  min(cost)
from 
  products;
-- 上記のようにsum(カラム名), avg(カラム名), max(カラム名), min(カラム名) の集計関数でnullを除いた集計値（合計値,平均値,最大値,最小値）を取得出来る
-- ＊集計関数は一般の各レコードの値を取り出すカラム指定とは一緒に使えないので、使うにはサブクエリとして使う必要がある

/* distinct, group by, having を使ったselect文 */
select distinct made_in from products;
-- どこの国で生産されたかの一覧を取得したい場合などに distict カラム名 で指定することで重複する値を除いたデータが取得できる
select made_in, avg(price) from products group by made_in;
-- 国別で上代の平均金額などの集計値を取得したい場合に上記のように group by グループ化したいカラム名 と指定することでグループ別の集計値が取得できる
select made_in, avg(price) as average_price from products group by made_in having average_price > 7000;
-- group by で取得した集計結果に対してさらに抽出条件を設けたい場合は上記のように having で条件を指定して集計値を取得できる
-- ＊ where は group by より前に処理されるので後ろに書いてはいけない点に注意
select made_in, avg(price) from products where is_stocked = true group by made_in having avg(price) > 7000;
-- 上記は在庫がある商品の上代の平均値を国別で集計した結果が7000円以上のデータを取得している

/* if, caseを使ったselect文 */
select id, product_name, price, if(price >= 10000, 'more_than_10000', 'less_than_10000') as price_range from products;
-- select if(条件, trueの場合に挿入する値, falseの場合に挿入する値) from テーブル名;で条件別で値を挿入したカラムが取得できる
select 
  id, 
  product_name, 
  created,
  case
    when year(created) >= 2020 then 'new'
    when year(created) >= 2019 then 'normal'
    else 'old'
  end as time_range 
from 
  products;
-- select cace when 条件 then trueの場合に挿入する値 ... else falseの場合に挿入する値 from テーブル名;で if文より多くの条件別の値を設定したカラムが取得できる

/* 抽出結果を別テーブルに切り出す方法 */
create table products_japan as select * from products where made_in = 'JA';
-- create table テーブル名 as select文; でselect文で抽出した結果を別テーブルに切り出せる
select * from products_japan;
desc products_japan;
-- ＊ 上記は全てのカラムを取得している為、テーブルの構造もすべて取得してテーブルに切り出せているが、、、
--    下記のように取得するカラムを絞って抽出した場合は該当のカラムに関するテーブルの構造のみ切り出して取得になる
create table products_japan2 as select id, product_name, made_in from products where made_in = 'JA';
-- create table テーブル名 as select文; でselect文で抽出した結果を別テーブルに切り出せる
select * from products_japan2;
desc products_japan2;
-- その為完全なコピーを別テーブルに書き出したい場合は下記のように記述すればいい
create table products_copy as select * from products;
select * from products_copy;
desc products_copy;
-- レコードは必要なく単純に構造のみコピーして別テーブルに切り出したい場合は下記のようの記述すればいい
create table products_skeleton like products;
select * from products_skeleton;
desc products_skeleton;

/* VIEWを使った仮想テーブルの作成 */
update products set cost = 2960 where id = 4 or id = 7;
select id, product_name, cost from products;
select id, product_name, cost from products_copy;
-- 上記のように切り出し元のテーブルを更新してもproducts_copyは当然影響をうけない

create view products_japan_view as select * from products where made_in = 'JA';
select * from products_japan_view;
update products set is_stocked = true where made_in = 'JA';
select * from products_japan_view;
-- 上記のように作成したviewは切り出し元のテーブルを更新するとviewのデータも更新される
-- viewは抽出条件だけを保持した仮想的なテーブルで実行する度に再度元データから値を抽出してくれる仕組みの為

-- VIEWを使うメリットとデメリット https://itmanabi.com/db-view/
-- VIEWの使いどころを考える https://blog.mosuke.tech/entry/2016/03/16/175431/

/* UNIONで抽出結果をまとめる */
select id, product_name, price from products order by price desc limit 3;
select id, product_name, price from products order by price limit 1;
-- 上記の抽出結果を下記のようにまとめられる
(select id, product_name, price from products order by price desc limit 3)
union all
(select id, product_name, price from products order by price limit 1);
-- (select文) union all (select文); で抽出結果を縦にまとめる事が出来る

/* サブクエリ */
select id, product_name, price, (select avg(price) from products) as price_avg from products;
-- 集計関数は全てのレコードを集計して一つのレコードにしてしまうので普通の各レコードの値を抽出するselect文とは一緒に使えないので
-- select文の中でselect文(サブクエリ)を使うことで一緒に使うことが出来る
-- サブクエリは複雑な条件のデータの抽出が出来るがクエリが長くなったり処理速度が落ちる傾向があるので膨大なデータの集計時には注意が必要

/* 相関サブクエリ */
-- +----+-----------------+-------+---------+
-- | id | product_name    | price | made_in |
-- +----+-----------------+-------+---------+
-- |  1 | stretch pants   |  7980 | KO      |
-- |  2 | print T-shirts  |  2980 | KO      |
-- |  3 | wool 100% setup | 14980 | JA      |
-- |  4 | color jeans     |  9880 | JA      |
-- |  5 | denim jacket    | 11980 | DE      |
-- |  6 | military jacket | 12980 | DE      |
-- |  7 | low gauge knit  |  8980 | KO      |
-- |  8 | hat             |  3980 | DE      |
-- |  9 | socks           |   990 | JA      |
-- +----+-----------------+-------+---------+
-- 上記の抽出結果に国別での上代平均値も一緒に抽出したいと考えた場合
-- 最初のレコードの処理時にmade_inカラムの値が’KO’のレコードを全体から抽出して集計して、次に値がJAのレコードを全体から抽出して集計すればいい
-- 具体的には抽出元のテーブルをtable_1と仮に名付けて, サブクエリの抽出元のテーブルをtable_2と仮に名付けて区別出来るようにする
-- サブクエリのwhere条件で全体のテーブル(table_1)のmade_inの値がサブクエリ処理時のテーブル(table_2)の値と一緒な時に集計関数を使うことで抽出できる
select 
  id, 
  product_name, 
  price,
  made_in, 
  (select avg(price) from products as table_2 where table_1.made_in = table_2.made_in) as price_area_avg
from 
  products as table_1;
-- 上記のように大元のクエリと関連付けながら実行しているクエリを相関クエリと呼ぶ

/* where条件でサブクエリを使う */
-- priceが一番高いものレコードを取得したい場合
select id, product_name, price from products order by price desc limit 1;
-- 抽出してorder by で大きい順に並べ替えてlimitで件数を1件に絞って取得する方法と
select id, product_name, price from products where price = (select max(price) from products);
-- where条件でサブクエリを使って集計関数max()を使って抽出した値と同じものを抽出するの２つ場合がある

/* 抽出元でサブクエリを使う */
-- 国別の出品数を下記のように取得した結果に対して平均値を取得したい場合
select made_in, count(id) as item_number from products as table_1 group by made_in;
-- 下記のように抽出元に国別の出品数を抽出したサブクエリをかいてあげればいい
select avg(item_number) from (select made_in, count(id) as item_number from products group by made_in) as table_1;
-- select カラム名 from (サブクエリ) as 仮のテーブル名; で抽出結果に対して抽出をすることが出来る


-- MySQL でも 8.0 から Window 関数が使える
-- lesson12 ~ 16まではversion up後にまとめる

/* transaction */
-- transactionは指定した一連の処理中に他の処理を受け付けないようにするための記述方法でデータの整合性を保つための方法
-- transactionを実装するにはエラーを検出しないといけないので他のサーバーサイド言語と組み合わせて使う必要がある
start transaction;
update products set is_stocked = 0 where id = 10;
update products set is_stocked = 0 where id = 7;
-- commit; -- 処理を確定させる
rollback; -- transactionが始まる前の状態に戻す
select * from products;

/* 複数のテーブルを内部結合/外部結合 */

-- 投稿と投稿に対してコメントを紐づけられるテーブルを用意

create table posts ( -- 親テーブル
  id INT PRIMARY KEY AUTO_INCREMENT,
  message VARCHAR(140)
);

create table comments ( -- 子テーブル
  id INT PRIMARY KEY AUTO_INCREMENT,
  post_id INT,
  -- 上記のように親テーブルの主キー(id)をデータとして保持する為のカラムを用意 * どの投稿に対してのコメントなのかを関連付ける為
  comment VARCHAR(140)
);

insert into posts (message) values ('post-1'), ('post-2'), ('post-3');
insert into comments (post_id, comment) values (1, 'comment p1-1'), (1, 'comment p1-2'), (3, 'comment p3-1'), (4, 'comment p4-1');

select * from posts;
-- +----+---------+
-- | id | message |
-- +----+---------+
-- |  1 | post-1  |
-- |  2 | post-2  |
-- |  3 | post-3  |
-- +----+---------+

select * from comments;
-- +----+---------+--------------+
-- | id | post_id | comment      |
-- +----+---------+--------------+
-- |  1 |       1 | comment p1-1 |
-- |  2 |       1 | comment p1-2 |
-- |  3 |       3 | comment p3-1 |
-- |  4 |       4 | comment p4-1 |
-- +----+---------+--------------+

-- 上記の２つのテーブルの結合方法するには内部結合と外部結合の2種類ある

-- 内部結合は2つのテーブルに共通のデータを取得する方法で上記の場合は,子テーブルの post_id と 親テーブルの id が一致するレコードのみ結合する方法

-- select * from posts inner join comments on posts.id = comments.post_id;
-- select カラム名 from テーブル名(A) inner join テーブル名(B) on A.id = B.Aに紐づけたid; で内部結合出来る
-- ＊ 上記の inner は下記のように省略可能

select 
  -- posts.id, posts.message, comments.comment
  -- 2つのテーブルで同一のカラム名でない場合はテーブル名は下記ように省略出来る
  posts.id, message, comment
from 
  posts join comments on posts.id = comments.post_id;
-- +----+---------+--------------+
-- | id | message | comment      |
-- +----+---------+--------------+
-- |  1 | post-1  | comment p1-1 |
-- |  1 | post-1  | comment p1-2 |
-- |  3 | post-3  | comment p3-1 |
-- +----+---------+--------------+

-- 外部結合には左のテーブルを軸にした左外部結合と右のテーブルを軸にした右外部結合の2パターンがある
-- 指定した軸のデータに合わせて対応する箇所があれば値を取得して、無ければnullが設定される

-- select * from posts left outer join comments on posts.id = comments.post_id;
-- select カラム名 from テーブル名(A) left(or right) outer join テーブル名(B) on A.id = B.Bに紐づけたid; で外部結合出来る
-- ＊ 上記の outer は下記のように省略可能

select * from posts left join comments on posts.id = comments.post_id; -- 左外部結合
-- +----+---------+------+---------+--------------+
-- | id | message | id   | post_id | comment      |
-- +----+---------+------+---------+--------------+
-- |  1 | post-1  |    1 |       1 | comment p1-1 |
-- |  1 | post-1  |    2 |       1 | comment p1-2 |
-- |  3 | post-3  |    3 |       3 | comment p3-1 |
-- |  2 | post-2  | NULL |    NULL | NULL         |
-- +----+---------+------+---------+--------------+
select * from posts right join comments on posts.id = comments.post_id; -- 右外部結合
-- +------+---------+----+---------+--------------+
-- | id   | message | id | post_id | comment      |
-- +------+---------+----+---------+--------------+
-- |    1 | post-1  |  1 |       1 | comment p1-1 |
-- |    1 | post-1  |  2 |       1 | comment p1-2 |
-- |    3 | post-3  |  3 |       3 | comment p3-1 |
-- | NULL | NULL    |  4 |       4 | comment p4-1 |
-- +------+---------+----+---------+--------------+

/* 外部キーと整合性の確認 */

-- 外部キーに設定された子テーブルのカラムの値は親テーブルのidを参照してそこに同一の値がなければ弾くという設定
-- ＊ 参照元の親テーブルには、子テーブルと紐付いたレコードがある場合、削除や紐付いたカラムの値の更新は出来ないという制約が生まれる

drop table if exists comments;
drop table if exists posts;

create table posts (
  id INT PRIMARY KEY AUTO_INCREMENT,
  message VARCHAR(140)
);

create table comments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  post_id INT, -- postテーブルと紐付ける為のid
  comment VARCHAR(140),
  -- FOREIGN KEY (post_id) REFERENCES posts(id)
  -- 上記のように FOREIGN KEY (子テーブルで保持してる親テーブルの主キー) REFERENCES 親テーブル(主キー); の形で外部キーが設定出来る
  -- FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE
  -- 上記のように ON DELETE CASCADE を設定すれば親テーブルのレコードを削除した際に一緒に関連付いた子テーブルのレコードも削除してくれる
  FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE ON UPDATE CASCADE
  -- 上記のように ON DELETE CASCADE を設定すれば親テーブルのレコードの更新した際に子テーブルに反映される
);

insert into posts (message) values ('post-1'), ('post-2'), ('post-3');
insert into comments (post_id, comment) values (1, 'comment p1-1'), (1, 'comment p1-2'), (3, 'comment p3-1');

delete from posts where id = 3;
-- on delete cascade が設定されてるのでpostを削除すると関連のcommentも削除されている
select * from posts;
-- +----+---------+
-- | id | message |
-- +----+---------+
-- |  1 | post-1  |
-- |  2 | post-2  |
-- +----+---------+
select * from comments;
-- +----+---------+--------------+-----------+
-- | id | post_id | comment      | parent_id |
-- +----+---------+--------------+-----------+
-- |  1 |       1 | comment p1-1 |      NULL |
-- |  2 |       1 | comment p1-2 |      NULL |
-- +----+---------+--------------+-----------+

insert into posts (message) values ('post-4');
insert into comments (post_id, comment) values (last_insert_id(), 'comment p4-1');
-- 上記のように last_insert_id() を使えば直前で挿入されたレコードのidを取得することが出来る
select * from posts;
-- +----+---------+
-- | id | message |
-- +----+---------+
-- |  1 | post-1  |
-- |  2 | post-2  |
-- |  4 | post-4  |
-- +----+---------+
select * from comments;
-- +----+---------+--------------+
-- | id | post_id | comment      |
-- +----+---------+--------------+
-- |  1 |       1 | comment p1-1 |
-- |  2 |       1 | comment p1-2 |
-- |  4 |       4 | comment p4-1 |
-- +----+---------+--------------+
update posts set id = 100 where id = 4;
-- on update cascade が設定されてるのでpostのidが変更されると関連のcommentテーブルのpost_idも変更されている
select * from posts;
-- +-----+---------+
-- | id  | message |
-- +-----+---------+
-- |   1 | post-1  |
-- |   2 | post-2  |
-- | 100 | post-4  |
-- +-----+---------+
select * from comments;
-- +----+---------+--------------+
-- | id | post_id | comment      |
-- +----+---------+--------------+
-- |  1 |       1 | comment p1-1 |
-- |  2 |       1 | comment p1-2 |
-- |  4 |     100 | comment p4-1 |
-- +----+---------+--------------+


/* コメントにコメントをつける */

drop table if exists comments;
drop table if exists posts;

create table posts (
  id INT PRIMARY KEY AUTO_INCREMENT,
  message VARCHAR(140)
);

create table comments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  post_id INT, -- postテーブルと紐付ける為のid
  comment VARCHAR(140),
  FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE ON UPDATE CASCADE,
  parent_id INT -- 階層を作る為のid
);

insert into posts (message) values ('post-1'), ('post-2'), ('post-3');
insert into 
  comments (post_id, comment, parent_id) 
values 
  (1, 'comment p1-1', null),
  (1, 'comment p1-2', null),
  (3, 'comment p3-1', null),
  (1, 'comment p1-c2-1', 2),
  (1, 'comment p1-c2-2', 2),
  (1, 'comment p1-c2-1-1', 4);
/*
/* 上記のinsertで下記のような階層になっている
  post-1
    comment-p1-1
    comment-p1-2
      comment-p1-2-1
        comment-p1-2-1-1
      comment-p1-2-2
  post-2
  post-3
    comment-p3-1
*/
select * from posts;
select * from comments;
select * from comments where parent_id = 2;
-- 2階層目のコメントを全て取得する場合は上記のように取得出来る
select comments.* from (select * from comments where parent_id = 2) as layer_2 join comments on layer_2.id = comments.parent_id;
-- 3階層目のコメントを取得する場合は2階層目のコメントのidとcommentsテーブルのparent_idが一致するもので探せば取得出来る

(select * from comments where parent_id = 2)
union all
(select comments.* from (select * from comments where parent_id = 2) as layer_2 join comments on layer_2.id = comments.parent_id);
-- 上記で取得した内容をunion allで結合すればpost１に対するコメントより下の階層のコメントまとめて表示出来る


-- CTEはmysql: version 8.0 ~ 後でまとめる

/* trigger */
-- trigger あるテーブルで何らかの変更が怒った際にそれをトリガーにして何らかの処理をする仕組みのこと
drop table if exists comments;
drop table if exists posts;
drop table if exists logs;
drop trigger if exists posts_update_trigger;

create table posts (
  id INT PRIMARY KEY AUTO_INCREMENT,
  message VARCHAR(140)
);

create table logs (
  id INT PRIMARY KEY AUTO_INCREMENT,
  message VARCHAR(140),
  created DATETIME DEFAULT NOW() 
);

-- postsテーブルが更新されたらログが残したい時下記のように記述すればいい
-- create trigger posts_update_trigger after update on posts for each row insert into logs (message) values ('updated'); 
-- create trigger トリガー名 実行タイミング(after / before) イベント(insert / update / delete) on テーブル名 for each row 処理したいSQL文;
create trigger posts_update_trigger after update on posts for each row insert into logs (message) values (concat( old.message, ' -> ', new.message));
-- 上記はpostsテーブルが更新された後にlogsテーブルに変更前のmessageと変更後のmessageを挿入するという意味
-- triggerではoldとnewキーワードが使えて更新前をold.カラム名で更新後をnew.カラム名で取得出来る
insert into posts (message) values ('post-1'), ('post-2'), ('post-3');

update posts set message = 'post-1 updated' where id = 1;

select * from posts;
select * from logs;

show triggers\G
-- show triggers; で設定されているトリガーの情報を見れる \G は横に長くなってしまった際に見やすくしてくれる

/* 外部ファイルの読み込み */
-- trigger あるテーブルで何らかの変更が怒った際にそれをトリガーにして何らかの処理をする仕組みのこと
drop table if exists logs;
drop trigger if exists posts_update_trigger;
drop table if exists posts;

create table posts_2 (
  id INT PRIMARY KEY AUTO_INCREMENT,
  message VARCHAR(140),
  likes INT,
  area VARCHAR(20)
);

load data local infile 'data.csv' into table posts_2
-- load data local infile 'ファイル名' into table テーブル名; で同じサーバー内の外部ファイルを読み込める
  fields terminated by ','
  -- 項目が「,」区切りの場合は fields terminated by ',' とオプションを設定する
  lines terminated by '\r\n'
  -- レコードの区切りが改行の場合は lines terminated by '\r\n' とオプションを設定する
  ignore 1 lines
  -- 上記のオプションは最初の1行が無視するという設定
  -- (message, likes, area);
  -- 最後に上記のようにカラムを指定すればいい
  --  ＊ 読み込むファイル形式に応じて別のオプションを設ける必要があることに注意
  (@message,@likes,@area,@id)
  set id = @id,
  message = @message,
  likes = @likes,
  area = @area;
  -- 読み込むCSVファイルとカラムの順番とMySQL側のカラムの順番が対応しない場合は
  -- 上記のようにCSVファイル側のカラムに任意の変数(@変数名)を割り当てて、それをMySQL側のカラムに対応させる形でset句を使ってこの変数とMySQLテーブルのカラム名を対応付けている

select * from posts_2;

/* index */
-- mysqlではある検索条件を設けてselect文で抽出する際にDBの先頭から順番に見て行って合致するものを選ぶ仕組みになっている
-- その為、膨大なレコードの検索をする際には時間がかかってしまいパフォーマンスが落ちることが懸念される
-- そういった問題を解決する為に良く検索されるカラムに対してはindexを設けることでパフォーマンスを向上させることが出来る
-- indexは元データとは別に保持される索引のようなデータで、予め値を整列させた上で範囲毎に区切られている為上から順に見ることなく効率的に検索できる
-- ただし、indexを作ると検索は早くなるがデータの挿入、更新、削除をするとindexを再構築する必要があるので遅くなる
-- またindex分のデータベースに必要な容量がふえてしまう問題がある
-- その為、indexはデータベースの運用状況をみながら必要なカラムに対してつけはずしが出来るようにしておくのがいい
-- 主キーに対してはPRIMARYというindexが自動的に生成されるのでidを使った検索は高速で行える

show index from posts_2 \G;
-- show index from テーブル名; テーブルに設定されたindexを下記のように確認出来る
--         Table: posts_2
--    Non_unique: 0
--      Key_name: PRIMARY ← PRIMARYという名前のindexが設定されている
--  Seq_in_index: 1
--   Column_name: id ← idカラム
--     Collation: A
--   Cardinality: 10
--      Sub_part: NULL
--        Packed: NULL
--          Null:
--    Index_type: BTREE
--       Comment:
-- Index_comment:

explain select * from posts_2 where id = 10 \G;
-- explain select文; で検索にどのindexがついているか調べる事が出来る
--            id: 1
--   select_type: SIMPLE
--         table: posts_2
--    partitions: NULL
--          type: const
-- possible_keys: PRIMARY
--           key: PRIMARY ← 上記のクエリで使われたindexの名前
--       key_len: 4
--           ref: const
--          rows: 1 ← 上記のクエリで検索対象になったレコード数 rowsが１なので高速で処理されていることがわかる
--      filtered: 100.00
--         Extra: NULL

explain select * from posts_2 where area = 'Tokyo' \G;
-- 下記のようにidを使わなかった検索に関してはkeyがnullでindexが使われてないこととrowsは10なので結果を出すのに10件のレコードを確認したことが分かる
--            id: 1
--   select_type: SIMPLE
--         table: posts_2
--    partitions: NULL
--          type: ALL
-- possible_keys: NULL
--           key: NULL
--       key_len: NULL
--           ref: NULL
--          rows: 10
--      filtered: 10.00
--         Extra: Using where

alter table posts_2 add index index_area(area);
-- alter table テーブル名 add index index名(indexをつけるカラム名); でindexをつけることが出来る
-- indexはcreate tableの際に設定可能だが運用状況を見て、後からつけたり外したりすることが多いので上記のようにalter tableでつけたパターンを確認
show index from posts_2;
-- +---------+------------+------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
-- | Table   | Non_unique | Key_name   | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
-- +---------+------------+------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
-- | posts_2 |          0 | PRIMARY    |            1 | id          | A         |          10 |     NULL | NULL   |      | BTREE      |         |               |
-- | posts_2 |          1 | index_area |            1 | area        | A         |           4 |     NULL | NULL   | YES  | BTREE      |         |               |
-- +---------+------------+------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
explain select * from posts_2 where area = 'Tokyo' \G;
--            id: 1
--   select_type: SIMPLE
--         table: posts_2
--    partitions: NULL
--          type: ref
-- possible_keys: index_area
--           key: index_area
--       key_len: 23
--           ref: const
--          rows: 2
--      filtered: 100.00
--         Extra: NULL
-- 上記のようにpost_2テーブルにはkey_nameに2つのindexが設定されている事が分かり、explainの検索結果にもindex_areを使って高速に処理されていることが分かる

alter table posts_2 drop index index_area;
-- alter table テーブル名 drop index index名; でindexを外す事が出来る
show index from posts_2;
-- +---------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
-- | Table   | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
-- +---------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
-- | posts_2 |          0 | PRIMARY  |            1 | id          | A         |          10 |     NULL | NULL   |      | BTREE      |         |               |
-- +---------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
-- 上記のようにindexが外れていることが確認出来る