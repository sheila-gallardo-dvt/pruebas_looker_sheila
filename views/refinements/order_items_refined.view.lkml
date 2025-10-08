include: "/views/**/*.view.lkml"
view: +order_items {
  measure: total_users {
    description: "user count"
    type: count_distinct
    sql: ${user_id} ;;
  }
}
