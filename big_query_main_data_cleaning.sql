with cte as (
  select * 
  from `robotic-energy-468108-d9.online_store_transaction654.online_store`
  where
    UnitPrice > 0 AND
NOT (
    (Quantity < 0 AND InvoiceNo NOT LIKE 'C%')
    OR (Quantity > 0 AND InvoiceNo LIKE 'C%')
)
)


SELECT 
InvoiceNo,
case when InvoiceNo like 'C%' then 'Cancel' else 'Complete' end as Invoicestatus,
StockCode,
InvoiceDate,
Description as product,
Quantity,
UnitPrice,
Quantity * UnitPrice as Total_price,
CustomerID,
Country
FROM cte
