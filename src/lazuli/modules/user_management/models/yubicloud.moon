import Model from require "lapis.db.model"
import Users from require "lazuli.modules.user_management.models.users"


class YubiCloud extends Model
  @table_name: => "lazuli_modules_user_management_yubicloud"
  @relations: {
    {"user", belongs_to: "lazuli.modules.user_management.models.users"}
  }
