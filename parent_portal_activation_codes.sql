/*
	Title: Parent Portal Activation Codes
	
	Description:
	Generates a file for Infinite Campus parent portal activation codes for use in a mail merge. To show in this report, a guardian must have an email address and the "Portal" box checked under the student record in Census > Relationships.
	
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
	cc.firstName AS guardian_first_name,
	cc.lastname AS guardian_last_name,
	cc.email AS guardian_email,
	cc.relationship AS guardian_relationship,
	pp.personGUID AS activation_code
FROM
	student stu,
	district d,
	calendar c,
	school s,
	v_CensusContactSummary cc,
	person pp
WHERE
	stu.personid = cc.personID
	AND d.districtID = stu.districtId
	AND c.calendarID = stu.calendarID
	AND s.schoolID = c.schoolID
	AND cc.personID = stu.personID
	AND pp.personID = cc.contactPersonID
	AND c.startDate <= GETDATE ()
	AND c.endDate >= GETDATE ()
	AND(stu.endDate IS NULL
		OR stu.endDate >= GETDATE ())
	AND cc.portal = '1'
	AND cc.email IS NOT NULL
ORDER BY
	calendar_name,
	student_last,
	student_first,
	guardian_relationship
