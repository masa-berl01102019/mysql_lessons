drop database if exists ec_db;
create database ec_db;
use ec_db;

-- demo table 作成

create table users (
  id int primary key auto_increment,
  `name` varchar(50) not null,
  gender enum('man','woman') not null,
  date_of_birth datetime not null,
  tell varchar(20) not null,
  adress varchar(50) not null,
  email varchar(50) not null unique,
  created datetime default now(),
  updated datetime default now() on update now()
);

-- desc users;

create table order_recodes (
  id int primary key auto_increment,
  user_id int not null,
  foreign key (user_id) references users(id) on update cascade,
  order_date datetime default now(),
  sub_total int unsigned not null,
  tax_amount int unsigned not null,
  total_amount int unsigned not null
);

-- desc order_recodes;

create table items (
  id int primary key auto_increment,
  item_name varchar(100) not null,
  price int unsigned not null, 
  cost int unsigned not null,
  comment varchar(100),
  `description` text,
  season set('spring', 'summer', 'autumn', 'winter') not null,
  created datetime default now(),
  updated datetime default now() on update now()
);

-- desc items;

create table images (
  id int primary key auto_increment,
  item_id int not null,
  foreign key (item_id) references items(id) on delete cascade on update cascade,
  main_pic varchar(150) not null,
  thumbnail_pic1 varchar(150),
  thumbnail_pic2 varchar(150),
  thumbnail_pic3 varchar(150),
  created datetime default now(),
  updated datetime default now() on update now()
);

-- desc images;

create table sizes (
  id int primary key auto_increment,
  item_id int not null,
  foreign key (item_id) references items(id) on delete cascade on update cascade,
  size enum('S', 'M', 'L'),
  width int unsigned,
  sholder_width int unsigned,
  raglan_sleeve_length int unsigned,
  sleeve_length int unsigned,
  `length` int unsigned,
  waist int unsigned,
  hip int unsigned,
  rise int unsigned,
  inseam int unsigned,
  thigh_width int unsigned,
  outseam int unsigned,
  sk_length int unsigned,
  hem_width int unsigned,
  `weight` int unsigned,
  created datetime default now(),
  updated datetime DEFAULT now() on update now()
);

-- desc sizes;

create table stocks (
  id int primary key auto_increment,
  item_id int not null,
  foreign key (item_id) references items(id) on delete cascade on update cascade,
  color varchar(50) not null,
  quantity_s int unsigned,
  quantity_m int unsigned,
  quantity_l int unsigned,
  created datetime default now(),
  updated datetime DEFAULT now() on update now()
);

-- desc stocks;

create table order_details (
  id int primary key auto_increment,
  order_id int not null,
  foreign key (order_id) references order_recodes(id) on delete cascade on update cascade,
  item_id int not null,
  foreign key (item_id) references items(id) on update cascade,
  item_name varchar(100) not null,
  price int unsigned not null, 
  quantity int unsigned not null
);

-- desc order_details;

create table categories (
  id int primary key auto_increment,
  category_name varchar(50) not null,
  parent_id int
);

-- desc categories;

create table item_category (
  id int primary key auto_increment,
  item_id int not null,
  foreign key (item_id) references items(id) on delete cascade on update cascade,
  category_id int not null,
  foreign key (category_id) references categories(id) on delete cascade on update cascade
);

-- desc item_category;

-- demo data 挿入

load data local infile 'users_demo.csv' into table users
  fields terminated by ','
  lines terminated by '\r\n'
  ignore 1 lines
  (@id,@name,@gender,@date_of_birth,@tell,@adress,@email)
  set id=@id,
  name=@name,
  gender=@gender,
  date_of_birth=@date_of_birth,
  tell=@tell,
  adress=@adress,
  email=@email;

-- select * from users;

load data local infile 'items_demo.csv' into table items
  fields terminated by ','
  lines terminated by '\r\n'
  ignore 1 lines
  (@id,@item_name,@price,@cost,@comment,@description,@season)
  set id=@id,
  item_name=@item_name,
  price=@price,
  cost=@cost,
  comment=@comment,
  description=@description,
  season=@season;

