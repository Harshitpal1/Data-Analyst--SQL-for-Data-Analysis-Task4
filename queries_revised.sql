-- queries_revised.sql
-- SQL queries for Elevate Labs Data Analyst Task 4
-- Dataset: customer_data.csv loaded as 'CustomerData' table.

-- Query 1: Basic Selection and Filtering
-- Objective: Find all customers with a PhD, an income over $60,000, and at least one kid at home.
-- Demonstrates: SELECT, WHERE with multiple conditions.
SELECT
    ID,
    Year_Birth,
    Education,
    Income,
    Kidhome
FROM
    CustomerData
WHERE
    Education = 'PhD'
    AND Income > 60000
    AND Kidhome > 0;

-- Query 2: Aggregation and Grouping
-- Objective: Calculate the average income for each education level, ordered from highest to lowest.
-- Demonstrates: GROUP BY, AVG(), ORDER BY.
SELECT
    Education,
    AVG(Income) AS AverageIncome
FROM
    CustomerData
WHERE
    Income IS NOT NULL -- Exclude null incomes from the average calculation
GROUP BY
    Education
ORDER BY
    AverageIncome DESC;

-- Query 3: Date Manipulation and Aggregation
-- Objective: Find the number of new customers who enrolled each year.
-- Note: The 'Dt_Customer' is in 'DD/MM/YY' format. We'll need to parse it.
-- This query assumes a function like TO_DATE() is available.
SELECT
    EXTRACT(YEAR FROM TO_DATE(Dt_Customer, 'DD/MM/YY')) AS EnrollmentYear,
    COUNT(ID) AS NumberOfCustomers
FROM
    CustomerData
GROUP BY
    EnrollmentYear
ORDER BY
    EnrollmentYear ASC;

-- Query 4: Subquery and Aggregate Functions
-- Objective: Find the marital status with the highest average spending on meat products.
-- Demonstrates: Subquery, MAX(), AVG().
SELECT
    Marital_Status,
    AverageMeatSpending
FROM (
    SELECT
        Marital_Status,
        AVG(MntMeatProducts) AS AverageMeatSpending
    FROM
        CustomerData
    GROUP BY
        Marital_Status
) AS MeatAnalysis
WHERE AverageMeatSpending = (
    SELECT MAX(AverageMeatSpending)
    FROM (
        SELECT AVG(MntMeatProducts) AS AverageMeatSpending
        FROM CustomerData
        GROUP BY Marital_Status
    ) AS InnerMeatAnalysis
);


-- Query 5: Create a View for Simplified Analysis
-- Objective: Create a view that calculates the total spending for each customer.
-- Demonstrates: CREATE VIEW, arithmetic operations.
CREATE VIEW CustomerTotalSpending AS
SELECT
    ID,
    Income,
    (MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) AS TotalSpending,
    (AcceptedCmp1 + AcceptedCmp2 + AcceptedCmp3 + AcceptedCmp4 + AcceptedCmp5 + Response) as TotalCampaignsAccepted
FROM
    CustomerData;


-- Query 6: Querying the View
-- Objective: Using the view, find the average total spending of customers who have accepted at least one campaign versus those who have not.
-- Demonstrates: Using a VIEW, CASE statement.
SELECT
    CASE
        WHEN TotalCampaignsAccepted > 0 THEN 'Accepted at least one campaign'
        ELSE 'Accepted no campaigns'
    END AS CampaignAcceptance,
    AVG(TotalSpending) as AverageTotalSpending
FROM
    CustomerTotalSpending
GROUP BY
    CampaignAcceptance;
