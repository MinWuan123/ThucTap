CREATE DATABASE QuanLyBanHangBVTV;
USE QuanLyBanHangBVTV;

-- Bảng nhân viên
CREATE TABLE NhanVien (
    MaNhanVien VARCHAR(20) PRIMARY KEY,
    HoTen NVARCHAR(255) NOT NULL,
    ChucVu NVARCHAR(100),
    SoDienThoai VARCHAR(10)
);

-- Bảng tài khoản
CREATE TABLE TaiKhoan (
    TenDangNhap VARCHAR(50) PRIMARY KEY,
    MatKhauHash NVARCHAR(255) NOT NULL,
    MaNhanVien VARCHAR(20) NOT NULL,
    VaiTro NVARCHAR(50) CHECK (VaiTro IN ('QuanLy', 'NhanVien')),
    FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien)
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

-- Bảng kho
CREATE TABLE Kho (
    MaKho VARCHAR(20) PRIMARY KEY,
    TenKho NVARCHAR(255) NOT NULL,
    DiaChi NVARCHAR(255)
);

-- Bảng nhập kho
CREATE TABLE NhapKho (
    MaPhieuNhap VARCHAR(20) PRIMARY KEY,
    MaKho VARCHAR(20) NOT NULL,
    MaNhanVien VARCHAR(20) NOT NULL,
    NgayNhap DATE NOT NULL,
    FOREIGN KEY (MaKho) REFERENCES Kho(MaKho),
    FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien)
);

-- Bảng chi tiết nhập kho
CREATE TABLE ChiTietNhapKho (
    MaChiTietNhapKho INT IDENTITY(1,1) PRIMARY KEY,
    MaPhieuNhap VARCHAR(20) NOT NULL,
    MaHang VARCHAR(20) NOT NULL,
    SoLuongNhap INT NOT NULL,
    DonGia DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (MaPhieuNhap) REFERENCES NhapKho(MaPhieuNhap),
    FOREIGN KEY (MaHang) REFERENCES HangHoa(MaHang)
);

-- Bảng xuất kho
CREATE TABLE XuatKho (
    MaPhieuXuat VARCHAR(20) PRIMARY KEY,
    MaKho VARCHAR(20) NOT NULL,
    MaNhanVien VARCHAR(20) NOT NULL,
    NgayXuat DATE NOT NULL,
    FOREIGN KEY (MaKho) REFERENCES Kho(MaKho),
    FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien)
);

-- Bảng chi tiết xuất kho
CREATE TABLE ChiTietXuatKho (
    MaChiTietXuatKho INT IDENTITY(1,1) PRIMARY KEY,
    MaPhieuXuat VARCHAR(20) NOT NULL,
    MaHang VARCHAR(20) NOT NULL,
    SoLuongXuat INT NOT NULL,
    DonGia DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (MaPhieuXuat) REFERENCES XuatKho(MaPhieuXuat),
    FOREIGN KEY (MaHang) REFERENCES HangHoa(MaHang)
);

-- Bảng khách hàng
CREATE TABLE KhachHang (
    MaKhachHang VARCHAR(20) PRIMARY KEY,
    TenKhachHang NVARCHAR(255) NOT NULL,
    DiaChi NVARCHAR(255),
    SoDienThoai VARCHAR(10),
    CongNo DECIMAL(18,2) DEFAULT 0
);

CREATE TABLE DonHang (
    MaDonHang VARCHAR(20) PRIMARY KEY,
    MaKhachHang VARCHAR(20) NOT NULL,
    NgayDatHang DATE NOT NULL,
    TongTien DECIMAL(18,2) DEFAULT 0,
    TrangThai NVARCHAR(50) CHECK (TrangThai IN ('Chờ xác nhận', 'Đã xác nhận', 'Đã giao', 'Đã hủy')),
    FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang)
);

-- Bảng chi tiết đơn hàng
CREATE TABLE ChiTietDonHang (
    MaChiTietDonHang INT IDENTITY(1,1) PRIMARY KEY,
    MaDonHang VARCHAR(20) NOT NULL,
    MaHang VARCHAR(20) NOT NULL,
    SoLuong INT NOT NULL,
    DonGia DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang),
    FOREIGN KEY (MaHang) REFERENCES HangHoa(MaHang)
);

-- Bảng hóa đơn
CREATE TABLE HoaDon (
    MaHoaDon VARCHAR(20) PRIMARY KEY,
    MaDonHang VARCHAR(20) NOT NULL,
    NgayLap DATE NOT NULL,
    TongTien DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang)
);

-- Bảng chi tiết hóa đơn
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

-- Trigger cập nhật số lượng tồn khi nhập hàng
CREATE TRIGGER trg_CapNhatSoLuongNhap ON ChiTietNhapKho
AFTER INSERT
AS
BEGIN
    UPDATE HangHoa
    SET SoLuongTon = SoLuongTon + (SELECT SUM(SoLuongNhap) FROM inserted WHERE inserted.MaHang = HangHoa.MaHang)
    WHERE EXISTS (SELECT 1 FROM inserted WHERE inserted.MaHang = HangHoa.MaHang);
END;

-- Trigger cập nhật số lượng tồn khi xuất hàng
CREATE TRIGGER trg_CapNhatSoLuongXuat ON ChiTietXuatKho
AFTER INSERT
AS
BEGIN
    UPDATE HangHoa
    SET SoLuongTon = SoLuongTon - (SELECT SUM(SoLuongXuat) FROM inserted WHERE inserted.MaHang = HangHoa.MaHang)
    WHERE EXISTS (SELECT 1 FROM inserted WHERE inserted.MaHang = HangHoa.MaHang);
END;

-- Trigger cập nhật công nợ khách hàng khi tạo đơn hàng
CREATE TRIGGER trg_CapNhatCongNo ON DonHang
AFTER INSERT
AS
BEGIN
    UPDATE KhachHang
    SET CongNo = CongNo + (SELECT SUM(TongTien) FROM inserted WHERE inserted.MaKhachHang = KhachHang.MaKhachHang)
    WHERE EXISTS (SELECT 1 FROM inserted WHERE inserted.MaKhachHang = KhachHang.MaKhachHang);
END;
