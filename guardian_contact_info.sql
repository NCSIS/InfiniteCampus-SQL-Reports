/*
   Parent Contact Information

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
	cc.householdName,
	cc.firstName AS contact_first_name,
	cc.lastname AS contact_last_name,
	cc.relationship,
	cc.email,
	cc.homePhone,
	cc.householdPhone,
	cc.workPhone,
	cc.cellPhone
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
	AND cc.guardian = 1
ORDER BY
	calendar_name,
	student_last,
	student_first
