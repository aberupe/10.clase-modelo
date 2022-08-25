--El director de ventas le ha pedido que busque todas las ventas de las cinco marcas más vendidas.
--Una solicitud como esta ilustra que algunos desafíos de análisis de datos requieren que genere un
--conjunto de registros que use el resultado de un segundo conjunto (una tabla derivada) como filtro.

SELECT MKX.MakeName, SDX.SalePrice
FROM Data.Make AS MKX
INNER JOIN Data.Model AS MDX ON MKX.MakeID = MDX.MakeID
INNER JOIN Data.Stock AS STX ON STX.ModelID = MDX.ModelID
INNER JOIN Data.SalesDetails SDX ON STX.StockCode = SDX.StockID
WHERE MakeName IN (
SELECT  TOP (5) MK.MakeName
FROM Data.Make AS MK
INNER JOIN Data.Model AS MD
ON MK.MakeID = MD.MakeID
INNER JOIN Data.Stock AS ST
ON ST.ModelID = MD.ModelID
INNER JOIN Data.SalesDetails SD
ON ST.StockCode = SD.StockID
INNER JOIN Data.Sales SA
ON SA.SalesID = SD.SalesID
GROUP BY MK.MakeName
ORDER BY SUM(SA.TotalSalePrice) DESC
)
ORDER BY MKX.MakeName, SDX.SalePrice DESC
