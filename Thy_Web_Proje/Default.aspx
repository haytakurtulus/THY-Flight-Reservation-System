<%@ Page Title="Anasayfa" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Thy_Web_Proje.Default" %>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        body {
            /*Arka plan resmi olarak kullanacağım resmin adresi ve özellikleri*/
            background-image: url('Resimler/PeakLoading.jpg');
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center center;
            background-attachment: fixed;
        }
    </style>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="main-container">
        
        <div class="header-bar">
            <h2>Uçuş Ara</h2>
            <asp:Label ID="lblKullanici" runat="server" Font-Bold="true" ForeColor="#333"></asp:Label>
        </div>

        <asp:Label ID="lblDurum" runat="server" ForeColor="Red" Font-Bold="true"></asp:Label>

        <div class="search-box">
            <div style="margin-bottom: 15px;">
                <span>Yön Seçimi:</span>
                <asp:RadioButtonList ID="rbYon" runat="server" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="rbYon_SelectedIndexChanged">
                    <asp:ListItem Value="1" Selected="True">Tek Yön</asp:ListItem>
                    <%-- Bu radio button sayesinde tek yön veya gidiş dönüş yolculuk seçeneğini kullanabilicez --%>
                    <asp:ListItem Value="2" style="margin-left:20px;">Gidiş - Dönüş</asp:ListItem>
                </asp:RadioButtonList>
            </div>

            <div class="form-row">
                <%-- Nereden nereye seçimlerinin yapılabilmesi ve havalimanlarını doldurmamız için dropdown listler ekliyoruz --%>
                <div class="form-group">
                    <span>Nereden:</span>
                    <asp:DropDownList ID="ddlNereden" runat="server"></asp:DropDownList>
                </div>

                <div class="form-group">
                    <span>Nereye:</span>
                    <asp:DropDownList ID="ddlNereye" runat="server"></asp:DropDownList>
                </div>

                <div class="form-group">
                    <span>Gidiş Tarihi:</span>
                    <%-- Tarih seçimleri --%>
                    <asp:TextBox ID="txtTarih" runat="server" TextMode="Date"></asp:TextBox>
                </div>

                <div class="form-group">
                    <span>Dönüş Tarihi:</span>
                    <asp:TextBox ID="txtDonusTarih" runat="server" TextMode="Date" Enabled="false"></asp:TextBox>
                </div>

            </div>

            <div class="btn-container">
                <%-- Arama butonu --%>
                <asp:Button ID="btnAra" runat="server" Text="UÇUŞ BUL" CssClass="btn-search" OnClick="btnAra_Click" />
            </div>
        </div>

        <div style="overflow-x:auto;">
    <asp:GridView ID="gridUcuslar" runat="server" CssClass="ucus-tablosu" AutoGenerateColumns="False" GridLines="None" OnSelectedIndexChanged="gridUcuslar_SelectedIndexChanged">
        <Columns>
            <%-- Arama sonucunda eğer uygun uçuş bulunduysa sergilemek için yer --%>
            <asp:BoundField DataField="FlightID" HeaderText="Uçuş No" />
            <asp:BoundField DataField="Nereden" HeaderText="Kalkış" />
            <asp:BoundField DataField="Nereye" HeaderText="Varış" />
            <asp:BoundField DataField="TimeandDate" HeaderText="Tarih / Saat" />
            <asp:BoundField DataField="Price" HeaderText="Fiyat (TL)" />
            
            <%-- Kullanıcının alması için seç butonu --%>
            <asp:CommandField ShowSelectButton="True" SelectText="Seç" ButtonType="Button" ControlStyle-CssClass="btn-search" />
        </Columns>
    </asp:GridView>
</div>

    </div>

</asp:Content>