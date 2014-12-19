require 'hashids'

module ActiveRecord::HashID
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def find(*args)
      hash_ids = Hashids.new('', 15)

      scope   = args.slice!(0)
      options = args.slice!(0) || {}

      super(hash_ids.decode(scope.tr('-', '')), options)
    end
  end

  module InstanceMethods
    def to_param
      hash_id = Hashids.new('', 15).encode(id)

      hash_id.reverse.scan(/.{1,5}/).collect { |s| s.reverse }.reverse.join('-')
    end
  end
end

ActiveRecord::Base.class_eval do
  include ActiveRecord::HashID
end
