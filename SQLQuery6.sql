CREATE DATABASE QuanLyBanHangBVTV;
USE QuanLyBanHangBVTV;

-- Bảng nhà cung cấp
CREATE TABLE NhaCungCap (
    MaNhaCungCap VARCHAR(20) PRIMARY KEY,
    TenNhaCungCap NVARCHAR(255) NOT NULL,
    DiaChi NVARCHAR(255),
    SoDienThoai VARCHAR(10)
);

-- Bảng nhân viên
CREATE TABLE NhanVien (
    MaNhanVien VARCHAR(20) PRIMARY KEY,
    HoTen NVARCHAR(255) NOT NULL,
    NgaySinh DATE,
    GioiTinh NVARCHAR(10),
    ChucVu NVARCHAR(100),
    SoDienThoai VARCHAR(10),
    DiaChi NVARCHAR(255),
    NgayVaoLam DATE NOT NULL
);

-- Bảng kho
CREATE TABLE Kho (
    MaKho VARCHAR(20) PRIMARY KEY,
    TenKho NVARCHAR(255) NOT NULL,
    DiaChi NVARCHAR(255)
);

-- Bảng khách hàng
CREATE TABLE KhachHang (
    MaKhachHang VARCHAR(20) PRIMARY KEY,
    TenKhachHang NVARCHAR(255) NOT NULL,
    DiaChi NVARCHAR(255),
    SoDienThoai VARCHAR(10),
    CongNo DECIMAL(18,2) DEFAULT 0
);

-- Bảng danh mục hàng hóa
CREATE TABLE HangHoa (
    MaHang VARCHAR(20) PRIMARY KEY,
    TenHang NVARCHAR(255) NOT NULL,
    QuyCach NVARCHAR(100),
    DonViTinh NVARCHAR(50),
    GiaBan DECIMAL(18,2),
    SoLuongTon INT DEFAULT 0
);

-- Bảng tài khoản (phụ thuộc vào NhanVien)
CREATE TABLE TaiKhoan (
    TenDangNhap VARCHAR(50) PRIMARY KEY,
    MatKhauHash NVARCHAR(255) NOT NULL,
    MaNhanVien VARCHAR(20) NOT NULL,
    VaiTro NVARCHAR(50) ,
    FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien)
);

-- Bảng nhập kho (phụ thuộc vào Kho, NhanVien, NhaCungCap)
CREATE TABLE NhapKho (
    MaPhieuNhap VARCHAR(20) PRIMARY KEY,
    MaKho VARCHAR(20) NOT NULL,
    MaNhanVien VARCHAR(20) NOT NULL,
    MaNhaCungCap VARCHAR(20) NOT NULL,
    NgayNhap DATE NOT NULL,
    FOREIGN KEY (MaKho) REFERENCES Kho(MaKho),
    FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien),
    FOREIGN KEY (MaNhaCungCap) REFERENCES NhaCungCap(MaNhaCungCap)
);

-- Bảng xuất kho (phụ thuộc vào Kho, NhanVien)
CREATE TABLE XuatKho (
    MaPhieuXuat VARCHAR(20) PRIMARY KEY,
    MaKho VARCHAR(20) NOT NULL,
    MaNhanVien VARCHAR(20) NOT NULL,
    NgayXuat DATE NOT NULL,
    FOREIGN KEY (MaKho) REFERENCES Kho(MaKho),
    FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien)
);

-- Bảng đơn hàng (phụ thuộc vào KhachHang)
CREATE TABLE DonHang (
    MaDonHang VARCHAR(20) PRIMARY KEY,
    MaKhachHang VARCHAR(20) NOT NULL,
    NgayDatHang DATE NOT NULL,
    TongTien DECIMAL(18,2) DEFAULT 0,
    TrangThai NVARCHAR(50) CHECK (TrangThai IN ('Chờ xác nhận', 'Đã xác nhận', 'Đã giao', 'Đã hủy')),
    FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang)
);