-- select * from items;

load data local infile 'order_recodes_demo.csv' into table order_recodes
  fields terminated by ','
  lines terminated by '\r\n'
  ignore 1 lines
  (@id,@user_id,@order_date,@sub_total,@tax_amount,@total_amount)
  set id=@id,
  user_id=@user_id,
  order_date=@order_date,
  sub_total=@sub_total,
  tax_amount=@tax_amount,
  total_amount=@total_amount;

-- select * from order_recodes;

load data local infile 'order_details_demo.csv' into table order_details
  fields terminated by ','
  lines terminated by '\r\n'
  ignore 1 lines
  (@id,@order_id,@item_id,@item_name,@price,@quantity)
  set id=@id,
  order_id=@order_id,
  item_id=@item_id,
  item_name=@item_name,
  price=@price,
  quantity=@quantity;

-- select * from order_details;

load data local infile 'images_demo.csv' into table images
  fields terminated by ','
  lines terminated by '\r\n'
  ignore 1 lines
  (@id,@item_id,@main_pic,@thumbnail_pic1,@thumbnail_pic2,@thumbnail_pic3)
  set id=@id,
  item_id=@item_id,
  main_pic=@main_pic,
  thumbnail_pic1=@thumbnail_pic1,
  thumbnail_pic2=@thumbnail_pic2,
  thumbnail_pic3=@thumbnail_pic3;

-- select * from images;

load data local infile 'sizes_demo.csv' into table sizes
  fields terminated by ','
  lines terminated by '\r\n'
  ignore 1 lines
  (@id,@item_id,@size,@width,@sholder_width,@raglan_sleeve_length,@sleeve_length,@length,@waist,@hip,@rise,@inseam,@thigh_width,@outseam,@sk_length,@hem_width,@weight)
  set id=@id,
  item_id=@item_id,
  size=@size,
  width=@width,
  sholder_width=@sholder_width,
  raglan_sleeve_length=@raglan_sleeve_length,
  sleeve_length=@sleeve_length,
  length=@length,
  waist=@waist,
  hip=@hip,
  rise=@rise,
  inseam=@inseam,
  thigh_width=@thigh_width,
  outseam=@outseam,
  sk_length=@sk_length,
  hem_width=@hem_width,
  weight=@weight;

-- select * from sizes;

load data local infile 'stocks_demo.csv' into table stocks
  fields terminated by ','
  lines terminated by '\r\n'
  ignore 1 lines
  (@id,@item_id,@color,@quantity_s,@quantity_m,@quantity_l)
  set id=@id,
  item_id=@item_id,
  color=@color,
  quantity_s=@quantity_s,
  quantity_m=@quantity_m,
  quantity_l=@quantity_l;

-- select * from stocks;

load data local infile 'category_demo.csv' into table categories
  fields terminated by ','
  lines terminated by '\r\n'
  ignore 1 lines
  (@id,@category_name,@parent_id)
  set id=@id,
  category_name=@category_name,
  parent_id=@parent_id;

-- select * from categories;

load data local infile 'item_category_demo.csv' into table item_category
  fields terminated by ','
  lines terminated by '\r\n'
  ignore 1 lines
  (@id,@item_id,@category_id)
  set id=@id,
  item_id=@item_id,
  category_id=@category_id;

-- select * from item_category;


/*  user画面 */

-- 商品一覧画面 
select  items.id, item_name ,price, main_pic from items join images on items.id = images.item_id;
-- +----+------------------+-------+------------------------------+
-- | id | item_name        | price | main_pic                     |
-- +----+------------------+-------+------------------------------+
-- |  1 | military jacket  |  5800 | ./img/main_pic/clothes1.jpg  |
-- |  2 | BD shirts        |  3200 | ./img/main_pic/clothes2.jpg  |
-- |  3 | print T-shirts C |  1200 | ./img/main_pic/clothes3.jpg  |
-- |  4 | pleats skirt     |  2200 | ./img/main_pic/clothes4.jpg  |
-- |  5 | merino wool knit |  2200 | ./img/main_pic/clothes5.jpg  |
-- |  6 | logo T-shirts    |  1800 | ./img/main_pic/clothes6.jpg  |
-- |  7 | short pants      |  2300 | ./img/main_pic/clothes7.jpg  |
-- |  8 | print T-shirts B |  1000 | ./img/main_pic/clothes8.jpg  |
-- |  9 | pullover         |  1700 | ./img/main_pic/clothes9.jpg  |
-- | 10 | color pants      |  3400 | ./img/main_pic/clothes10.jpg |
-- | 11 | print T-shirts A |  1400 | ./img/main_pic/clothes11.jpg |
-- +----+------------------+-------+------------------------------+

