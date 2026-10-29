<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="Thy_Web_Proje.Register" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Kayıt Ol - THY</title>
    <%-- Tasarım.css dosyamızı html e bağlıyoruz --%>
    <link href="Css/Tasarim.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-box">
            <h2>Kayıt Ol</h2>
            <%-- Kullanıcının kayıt için gerekli verilerini girmesi için gerekli kutucuklar ve onları tanımlayacak olan labelleri giriyoruz --%>
            <asp:Label ID="Label3" runat="server" Text="Ad:"></asp:Label>
            <br />
            <asp:TextBox ID="txtAd" runat="server" PlaceHolder="Adınız"></asp:TextBox>
            <br /><br />

            <asp:Label ID="Label4" runat="server" Text="Soyad:"></asp:Label>
            <br />
            <asp:TextBox ID="txtSoyad" runat="server" PlaceHolder="Soyadınız"></asp:TextBox>
            <br /><br />

            <asp:Label ID="Label1" runat="server" Text="E-Posta:"></asp:Label>
            <br />
            <asp:TextBox ID="txtEmail" runat="server" PlaceHolder="ornek@thy.com"></asp:TextBox>
            <br /><br />

            <asp:Label ID="Label2" runat="server" Text="Şifre:"></asp:Label>
            <br />
            <asp:TextBox ID="txtSifre" runat="server" TextMode="Password" PlaceHolder="******"></asp:TextBox>
            <br /><br />
            <%-- Kayıt tamamlamak için gerekli tuş --%>
            <asp:Button ID="btnKayitTamamla" runat="server" Text="Üyeliği Tamamla" OnClick="btnKayitTamamla_Click" />
            
            <br /><br />
            <asp:Label ID="lblSonuc" runat="server" ForeColor="Red"></asp:Label>
        </div>
    </form>
</body>
</html>