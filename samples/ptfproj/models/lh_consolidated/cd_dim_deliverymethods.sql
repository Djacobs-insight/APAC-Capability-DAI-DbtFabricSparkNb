
-- Use the `ref` function to select from other models
{{ config(materialized='incremental', incremental_strategy="insert_overwrite",file_format="delta") }}
with source_data as (

select 
a.DeliveryMethodID as DeliveryMethodKey,
a.DeliveryMethodName,
row_number () over (
    partition by 
    a.DeliveryMethodID,
    a.DeliveryMethodName
    order by
    a.ETL_Date desc
    ) as LatestRecord
from {{ ref('cf_deliverymethods') }} a

)

select 
    DeliveryMethodKey,
    DeliveryMethodName
from source_data
where LatestRecord = 1