-- 商品詳細画面 (ex id= 1)

-- イメージ, 商品説明等の詳細
select  items.id, item_name ,price, comment, `description`, season, main_pic, thumbnail_pic1,thumbnail_pic2, thumbnail_pic3 from items join images on items.id = images.item_id where items.id = 1 \G
--             id: 1
--      item_name: military jacket
--          price: 5800
--        comment: comment
--    description: color/fablic/madein
--         season: autumn
--       main_pic: ./img/main_pic/clothes1.jpg
-- thumbnail_pic1: ./img/thumbnail/clothes1.jpg
-- thumbnail_pic2: ./img/thumbnail/clothes1.jpg
-- thumbnail_pic3: ./img/thumbnail/clothes1.jpg

-- サイズの詳細
select items.id, item_name, size, width, sholder_width, sleeve_length, `length` from items join sizes on items.id = sizes.item_id where items.id = 1;
-- +----+-----------------+------+-------+---------------+---------------+--------+
-- | id | item_name       | size | width | sholder_width | sleeve_length | length |
-- +----+-----------------+------+-------+---------------+---------------+--------+
-- |  1 | military jacket | S    |    61 |            52 |            57 |     72 |
-- |  1 | military jacket | M    |    62 |            53 |            58 |     73 |
-- |  1 | military jacket | L    |    63 |            54 |            59 |     74 |
-- +----+-----------------+------+-------+---------------+---------------+--------+

-- サイズ別在庫詳細
select 
  items.id, 
  item_name, 
  color,
  if(quantity_s > 0, 'exsits', 'nothing') as s_stock,
  if(quantity_m > 0, 'exsits', 'nothing') as s_stock,
  if(quantity_l > 0, 'exsits', 'nothing') as s_stock
from items join stocks on items.id = stocks.item_id where items.id = 1;
-- +----+-----------------+--------+---------+---------+---------+
-- | id | item_name       | color  | s_stock | s_stock | s_stock |
-- +----+-----------------+--------+---------+---------+---------+
-- |  1 | military jacket | red    | exsits  | exsits  | exsits  |
-- |  1 | military jacket | blue   | exsits  | exsits  | exsits  |
-- |  1 | military jacket | yellow | exsits  | exsits  | exsits  |
-- +----+-----------------+--------+---------+---------+---------+


-- マイページ画面

-- ユーザー情報
select id, `name`, gender, date_of_birth, tell, adress, email from users where id = 1;
-- +----+--------+--------+---------------------+----------------+----------+----------------+
-- | id | name   | gender | date_of_birth       | tell           | adress   | email          |
-- +----+--------+--------+---------------------+----------------+----------+----------------+
-- |  1 | tanaka | man    | 1996-12-13 00:00:00 | 090-XXXX-XXXX  | Ishikawa | test1@mail.com |
-- +----+--------+--------+---------------------+----------------+----------+----------------+

-- 注文履歴
select users.id, `name`,  item_id, item_name, price, quantity, sub_total, tax_amount, total_amount, order_date from users join order_recodes on users.id = order_recodes.user_id join order_details on order_recodes.id = order_details.order_id where users.id = 1;
-- +----+--------+---------+------------------+-------+----------+-----------+------------+--------------+---------------------+
-- | id | name   | item_id | item_name        | price | quantity | sub_total | tax_amount | total_amount | order_date          |
-- +----+--------+---------+------------------+-------+----------+-----------+------------+--------------+---------------------+
-- |  1 | tanaka |       1 | military jacket  |  5800 |        1 |      9700 |        970 |        10670 | 2016-04-03 00:00:00 |
-- |  1 | tanaka |       5 | merino wool knit |  2200 |        1 |      9700 |        970 |        10670 | 2016-04-03 00:00:00 |
-- |  1 | tanaka |       9 | pullover         |  1700 |        1 |      9700 |        970 |        10670 | 2016-04-03 00:00:00 |
-- +----+--------+---------+------------------+-------+----------+-----------+------------+--------------+---------------------+

