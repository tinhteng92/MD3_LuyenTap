CREATE DATABASE `QuanLyCuaHang`;
use quanLyCuaHang;
-- KHACHHANG (MAKH, HOTEN, DCHI, SODT, NGSINH, DOANHSO, NGDK)
CREATE TABLE KhachHang (
MAKH int(5) primary key auto_increment,
HoTen varchar(50) NOT NULL,
DChi varchar (255),
SODT int NOT NULL,
NGSinh date,
DoanhSo float default 0,
NGDK date );

-- NHANVIEN (MANV,HOTEN, NGVL, SDT)
CREATE TABLE NhanVien (
MANV int(5) primary key auto_increment,
HoTen varchar(50) NOT NULL,
NGVL date NOT NULL, 
SDT int NOT NULL );

-- SANPHAM (MASP,TENSP, DVT, NUOCSX, GIA)
CREATE TABLE SanPham (
MASP int primary key auto_increment,
TENSP varchar(50) NOT NULL,
DVT varchar(25),
NUOCSX varchar(50),
Gia float );

-- HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA)
CREATE TABLE HoaDon (
SoHD int primary key auto_increment,
NGHD date,
MaKH int,
MANV int,
TrIGIA float default 0,
foreign key(MAKH) references KHACHHANG(MAKH),
foreign key(MANV) references NHANVIEN(MANV) );

-- CTHD (SOHD,MASP,SL) hóa đơn chi tiết.
CREATE TABLE CTHD (
SOHD int,
MASP int,
SL int,
primary key(SOHD, MASP),
foreign key(SOHD) references HOADON(SOHD),
foreign key(MASP) references SANPHAM(MASP) );



INSERT INTO KHACHHANG (HOTEN, DCHI, SODT, NGSINH, NGDK) VALUES 
('Nguyen Van Thanh', 'HN', 0981113333, '1992-04-4', '2021-03-01'),
('Tran Trung Dung', 'HN', 0981112222, '1990-05-23', '2021-03-02'),
('NGuyen Thi Hoa', 'ND', 0972334778, '1988-02-09', '2021-03-05'),
('Le Manh Hung', 'BG', 0962234777, '1985-11-09', '2021-04-21'),
('Tran Ngoc Anh', 'QN', 0913424289, '1993-10-08', '2021-06-18');

INSERT INTO NHANVIEN (HOTEN, NGVL, SDT) VALUES 
('Tran Duc Chinh', '2018-09-10', 0982113113),
('Le Thu Trang', '2019-06-11', 0968221221),
('Tran Trung Duc', '2019-10-10', 0919234234);

INSERT INTO SANPHAM (TENSP, DVT, NUOCSX, GIA) VALUES
('Bat', 'chiếc', 'VietNam', 2000),
('Thia', 'chiếc', 'VietNam', 1000),
('Dĩa', 'chiếc', 'VietNam', 500),
('Cốc', 'chiếc', 'VietNam', 4000),
('Đĩa', 'chiếc', 'TrungQuoc', 1000),
('Chổi', 'chiếc', 'TrungQuoc', 2000),
('Gương', 'chiếc', 'TrungQuoc', 9000),
('Quạt', 'chiếc', 'TrungQuoc', 12000),
('Dầu Gội', 'bộ', 'ThaiLan', 10000),
('Sữa Tắm', 'bộ', 'ThaiLan', 8000),
('Kem Đánh răng', 'tuýp', 'ThaiLan', 5000);

INSERT INTO HOADON (NGHD, MAKH, MANV) values
('2022-02-03', 2, 1),
('2022-03-04', 1, 2),
('2022-03-08', 3, 2),
('2022-03-09', 3, 3),
('2022-03-09', 4, 1),
('2022-03-09', 5, 1);


INSERT INTO CTHD (SOHD,MASP,SL) VALUES
(1, 1, 2),(1, 2, 1),(1, 4, 1),(1,3 , 1), (1, 5, 1),
(2, 8, 1), (2, 2, 1), (2, 11, 1), (2, 4, 1), 
(3, 3, 1), (3, 6, 1), (3, 7, 1), 
(4, 9, 1), (4, 10, 1), (4, 3, 1), 
(5, 9, 1), (5, 10, 1),
(6, 5, 1), (6, 1, 1), (6, 7, 1);

delete from CTHD;

DELIMITER $$
CREATE TRIGGER tgSetDoanhSo
 after update on HoaDon
 for each row
 BEGIN
	update KhachHang 
    set DoanhSo = DoanhSo + (select TriGia from HoaDon where SOHD = new.SOHD);
End;
$$

DELIMITER $$
CREATE TRIGGER tgDeleteDoanhSo
 after update on HoaDon
 for each row
 BEGIN
	update KhachHang 
    set DoanhSo = DoanhSo - (select TriGia from HoaDon where SOHD = old.SOHD);
End;
$$

DELIMITER $$
CREATE TRIGGER tgSetTriGia
 after insert on CTHD
 for each row
 BEGIN
	update HOADON 
    set TRIGIA = TRIGIA + (new.SL * (select Gia from SanPham where MASP = new.MASP)) where SOHD = new.SOHD;
End;
$$

drop trigger tgSetTriGia;

DELIMITER $$
CREATE TRIGGER tgDeleteTriGia
 after delete on CTHD
 for each row
 BEGIN
	update HoaDon 
    set TRIGIA = TRIGIA - (old.SL * (select Gia from SANPHAM where MASP = old.MASP)) where SOHD = old.SOHD;
End;
$$
drop trigger tgDeleteTriGia;


