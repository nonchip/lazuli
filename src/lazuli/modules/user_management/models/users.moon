import Model, enum from require "lapis.db.model"
import create_table, types, add_column from require "lapis.db.schema"

create_table "users", {
  {"id", types.serial}
  {"username", types.varchar}
  {"pwHMACs1", types.varchar}
  "PRIMARY KEY (id)"
}

class Users extends Model
  @table_name: => "users"
