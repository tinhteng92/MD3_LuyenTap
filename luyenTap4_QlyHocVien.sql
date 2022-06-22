create database `QuanLyHocVien`;
use quanlyhocvien;

create table test(
testId int primary key,
SubTestName varchar(60)
);
create table student(
RN int primary key,
Name varchar(50) not null,
Age int(4)
);

create table studentTest(
testId int, 
RN int, 
foreign key (testId) references test(testId),
foreign key (RN) references student(RN),
Date datetime,
mark float
);
insert into test values
(1,'EPC'),
(2,'DWMX'),
(3,'SQL1'),
(4,'SQL2');
insert into student values
(1,'Nguyen Hong Ha',20),
(2,'Truong Ngoc Anh',30),
(3,'Tuan Minh',25),
(4,'Dan Truong',22);
insert into studentTest values
(1,1,'2006-07-17',8),
(1,2,'2006-07-18',5),
(1,3,'2006-07-19',7),
(2,1,'2006-07-17',7),
(2,2,'2006-07-18',4),
(2,3,'2006-07-19',2),
(3,1,'2006-07-17',10),
(3,3,'2006-07-19',1);

-- cau 2: Hiển thị danh sách các học viên đã tham gia thi, các môn thi được thi bởi các học viên đó, điểm thi và ngày thi giống như hình sau:
CREATE VIEW DsDiemThi AS
select S.name, T.SubTestName, ST.mark, ST.date
from studentTest ST join Test T on ST.testId = T.testId join student S on ST.RN = S.RN;
select * from dsDiemThi;

-- cau 3: Hiển thị danh sách các bạn học viên chưa thi môn nào như hình sau:
Select * from student
where not exists (select * from studentTest where student.RN = studentTest.RN);

-- cau 4: Hiển thị danh sách học viên phải thi lại, tên môn học phải thi lại và điểm thi(điểm phải thi lại là điểm nhỏ hơn 5) 
CREATE VIEW DsThiLai AS
select S.name, T.SubTestName, ST.mark, ST.date
from studentTest ST join Test T on ST.testId = T.testId join student S on ST.RN = S.RN
where ST.mark < 5;
select * from dsThiLai;

-- cau 5: Hiển thị danh sách học viên và điểm trung bình(Average) của các môn đã thi. 
-- Danh sách phải sắp xếp theo thứ tự điểm trung bình giảm dần(nếu không sắp xếp thì chỉ được ½ số điểm) như sau:
CREATE VIEW DsDiemTrungBinh AS
select dsDiemThi.name, avg(mark) as 'AvgMark'
from dsDiemThi
group by name;
select * from dsDiemTrungBinh;


-- cau 6: Hiển thị tên và điểm trung bình của học viên có điểm trung bình lớn nhất như sau:
select dsDiemTrungBinh.name, max(avgmark) as 'maxmark'
from dsDiemTrungBinh;


-- cau 7: Hiển thị điểm thi cao nhất của từng môn học. Danh sách phải được sắp xếp theo tên môn học như sau:
select dsDiemThi.subTestName, max(mark) as 'maxMark'
from dsDiemThi
group by dsDiemthi.subTestName;
-- order by  dsDiemThi.subTestName ASC;

-- Câu 8: Hiển thị danh sách tất cả các học viên và môn học mà các học viên đó đã thi nếu học viên chưa thi môn nào thì phần tên môn học để Null như sau
CREATE VIEW DsThi As
Select S.name, T.subTestName
from student S left join studentTest ST on S.RN = ST.RN
join test T on T.testID = ST.testID;
select * from DsThi;

-- Câu 9: Sửa (Update) tuổi của tất cả các học viên mỗi người lên một tuổi. 
update student set age = age + 1
where RN >0;