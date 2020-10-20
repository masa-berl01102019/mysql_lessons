drop database if exists test_db;

create database test_db;
-- 上記のコマンドでデータベースを作成

use test_db;
-- 上記のコマンドで操作したいデータベースを選択出来る

-- select version();
-- 上記のコマンドでversionの確認が出来る
-- +-----------+
-- | version() |
-- +-----------+
-- | 5.7.29    |
-- +-----------+

-- create table posts ( --postsはテーブル名
--   message varchar(140), --カラム名 data型を指定 * 複数ある場合は「,」で区切る
--   likes int
-- );
-- 上記のコマンドでテーブルを作成

-- desc posts;
-- 上記のコマンドでテーブルの構造を確認出来る
-- +---------+--------------+------+-----+---------+-------+
-- | Field   | Type         | Null | Key | Default | Extra |
-- +---------+--------------+------+-----+---------+-------+
-- | message | varchar(140) | YES  |     | NULL    |       |
-- | likes   | int(11)      | YES  |     | NULL    |       |
-- +---------+--------------+------+-----+---------+-------+
-- 2 rows in set (0.01 sec)

-- show tables;
-- 上記のコマンドでDB内のテーブルの一覧が取得できる
-- +-------------------+
-- | Tables_in_test_db |
-- +-------------------+
-- | posts             |
-- +-------------------+
-- 1 row in set (0.00 sec)

-- drop table if exists posts;
-- drop table テーブル名でテーブルを削除出来る
-- drop table if exists posts;
-- 上記のようにif exists をテーブル名の直前に置けば指定のテーブルがあればと条件分岐をして削除出来る

-- create table posts (
--   message varchar(140),
--   likes int
-- );

-- insert into posts (message, likes) values ('Thanks', 12);
-- insert into  テーブル名 (カラム名) values (値)の形でレコードを挿入出来る
-- insert into posts (message, likes) values ('Arigato', 4);
--  上記のようにまとめてレコードを挿入したい場合は下記のように書き換える事も出来る
-- insert into posts (message, likes) values ('Thanks', 12), ('arigato', 4);


/* mysql のデータ型一覧
  整数:
    ＊下記のように扱える数字の幅によって分けられている
    - TINYINT:  -128 ~ +127
    - INT:      -21億 ~ +21億
    - BIGINT:   -922京 ~ +922京
    ＊マイナスの値を扱わない場合はUNSIGNEDをつける事で下記のように扱えるデータの幅が増える
    - TINYINT UNSIGNED: 0 ~ 255
    - INT UNSIGNED:     0 ~ 42億
    - BIGINT UNSIGNED:  0 ~ 1844京
  実数: 
    - DECIMAL: 固定小数点
    - FLOAT: 浮動小数点
    - DOUBLE: 浮動小数点（高精度）
    ＊ 浮動小数点は細かいところで誤差が出るので通常はDECIMALを使えばいい
  文字列: 
    - CHAR:     0 ~ 255文字
    - VARCHAR:  0 ~ 65535文字
    - TEXT:     それ以上
    ＊ ここでの文字数の制限にはBYTE数は関係ない=> 日本語 3byteと考えなくていい
    ＊ CHARは格納される値が固定長のデータに合っている、VARCHARは可変長のデータに合っている
    - ENUM: 特定の文字列から一つの値だけ格納したい場合
    - SET: 特定の文字列から複数の値だけ格納したい場合
  真偽値: 
    - BOOL: true / false
    ＊ 内部的にはtrueが1, falseが0として管理されるのでTINYINT(1) 1 / 0 と同じ型でもある
  日時: 
    - DATE: 日付
    - TIME: 時間
    - DATETIME: 両方扱う場合はこっちをつかう
*/

drop table if exists products;

