with customers as (

    select * from {{ ref('stg_customers') }}

),

nations as (

    select * from {{ ref('stg_tpch__nation') }}

),

regions as (

    select * from {{ ref('stg_tpch__region') }}

),

final as (

    select
        customers.customer_key,
        customers.name,
        customers.address,
        nations.n_name as nation,
        regions.r_name as region,
        customers.phone_number,
        customers.account_balance,
        customers.market_segment
    from customers
    inner join nations on customers.nation_key = nations.n_nationkey
    inner join regions on nations.n_regionkey = regions.r_regionkey

)

select * from final
