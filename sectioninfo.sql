WITH SectionsGrouped AS (
  SELECT sg.sectionID, sg.termname, sg.termstartdate, sg.termenddate
  FROM v_OneRosterSectionPlacement sg
  GROUP BY sg.sectionID, sg.termname, sg.termstartdate, sg.termenddate
),

SixWeekSemester AS (
  SELECT COUNT(sg2.sectionID) AS TCount, sg2.sectionID
  FROM SectionsGrouped sg2
  WHERE sg2.termname IN ('T1', 'T2', 'T3', 'T4', 'T5', 'T6')
  GROUP BY sg2.sectionID
),

NineWeekSemester AS (
  SELECT COUNT(sg1.sectionID) AS NCount, sg1.sectionID
  FROM SectionsGrouped sg1
  WHERE sg1.termname IN ('N1', 'N2', 'N3', 'N4')
  GROUP BY sg1.sectionID
),

SemesterDate AS (
  SELECT sg3.sectionID,
         MIN(sg3.termstartdate) AS SemesterStart,
         MAX(sg3.termenddate) AS SemesterEnd
  FROM SectionsGrouped sg3
  GROUP BY sg3.sectionID
)

SELECT DISTINCT
  s.sectionID AS 'CC.SectionID',
  s.courseID AS 'CourseID',
  s.teacherDisplay AS 'Teacher_Display_Name',
  s.number AS 'CC.Section_Number',
  sm.personid AS 'SISID',
--  s.teacherPersonID AS 'SISID',
--  s.teacherPersonID AS 'TEACHERS.USERS_DCID',
  s.homeroomSection AS 'IsHomeroom',
  sp.status AS 'SectionStatus',
  sp.periodID AS 'PeriodID',
-- sp.termID AS 'TermICID',
  sp.periodScheduleID AS 'PeriodScheduleID',
  sp.periodScheduleName AS 'PeriodName',
--  sp.termSeq AS 'TermSeq',
  c.active AS 'CourseActive',
  c.courseID AS 'CCourseID',
  c.calendarID AS 'CCalendarID',
  c.StateCode AS 'CourseCode',
  c.number AS 'CC.COURSE_NUMBER',
  c.name AS 'COURSES.Course_Name',
  cal.calendarID AS 'CalendarID',
  cal.name AS 'CalendarName',
  cal.endDate AS 'CalendarDate',
  cal.endYear AS 'CalendarEndYear',
  p.periodID AS 'CC.EXPRESSION',
  p.name AS 'periodNum',
  p.startTime AS 'periodStartTime',
  p.endTime AS 'periodEndTime',  -- Updated to correct this line
  sm.staffStateID AS 'TeacherNumber',
  sm.givenName AS 'TeacherFirst',
  sm.familyName AS 'TeacherLast',
  sm.email AS 'TeacherEmail',
  sch.number AS 'CC.SchoolID',
  sch.name AS 'SchoolName',
  CASE
    WHEN nws.NCount = 4 THEN 'YL'
    WHEN nws.NCount = 2 AND sp.termname IN ('N1', 'N2') THEN 'S1'
    WHEN nws.NCount = 2 AND sp.termname IN ('N3', 'N4') THEN 'S2'
    WHEN tws.TCount = 6 THEN 'YL'
    WHEN tws.TCount = 3 AND sp.termname IN ('T1', 'T2', 'T3') THEN 'S1'
    WHEN tws.TCount = 3 AND sp.termname IN ('T4', 'T5', 'T6') THEN 'S2'
    ELSE 'Other'
  END AS 'CC.termID',
  FORMAT(sd.SemesterStart, 'MM/dd/yyyy') AS 'TermStartDate',
  FORMAT(sd.SemesterEnd, 'MM/dd/yyyy') AS 'TermEndDate'

FROM v_OneRosterSectionPlacement sp
INNER JOIN section s ON sp.sectionID = s.sectionID
INNER JOIN course c ON c.courseID = s.CourseID
INNER JOIN calendar cal ON cal.calendarID = c.calendarID
INNER JOIN period p ON p.periodID = sp.periodID
INNER JOIN v_OneRosterTeacherEnrollment orte ON orte.sectionid = s.sectionid and orte.[primary] = '1'
INNER JOIN v_OneRosterTeacher sm ON sm.personID = orte.personID
INNER JOIN School sch ON sch.schoolID = cal.schoolid
LEFT OUTER JOIN NineWeekSemester nws ON s.sectionID = nws.sectionID
LEFT OUTER JOIN SixWeekSemester tws ON s.sectionID = tws.sectionID
LEFT OUTER JOIN SemesterDate sd ON sd.sectionID = s.sectionID
/*
CROSS APPLY (
  SELECT TOP 1 * 
  FROM v_CensusContactSummary cs 
  WHERE cs.personID = sm.personID 
  AND cs.relationship = 'Self' 
  ORDER BY cs.contactID DESC
) cs
*/

WHERE cal.endYear = '2026'
ORDER BY sp.periodScheduleID

