----------------------------Table 1------------------------------
-----------------------Create Table Address----------------------

CREATE TABLE dbo.Address
(
	[AddressID] [varchar](15) NOT NULL PRIMARY KEY,
	[Street] [varchar](100) NOT NULL,
	[City] [varchar](100) NOT NULL,
	[State] [varchar](50) NOT NULL,
	[ZipCode] [int] NOT NULL
)

----------------------------Table 2------------------------------
-----------------------Create Table Person-----------------------

CREATE TABLE dbo.Person
 (
	[PersonId] [varchar](15) NOT NULL PRIMARY KEY,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](20) NOT NULL,
	[Gender] [varchar](2) NOT NULL,
	[IdentificationNo] [nvarchar](10) NOT NULL,
	[SSN] [nvarchar](20) NOT NULL,
	[Phone] [bigint] NOT NULL,
	[Email] [nvarchar](50) NOT NULL
 );

----------------------------Table 3------------------------------------
-----------------------Create Table PersonAddress----------------------

CREATE TABLE [dbo].[PersonAddress]
(
	[PersonId] [varchar](15) NOT NULL,
	[AddressId] [varchar](15) NOT NULL,
	PRIMARY KEY([PersonID],[AddressID]),
	FOREIGN KEY([PersonID]) REFERENCES [PERSON]([PersonID]),
	FOREIGN KEY([AddressID]) REFERENCES [ADDRESS]([AddressID])
);

----------------------------Table 4------------------------------------
-----------------------Create Table JobTitle---------------------------

 CREATE TABLE dbo.JobTitle
 (
	[JobTitleId] [varchar](15) NOT NULL PRIMARY KEY,
	[TitleName] [varchar](50) NOT NULL,
	[Salary] [money] NOT NULL,
	[PaymentCycle] [varchar](10) NOT NULL
 );

----------------------------Table 5------------------------------------
-----------------------Create Table Discounts--------------------------

 CREATE TABLE dbo.Discounts
 (
	 [DiscountType] [varchar](15) NOT NULL PRIMARY KEY,
	 [DiscountPrice] [money] NOT NULL,
	 [Season] [varchar](10) NOT NULL
 );

----------------------------Table 6------------------------------------
-----------------------Create Table PlanType---------------------------

 CREATE TABLE dbo.PlanType
 (
	[PlanTypeId] [varchar](15) NOT NULL PRIMARY KEY,
	[PlanName] [varchar](30) NOT NULL,
	[AmountByMonth] [money] NOT NULL
 );

----------------------------Table 7------------------------------------
-----------------------Create Table EquipmentCategory------------------

 CREATE TABLE dbo.EquipmentCategory
 (
	[EquipmentCategoryId] [varchar](15) NOT NULL PRIMARY KEY,
	[CategoryName] [varchar](50) NOT NULL
  );

----------------------------Table 8----------------------------------
-----------------------Create Table Branch---------------------------

 CREATE TABLE dbo.Branch
 (
	[BranchId] [varchar](15) NOT NULL PRIMARY KEY,
	[Phone] [bigint] NOT NULL,
	[AddressID] [varchar](15) NOT NULL
	FOREIGN KEY([AddressID]) REFERENCES [ADDRESS]([AddressID])
 );
 
----------------------------Table 9-------------------------------------
-----------------------Create Table Equipment---------------------------
 CREATE TABLE dbo.Equipment
 (
	[EquipmentId] [varchar](15) NOT NULL PRIMARY KEY,
	[BranchId] [varchar](15) NOT NULL,
	[EquipmentCategoryId] [varchar](15) NOT NULL,
	[PurchaseDate] [datetime] NOT NULL,
	FOREIGN KEY([BranchId]) REFERENCES [BRANCH]([BranchId]),
	FOREIGN KEY([EquipmentCategoryId]) REFERENCES [EquipmentCategory]([EquipmentCategoryId])
 );

----------------------------Table 10---------------------------------------------
-----------------------Create Table MaintainanceRecord---------------------------
 CREATE TABLE dbo.MaintainanceRecord
 (
	[MaintainanceRecordId] [varchar](15) NOT NULL PRIMARY KEY,
	[EquipmentId] [varchar](15) NOT NULL,
	[MaintainanceDate] [datetime] NOT NULL,
	[MaintainanceDetail] [varchar](50) NOT NULL,
	[MainatainanceCost] [money] NOT NULL,
	FOREIGN KEY([EquipmentId]) REFERENCES [Equipment]([EquipmentId])
 );

----Function to create constraint on Maintainance Table
CREATE FUNCTION checkMaintenanceDate(@EquipmentID varchar(15))
Returns DateTime
AS
BEGIN
	DECLARE @PurchaseDate datetime
	SELECT @PurchaseDate=PurchaseDate from Equipment
	where EquipmentID=@EquipmentID
