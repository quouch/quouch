# Base class with minimal setup to extend from when creating serializers
class BaseSerializer
  include JSONAPI::Serializer

  set_key_transform :camel_lower
end
