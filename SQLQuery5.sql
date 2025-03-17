-- Tạo cơ sở dữ liệu
CREATE DATABASE QuanLyBanHangThuocBVTV;
USE QuanLyBanHangThuocBVTV;

-- 1. Bảng Nhân viên
CREATE TABLE NhanVien (
    MaNV VARCHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    NgaySinh DATE,
    GioiTinh NVARCHAR(10),
    DiaChi NVARCHAR(200),
    DienThoai VARCHAR(20),
    Email VARCHAR(100),
    ChucVu NVARCHAR(50),
    PhongBan NVARCHAR(50),
    NgayVaoLam DATE,
    TrangThai BIT DEFAULT 1, -- 1: Đang làm việc, 0: Nghỉ việc
    GhiChu NVARCHAR(500)
);

-- 2. Bảng Người dùng (tài khoản đăng nhập hệ thống)
CREATE TABLE NguoiDung (
    MaND VARCHAR(20) PRIMARY KEY,
    MaNV VARCHAR(10),
    TenDangNhap VARCHAR(50) UNIQUE NOT NULL,
    MatKhau VARCHAR(100) NOT NULL,
    VaiTro NVARCHAR(20) NOT NULL, -- Admin, QuanLy, NhanVienBanHang, NhanVienKho, KeToan
    NgayTao DATETIME DEFAULT GETDATE(),
    TrangThai BIT DEFAULT 1, -- 1: Hoạt động, 0: Khóa
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);

-- 3. Bảng Khách hàng
CREATE TABLE KhachHang (
    MaKH VARCHAR(10) PRIMARY KEY,
    TenKH NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(200),
    DienThoai VARCHAR(20),
    MaSoThue VARCHAR(20),
    NgayTao DATE DEFAULT GETDATE(),
    NguoiTao VARCHAR(10),
    HanMucNo DECIMAL(18,2) DEFAULT 0,
    GhiChu NVARCHAR(500),
    TrangThai BIT DEFAULT 1, -- 1: Hoạt động, 0: Ngừng hoạt động
    FOREIGN KEY (NguoiTao) REFERENCES NhanVien(MaNV)
);

-- 4. Bảng lịch sử biến động khách hàng
CREATE TABLE LichSuKhachHang (
    MaLSKH INT IDENTITY(1,1) PRIMARY KEY,
    MaKH VARCHAR(10),
    NgayCapNhat DATETIME DEFAULT GETDATE(),
    NguoiCapNhat VARCHAR(10),
    NoiDungCapNhat NVARCHAR(500),
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH),
    FOREIGN KEY (NguoiCapNhat) REFERENCES NhanVien(MaNV)
);

-- 5. Bảng Nhóm hàng
CREATE TABLE NhomHang (
    MaNhom VARCHAR(10) PRIMARY KEY,
    TenNhom NVARCHAR(100) NOT NULL,
    MoTa NVARCHAR(200)
);

-- 6. Bảng Hàng hóa
CREATE TABLE HangHoa (
    MaHH VARCHAR(10) PRIMARY KEY,
    TenHH NVARCHAR(100) NOT NULL,
    MaNhom VARCHAR(10),
    DonViTinh NVARCHAR(20),
    MoTa NVARCHAR(500),
    TrangThai BIT DEFAULT 1, -- 1: Đang kinh doanh, 0: Ngừng kinh doanh
    FOREIGN KEY (MaNhom) REFERENCES NhomHang(MaNhom)
);

-- 7. Bảng Quy cách đóng gói
CREATE TABLE QuyCachDongGoi (
    MaQC VARCHAR(10) PRIMARY KEY,
    MaHH VARCHAR(10) NOT NULL,
    TenQuyCach NVARCHAR(100) NOT NULL,
    SoLuongQuyDoi DECIMAL(10,2) NOT NULL, -- Số lượng quy đổi ra đơn vị cơ bản
    TrangThai BIT DEFAULT 1, -- 1: Sử dụng, 0: Không sử dụng
    FOREIGN KEY (MaHH) REFERENCES HangHoa(MaHH)
);

