using System;
using System.Data;
using System.Data.SqlClient;
using System.Drawing; // Renkler için
using System.Web.UI.WebControls;

namespace Thy_Web_Proje
{
    public partial class Boss : System.Web.UI.Page
    {
        SqlBaglantisi bgl = new SqlBaglantisi();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Giriş Kontrolü (Rol 3)
            if (Session["Rol"] == null || (Session["Rol"].ToString() != "3" && Session["Rol"].ToString()!="2"))
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                KartlariDoldur();
                RaporlariGetir();
                LoglariGetir();
            }
        }

        void KartlariDoldur()
        {
            using (SqlConnection baglanti = bgl.baglanti())
            {
                using (SqlCommand komut = new SqlCommand("SP_BossStats", baglanti))
                {
                    SqlDataReader dr = komut.ExecuteReader();
                    if (dr.Read())
                    {
                        //Boss Stats Prosedürü ile toplam kar yolcu sayısı ve uçuş sayısı gibi TOPLAM değerler çekiyoruz
                        lblCiro.Text = dr["ToplamKasa"] != DBNull.Value ? Convert.ToDouble(dr["ToplamKasa"]).ToString("C") : "0 ₺";
                        lblYolcu.Text = dr["ToplamYolcu"].ToString();
                        lblUcusSayisi.Text = dr["ToplamUcus"].ToString();
                    }
                }
            }
        }

        void RaporlariGetir()
        {
            using (SqlConnection baglanti = bgl.baglanti())
            {
                //BossReport Sql Sorgusu Sayesinde her uçuşa özel veri çekiyoruz
                SqlDataAdapter da = new SqlDataAdapter("SP_BossReport", baglanti);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gridFinans.DataSource = dt;
                gridFinans.DataBind();
            }
        }

        void LoglariGetir()
        {
            using (SqlConnection baglanti = bgl.baglanti())
            {
                // 1. FİYAT LOGLARI 
                SqlDataAdapter da1 = new SqlDataAdapter("SELECT TOP 10 * FROM Tbl_Thy_PriceLogs ORDER BY ChangeTime DESC", baglanti);
                DataTable dt1 = new DataTable();
                da1.Fill(dt1);
                gridLogFiyat.DataSource = dt1;
                gridLogFiyat.DataBind();

                //  İPTAL LOGLARI 
                
                using (SqlCommand komut = new SqlCommand("SP_GetCancelLogs", baglanti))
                {
                    komut.CommandType = CommandType.StoredProcedure; 
                    // Bunun bir prosedür olduğunu belirtiyoruz

                    SqlDataAdapter da2 = new SqlDataAdapter(komut);
                    DataTable dt2 = new DataTable();
                    da2.Fill(dt2);

                    gridLogIptal.DataSource = dt2;
                    gridLogIptal.DataBind();
                }
            }
        }

        // Doluluk oranına göre satır renklendirme
        protected void gridFinans_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Doluluk yüzdesini al 
                string oranStr = e.Row.Cells[4].Text;
                int oran = 0;
                int.TryParse(oranStr, out oran);

                if (oran >= 80)
                {
                    e.Row.Cells[4].ForeColor = Color.Green;
                    e.Row.Cells[4].Font.Bold = true;
                    e.Row.Cells[4].Text += " 🔥";
                }
                else if (oran < 30)
                {
                    e.Row.Cells[4].ForeColor = Color.Red;
                    e.Row.Cells[4].Text += " ⚠️";
                }
            }
        }
    }
}