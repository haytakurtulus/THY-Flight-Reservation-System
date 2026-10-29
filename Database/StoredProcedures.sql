--Kullanýcýnýn register kýsmýna gireceði deðerleri aktarmak için deðiþkenler atýyoruz 
Create PROCEDURE SP_Register
    @Ad nvarchar(30),
    @Soyad nvarchar(20),
    @Email nvarchar(50),
    @Sifre nvarchar(30)
AS
BEGIN
    -- Daha önce bu mailin kaydý var mý diye bakýlýr
    IF EXISTS(SELECT * FROM Tbl_Thy_Kullanicilar WHERE Email = @Email)
    BEGIN
        -- Varsa 0 döndür 
        SELECT 0
    END
    ELSE
    BEGIN
        -- Yoksa ekle ve 1 döndür 
        INSERT INTO Tbl_Thy_Kullanicilar (Ad, Soyad, Email, Sifre, RolID)
        VALUES (@Ad, @Soyad, @Email, @Sifre, 1)
        
        SELECT 1
    END
END

Go
-- hesabý bulunan kullanýcýnýn giriþ yapabilmesi için
Create Procedure SP_Login
@Email nvarchar(50),
@Sifre nvarchar(30)
AS
BEGIN
-- varlýk kontrolü
  Select * from Tbl_Thy_Kullanicilar where Email=@Email AND Sifre=@Sifre
End

Go
-- admin in yeni uçuþ ekleyebilmesi için
Create Procedure SP_AddFlight
@FromID int,
--Nereden kalkacak
@WhereID int,
--Nereye inicek
@TimeandDate datetime,
@PlaneID int,
--Uçak modeli
@Price float
As
Begin
-- Flight tablosuna uçuþ eklenir
   Insert Into Tbl_Thy_Flight(FromId,WhereID,TimeandDate,PlaneID,Price,SoldSeats)
   Values(@FromId,@WhereID,@TimeandDate,@PlaneID,@Price,0)
End

Go
-- Uçuþ arama ekraný için spesifik o özelliklerde uçuþ arama
Create PROCEDURE SP_ISFLIGHTEXIST
    @FromID int,
    @WhereID int,
    @SelectedTime date -- Datetime yerine Date yaptýk çünkü bilet arama ekranýnda saate göre giriþ yapamýyoruz
AS
BEGIN
    SELECT 
        F.FlightID,
        A1.City as 'Nereden',
        A2.City as 'Nereye',
        F.TimeandDate,
        F.Price,
        P.Model,
        (P.Kapasite-F.SoldSeats) as 'Kalan Koltuk'
    FROM Tbl_Thy_Flight F
    INNER JOIN Tbl_Thy_Airport A1 On F.FromID=A1.AirportID
    INNER JOIN Tbl_Thy_Airport A2 on F.WhereID=A2.AirportID
    INNER JOIN Tbl_Thy_Plane P on F.PlaneID=P.PlaneID
    --Flight tablosundan uçuþlar çekilir ama ID þeklinde olan verilerin düzgün gözükmesi için bu primeri keyler aracýlýðý ile kendi tablolalarýndan onlara ait isimler çekilir
    WHERE 
        F.FromID = @FromID AND 
        F.WhereID = @WhereID AND
        --Ýstenilen gün, kalkýþ noktasý ve iniþ noktasý
        CAST(F.TimeandDate AS DATE) = @SelectedTime
        -- saatten kurtulmak için date e çevirdik 
END

Go

Create PROCEDURE SP_BuyTicket
    @FlightID int,
    @PassengerID int
AS
--Kullanýcýnýn seçtiiði uçuþun id si ve kullancýnýn id si alýnýr
BEGIN
    Declare @Kapasite int
    Declare @Satilan int
    Declare @YeniKoltukNo int

    -- Kapasite ve Satýlan bilgisini çek
    Select @Kapasite = P.Kapasite, @Satilan = F.SoldSeats 
    from Tbl_Thy_Flight F
    Inner Join Tbl_Thy_Plane P on F.PlaneID = P.PlaneID
    where F.FlightID = @FlightID
    --Uçaðýn model bilgisini al ki koltuk sayýsýný öðrenelim
    -- Yer var mý kontrol
    if @Satilan < @Kapasite
    begin
        -- Varsa sýradaki boþ koltuðu ver
        Set @YeniKoltukNo = @Satilan + 1
        
        --Sadece yeni bilet giriþi yapýyoruz çünkü dolu koltuk sayýsý artýmýný triggerýmýz yapacak
        Insert Into Tbl_Thy_Ticket (FlightID, PassengerID, SeatID, SoldDate)
        Values (@FlightID, @PassengerID, @YeniKoltukNo, GetDate())
    end
END


GO

--Admin uçuþ iptali
Create procedure SP_CancelFlight
@FlightID int
--Ýptal edilecek uçuþ numarasý 
as 
begin
Delete from Tbl_Thy_Ticket where FlightID=@FlightID
-- az önce ticketlarý sýfýrladýk bu sayede trigger otomatik olarak mil puaný ekler
Delete from Tbl_Thy_Flight where FlightID=@FlightID
End

Go
--Admin bir uçuþun fiyatýný güncellemek isterse
CREATE PROCEDURE SP_UpdatePrice
    @FlightID int,
    @NewPrice float 
AS
BEGIN
    UPDATE Tbl_Thy_Flight
    SET Price = @NewPrice
    WHERE FlightID = @FlightID
END

Go
--Kullanýcnýn ticket numarasýna göre o ticketýn iptali için ve mil otomatik artar
CREATE PROCEDURE SP_CancelTicket
    @TicketID int
AS
BEGIN
    
    DELETE FROM Tbl_Thy_Ticket WHERE TicketID = @TicketID
