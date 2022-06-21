CREATE DATABASE `QuanLyOTo`;
use quanlyoto;

CREATE TABLE NhaCungCap (
MaNhaCC int primary key,
TenNhaCC varchar(50),
DiaChi varchar(50),
SoDT int unique,
MaSoThue int unique);

CREATE TABLE LoaiDichVu (
MaLoaiDV int primary key,
TenLoaiDv varchar(100) );

CREATE TABLE MucPhi (
MaMP int primary key,
DonGia int,
Mota varchar(255) );

CREATE TABLE DongXe (
DongXe varchar(25) primary key,
HangXe varchar(25),
SoChoNgoi int );

CREATE TABLE DangKyCungCap (
MaDKCC int primary key,
MaNhaCC int,
MaLoaiDV int,
DongXe varchar(25),
MaMP int,
foreign key (MaNhaCC) references NhaCungCap(MaNhaCC),
foreign key (MaLoaiDv) references LoaiDichVu(MaLoaiDV),
foreign key (DongXe) references DongXe(DongXe),
foreign key (MaMP) references MucPhi(MaMP) 
);

CREATE TABLE DangKyDongXe (
MaNhaCC int,
DongXe varchar(25),
foreign key (MaNhaCC) references NhaCungCap(MaNhaCC),
foreign key (DongXe) references DongXe(DongXe)
);


-- Câu 3: Liệt kê những dòng xe có số chỗ ngồi trên 5 chỗ
Select * from dongxe
where soChoNgoi > 5;

-- Câu 4: Liệt kê thông tin của các nhà cung cấp đã từng đăng ký cung cấp những dòng xe
-- thuộc hãng xe “Toyota” với mức phí có đơn giá là 15.000 VNĐ/km hoặc những dòng xe
-- thuộc hãng xe “KIA” với mức phí có đơn giá là 20.000 VNĐ/km

Select dkcc.madkcc, ncc.maNhaCC, ncc.TenNhaCC, dx.dongxe, dx.hangxe
from dangkycungcap dkcc join nhaCungCap ncc on dkcc.maNhacc = ncc.maNhacc
join dongxe dx on dkcc.dongxe = dx.dongxe
where dx.hangxe = 'Toyota' or dx.hangxe = 'Kia';

-- Câu 5: Liệt kê thông tin toàn bộ nhà cung cấp được sắp xếp tăng dần theo tên nhà cung
-- cấp và giảm dần theo mã số thuế
Select * from nhacungcap
order by tenNhaCC asc;

Select * from nhacungcap
order by maSoThue desc;

-- Câu 6: Đếm số lần đăng ký cung cấp phương tiện tương ứng cho từng nhà cung cấp với
-- yêu cầu chỉ đếm cho những nhà cung cấp thực hiện đăng ký cung cấp có ngày bắt đầu
-- cung cấp là “2022-05-03”
Select dkcc.madkcc, ncc.tenNhaCC, dkcc.ngaybatdauCungCap, count(dkcc.madkcc) as 'SoLan'
from dangkycungcap dkcc join nhacungcap ncc on dkcc.maNhaCC = ncc.maNhacc
where dkcc.ngaybatdauCungCap = '2022-05-03'
group by ncc.tenNhaCC;

-- Câu 7: Liệt kê tên của toàn bộ các hãng xe có trong cơ sở dữ liệu với yêu cầu mỗi hãng xe
-- chỉ được liệt kê một lần
Select hangxe from dongXe
group by hangxe;

-- Câu 8: Liệt kê MaDKCC, MaNhaCC, TenNhaCC, DiaChi, MaSoThue, TenLoaiDV, DonGia,
-- HangXe, NgayBatDauCC, NgayKetThucCC của tất cả các lần đăng ký cung cấp phương
-- tiện với yêu cầu những nhà cung cấp nào chưa từng thực hiện đăng ký cung cấp phương
-- tiện thì cũng liệt kê thông tin những nhà cung cấp đó ra
select dk.maDKCC, ncc.maNhaCC,ncc.tenNhaCC,ncc.diaChi,ncc.maSoThue,ldv.TenLoaiDv,mp.donGia,
dx.hangXe,dk.ngayBatDauCungCap,dk.ngayKetThucCungCap
from nhaCungCap ncc
left join dangKyCungCap dk on ncc.maNhaCC = dk.maNhaCC
left join dongXe dx on dk.dongXe = dx.dongXe
left join mucPhi mp on mp.maMP = dk.maMP
left join loaidichvu ldv on ldv.MaLoaiDV = dk.MaLoaiDV;

-- Câu 9: Câu 9: Liệt kê thông tin của các nhà cung cấp đã từng đăng ký cung cấp phương tiện
-- thuộc dòng xe “Hiace” hoặc từng đăng ký cung cấp phương tiện thuộc dòng xe “Cerato”
select ncc.*, dx.hangXe, dx.dongXe from nhaCungCap ncc
join dangKyCungCap dk on ncc.maNhaCC = dk.maNhaCC
join dongXe dx on dk.dongXe = dx.dongXe
where dx.dongXe = 'Hiace' or dx.dongXe = 'Cerato';

-- Câu 10: Liệt kê thông tin của các nhà cung cấp chưa từng thực hiện đăng ký cung cấp
-- phương tiện lần nào cả.
select ncc.*, dk.maDKCC from nhaCungCap ncc
left join dangKyCungCap dk on ncc.maNhaCC = dk.maNhaCC
where  dk.maDKCC is null;