-- Bảng chi tiết nhập kho (phụ thuộc vào NhapKho, HangHoa)
CREATE TABLE ChiTietNhapKho (
    MaChiTietNhapKho INT IDENTITY(1,1) PRIMARY KEY,
    MaPhieuNhap VARCHAR(20) NOT NULL,
    MaHang VARCHAR(20) NOT NULL,
    SoLuongNhap INT NOT NULL,
    DonGia DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (MaPhieuNhap) REFERENCES NhapKho(MaPhieuNhap),
    FOREIGN KEY (MaHang) REFERENCES HangHoa(MaHang)
);

-- Bảng chi tiết xuất kho (phụ thuộc vào XuatKho, HangHoa)
CREATE TABLE ChiTietXuatKho (
    MaChiTietXuatKho INT IDENTITY(1,1) PRIMARY KEY,
    MaPhieuXuat VARCHAR(20) NOT NULL,
    MaHang VARCHAR(20) NOT NULL,
    SoLuongXuat INT NOT NULL,
    DonGia DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (MaPhieuXuat) REFERENCES XuatKho(MaPhieuXuat),
    FOREIGN KEY (MaHang) REFERENCES HangHoa(MaHang)
);

-- Bảng chi tiết đơn hàng (phụ thuộc vào DonHang, HangHoa)
CREATE TABLE ChiTietDonHang (
    MaChiTietDonHang INT IDENTITY(1,1) PRIMARY KEY,
    MaDonHang VARCHAR(20) NOT NULL,
    MaHang VARCHAR(20) NOT NULL,
    SoLuong INT NOT NULL,
    DonGia DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang),
    FOREIGN KEY (MaHang) REFERENCES HangHoa(MaHang)
);

-- Bảng hóa đơn (phụ thuộc vào DonHang)
CREATE TABLE HoaDon (
    MaHoaDon VARCHAR(20) PRIMARY KEY,
    MaDonHang VARCHAR(20) NOT NULL,
    NgayLap DATE NOT NULL,
    TongTien DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang)
);

-- Bảng chi tiết hóa đơn (phụ thuộc vào HoaDon, HangHoa)
CREATE TABLE ChiTietHoaDon (
    MaChiTietHoaDon INT IDENTITY(1,1) PRIMARY KEY,
    MaHoaDon VARCHAR(20) NOT NULL,
    MaHang VARCHAR(20) NOT NULL,
    TenHang NVARCHAR(255) NOT NULL,
    SoLuong INT NOT NULL,
    DonGia DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (MaHoaDon) REFERENCES HoaDon(MaHoaDon),
    FOREIGN KEY (MaHang) REFERENCES HangHoa(MaHang)
);

-------------------Dữ liệu----------------------
-- Thêm dữ liệu vào bảng NhaCungCap
INSERT INTO NhaCungCap (MaNhaCungCap, TenNhaCungCap, DiaChi, SoDienThoai) VALUES
('NCC001', N'Công ty An Phát', N'Hà Nội', '0912345678'),
('NCC002', N'Công ty Bình Minh', N'Hồ Chí Minh', '0923456789'),
('NCC003', N'Công ty Việt Xanh', N'Đà Nẵng', '0934567890'),
('NCC004', N'Công ty Phương Nam', N'Cần Thơ', '0945678901'),
('NCC005', N'Công ty Đại Dương', N'Hải Phòng', '0956789012'),
('NCC006', N'Công ty Nông Dược', N'Nghệ An', '0967890123'),
('NCC007', N'Công ty Hữu Cơ', N'Thanh Hóa', '0978901234'),
('NCC008', N'Công ty Tân Tiến', N'Bắc Giang', '0989012345'),
('NCC009', N'Công ty Nhật Nam', N'Nam Định', '0990123456'),
('NCC010', N'Công ty Minh Châu', N'Vĩnh Long', '0901234567');

