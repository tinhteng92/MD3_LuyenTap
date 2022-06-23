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

ALTER TABLE studentTest 
ADD PRIMARY KEY(testId, RN );

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

-- Câu 10: Thêm trường tên là Status có kiểu Varchar(10) vào bảng Student.
ALTER TABLE student add status varchar(10);

-- Câu 11: Cập nhật(Update) trường Status sao cho những học viên nhỏ hơn 30 tuổi sẽ nhận giá trị ‘Young’, 
-- trường hợp còn lại nhận giá trị ‘Old’ sau đó hiển thị toàn bộ nội dung bảng Student lên như sau:
-- SET SQL_SAFE_UPDATES = 0;

-- update student set status = 'Young'
-- where age < 30;
-- update student
-- set status = 'Old'
-- where age = 30 or age > 30;
-- SET SQL_SAFE_UPDATES = 1;-- 

update student set Status = if(age < 30, 'Young', 'Old') where RN >0;

-- Câu 12: Tạo view tên là vwStudentTestList hiển thị danh sách học viên và điểm thi, dánh sách phải sắp xếp tăng dần theo ngày thi như sau:
CREATE VIEW vwStudentTestList AS
select S.name, T.subTestName, ST.mark, ST.date
from student S join studentTest ST on S.RN = ST.RN
join test T on ST.testId = T.testId
order by S.name;  

select * from vwStudentTestList;

-- Câu 13: Tạo một trigger tên là tgSetStatus sao cho khi sửa tuổi của học viên thi trigger này sẽ tự động cập nhật status theo quy tắc sau:
-- Nếu tuổi nhỏ hơn 30 thì Status=’Young’
-- Nếu tuổi lớn hơn hoặc bằng 30 thì Status=’Old’
DELIMITER $$
CREATE TRIGGER tgSetStatus 
 before UPDATE on student
 FOR EACH ROW
BEGIN
	set new.status = if(new.age < 30, 'Young','old'); 
END;
$$

-- Câu 14: 
CREATE VIEW view1 as
Select s.Name, t.subTestName, st.mark
From Student s
Left join studentTest st on s.RN = st.RN
LEFT JOIN Test t on st.testid = t.testid;

drop procedure spViewStatus;
DELIMITER $$
CREATE procedure spViewStatus(IN nameHV varchar(50), IN nameMH varchar(50),OUT output1 varchar(50),out output2 float)
BEGIN
DECLARE diem float;
	if nameHV not in (select Name from Student) or nameMH not in(select Subtestname from test) then
		set output1='Khong tìm thấy';
	else
		SELECT Mark INTO diem FROM view1 WHERE view1.Name=nameHV and view1.Subtestname=nameMH;
            set output2=diem;
 			IF diem>=5 then
				SET output1='Đỗ';
			ELSEIF diem<5 then
				SET output1='Trượt';
			ELSE
				SET output1='Chưa thi';
			end if;
	end if;
END$$


call spViewStatus('Tuan Minh','SQL1',@a,@b);

select @a as 'trạng thái' , @b as 'Điểm thi';
