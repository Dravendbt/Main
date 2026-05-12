{{ config(
    materialized = 'table'
) }}

with customers as (

    select
        customer_key,
        name as customer_name,
        address as customer_address,
        nation_key,
        phone_number,
        account_balance,
        market_segment,
        comment as customer_comment
    from {{ ref('stg_customers') }}

),

final as (

    select
        customer_key,
        customer_name,
        customer_address,
        nation_key,
        phone_number,
        account_balance,
        market_segment,
        customer_comment
    from customers

)

select * from final
