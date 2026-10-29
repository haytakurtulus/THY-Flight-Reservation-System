<%@ Page Title="Profil" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Profil.aspx.cs" Inherits="Thy_Web_Proje.Profil" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Css/Profil.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <%-- Css ve style linkimiz --%>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="profile-container">
        
        <div class="profile-card">
            
            <div class="profile-header">
                
                <div class="logo-container">
                    <img src="Resimler/Thy_Logo.png" alt="THY Logo" style="height: 60px; width: auto;" />
                </div>

                <h2 class="profile-name">
                    <%-- Eğer daha profil verileri çekilemediyse yükleniyor olarak gözükücek --%>
                    <asp:Label ID="Profil_HeaderAdSoyad" runat="server" Text="Yükleniyor..."></asp:Label>
                </h2>
                <span class="membership-badge">
                    <asp:Label ID="Profil_Statu" runat="server" Text="Classic Üye"></asp:Label>
                </span>
            </div>

            <div class="miles-container">
                <div class="miles-info">
                    <%-- Toplam Mil puanı  --%>
                    <div class="miles-label">Toplam Mil Puanınız</div>
                    <div class="miles-value">
                        <asp:Label ID="Profil_MilPuan" runat="server" Text="0" ForeColor="White" Font-Bold="true"></asp:Label> 
                        <span class="mil-unit">Mil</span>
                    </div>
                </div>
                <div class="mil-icon">
                    <i class="fa fa-plane-departure"></i>
                </div>
            </div>

            <div class="profile-details">
                
                <div class="detail-item">
                    <%-- Kullanıcı verileri için label --%>
                    <label><i class="fa fa-hashtag"></i> Kullanıcı ID</label>
                    <asp:Label ID="Profil_KullaniciID" runat="server" CssClass="detail-text" Text="-"></asp:Label>
                </div>

                <div class="detail-item">
                    <label><i class="fa fa-envelope"></i> Email Adresi</label>
                    <asp:Label ID="Profil_Email" runat="server" CssClass="detail-text" Text="-"></asp:Label>
                </div>

                <div class="detail-item">
                    <label><i class="fa fa-user"></i> Ad</label>
                    <asp:Label ID="Profil_Ad" runat="server" CssClass="detail-text" Text="-"></asp:Label>
                </div>

                <div class="detail-item">
                    <label><i class="fa fa-user"></i> Soyad</label>
                    <asp:Label ID="Profil_Soyad" runat="server" CssClass="detail-text" Text="-"></asp:Label>
                </div>

                <div class="detail-item">
                    <label><i class="fa fa-phone"></i> Telefon Numarası</label>
                    <asp:Label ID="Profil_Telefon" runat="server" CssClass="detail-text" Text="-"></asp:Label>
                </div>

                <div class="detail-item">
                    <label><i class="fa fa-id-card"></i> TC Kimlik No</label>
                    <asp:Label ID="Profil_TCKN" runat="server" CssClass="detail-text" Text="-"></asp:Label>
                </div>

                <div class="detail-item">
                    <label><i class="fa fa-birthday-cake"></i> Doğum Tarihi</label>
                    <asp:Label ID="Profil_DogumTarihi" runat="server" CssClass="detail-text" Text="-"></asp:Label>
                </div>
                
                <div class="detail-item" style="border:none;"></div> 

            </div>
            <%-- Bilgileri güncelleme butonu gerekli sayfaya atıcak --%>
            <div class="profile-actions">
                <asp:Button ID="Btn_BilgileriGuncelle" runat="server" Text="Bilgileri Güncelle" CssClass="btn-update" OnClick="Btn_BilgileriGuncelle_Click" />
            </div>

        </div>
    </div>

</asp:Content>