/*
	Title: All contacts
	
	Description:
	All contacts - add fields from v_censusContactSummary as needed. List below:

districtID	int	NO
personID	int	NO
relatedBy	varchar(12)	NO
contactID	int	YES
contactGUID	uniqueidentifier	NO
private	int	NO
secondary	int	NO
mailing	int	NO
mailingHHL	bit	NO
guardian	bit	YES
portal	bit	YES
messenger	bit	YES
householdID	int	YES
householdPhone	varchar(25)	YES
householdName	varchar(50)	YES
personGUID	uniqueidentifier	NO
contactPersonID	int	NO
studentNumber	varchar(15)	YES
staffNumber	varchar(15)	YES
staffStateID	varchar(20)	YES
lastName	varchar(50)	NO
firstName	varchar(50)	YES
middleName	varchar(50)	YES
suffix	varchar(50)	YES
gender	char(1)	YES
birthdate	smalldatetime	YES
relationship	varchar(40)	YES
seq	tinyint	YES
grade	varchar(4)	YES
calendarName	varchar(30)	YES
homePhone	varchar(25)	YES
workPhone	varchar(25)	YES
cellPhone	varchar(25)	YES
pager	varchar(25)	YES
email	varchar(100)	YES
secondaryEmail	varchar(100)	YES
comments	varchar(500)	YES
communicationLanguage	varchar(15)	YES
number	varchar(12)	YES
street	varchar(30)	YES
tag	varchar(20)	YES
prefix	varchar(10)	YES
dir	varchar(10)	YES
apt	varchar(17)	YES
city	varchar(24)	YES
state	varchar(2)	YES
zip	varchar(10)	YES
county	varchar(50)	YES
addressLine1	varchar(105)	YES
addressLine2	varchar(39)	YES
residentDistrictID	int	YES
residentDistrictNum	varchar(12)	YES
residentDistrictType	varchar(2)	YES
residentDistrictName	varchar(50)	YES
addressID	int	YES
location_code	varchar(40)	YES
tract	varchar(10)	YES
block	varchar(12)	YES
privatePhone	bit	YES
privateAddress	bit	YES
modifiedDate	smalldatetime	YES
addressL1	varchar(87)	YES
addressL2	varchar(17)	YES


	Author: Mark Samberg (mark.samberg@dpi.nc.gov)
	
	Revision History:
	05/30/2024		Initial creation of this template

*/

SELECT
	d.name AS district_name,
	c.name AS calendar_name,
	s.name AS school_name,
	stu.firstname AS student_first,
	stu.lastname AS student_last,
	stu.grade AS grade_level,
	cc.firstName AS contact_first_name,
	cc.lastname AS contact_last_name,
	cc.relationship,
	cc.guardian
	FROM
	student stu,
	district d,
	calendar c,
	school s,
	v_CensusContactSummary cc
WHERE
	stu.personid = cc.personID
	AND d.districtID = stu.districtId
	AND c.calendarID = stu.calendarID
	AND s.schoolID = c.schoolID
	AND cc.personID = stu.personID
	AND c.startDate <= GETDATE ()
	AND c.endDate >= GETDATE ()
	AND(stu.endDate IS NULL
		OR stu.endDate >= GETDATE ())
ORDER BY
	calendar_name,
	student_last,
	student_first
	
