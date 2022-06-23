CREATE DATABASE `TicketFilm`;
USE TicketFilm;

CREATE TABLE tblPhong(
PhongId int,
Ten_phong varchar (50),
Trang_thai bit
);

CREATE TABLE tblGhe (
GheId int,
PhongId int,
So_ghe varchar(5)
);

CREATE TABLE tblPhim (
PhimID int,
Ten_phim varchar(100),
Loai_phim varchar(100),
Thoi_gian int
);

CREATE TABLE tblVe (
PhimID int,
GheID int,
Ngay_chieu date,
Trang_thai bit
);

ALTER TABLE tblPhong ADD Primary key (PhongId);
ALTER TABLE tblGhe ADD Primary key (GheId);
ALTER TABLE tblPhim ADD Primary key (PhimId);

ALTER TABLE tblGhe ADD foreign key (PhongId) references tblPhong(PhongId);
ALTER TABLE tblVe ADD foreign key (PhimID) references tblPhim(PhimId);
ALTER TABLE tblVe ADD foreign key (GheID) references tblGhe(GheId);

Insert into tblPhim values
(1, 'Em bé Hà Nôi', 'Tâm lý', 90),
(2, 'Nhiệm vụ bất khả thi', 'Hành động', 100),
(3, 'Dị nhân', 'Viễn tưởng', 90),
(4, 'Cuốn theo chiều gió', 'Tình cảm', 120);

Insert into tblPhong values
(1, 'Phòng chiếu 1',1 ),
(2, 'Phòng chiếu 2', 1),
(3, 'Phòng chiếu 3', 0);

Insert into tblGhe  values
(1, 1, 'A3'),
(2, 1, 'B5'),
(3, 2, 'A7'),
(4, 2, 'D1'),
(5, 3, 'T2');

Insert into tblVe  values
(1, 1, '2008/10/20', 'Đã bán'),
(1, 3, '2008/11/20', 'Đã bán'),
(1, 4, '2008/12/23', 'Đã bán'),
(2, 1, '2009/02/14', 'Đã bán'),
(3, 1, '2009/02/14', 'Đã bán'),
(2, 5, '2009/03/08', 'Chưa bán'),
(2, 3, '2009/03/08', 'Chưa bán');


-- Câu 2: Hiển thị danh sách các phim (chú ý: danh sách phải được sắp xếp theo trường Thoi_gian)
Select * from tblPhim
order by thoi_gian;

-- Câu 3: Hiển thị Ten_phim có thời gian chiếu dài nhất
Select * from tblPhim
order by thoi_gian desc
limit 1;

-- Câu 4: Hiển thị Ten_Phim có thời gian chiếu ngắn nhất
Select * from tblPhim
order by thoi_gian
limit 1;

-- Câu 5: Hiển thị danh sách So_Ghe mà bắt đầu bằng chữ ‘A’
Select * from tblGhe
where so_ghe like 'A%';

-- Câu 6: Sửa cột Trang_thai của bảng tblPhong sang kiểu nvarchar(25)
ALTER TABLE tblPhong
  MODIFY COLUMN Trang_thai nvarchar(25);
  
  -- Câu 7: Cập nhật giá trị cột Trang_thai của bảng tblPhong theo các luật sau
  update tblPhong set Trang_thai = if(Trang_thai=0, 'Đang sửa', (if(Trang_thai = 1, 'Đang sử dụng', 'Unknow'))
)where phongid >0;

-- Câu 8: Hiển thị danh sách tên phim mà  có độ dài >15 và < 25 ký tự
select * from tblPhim
where (select length(ten_phim)) between 15 and 25;

-- Câu 9: Hiển thị Ten_Phong và Trang_Thai trong bảng tblPhong  trong 1 cột với tiêu đề ‘Trạng thái phòng chiếu’
SELECT CONCAT(Ten_Phong,' ', Trang_Thai) as 'Trạng thái phòng chiếu'
from tblPhong;

-- Câu 10: Tạo bảng mới có tên tblRank với các cột sau: STT(thứ hạng sắp xếp theo Ten_Phim), TenPhim, Thoi_gian
Create Table tblRank (
STT int primary key auto_increment not null,
TenPhim varchar(100),
Thoi_gian int
);

insert into tblRank(TenPhim, thoi_gian)
select tblPhim.ten_phim, tblPhim.thoi_gian from tblPhim
order by ten_phim;

-- Câu 11
ALTER TABLE tblPhim 
ADD Mo_ta nvarchar(255) not null ;

UPDATE tblphim 
SET Mo_ta=concat('Đây là bộ phim thể loại ',loai_phim)
WHERE phimId > 0;

UPDATE tblphim 
SET Mo_ta=replace(Mo_ta,'bộ phim','film')
WHERE phimId > 0;

-- Câu 12: Xóa tất cả các khóa ngoại trong các bảng trên.	
ALTER TABLE tblGhe 
DROP CONSTRAINT PhongId;

ALTER TABLE tblVe
DROP CONSTRAINT PhimID,
DROP CONSTRAINT GheID;

-- Câu 13: Xóa dữ liệu ở bảng tblGhe
DELETE from tblGhe;

-- Câu 14: Hiển thị ngày giờ hiện tại và ngày giờ hiện tại cộng thêm 5000 phút
SELECT date_add(now(),INTERVAL 5000 MINUTE) AS 'Thoi Gian Hien tai';