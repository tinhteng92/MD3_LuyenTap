CREATE DATABASE `QUANLYSINHVIEN2`;
USE QuanLySinhVien2;

CREATE TABLE KHOA (
MaKhoa int primary key,
TenKhoa varchar(50)
);

CREATE TABLE LOP (
MaLop int primary key,
TenLop varchar (50),
MaKhoa int,
foreign key (MaKhoa) references Khoa(MaKhoa)
);

CREATE TABLE MonHoc (
MaMH int primary key,
TenMH varchar(50),
SoTiet int);

CREATE TABLE KetQua (
MaDT int primary key,
DiemThi float,
MaSV int,
MaMH int,
foreign key (MaSV) references SinhVien(MaSV),
foreign key (MaMH) references MonHoc(MaMH)
);

CREATE TABLE SinhVien (
MaSv int primary key,
HoTen varchar(50),
NgaySinh Date,
HocBong int,
GioiTinh varchar(25),
MaLop int,
foreign key(MaLop) references Lop(MaLop)
);

-- Câu 5: Lập danh sách sinh viên có họ ‘Trần’
Select * from Sinhvien 
where HoTen like 'Trần%';

-- Câu 6: Lập danh sách sinh viên nữ có học bổng
Select * from Sinhvien
where hocbong = 1 and gioitinh = 'Nữ';

-- Câu 7: Lập danh sách sinh viên nữ hoặc danh sách sinh viên có học bổng
Select * from Sinhvien
where hocbong = 1 or gioitinh = 'Nữ';

-- Câu 8:  Lập danh sách sinh viên có năm sinh từ 1992 đến 1997. Danh sách cần các thuộc tính của quan hệ SinhVien
Select * from Sinhvien
where year(ngaysinh) between 1992 and 1997;

-- Câu 9: Liệt kê danh sách sinh viên được sắp xếp giam dần theo MaSV
Select * from SinhVien 
order by MaSv desc;

-- Cau 10: Liệt kê danh sách sinh viên được sắp xếp giảm dần theo HocBong
Select * from Sinhvien
order by HocBong desc;

-- Cau 12: Lập danh sách sinh viên có học bổng của khoa CNTT
Select Sinhvien.*, lop.maLop, khoa.tenKhoa
from sinhvien join lop on sinhvien.masv = lop.malop
join khoa on lop.malop = khoa.makhoa
where sinhvien.hocBong = 1;

-- Cau 14: Cho biết số sinh viên của mỗi lớp
Select malop, count(maSv)
from sinhvien 
group by malop;

-- Cau 15: Cho biết số lượng sinh viên của mỗi khoa
Select khoa.tenkhoa, lop.malop, lop.tenlop, count(sinhvien.maSv)
from sinhvien join lop on sinhvien.malop= lop.malop
join khoa on lop.makhoa = khoa.makhoa
group by malop;

-- Cau 16: Cho biết số lượng sinh viên nữ của mỗi khoa.
Select sinhvien.*, lop.tenlop, khoa.tenkhoa
from sinhvien join lop on sinhvien.malop= lop.malop
join khoa on lop.makhoa = khoa.makhoa
where sinhvien.gioiTinh = 'Nữ';

-- Câu 17: Cho biết tổng tiền học bổng của mỗi lớp
Select lop.malop, lop.tenlop, sum(sinhvien.hocbong* 500)
from sinhvien join lop on sinhvien.malop = lop.malop
where sinhvien.hocbong = 1
group by lop.malop;

-- Câu 18: Cho biết tổng số tiền học bổng của mỗi khoa
Select khoa.tenkhoa, lop.malop, lop.tenlop, sum(sinhvien.hocbong* 500)
from sinhvien join lop on sinhvien.malop = lop.malop
join khoa on lop.makhoa = khoa.makhoa
where sinhvien.hocbong = 1
group by lop.malop;

-- Câu 19: Lập danh sánh những khoa có nhiều hơn 100 sinh viên. Danh sách cần: MaKhoa, TenKhoa, Soluong
Select khoa.makhoa, khoa.tenkhoa, count(sinhvien.maSv) as 'Soluong'
from sinhvien join lop on sinhvien.malop = lop.malop
join khoa on lop.makhoa = khoa.makhoa
group by khoa.makhoa, khoa.tenkhoa
having Soluong > 100;

-- Câu 20: Lập danh sánh những khoa có nhiều hơn 50 sinh viên nữ. Danh sách cần: MaKhoa, TenKhoa, Soluong
Select khoa.makhoa, khoa.tenkhoa, count(sinhvien.masv) as 'Soluong'
from sinhvien join lop on sinhvien.malop = lop.malop
join khoa on lop.makhoa = khoa.makhoa
where sinhvien.gioiTinh = 'Nữ'
group by khoa.makhoa, khoa.tenkhoa
having Soluong > 50;

-- Câu 23: Lập danh sách sinh viên có điểm thi môn toán cao nhất
Select sinhvien.masv, sinhvien.hoTen, ketqua.diemThi
from ketQua join sinhVien on sinhVien.maSV = ketQua.maSV
where ketqua.diemThi >= all (select diemthi from ketqua);

