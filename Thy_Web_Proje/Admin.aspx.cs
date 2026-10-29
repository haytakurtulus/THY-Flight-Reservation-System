using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

namespace Thy_Web_Proje
{
    public partial class Admin : System.Web.UI.Page
    {
        SqlBaglantisi bgl = new SqlBaglantisi();

        protected void Page_Load(object sender, EventArgs e)
        {
            
            //Sadece admin ulaşabilir
            if (Session["Rol"] == null || Session["Rol"].ToString() != "2")
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                //sayfaya veri doldur
                DropdownlariDoldur();
                UcuslariListele();
            }
        }

        // verileri çekme
        void DropdownlariDoldur()
        {
            using (SqlConnection baglanti = bgl.baglanti())
            {
                // Şehirleri Çek 
                SqlCommand komutSehir = new SqlCommand("SELECT * FROM Tbl_Thy_Airport", baglanti);
                SqlDataAdapter daSehir = new SqlDataAdapter(komutSehir);
                DataTable dtSehir = new DataTable();
                daSehir.Fill(dtSehir);

                // Nereden
                ddlNereden.DataSource = dtSehir;
                ddlNereden.DataTextField = "City"; 
                ddlNereden.DataValueField = "AirportID";
                ddlNereden.DataBind();

                // Nereye
                ddlNereye.DataSource = dtSehir;
                ddlNereye.DataTextField = "City";
                ddlNereye.DataValueField = "AirportID";
                ddlNereye.DataBind();

                // Uçakları Çek
                SqlCommand komutUcak = new SqlCommand("SELECT * FROM Tbl_Thy_Plane", baglanti);
                SqlDataAdapter daUcak = new SqlDataAdapter(komutUcak);
                DataTable dtUcak = new DataTable();
                daUcak.Fill(dtUcak);

                ddlUcak.DataSource = dtUcak;
                ddlUcak.DataTextField = "Model"; 
                ddlUcak.DataValueField = "PlaneID";
                ddlUcak.DataBind();
            }
        }

        void UcuslariListele()
        {
            using (SqlConnection baglanti = bgl.baglanti())
            {
                // SQL prosedürü ile uçuş listesi
                using (SqlCommand komut = new SqlCommand("SP_GetFlightList", baglanti))
                {
                    // Bunun bir prosedür olduğunu belirtiyoruz (Çok Önemli!)
                    komut.CommandType = CommandType.StoredProcedure;
                    //getirilen verileri datatable a geçir 
                    SqlDataAdapter da = new SqlDataAdapter(komut);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    //Datatabledan gridUcuslara a aktar
                    gridUcuslar.DataSource = dt;
                    gridUcuslar.DataBind();
                }
            }
        }

        // Uçuş ekleme
        protected void btnEkle_Click(object sender, EventArgs e)
        {
            using (SqlConnection baglanti = bgl.baglanti())
            {
                using (SqlCommand komut = new SqlCommand("SP_AddFlight", baglanti))
                {
                    komut.CommandType = CommandType.StoredProcedure;
                    //Uçuş ekleyebilmek için eklemek istediğimiz uçuşun bilgilerini  tarihini ve saatini prosedüre aktarıyoruz
                    komut.Parameters.AddWithValue("@FromID", ddlNereden.SelectedValue);
                    komut.Parameters.AddWithValue("@WhereID", ddlNereye.SelectedValue);

                    
                    string tarihSaatBirlestir = txtTarih.Text + " " + txtSaat.Text;

                    // Sql e uygun formata çeviriyoruz
                    komut.Parameters.AddWithValue("@TimeandDate", Convert.ToDateTime(tarihSaatBirlestir));
                    

                    komut.Parameters.AddWithValue("@PlaneID", ddlUcak.SelectedValue);
                    komut.Parameters.AddWithValue("@Price", Convert.ToDouble(txtFiyat.Text));

                    komut.ExecuteNonQuery();
                }
            }
            Response.Write("<script>alert('Yeni uçuş başarıyla oluşturuldu.');</script>");
            //Yeni uçuş eklendikten sonra tekrardan listele
            UcuslariListele();
        }

        // Tablo içinde fiyat güncellemek ve uçuş iptali için
        protected void gridUcuslar_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "UcusIptal")
            {
                int ucusID = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection baglanti = bgl.baglanti())
                {
                    // İPTAL Prosedürü
                    using (SqlCommand komut = new SqlCommand("SP_CancelFlight", baglanti))
                    {
                        komut.CommandType = CommandType.StoredProcedure;
                        komut.Parameters.AddWithValue("@FlightID", ucusID);
                        komut.ExecuteNonQuery();
                    }
                }
                Response.Write("<script>alert('Uçuş iptal edildi.');</script>");
                UcuslariListele();
            }

            else if (e.CommandName == "FiyatGuncelle")
            {
                // GridView içinde satır indeksini buluyoruz
                int index = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = gridUcuslar.Rows[index];

                // O satırdaki FlightID yi alıyoruz 
                int ucusID = Convert.ToInt32(row.Cells[0].Text);

                // O satırdaki TextBox dan bulup içindeki yeni fiyatı alıyoruz
                TextBox txtYeniFiyat = (TextBox)row.FindControl("txtGridFiyat");
                double yeniFiyat = Convert.ToDouble(txtYeniFiyat.Text);

                using (SqlConnection baglanti = bgl.baglanti())
                {
                    // Güncelleme Prosedürü
                    using (SqlCommand komut = new SqlCommand("SP_UpdatePrice", baglanti))
                    {
                        komut.CommandType = CommandType.StoredProcedure;
                        komut.Parameters.AddWithValue("@FlightID", ucusID);
                        komut.Parameters.AddWithValue("@NewPrice", yeniFiyat);
                        komut.ExecuteNonQuery();
                    }
                }
                Response.Write("<script>alert('Fiyat güncellendi.');</script>");
                UcuslariListele();
            }
        }
    }
}