/* ===========================================================
   DATA CLEANING - MEMBERS TABLE
   =========================================================== */

-- Convert blank enrollment end dates to NULL
UPDATE members
SET enrollment_end_date = NULL
WHERE TRIM(enrollment_end_date) = '';

-- Check for NULL enrollment end dates
SELECT *
FROM members
WHERE enrollment_end_date IS NULL;

-- Check for duplicate member IDs
SELECT member_id, COUNT(*)
FROM members
GROUP BY member_id
HAVING COUNT(*) > 1;

-- Check for invalid member ages
SELECT *
FROM members
WHERE member_age < 0
   OR member_age > 120;

-- Check if enrollment start date is after enrollment end date
SELECT *
FROM members
WHERE STR_TO_DATE(enrollment_start_date, '%m/%d/%Y')
    > STR_TO_DATE(enrollment_end_date, '%m/%d/%Y');


/* ===========================================================
   DATA CLEANING - CLAIMS TABLE
   =========================================================== */

-- Check for duplicate claim IDs
SELECT claim_id, COUNT(*)
FROM claims
GROUP BY claim_id
HAVING COUNT(*) > 1;

-- Check for claims that reference non-existing members
SELECT c.member_id
FROM claims c
LEFT JOIN members m
ON c.member_id = m.member_id
WHERE m.member_id IS NULL;

-- Check for negative paid amounts
SELECT *
FROM claims
WHERE paid_amount < 0;

-- Check for negative billed amounts
SELECT *
FROM claims
WHERE billed_amount < 0;

-- Check for paid amounts greater than billed amounts
SELECT *
FROM claims
WHERE paid_amount > billed_amount;

-- Check for missing CPT codes
SELECT *
FROM claims
WHERE cpt_code IS NULL
   OR TRIM(cpt_code) = '';

-- Check for missing ICD codes
SELECT *
FROM claims
WHERE icd_code IS NULL
   OR TRIM(icd_code) = '';