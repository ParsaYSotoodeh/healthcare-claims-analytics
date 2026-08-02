/* ===========================================================
   HEALTHCARE CLAIMS ANALYSIS
   Business Questions & SQL Analysis
   =========================================================== */


/* ===========================================================
   1. Claim Type Cost Breakdown
   - Total billed amount
   - Total paid amount
   - Number of claims
   - Ranked by total paid amount
   =========================================================== */

SELECT
    claim_type,
    SUM(billed_amount) AS total_billed_amount,
    SUM(paid_amount) AS total_paid_amount,
    COUNT(*) AS claim_count
FROM claims
GROUP BY claim_type
ORDER BY total_paid_amount DESC;


/* ===========================================================
   2. Top 10 ICD Codes by Total Paid Amount
   =========================================================== */

SELECT
    icd_code,
    SUM(paid_amount) AS total_paid_amount
FROM claims
GROUP BY icd_code
ORDER BY total_paid_amount DESC
LIMIT 10;


/* ===========================================================
   3. Top 10 CPT Codes
   - Total paid amount
   - Number of claims
   - Average paid amount per claim
   =========================================================== */

SELECT
    cpt_code,
    COUNT(*) AS claim_count,
    SUM(paid_amount) AS total_paid_amount,
    AVG(paid_amount) AS average_paid_per_claim
FROM claims
GROUP BY cpt_code
ORDER BY total_paid_amount DESC
LIMIT 10;


/* ===========================================================
   4. Member-Level Cost Analysis
   - Identify the top 10 highest-cost members
   - Show which claim types contribute most to their costs
   =========================================================== */

WITH top_members AS (
    SELECT
        member_id,
        SUM(paid_amount) AS total_paid_amount
    FROM claims
    GROUP BY member_id
    ORDER BY total_paid_amount DESC
    LIMIT 10
)

SELECT
    c.member_id,
    tm.total_paid_amount,
    c.claim_type,
    SUM(c.paid_amount) AS claim_type_paid_amount
FROM claims c
JOIN top_members tm
    ON c.member_id = tm.member_id
GROUP BY
    c.member_id,
    c.claim_type
ORDER BY
    c.member_id,
    total_paid_amount DESC;


/* ===========================================================
   5. Billed vs Paid Ratio Analysis
   Compare paid ratios across different dimensions
   =========================================================== */

-- Paid ratio by claim type

SELECT
    claim_type,
    SUM(paid_amount) / SUM(billed_amount) AS paid_ratio
FROM claims
GROUP BY claim_type
ORDER BY paid_ratio DESC;


-- Paid ratio by provider

SELECT
    provider_id,
    SUM(paid_amount) / SUM(billed_amount) AS paid_ratio
FROM claims
GROUP BY provider_id
ORDER BY paid_ratio DESC;


-- Paid ratio by CPT code

SELECT
    cpt_code,
    SUM(paid_amount) / SUM(billed_amount) AS paid_ratio
FROM claims
GROUP BY cpt_code
ORDER BY paid_ratio DESC;