CREATE DATABASE `QUANLYSINHVIEN1`;
Use QuanLySinhVien1;

CREATE TABLE Subjects (
SubjectID int Primary key,
SubjectName varchar(50)
);

CREATE TABLE Student (
StudentID int primary key,
StudentName varchar(50),
Age int,
Email varchar(100)
);

CREATE TABLE Classes (
ClassID int primary key,
ClassName varchar(50)
);

CREATE TABLE Marks (
Mark int, 
SubjectID int ,
StudentID int,
foreign key (SubjectID) references Subjects (subjectId),
foreign key (StudentID) references Student (studentId)
);

CREATE TABLE CLassStudent (
StudentID int,
ClassId int,
foreign key (StudentID) references student (StudentId),
foreign key (ClassId) references Classes (ClassId)
);

INSERT INTO Student Values 
(1, 'Nguyen Quang An', 18, 'an@yahoo.com'),
(2, 'Nguyen Cong Vinh', 20, 'vinh@gmail.com'),
(3, 'Nguyen Van Quyen', 19, 'quyen'),
(4, 'Pham Thanh Vinh', 25, 'binh@com'),
(5, 'Nguyen Van Tai Em', 30, 'taiem@sport.vn');

INSERT INTO Classes Values
(1, 'C0706L'),
(2, 'C0708G');

INSERT INTO ClassStudent values
(1, 1),
(2, 1),
(3, 2),
(4, 2),
(5, 2);

truncate ClassStudent

INSERT INTO Subjects values
(1, 'SQL'),
(2, 'Java'),subjects
(3, 'C'),
(4, 'Visual Basic');

INSERT INTO Marks values
(8, 1, 1),
(4, 2, 1),
(9, 1, 1), 
(7, 1, 3),
(3, 1, 4),
(5, 2, 5),
(8, 3, 3),
(1, 3, 5),
(3, 2, 4);

SELECT student.*, classes.*
from student join classStudent 
on Student.studentID = classstudent.studentId
join classes
on classStudent.classId = classes.classid ;

SELECT * from subjects;

SELECT AVG(Mark) as "Diem trung binh"
from Marks;

select  subjects.subjectid, subjects.subjectName, Marks.mark
From marks join subjects on Marks.subjectid = Subjects.subjectid
 where Marks.mark >= all (select mark from marks);

select * from Marks
order by mark desc;

-- Câu 6: Thay doi kieu du lieu cua cot SubjectName trong bang Subjects thanh nvarchar(max)
alter table subjects
modify column subjectName varchar(255);

-- caau7: Cap nhat them dong chu « Day la mon hoc «  vao truoc cac ban ghi tren cot SubjectName trong bang Subjects
-- câu 7 vì ít record nên có thể update thủ công từng dòng

-- Câu 9: Loai bo tat ca quan he giua cac bang
-- Câu 9: Có thể cho tham chiếu bằng null thì có thể xóa mà không cần xóa quan hệ 
alter table ClassStudent
drop constraint classstudent_ibfk_1;

alter table ClassStudent
drop constraint classstudent_ibfk_2;

alter table Marks
drop constraint marks_ibfk_1;

alter table Marks
drop constraint marks_ibfk_2;

-- Câu 10: Xoa hoc vien co StudentID la 1
delete from Students 
where studentID = 1;

-- Câu 11: Trong bang Student them mot column Status co kieu du lieu la Bit va co gia tri Default la 1
alter table Students
add column Status bit default 1;

-- Câu 12: Cap nhap gia tri Status trong bang Student thanh 0
update Students
set status = 0
where studentID > 0;