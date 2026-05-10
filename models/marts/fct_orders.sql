with orders as (

    select
        o_orderkey      as order_key,
        o_orderdate     as order_date,
        o_custkey       as customer_key,
        o_orderstatus   as status_code,
        o_orderpriority as priority_code,
        o_clerk         as clerk_name
    from {{ ref('stg_orders') }}

),

customers as (

    select
        c_custkey       as customer_key,
        c_name          as name,
        c_mktsegment    as market_segment
    from {{ ref('stg_customers') }}

),

lineitems as (

    select
        l_orderkey                                  as order_key,
        sum(l_extendedprice)                        as gross_item_sales_amount,
        sum(l_discount * l_extendedprice)           as item_discount_amount,
        sum(l_tax * (l_extendedprice - (l_discount * l_extendedprice)))
                                                    as item_tax_amount,
        sum(
            l_extendedprice
            - (l_discount * l_extendedprice)
            + (l_tax * (l_extendedprice - (l_discount * l_extendedprice)))
        )                                           as net_item_sales_amount
    from {{ ref('stg_line_items') }}
    group by 1

)

select
    o.order_key,
    o.order_date,
    o.customer_key,
    o.status_code,
    o.priority_code,
    o.clerk_name,
    c.name,
    c.market_segment,
    li.gross_item_sales_amount,
    li.item_discount_amount,
    li.item_tax_amount,
    li.net_item_sales_amount
from orders o
left join customers c
    on o.customer_key = c.customer_key
left join lineitems li
    on o.order_key = li.order_key
