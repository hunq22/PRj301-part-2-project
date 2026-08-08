USE SportShop;

DROP TABLE IF EXISTS ORDER_DETAILS;
DROP TABLE IF EXISTS PAYMENT;
DROP TABLE IF EXISTS [ORDER];
DROP TABLE IF EXISTS CART_ITEMS;
DROP TABLE IF EXISTS CART;
DROP TABLE IF EXISTS PRODUCTS;
DROP TABLE IF EXISTS CATEGORIES;
DROP TABLE IF EXISTS [USER];

CREATE TABLE [USER] (
    User_id INT IDENTITY(1,1) PRIMARY KEY,
    User_name NVARCHAR(100) NOT NULL,
    User_full_name NVARCHAR(150),
    Email NVARCHAR(150) UNIQUE NOT NULL,
    Password NVARCHAR(255) NOT NULL,
    Phone_number NVARCHAR(20),
    Gender NVARCHAR(10) CHECK (Gender IN ('Male', 'Female', 'Other')),
    DateOfBirth DATE,
    Role NVARCHAR(20) CHECK (Role IN ('Customer', 'Admin')) DEFAULT 'Customer',
    Address NVARCHAR(255),
    User_avatar NVARCHAR(255)
);

CREATE TABLE CATEGORIES (
    Category_id INT IDENTITY(1,1) PRIMARY KEY,
    Category_name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX)
);

CREATE TABLE PRODUCTS (
    Product_id INT IDENTITY(1,1) PRIMARY KEY,
    Category_id INT NOT NULL,
    Product_name NVARCHAR(150) NOT NULL,
    Description NVARCHAR(MAX),
    Image_url NVARCHAR(255),
    Price DECIMAL(10,2) NOT NULL DEFAULT 0,
    Quantity INT DEFAULT 0,
    Color NVARCHAR(50),
    Size NVARCHAR(20),
    Gender NVARCHAR(10) CHECK (Gender IN ('Male','Female','Unisex')) DEFAULT 'Unisex',
    Trending BIT DEFAULT 0,
    FOREIGN KEY (Category_id) REFERENCES CATEGORIES(Category_id) ON DELETE CASCADE
);

CREATE TABLE CART (
    Cart_id INT IDENTITY(1,1) PRIMARY KEY,
    User_id INT NOT NULL,
    FOREIGN KEY (User_id) REFERENCES [USER](User_id) ON DELETE CASCADE
);

CREATE TABLE CART_ITEMS (
    Cart_item_id INT IDENTITY(1,1) PRIMARY KEY,
    Cart_id INT NOT NULL,
    Product_id INT NOT NULL,
    Quantity INT DEFAULT 1,
    FOREIGN KEY (Cart_id) REFERENCES CART(Cart_id) ON DELETE CASCADE,
    FOREIGN KEY (Product_id) REFERENCES PRODUCTS(Product_id) ON DELETE CASCADE
);

CREATE TABLE [ORDER] (
    Order_id INT IDENTITY(1,1) PRIMARY KEY,
    Cart_id INT NULL,
    User_id INT NOT NULL,
    Order_date DATETIME DEFAULT GETDATE(),
    Address NVARCHAR(255),
    Total_price DECIMAL(12,2) DEFAULT 0,
    Status NVARCHAR(20) CHECK (Status IN ('pending','completed','shipping','cancelled')) DEFAULT 'pending',
    Tracking_number NVARCHAR(100),
    FOREIGN KEY (User_id) REFERENCES [USER](User_id) ON DELETE NO ACTION,
    FOREIGN KEY (Cart_id) REFERENCES CART(Cart_id) ON DELETE SET NULL
);

CREATE TABLE PAYMENT (
    Payment_id INT PRIMARY KEY IDENTITY(1,1),
    Order_id INT NOT NULL,
    Method NVARCHAR(50),
    Status NVARCHAR(50),
    Amount DECIMAL(10,2),
    FOREIGN KEY (Order_id) REFERENCES [ORDER](Order_id) ON DELETE CASCADE
);

CREATE TABLE ORDER_DETAILS (
    Order_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    Order_id INT NOT NULL,
    Product_id INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 1,
    Unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (Order_id) REFERENCES [ORDER](Order_id) ON DELETE CASCADE,
    FOREIGN KEY (Product_id) REFERENCES PRODUCTS(Product_id) ON DELETE CASCADE
);

