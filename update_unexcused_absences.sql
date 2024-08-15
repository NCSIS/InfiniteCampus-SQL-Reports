/*
	Title: Update unknown absences to 2A code
	
	Description:
	Query that can run as a scheduled task daily to update all unknown absences to a "2A" code. 

  WARNING: THIS IS A DESTRUCTIVE ACTION. DO NOT PROCEED WITHOUT TESTING IN YOUR SANDBOX/TRAINING INSTANCE. 
	
	Author: Karen Jimeson (karen.jimeson@dpi.nc.gov)
	
	Revision History:
	08/15/2024		Initial creation of this template

*/

UPDATE
	a
SET
	a.excuseid = CASE COALESCE(x.status, a.status)
	WHEN 'A' THEN
	(
		SELECT
			AE.excuseid
		FROM
			AttendanceExcuse AE
		WHERE
			a.calendarid = ae.calendarid
			AND ae. [code] = '2A')
	END
FROM
	dbo.Attendance a
	LEFT OUTER JOIN dbo.AttendanceExcuse x ON x.excuseID = a.excuseID
	AND x.calendarID = a.calendarID
	INNER JOIN calendar c ON c.calendarid = a.calendarid
	INNER JOIN schoolyear sy ON sy.endyear = c.endyear
WHERE (a.excuse IS NULL
	AND x.excuse IS NULL)
AND sy.active = 1