create table products (
  id INT PRIMARY KEY AUTO_INCREMENT,
  -- PRIMARY KEY で主キーを設定することで値の挿入漏れや重複があるとerrorを返す * nullを挿入されてもerrorを返す
  -- AUTO_INCREMENT でカラムに値を挿入しなくても値を1から連番で振ってくれる * PRIMARY KEY がないと動作しない
  product_name VARCHAR(140),
  product_number INT UNIQUE,
  -- UNIQUE で指定されたカラムは値の重複があるとerrorを返す
  points DECIMAL(4,2) UNSIGNED,
  -- decimal(全体の桁数,小数点第何位まで含むか) ex) 10.325 → 10.33
  care_label CHAR(2),
  target_category ENUM('mens', 'ladies', 'kids'),
  -- enum('文字列', ...) 特定の文字列から一つだけ選択可でそれ以外の文字列はerrorを返す
  item_category SET('tops', 'bottoms', 'jacket', 'skirt', 'inner', 'outer'),
  -- set('文字列', ...) 特定の文字列から複数選択可でそれ以外の文字列はerrorを返す
  -- set (2の0乗 = 1, 2の１乗 = 2, 2の2乗 = 4)と内部的に管理されている
  is_stocked BOOL DEFAULT TRUE,
  -- DEFAULT 値 で何も挿入されなかった場合に適用する値を指定出来る
  posted DATETIME NOT NULL,
  created DATETIME DEFAULT NOW(),
  -- DEFAULT NOW() で作成された時点での現在時刻の取得
  updated DATETIME DEFAULT NOW() ON UPDATE NOW()
  -- ON UPDATE NOW() で更新された時点での現在時刻の取得
);
-- points DECIMAL(4,2) CHECK(points >= 0 AND points <= 10)
-- MySQL 8.0.16以上でcheck制約で値を制限することが出来る
-- TIMESTAMP と DATETIME のタイムゾーン設定時の挙動の違い
-- DATETIME はタイムゾーンの影響を受けず、登録した日時がそのまま保存される
-- TIMESTAMP は保存時には UTC 時間に変換し、取得する際は設定中のタイムゾーンでの時間に変換される
-- 越境ECなど、多国で使用するシステムでは日時は TIMESTAMP 型にすると便利
-- ＊ TIMESTAMP 型は現時点で2038年以降のデータを使う場合は TIMESTAMP 型は使えないので注意

insert into products 
  (product_name, product_number, points, care_label, target_category, item_category, is_stocked, posted)
values
  ('stretch pants'  , 17068543, 7.825  , 'EN',    1    , 'bottoms'   , 0     , '2020-12-30 15:32:22'),
    -- ENUMは()内の選択肢が1～ｎ番目かを指定することでも表現出来る
  ('print T-shirts' , 17068544, 3.7542 , 'KO', 'kids'  , 'tops,inner', 1     , '2020-12-30 11:20:47'),
  -- SETは選択肢を複数選ぶ場合は’選択肢1,選択肢2’と書く * ' '内はカンマ以外入れられない
  ('wool_100% setup', 17068545, 5.2    , 'AR', 'ladies',      6      , true  , '2021-1-18 17:32:29'),
  -- SETは2の乗数で指定出来、複数選択する場合 bottoms(2) + jacket(4) = 6で指定出来る
  ('color jeans'    , 17068546, 4.2138 , 'JA', 'ladies',      2      , false , '2021-1-18'),
  -- DATETIMEは時間を省略すると 00:00:00 となる
  ('denim jacket'   , 17068547, 6.2138 , 'DE', 'kids'  , 'jacket'    , 1     , now());
  -- DATETIMEはnow()で現在時刻を取得することが出来る


insert into products 
  (product_name, product_number, points, target_category, item_category, posted)
values  
  ('military jacket', 17068548, 9.2138 , 'mens'  , 'jacket',  now()),
  -- 一部のカラムだけを値を挿入すると指定されなかったカラムの値はnullになりデフォルト値があればデフォルト値が適用される
  ('short pants'    , 17068549, 7.88 , 'ladies', 'bottoms', now());


/* select文を使ったデータの取得 */
select * from products;
-- select カラム名 from テーブル名; で指定したカラムの値を取得できる * 「＊」は全ての意味
select id, product_name from products;
-- 複数の特定のカラムの値だけを取得したい場合はカラム名を 「,」区切りで書いてあげればいい

/* whereで条件をつけてデータの取得 */
select id, product_name, points from products where points >= 6;
-- whereで条件分岐して値を取得することも出来る
-- 演算子 >, >= , < , >= , != , <> (!= と同じ意味), =  * = は常に右側

/* OR, AND, BETWEEN, IN で複数条件でのデータの取得 */
select id, product_name, product_number from products where product_number >= 17068545 and product_number <= 17068547;
-- AND（なおかつ）を使って条件を組み合わせられる
select id, product_name, product_number from products where product_number between 17068545 and 17068547;
-- where カラム名 between 値 and 値; betweenで値の範囲を指定して取得出来る * 上記のANDを使ったqueryと同じ意味
select id, product_name, product_number from products where product_number not between 17068545 and 17068547;
-- not をbetweenの前につければ反転した条件で取得出来る
select id, product_name, target_category from products where target_category = 'mens' or target_category = 'kids';
-- OR（もしくは）を使って条件を組み合わせられる
select id, product_name, target_category from products where target_category in ('mens', 'kids');
-- where カラム名 in(値, 値); inで指定した値のどちらかが含まれる値を取得出来る * 上記のORを使ったqueryと同じ意味
select id, product_name, target_category from products where target_category not in ('mens', 'kids');
-- not をinの前につければ反転した条件で取得出来

