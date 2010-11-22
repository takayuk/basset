require "rubygems"
require "mongoid"

module Schema
  
  class User

    include Mongoid::Document

    field :user_id
    
    embeds_many :photos

    field :contacts => Array
    field :groups => Array
  end
  
  class Photo

    include Mongoid::Document

    field :photo_id
    field :tags => Array
    field :geo_lat => Float
    field :geo_lng => Float

    embedded_in :user_id, :inverse_of => :photos
  end
end

