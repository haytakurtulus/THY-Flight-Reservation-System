using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace Thy_Web_Proje
{
    public partial class Login : Page
    {
        //SqlBaglantisi.cs dosyamızda oluşturduğumuz sınıf ile yeni bir sql baglantisi oluşturuyoruz
        SqlBaglantisi bgl = new SqlBaglantisi();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Zaten giriş olarak kullanacağımız saya olduğu için hesap kontrolü yapmıyoruz
        }

        protected void btnGiris_Click(object sender, EventArgs e)
        {
            //Connection SqlConnection baglanti = new SqlConnection olarak kullanmadık bu yöntemle sayfa otomatik connection ı kapatıcak
            using (SqlConnection baglanti = bgl.baglanti())
            {//Sql kodunu buraya yazmak yerine oluşturduğumuz SP yi sql command yardımı ile komut olarak tanımlayıp kullanıyoruz
                using (SqlCommand komut = new SqlCommand("SP_Login", baglanti))
                {
                    //Komut tipinin sp olduğunu tanımlıyoruz
                    komut.CommandType = System.Data.CommandType.StoredProcedure;
                    //Komuta txtbox dan aldığımız Email ve şifreyi yolluyoruz
                    komut.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    komut.Parameters.AddWithValue("@Sifre", txtSifre.Text.Trim());
                    //Veritabanından dönen sonucu okuyoruz
                    using (SqlDataReader dr = komut.ExecuteReader())
                    {
                        //1 ise giriş başarılı kullanıcının ya hemen bir oturum açıp KullanıcıID Ad soyad ve ÖZELLİKLE rol değerini kaydediyoruz
                        if (dr.Read())
                        {
                            Session["KullaniciID"] = dr["PassengerID"].ToString();
                            Session["AdSoyad"] = dr["Ad"].ToString() + " " + dr["Soyad"].ToString();
                            Session["Rol"] = dr["RolID"].ToString();
                        }
                        else
                        {
                            lblSonuc.Text = "Hatalı E-Posta veya Şifre girdiniz!";
                            return;
                        }
                    }
                }
            }

            // Kullanıcının Rol id sine göre hangi sayfaya atacağımızı belirliyoruz
            if (Session["Rol"].ToString() == "2")
                Response.Redirect("Admin.aspx");
            else
                Response.Redirect("Default.aspx");
        }
        //Eğer kullanıcı Kayıt Ol butonun tıklarsa register a yolluyoruz
        protected void btnKayitOl_Click(object sender, EventArgs e)
        {
            Response.Redirect("Register.aspx");
        }
    }
}
