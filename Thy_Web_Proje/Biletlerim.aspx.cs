using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace Thy_Web_Proje
{
    public partial class Biletlerim : System.Web.UI.Page
    {
        SqlBaglantisi bgl = new SqlBaglantisi();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["KullaniciID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                //Giriş başarılı ise biletleri getiriyoruz
                BiletleriGetir();
            }
        }

        protected void BiletleriGetir()
        {
            //Sessionumuzdan kullanıcı ID mizi değişkene atıyoruz
            int kullaniciID = Convert.ToInt32(Session["KullaniciID"]);

            using (SqlConnection baglanti = bgl.baglanti())
            {
                //Sql sp mizi komut olarak tanımlıyoruz
                using (SqlCommand komut = new SqlCommand("SP_MyTickets", baglanti))
                {
                    //Sp olduğunu sorgu olmadığını tanımlıyoruz
                    komut.CommandType = System.Data.CommandType.StoredProcedure;

                    // KullanıcıID yi sp mize veriyoruz
                    komut.Parameters.AddWithValue("@PassengerID", kullaniciID);

                    SqlDataAdapter adapter = new SqlDataAdapter(komut);
                    //Dataadapter ile sp mizden dönen verileri datatable a veriyoruz
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);
                    //Repeater ı datalarımızla dolduruyoruz
                    if (dt.Rows.Count > 0)
                    {
                        rptBiletler.DataSource = dt;
                        rptBiletler.DataBind();

                        rptBiletler.Visible = true;
                        pnlNoTickets.Visible = false;
                    }
                    //Eğer dönüş alamadıysak bileti yoktur 
                    else
                    {
                        rptBiletler.Visible = false;
                        pnlNoTickets.Visible = true;
                    }




                }
                
            }
        }
        
        protected void rptBiletler_ItemCommand(Object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Iptal")
            {
                //Bilet iptal tuşuna tıklanırsa o ID ye göre Ticketı siliyoruz 
                int biletID = Convert.ToInt32(e.CommandArgument);
                
                    string sql = "DELETE FROM Tbl_Thy_Ticket WHERE TicketID = @ID";
                using (SqlConnection baglanti = bgl.baglanti())
                {
                    using (SqlCommand komut = new SqlCommand(sql, baglanti))
                    {
                        //atadığımız string ile sql komutunu tetikliyoru o ID ye göre silme işlemi yapıyoruz
                        komut.Parameters.AddWithValue("@ID", biletID);
                        komut.ExecuteNonQuery();
                    }
                }
                Response.Write("<script>alert('Bilet iptal edildi. Mil puanlarınız hesabınıza yüklendi.');</script>");

                // Listeyi güncellemek için tekrar çağırıyoruz
                BiletleriGetir();
            }


        }
    }
}