-- Data cleaning Project
SET SQL_SAFE_UPDATES = 0;

-- CREATING DUPLICATE TABLE SO WE HAVE THE RAW DATA
CREATE TABLE layoffs_staging
LIKE layoffs;


INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging
)
DELETE
FROM duplicate_cte 
WHERE row_num > 1;

-- JUST FOR CHECKING IF DATA HAS DULPICATE OR NOT
-- SELECT *
-- FROM layoffs_staging
-- WHERE company = 'Casper';


-- CREATING ANOTHER TABLE AND ADDING ROW_NUM  AS A FIELD 
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging;


DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- STANDARDIZING DATA 

SELECT company, TRIM(company) 
FROM layoffs_staging2;

UPDATE layoffs_staging2 
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

-- FROM THIS WE GET TO KNOW CRYPTO AND CRYPTO CURRENCY ARE THE SAME THING, SO IT NEEDS TO BE CHANGED TO ANY ONE UNIQUE NAME 
SELECT DISTINCT industry
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';


UPDATE layoffs_staging2
SET industry= 'Crypto'
WHERE industry LIKE 'Crypto%';


SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%';

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';

-- CHANGING DATE FORMATE FROM TEXT TO DATE

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

Update layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- DELETING DATA WHERE BOTH TOTAL LAID OFF AND PERCENTAGE LAID OFF IS NULL.
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
;

SELECT *
FROM layoffs_staging2 
WHERE industry IS NULL OR industry = ''
;

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';


SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company 
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL ;

-- CHANGING BLANK TO NULL SO WE CAN EASILY UPDATE TABLE
UPDATE layoffs_staging2
SET industry = NULL 
WHERE industry = '' ;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company 
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL ;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num; 

-- FINAL CLEAN DATA
SELECT * 
FROM layoffs_staging2;



-- EXPLORATORY DATA ANALYSIS 

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2; 

-- COMPANIES THAT ARE TOTALLY SHUT DOWN. HOW MUCH FUNDS WERE RAISED?
SELECT *
FROM layoffs_staging2 
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC; 

-- TOTAL LAID OFF BY EVERY COMPANY, COUNTRY, INDUSTRY, TIME PERIOD

SELECT company, sum(total_laid_off)
FROM layoffs_staging2 
GROUP BY company
ORDER BY sum(total_laid_off) DESC ; 


SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2; 

SELECT industry, sum(total_laid_off)
FROM layoffs_staging2 
GROUP BY industry
ORDER BY sum(total_laid_off) DESC ; 

SELECT country, sum(total_laid_off)
FROM layoffs_staging2 
GROUP BY country
ORDER BY sum(total_laid_off) DESC ; 

SELECT industry, sum(total_laid_off)
FROM layoffs_staging2 
GROUP BY industry
ORDER BY sum(total_laid_off) DESC ; 

SELECT YEAR(`date`), sum(total_laid_off)
FROM layoffs_staging2 
GROUP BY YEAR(`date`)
ORDER BY YEAR(`date`) DESC ; 

SELECT SUBSTRING(`date`,1,7) AS time_PERIOD , SUM(total_laid_off) AS LAID_OFF
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP  BY time_PERIOD
ORDER BY time_PERIOD ASC
;
-- LAID OFF MONTH BY MONTH PROGRESSION
WITH Rolling_TOTAL AS
(
SELECT SUBSTRING(`date`,1,7) AS TIME_PERIOD , SUM(total_laid_off) AS LAID_OFF
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP  BY TIME_PERIOD
ORDER BY TIME_PERIOD ASC
)
SELECT TIME_PERIOD, LAID_OFF ,SUM(LAID_OFF) OVER(ORDER BY TIME_PERIOD) AS Total_Laid_Off_In_Month
FROM Rolling_TOTAL;

-- Ranking companies according to the highest number of laid off by the year, then filtering to just top 5 companies
SELECT company, sum(total_laid_off)
FROM layoffs_staging2 
GROUP BY company
ORDER BY sum(total_laid_off) DESC ; 

SELECT company, YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_staging2
WHERE YEAR(`date`) IS NOT NULL
GROUP BY company, YEAR(`date`) 
ORDER BY SUM(total_laid_off) DESC;
;

WITH Company_Year (company, years, laidoff ) as
(
SELECT company, YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_staging2
WHERE YEAR(`date`) IS NOT NULL
GROUP BY company, YEAR(`date`) 
ORDER BY SUM(total_laid_off) DESC
), Company_Year_Rank as
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY laidoff DESC) as Ranks
FROM Company_Year
WHERE years IS NOT NULL 
)
SELECT *
FROM Company_Year_Rank 
WHERE Ranks <= 5;
