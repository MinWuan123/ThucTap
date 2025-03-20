using System;
using System.Data;
using System.Data.SqlClient;
using System.Windows.Forms;
using System.Configuration;
using Microsoft.Win32;

namespace PMQuanLyBanHang_thuoctrusau_
{
    public partial class frmDangNhap : Form
    {
        private string connectionString = "Server=MSI\\SQLEXPRESS01;Database=QuanLyBanHangBVTV;Integrated Security=True;TrustServerCertificate=True;";
        public frmDangNhap()
        {
            InitializeComponent();
        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (MessageBox.Show("Bạn có chắc chắn muốn thoát.", "Thông Báo", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button1) == DialogResult.No)
            {
                e.Cancel = true;
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            txtTaiKhoan.Focus();
        }

        private void btnDangnhap_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string tk = txtTaiKhoan.Text.Trim();
                    string mk = txtMatKhau.Text.Trim();
                    // Truy vấn kiểm tra tài khoản
                    string sql = "SELECT * FROM TaiKhoan WHERE TenDangNhap = @Username AND MatKhauHash = @Password";
                    
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Username", tk);
                        cmd.Parameters.AddWithValue("@Password", mk);

                        SqlDataAdapter adp = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        adp.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            string vaiTro = dt.Rows[0]["VaiTro"].ToString().Trim();  // Lấy vai trò dạng string

                            MessageBox.Show("Đăng nhập thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);

                            // Mở form chính
                            Dashboard_cs mainForm = new Dashboard_cs();
                            this.Hide();
                            mainForm.ShowDialog();
                            this.Show();
                        }
                        else
                        {
                            MessageBox.Show("Sai tài khoản hoặc mật khẩu!", "Lỗi đăng nhập", MessageBoxButtons.OK, MessageBoxIcon.Error);
                            txtTaiKhoan.Clear();
                            txtMatKhau.Clear();
                        }
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Lỗi kết nối: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
        }
        private void chkHienThi_CheckedChanged(object sender, EventArgs e)
        {
            txtMatKhau.PasswordChar = chkHienThi.Checked ? '\0' : '*';
        }
    }
}
