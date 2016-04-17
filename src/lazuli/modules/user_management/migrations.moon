import drop_column, create_table, types, add_column from require "lapis.db.schema"

{
  user_management_000001: =>
    create_table "lazuli_modules_user_management_users", {
      {"id", types.serial}
      {"username", types.varchar}
      {"pwHMACs1", types.varchar}
      "PRIMARY KEY (id)"
    }
  user_management_yubicloud_000001: =>
    create_table "lazuli_modules_user_management_yubicloud", {
      {"id", types.serial}
      {"user_id", types.integer}
      {"idstr", types.varchar}
      "PRIMARY KEY (id)"
    }
  user_management_000002: =>
    drop_column "lazuli_modules_user_management_users", "pwHMACs1"
    add_column "lazuli_modules_user_management_users", "pwHash", types.varchar null: true
}