INSERT INTO [USER] (User_name, User_full_name, Email, Password, Phone_number, Gender, DateOfBirth, Role, Address, User_avatar)
VALUES
('john_doe', N'John Doe', 'john@example.com', '123456', '0123456789', 'Male', '1990-01-15', 'Customer', N'123 Le Loi, Hanoi', NULL),
('jane_smith', N'Jane Smith', 'jane@example.com', 'abcdef', '0987654321', 'Female', '1995-06-20', 'Customer', N'456 Tran Phu, Da Nang', NULL),
('admin01', N'Nguyen Admin', 'admin@sportshop.com', 'admin123', '0909090909', 'Male', '1988-10-05', 'Admin', N'12 Hai Ba Trung, Hanoi', NULL),
('maria', N'Maria Nguyen', 'maria@gmail.com', 'pass001', '0911222333', 'Female', '2000-02-10', 'Customer', N'23 Nguyen Hue, Ho Chi Minh City', NULL),
('hungtran', N'Hung Tran', 'hungtran@gmail.com', 'hung123', '0933444555', 'Male', '1998-11-22', 'Customer', N'8 Nguyen Van Cu, Can Tho', NULL),
('anhdao', N'Dao Thi Anh', 'anhdao@gmail.com', 'dao123', '0977666555', 'Female', '2002-07-09', 'Customer', N'5 Phan Chu Trinh, Hue', NULL),
('minhvu', N'Minh Vu', 'minhvu@yahoo.com', 'vu123', '0911888777', 'Male', '1999-09-09', 'Customer', N'9 Vo Van Kiet, Da Nang', NULL),
('linhpham', N'My Linh Pham', 'linhpham@gmail.com', 'linh001', '0905123123', 'Female', '2001-12-12', 'Customer', N'77 Nguyen Thi Minh Khai, Ho Chi Minh City', NULL),
('davidle', N'David Le', 'davidle@gmail.com', 'dav123', '0919119119', 'Male', '1997-03-03', 'Customer', N'12 Vo Thi Sau, Hanoi', NULL),
('thuyle', N'Thuy Le', 'thuyle@gmail.com', 'thuy123', '0988988999', 'Female', '2003-05-30', 'Customer', N'88 Bach Dang, Da Nang', NULL);

INSERT INTO CATEGORIES (Category_name, Description)
VALUES
(N'Football', N'Soccer shoes, clothes, and accessories for football players'),
(N'Badminton', N'Rackets, shoes, and sportswear for badminton training and matches'),
(N'Golf', N'Golf clubs, shoes, and accessories for golf players');

INSERT INTO PRODUCTS (Category_id, Product_name, Description, Image_url, Price, Quantity, Color, Size, Gender, Trending)
VALUES
(1, N'Adidas Predator Elite', N'Professional football boots with firm ground studs', N'https://images.pexels.com/photos/1407354/pexels-photo-1407354.jpeg', 2600000, 20, N'White', N'42', 'Male', 1),
(1, N'Nike Mercurial Vapor 15', N'Lightweight football shoes designed for speed and control', N'https://images.pexels.com/photos/18368115/pexels-photo-18368115.jpeg', 2800000, 18, N'Red', N'41', 'Unisex', 1),
(1, N'Football Training Jersey', N'Breathable and quick-dry football shirt for daily training', N'https://images.pexels.com/photos/27271619/pexels-photo-27271619.jpeg', 450000, 30, N'Blue', N'L', 'Male', 0),
(1, N'Puma Goalkeeper Gloves', N'Professional goalkeeper gloves with firm grip and durability', N'https://i.pinimg.com/1200x/a4/29/f2/a429f23f5a2400c4d9136cfb69faeb1a.jpg', 600000, 25, N'Black', N'M', 'Unisex', 0),
(2, N'Yonex Astrox 100ZZ', N'Premium graphite badminton racket with powerful smashes', N'https://i.pinimg.com/736x/0a/46/98/0a4698476a9fd3828acd67686d13439b.jpg', 3200000, 10, N'Black', NULL, 'Unisex', 1),
(2, N'Li-Ning Badminton Shoes', N'Comfortable non-slip shoes for badminton court performance', N'https://i.pinimg.com/736x/5b/8d/78/5b8d785c495ddcaf74792aa979b0fa49.jpg', 1900000, 25, N'White', N'42', 'Unisex', 0),
(2, N'Badminton Grip Tape', N'Anti-slip handle grip tape for professional rackets', N'https://i.pinimg.com/1200x/35/f5/59/35f559b3158585723c8a9f11db309209.jpg', 120000, 50, N'Yellow', NULL, 'Unisex', 0),
(3, N'Titleist Pro V1 Golf Balls', N'High-performance golf balls for distance and spin control', N'https://i.pinimg.com/1200x/ee/0f/29/ee0f29c4a170622ab1432fa0761a150d.jpg', 1500000, 40, N'White', NULL, 'Unisex', 1),
(3, N'Callaway Golf Glove', N'Soft leather glove ensuring excellent grip and comfort', N'https://i.pinimg.com/1200x/cb/ef/50/cbef508513ade0f1a6b4c253dc96864b.jpg', 350000, 35, N'White', N'M', 'Male', 0),
(3, N'Golf Polo Shirt', N'Slim-fit breathable polo shirt for golf players', N'https://i.pinimg.com/736x/22/2b/c6/222bc6fc94431065c30c7d8d2418c49c.jpg', 700000, 28, N'Green', N'L', 'Male', 0);

