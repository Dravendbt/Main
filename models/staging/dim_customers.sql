with customers as (

    select
        c_custkey      as customer_key,
        c_name         as name,
        c_address      as address,
        c_phone        as phone_number,
        c_acctbal      as account_balance,
        c_mktsegment   as market_segment,
        c_nationkey    as nation_key
    from {{ ref('stg_customers') }}

),

nation as (

    select
        n_nationkey    as nation_key,
        n_name         as nation,
        n_regionkey    as region_key
    from {{ ref('stg_tpch_nation') }}

),

region as (

    select
        r_regionkey    as region_key,
        r_name         as region
    from {{ ref('stg_tpch_region') }}

)

select
    c.customer_key,
    c.name,
    c.address,
    n.nation,
    r.region,
    c.phone_number,
    c.account_balance,
    c.market_segment
from customers c
left join nation n
    on c.nation_key = n.nation_key
left join region r
    on n.region_key = r.region_key
