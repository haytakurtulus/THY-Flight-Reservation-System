using System;
using System.Collections.Generic;
using System.Data.SqlClient; // SQL kütüphanesi
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Thy_Web_Proje
{
    public partial class ProfilGuncelle : System.Web.UI.Page
    {
        SqlBaglantisi bgl = new SqlBaglantisi();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Oturum kontrolü
            if (Session["KullaniciID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // Sayfa ilk defa yükleniyorsa verileri getir 
            if (!IsPostBack)
            {
                MevcutBilgileriGetir();
            }
        }

        void MevcutBilgileriGetir()
        {
            //Kullanıcı Id çek
            int id = Convert.ToInt32(Session["KullaniciID"]);
            SqlConnection baglanti = bgl.baglanti();

            // Tablomuzdan O kişiye ait bilgileri al
            SqlCommand komut = new SqlCommand("SELECT * FROM Tbl_Thy_Kullanicilar WHERE PassengerID=@p1", baglanti);
            komut.Parameters.AddWithValue("@p1", id);
            //Alınan ve okunan bilgileri Forma geçir
            SqlDataReader dr = komut.ExecuteReader();
            if (dr.Read())
            {
                // Değiştirilemez alanlar
                //Forma geçir
                txtAdSoyad.Text = dr["Ad"].ToString() + " " + dr["Soyad"].ToString(); // Tablo sütun adlarına dikkat: Ad, Soyad
                txtEmail.Text = dr["Email"].ToString();

                // Güncellenebilir alanlar 
                if (dr["Telefon"] != DBNull.Value)
                    txtTelefon.Text = dr["Telefon"].ToString();

                if (dr["TCKimlikNo"] != DBNull.Value)
                    txtTC.Text = dr["TCKimlikNo"].ToString();

                if (dr["DogumTarihi"] != DBNull.Value)
                {
                    //Doğum tarihini uygun formata getir
                    DateTime tarih = Convert.ToDateTime(dr["DogumTarihi"]);
                    txtDogumTarihi.Text = tarih.ToString("yyyy-MM-dd");
                }
            }
            baglanti.Close();
        }

        protected void btnKaydet_Click(object sender, EventArgs e)
        {
            //  TC 11 hane mi
            if (txtTC.Text.Length != 11 && !string.IsNullOrEmpty(txtTC.Text))
            {
                lblMesaj.Text = "TC Kimlik Numarası 11 haneli olmalıdır.";
                lblMesaj.ForeColor = System.Drawing.Color.Red;
                return;
            }

            try
            {
                int id = Convert.ToInt32(Session["KullaniciID"]);
                SqlConnection baglanti = bgl.baglanti();

                //Sp miz ile Profili güncelleme
                SqlCommand komut = new SqlCommand("sp_UpdateProfile", baglanti);
                komut.CommandType = System.Data.CommandType.StoredProcedure;
                //Parametreleri Sp ye ver
                komut.Parameters.AddWithValue("@KullaniciID", id);
                komut.Parameters.AddWithValue("@TCKimlikNo", txtTC.Text);
                komut.Parameters.AddWithValue("@Telefon", txtTelefon.Text);

                // Tarih boşsa hata vermemesi için kontrol
                if (!string.IsNullOrEmpty(txtDogumTarihi.Text))
                    komut.Parameters.AddWithValue("@DogumTarihi", Convert.ToDateTime(txtDogumTarihi.Text));
                else
                    komut.Parameters.AddWithValue("@DogumTarihi", DBNull.Value);

                komut.ExecuteNonQuery();
                baglanti.Close();

                // Başarılı olursa Profil sayfasına geri dön
                Response.Redirect("Profil.aspx");
            }
            catch (Exception ex)
            {
                lblMesaj.Text = "Hata oluştu: " + ex.Message;
                lblMesaj.ForeColor = System.Drawing.Color.Red;
            }
        }

        protected void btnIptal_Click(object sender, EventArgs e)
        {
            // İptal ederse direkt profil sayfasına dön
            Response.Redirect("Profil.aspx");
        }
    }
}