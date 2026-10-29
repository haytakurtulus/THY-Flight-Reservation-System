using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient; // SQL Kütüphanesi

namespace Thy_Web_Proje
{
    public partial class Register : System.Web.UI.Page
    {
        // Bağlantı sınıfımızı çağırıyoruz
        SqlBaglantisi bgl = new SqlBaglantisi();

        protected void Page_Load(object sender, EventArgs e)
        {
            //hala session denen bir kavrama sahip olmadığımız için boş
        }

        protected void btnKayitTamamla_Click(object sender, EventArgs e)
        {
            // Bağlantı nesnesi oluşturuyoruz
            SqlConnection baglanti = bgl.baglanti();

            // Sql den kullanacağımız stop prosedür
            SqlCommand komut = new SqlCommand("SP_Register", baglanti);
            //Komutun tipini yani bir sorgu değil prosedür olduğunu belirtiyoruz
            komut.CommandType = System.Data.CommandType.StoredProcedure;

            // Stop Prosedürün kullanacağı gerekli olan değerleri ekle
            komut.Parameters.AddWithValue("@Ad", txtAd.Text);
            komut.Parameters.AddWithValue("@Soyad", txtSoyad.Text);
            komut.Parameters.AddWithValue("@Email", txtEmail.Text);
            komut.Parameters.AddWithValue("@Sifre", txtSifre.Text);

           //Burada işlemin sonucunu kaydediyoruz 0 mı 1 mi 
            int sonuc = Convert.ToInt32(komut.ExecuteScalar());
            //Açtığımzı connection ı kapıyoruz
            baglanti.Close();

            // Sonuca göre işlem yap
            if (sonuc == 0)
            {
                // Mail zaten varsa
                lblSonuc.Text = "Bu E-Posta adresi zaten sistemde kayıtlı!";
                lblSonuc.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                // Kayıt başarılıysa
                Response.Write("<script>alert('Kayıt Başarılı! Giriş yapabilirsiniz.'); window.location='Login.aspx';</script>");
            }
        }
    }
}