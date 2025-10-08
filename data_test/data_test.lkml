test: pk_order_item_id_is_not_null {
  explore_source: order_items {
    column: total_lifetime_orders {
      field: order_items.total_lifetime_orders
    }
  }

  # The test passes if the query above returns exactly 0 rows.
  assert: no_null_primary_keys {
    expression: ${order_items.total_lifetime_orders} != 0 ;;
  }
}