END

GO

CREATE PROCEDURE SP_MyTickets
--Kullanýcýnýn id si
    @PassengerID int
AS
BEGIN
    SELECT 
        T.TicketID, 
        A1.City AS [Nereden],
        A2.City AS [Nereye],
        F.TimeandDate AS [Tarih],
        T.SeatID AS [Koltuk],
        F.Price AS [Fiyat]
    FROM Tbl_Thy_Ticket T
    --Belirli ticketin flightID si kullanýlarak where ve from belirlenir bu ID ler ile airport tablosunu joinlenip id yerine isim çekilir
    INNER JOIN Tbl_Thy_Flight F ON T.FlightID = F.FlightID
    INNER JOIN Tbl_Thy_Airport A1 ON F.FromID = A1.AirportID
    INNER JOIN Tbl_Thy_Airport A2 ON F.WhereID = A2.AirportID
    WHERE T.PassengerID = @PassengerID
    --Spesifik o kullanýcýnýn biletleri sorgulamasý
END


Go

CREATE PROCEDURE sp_UpdateProfile
--Prosedüre verilecek olan veriler (ID) yi session vericek
    @KullaniciID int,           
    @TCKimlikNo char(11),
    @DogumTarihi date,
    @Telefon varchar(15)
AS
BEGIN
    UPDATE Tbl_Thy_Kullanicilar
    SET 
    --yeni girilen veriler tabloya girilir
        TCKimlikNo = @TCKimlikNo,
        DogumTarihi = @DogumTarihi,
        Telefon = @Telefon
    WHERE PassengerID = @KullaniciID
END
go
--Bilet alým ekranýnda uçuþ seçildikten sonra spesifik olarak sadece o uçuþun detaylarýný getirir
CREATE PROCEDURE SP_GetFlightDetails
    @FlightID int
AS
BEGIN
    SELECT 
        F.FlightID,
        F.TimeandDate,
        F.Price,
        A1.City as Nereden, 
        A2.City as Nereye   
    FROM Tbl_Thy_Flight F
    INNER JOIN Tbl_Thy_Airport A1 ON F.FromID = A1.AirportID
    INNER JOIN Tbl_Thy_Airport A2 ON F.WhereID = A2.AirportID
    WHERE F.FlightID = @FlightID
END

go
--Admin panelinde tüm uçuþlarý sergileriz
Create PROCEDURE SP_GetFlightList
AS
BEGIN
    SELECT 
        F.FlightID, 
        (L1.City + ' - ' + L2.City) as Rota, 
        F.TimeandDate, 
        P.Model, 
        F.Price,
        
        -- Fonksiyon ile doluluk oranýný hesaplarýz
        dbo.FN_DolulukOrani(F.FlightID) AS DolulukOrani 

    FROM Tbl_Thy_Flight F
    INNER JOIN Tbl_Thy_Airport L1 ON F.FromID = L1.AirportID
    INNER JOIN Tbl_Thy_Airport L2 ON F.WhereID = L2.AirportID
    INNER JOIN Tbl_Thy_Plane P ON F.PlaneID = P.PlaneID
    ORDER BY F.FlightID DESC
END

go


-- Boss panelinde patronun görmek isteyeceði ciro hesabý
CREATE PROCEDURE SP_BossStats
AS
BEGIN
    SELECT 
    --Toplam yolcu sayýsý ve her uçuþun kendi dolu koltuk sayýsý ile bilet fiyatý çarpýmýnýn her uçuþ için toplamý
        SUM(Price * SoldSeats) as ToplamKasa,
        SUM(SoldSeats) as ToplamYolcu,
        --Toplam uçuþ sayýsý çekilir

        (SELECT COUNT(*) FROM Tbl_Thy_Flight) as ToplamUcus
    FROM Tbl_Thy_Flight
END
GO

-- 2. Detaylý Rapor (Büyük Tablo için)
CREATE PROCEDURE SP_BossReport
AS
BEGIN
    SELECT 
        F.FlightID,
        (L1.City + ' - ' + L2.City) AS Rota,
        F.Price,
        F.SoldSeats,
        
        -- Fonksiyonlar ile kdv ve dolu koltuk yüzdesi hesabý
        dbo.FN_KDVHesapla(F.Price * F.SoldSeats) AS ToplamKDV, 
        dbo.FN_DolulukOrani(F.FlightID) AS DolulukYuzdesi,
        --Her uçuþun ayrý ayrý toplam cirosu
        (F.Price * F.SoldSeats) AS ToplamCiro
    FROM Tbl_Thy_Flight F
    INNER JOIN Tbl_Thy_Airport L1 ON F.FromID = L1.AirportID
    INNER JOIN Tbl_Thy_Airport L2 ON F.WhereID = L2.AirportID
    ORDER BY F.FlightID DESC
END



go


--En son iptla edilen 10 uçuþun log unu çeker
CREATE PROCEDURE SP_GetCancelLogs
AS
BEGIN
    SELECT TOP 10 
        L.FlightID, 
        (A1.City + ' - ' + A2.City) as Rota, 
        L.OriginalDateTime, 
        --iptal zamanýný kaydýný çeker ki ona göre sýralayalým
        L.CancelDateTime 
    FROM Tbl_Thy_CancelFlights L
    INNER JOIN Tbl_Thy_Airport A1 ON L.FromID = A1.AirportID
    INNER JOIN Tbl_Thy_Airport A2 ON L.WhereID = A2.AirportID
    ORDER BY L.CancelDateTime DESC
END

go
--Tüm airportlarý yani havalimanlarýný çekmek için
CREATE PROCEDURE SP_GetAirports
AS
BEGIN
    SELECT AirportID, City FROM Tbl_Thy_Airport
END