/* LIKE で文字列の部分一致データの取得 */
select id, product_name from products where product_name like 's%'; -- 前方一致
select id, product_name from products where product_name like '%jacket'; -- 後方一致
select id, product_name from products where product_name like '%t%'; -- 部分一致
select id, product_name from products where product_name like binary '%T%'; -- binary で大文字と小文字の区別
select id, product_name from products where product_name like '__l%'; -- 三文字目がlで始まる文字列の抽出
select id, product_name from products where product_name not like '%t%'; -- 条件の反転 tを含まない
-- where カラム名 like '条件' で文字列の部分一致検索が出来る
-- 「%」: 0文字上の任意の文字
-- 「_」: 1文字の任意の文字
-- 「%」や「_」自体を検索したい場合は直前にバックスラッシュつけてエスケープすればいい

/* nullの入ったレコードのデータの取得する上での注意点 */
select id, product_name, care_label from products;
-- 単純にカラム名だけを指定して抽出すると値がnullのレコードも取得出来るが
select id, product_name, care_label from products where care_label != 'EN';
-- 上記のようにwhereなどで条件を絞った場合に値がnullのレコードは取得出来ない
select id, product_name, care_label from products where care_label != 'EN' or care_label is null;
-- 上記のようにnullのレコードも取得したい場合は or カラム名 is null と指定すれば取得出来る
select id, product_name, care_label from products where care_label is not null;
-- 上記のようにnullのレコードは取得したくない場合は where カラム名 is not null と指定すれば取得出来る

/* order by, limit, offset で取得したデータの並び替えと件数の絞り込み*/
select id, product_name, posted from products order by posted;
-- order by で値の小さい順もしくは時間の古い順に取得したレコードを並び替える事が出来る
select id, product_name, posted from products order by posted desc;
-- order by カラム名 desc で値の大きい順もしくは時間の新しい順に取得したレコードを並び替える事が出来る
select id, product_name, posted, points from products order by posted desc, points;
-- order by で並び替える際に同一の値があった場合にカンマ区切りでカラムを指定して並び替えの基準を加えられる
-- 上記は postedをdescで新しい順に並び替えた後に, 同一日時のレコードはpointsの小さい順に並び替えている
select id, product_name, posted, points from products order by posted, points desc limit 3;
-- limit で取得するレコードの件数を指定して上から取得出来る
select id, product_name, posted, points from products order by posted, points desc limit 2 offset 1;
-- limit 件数 offset 取得のスタート位置; で取得するレコードの開始位置を決めて指定の件数を取得出来る
-- レコードは上から0,1,2となっているのでoffset 1 は一番最初のレコードを除外してという意味になる

/* 演算子(+, -, *, /, %) や数値の関数(round, ceil, floor)を使って加工したデータの取得*/
-- 購入した商品の1ポイントあたり50円で三分の１がキャッシュバックされたと仮定すると下記のようになる
select 
  id, 
  product_name, 
  points * 50 / 3 as cashback,
  floor(points * 50 / 3) as cashback_floor, -- 小数点以下切り捨て
  ceil(points * 50 / 3) as cashback_ceil,   -- 小数点以下繰り上げ
  round(points * 50 / 3) as cashback_round, -- 小数点以下で四捨五入
  round(points * 50 / 3, 2) as cashback_round2  -- 小数点第二位で四捨五入 * 第二引数で小数点以下第何位か指定出来る
from 
  products;
-- as 新しいカラム名で集計した値の入るカラム名を作成出来る

/* 文字列の関数(substring, concat, length)を使って加工したデータの取得 */
select 
 id,
 product_name, --  wool_100% setup
 substring(product_name, 6) as cut_name1,    -- 6文字目以降の切り出し -> 100% setup
 substring(product_name, 1, 4) as cut_name2, -- 1文字目以降から4文字切り出し -> wool
 substring(product_name, -5) as cut_name3    -- 後ろから5文字目以降の切り出し -> setup
from 
  products
where 
  id = 3;