Return @PurchaseDate
END

----Alter table to add constraint "checkMaintenanceDate"
ALTER TABLE [dbo].[MaintainanceRecord] ADD CONSTRAINT Constraint_GreaterThanPurchaseDate CHECK(dbo.checkMaintenanceDate(EquipmentID)<MaintainanceDate)


 ----------------------------Table 11-----------------------------------
-----------------------Create Table ClassRoom---------------------------

 CREATE TABLE dbo.ClassRoom
 (
	[ClassRoomId] [varchar](15) NOT NULL PRIMARY KEY,
	[BranchId] [varchar](15) NOT NULL,
	[RoomNo] [int] NOT NULL,
	FOREIGN KEY([BranchId]) REFERENCES [BRANCH]([BranchId])
 );
 
 ----------------------------Table 12------------------------------------
 -----------------------Create Table Employees---------------------------
 CREATE TABLE dbo.Employees
 (
	[EmployeeId] [varchar](15) NOT NULL PRIMARY KEY,
	[PersonId] [varchar](15) NOT NULL,
	[BranchId] [varchar](15) NOT NULL,
	[JobTitleId] [varchar](15) NOT NULL,
	[HireDate] [date] NOT NULL,
	FOREIGN KEY([BranchId]) REFERENCES [BRANCH]([BranchId]),
	FOREIGN KEY([PersonId]) REFERENCES [PERSON]([PersonId]),
	FOREIGN KEY([JobTitleId]) REFERENCES [JobTitle]([JobTitleId])
 );

 ----------------------------Table 13----------------------------------------
 -----------------------Create Table PaymentRecord---------------------------

  CREATE TABLE dbo.PaymentRecord
 (
	[PaymentRecordId] [varchar](15) NOT NULL PRIMARY KEY,
	[EmployeeId] [varchar](15) NOT NULL,
	[PaymentDate] [datetime] NOT NULL,
	[DirectDepositAccount] [varchar](20) NOT NULL,
	FOREIGN KEY([EmployeeId]) REFERENCES [EMPLOYEES]([EmployeeId])
 );

 ----Function to create constraint on PaymentRecord Table
CREATE FUNCTION checkPayDate(@EmployeeID varchar(15))
Returns DateTime
AS
BEGIN
	DECLARE @HireDate datetime
	SELECT @HireDate=HireDate from Employees
	where EmployeeID=@EmployeeID
Return @HireDate
END

----Alter Table to add constraint "checkPayDate"
ALTER TABLE PaymentRecord ADD CONSTRAINT Constraint_GreaterThanHireDate CHECK(dbo.checkPayDate(EmployeeID)<PaymentDate)

 ----------------------------Table 14----------------------------------
 -----------------------Create Table Classes---------------------------


 CREATE TABLE dbo.Classes
 (
	[ClassId] [varchar](15) NOT NULL PRIMARY KEY,
	[InstructorId] [varchar](15) NOT NULL,
	[ClassRoomId] [varchar](15) NOT NULL,
	[ProgramName] [varchar](30) NOT NULL,
	[DayInWeek] [varchar](10) NOT NULL,
	[Time] [time](7) NOT NULL,
	[Capacity] [int] NOT NULL,
	[DurationInHours] [int] NOT NULL,
	FOREIGN KEY([ClassRoomId]) REFERENCES [ClassRoom] ([ClassRoomId]),
	FOREIGN KEY([InstructorId]) REFERENCES [Employees] ([EmployeeId])
 );

 ----------------------------Table 15-----------------------------------
 -----------------------Create Table Customer---------------------------

 CREATE TABLE dbo.Customer
 (
	[CustomerId] [varchar](15) NOT NULL PRIMARY KEY,
	[PersonId] [varchar](15) NOT NULL,
	[DiscountType] [varchar](15) NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[PlanTypeId] [varchar](15) NOT NULL,
	[BranchID] [varchar](15) NOT NULL,
	FOREIGN KEY([DiscountType]) REFERENCES [Discounts] ([DiscountType]),
	FOREIGN KEY([PersonId]) REFERENCES [Person] ([PersonId]),
	FOREIGN KEY([PlanTypeId]) REFERENCES [PlanType] ([PlanTypeId]),
	FOREIGN KEY([BranchID]) REFERENCES [BRANCH]([BranchID])
 );

 ----------------------------Table 16-------------------------------------
 -----------------------Create Table Enrollment---------------------------

  CREATE TABLE dbo.Enrollment
 (
	 [EnrollmentId] [varchar](15) NOT NULL PRIMARY KEY,
	 [ClassId] [varchar](15) NOT NULL,
	 [CustomerId] [varchar](15) NOT NULL,
	 FOREIGN KEY([ClassId]) REFERENCES [Classes] ([ClassId]),
	 FOREIGN KEY([CustomerId]) REFERENCES .[Customer] ([CustomerId])
 );

 ----------------------------Table 17----------------------------------------
 -----------------------Create Table BillingRecord---------------------------

 CREATE TABLE dbo.BillingRecord
 (
	[BillingRecordId] [varchar](15) NOT NULL PRIMARY KEY,
	[CustomerId] [varchar](15) NOT NULL,
	[BillingDate] [datetime] NOT NULL,
	FOREIGN KEY([CustomerId]) REFERENCES [Customer] ([CustomerId])
 );

