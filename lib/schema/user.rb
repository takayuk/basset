require "rubygems"
require "mongoid"

module Schema
  
  class User

    include Mongoid::Document

    field :user_id
    field :contact_id => Array
    field :group_name => Array
    field :geo_lat => Float
    field :geo_lng => Float
    field :tags => Array
  end
end

