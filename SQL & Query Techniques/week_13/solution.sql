-- =========================================================
-- Frosty Friday · Week 13 — SQL & Query Techniques (Medium)
-- Challenge: https://www.frostyfri.day/en/challenges/blog/2022/09/09/week-13-sql-query-techniques
--
-- Problem:  forward-fill stock_amount per product (LOCF)
-- Approach: LAG(...) IGNORE NULLS + COALESCE;
--           duplicate dates tie-broken with id
-- =========================================================

-- Challenge setup (provided by Frosty Friday)
CREATE OR REPLACE TABLE testing_data(id INT AUTOINCREMENT START 1 INCREMENT 1, product STRING, stock_amount INT, date_of_check DATE);

insert into testing_data (product,stock_amount,date_of_check) values ('Superhero capes',1,'2022-01-01');

insert into testing_data (product,stock_amount,date_of_check) values ('Superhero capes',2,'2022-01-02');

insert into testing_data (product,stock_amount,date_of_check) values ('Superhero capes',NULL,'2022-02-01');

insert into testing_data (product,stock_amount,date_of_check) values ('Superhero capes',NULL,'2022-03-01');

insert into testing_data (product,stock_amount,date_of_check) values ('Superhero masks',5,'2022-01-01');

insert into testing_data (product,stock_amount,date_of_check) values ('Superhero masks',NULL,'2022-02-13');

insert into testing_data (product,stock_amount,date_of_check) values ('Superhero pants',6,'2022-01-01');

insert into testing_data (product,stock_amount,date_of_check) values ('Superhero pants',NULL,'2022-01-01');

insert into testing_data (product,stock_amount,date_of_check) values ('Superhero pants',3,'2022-04-01');

insert into testing_data (product,stock_amount,date_of_check) values ('Superhero pants',2,'2022-07-01');

insert into testing_data (product,stock_amount,date_of_check) values ('Superhero pants',NULL,'2022-01-01');

insert into testing_data (product,stock_amount,date_of_check) values ('Superhero pants',3,'2022-05-01');

insert into testing_data (product,stock_amount,date_of_check) values ('Superhero pants',NULL,'2022-10-01');

insert into testing_data (product,stock_amount,date_of_check) values ('Superhero masks',10,'2022-11-01');

insert into testing_data (product,stock_amount,date_of_check) values ('Superhero masks',NULL,'2022-02-14');

insert into testing_data (product,stock_amount,date_of_check) values ('Superhero masks',NULL,'2022-02-15');

insert into testing_data (product,stock_amount,date_of_check) values ('Superhero masks',NULL,'2022-02-13');

-- Solution
SELECT id, product,
       COALESCE(
         stock_amount,
         LAG(stock_amount) IGNORE NULLS OVER (PARTITION BY product ORDER BY date_of_check, id)
       ) AS stock_amount,
       date_of_check
FROM testing_data
ORDER BY product, date_of_check, id;