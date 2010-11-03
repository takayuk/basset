$LOAD_PATH.push("./")
require "schema/user"
require "req/req.photo"

require "mongoid"

Mongoid.configure {|conf|
  conf.master = Mongo::Connection.new("133.83.90.36", 27017).db("flickr")
}

open("user.list"){|f|
  while l=f.gets
    #@user = Schema::User.new(:user_id => l.chomp)
    #@user.save
  end
}

=begin
Schema::User.find(:user_id).each{|r|

  r.update_attributes!(:contact_id => %w!contact_a contact_b!)
}
=end

Schema::User.find(:user_id).each{|u|
  puts "#{u.user_id}, #{u.contact_id}"
}
p Schema::User.find(:user_id).count

