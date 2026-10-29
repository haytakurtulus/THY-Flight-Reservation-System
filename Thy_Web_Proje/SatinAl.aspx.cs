using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data; // CommandType için gerekli

namespace Thy_Web_Proje
{
    public partial class SatinAl : System.Web.UI.Page
    {
        SqlBaglantisi bgl = new SqlBaglantisi();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["KullaniciID"] == null)
            {
                //Kullanıcı giriş yapmadı ise onu otomatik olarak login sayfasına atar
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // Gidiş Uçuşunu Getir
                if (Session["GidisUcusID"] != null)
                {
                    UcusDetayGetir(Session["GidisUcusID"].ToString(), true);
                }
                else
                {
                    // Uçuş seçilmeden geldiyse anasayfaya at
                    Response.Redirect("Default.aspx");
                }

                // Dönüş Uçuşu Varsa Getir
                if (Session["DonusUcusID"] != null)
                {
                    pnlDonus.Visible = true; // Paneli aç
                    UcusDetayGetir(Session["DonusUcusID"].ToString(), false);
                }
            }
        }

        // isGidis: true ise Gidiş paneline, false ise Dönüş paneline yaz
        void UcusDetayGetir(string ucusID, bool isGidis)
        {
            SqlConnection baglanti = bgl.baglanti();

            //Sql sorgumuz ile uçuş detaylarını getiriyoruz
            SqlCommand komut = new SqlCommand("SP_GetFlightDetails", baglanti);
            komut.CommandType = CommandType.StoredProcedure;

            // Uçuş Id sini prosedüre veriyoruz

            komut.Parameters.AddWithValue("@FlightID", ucusID);
         
            //Sorgumuz ile gelen verileri okuyoruz
            SqlDataReader dr = komut.ExecuteReader();
            if (dr.Read())
            {
                //Sorgumuzun verilerini değişkenlere atıyoruz
                double fiyat = Convert.ToDouble(dr["Price"]);
                DateTime tarih = Convert.ToDateTime(dr["TimeandDate"]);

                if (isGidis)
                {
                    //Panelimizi elde ettiğimiz verilerle dolduruyoruz
                    lblGidisNereden.Text = dr["Nereden"].ToString();
                    lblGidisNereye.Text = dr["Nereye"].ToString();
                    lblGidisTarih.Text = tarih.ToString("dd.MM.yyyy");
                    lblGidisSaat.Text = tarih.ToString("HH:mm");
                    lblGidisNo.Text = dr["FlightID"].ToString();
                    lblGidisFiyat.Text = fiyat + " TL";
                }
                else
                {
                    //Gidis ucusu değilse dönüştür dönüş biletiin dolduruyoruz
                    lblDonusNereden.Text = dr["Nereden"].ToString();
                    lblDonusNereye.Text = dr["Nereye"].ToString();
                    lblDonusTarih.Text = tarih.ToString("dd.MM.yyyy");
                    lblDonusSaat.Text = tarih.ToString("HH:mm");
                    lblDonusNo.Text = dr["FlightID"].ToString();
                    lblDonusFiyat.Text = fiyat + " TL";
                }
                //Eğer gidiş dönüşse toplam fiyat hesabı için
                MevcutFiyatiGuncelle(fiyat);
            }
            baglanti.Close();
        }
        //Eğer 2. panel görünür kılındıysa toplamlarını yazıyoruz
        void MevcutFiyatiGuncelle(double fiyat)
        {
            if (ViewState["ToplamTutar"] == null)
            {
                ViewState["ToplamTutar"] = fiyat;
            }
            else
            {
                double mevcut = (double)ViewState["ToplamTutar"];
                ViewState["ToplamTutar"] = mevcut + fiyat;
            }

            lblToplamFiyat.Text = ViewState["ToplamTutar"].ToString() + " TL";
        }

        protected void btnOnayla_Click(object sender, EventArgs e)
        {
            int yolcuID = Convert.ToInt32(Session["KullaniciID"]);
            SqlConnection baglanti = bgl.baglanti();

            try
            {
                // 1. GİDİŞ BİLETİNİ AL
                string gidisID = Session["GidisUcusID"].ToString();

                SqlCommand komut1 = new SqlCommand("SP_BuyTicket", baglanti);
                komut1.CommandType = CommandType.StoredProcedure;
                komut1.Parameters.AddWithValue("@FlightID", gidisID);
                komut1.Parameters.AddWithValue("@PassengerID", yolcuID);

                komut1.ExecuteNonQuery();

                // 2. DÖNÜŞ VARSA ONU DA AL
                if (Session["DonusUcusID"] != null)
                {
                    SqlCommand komut2 = new SqlCommand("SP_BuyTicket", baglanti);
                    komut2.CommandType = CommandType.StoredProcedure;
                    komut2.Parameters.AddWithValue("@FlightID", Session["DonusUcusID"].ToString());
                    komut2.Parameters.AddWithValue("@PassengerID", yolcuID);

                    komut2.ExecuteNonQuery();
                }

                // İŞLEM BİTTİ, DİREKT ANASAYFAYA GİT 
                Response.Redirect("Default.aspx");
            }
            catch (Exception ex)
            {
                // Sadece bir hata olursa ekrana hata mesajı basarız
                Response.Write("Bir hata oluştu: " + ex.Message);
            }
            finally
            {
                if (baglanti.State == ConnectionState.Open)
                    baglanti.Close();
            }
        }
    }
}