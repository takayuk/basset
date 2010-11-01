require "rubygems"
require "mongo_mapper"

MongoMapper.database = "flickr"
MongoMapper.connection = Mongo::Connection.new("133.83.90.36",27017)

module DB
  
  class History

    include MongoMapper::Document

    key :user_id, String, :required => true
    key :contact_id, Array

    ensure_index :user_id
  end
end

