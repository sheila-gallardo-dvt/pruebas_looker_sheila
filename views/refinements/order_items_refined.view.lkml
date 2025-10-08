include: "/views/**/*.view.lkml"
view: +order_items {
    measure: total_users {
      type: count_distinct
      sql: ${user_id} ;;
    }
}