-- Thêm dữ liệu vào bảng NhanVien
INSERT INTO NhanVien (MaNhanVien, HoTen, ChucVu, SoDienThoai, NgaySinh, GioiTinh, DiaChi, NgayVaoLam) VALUES
('NV011', N'Nguyễn Văn A', N'Quản lý', '0911111111', '1985-05-10', N'Nam', N'Hà Nội', '2020-01-15'),
('NV012', N'Trần Thị B', N'Nhân viên', '0922222222', '1990-06-20', N'Nữ', N'Hồ Chí Minh', '2021-02-10'),
('NV013', N'Lê Văn C', N'Nhân viên', '0933333333', '1992-07-15', N'Nam', N'Đà Nẵng', '2021-03-05'),
('NV014', N'Phạm Thị D', N'Nhân viên', '0944444444', '1988-08-25', N'Nữ', N'Cần Thơ', '2020-07-18'),
('NV015', N'Hoàng Văn E', N'Nhân viên', '0955555555', '1995-09-10', N'Nam', N'Hải Phòng', '2022-04-22'),
('NV016', N'Đặng Thị F', N'Nhân viên', '0966666666', '1991-10-12', N'Nữ', N'Nghệ An', '2022-06-30'),
('NV017', N'Vũ Văn G', N'Nhân viên', '0977777777', '1987-11-05', N'Nam', N'Thanh Hóa', '2021-11-11'),
('NV018', N'Bùi Thị H', N'Nhân viên', '0988888888', '1993-12-01', N'Nữ', N'Bắc Giang', '2022-09-15'),
('NV019', N'Ngô Văn K', N'Nhân viên', '0999999999', '1994-03-22', N'Nam', N'Nam Định', '2023-01-05'),
('NV020', N'Đỗ Thị M', N'Nhân viên', '0900000000', '1996-04-18', N'Nữ', N'Vĩnh Long', '2023-03-20');

-- Thêm dữ liệu vào bảng Kho
INSERT INTO Kho (MaKho, TenKho, DiaChi) VALUES
('K001', N'Kho Hà Nội', N'Hà Nội'),
('K002', N'Kho Hồ Chí Minh', N'Hồ Chí Minh'),
('K003', N'Kho Đà Nẵng', N'Đà Nẵng'),
('K004', N'Kho Cần Thơ', N'Cần Thơ'),
('K005', N'Kho Hải Phòng', N'Hải Phòng'),
('K006', N'Kho Nghệ An', N'Nghệ An'),
('K007', N'Kho Thanh Hóa', N'Thanh Hóa'),
('K008', N'Kho Bắc Giang', N'Bắc Giang'),
('K009', N'Kho Nam Định', N'Nam Định'),
('K010', N'Kho Vĩnh Long', N'Vĩnh Long');

-- Thêm dữ liệu vào bảng KhachHang
INSERT INTO KhachHang (MaKhachHang, TenKhachHang, DiaChi, SoDienThoai, CongNo) VALUES
('KH001', N'Nguyễn Văn An', N'Hà Nội', '0911111112', 0),
('KH002', N'Trần Thị Bình', N'Hồ Chí Minh', '0922222223', 100000),
('KH003', N'Lê Văn Cường', N'Đà Nẵng', '0933333334', 200000),
('KH004', N'Phạm Thị Dung', N'Cần Thơ', '0944444445', 150000),
('KH005', N'Hoàng Văn Em', N'Hải Phòng', '0955555556', 0),
('KH006', N'Đặng Thị Phương', N'Nghệ An', '0966666667', 500000),
('KH007', N'Vũ Văn Hưng', N'Thanh Hóa', '0977777778', 300000),
('KH008', N'Bùi Thị Lan', N'Bắc Giang', '0988888889', 0),
('KH009', N'Ngô Văn Minh', N'Nam Định', '0999999900', 400000),
('KH010', N'Đỗ Thị Ngọc', N'Vĩnh Long', '0900000011', 0);

