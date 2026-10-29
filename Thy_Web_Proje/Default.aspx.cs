using System;
using System.Collections.Generic;
using System.Data; // SqlDataAdapter ve CommandType için gerekli
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Thy_Web_Proje
{
    public partial class Default : System.Web.UI.Page
    {
        //Baglanti nesnemiz
        SqlBaglantisi bgl = new SqlBaglantisi();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Oturum Kontrolü
            if (Session["KullaniciID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // Sayfa Yüklenirken 
            if (!IsPostBack)
            {
                lblKullanici.Text = "Hoşgeldiniz, " + Session["AdSoyad"];
                HavalimanlariniGetir();
                //Gidiş ve dönüş tarihi dün olamaz
                txtTarih.Attributes["min"] = DateTime.Now.ToString("yyyy-MM-dd");
                txtDonusTarih.Attributes["min"] = DateTime.Now.ToString("yyyy-MM-dd");
            }
        }

        // Havalimanlarını Dropdown'a dolduran metod
        void HavalimanlariniGetir()
        {
            SqlConnection baglanti = bgl.baglanti();
            //sql sorgusu kullanımı
            SqlCommand komut = new SqlCommand("SELECT * FROM Tbl_Thy_Airport", baglanti);

            try
            {
                SqlDataReader dr = komut.ExecuteReader();
                //Sayfa her yenilendiğinde Dropdown a doldurum yapacağı için şehirleri tekrar eden kayıtın önüne geçmek için
                ddlNereden.Items.Clear();
                ddlNereye.Items.Clear();
                //İlk item seçili olarak Seçiniz... yazısını eklimek için Listeye yeni itemin 0. indisine Onu ekliyoruz
                ddlNereden.Items.Add(new ListItem("Seçiniz...", "0"));
                ddlNereye.Items.Add(new ListItem("Seçiniz...", "0"));

                while (dr.Read())
                {
                    ListItem item = new ListItem();
                    //Kullanıcıya havalimanı adı ve kodunu gösteriyoruz
                    item.Text = dr["City"].ToString() + " (" + dr["Code"].ToString() + ")";
                    // Arka planda ise AirportID tutuyoruz
                    item.Value = dr["AirportID"].ToString();

                    ddlNereden.Items.Add(item);
                    // Dropdown elemanlarını kopyalamak yerine yeni instance oluşturuyoruz
                    ddlNereye.Items.Add(new ListItem(item.Text, item.Value));
                }
            }
            catch (Exception) {
            // Olası hatas durumu için
            
            }
            finally { baglanti.Close(); 
            }
            //Hata yoksa bile 
        }

        // Radyo Buton Değişimi Tek Yön / Gidiş Dönüş
        protected void rbYon_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rbYon.SelectedValue == "2") // Gidiş - Dönüş
            {
                txtDonusTarih.Enabled = true;
            }
            else // Tek Yön
            {
                txtDonusTarih.Enabled = false;
                txtDonusTarih.Text = "";
            }
        }

        // UÇUŞ BUL Butonu Tıklanınca
        protected void btnAra_Click(object sender, EventArgs e)
        {
            // Uçuş arama için herhangi bir veri eksik olması durumunda
            if (ddlNereden.SelectedValue == "0" || ddlNereye.SelectedValue == "0" || string.IsNullOrEmpty(txtTarih.Text))
            {
                lblDurum.Text = "Lütfen kalkış, varış ve tarih bilgilerini eksiksiz giriniz.";
                return;
            }
            if (rbYon.SelectedValue == "2" && !string.IsNullOrEmpty(txtDonusTarih.Text))
            {
                //Eğer dönüş tarihi gidişten önce ise durdur
                DateTime gidisTarihi = Convert.ToDateTime(txtTarih.Text);
                DateTime donusTarihi = Convert.ToDateTime(txtDonusTarih.Text);

                if (donusTarihi < gidisTarihi)
                {
                    lblDurum.Text = "Hata: Dönüş tarihi, gidiş tarihinden önce olamaz!";
                    return; 
                }
            }
            // Yeni bir arama yapıldığı için önceki seçimleri hafızadan siliyoruz
            Session["GidisUcusID"] = null;
            Session["DonusUcusID"] = null;

            // Uçuşları Listele metodunu çağırıyoruz
            UcuslariListele(ddlNereden.SelectedValue, ddlNereye.SelectedValue, txtTarih.Text);
        }


        void UcuslariListele(string neredenID, string nereyeID, string tarih)
        {
            SqlConnection baglanti = bgl.baglanti();

            // SQL Prosedürünü Çağırıyoruz
            SqlCommand komut = new SqlCommand("SP_ISFLIGHTEXIST", baglanti);
            komut.CommandType = CommandType.StoredProcedure;
            //Sql prosedürümüzün arama yapması için gerekli değişkenleri veriyoruz
            komut.Parameters.AddWithValue("@FromID", neredenID);
            komut.Parameters.AddWithValue("@WhereID", nereyeID);

            // Tarih formatını YYYY-MM-DD olarak ayarlayıp gönderiyoruz
            komut.Parameters.AddWithValue("@SelectedTime", Convert.ToDateTime(tarih).ToString("yyyy-MM-dd"));

            SqlDataAdapter da = new SqlDataAdapter(komut);
            //Datatable da tutuyoruz veriyi
            DataTable dt = new DataTable();
            da.Fill(dt);
            //Gelen sonuçları Gridview e basıyoruz
            gridUcuslar.DataSource = dt;
            gridUcuslar.DataBind();

            if (dt.Rows.Count == 0)
            {
                lblDurum.Text = "Aradığınız kriterlere uygun uçuş bulunamadı.";
                lblDurum.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblDurum.Text = ""; // Hata yoksa temizle
            }

            baglanti.Close();
        }

        // Tablodan "SEÇ" Butonuna 
        protected void gridUcuslar_SelectedIndexChanged(object sender, EventArgs e)
        {
            //  Seçilen satırdaki FlightID'yi al
            GridViewRow row = gridUcuslar.SelectedRow;
            
            string secilenID = row.Cells[0].Text;

            //  Tek Yön mü, Gidiş-Dönüş mü

            //  DURUM A TEK YÖN 
            if (rbYon.SelectedValue == "1")
            {
                Session["GidisUcusID"] = secilenID;
                Session["DonusUcusID"] = null; // Dönüş yok
                Response.Redirect("SatinAl.aspx");
            }
            // DURUM B GİDİŞ - DÖNÜŞ
            else
            {
                // Eğer Gidiş ID'si henüz seçilmemişse bu Gidiş seçimidir
                if (Session["GidisUcusID"] == null)
                {
                    Session["GidisUcusID"] = secilenID;

                    // Kullanıcıya bilgi ver
                    lblDurum.Text = "Gidiş uçuşu seçildi. Lütfen listeden DÖNÜŞ uçuşunu seçiniz.";
                    lblDurum.ForeColor = System.Drawing.Color.Green;

                   
                    // Nereden ve Nereye ID'lerini ters çeviriyoruz 
                    string donusNereden = ddlNereye.SelectedValue;
                    string donusNereye = ddlNereden.SelectedValue;
                    string donusTarihi = txtDonusTarih.Text;

                    // Eğer dönüş tarihi girilmediyse hata ver
                    if (string.IsNullOrEmpty(donusTarihi))
                    {
                        lblDurum.Text = "Gidiş seçildi ancak Dönüş Tarihi boş!";
                        lblDurum.ForeColor = System.Drawing.Color.Red;
                        return;
                    }

                    // Listeyi güncelle 
                    UcuslariListele(donusNereden, donusNereye, donusTarihi);
                }
                // Eğer Gidiş ID'si zaten doluysa, bu Dönüş seçimidir
                else
                {
                    Session["DonusUcusID"] = secilenID;

                    // İkisi de seçildi, ödeme sayfasına git
                    Response.Redirect("SatinAl.aspx");
                }
            }
        }
    }
}