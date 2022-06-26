-- Câu 1: Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2022.
SELECT sp.MaSP, sp.tenSP, COUNT(SL)
  FROM SanPham SP join CTHD on sp.MaSP = cthd.MaSP
  WHERE cthd.SL >0
  GROUP BY MaSP;
  
  -- Câu 2: Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu ?
SELECT MIN(TriGia) as 'Hóa đơn thấp nhất', Max(TriGia) as 'Hóa đơn cao nhất'
FROM HoaDon;

-- Câu 3: Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2022 là bao nhiêu?
SELECT AVG(TRiGia) as 'Trị giá HD trung bình'
FROM HoaDon
WHERE year(NGHD) = 2022;

-- Câu 4: Tính doanh thu bán hàng trong năm 2022.
Select Sum(TriGia) as'Doanh thu 2022'
From HoaDon
WHERE year(NGHD) = 2022;

-- Câu 5: Tìm số hóa đơn có trị giá cao nhất trong năm 2022.
SELECT SoHD, Max(TriGia) as 'Hóa đơn cao nhất'
FROM HoaDon
WHERE TriGia = (SELECT MAX(TriGia) FROM HoaDon);

-- Câu 6: Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2022.
SELECT KH.hoTen, Max(TriGia) as 'Hóa đơn cao nhất'
FROM khachHang KH join HoaDon HD on KH.MaKH = HD.MaKH
WHERE TriGia = (SELECT MAX(TriGia) FROM HoaDon) and year(NGHD) = 2022;

-- Câu 7: In ra danh sách 3 khách hàng (MAKH, MAKH) có doanh số cao nhất.
SELECT MAKH, MAKH, DoanhSo
FROM KhachHang 
Order by DoanhSo desc limit 3;

-- Câu 9: In ra danh sách các sản phẩm (MASP, TENSP) 
-- do “Thai Lan” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của tất cả các sản phẩm).
CREATE VIEW SPGiaCao As
SELECT MASP, TENSP, Gia, NuocSX
FROM SanPham 
Order by Gia desc 
limit 3;

select * from SPGiaCao
Where NuocSx = 'ThaiLan';

drop view SPGiaCao;

-- Câu 10: In ra danh sách các sản phẩm (MASP, TENSP) 
-- do “Trung Quoc” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất).
SELECT MASP, TENSP, Gia
FROM SanPham 
Where NuocSx = 'TrungQuoc'
Order by Gia desc limit 3;

-- Câu 11: * In ra danh sách 3 khách hàng có doanh số cao nhất (sắp xếp theo kiểu xếp hạng).
SELECT RANK() OVER (ORDER BY DoanhSo) AS 'Xếp hạng theo doanh số',
MAKH, MAKH, DoanhSo
FROM KhachHang
limit 3;

-- Câu 12: Tính tổng số sản phẩm do “Trung Quoc” sản xuất.
Select nuocSX, count(tenSP) as 'SL sản phẩm '
from sanpham
Where NuocSx = 'TrungQuoc';

-- Câu 13: Tính tổng số sản phẩm của từng nước sản xuất.
Select nuocSX, count(tenSP) as 'SL sản phẩm '
from sanpham
group by NuocSX
;

-- Câu 14: Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm.
SELECT NuocSX, MIN(Gia) as 'Giá thấp nhất', Max(Gia) as 'Giá cao nhất', AVG(Gia) as 'Giá TB'
FROM SanPham
group by NuocSX;

-- Câu 15: Tính doanh thu bán hàng mỗi ngày.
Select NGHD, Sum(TriGia) as'Doanh thu mỗi ngày'
From HoaDon
group by NGHD;

-- Câu 16: Tính tổng số lượng của từng sản phẩm bán ra trong tháng 9/2022.
-- chưa ra kq

SELECT MASP, COUNT(DISTINCT MASP) AS TONGSO
FROM SANPHAM
WHERE MASP IN(SELECT MASP
FROM CTHD C INNER JOIN HOADON H
ON C.SOHD = H.SOHD
WHERE MONTH(NGHD) = 09 AND YEAR(NGHD) = 2022)
GROUP BY MASP;

-- Câu 17: Tính doanh thu bán hàng của từng tháng trong năm 2022.
SELECT MONTH(NGHD) AS THANG, SUM(TRIGIA) AS DOANHTHU
FROM HOADON
WHERE YEAR(NGHD) = 2022
GROUP BY MONTH(NGHD);

-- Câu 18: Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.
SELECT SOHD, count(MaSP) as 'SL SP'
FROM CTHD group by soHD having count(MaSP) >= 4;

-- Câu 19: Tìm hóa đơn có mua 3 sản phẩm do “Viet Nam” sản xuất (3 sản phẩm khác nhau).
SELECT cthd.SOHD, sp.nuocSX, count(cthd.MaSP) as 'SL SP'
FROM SanPham sp join cthd on cthd.masp = sp.masp
where sp.nuocSX = 'VietNam' group by cthd.soHD
having count(cthd.MaSP) >= 3;

-- Câu 20: Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất.
SELECT MAKH, HOTEN
FROM KHACHHANG
WHERE MAKH = (SELECT MAKH
FROM HOADON
GROUP BY MAKH
ORDER BY COUNT(DISTINCT SOHD) DESC limit 1)

-- Câu 21: Tháng mấy trong năm 2006, doanh số bán hàng cao nhất ?

SELECT MONTH(NGHD) AS THANG_DOANHSO_MAX
FROM HOADON
WHERE YEAR(NGHD) = 2022
GROUP BY MONTH(NGHD)
ORDER BY SUM(TRIGIA) DESC limit 1;

-- Câu 22: Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006.
SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP = (SELECT MASP
FROM CTHD
GROUP BY MASP
ORDER BY SUM(SL) asc limit 1)

-- Câu 23: *Mỗi nước sản xuất, tìm sản phẩm (MASP,TENSP) có giá bán cao nhất.

SELECT B.NUOCSX, MASP, TENSP
FROM (SELECT NUOCSX, MAX(GIA) AS MAX
FROM SANPHAM
GROUP BY NUOCSX) AS B LEFT JOIN SANPHAM S 
ON S.GIA = B.MAX 
WHERE B.NUOCSX = S.NUOCSX;

-- Câu 24: Tìm nước sản xuất sản xuất ít nhất 3 sản phẩm có giá bán khác nhau.

-- Câu 25: *Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều nhất.

