require "rubygems"
require "mongo_mapper"

MongoMapper.database = "app"
MongoMapper.connection = Mongo::Connection.new("133.83.90.36",27017)

module DB
  
  class History

    include MongoMapper::Document

    key :user_id, Integer, :required => true
    key :date, String, :required => true
    
    ensure_index :date
  end
end

