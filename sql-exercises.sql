-- Le Minh Duc - 20200164

-- 1
SELECT No_Of_Copies
FROM BOOK_COPIES
JOIN BOOK ON BOOK.BookId = BOOK_COPIES.BookId
JOIN LIBRARY_BRANCH ON LIBRARY_BRANCH.BranchId = BOOK_COPIES.BranchId
WHERE Title = 'The Lost Tribe' AND BranchName = 'Sharpstown';

-- 2
SELECT BranchId, No_Of_Copies
FROM BOOK_COPIES
JOIN BOOK ON BOOK.BookId = BOOK_COPIES.BookId
WHERE Title = 'The Lost Tribe';

-- 3
SELECT Name
FROM BORROWER
WHERE CardNo NOT IN (SELECT CardNo FROM BOOK_LOANS);

-- 4
SELECT Title, Name, Address
FROM BOOK_LOANS
JOIN BOOK ON BOOK.BookId = BOOK_LOANS.BookId
JOIN BORROWER ON BORROWER.CardNo = BOOK_LOANS.CardNo
WHERE BranchId IN (
	SELECT BranchId
	FROM LIBRARY_BRANCH
	WHERE BranchName = 'Sharpstown'
) AND DueDate = CURRENT_DATE;

-- 5
SELECT BranchName, COUNT(*)
FROM LIBRARY_BRANCH
JOIN BOOK_LOANS ON BOOK_LOANS.BranchId = LIBRARY_BRANCH.BranchId;
GROUP BY LIBRARY_BRANCH.BranchId, BranchName;

-- 6
SELECT Name, Address, COUNT(*)
FROM BORROWER
JOIN BOOK_LOANS ON BOOK_LOANS.CardNo = BORROWER.CardNo
GROUP BY BORROWER.CardNo, Name, Address
HAVING COUNT(*) > 5;

-- 7
SELECT Title, No_Of_Copies
FROM BOOK
JOIN BOOK_COPIES ON BOOK_COPIES.BookId = Book.BookId
WHERE BookId IN (
	SELECT BookId
	FROM BOOK_AUTHORS
	WHERE AuthorName = 'Stephen King'
) AND BranchId IN (
	SELECT BranchId
	FROM LIBRARY_BRANCH
	WHERE BranchName = 'Central'
);

-- 8
SELECT FNAME, LNAME
FROM EMPLOYEE
JOIN WORKS_ON ON WORKS_ON.ESSN = EMPLOYEE.SSN
JOIN PROJECT ON PROJECT.PNUMBER = WORKS_ON.PNO
WHERE DNO = 5 AND HOURS > 10 AND PNAME = 'ProductX';

-- 9
SELECT PNAME, SUM(HOURS)
FROM PROJECT
JOIN WORKS_ON ON WORKS_ON.PNO = PROJECT.PNUMBER
GROUP BY PROJECT.PNUMBER, PNAME;

-- 10
SELECT FNAME, LNAME
FROM EMPLOYEE
WHERE SSN IN (
	SELECT ESSN
	FROM WORKS_ON
	GROUP BY PNO
	HAVING COUNT(*) = (SELECT COUNT(*) FROM PROJECT)
);

-- 11
SELECT FNAME, LNAME
FROM EMPLOYEE
WHERE SSN NOT IN (
	SELECT ESSN
	FROM WORKS_ON
);

-- 12
SELECT FNAME, LNAME, ADDRESS
FROM EMPLOYEE
WHERE SSN IN (
	SELECT ESSN
	FROM WORKS_ON
	JOIN PROJECT ON PROJECT.PNUMBER = WORKS_ON.PNO
	WHERE PLOCATION = 'Houston'
) AND DNO NOT IN (
	SELECT DNUMBER
	FROM DEPT_LOCATIONS
	WHERE DLOCATION = 'Houston'
);

-- 13
SELECT LNAME
FROM EMPLOYEE
WHERE SSN IN (
	SELECT MGRSSN FROM DEPARTMENT
) AND SSN NOT IN (
	SELECT ESSN FROM DEPENDENT
);

-- 14
SELECT *
FROM EMPLOYEE
WHERE SALARY > (
	SELECT AVG(SALARY) FROM EMPLOYEE
)
ORDER BY SALARY DESC;

-- 15
SELECT E1.*
FROM EMPLOYEE AS E1
WHERE E1.SALARY > (
	SELECT AVG(SALARY)
	FROM EMPLOYEE AS E2
	WHERE E1.DNO = E2.DNO
)
ORDER BY SALARY ASC;