-- order_detailsとuserのidを直接結びつけるべきか？

/* 管理画面 */

-- ユーザー一覧画面

-- ユーザー情報の一覧
select id, `name`, gender, date_of_birth, tell, adress, email from users;
-- +----+-----------+--------+---------------------+----------------+-----------+-----------------+
-- | id | name      | gender | date_of_birth       | tell           | adress    | email           |
-- +----+-----------+--------+---------------------+----------------+-----------+-----------------+
-- |  1 | tanaka    | man    | 1996-12-13 00:00:00 | 090-XXXX-XXXX  | Ishikawa  | test1@mail.com  |
-- |  2 | takahashi | woman  | 1999-03-22 00:00:00 | 090-XXXX-XXXX  | Shiga     | test2@mail.com  |
-- |  3 | suzuki    | woman  | 1987-05-03 00:00:00 | 090-XXXX-XXXX  | tokyo     | test3@mail.com  |
-- |  4 | satou     | man    | 1973-08-19 00:00:00 | 090-XXXX-XXXX  | osaka     | test4@mail.com  |
-- |  5 | murata    | man    | 2006-06-23 00:00:00 | 090-XXXX-XXXX  | kyoto     | test5@mail.com  |
-- |  6 | nakatani  | woman  | 1984-11-06 00:00:00 | 080-XXXX-XXXX  | kanagawa  | test6@mail.com  |
-- |  7 | yamagishi | woman  | 1992-08-25 00:00:00 | 080-XXXX-XXXX  | mie       | test7@mail.com  |
-- |  8 | maeda     | man    | 2002-04-18 00:00:00 | 080-XXXX-XXXX  | kouti     | test8@mail.com  |
-- |  9 | kawamoto  | man    | 1983-01-27 00:00:00 | 080-XXXX-XXXX  | fukuoka   | test9@mail.com  |
-- | 10 | yasutani  | man    | 2000-02-28 00:00:00 | 080-XXXX-XXXX  | kagoshima | test10@mail.com |
-- +----+-----------+--------+---------------------+----------------+-----------+-----------------+

-- 商品一覧画面

-- 商品の基礎情報一覧
select * from items;
-- +----+------------------+-------+------+---------+---------------------+--------+---------------------+---------------------+
-- | id | item_name        | price | cost | comment | description         | season | created             | updated             |
-- +----+------------------+-------+------+---------+---------------------+--------+---------------------+---------------------+
-- |  1 | military jacket  |  5800 | 1920 | comment | color/fablic/madein | autumn | 2020-10-19 17:09:14 | 2020-10-19 17:09:14 |
-- |  2 | BD shirts        |  3200 |  670 | comment | color/fablic/madein | spring | 2020-10-19 17:09:14 | 2020-10-19 17:09:14 |
-- |  3 | print T-shirts C |  1200 |  300 | comment | color/fablic/madein | summer | 2020-10-19 17:09:14 | 2020-10-19 17:09:14 |
-- |  4 | pleats skirt     |  2200 |  810 | comment | color/fablic/madein | spring | 2020-10-19 17:09:14 | 2020-10-19 17:09:14 |
-- |  5 | merino wool knit |  2200 |  740 | comment | color/fablic/madein | winter | 2020-10-19 17:09:14 | 2020-10-19 17:09:14 |
-- |  6 | logo T-shirts    |  1800 |  530 | comment | color/fablic/madein | summer | 2020-10-19 17:09:14 | 2020-10-19 17:09:14 |
-- |  7 | short pants      |  2300 |  790 | comment | color/fablic/madein | spring | 2020-10-19 17:09:14 | 2020-10-19 17:09:14 |
-- |  8 | print T-shirts B |  1000 |  300 | comment | color/fablic/madein | summer | 2020-10-19 17:09:14 | 2020-10-19 17:09:14 |
-- |  9 | pullover         |  1700 |  450 | comment | color/fablic/madein | autumn | 2020-10-19 17:09:14 | 2020-10-19 17:09:14 |
-- | 10 | color pants      |  3400 |  750 | comment | color/fablic/madein | autumn | 2020-10-19 17:09:14 | 2020-10-19 17:09:14 |
-- | 11 | print T-shirts A |  1400 |  400 | comment | color/fablic/madein | summer | 2020-10-19 17:09:14 | 2020-10-19 17:09:14 |
-- +----+------------------+-------+------+---------+---------------------+--------+---------------------+---------------------+

