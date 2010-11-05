require "rubygems"
require "mongoid"

module Schema
  
  class Photo

    include Mongoid::Document

    field :photo_id
    field :geo_lat => Float
    field :geo_lng => Float
    field :tag => Array
  end
end

