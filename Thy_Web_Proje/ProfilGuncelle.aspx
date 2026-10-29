<%@ Page Title="Bilgileri Güncelle" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProfilGuncelle.aspx.cs" Inherits="Thy_Web_Proje.ProfilGuncelle" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Css/profil.css" rel="stylesheet" />
    <style>
        /* Form elemanları için düzenlemeler */
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            margin-top: 5px;
            font-size: 14px;
        }
        .text-muted {
            color: #888;
            font-size: 12px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="profile-container">
        <div class="profile-card">
            <%-- Profil formu başlık --%>
            <div class="profile-header">
                <div class="avatar-circle">
                    <i class="fa fa-edit"></i>
                </div>
                <h2 class="profile-name">Bilgilerimi Güncelle</h2>
                <p style="color:white; opacity:0.8;">Lütfen bilgilerinizi eksiksiz giriniz.</p>
            </div>

            <div style="text-align:center; margin-top:15px;">
                <asp:Label ID="lblMesaj" runat="server" Font-Bold="true"></asp:Label>
            </div>

            <div class="profile-details">
                
                <div class="detail-item">
                    <%-- Ad soyad  E mail değiştirilemez --%>
                    <label>Ad Soyad</label>
                    <asp:TextBox ID="txtAdSoyad" runat="server" CssClass="form-control" Enabled="false" BackColor="#eee"></asp:TextBox>
                    <span class="text-muted">* Güvenlik nedeniyle değiştirilemez.</span>
                </div>

                <div class="detail-item">
                    <label>Email Adresi</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" Enabled="false" BackColor="#eee"></asp:TextBox>
                </div>

                <div class="detail-item">
                    <%-- Değiştirilebilir bilgiler Tel No Tc Doğum Tarihi --%>
                    <label>Telefon Numarası</label>
                    <asp:TextBox ID="txtTelefon" runat="server" CssClass="form-control" placeholder="(5XX) XXX XX XX"></asp:TextBox>
                </div>

                <div class="detail-item">
                    <label>TC Kimlik No</label>
                    <asp:TextBox ID="txtTC" runat="server" CssClass="form-control" MaxLength="11" placeholder="11 Haneli TC Kimlik No"></asp:TextBox>
                </div>

                <div class="detail-item">
                    <label>Doğum Tarihi</label>
                    <asp:TextBox ID="txtDogumTarihi" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                </div>

            </div>

            <div class="profile-actions" style="display:flex; justify-content:space-between;">
                <asp:Button ID="btnIptal" runat="server" Text="Vazgeç" CssClass="btn-update" BackColor="#555" OnClick="btnIptal_Click" />
                <%-- Kayıt butonu ve İptal butonu --%>
                <asp:Button ID="btnKaydet" runat="server" Text="Değişiklikleri Kaydet" CssClass="btn-update" OnClick="btnKaydet_Click" />
            </div>

        </div>
    </div>

</asp:Content>