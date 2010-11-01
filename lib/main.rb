$LOAD_PATH.push("./")
require "db/history"

require "req/req.photo"

=begin
@responses = photos_queryof("kyoto")
@responses.each{|r|

  doc=REXML::Document.new(r)
  p doc.elements["rsp/stat/"]
  doc.elements.each("rsp/photos/photo/"){|e|
    p e.attributes["owner"]
  }
}
p @responses.size
=end

#puts "count: #{DB::History.count()}"

open("user.list"){|f|
  while l=f.gets
    d=DB::History.create({
      :user_id => l.chomp,
      :contact => %w!12345@N00 56789@N00!
    })
    d.save
  end
}
puts "count: #{DB::History.count()}"

=begin
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