-- 在庫の一覧
select items.id, item_name, color, quantity_s, quantity_m, quantity_l from items join stocks on items.id = stocks.item_id;


-- サイズの一覧
select * from items join sizes on items.id = sizes.item_id where items.id = 1\G
/* 量が多すぎるので whereで部分抽出
  *************************** 1. row ***************************
                    id: 1
            item_name: military jacket
                price: 5800
                  cost: 1920
              comment: comment
          description: color/fablic/madein
                season: autumn
              created: 2020-10-19 17:29:53
              updated: 2020-10-19 17:29:53
                    id: 1
              item_id: 1
                  size: S
                width: 61
        sholder_width: 52
  raglan_sleeve_length: 63
        sleeve_length: 57
                length: 72
                waist: 94
                  hip: 32
                  rise: 61
                inseam: 12
          thigh_width: 21
              outseam: 70
            sk_length: 80
            hem_width: 22
                weight: 100
              created: 2020-10-19 17:29:53
              updated: 2020-10-19 17:29:53
  *************************** 2. row ***************************
                    id: 1
            item_name: military jacket
                price: 5800
                  cost: 1920
              comment: comment
          description: color/fablic/madein
                season: autumn
              created: 2020-10-19 17:29:53
              updated: 2020-10-19 17:29:53
                    id: 2
              item_id: 1
                  size: M
                width: 62
        sholder_width: 53
  raglan_sleeve_length: 64
        sleeve_length: 58
                length: 73
                waist: 95
                  hip: 33
                  rise: 62
                inseam: 13
          thigh_width: 22
              outseam: 71
            sk_length: 81
            hem_width: 23
                weight: 100
              created: 2020-10-19 17:29:53
              updated: 2020-10-19 17:29:53
  *************************** 3. row ***************************
                    id: 1
            item_name: military jacket
                price: 5800
                  cost: 1920
              comment: comment
          description: color/fablic/madein
                season: autumn
              created: 2020-10-19 17:29:53
              updated: 2020-10-19 17:29:53
                    id: 3
              item_id: 1
                  size: L
                width: 63
        sholder_width: 54
  raglan_sleeve_length: 65
        sleeve_length: 59
                length: 74
                waist: 96
                  hip: 34
                  rise: 63
                inseam: 14
          thigh_width: 23
              outseam: 72
            sk_length: 82
            hem_width: 24
                weight: 100
              created: 2020-10-19 17:29:53
              updated: 2020-10-19 17:29:53
*/

-- 粗利/粗利率/原価/原価率の一覧
select id, item_name, price, cost, round(cost / price * 100) as cost_rate, (price - cost) as profit, round( (price - cost) / price * 100) as profit_rate from items;
-- +----+------------------+-------+------+-----------+--------+-------------+
-- | id | item_name        | price | cost | cost_rate | profit | profit_rate |
-- +----+------------------+-------+------+-----------+--------+-------------+
-- |  1 | military jacket  |  5800 | 1920 |        33 |   3880 |          67 |
-- |  2 | BD shirts        |  3200 |  670 |        21 |   2530 |          79 |
-- |  3 | print T-shirts C |  1200 |  300 |        25 |    900 |          75 |
-- |  4 | pleats skirt     |  2200 |  810 |        37 |   1390 |          63 |
-- |  5 | merino wool knit |  2200 |  740 |        34 |   1460 |          66 |
-- |  6 | logo T-shirts    |  1800 |  530 |        29 |   1270 |          71 |
-- |  7 | short pants      |  2300 |  790 |        34 |   1510 |          66 |
-- |  8 | print T-shirts B |  1000 |  300 |        30 |    700 |          70 |
-- |  9 | pullover         |  1700 |  450 |        26 |   1250 |          74 |
-- | 10 | color pants      |  3400 |  750 |        22 |   2650 |          78 |
-- | 11 | print T-shirts A |  1400 |  400 |        29 |   1000 |          71 |
-- +----+------------------+-------+------+-----------+--------+-------------+

