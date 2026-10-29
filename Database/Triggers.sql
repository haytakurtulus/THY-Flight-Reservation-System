
Create Trigger TRG_PriceChangeLog
On Tbl_Thy_Flight
After Update
-- Her Flight tablosunda
as 
begin
IF Update(Price)
-- Eðer fiyat güncellendiyse
Begin
Declare @FlightID int
Declare @Old float
Declare @New float

Select @FlightID=FlightID, @Old=Price from deleted
-- güncelleme öncesi eski veriler silinenler sanal tablosuna atýlýyor eski flight ID ve price deðerini alýyoruz
Select @New=Price from inserted
-- girilen yeni fiyat deðeri new deðiþkenine kaydediliyor
INSERT INTO Tbl_Thy_PriceLogs (FlightID, OldPrice, NewPrice, ChangeTime)
        VALUES (@FlightID, @Old, @New, GETDATE())
        End --2. begin sonu
        End -- ilk begin sonu
        -- O flightID nin olduðu satýra yeni deðerler baþtan kaydediliyor 

Go


CREATE TRIGGER TRG_WelcomeBonus
ON Tbl_Thy_Kullanicilar
AFTER INSERT
AS
BEGIN
    DECLARE @YeniUyeID int
    -- Yeni eklenen üye ID alýnýr
    SELECT @YeniUyeID = PassengerID FROM inserted
    -- sanal insterted tablosundan PassengerId yi aldýk
    -- Ona 100 Mil hediye ediyoruz
    UPDATE Tbl_Thy_Kullanicilar
    SET Miles = 100
    WHERE PassengerID = @YeniUyeID
    --PassengerID ye göre doðru kiþiye mil ekledik
END



GO


CREATE TRIGGER TRG_UpdateSoldSeat
ON Tbl_Thy_Ticket
AFTER INSERT
AS
BEGIN
    Declare @FlightID int
    Select @FlightID=FlightID from inserted
    -- sanal inserted tablosundna eklenecek olan Flightýn ID sini al
    Update Tbl_Thy_Flight
    Set SoldSeats=SoldSeats+1
    Where FlightID=@FlightID
    --Doðru Flightýn Satýlan koltuk sayýsýný arttýr
END


use Thy_Proje
GO

-- Bilet silinirse koltuk sayýsýný geri artýran trigger
Create TRIGGER TRG_DecreaseSoldSeat
ON Tbl_Thy_Ticket
AFTER DELETE
AS
BEGIN
    DECLARE @FlightID int
    DECLARE @PassengerID int
    DECLARE @BiletFiyati float
    DECLARE @KazanilanMil int

    -- Silinen biletin bilgilerini  FlightID ve PassengerID alýyoruz
    SELECT @FlightID = FlightID, @PassengerID = PassengerID FROM deleted

    -- 1. ÝÞLEM Koltuk Sayýsýný Düþür
    UPDATE Tbl_Thy_Flight
    SET SoldSeats = SoldSeats - 1
    WHERE FlightID = @FlightID

    --Bileti silinen kullanýcýya biletin parasýna göre mil puaný ekliyoruz
    --Bunun için FlightID ile biletin parasýný öðreniyoruz
    SELECT @BiletFiyati = Price FROM Tbl_Thy_Flight WHERE FlightID = @FlightID

    -- Fiyatýn %10'unu hesapla 
    SET @KazanilanMil = @BiletFiyati * 0.10

    -- Kullanýcýnýn mil puanýný artýr
    UPDATE Tbl_Thy_Kullanicilar
    SET Miles = Miles + @KazanilanMil
    WHERE PassengerID = @PassengerID
END

go

CREATE TRIGGER TRG_FlightCancelLog
ON Tbl_Thy_Flight
AFTER DELETE
AS
BEGIN
    -- Silinen uçuþun bilgilerini log tablona aktarýyoruz
    INSERT INTO Tbl_Thy_CancelFlights (FlightID, FromID, WhereID, OriginalDateTime, CancelDateTime)
    SELECT FlightID, FromID, WhereID, TimeandDate, GETDATE()
    --Bilgileri Deleted tablosundan alýyoruz ki aktrabilelim
    FROM deleted
END