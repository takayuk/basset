$LOAD_PATH.push("./")
require "db/history"

puts "count: #{DB::History.count()}"

d=DB::History.create({
  :user_id => 1234,
  :date => Time.now.strftime("%Y-%m-%d"),
})

e=DB::History.create({
  :user_id => 5678,
  :date => Time.now.strftime("%Y-%m-%d"),
})
d.save
e.save

h = DB::History.all(:user_id => 1234)
h.each{|_h|
  p _h
}


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

