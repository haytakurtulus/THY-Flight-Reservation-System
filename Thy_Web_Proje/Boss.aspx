<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Boss.aspx.cs" Inherits="Thy_Web_Proje.Boss" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Css/boss.css" rel="stylesheet" />
    <%-- Css dosyamız --%>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        
        <h2 class="mb-4 text-center">Şirket Yönetim Paneli</h2>
        <%-- Toplam Ciro --%>
        <div class="row">
            <div class="col-md-4">
                <div class="card-box bg-money">
                    <h3><i class="fas fa-wallet"></i> Toplam Ciro</h3>
                    <asp:Label ID="lblCiro" runat="server" Text="0 TL" Font-Size="X-Large" Font-Bold="true"></asp:Label>
                </div>
            </div>
            <%-- Toplam Yolcu Sayısı --%>
            <div class="col-md-4">
                <div class="card-box bg-users">
                    <h3><i class="fas fa-users"></i> Toplam Yolcu</h3>
                    <asp:Label ID="lblYolcu" runat="server" Text="0" Font-Size="X-Large" Font-Bold="true"></asp:Label>
                </div>
            </div>
            <%-- Aktif uçuş sayısı --%>
            <div class="col-md-4">
                <div class="card-box bg-flight">
                    <h3><i class="fas fa-plane"></i> Aktif Uçuş</h3>
                    <asp:Label ID="lblUcusSayisi" runat="server" Text="0" Font-Size="X-Large" Font-Bold="true"></asp:Label>
                </div>
            </div>
        </div>
        <%-- Finansal Rapor  Bölgesi ve içinde tüm uçuşların listesi ve bilgileri --%>
        <div class="card mb-4">
            <div class="card-header bg-dark text-white">
                <i class="fas fa-chart-line"></i> Finansal Rapor
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <asp:GridView ID="gridFinans" runat="server" AutoGenerateColumns="False" CssClass="table table-hover table-striped" OnRowDataBound="gridFinans_RowDataBound">
                        <Columns>
                            <asp:BoundField DataField="Rota" HeaderText="Güzergah" />
                            <asp:BoundField DataField="SoldSeats" HeaderText="Bilet" />
                            <asp:BoundField DataField="ToplamCiro" HeaderText="Ciro" DataFormatString="{0:C}" />
                            <asp:BoundField DataField="ToplamKDV" HeaderText="KDV" DataFormatString="{0:C}" />
                            <asp:BoundField DataField="DolulukYuzdesi" HeaderText="Doluluk %" ItemStyle-Font-Bold="true" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
        <%-- Fiyat değişikliği Logları --%>
        <div class="row">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-warning">
                        <i class="fas fa-history"></i> Fiyat Değişimleri
                    </div>
                    <div class="card-body">
                        <asp:GridView ID="gridLogFiyat" runat="server" CssClass="table table-sm table-bordered" AutoGenerateColumns="False">
                            <Columns>
                                <asp:BoundField DataField="FlightID" HeaderText="Uçuş ID" />
                                <asp:BoundField DataField="OldPrice" HeaderText="Eski Fiyat" />
                                <asp:BoundField DataField="NewPrice" HeaderText="Yeni Fiyat" />
                                <asp:BoundField DataField="ChangeTime" HeaderText="Tarih" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
            <%-- İptal edilen Uçuş logları --%>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-danger text-white">
                        <i class="fas fa-trash-alt"></i> İptal Edilen Uçuşlar
                    </div>
                    <div class="card-body">
                        <asp:GridView ID="gridLogIptal" runat="server" CssClass="table table-sm table-bordered" AutoGenerateColumns="False">
                             <Columns>
                                <asp:BoundField DataField="FlightID" HeaderText="ID" />
                                <asp:BoundField DataField="Rota" HeaderText="Rota" />
                                <asp:BoundField DataField="OriginalDateTime" HeaderText="Uçuş Tarihi" />
                                <asp:BoundField DataField="CancelDateTime" HeaderText="İptal Tarihi" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>

    </div>
</asp:Content>