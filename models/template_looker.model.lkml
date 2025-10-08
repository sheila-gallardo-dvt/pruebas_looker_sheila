connection: "public_data"

include: "/views/**/*.view.lkml"
include: "/data_test/*.lkml"

datagroup: template_looker_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

access_grant: access_test {
  user_attribute: test_grant
  allowed_values: [ "yes" ]
}


persist_with: template_looker_default_datagroup

explore: order_items {
  # access_filter: {
  #   field: order_id
  #   user_attribute: status_filter
  # }
}
