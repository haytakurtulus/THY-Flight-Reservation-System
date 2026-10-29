using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient; 

namespace Thy_Web_Proje
{
    public partial class Profil : System.Web.UI.Page
    {
        // Bağlantı sınıfını çağırıyoruz
        SqlBaglantisi bgl = new SqlBaglantisi();

        protected void Page_Load(object sender, EventArgs e)
        {
            //  Kullanıcı giriş yapmamışsa Login sayfasına at
            if (Session["KullaniciID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // 2. Sayfa ilk kez yükleniyorsa verileri getir
            if (!IsPostBack)
            {
                VerileriGetir();
            }
        }

        void VerileriGetir()
        {
            try
            {
                // Sessiondan ID'yi alıyoruz
                int kullaniciID = Convert.ToInt32(Session["KullaniciID"]);

                SqlConnection baglanti = bgl.baglanti();

                // Tablo adı ve ID sütununun doğruluğu önemli
                SqlCommand komut = new SqlCommand("SELECT * FROM Tbl_Thy_Kullanicilar WHERE PassengerID=@p1", baglanti);
                komut.Parameters.AddWithValue("@p1", kullaniciID);

                SqlDataReader dr = komut.ExecuteReader();
                if (dr.Read())
                {
                    
                    Profil_KullaniciID.Text = kullaniciID.ToString();

                    //Labellara veri girişi
                    Profil_Ad.Text = dr["Ad"].ToString();
                    Profil_Soyad.Text = dr["Soyad"].ToString();
                    Profil_Email.Text = dr["Email"].ToString();

                    // İsim Soyad Birleşimi
                    Profil_HeaderAdSoyad.Text = dr["Ad"].ToString() + " " + dr["Soyad"].ToString();

                    //MİL PUANI 
                    if (dr["Miles"] != DBNull.Value)
                    {
                        Profil_MilPuan.Text = dr["Miles"].ToString();

                        //  Mile göre statü belirleme
                        int mil = Convert.ToInt32(dr["Miles"]);
                        if (mil > 20000) Profil_Statu.Text = "Elite Plus";
                        else if (mil > 10000) Profil_Statu.Text = "Elite";
                        else Profil_Statu.Text = "Classic Üye";
                    }
                    else
                    {
                        Profil_MilPuan.Text = "0";
                    }

                    // --- DETAY BİLGİLER 

                    // Telefon
                    if (dr["Telefon"] != DBNull.Value)
                        Profil_Telefon.Text = dr["Telefon"].ToString();
                    else
                        Profil_Telefon.Text = "Belirtilmemiş";

                    // TC Kimlik No
                    if (dr["TCKimlikNo"] != DBNull.Value)
                        Profil_TCKN.Text = dr["TCKimlikNo"].ToString();
                    else
                        Profil_TCKN.Text = "Belirtilmemiş";

                    // Doğum Tarihi
                    if (dr["DogumTarihi"] != DBNull.Value)
                        Profil_DogumTarihi.Text = Convert.ToDateTime(dr["DogumTarihi"]).ToShortDateString();
                    else
                        Profil_DogumTarihi.Text = "Belirtilmemiş";
                }
                baglanti.Close();
            }
            catch (Exception ex)
            {
                //Hata olursa diye
            }
        }

        // ProfilGuncelle.aspx sayfasına yönlendirir
        protected void Btn_BilgileriGuncelle_Click(object sender, EventArgs e)
        {
            Response.Redirect("ProfilGuncelle.aspx");
        }
    }
}