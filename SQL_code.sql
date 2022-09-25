ALTER TABLE date RENAME COLUMN date TO order_date;   # change the column name from date to order_date of table date to make it similar to transaction table
ALTER TABLE markets RENAME COLUMN markets_code TO market_code;

SELECT count(*) FROM transactions;    # checking number of rows in transactions

SELECT sum(case when sales_amount IS NULL then 1 else 0 end) as NUMBER_OF_NULL_VALUE from transactions;   # getting number of missing values in sales_amount column

SELECT distinct year FROM date;   # checking how many years of data dataset contains

SELECT distinct currency FROM transactions;   # checking how many currencies we have in currency column
# after analysis we see that there are 'INR', 'INR\r', 'USD', 'USD\r' currencies. So there are errors in database and error
# is they are duplicates so we will keep only 'INR\r' and 'USD\r' as they are more in numbers.

SELECT count(*) FROM transactions WHERE currency = 'INR\r';

SELECT count(*) FROM transactions WHERE currency = 'INR';

SELECT * FROM transactions WHERE currency = 'USD' OR currency = 'USD\r';     # here we see they are duplicate

DELETE FROM transactions WHERE currency = 'USD' OR currency = 'INR';    # deleting duplicate rows

Delimiter //
CREATE procedure loopDemo()       # loop to get the sum of sales_amount for 2017 to 2020
   label:BEGIN
      DECLARE val INT ;
      DECLARE n INT;
      DECLARE result VARCHAR(50);
      SET val = 2017;
      SET result = '';
         loop_label: LOOP
         IF val > 2020 THEN 
            LEAVE loop_label;
         END IF;
         SELECT SUM(sales_amount) FROM transactions INNER JOIN date USING (order_date) WHERE year = val INTO n;
         SET result = CONCAT(result,n,',');
         SET val = val + 1;
         ITERATE loop_label;
      END LOOP;
      SELECT result;
      END//
      
     call loopDemo;//
      
      
SELECT SUM(sales_amount) FROM transactions INNER JOIN date USING (order_date) WHERE year = 2020;    # getting sum without loop

SELECT SUM(sales_amount) FROM transactions INNER JOIN date USING (order_date) INNER JOIN markets USING (market_code) WHERE year = 2019 AND markets_name = 'Mumbai';

SELECT * FROM transactions WHERE sales_amount <= 0;   #checking how many values less than 0 in sales_amount as we need to throw these rows

SELECT (SUM(sales_amount)/80)/1000000 FROM transactions INNER JOIN date USING (order_date) where year=2020;    # getting sales_amount of year 2020 in dollar

SELECT (SUM(sales_amount)/80)/1000000 FROM transactions INNER JOIN date USING (order_date);    # sum in dollar