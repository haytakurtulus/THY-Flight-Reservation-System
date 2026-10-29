<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Biletlerim.aspx.cs" Inherits="Thy_Web_Proje.Biletlerim" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Css/biletlerim.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
   <%-- Tasarım için css ve resimlerin çalışması için style linki  --%>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
     
    <div class="tickets-container">
        <h2 class="page-title">Uçuşlarım</h2>
        <%-- Her bilet için repeater sayesinde ayrı panel oluşturuyor ve her ayrı panele o biletin bilgileri --%>
        <asp:Repeater ID="rptBiletler" runat="server" OnItemCommand="rptBiletler_ItemCommand">
            <ItemTemplate>
                
                <div class="ticket-card">
                    
                    <div class="ticket-left">
                        <span class="brand-rotate">THY</span>
                    </div>
                    
                    <div class="ticket-middle">
                        
                        <div class="route-row">
                            <div class="city-group">
                                <span class="lbl">Kalkış</span>
                                <span class="city-name"><%# Eval("Nereden") %></span>
                            </div>
                            
                            <div class="flight-icon">
                                <i class="fa-solid fa-plane"></i>
                            </div>

                            <div class="city-group" style="text-align:right;">
                                <span class="lbl">Varış</span>
                                <span class="city-name"><%# Eval("Nereye") %></span>
                            </div>
                        </div>

                        <div class="info-grid">
                            <div class="info-item">
                                <span class="lbl">Tarih</span>
                                <span class="val"><%# Eval("Tarih", "{0:dd.MM.yyyy}") %></span>
                            </div>
                            <div class="info-item">
                                <span class="lbl">Saat</span>
                                <span class="val"><%# Eval("Tarih", "{0:HH:mm}") %></span>
                            </div>
                            <div class="info-item">
                                <span class="lbl">Koltuk</span>
                                <span class="val"><%# Eval("Koltuk") %>A</span>
                            </div>
                        </div>
                    </div>

                    <div class="ticket-right">
    <span class="price-tag"><%# Eval("Fiyat") %> TL</span>
    <span class="ticket-no">Bilet No: #<%# Eval("TicketID") %></span>
    <%-- Bilet iptal butonu için --%>
    <asp:LinkButton ID="btnIptal" runat="server" CssClass="btn-detail" 
        CommandName="Iptal" 
        CommandArgument='<%# Eval("TicketID") %>'
        OnClientClick="return confirm('Biletinizi iptal etmek istediğinize emin misiniz? \n(Bilet tutarının %10\'u kadar Mil puanı hesabınıza yüklenecektir.)');">
        Bilet İptal
    </asp:LinkButton>

</div>

                </div>

            </ItemTemplate>
        </asp:Repeater>
        <%-- Eğer bileti yoksa gözükmesi için --%>
        <asp:Panel ID="pnlNoTickets" runat="server" Visible="false" style="text-align:center; margin-top:50px;">
            <h3 style="color:#888;">Henüz aktif bir uçuşunuz bulunmuyor.</h3>
            <a href="Default.aspx" style="color:#c41230; font-weight:bold;">Uçuş Ara</a>
        </asp:Panel>

    </div>

</asp:Content>