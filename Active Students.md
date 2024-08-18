# Determining Active Students in Infinite Campus

Infinite Campus has three ways to determine an *active* student. You may end up mixing and matching these depending on the data that you need to pull.

## Active Today
Using the `v_adHocStudent.activeToday` field shows all students who are in membership on a given day. The advantage of this field is that you will see only students who are in school on a given day which accounts for different calendars and school start dates. However, at the beginning of the year, you will not see students using this field until the very first day of school.

**Without school name**:
```
SELECT stu.calendarName,
stu.stateId as UID,
stu.lastName,
stu.firstName,
stu.middleName,
stu.grade,
stu.gender,
CAST(stu.birthdate AS DATE) as birthdate --Change the birthdate DateTime field to just a date.
FROM v_AdHocStudent stu
WHERE stu.ActiveToday=1
ORDER BY lastName, firstName, middleName;
```

**With school name**:
```
SELECT stu.calendarName,
sch.name as SchoolName,
stu.stateId as UID,
stu.lastName,
stu.firstName,
stu.middleName,
stu.grade,
stu.gender,
CAST(stu.birthdate AS DATE) as birthdate --Change the birthdate DateTime field to just a date.
FROM v_AdHocStudent stu,
school sch
WHERE sch.schoolID=stu.schoolID
AND stu.ActiveToday=1
ORDER BY lastName, firstName, middleName;
```

## Active During the Year
Using the `v_adHocStudent.activeYear` field shows all students who are in membership at any point during the school year. The advantage of this field is that all students will show, regardless of enrollment date. However, this field will pull withdrawn students as well. This may be useful for systems where students are not dropped if they withdraw (e.g., a library system where they may still owe books).

```
SELECT stu.calendarName,
sch.name as SchoolName,
stu.stateId as UID,
stu.lastName,
stu.firstName,
stu.middleName,
stu.grade,
stu.gender,
CAST(stu.birthdate AS DATE) as birthdate --Change the birthdate DateTime field to just a date.
FROM v_AdHocStudent stu,
school sch
WHERE sch.schoolID=stu.schoolID
AND stu.ActiveYear=1
ORDER BY lastName, firstName, middleName;
```

## Using Calendar Start and Withdraw Dates
You can use a collection of tables to determine all students who have an enrollment date after the calendar start date (i.e., enrollment dates in the current year), but a withdraw date after or on the current date. While this is the most technically complex of the three queries, this will pull all students who have a current or future-dated enrollment while excluding withdrawn students:

```
SELECT cal.name as CalendarName,
sch.name as SchoolName,
stu.stateId as UID,
stu.lastName,
stu.firstName,
stu.middleName,
stu.grade,
stu.gender,
CAST(stu.birthdate AS DATE) as birthdate --Change the birthdate DateTime field to just a date.
FROM student stu,
calendar cal,
school sch,
schoolyear yr
WHERE cal.calendarId=stu.calendarId
AND sch.schoolID=cal.SchoolID
AND cal.endYear=yr.endYear
AND yr.active=1
AND (stu.endDate IS NULL or stu.endDate>=GETDATE()) --Get students with no end-date or future-dated end date
ORDER BY lastName, firstName, middleName;
```
