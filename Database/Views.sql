CREATE VIEW VW_UcusListesi
AS
SELECT 
    F.FlightID,
    A1.City AS [Nereden],
    A2.City AS [Nereye],
    F.TimeandDate AS [Tarih],
    P.Model AS [Ucak],
    F.Price AS [Fiyat],
    F.SoldSeats AS [Satilan],
    (P.Kapasite - F.SoldSeats) AS [Kalan]
FROM Tbl_Thy_Flight F
INNER JOIN Tbl_Thy_Airport A1 ON F.FromID = A1.AirportID
INNER JOIN Tbl_Thy_Airport A2 ON F.WhereID = A2.AirportID
INNER JOIN Tbl_Thy_Plane P ON F.PlaneID = P.PlaneID
-- Tüm uçularý sergileyecek vw tablosu için Flight tablosunu diðer tablolarýn primeri keyleri ile baðlýyoruz

SELECT * FROM VW_UcusListesi
-- Oluþturulan vw tablosunu çaðrýyoruz