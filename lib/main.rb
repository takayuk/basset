$LOAD_PATH.push("./")
require "db/history"

require "req/req.photo"

@responses = photos_queryof("naniwa")
@responses.each{|r|

  doc=REXML::Document.new(r)
  p doc.elements["rsp/stat/"].text
  doc.elements.each("rsp/photos/photo/"){|e|
    p e.attributes["owner"]
  }

  break
}
p @responses.size

=begin
puts "count: #{DB::History.count()}"

d=DB::History.create({
  :user_id => "123456@N00",
})
d.save

h = DB::History.all(:user_id => "123456@N00")
h.each{|_h|
  p _h
}
=end

=begin
puts "count: #{DB::History.count()}"

histories = DB::History.all(:user_id => 1234)
histories.each {|h|

  puts "#{h.user_id}: #{h.date}"
  #h.destroy
}

puts "count: #{DB::History.count()}"
=end
=begin
histories = DB::History.all(:order => "date ASC")
histories.each {|h| h.destroy }
=end

#puts "count: #{DB::History.count()}"

