view: derived_table_example {
  derived_table: {
    sql: SELECT
          CONCAT((CONVERT(user.first_name USING utf8mb4)), ' ', (CONVERT(user.last_name USING utf8mb4)))  AS `name`,
          user.id AS `id`
      FROM dataset_test.history
      LEFT JOIN user  AS user ON history.user_id = user.id
      GROUP BY
          1,
          2 ;;
  }

  dimension: name {
    type: string
    description: "name"
    sql: ${TABLE}.name ;;
  }

  dimension: pk_id {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.di ;;
  }
}