----1. Function to create constraint on BillingRecord Table

CREATE FUNCTION checkBillingDate(@CustomerID varchar(15))
Returns DateTime
AS
BEGIN
	DECLARE @StartDate DateTime
	SELECT @StartDate=StartDate from [Customer]
	where CustomerID=@CustomerID
Return @StartDate
END

-----2. Function to create constraint on BillingRecord Table
CREATE FUNCTION checkBillingDate2(@CustomerID varchar(15))
Returns DateTime
AS
BEGIN
	DECLARE @EndDate DateTime
	SELECT @EndDate=EndDate from [Customer]
	where CustomerID=@CustomerID
Return @EndDate
END

--Alter Table to add two contraints "checkBillingDate" and "checkBillingDate2"
ALTER TABLE BillingRecord ADD CONSTRAINT Constraint_BetweenStartAndEndDate CHECK((dbo.checkBillingDate(CustomerID)<BillingDate) and (dbo.checkBillingDate2(CustomerID)>BillingDate))

---After inserting records into Person table run the below script to encrypt SSN. Please note we need to execute only from step 5 to step 7
--as we have already created key, certificate and password.

--Step 1
CREATE MASTER KEY ENCRYPTION BY   
PASSWORD = '<Crackme>';

  
--Step 2
CREATE CERTIFICATE personSSN  
   WITH SUBJECT = 'Employee Social Security Numbers';  
GO  

--Step 3
CREATE SYMMETRIC KEY SSN_Key_01  
    WITH ALGORITHM = AES_256  
    ENCRYPTION BY CERTIFICATE personSSN;  
GO  


--Step 4
-- Create a column in which to store the encrypted data.  
ALTER TABLE dbo.[Person]  
    ADD EncryptedNationalIDNumber varbinary(250);   
GO  
--Step 5
-- Open the symmetric key with which to encrypt the data.  
OPEN SYMMETRIC KEY SSN_Key_01  
   DECRYPTION BY CERTIFICATE personSSN;  

 --Step 6
-- Encrypt the value in column SSN with symmetric   
-- key SSN_Key_01. Save the result in column EncryptedNationalIDNumber.  
UPDATE dbo.[Person]  
SET EncryptedNationalIDNumber = EncryptByKey(Key_GUID('SSN_Key_01'),[SSN] ) WHERE SSN NOT IN('XXX-XXX-XXX') ;  
GO  


--Step 7
--Replacing data in attribute SSN  with dummy value
UPDATE dbo.[Person]
SET SSN='XXX-XXX-XXX'
WHERE SSN IS NOT NULL;

-- Verify the encryption.  
-- First, open the symmetric key with which to decrypt the data.  
OPEN SYMMETRIC KEY SSN_Key_01  
   DECRYPTION BY CERTIFICATE personSSN;  
GO  


-- Now list the Column SSN, the encrypted ID, and the   
-- decrypted ciphertext.   
SELECT personId,[SSN], EncryptedNationalIDNumber   
    AS 'Encrypted SSN',  
    CONVERT(nvarchar, DecryptByKey(EncryptedNationalIDNumber))   
    AS 'Decrypted SSN'  
    FROM  dbo.[Person]
	order by personId;  
GO

/*Computed Columns based on a function
	Create a Computed Column in Customer table based on a funtion return the total classes enrollment
	*/
CREATE FUNCTION TotalClassEnrollment
(@InputCustomerId VARCHAR(20))
RETURNS INT
AS
	BEGIN
		DECLARE @TotalEnrollment INT;
		SELECT @TotalEnrollment = COUNT(e.EnrollmentId)
		FROM dbo.Enrollment e
		WHERE e.CustomerId = @InputCustomerId;
		RETURN @TotalEnrollment;
	END
GO

SELECT * FROM dbo.Customer;

ALTER TABLE dbo.Customer
ADD TotalEnrollment AS (dbo.TotalClassEnrollment(CustomerId));