-- 注文一覧
select * from order_recodes;
-- +----+---------+---------------------+-----------+------------+--------------+
-- | id | user_id | order_date          | sub_total | tax_amount | total_amount |
-- +----+---------+---------------------+-----------+------------+--------------+
-- |  1 |       2 | 2015-07-02 00:00:00 |      3400 |        340 |         3740 |
-- |  2 |       1 | 2016-04-03 00:00:00 |      9700 |        970 |        10670 |
-- |  3 |       3 | 2017-12-04 00:00:00 |      7100 |        710 |         7810 |
-- |  4 |       4 | 2018-02-05 00:00:00 |      4500 |        450 |         4950 |
-- |  5 |       5 | 2019-08-06 00:00:00 |      6800 |        680 |         7480 |
-- +----+---------+---------------------+-----------+------------+--------------+

-- 注文詳細
select * from order_details;
-- +----+----------+---------+------------------+-------+----------+
-- | id | order_id | item_id | item_name        | price | quantity |
-- +----+----------+---------+------------------+-------+----------+
-- |  1 |        2 |       1 | military jacket  |  5800 |        1 |
-- |  2 |        2 |       5 | merino wool knit |  2200 |        1 |
-- |  3 |        2 |       9 | pullover         |  1700 |        1 |
-- |  4 |        5 |       2 | BD shirts        |  3200 |        1 |
-- |  5 |        5 |       6 | logo T-shirts    |  1800 |        2 |
-- |  6 |        1 |      10 | color pants      |  3400 |        2 |
-- |  7 |        3 |      11 | print T-shirts A |  1400 |        1 |
-- |  8 |        3 |       8 | print T-shirts B |  1000 |        3 |
-- |  9 |        3 |       3 | print T-shirts C |  1200 |        2 |
-- | 10 |        4 |       7 | short pants      |  2300 |        1 |
-- | 11 |        4 |       4 | pleats skirt     |  2200 |        1 |
-- +----+----------+---------+------------------+-------+----------+

-- 商品別の売上/利益の実績
select 
  items.id, 
  items.item_name, 
  items.price, 
  cost, 
  (items.price - cost) as profit, 
  quantity, 
  (items.price * quantity) as sales_amount,
  ((items.price - cost) * quantity) as profit_amount
from order_details join items on order_details.item_id = items.id where quantity > 0; 
-- +----+------------------+-------+------+--------+----------+--------------+---------------+
-- | id | item_name        | price | cost | profit | quantity | sales_amount | profit_amount |
-- +----+------------------+-------+------+--------+----------+--------------+---------------+
-- |  1 | military jacket  |  5800 | 1920 |   3880 |        1 |         5800 |          3880 |
-- |  5 | merino wool knit |  2200 |  740 |   1460 |        1 |         2200 |          1460 |
-- |  9 | pullover         |  1700 |  450 |   1250 |        1 |         1700 |          1250 |
-- |  2 | BD shirts        |  3200 |  670 |   2530 |        1 |         3200 |          2530 |
-- |  6 | logo T-shirts    |  1800 |  530 |   1270 |        2 |         3600 |          2540 |
-- | 10 | color pants      |  3400 |  750 |   2650 |        2 |         6800 |          5300 |
-- | 11 | print T-shirts A |  1400 |  400 |   1000 |        1 |         1400 |          1000 |
-- |  8 | print T-shirts B |  1000 |  300 |    700 |        3 |         3000 |          2100 |
-- |  3 | print T-shirts C |  1200 |  300 |    900 |        2 |         2400 |          1800 |
-- |  7 | short pants      |  2300 |  790 |   1510 |        1 |         2300 |          1510 |
-- |  4 | pleats skirt     |  2200 |  810 |   1390 |        1 |         2200 |          1390 |
-- +----+------------------+-------+------+--------+----------+--------------+---------------+

