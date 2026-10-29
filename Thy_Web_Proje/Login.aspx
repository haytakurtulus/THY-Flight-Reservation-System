<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Thy_Web_Proje.Login" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Giriş Yap</title>
    <%-- Tasarım.css imizi ekliyoruz dış görünül için --%>
    <link href="Css/Tasarim.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-box">
            <%-- Sayfanın tarayıcı penceresinde gözükecek olan başlığı --%>
            <h2>Giriş Yap</h2>
            
            <asp:Label ID="Label1" runat="server" Text="E-Posta Adresi:"></asp:Label>
            <br />
            <%-- Kullanıcının mailini girebilmesi için olan txtbox ve fikir olması için örnek placeholder --%>
            <asp:TextBox ID="txtEmail" runat="server" PlaceHolder="ornek@thy.com"></asp:TextBox>
            <br /><br />
            <%-- Kullanıcının şifre girmesi için txtbox --%>
            <asp:Label ID="Label2" runat="server" Text="Şifre:"></asp:Label>
            <br />
            <asp:TextBox ID="txtSifre" runat="server" TextMode="Password" PlaceHolder="******"></asp:TextBox>
            <br /><br />
            <%-- Giriş butonu --%>
            <asp:Button ID="btnGiris" runat="server" Text="Giriş Yap" OnClick="btnGiris_Click" />
            
     
            
            <br /><br />
            
            <asp:Button ID="btnKayitOl" runat="server" Text="Kayıt Ol" OnClick="btnKayitOl_Click" BackColor="#333" />
            <asp:Label ID="lblSonuc" runat="server" ForeColor="Red"></asp:Label>
        </div>
    </form>
</body>
</html>