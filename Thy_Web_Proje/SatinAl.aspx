<%@ Page Title="Bilet Satın Al" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SatinAl.aspx.cs" Inherits="Thy_Web_Proje.SatinAl" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%-- Satın al sayfamız için gerekli olan css --%>
    <link href="Css/satinal.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <%-- Thy logo bu linkle çalışıyor--%>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="payment-container">
        
        <div class="ticket-card">
            
            <div class="ticket-header">
                <h2>Bilet Özeti ve Onay</h2>
                <div class="header-logo">
                    <img src="Resimler/Thy_Logo.png" alt="THY">
                </div>
            </div>

            <div class="ticket-body">
                <%-- Gidiş uçuşunu sergilemek için gerekli olan Panel ve üstünde ki bilgiler için gerekli labellar --%>
                <asp:Panel ID="pnlGidis" runat="server" CssClass="flight-section">
                    <span class="section-title"><i class="fa fa-plane-departure"></i> Gidiş Uçuşu</span>
                    
                    <div class="flight-route">
                        <asp:Label ID="lblGidisNereden" runat="server" CssClass="city"></asp:Label>
                        <i class="fa fa-long-arrow-alt-right plane-icon"></i>
                        <asp:Label ID="lblGidisNereye" runat="server" CssClass="city"></asp:Label>
                    </div>

                    <div class="flight-details-grid">
                        <div class="info-box">
                            <span>Tarih</span>
                            <asp:Label ID="lblGidisTarih" runat="server" Font-Bold="true"></asp:Label>
                        </div>
                        <div class="info-box">
                            <span>Saat</span>
                            <asp:Label ID="lblGidisSaat" runat="server" Font-Bold="true"></asp:Label>
                        </div>
                        <div class="info-box">
                            <span>Uçuş No</span>
                            <asp:Label ID="lblGidisNo" runat="server" Font-Bold="true"></asp:Label>
                        </div>
                        <div class="info-box">
                            <span>Fiyat</span>
                            <asp:Label ID="lblGidisFiyat" runat="server" Font-Bold="true" ForeColor="#c41230"></asp:Label>
                        </div>
                    </div>
                </asp:Panel>
                                <%-- Dönüş uçuşunu sergilemek için gerekli olan Panel ve üstünde ki bilgiler için gerekli labellar --%>

                <asp:Panel ID="pnlDonus" runat="server" CssClass="flight-section" Visible="false">
                    <span class="section-title"><i class="fa fa-plane-arrival"></i> Dönüş Uçuşu</span>
                    
                    <div class="flight-route">
                        <asp:Label ID="lblDonusNereden" runat="server" CssClass="city"></asp:Label>
                        <i class="fa fa-long-arrow-alt-left plane-icon"></i>
                        <asp:Label ID="lblDonusNereye" runat="server" CssClass="city"></asp:Label>
                    </div>

                    <div class="flight-details-grid">
                        <div class="info-box">
                            <span>Tarih</span>
                            <asp:Label ID="lblDonusTarih" runat="server" Font-Bold="true"></asp:Label>
                        </div>
                        <div class="info-box">
                            <span>Saat</span>
                            <asp:Label ID="lblDonusSaat" runat="server" Font-Bold="true"></asp:Label>
                        </div>
                        <div class="info-box">
                            <span>Uçuş No</span>
                            <asp:Label ID="lblDonusNo" runat="server" Font-Bold="true"></asp:Label>
                        </div>
                        <div class="info-box">
                            <span>Fiyat</span>
                            <asp:Label ID="lblDonusFiyat" runat="server" Font-Bold="true" ForeColor="#c41230"></asp:Label>
                        </div>
                    </div>
                </asp:Panel>

            </div>
            <%-- Total uçuş ödeme bilgileri --%>
            <div class="payment-summary">
                <div class="total-price">
                    <span>Ödenecek Toplam Tutar</span>
                    <strong>
                        <asp:Label ID="lblToplamFiyat" runat="server" Text="0 TL"></asp:Label>
                    </strong>
                </div>
                <div>
                    <asp:Button ID="btnOnayla" runat="server" Text="ÖDEMEYİ TAMAMLA" CssClass="btn-confirm" OnClick="btnOnayla_Click" />
                </div>
            </div>

        </div>

    </div>
</asp:Content>