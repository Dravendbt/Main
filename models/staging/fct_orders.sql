
with orders as (

    select * from {{ ref('stg_orders') }}

),

customers as (

    select * from {{ ref('stg_customers') }}

),

line_items as (

    select
        order_key,
        sum(gross_item_sales_amount) as gross_item_sales_amount,
        sum(gross_item_sales_amount * discount_percentage) as item_discount_amount,
        sum(gross_item_sales_amount * (1 - discount_percentage) * tax_rate) as item_tax_amount,
        sum(gross_item_sales_amount * (1 - discount_percentage) * (1 + tax_rate)) as net_item_sales_amount
    from {{ ref('stg_line_items') }}
    group by order_key

),

final as (

    select
        orders.order_key,
        orders.order_date,
        orders.customer_key,
        orders.status_code,
        orders.priority_code,
        orders.clerk_name,
        customers.name,
        customers.market_segment,
        line_items.gross_item_sales_amount,
        line_items.item_discount_amount,
        line_items.item_tax_amount,
        line_items.net_item_sales_amount
    from orders
    inner join customers on orders.customer_key = customers.customer_key
    inner join line_items on orders.order_key = line_items.order_key

)

select * from final
