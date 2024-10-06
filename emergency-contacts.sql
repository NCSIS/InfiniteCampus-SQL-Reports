/*
   Staff/Student/Emergency Contact Names and Addresses

	Author: Mark Samberg (mark.samberg@dpi.nc.gov)
	
	Revision History:
	10/06/2024		Initial creation of this template

*/


/* Staff Names and Addresses */
SELECT
    s.name as school,
    st.lastname,
    st.firstname,
    st.number,
    st.street,
    st.tag,
    st.prefix,
    st.dir,
    st.apt,
    st.city,
    st.zip,
    st.phone,
    st.homephone,
    st.cellphone
FROM
    sif_StaffPersonal st,
    school s
WHERE
    s.schoolID = st.schoolID
ORDER BY
    school,
    lastname,
    firstname

/* Student Names and Addresses */
SELECT 
	d.name AS district_name,
	c.name AS calendar_name,
	s.name AS school_name,
	stu.last_name AS student_last,
	stu.first_name AS student_first,
	stu.grade AS grade_level,
	stu.address,
	stu.city,
	stu.zip,
	stu.home_phone
	FROM
	view_students stu,
	district d,
	calendar c,
	school s
WHERE d.districtID = c.districtId
	AND c.calendarID = stu.calendarID
	AND s.schoolID = c.schoolID
	AND c.endYear='2025'
ORDER BY
	calendar_name,
	student_last,
	student_first

/* Emergency Contacts */
SELECT DISTINCT
	d.name AS district_name,
	c.name AS calendar_name,
	s.name AS school_name,
	stu.firstname AS student_first,
	stu.lastname AS student_last,
	stu.grade AS grade_level,
	vst.address,
	cc.householdName,
	cc.firstName AS contact_first_name,
	cc.lastname AS contact_last_name,
	cc.relationship,
	cc.seq as contact_sequence,
	cc.email,
	cc.homePhone,
	cc.householdPhone,
	cc.workPhone,
	cc.cellPhone
	FROM
	student stu,
	view_students vst,
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
	AND vst.personID=stu.personID
	AND vst.calendarID=stu.calendarID
ORDER BY
	calendar_name,
	student_last,
	student_first,
	contact_sequence