INSERT INTO CART (User_id)
VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10);

INSERT INTO CART_ITEMS (Cart_id, Product_id, Quantity)
VALUES
(1,1,1),
(1,2,2),
(2,3,1),
(3,4,3),
(4,5,2),
(5,6,1),
(6,7,1),
(7,8,2),
(8,9,1),
(9,10,1);

INSERT INTO [ORDER] (Cart_id, User_id, Order_date, Address, Total_price, Status, Tracking_number)
VALUES
(1,1,'2024-10-10', N'123 Le Loi, Ha Noi', 5000000, 'pending', 'VN001'),
(2,2,'2024-10-12', N'456 Tran Phu, Da Nang', 3000000, 'pending', 'VN002'),
(3,3,'2024-10-15', N'12 Hai Ba Trung, Ha Noi', 800000, 'shipping', 'VN003'),
(4,4,'2024-10-18', N'23 Nguyen Hue, HCM', 1400000, 'completed', 'VN004'),
(5,5,'2024-10-21', N'8 Nguyen Van Cu, Can Tho', 700000, 'pending', 'VN005'),
(6,6,'2024-10-24', N'5 Phan Chu Trinh, Hue', 3200000, 'shipping', 'VN006'),
(7,7,'2024-10-27', N'9 Vo Van Kiet, Da Nang', 600000, 'completed', 'VN007'),
(8,8,'2024-11-02', N'77 Nguyen Thi Minh Khai, HCM', 250000, 'shipping', 'VN008'),
(9,9,'2024-11-05', N'12 Vo Thi Sau, Ha Noi', 550000, 'pending', 'VN009'),
(10,10,'2024-11-10', N'88 Bach Dang, Da Nang', 450000, 'cancelled', 'VN010');

INSERT INTO PAYMENT (Order_id, Method, Status, Amount)
VALUES
(1, N'Credit Card', N'Completed', 5000000),
(2, N'Momo', N'Completed', 3000000),
(3, N'Cash', N'Completed', 800000),
(4, N'Bank Transfer', N'Completed', 1400000),
(5, N'Momo', N'Pending', 700000),
(6, N'Credit Card', N'Completed', 3200000),
(7, N'Cash', N'Completed', 600000),
(8, N'ZaloPay', N'Pending', 250000),
(9, N'Credit Card', N'Failed', 550000),
(10, N'Cash', N'Cancelled', 450000);

INSERT INTO ORDER_DETAILS (Order_id, Product_id, Quantity, Unit_price)
VALUES
(1,1,2,2500000),
(2,2,1,2800000),
(3,3,1,500000),
(4,4,2,450000),
(5,5,1,300000),
(6,6,1,700000),
(7,7,1,3200000),
(8,8,1,600000),
(9,9,1,250000),
(10,10,1,550000);



