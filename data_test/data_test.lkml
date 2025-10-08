test: pk_order_item_id_not_null {
  explore_source: order_items {
    column: pk_order_item_id {
      field: order_items.pk_order_item_id
    }
  }
  # La prueba tiene éxito si esta consulta devuelve 0 filas
  assert: a_null_primary_key {
    expression: NOT is_null(${order_items.pk_order_item_id});;
  }
}
