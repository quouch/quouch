# Used for integration tests
module DBHelper
  def db_cleanup
    Couch.delete_all
    UserCharacteristic.delete_all
    User.delete_all
  end
end
