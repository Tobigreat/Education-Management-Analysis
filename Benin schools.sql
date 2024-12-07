CREATE DATABASE School;
USE School;
# summarize how many schools you eliminated for bad/missing data
SELECT COUNT(School) AS Number_blank
FROM edu2
WHERE School = '' OR School IS NULL;
#How many total schools are left in the dataset?
SELECT COUNT(School) AS Number_of_school
FROM edu2
WHERE School != '' AND School IS NOT NULL;
SELECT 
    ROUND(
        (SUM(CASE WHEN (ECD_Enrollment_Boys_and_Girls + Primary_Enrollment_Boys + Primary_Enrollment_Girls) >= 200 
              THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 
        2
    ) AS percentage_with_200_students
FROM 
    edu2;
#What percentage of the total schools have enough teachers assigned to those schools such that the
#ratio of Teachers Assigned to Total Classes Offered (Total Classes Offered is both ECD and Primary
#Classes Offered) is at least 1.0
SELECT 
    ROUND(
        (SUM(CASE WHEN (Teachers_assigned / (ECD_Classes_Offered + Primary_Classes_Offered)) >= 1 
              THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 
        2
    ) AS percentage_with_sufficient_teachers
FROM 
    edu2;
SELECT *
FROM edu2;
#How many of the total schools have a total PTR (ECD and Primary combined) of at least 20
SELECT 
    COUNT(*) AS schools_with_PTR
FROM 
    edu2
WHERE 
    (ECD_Enrollment_Boys_and_Girls + Primary_Enrollment_Boys + Primary_Enrollment_Girls) / Teachers_assigned >= 20;
#How many of the schools in question 5 offer at least some classes in both ECD AND Primary?
SELECT 
    COUNT(*) AS school_with_classes_in_both_PTR
FROM 
    edu2
WHERE 
    (ECD_Enrollment_Boys_and_Girls + Primary_Enrollment_Boys + Primary_Enrollment_Girls) / Teachers_Assigned >= 20
    AND ECD_Classes_Offered > 0
    AND Primary_Classes_Offered > 0;
#Present a summary table breaking down the total schools by buckets of their PTR
SELECT 
    CASE 
        WHEN (ECD_Enrollment_Boys_and_Girls + Primary_Enrollment_Boys + Primary_Enrollment_Girls) / Teachers_Assigned BETWEEN 0 AND 10 THEN 'PTR 0-10'
        WHEN (ECD_Enrollment_Boys_and_Girls + Primary_Enrollment_Boys + Primary_Enrollment_Girls) / Teachers_Assigned BETWEEN 10 AND 15 THEN 'PTR 10-15'
        WHEN (ECD_Enrollment_Boys_and_Girls + Primary_Enrollment_Boys + Primary_Enrollment_Girls) / Teachers_Assigned BETWEEN 15 AND 20 THEN 'PTR 15-20'
        ELSE 'PTR > 20'
    END AS Bucket,
    COUNT(*) AS Total_Schools
FROM 
    edu2
GROUP BY 
    Bucket
ORDER BY 
    Bucket;
#For each bucket group, present the of schools in each bucket, the total enrollment in all schools
SELECT 
    CASE 
        WHEN (ECD_Enrollment_Boys_and_Girls + Primary_Enrollment_Boys + Primary_Enrollment_Girls) / Teachers_assigned BETWEEN 0 AND 10 THEN 'PTR 0-10'
        WHEN (ECD_Enrollment_Boys_and_Girls + Primary_Enrollment_Boys + Primary_Enrollment_Girls) / Teachers_assigned BETWEEN 10 AND 15 THEN 'PTR 10-15'
        WHEN (ECD_Enrollment_Boys_and_Girls + Primary_Enrollment_Boys + Primary_Enrollment_Girls) / Teachers_assigned BETWEEN 15 AND 20 THEN 'PTR 15-20'
        ELSE 'PTR > 20'
    END AS Bucket,
    COUNT(*) AS Total_Schools,
    SUM(ECD_Enrollment_Boys_and_Girls + Primary_Enrollment_Boys + Primary_Enrollment_Girls) AS Total_Enrollment,
    SUM(CASE 
            WHEN Teachers_assigned / (ECD_Classes_Offered + Primary_Classes_Offered) >= 1 THEN 1 
            ELSE 0 
        END) AS Schools_With_Ratio
FROM 
    edu2
GROUP BY 
    Bucket
ORDER BY 
    Bucket;




