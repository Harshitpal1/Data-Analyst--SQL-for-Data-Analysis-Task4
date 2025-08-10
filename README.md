# Elevate Labs - Data Analyst Internship: Task 4

This project demonstrates the use of SQL for data extraction and analysis as part of the Elevate Labs Data Analyst Internship.

---

## Objective

[cite_start]The main goal is to use SQL queries to extract and analyze data from a database[cite: 4]. This task showcases the ability to manipulate and query structured data to derive meaningful insights.

---

## Dataset

The analysis is performed on the `customer_data.csv` dataset. This file contains rich customer information, including demographics, income, spending habits across different product categories, and campaign responses. For this task, the data is assumed to be loaded into a single SQL table named `CustomerData`.

---

## Tools

* **Database**: PostgreSQL (as an example from the suggested options of MySQL, PostgreSQL, or SQLite)
* **Language**: SQL

---

## SQL Queries

The file `queries_revised.sql` contains a series of SQL queries written to analyze the `CustomerData` table. These queries demonstrate proficiency in:
* Filtering data using `WHERE`
* Grouping and aggregating data with `GROUP BY`, `SUM`, and `AVG` [cite: 8, 11]
* Sorting results with `ORDER BY` [cite: 8]
* Creating and using subqueries 
* Creating and querying `VIEW`s for simplified analysis 

---

## Interview Questions & Answers

Here are the answers to the interview questions provided in the task description.

### 1. What is the difference between WHERE and HAVING? 

The **`WHERE`** and **`HAVING`** clauses both filter data, but they operate at different stages of a query.

* **`WHERE`** is used to filter individual rows **before** any aggregation or grouping occurs. It works directly on the rows from the table specified in the `FROM` clause.
* **`HAVING`** is used to filter groups **after** the data has been grouped using the `GROUP BY` clause. It is applied to the results of aggregate functions (like `SUM()`, `AVG()`, `COUNT()`).

**Analogy**: Imagine you have a box of assorted fruits.
* `WHERE fruit_color = 'red'` is like picking out only the red fruits (apples, strawberries) from the box *before* you sort them into piles.
* `GROUP BY fruit_type` is like sorting the remaining fruits into piles of apples, strawberries, etc.
* `HAVING COUNT(*) > 10` is like checking which of these piles has more than 10 fruits in it.

### 2. What are the different types of joins? 

Joins are used to combine rows from two or more tables based on a related column. [cite: 9]

* **`(INNER) JOIN`**: Returns only the records that have matching values in both tables. It's the most common join type.
* **`LEFT JOIN` (or `LEFT OUTER JOIN`)**: Returns all records from the left table and the matched records from the right table. If there's no match, the columns from the right table will contain `NULL`.
* **`RIGHT JOIN` (or `RIGHT OUTER JOIN`)**: The opposite of a `LEFT JOIN`. It returns all records from the right table and the matched records from the left table. If there's no match, the columns from the left table will contain `NULL`.
* **`FULL OUTER JOIN`**: Returns all records when there is a match in either the left or the right table. It effectively combines the results of both `LEFT` and `RIGHT` joins.



### 3. How do you calculate average revenue per user in SQL? 

You calculate this in two steps:
1.  **Calculate Total Revenue for Each User**: First, you need a query that calculates the total revenue from each individual user. This typically involves multiplying `price` by `quantity` for each item ordered and then using `SUM()` to get the total for each user, grouped by a `user_id`.
2.  **Calculate the Average of Those Totals**: Next, you treat the result of the first query as a new dataset (using a subquery or a Common Table Expression) and apply the `AVG()` function to the total revenue column.

```sql
SELECT
    AVG(user_total_revenue) as average_revenue_per_user
FROM (
    -- Step 1: Find total revenue for each user
    SELECT
        customer_id,
        SUM(price * quantity) AS user_total_revenue
    FROM
        Orders
    GROUP BY
        customer_id
) AS UserRevenues;
