import create_table, types, add_column from require "lapis.db.schema"

{
  user_management_000001: =>
    create_table "users", {
      {"id", types.serial}
      {"username", types.varchar}
      {"pwHMACs1", types.varchar}
      "PRIMARY KEY (id)"
    }
}