-- Thêm dữ liệu vào bảng HangHoa
INSERT INTO HangHoa (MaHang, TenHang, QuyCach, DonViTinh, GiaBan, SoLuongTon) VALUES
('HH001', N'Thuốc trừ sâu X', N'500ml', N'Chai', 150000, 50),
('HH002', N'Phân bón Y', N'50kg', N'Bao', 300000, 100),
('HH003', N'Hạt giống Z', N'1kg', N'Gói', 20000, 200),
('HH004', N'Thuốc diệt cỏ A', N'1 lít', N'Chai', 180000, 30),
('HH005', N'Thuốc bảo vệ thực vật B', N'250ml', N'Chai', 90000, 60),
('HH006', N'Phân hữu cơ C', N'10kg', N'Bao', 120000, 80),
('HH007', N'Dụng cụ làm vườn D', N'1 bộ', N'Bộ', 500000, 20),
('HH008', N'Bẫy côn trùng E', N'5 cái', N'Bộ', 250000, 40),
('HH009', N'Chế phẩm sinh học F', N'100ml', N'Chai', 70000, 70),
('HH010', N'Dịch vụ tư vấn cây trồng G', N'1 lần', N'Gói', 1000000, 10);

-- Thêm dữ liệu vào bảng TaiKhoan
INSERT INTO TaiKhoan (TenDangNhap, MatKhauHash, MaNhanVien, VaiTro) VALUES
('admin', '123', 'NV011', N'QuanLy'),
('nv002', '123', 'NV012', N'NhanVien'),
('nv003', '123', 'NV013', N'NhanVien'),
('nv004', '123', 'NV014', N'NhanVien'),
('nv005', '123', 'NV015', N'NhanVien'),
('nv006', '123', 'NV016', N'NhanVien'),
('nv007', '123', 'NV017', N'NhanVien'),
('nv008', '123', 'NV018', N'NhanVien'),
('nv009', '123', 'NV019', N'NhanVien'),
('nv010', '123', 'NV020', N'NhanVien');

-- Thêm dữ liệu vào bảng NhapKho
INSERT INTO NhapKho (MaPhieuNhap, MaKho, MaNhanVien, MaNhaCungCap, NgayNhap) VALUES
('PN001', 'K001', 'NV012', 'NCC001', '2025-03-01'),
('PN002', 'K002', 'NV013', 'NCC002', '2025-03-02'),
('PN003', 'K003', 'NV014', 'NCC003', '2025-03-03'),
('PN004', 'K004', 'NV015', 'NCC004', '2025-03-04'),
('PN005', 'K005', 'NV016', 'NCC005', '2025-03-05'),
('PN006', 'K006', 'NV017', 'NCC006', '2025-03-06'),
('PN007', 'K007', 'NV018', 'NCC007', '2025-03-07'),
('PN008', 'K008', 'NV019', 'NCC008', '2025-03-08');


-- Thêm dữ liệu vào bảng XuatKho
INSERT INTO XuatKho (MaPhieuXuat, MaKho, MaNhanVien, NgayXuat) VALUES
('PX001', 'K001', 'NV012', '2025-03-05'),
('PX002', 'K002', 'NV013', '2025-03-06'),
('PX003', 'K003', 'NV014', '2025-03-07'),
('PX004', 'K004', 'NV015', '2025-03-08'),
('PX005', 'K005', 'NV016', '2025-03-09'),
('PX006', 'K006', 'NV017', '2025-03-10'),
('PX007', 'K007', 'NV018', '2025-03-11'),
('PX008', 'K008', 'NV019', '2025-03-12'),
('PX009', 'K009', 'NV020', '2025-03-13');

SELECT MaNhanVien FROM NhanVien ORDER BY MaNhanVien DESC;
SELECT * FROM NhanVien WHERE GioiTinh NOT IN (N'Nam', N'Nữ', N'Khác');
SELECT DISTINCT GioiTinh FROM NhanVien;
UPDATE NhanVien 
SET GioiTinh = N'Khác' 
WHERE GioiTinh NOT IN (N'Nam', N'Nữ', N'Khác');