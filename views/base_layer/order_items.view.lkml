view: order_items {
  # You can specify the table name if it's different from the view name:
  sql_table_name: sheila-gallardo-sandbox-01.looker_example.order_items ;;
  # NOW EVERYTHING WORKS -> DEPLOY TO pruebas_looker_sheila_prod (PRDUCTON PROJECT)

  dimension: pk_order_item_id {
    description: "PK"
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  # Define your dimensions and measures here, like this:
  dimension: user_id {
    label: "ID"
    description: "user"
    type: number
    sql: ${TABLE}.user_id ;;
    #access grant
    required_access_grants: [access_test]
  }

  dimension: order_id {
    description: "The total number of orders for each user"
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: created_at {
    description: "The date when each user last ordered"
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.created_at ;;
  }

  measure: total_lifetime_orders {
    description: "Use this for counting lifetime orders across many users"
    type: count_distinct
    sql: ${order_id} ;;
  }

}