SELECT * FROM dbo.Customer;

--Function for calculate the profit of Gyms in certain year and month
CREATE FUNCTION ProfitInYearMonth
 (@InputYear INT, @InputMonth INT)
RETURNS INT
AS
	BEGIN
		DECLARE @TotalPaymentToEmployee INT;
		DECLARE @TotalMaintenanceFee INT;
		DECLARE @TotalIncome INT;
	--Calculate the payment to employee
		SELECT @TotalPaymentToEmployee = ISNULL(SUM(jt.Salary), 0)
		FROM dbo.PaymentRecord pr
		LEFT JOIN dbo.Employees e
		ON pr.EmployeeId = e.EmployeeId
		LEFT JOIN dbo.JobTitle jt
		ON e.JobTitleId = jt.JobTitleId
		WHERE DATEPART(YEAR, pr.PaymentDate) = @InputYear 
			AND DATEPART(MONTH, pr.PaymentDate) = @InputMonth;
	--Calculate the equipment Maintainance cost
		SELECT @TotalMaintenanceFee = ISNULL(SUM(mr.MainatainanceCost), 0)
		FROM dbo.MaintainanceRecord mr
		WHERE DATEPART(YEAR, mr.MaintainanceDate) = @InputYear 
			AND DATEPART(MONTH, mr.MaintainanceDate) = @InputMonth;
	--Calculate the income from Customer Membership Fee
		SELECT @TotalIncome = ISNULL(SUM(pt.AmountByMonth - ISNULL(dc.DiscountPrice,0)), 0)
		FROM dbo.BillingRecord br
		LEFT JOIN dbo.Customer c
		ON br.CustomerId = c.CustomerId
		LEFT JOIN dbo.PlanType pt
		ON c.PlanTypeId = pt.PlanTypeId
		LEFT JOIN dbo.Discounts dc
		ON c.DiscountType = dc.DiscountType
		WHERE  DATEPART(YEAR, br.BillingDate) = @InputYear 
			AND DATEPART(MONTH, br.BillingDate) = @InputMonth;
	
		RETURN @TotalIncome - @TotalPaymentToEmployee - @TotalMaintenanceFee;
	END
GO

SELECT dbo.ProfitInYearMonth(2019,5);

DROP FUNCTION ProfitInYearMonth;

/*Create a View to show the fitness classes enrollments records from high to low,
	show the ClassId, ProgramName and the total enrollments number, 
	show the view and order by enrollments number from high to low
	*/
CREATE VIEW [Classes popularity] AS
	SELECT  cl.ClassId, cl.ProgramName, COUNT(en.EnrollmentId) AS [Total Enrollment]
	FROM dbo.Classes cl
	JOIN dbo.Enrollment en
	ON cl.ClassId = en.ClassId
	GROUP BY cl.ClassId, cl.ProgramName;

--Select from the view
SELECT * FROM [Classes popularity]
ORDER BY [Total Enrollment] DESC;

--Drop the view
DROP VIEW [Classes popularity];

/* Create a View to show the frequency of equipment maintenance grouping by EquimentCatagory,
	show the EquipmentCatagoryId, CatagoryName, total number of maintenance record,
	order by mantenance records number from high to low
	This view is to report which catagory of equipments is maintained more freguenyly.
	 */
CREATE VIEW [Maintainance Frequency] AS
	SELECT ec.EquipmentCategoryId, ec.CategoryName, 
			COUNT(mr.MaintainanceRecordId) AS[Total Maintence Records]
	FROM dbo.EquipmentCategory ec
	JOIN dbo.Equipment ep
	ON ec.EquipmentCategoryId = ep.EquipmentCategoryId
	JOIN dbo.MaintainanceRecord mr
	ON ep.EquipmentId = mr.EquipmentId
	GROUP BY ec.EquipmentCategoryId, ec.CategoryName;

--Select from the view
SELECT * FROM [Maintainance Frequency]
ORDER BY [Total Maintence Records] DESC;

--Drop the view
DROP VIEW [Maintainance Frequency];


/* Create a View to show the class instructor's information, including ProgramName, First Name, Last Name,
	Gender, and Email.
	Order by ClassId.
	*/
CREATE VIEW [Instructor Information] AS
	SELECT cl.ClassId, cl.ProgramName, p.FirstName, p.LastName, p.Gender, p.Email
	FROM dbo.Classes cl
	JOIN dbo.Employees e
	ON cl.InstructorId = e.EmployeeId
	JOIN dbo.Person p
	ON e.PersonId = p.PersonID;

--Select from the view
SELECT * FROM [Instructor Information]
ORDER BY ClassId;

--Drop the view
DROP VIEW [Instructor Information];