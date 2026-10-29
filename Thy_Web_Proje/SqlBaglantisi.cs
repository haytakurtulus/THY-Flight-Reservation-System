using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
// SQL Server ile iletişim kurmamızı sağlayan temel kütüphane
using System.Data.SqlClient; 

namespace Thy_Web_Proje
{
    public class SqlBaglantisi
    {
        public SqlConnection baglanti()
        {
            //Bağlanmasını istediğim database imi ve güvelik bilgilerini giriyorum
            SqlConnection baglan = new SqlConnection(@"Data Source=.;Initial Catalog=Thy_Proje;Integrated Security=True");
            // Bağlantıyı burada açıp gönderiyorum her  çağırdığım yerde bir de .Open() yazmakla uğraşmayayım
            baglan.Open();
            // açık olan bağlantıyı kullanılması için gönderiyorum
            return baglan;
        }
    }
}