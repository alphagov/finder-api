class Hash
  def slice(*keys)
    keys.map! { |key| convert_key(key) } if respond_to?(:convert_key, true)
    keys.each_with_object(self.class.new) { |k, hash| hash[k] = self[k] if has_key?(k) }
  end

  def except(*keys)
    dup.except!(*keys)
  end

  def transform_keys
    result = {}
    each_key do |key|
      result[yield(key)] = self[key]
    end
    result
  end

 def symbolize_keys
    transform_keys{ |key| key.to_sym rescue key }
  end

  def stringify_keys
    transform_keys{ |key| key.to_s }
  end

  protected
  def except!(*keys)
    keys.each { |key| delete(key) }
    self
  end
end
