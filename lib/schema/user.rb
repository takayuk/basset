require "rubygems"
require "mongoid"

module Schema
  
  class User

    include Mongoid::Document

    field :user_id
    field :contact_id => Array
  end
end

