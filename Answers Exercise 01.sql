
-- Q1. Write a code to check NULL values

SELECT 
    COUNT(*) as Total,
    SUM(CASE WHEN province IS NULL THEN 1 ELSE 0 END) as Null_Province,
    SUM(CASE WHEN country_region IS NULL THEN 1 ELSE 0 END) as Null_Country_Region,
    SUM(CASE WHEN Latitude IS NULL THEN 1 ELSE 0 END) as Null_Latitude,
    SUM(CASE WHEN Longitude IS NULL THEN 1 ELSE 0 END) as Null_Longitude,
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) as Null_Date,
    SUM(CASE WHEN Confirmed IS NULL THEN 1 ELSE 0 END) as Null_Confirmed,
    SUM(CASE WHEN Deaths IS NULL THEN 1 ELSE 0 END) as Null_Deaths,
    SUM(CASE WHEN recovered IS NULL THEN 1 ELSE 0 END) as Null_Recovered
FROM 
    info_corona;


-- Q2. If NULL values are present, update them with zeros for all columns. 

UPDATE info_corona SET Latitude = COALESCE(Latitude, 0);
UPDATE info_corona SET Longitude = COALESCE(Longitude, 0);
UPDATE info_corona SET Confirmed = COALESCE(Confirmed, 0);
UPDATE info_corona SET Deaths = COALESCE(Deaths, 0);
UPDATE info_corona SET Recovered = COALESCE(Recovered, 0);
UPDATE info_corona SET Country_Region = COALESCE(Country_Region, 'Unknown');
UPDATE info_corona SET Date = COALESCE(Date, GETDATE());


-- Q3. check total number of rows

SELECT COUNT(*) as total_number FROM info_corona;

-- Q4. Check what is start_date and end_date

SELECT MIN(date) as start_date, MAX(date) as end_date FROM info_corona;

-- Q5. Number of month present in dataset

SELECT COUNT(DISTINCT YEAR(Date)*100 + MONTH(Date)) as NumberOfMonths FROM info_corona;

-- Q6. Find monthly average for confirmed, deaths, recovered

SELECT 
    YEAR(Date) as Year, 
    MONTH(Date) as Month, 
    AVG(CAST(Confirmed as float)) as Avg_Confirmed, 
    AVG(CAST(Deaths as float)) as Avg_Deaths, 
    AVG(CAST(Recovered as float)) as Avg_Recovered
FROM 
    info_corona
GROUP BY 
    YEAR(Date), 
    MONTH(Date);

-- Q7. Find most frequent value for confirmed, deaths, recovered each month 

WITH MonthlyCounts AS (
    SELECT 
        YEAR(Date) as Year, 
        MONTH(Date) as Month, 
        Confirmed, 
        Deaths, 
        Recovered, 
        COUNT(*) as Count
    FROM 
        info_corona
    GROUP BY 
        YEAR(Date), 
        MONTH(Date), 
        Confirmed, 
        Deaths, 
        Recovered
)
SELECT 
    Year, 
    Month, 
    Confirmed, 
    MAX(Count) as Confirmed_Frequency
FROM 
    MonthlyCounts
GROUP BY 
    Year, 
    Month, 
    Confirmed
UNION ALL
SELECT 
    Year, 
    Month, 
    Deaths, 
    MAX(Count) as Deaths_Frequency
FROM 
    MonthlyCounts
GROUP BY 
    Year, 
    Month, 
    Deaths
UNION ALL
SELECT 
    Year, 
    Month, 
    Recovered, 
    MAX(Count) as Recovered_Frequency
FROM 
    MonthlyCounts
GROUP BY 
    Year, 
    Month, 
    Recovered;


-- Q8. Find minimum values for confirmed, deaths, recovered per year

SELECT 
    YEAR(Date) as Year, 
    MIN(CAST(Confirmed as float)) as Min_Confirmed, 
    MIN(CAST(Deaths as float)) as Min_Deaths, 
    MIN(CAST(Recovered as float)) as Min_Recovered
FROM 
    info_corona
GROUP BY 
    YEAR(Date);

-- Q9. Find maximum values of confirmed, deaths, recovered per year

SELECT 
    YEAR(Date) as Year, 
    MAX(CAST(Confirmed as float)) as Max_Confirmed, 
    MAX(CAST(Deaths as float)) as Max_Deaths, 
    MAX(CAST(Recovered as float)) as Max_Recovered
FROM 
    info_corona
GROUP BY 
    YEAR(Date);

-- Q10. The total number of case of confirmed, deaths, recovered each month

SELECT 
    YEAR(Date) as Year, 
    MONTH(Date) as Month, 
    SUM(CAST(Confirmed as float)) as Total_Confirmed, 
    SUM(CAST(Deaths as float)) as Total_Deaths, 
    SUM(CAST(Recovered as float)) as Total_Recovered
FROM 
    info_corona
GROUP BY 
    YEAR(Date), 
    MONTH(Date);


-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT 
    SUM(CAST(Confirmed as float)) as Total_Confirmed, 
    AVG(CAST(Confirmed as float)) as Average_Confirmed, 
    VAR(CAST(Confirmed as float)) as Variance_Confirmed, 
    STDEV(CAST(Confirmed as float)) as StdDev_Confirmed
FROM 
    info_corona;

-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT 
    YEAR(Date) as Year, 
    MONTH(Date) as Month, 
    SUM(CAST(Deaths as float)) as Total_Deaths, 
    AVG(CAST(Deaths as float)) as Average_Deaths, 
    VAR(CAST(Deaths as float)) as Variance_Deaths, 
    STDEV(CAST(Deaths as float)) as StdDev_Deaths
FROM 
    info_corona
GROUP BY 
    YEAR(Date), 
    MONTH(Date);

-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT 
    YEAR(Date) as Year, 
    MONTH(Date) as Month, 
    SUM(CAST(Recovered as float)) as Total_Recovered, 
    AVG(CAST(Recovered as float)) as Average_Recovered, 
    VAR(CAST(Recovered as float)) as Variance_Recovered, 
    STDEV(CAST(Recovered as float)) as StdDev_Recovered
FROM 
    info_corona
GROUP BY 
    YEAR(Date), 
    MONTH(Date);

-- Q14. Find Country having highest number of the Confirmed case

SELECT TOP 1
    Country_Region, 
    MAX(CAST(Confirmed as float)) as Max_Confirmed
FROM 
    info_corona
GROUP BY 
    Country_Region
ORDER BY 
    Max_Confirmed DESC;

-- Q15. Find Country having lowest number of the death case

SELECT 
    Country_Region, 
    MIN(CAST(Deaths as float)) as Min_Deaths
FROM 
    info_corona
GROUP BY 
    Country_Region
HAVING 
    MIN(CAST(Deaths as float)) >= 0
ORDER BY 
    Min_Deaths ASC;

-- Q16. Find top 5 countries having highest recovered case

SELECT TOP 5
    Country_Region, 
    MAX(CAST(Recovered as float)) as Max_Recovered
FROM 
    info_corona
GROUP BY 
    Country_Region
ORDER BY 
    Max_Recovered DESC;