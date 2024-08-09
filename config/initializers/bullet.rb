if defined?(Bullet)
  Bullet.enable = true
  Bullet.alert = true
  Bullet.bullet_logger = true
  Bullet.console = true
  Bullet.rails_logger = true
  Bullet.add_footer = true
  Bullet.unused_eager_loading_enable = false

  # Add an exception for a query that's causing a false positive
  Bullet.add_safelist type: :unused_eager_loading, class_name: 'Couch', association: :reviews
  Bullet.add_safelist type: :unused_eager_loading, class_name: 'User', association: :user_characteristics
  Bullet.add_safelist type: :unused_eager_loading, class_name: 'User', association: :characteristics
  Bullet.add_safelist type: :unused_eager_loading, class_name: 'UserCharacteristic', association: :characteristic
end