-- 8. Bảng Giá bán
CREATE TABLE GiaBan (
    MaGia INT IDENTITY(1,1) PRIMARY KEY,
    MaHH VARCHAR(10) NOT NULL,
    MaQC VARCHAR(10) NOT NULL,
    GiaBan DECIMAL(18,2) NOT NULL,
    NgayApDung DATE NOT NULL,
    NgayHetHan DATE,
    GhiChu NVARCHAR(200),
    FOREIGN KEY (MaHH) REFERENCES HangHoa(MaHH),
    FOREIGN KEY (MaQC) REFERENCES QuyCachDongGoi(MaQC)
);

-- 9. Bảng Kho
CREATE TABLE Kho (
    MaKho VARCHAR(10) PRIMARY KEY,
    TenKho NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(200),
    NguoiQuanLy VARCHAR(10),
    GhiChu NVARCHAR(200),
    --TrangThai BIT DEFAULT 1, -- 1: Hoạt động, 0: Ngừng hoạt động
    FOREIGN KEY (NguoiQuanLy) REFERENCES NhanVien(MaNV)
);

-- 10. Bảng Tồn kho
CREATE TABLE TonKho (
    MaTonKho INT IDENTITY(1,1) PRIMARY KEY,
    MaKho VARCHAR(10) NOT NULL,
    MaHH VARCHAR(10) NOT NULL,
    MaQC VARCHAR(10) NOT NULL,
    SoLuongTon DECIMAL(10,2) DEFAULT 0,
    NgayCapNhat DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (MaKho) REFERENCES Kho(MaKho),
    FOREIGN KEY (MaHH) REFERENCES HangHoa(MaHH),
    FOREIGN KEY (MaQC) REFERENCES QuyCachDongGoi(MaQC)
);

-- 11. Bảng Phiếu nhập kho
CREATE TABLE PhieuNhapKho (
    MaPNK VARCHAR(20) PRIMARY KEY,
    NgayNhap DATE NOT NULL,
    MaKho VARCHAR(10) NOT NULL,
    NguoiNhap VARCHAR(10) NOT NULL,
    NguoiGiao NVARCHAR(100),
    GhiChu NVARCHAR(500),
    TrangThai INT DEFAULT 0, -- 0: Tạo mới, 1: Đã xác nhận, 2: Đã nhập kho
    FOREIGN KEY (MaKho) REFERENCES Kho(MaKho),
    FOREIGN KEY (NguoiNhap) REFERENCES NhanVien(MaNV)
);

-- 12. Bảng Chi tiết phiếu nhập
CREATE TABLE ChiTietPhieuNhap (
    MaCTPN INT IDENTITY(1,1) PRIMARY KEY,
    MaPNK VARCHAR(20) NOT NULL,
    MaHH VARCHAR(10) NOT NULL,
    MaQC VARCHAR(10) NOT NULL,
    SoLuong DECIMAL(10,2) NOT NULL,
    DonGia DECIMAL(18,2) NOT NULL,
    ThanhTien DECIMAL(18,2) NOT NULL,
    GhiChu NVARCHAR(200),
    FOREIGN KEY (MaPNK) REFERENCES PhieuNhapKho(MaPNK),
    FOREIGN KEY (MaHH) REFERENCES HangHoa(MaHH),
    FOREIGN KEY (MaQC) REFERENCES QuyCachDongGoi(MaQC)
);

-- 13. Bảng Đơn hàng
CREATE TABLE DonHang (
    MaDH VARCHAR(20) PRIMARY KEY,
    NgayDH DATE NOT NULL,
    MaKH VARCHAR(10) NOT NULL,
    NhanVienBanHang VARCHAR(10) NOT NULL,
    TongTienHang DECIMAL(18,2) DEFAULT 0,
    ChietKhau DECIMAL(18,2) DEFAULT 0,
    TongThanhTien DECIMAL(18,2) DEFAULT 0,
    DaThanhToan DECIMAL(18,2) DEFAULT 0,
    ConNo DECIMAL(18,2) DEFAULT 0,
    GhiChu NVARCHAR(500),
    TrangThai INT DEFAULT 0, -- 0: Đơn mới, 1: Đã xác nhận, 2: Đã giao hàng, 3: Đã thanh toán, 4: Hủy
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH),
    FOREIGN KEY (NhanVienBanHang) REFERENCES NhanVien(MaNV)
);

