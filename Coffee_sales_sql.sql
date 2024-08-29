SELECT * FROM coffee_shop_sales_db.coffee_shop_sales;
SET sql_safe_updates = 0;
UPDATE coffee_shop_sales
SET transaction_date = STR_TO_DATE(transaction_date, '%m/%d/%Y');
ALTER TABLE coffee_shop_sales
MODIFY transaction_date DATE;

DESCRIBE coffee_shop_sales;
ALTER TABLE coffee_shop_sales
MODIFY transaction_time TIME;
rollback;
SELECT * FROM coffee_shop_sales_db.coffee_shop_sales;
-- -------------------------------------------------------------------
-- KPI requirement --- >

-- 1.Total Sales
--  a.	Calculate total sales for each respective month
	
    SELECT ROUND(SUM(transaction_qty * unit_price)) AS Total_Sales_March
	FROM coffee_shop_sales
    WHERE MONTHNAME(transaction_date) = "March";


SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales,
    (SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1)
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(unit_price * transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for months of April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);
SELECT * FROM coffee_shop_sales_db.coffee_shop_sales; 



    SELECT COUNT(*)
    AS Total_Orders_March
	FROM coffee_shop_sales
    WHERE MONTHNAME(transaction_date) = "March";
    
    SELECT 
    MONTH(transaction_date) AS month,
    ROUND(COUNT(transaction_id)) AS total_orders,
    (COUNT(transaction_id) - LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);



    SELECT SUM(transaction_qty)
    AS Total_Quantity_March
	FROM coffee_shop_sales
    WHERE MONTHNAME(transaction_date) = "March";
    
    
    
    SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(transaction_qty)) AS total_quantity_sold,
    (SUM(transaction_qty) - LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5)   -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);
    
    SELECT 
	CONCAT(ROUND(SUM(transaction_qty * unit_price)/1000,1),'K') AS Total_sales,
	CONCAT(ROUND(SUM(transaction_qty)/1000,1),'k') AS Total_orders,
	CONCAT(ROUND(COUNT(transaction_id)/1000,1),'k') AS Total_quantity
    FROM coffee_shop_sales
    WHERE transaction_date = '2023-05-18';
 
	--  Weekends -- Sat	-7 and Sun -1
    -- Weekdays -- Mon-2 , Tue-3, Wed -4, Thu-5,Fri-6
    
    SELECT 
		CASE WHEN DAYOFWEEK(transaction_date) IN (1,7) THEN 'Weekend'
        ELSE 'Weekdays'
        END  AS Day_type,
	CONCAT(ROUND(SUM(transaction_qty * unit_price)/1000,1),'K')	AS Total_sales
	FROM coffee_shop_sales
    WHERE MONTH(transaction_date) = 5 -- May Month
    GROUP BY Day_type;
    
    SELECT 
		store_location,
		CONCAT(ROUND(SUM(transaction_qty * unit_price)/1000,1),'k')AS Total_sales
	FROM coffee_shop_sales
    WHERE MONTH(transaction_date) = 5
    GROUP BY store_location
    ORDER BY Total_sales DESC;
    
    SELECT
		AVG(unit_price * transaction_qty) AS avg_sales
	FROM coffee_shop_sales
    WHERE MONTH(transaction_date) = 5;
    
    
    SELECT 
	CONCAT(ROUND(AVG(total_sales)/1000,1),'K')AS avg_sales
	FROM
    (
		SELECT SUM(unit_price * transaction_qty) AS total_sales
        FROM coffee_shop_sales
        WHERE MONTH(transaction_date) = 5
        GROUP BY transaction_date
     ) AS Internal_query;
     
     
     SELECT
			DAY(transaction_date) AS day_of_month,
            SUM(unit_price * transaction_qty) AS Daily_sales
	FROM coffee_shop_sales
    WHERE MONTH(transaction_date) =5
    GROUP BY day_of_month;
    
    SELECT 
    day_of_month,
    CASE 
        WHEN total_sales > avg_sales THEN 'Above Average'
        WHEN total_sales < avg_sales THEN 'Below Average'
        ELSE 'Equal to	Average'
    END AS sales_status,
    total_sales
FROM (
    SELECT 
        DAY(transaction_date) AS day_of_month,
        SUM(unit_price * transaction_qty) AS total_sales,
        AVG(SUM(unit_price * transaction_qty)) OVER () AS avg_sales
    FROM 
        coffee_shop_sales
    WHERE 
        MONTH(transaction_date) = 5  -- Filter for May
    GROUP BY 
        DAY(transaction_date)
) AS sales_data
ORDER BY 
    day_of_month;
    
    SELECT 
		product_category,
	CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1),'k')	AS Total_sales
	FROM coffee_shop_sales
    WHERE MONTH(transaction_date) = 5
    GROUP BY product_category;
-- CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1),'k')	AS Total_sales
    SELECT 
		SUM(unit_price * transaction_qty)	AS Total_sales,
        SUM(transaction_qty) AS Total_quantity,
        COUNT(*) AS Total_orders
	FROM coffee_shop_sales
    WHERE MONTH(transaction_date) = 5
    AND DAYOFWEEK(transaction_date) = 2 -- Monday
    AND HOUR(transaction_time) = 8; -- Hour No. 8

    SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END AS Day_of_Week,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END;

