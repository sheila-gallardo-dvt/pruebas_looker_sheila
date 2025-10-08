include: "/views/**/*.view.lkml"
view: order_items_extended {
  extends: [order_items]
  measure: total_users {
    description: "user count"
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: dynamic_count{
    label: "Dynamic Count"
    description: "dynamic measure example"
    type: count_distinct
    sql:
    {% if parameters.filtro_medida._parameter_value == 'value_1'}
    ${user_id}
    {% elsif parameters.filtro_medida._parameter_value == 'value_2'}
    ${order_id}
    {% endif %};;
  }



}
