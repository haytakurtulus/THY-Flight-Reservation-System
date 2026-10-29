<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="Thy_Web_Proje.Admin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Css/Tasarim.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        
        <div class="card">
            <div class="card-header bg-primary text-white">

                <%-- Admin sayfasında yeni uçuş ekleme bölmesi --%>
                <h4>Yeni Uçuş Planla</h4>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-3">
                        <%-- Yeni uçuş bilgilerini almak için gerekli alanlar --%>
                        <label>Nereden:</label>
                        <asp:DropDownList ID="ddlNereden" runat="server" CssClass="form-control"></asp:DropDownList>
                    </div>
                    
                    <div class="col-md-3">
                        <label>Nereye:</label>
                        <asp:DropDownList ID="ddlNereye" runat="server" CssClass="form-control"></asp:DropDownList>
                    </div>

                    <div class="col-md-2">
                        <label>Tarih:</label>
                        <asp:TextBox ID="txtTarih" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                    </div>

                    <div class="col-md-2">
                        <label>Saat:</label>
                        <asp:TextBox ID="txtSaat" runat="server" CssClass="form-control" TextMode="Time"></asp:TextBox>
                    </div>
                    <div class="col-md-2">
                         <label>Uçak Seçimi:</label>
                         <asp:DropDownList ID="ddlUcak" runat="server" CssClass="form-control"></asp:DropDownList>
                    </div>
                </div>
                
                <div class="row mt-3">
                    <div class="col-md-3">
                        <label>Bilet Fiyatı (TL):</label>
                        <asp:TextBox ID="txtFiyat" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="col-md-9 mt-4">
                        <asp:Button ID="btnEkle" runat="server" Text="Uçuşu Sisteme Ekle" CssClass="btn btn-success btn-block" OnClick="btnEkle_Click" />
                    </div>
                </div>
            </div>
        </div>

        <hr />

        <h3 class="text-center">Aktif Uçuş Yönetimi</h3>
        <%-- Aktif uçuş iptali, kontrolü ve fiyat değişikliği için alan --%>
        <div class="table-responsive">
            <asp:GridView ID="gridUcuslar" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-bordered" OnRowCommand="gridUcuslar_RowCommand">
                <Columns>
                    <asp:BoundField DataField="FlightID" HeaderText="ID" />
                    
                    <asp:BoundField DataField="Rota" HeaderText="Güzergah" />
                    <asp:BoundField DataField="TimeandDate" HeaderText="Tarih" />
                    <asp:BoundField DataField="DolulukOrani" HeaderText="Doluluk %" ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="Model" HeaderText="Uçak Modeli" />

                    <asp:TemplateField HeaderText="Fiyat Güncelleme">
                        <ItemTemplate>
                            <asp:TextBox ID="txtGridFiyat" runat="server" Text='<%# Eval("Price") %>' CssClass="form-control d-inline-block" Width="100px"></asp:TextBox>
                            
                            <asp:LinkButton ID="btnGuncelle" runat="server" CommandName="FiyatGuncelle" CommandArgument='<%# Container.DataItemIndex %>' CssClass="btn btn-warning btn-sm">
                                <i class="fas fa-sync-alt"></i> Güncelle
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="İşlemler">
                        <ItemTemplate>
                            <asp:Button ID="btnIptal" runat="server" Text="UÇUŞU İPTAL ET" CommandName="UcusIptal" CommandArgument='<%# Eval("FlightID") %>' CssClass="btn btn-danger btn-sm" OnClientClick="return confirm('Bu uçuşu iptal etmek istediğinize emin misiniz? Biletler silinecektir.');" />
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>
            </asp:GridView>
        </div>

    </div>
</asp:Content>