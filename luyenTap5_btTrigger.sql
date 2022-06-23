CREATE DATABASE `QuanLySP`;
use quanlySP;

Create table Product (
productId int primary key,
nameP varchar(50),
priceP float,
status bit
);

Create table OrderP (
orderId int primary key,
Date date,
totalMoney varchar(50)
);

Create table OrderDetail (
id int primary key,
orderId int,
productId int,
foreign key (orderId) references OrderP(orderId),
foreign key (productId) references Product(productId),
amount int
);
INSERT INTO `quanlysp`.`product` (`productId`, `nameP`, `priceP`, `status`) VALUES (1, 'Ti Vi', 300, 1);
INSERT INTO `quanlysp`.`product` (`productId`, `nameP`, `priceP`, `status`) VALUES (2, 'Tủ lạnh', 250, 1);
INSERT INTO `quanlysp`.`product` (`productId`, `nameP`, `priceP`, `status`) VALUES (3, 'Máy Giặt ', 200, 1);orderp

DELIMITER $$
CREATE TRIGGER tgSetStatus
 after insert on orderDetail
 for each row
 BEGIN
	update Orderp 
    set totalMoney = totalMoney + (new.amount * (select priceP from product where productId = new.productId)) where orderId = new.orderId;
End;
$$

drop trigger tgDeleteOrder;

DELIMITER $$
CREATE TRIGGER tgDeleteOrder
 after delete on orderDetail
 for each row
 BEGIN
	update Orderp 
    set totalMoney = totalMoney - (old.amount * (select priceP from product where productId = old.productId)) where orderId = old.orderId;
End;
$$