-- 14. Bảng Chi tiết đơn hàng
CREATE TABLE ChiTietDonHang (
    MaCTDH INT IDENTITY(1,1) PRIMARY KEY,
    MaDH VARCHAR(20) NOT NULL,
    MaHH VARCHAR(10) NOT NULL,
    MaQC VARCHAR(10) NOT NULL,
    SoLuong DECIMAL(10,2) NOT NULL,
    DonGia DECIMAL(18,2) NOT NULL,
    ChietKhau DECIMAL(18,2) DEFAULT 0,
    ThanhTien DECIMAL(18,2) NOT NULL,
    GhiChu NVARCHAR(200),
    FOREIGN KEY (MaDH) REFERENCES DonHang(MaDH),
    FOREIGN KEY (MaHH) REFERENCES HangHoa(MaHH),
    FOREIGN KEY (MaQC) REFERENCES QuyCachDongGoi(MaQC)
);

-- 15. Bảng Phiếu giao hàng
CREATE TABLE PhieuGiaoHang (
    MaPGH VARCHAR(20) PRIMARY KEY,
    MaDH VARCHAR(20) NOT NULL,
    NgayGiao DATE NOT NULL,
    NguoiGiao VARCHAR(10) NOT NULL,
    TrangThai INT DEFAULT 0, -- 0: Chờ giao, 1: Đang giao, 2: Đã giao, 3: Hủy
    GhiChu NVARCHAR(500),
    FOREIGN KEY (MaDH) REFERENCES DonHang(MaDH),
    FOREIGN KEY (NguoiGiao) REFERENCES NhanVien(MaNV)
);

-- 16. Bảng Chi tiết phiếu giao
CREATE TABLE ChiTietPhieuGiao (
    MaCTPG INT IDENTITY(1,1) PRIMARY KEY,
    MaPGH VARCHAR(20) NOT NULL,
    MaHH VARCHAR(10) NOT NULL,
    MaQC VARCHAR(10) NOT NULL,
    SoLuong DECIMAL(10,2) NOT NULL,
    GhiChu NVARCHAR(200),
    FOREIGN KEY (MaPGH) REFERENCES PhieuGiaoHang(MaPGH),
    FOREIGN KEY (MaHH) REFERENCES HangHoa(MaHH),
    FOREIGN KEY (MaQC) REFERENCES QuyCachDongGoi(MaQC)
);

-- 17. Bảng Thanh toán
CREATE TABLE ThanhToan (
    MaTT INT IDENTITY(1,1) PRIMARY KEY,
    MaDH VARCHAR(20) NOT NULL,
    NgayThanhToan DATE NOT NULL,
    SoTien DECIMAL(18,2) NOT NULL,
    NguoiThu VARCHAR(10) NOT NULL,
    GhiChu NVARCHAR(500),
    FOREIGN KEY (MaDH) REFERENCES DonHang(MaDH),
    FOREIGN KEY (NguoiThu) REFERENCES NhanVien(MaNV)
);

