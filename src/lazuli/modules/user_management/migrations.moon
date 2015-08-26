import create_table, types, add_column from require "lapis.db.schema"

{
  user_management_000001: =>
    create_table "lazuli_modules_user_management_users", {
      {"id", types.serial}
      {"username", types.varchar}
      {"pwHMACs1", types.varchar}
      "PRIMARY KEY (id)"
    }
}