-- substring(カラム名, スタート位置, 文字数)でスタート位置以降の文字列を切り出せる
select id, concat(product_name, '@', target_category) as renames from products;
-- concat(カラム名, ' 結合部の文字列 ', カラム名)で指定したカラムの値を連結出来る
select id, product_name, length(product_name) as name_length from products;
-- length(カラム名)で指定したカラムの値を文字数を取得出来る
-- ＊ length() は日本語は1文字当たり３ずつカウントされてしまうのでchar_length(カラム名)とすれば正しく文字数をカウント出来る
-- ＊ 日本語でおかしくなるのはlength()だけなのでsubstring()は上手く機能する

/* 日時の関数(substring, concat, length)を使って加工したデータの取得 */
select 
  id, 
  year(posted), -- 年の取得
  date_format(posted, '%M %D %Y, %W') as new_format, -- 日時のformatを変更
  date_add(posted, interval 7 day) as add_week, -- 7日後の日時を取得
  posted, -- 投稿された日
  now(), -- 現在の日時
  datediff(posted, now()) as diff -- 投稿日と現在の日時でどれだけの日数離れているか取得
from 
  products;
-- year(), month(), day(), hour(), minute(), second() でそれぞれカラムから年:月:日:時:分:秒を抜き出せる
-- date_format(カラム名, 'formatの形式')で日時を変更して取得出来る
-- formatの形式は公式で確認 https://dev.mysql.com/doc/refman/5.7/en/date-and-time-functions.html#function_date-add
-- date_add(カラム名, interval 数字 日時の単位) で指定のカラムの日時に時間や日を足してデータを取得出来る
-- datediff(カラム名,カラム名)で2つの日時の差異を計算してくれる

/* レコードの更新 */
select id, product_name, points * 100 from products;
-- select文で加工したデータの取得をしても実際のDBの値が書き換わるわけではないので
select id, product_name, points from products;
-- もう一度 select文で確認しても、当然元データが表示されるので下記のupdate文を使う
update products set care_label = 'JA';
-- update テーブル名 set カラム名 = 値; で指定したカラムのすべての値を書き換えることが出来る
-- 在庫のあるものはポイント10倍にするという更新の場合、下記のようになる
update 
  products 
set 
  product_name = upper(product_name), -- upper()で大文字に変換出来る
  points = points * 10
where
  is_stocked = true;
-- 上記のようにwhereを使って特定のレコードに対して、カンマ区切りで複数のカラムを指定して値を変更出来る
select id, product_name, care_label, points, is_stocked from products;
-- 確認するときちんと元のデータの値が書き換わってる

/* レコードの削除 */
-- delete from products;
-- delete from テーブル名; 全てのレコードの削除出来る
-- ＊tableごと削除する場合は drop table テーブル名;
-- delete from products where id = 7;
-- 通常 delete文を使うときはwhereで特定のレコードを指定して削除する
-- insert into products (product_name, posted) values ('socks', now());
-- 削除されたレコードのid等(auto_incrementで連番で管理しているもの) は欠番となる
-- select * from products;

-- truncate table products;
-- truncate table テーブル名; でテーブルごと削除して再作成されるので欠番になった番号を使えるようになる
-- insert into products (product_name, posted) values ('socks', now());
-- select * from products;

/* 作成日時と更新日時を自動設定 */
insert into products (product_name, posted) values ('socks', now());
select id, product_name, created, updated from products where id = 1 or id = 8;

select sleep(3);
-- select sleep(秒数) で一定時間待たせて次の処理を見る
update products set product_name = 'yellow socks' where id = 8;

select id, product_name, created, updated from products where id = 1 or id = 8;

/* テーブルの設計の変更 */
alter table products add season set ('spring', 'summer', 'fall', 'winter');
-- alter table テーブル名 add 追加したいカラム名 データ型; でカラムを追加することが出来る *基本的に一番下に追加される
desc products;
alter table products add cost int not null after points;
-- after カラム名 をつけることでカラムを追加する位置を指定することも出来る 
desc products;
alter table products add img varchar(600) first;
-- beforeというキーワードはないので一番先頭にカラムを加えたい場合は first というキーワードを使えばいい
desc products;
alter table products drop img;
-- alter table テーブル名 drop 削除したいカラム名; でカラムを削除することが出来る
desc products;
alter table products change points price int;
-- alter table テーブル名 change 変更したいカラム名 変更後のカラム名 データ型; でカラムを変更することが出来る
desc products;
select * from products;
-- changeはなるべく既存のデータを保持しようとするが、データが消えてしまう可能性もあるので注意が必要
alter table products rename items;
-- alter table テーブル名 rename 変更後のテーブル名; でテーブル名を変更することが出来る
show tables;