-- 18. Bảng Công nợ khách hàng
CREATE TABLE CongNoKhachHang (
    MaCN INT IDENTITY(1,1) PRIMARY KEY,
    MaKH VARCHAR(10) NOT NULL,
    NgayPS DATE NOT NULL,
    SoTienNo DECIMAL(18,2) DEFAULT 0,
    SoTienTra DECIMAL(18,2) DEFAULT 0,
    NoConLai DECIMAL(18,2) DEFAULT 0,
    GhiChu NVARCHAR(500),
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

-- 19. Bảng Doanh số khách hàng
CREATE TABLE DoanhSoKhachHang (
    MaDS INT IDENTITY(1,1) PRIMARY KEY,
    MaKH VARCHAR(10) NOT NULL,
    Nam INT NOT NULL,
    Thang INT NOT NULL,
    DoanhSo DECIMAL(18,2) DEFAULT 0,
    GhiChu NVARCHAR(500),
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

-- ====================== STORED PROCEDURES ======================
-- 1. Procedure thêm hàng hóa mới
CREATE PROCEDURE sp_ThemHangHoa
    @MaHH VARCHAR(10),
    @TenHH NVARCHAR(100),
    @MaNhom VARCHAR(10),
    @DonViTinh NVARCHAR(20),
    @MoTa NVARCHAR(500),
    @TrangThai BIT
AS
BEGIN
    INSERT INTO HangHoa (MaHH, TenHH, MaNhom, DonViTinh, MoTa, TrangThai)
    VALUES (@MaHH, @TenHH, @MaNhom, @DonViTinh, @MoTa, @TrangThai);
END;

-- 2. Procedure thêm quy cách đóng gói mới
CREATE PROCEDURE sp_ThemQuyCachDongGoi
    @MaQC VARCHAR(10),
    @MaHH VARCHAR(10),
    @TenQuyCach NVARCHAR(100),
    @SoLuongQuyDoi DECIMAL(10,2),
    @TrangThai BIT
AS
BEGIN
    INSERT INTO QuyCachDongGoi (MaQC, MaHH, TenQuyCach, SoLuongQuyDoi, TrangThai)
    VALUES (@MaQC, @MaHH, @TenQuyCach, @SoLuongQuyDoi, @TrangThai);
END;

-- 3. Procedure thêm giá bán mới
CREATE PROCEDURE sp_ThemGiaBan
    @MaHH VARCHAR(10),
    @MaQC VARCHAR(10),
    @GiaBan DECIMAL(18,2),
    @NgayApDung DATE,
    @NgayHetHan DATE,
    @GhiChu NVARCHAR(200)
AS
BEGIN
    INSERT INTO GiaBan (MaHH, MaQC, GiaBan, NgayApDung, NgayHetHan, GhiChu)
    VALUES (@MaHH, @MaQC, @GiaBan, @NgayApDung, @NgayHetHan, @GhiChu);
END;

-- 4. Procedure thêm khách hàng mới
CREATE PROCEDURE sp_ThemKhachHang
    @MaKH VARCHAR(10),
    @TenKH NVARCHAR(100),
    @DiaChi NVARCHAR(200),
    @DienThoai VARCHAR(20),
    @MaSoThue VARCHAR(20),
    @NguoiTao VARCHAR(10),
    @HanMucNo DECIMAL(18,2),
    @GhiChu NVARCHAR(500)
AS
BEGIN
    INSERT INTO KhachHang (MaKH, TenKH, DiaChi, DienThoai, MaSoThue, NgayTao, NguoiTao, HanMucNo, GhiChu, TrangThai)
    VALUES (@MaKH, @TenKH, @DiaChi, @DienThoai, @MaSoThue, GETDATE(), @NguoiTao, @HanMucNo, @GhiChu, 1);
END;

-- 5. Procedure tạo đơn hàng mới
CREATE PROCEDURE sp_TaoDonHang
    @MaDH VARCHAR(20),
    @MaKH VARCHAR(10),
    @NhanVienBanHang VARCHAR(10),
    @GhiChu NVARCHAR(500)
AS
BEGIN
    INSERT INTO DonHang (MaDH, NgayDH, MaKH, NhanVienBanHang, GhiChu, TrangThai)
    VALUES (@MaDH, GETDATE(), @MaKH, @NhanVienBanHang, @GhiChu, 0);
END;

-- 6. Procedure thêm sản phẩm vào đơn hàng
CREATE PROCEDURE sp_ThemSanPhamVaoDonHang
    @MaDH VARCHAR(20),
    @MaHH VARCHAR(10),
    @MaQC VARCHAR(10),
    @SoLuong DECIMAL(10,2),
    @GhiChu NVARCHAR(200)
AS
BEGIN
    DECLARE @DonGia DECIMAL(18,2);
    DECLARE @ThanhTien DECIMAL(18,2);
    
    -- Lấy giá bán hiện tại
    SELECT TOP 1 @DonGia = GiaBan
    FROM GiaBan
    WHERE MaHH = @MaHH AND MaQC = @MaQC 
    AND NgayApDung <= GETDATE() 
    AND (NgayHetHan IS NULL OR NgayHetHan >= GETDATE())
    ORDER BY NgayApDung DESC;
    
    SET @ThanhTien = @SoLuong * @DonGia;
    
    INSERT INTO ChiTietDonHang (MaDH, MaHH, MaQC, SoLuong, DonGia, ThanhTien, GhiChu)
    VALUES (@MaDH, @MaHH, @MaQC, @SoLuong, @DonGia, @ThanhTien, @GhiChu);
    
    -- Cập nhật tổng tiền đơn hàng
    UPDATE DonHang
    SET TongTienHang = (SELECT SUM(ThanhTien) FROM ChiTietDonHang WHERE MaDH = @MaDH),
        TongThanhTien = (SELECT SUM(ThanhTien) FROM ChiTietDonHang WHERE MaDH = @MaDH) - ChietKhau,
        ConNo = (SELECT SUM(ThanhTien) FROM ChiTietDonHang WHERE MaDH = @MaDH) - ChietKhau - DaThanhToan
    WHERE MaDH = @MaDH;
END;


-----------------INSERT------------------
-- 1. Thêm dữ liệu vào bảng NhanVien
INSERT INTO NhanVien (MaNV, HoTen, NgaySinh, GioiTinh, DiaChi, DienThoai, Email, ChucVu, PhongBan, NgayVaoLam, TrangThai, GhiChu) VALUES
('NV001', N'Nguyễn Văn A', '1985-01-15', N'Nam', N'Hà Nội', '0901234567', 'a@example.com', N'Quản lý', N'Kinh doanh', '2020-01-01', 1, N''),
('NV002', N'Trần Thị B', '1990-05-20', N'Nữ', N'Hồ Chí Minh', '0912345678', 'b@example.com', N'Nhân viên', N'Bán hàng', '2021-02-15', 1, N''),

-- 2. Thêm dữ liệu vào bảng NguoiDung
INSERT INTO NguoiDung (MaND, MaNV, TenDangNhap, MatKhau, VaiTro, NgayTao, TrangThai) VALUES
('ND001', 'NV001', 'admin', '123456', N'Admin', GETDATE(), 1),
('ND002', 'NV002', 'tranb', '123456', N'NhanVienBanHang', GETDATE(), 1),

-- 3. Thêm dữ liệu vào bảng KhachHang
INSERT INTO KhachHang (MaKH, TenKH, DiaChi, DienThoai, MaSoThue, NgayTao, NguoiTao, HanMucNo, GhiChu, TrangThai) VALUES
('KH001', N'Công ty A', N'Hà Nội', '0901000001', '0101010101', GETDATE(), 'NV001', 10000000, N'', 1),
('KH002', N'Công ty B', N'Hồ Chí Minh', '0901000002', '0202020202', GETDATE(), 'NV002', 20000000, N'', 1),
('KH003', N'Công ty C', N'Đà Nẵng', '0901000003', '0303030303', GETDATE(), 'NV003', 15000000, N'', 1),
('KH004', N'Công ty D', N'Hải Phòng', '0901000004', '0404040404', GETDATE(), 'NV004', 18000000, N'', 1),
('KH005', N'Công ty E', N'Bình Dương', '0901000005', '0505050505', GETDATE(), 'NV005', 12000000, N'', 1),
('KH006', N'Công ty F', N'Bắc Ninh', '0901000006', '0606060606', GETDATE(), 'NV006', 14000000, N'', 1),
('KH007', N'Công ty G', N'Thanh Hóa', '0901000007', '0707070707', GETDATE(), 'NV007', 13000000, N'', 1),
('KH008', N'Công ty H', N'Quảng Ninh', '0901000008', '0808080808', GETDATE(), 'NV008', 16000000, N'', 1),
('KH009', N'Công ty I', N'Cần Thơ', '0901000009', '0909090909', GETDATE(), 'NV009', 17000000, N'', 1),
('KH010', N'Công ty J', N'Nghệ An', '0901000010', '1010101010', GETDATE(), 'NV010', 19000000, N'', 1);

-- Bảng Nhóm hàng
INSERT INTO NhomHang (MaNhom, TenNhom, MoTa) VALUES
('NH01', N'Thuốc trừ sâu', N'Nhóm thuốc trừ sâu các loại'),
('NH02', N'Phân bón', N'Nhóm phân bón hữu cơ và hóa học'),
('NH03', N'Chế phẩm sinh học', N'Nhóm chế phẩm sinh học dùng trong nông nghiệp'),
('NH04', N'Giống cây trồng', N'Nhóm giống cây trồng chất lượng cao'),
('NH05', N'Thuốc trừ bệnh', N'Nhóm thuốc trừ bệnh cây trồng'),
('NH06', N'Bảo vệ thực vật', N'Nhóm sản phẩm bảo vệ thực vật'),
('NH07', N'Thuốc kích thích tăng trưởng', N'Nhóm thuốc kích thích sinh trưởng'),
('NH08', N'Dụng cụ nông nghiệp', N'Nhóm dụng cụ phục vụ nông nghiệp'),
('NH09', N'Chế phẩm vi sinh', N'Nhóm vi sinh hỗ trợ cây trồng'),
('NH10', N'Phụ gia nông nghiệp', N'Nhóm phụ gia hỗ trợ sản xuất nông nghiệp');

-- Bảng Hàng hóa
INSERT INTO HangHoa (MaHH, TenHH, MaNhom, DonViTinh, MoTa, TrangThai) VALUES
('HH01', N'Thuốc trừ sâu ABC', 'NH01', N'Chai', N'Thuốc trừ sâu hiệu quả', 1),
('HH02', N'Phân bón hữu cơ XYZ', 'NH02', N'Bao', N'Phân bón hữu cơ vi sinh', 1),
('HH03', N'Chế phẩm sinh học Bio', 'NH03', N'Chai', N'Hỗ trợ tăng trưởng cây trồng', 1),
('HH04', N'Giống lúa DT1', 'NH04', N'Kg', N'Giống lúa chất lượng cao', 1),
('HH05', N'Thuốc trừ bệnh cây Tom', 'NH05', N'Chai', N'Ngăn ngừa bệnh hại cây trồng', 1),
('HH06', N'Dụng cụ xịt thuốc', 'NH08', N'Cái', N'Dụng cụ hỗ trợ xịt thuốc', 1),
('HH07', N'Chế phẩm vi sinh Bacillus', 'NH09', N'Kg', N'Vi sinh hỗ trợ cây trồng', 1),
('HH08', N'Thuốc kích thích tăng trưởng GA3', 'NH07', N'Chai', N'Kích thích tăng trưởng thực vật', 1),
('HH09', N'Phân bón NPK 16-16-8', 'NH02', N'Bao', N'Phân bón tổng hợp', 1),
('HH10', N'Thuốc diệt cỏ nhanh', 'NH01', N'Chai', N'Thuốc diệt cỏ hiệu quả', 1);

-- Bảng Kho
INSERT INTO Kho (MaKho, TenKho, DiaChi, NguoiQuanLy, GhiChu) VALUES
('K01', N'Kho chính', N'123 Đường A, TP. HCM', 'NV001', N'Kho trung tâm'),
('K02', N'Kho miền Tây', N'456 Đường B, Cần Thơ', 'NV002', N'Kho chi nhánh miền Tây'),
('K03', N'Kho miền Trung', N'789 Đường C, Đà Nẵng', 'NV003', N'Kho chi nhánh miền Trung'),
('K04', N'Kho miền Bắc', N'101 Đường D, Hà Nội', 'NV004', N'Kho chi nhánh miền Bắc'),
('K05', N'Kho Đồng Nai', N'234 Đường E, Đồng Nai', 'NV005', N'Kho chi nhánh Đồng Nai'),
('K06', N'Kho Bình Dương', N'567 Đường F, Bình Dương', 'NV006', N'Kho chi nhánh Bình Dương'),
('K07', N'Kho Long An', N'890 Đường G, Long An', 'NV007', N'Kho chi nhánh Long An'),
('K08', N'Kho Đắk Lắk', N'112 Đường H, Đắk Lắk', 'NV008', N'Kho chi nhánh Tây Nguyên'),
('K09', N'Kho Tây Ninh', N'345 Đường I, Tây Ninh', 'NV009', N'Kho chi nhánh Tây Ninh'),
('K10', N'Kho Tiền Giang', N'678 Đường J, Tiền Giang', 'NV010', N'Kho chi nhánh Tiền Giang');