-- 商品別のカテゴリ一覧
select items.id, item_name, item_category.category_id, category_name from items join item_category on items.id = item_category.item_id join categories on item_category.category_id = categories.id;
/* 
  +----+------------------+-------------+-----------------+
  | id | item_name        | category_id | category_name   |
  +----+------------------+-------------+-----------------+
  |  1 | military jacket  |           1 | Men's           |
  |  1 | military jacket  |           4 | Jackets / Coats |
  |  1 | military jacket  |          29 | Military jacket |
  |  2 | BD shirts        |           1 | Men's           |
  |  2 | BD shirts        |           3 | Tops            |
  |  2 | BD shirts        |          17 | Shirts          |
  |  3 | print T-shirts C |           1 | Men's           |
  |  3 | print T-shirts C |           3 | Tops            |
  |  3 | print T-shirts C |          13 | T-Shirts        |
  |  4 | pleats skirt     |           2 | Women's         |
  |  4 | pleats skirt     |          11 | Skirts          |
  |  4 | pleats skirt     |          88 | Skirts          |
  |  5 | merino wool knit |           2 | Women's         |
  |  5 | merino wool knit |           7 | Tops            |
  |  5 | merino wool knit |          58 | Pullovers       |
  |  6 | logo T-shirts    |           1 | Men's           |
  |  6 | logo T-shirts    |           3 | Tops            |
  |  6 | logo T-shirts    |          13 | T-Shirts        |
  |  7 | short pants      |           2 | Women's         |
  |  7 | short pants      |           9 | Pants           |
  |  7 | short pants      |          81 | Denim pants     |
  |  8 | print T-shirts B |           1 | Men's           |
  |  8 | print T-shirts B |           3 | Tops            |
  |  8 | print T-shirts B |          13 | T-Shirts        |
  |  9 | pullover         |           2 | Women's         |
  |  9 | pullover         |           7 | Tops            |
  |  9 | pullover         |          58 | Pullovers       |
  | 10 | color pants      |           2 | Women's         |
  | 10 | color pants      |           9 | Pants           |
  | 10 | color pants      |          83 | Chino pants     |
  | 11 | print T-shirts A |           1 | Men's           |
  | 11 | print T-shirts A |           3 | Tops            |
  | 11 | print T-shirts A |          13 | T-Shirts        |
  +----+------------------+-------------+-----------------+
*/

select * from categories where parent_id = 1; -- men's を親に持つ子のカテゴリ一覧

select * from categories where parent_id = 4; -- Jackets / Coats を親に持つカテゴリ一覧

select * from categories where parent_id in(select id from categories where parent_id = 1); -- men's の子カテゴリを親に持つ孫カテゴリー一覧

select 
 t1.category_name,
 t2.category_name,
 t3.category_name
from categories as t1 
join categories as t2 on t2.parent_id = t1.id
join categories as t3 on t3.parent_id = t2.id; -- カテゴリの全ての階層を取得



create view 
  category_item_view
as select 
  categories.id, 
  categories.category_name, 
  categories.parent_id, 
  item_category.item_id,
  items.item_name 
from 
  categories 
join item_category on categories.id = item_category.category_id
join items on item_category.item_id = items.id;

select * from category_item_view;

-- select * from category_item_view where id = 1; -- men'sのカテゴリの商品の一覧
-- select * from category_item_view where parent_id = 3 and id = 17; -- men'sのカテゴリの商品の一覧


-- select 
--   categories.id, 
--   categories.category_name, 
--   item_category.item_id,
--   items.item_name 
-- from 
--   categories 
-- join item_category on categories.id = item_category.category_id
-- join items on item_category.item_id = items.id
-- where categories.id = ;
