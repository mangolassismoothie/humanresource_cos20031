USE hrdb;
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE deduction;
TRUNCATE TABLE bonus;
TRUNCATE TABLE payroll;
TRUNCATE TABLE salary;
TRUNCATE TABLE attendance;
TRUNCATE TABLE leaveRequest;
TRUNCATE TABLE employee_training;
TRUNCATE TABLE training;
TRUNCATE TABLE jobHistory;
TRUNCATE TABLE children;
TRUNCATE TABLE employee;
TRUNCATE TABLE `position`;
TRUNCATE TABLE department;
SET FOREIGN_KEY_CHECKS = 1;

-- Departments
INSERT INTO department(DepartmentName, Location)
VALUES ('HR','Hanoi'), ('Engineering','Danang');

-- Positions (chú ý backtick vì bảng tên `position`)
INSERT INTO `position`(DepartmentID, Title, BaseSalary)
VALUES (1,'HR Generalist',15000000),
       (2,'Backend Engineer',30000000);

-- Employees (có Role)  ✅ thêm DateOfBirth vì NOT NULL
INSERT INTO employee(FirstName, LastName, DateOfBirth, Email, Position_ID, DepartmentID, EmploymentType, `Role`)
VALUES 
  ('Lan','Nguyen','1999-01-15','lan.nguyen@example.com',1,1,'full-time','HR'),
  ('Minh','Tran','2000-04-02','minh.tran@example.com',2,2,'full-time','Staff');


-- Gán trưởng phòng (minh họa)
UPDATE department SET ManagerEmployeeID = 1 WHERE DepartmentID = 1;

-- Attendance (chấm công)
INSERT INTO attendance(EmployeeID,WorkDate,TimeIn,TimeOut,Status,MinutesWorked)
VALUES (1,'2025-10-15','2025-10-15 08:59:00','2025-10-15 18:01:00','on_time',542);

-- Leave request (có ApproverID)
INSERT INTO leaveRequest(EmployeeID,Type,StartDate,NoOfDays,Status,ApproverID)
VALUES (2,'annual','2025-10-20',2,'approved',1);

-- Salary & Payroll (minh họa)
INSERT INTO salary(EmployeeID,DepartmentID,BaseSalary,EffectiveFrom)
VALUES (1,1,15000000,'2025-01-01');

INSERT INTO payroll(EmployeeID,DepartmentID,SalaryID,PeriodStart,PeriodEnd,Total)
VALUES (1,1,1,'2025-10-01','2025-10-31',18000000);

INSERT INTO bonus(EmployeeID,Reason,BonusAmount,Date)
VALUES (1,'KPI Q3',2000000,'2025-10-10');

INSERT INTO deduction(EmployeeID,Reason,AmountDeducted,Date)
VALUES (2,'Late',100000,'2025-10-10');

SHOW TABLES;

SELECT e.EmployeeID, e.FirstName, e.LastName,
       d.DepartmentName, p.Title, e.`Role`
FROM employee e
LEFT JOIN department d ON e.DepartmentID = d.DepartmentID
LEFT JOIN `position` p ON e.Position_ID = p.Position_ID;

SELECT e.FirstName, a.WorkDate, a.TimeIn, a.TimeOut, a.Status
FROM employee e JOIN attendance a USING (EmployeeID);

SELECT lr.LeaveReqID, emp.FirstName AS Requester,
       appr.FirstName AS Approver, lr.Status
FROM leaveRequest lr
JOIN employee emp  ON lr.EmployeeID = emp.EmployeeID
LEFT JOIN employee appr ON lr.ApproverID = appr.EmployeeID;