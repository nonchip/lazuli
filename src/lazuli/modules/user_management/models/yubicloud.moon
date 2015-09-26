import Model from require "lapis.db.model"
import Users from require "lazuli.modules.user_management.models.users"

package.loaded['models'] or={}
package.loaded['models'].Users=Users

class YubiCloud extends Model
  @table_name: => "lazuli_modules_user_management_yubicloud"
  @relations: {
    {"user", belongs_to: "Users"}
  }
