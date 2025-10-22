#LAMS
#rule: K1{} # Primary key naming
#rule: K3{} # Primary keys first
#rule: K4{} # Primary keys hidden
#rule: K7{} # Provide one `primary_key`
#rule: K8{} # `primary_key` uses PK dims
#rule: F2{} # No view-labeled fields
#rule: F3{} # Count fields filtered
#rule: F4{} # Description or hidden
#rule: E1{} # Join with subst'n operator
#rule: E2{} # Join on PK for "one" joins
#rule: E6{} # FK joins are m:1
#rule: E7{} # Explore label 25-char max
#rule: T1{} # Triggers use datagroups
#rule: T2{} # Primary keys in DT
#rule: H2{} # Group fields
#rule: H3{} # Sort-group groups
#rule: H4{} # Group more
#rule: H5{} # Hoist main view
#rule: H6{} # Sort-group views
#rule: W1{} # Block indentation
# rule: prod_connection {
#  description: "Force sql_table_name in refinemet views"
#  match: "$.model.*.view[?(@.$name =~ /\\+.*/)]"
#  expr_rule: ($exists ::match:sql_table_name) ;;
# }
