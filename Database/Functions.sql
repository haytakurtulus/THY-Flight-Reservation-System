CREATE FUNCTION FN_KDVHesapla(@Fiyat float)
RETURNS float
AS
BEGIN
    -- %20 KDV oraný varsayýyoruz
    RETURN @Fiyat * 0.20
END


Go

CREATE FUNCTION FN_DolulukOrani(@UcusID int)
RETURNS int
AS
BEGIN
    DECLARE @Oran int
    DECLARE @Kapasite int
    DECLARE @Satilan int

    -- Verileri çekiyoruz
    SELECT @Kapasite = P.Kapasite, @Satilan = F.SoldSeats
    FROM Tbl_Thy_Flight F
    INNER JOIN Tbl_Thy_Plane P ON F.PlaneID = P.PlaneID
    WHERE F.FlightID = @UcusID

    -- Sýfýra bölünme hatasý
    IF @Kapasite = 0 RETURN 0

    -- Yüzde hesaplama
    SET @Oran = (@Satilan * 100) / @Kapasite
    RETURN @Oran
END