--new insert PRODUCTS
INSERT INTO PRODUCTS 
(Category_id, Product_name, Description, Image_url, Price, Quantity, Color, Size, Gender, Trending)
VALUES

-- Category 1: Football (4 sản phẩm)
(1, N'Nike Phantom GX 2', N'Giày đá bóng kiểm soát bóng tốt', N'https://images.unsplash.com/photo-1662411198835-c5a151d2af9e?q=80&w=765&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 2900000, 10, N'Black', N'42', 'Unisex', 1),
(1, N'Adidas X Crazyfast', N'Giày tốc độ siêu nhẹ', N'https://images.unsplash.com/photo-1518002171953-a080ee817e1f?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8QWRpZGFzJTIwWCUyMFNwZWVkZmxvd3xlbnwwfHwwfHx8MA%3D%3D', 3100000, 12, N'White', N'41', 'Male', 1),
(1, N'Football Shorts', N'Quần đá bóng thoáng khí', N'https://images.unsplash.com/photo-1761225091881-0d3bda9f6d5a?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 250000, 30, N'Blue', N'L', 'Male', 0),
(1, N'Football Socks', N'Tất đá bóng co giãn tốt', N'https://plus.unsplash.com/premium_photo-1661868926397-0083f0503c07?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 120000, 50, N'White', N'Free', 'Unisex', 0),

-- Category 2: Badminton (5 sản phẩm)
(2, N'Yonex Nanoray 10', N'Vợt cầu lông cho người mới', N'https://media.gettyimages.com/id/2060881043/photo/paris-france-an-se-young-of-korea-plays-a-backhand-during-the-womens-double-match-round-of-32.jpg?s=612x612&w=0&k=20&c=QDGdBBYGPomVzS6spx-dlssmdopJPeD9msHhdYI3KI8=', 900000, 20, N'Red', NULL, 'Unisex', 0),
(2, N'Yonex Power Cushion 65Z', N'Giày cầu lông chuyên nghiệp', N'https://us.yonex.com/cdn/shop/files/ALL_SUBAXIA_148-5.jpg?v=1769541507&width=533', 2200000, 15, N'White', N'42', 'Unisex', 1),
(2, N'Lining Turbo X', N'Vợt công mạnh', N'https://in.lining.studio/cdn/shop/files/01_02f0d8d89a.jpg?v=1749895603&width=500', 1800000, 10, N'Black', NULL, 'Unisex', 1),
(2, N'Badminton T-Shirt', N'Áo cầu lông thấm hút mồ hôi', N'https://images.unsplash.com/photo-1659081440135-b5dea50fcbea?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 300000, 25, N'Yellow', N'M', 'Unisex', 0),
(2, N'Badminton Net', N'Lưới cầu lông tiêu chuẩn', N'https://images.unsplash.com/photo-1536598774668-2eeb8a1a5f99?q=80&w=1171&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 500000, 8, N'Green', NULL, 'Unisex', 0),

-- Category 3: Golf (5 sản phẩm)
(3, N'Taylormade Stealth Driver', N'Gậy driver cao cấp', N'https://nhatminhsports.vn/wp-content/uploads/2026/02/TC451_zoom_D-600x600.jpg', 12000000, 5, N'Black', NULL, 'Male', 1),
(3, N'Ping Putter', N'Gậy putter chính xác cao', N'https://nhatminhsports.vn/wp-content/uploads/2025/12/Gay-Gat-Putter-Spider-ZT-Black-TaylorMade-5-600x600.jpg', 4000000, 7, N'Silver', NULL, 'Unisex', 0),
(3, N'Golf Cap', N'Mũ golf chống nắng', N'https://images.unsplash.com/photo-1668959813575-8e68053e2fcc?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 350000, 20, N'White', N'Free', 'Unisex', 0),
(3, N'Golf Bag', N'Túi đựng gậy golf cao cấp', N'https://images.unsplash.com/photo-1713728920047-45c7d1a51f1c?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 2500000, 6, N'Black', NULL, 'Male', 1),
(3, N'Golf Gloves Premium', N'Găng tay golf da mềm', N'https://images.unsplash.com/photo-1689323473750-75520243edcb?q=80&w=1332&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', 450000, 18, N'White', N'M', 'Male', 0);
