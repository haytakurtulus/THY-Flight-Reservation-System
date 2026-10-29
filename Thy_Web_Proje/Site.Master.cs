using System;
using System.Web.UI;

namespace Thy_Web_Proje
{
    public partial class Site : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Rol"] != null)
            {
                string rol = Session["Rol"].ToString();

                //Admin panelini şirket sahibi dahil göremez yani sadece RolID si 2 olan adminler görebilir
                if (rol == "2")
                {
                    liAdminPanel.Visible = true;
                }

                //Şirket panelini hem admin hemde şirket sahibi görebilir
                if (rol == "2" || rol == "3")
                {
                    liBossPanel.Visible = true;
                }
            }
        }
        //Nav barında ki butonların tıklama durumunda yapacağı yönlendirmeler
        protected void btnUcusBul_Click(object sender, EventArgs e)
        {
            Response.Redirect("Default.aspx");
        }

        protected void btnBiletlerim_Click(object sender, EventArgs e)
        {
            Response.Redirect("Biletlerim.aspx");
        }

        protected void btnProfil_Click(object sender, EventArgs e)
        {
            Response.Redirect("Profil.aspx");
        }

        
        protected void btnAdminGit_Click(object sender, EventArgs e)
        {
            Response.Redirect("Admin.aspx");
        }

        
        protected void btnBossGit_Click(object sender, EventArgs e)
        {
            Response.Redirect("Boss.aspx");
        }

        protected void btnCikis_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Session.Clear();
            Response.Redirect("Login.aspx");
        }
    }
}