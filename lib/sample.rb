$LOAD_PATH.push("./")
require "db/history"

SIZE = 100
LOOP_COUNT = 10

LOOP_COUNT.times {|i|

  insert_start_time = Time.now()
  SIZE.times {|p|

    DB::History.create({
      :user_id => 1234,
      :date => Time.now.strftime("%Y-%m-%d"),
    })
  }

  puts "Insert: #{i}: #{Time.now() - insert_start_time}"
}

LOOP_COUNT.times {|i|
  
  select_start_time = Time.now()

  histories = DB::History.all(:limit => SIZE)
  
  puts "Select: #{i}: #{Time.now() - select_start_time}"

  delete_start_time = Time.now()
  histories.each {|h| h.destroy }

  puts "Delete: #{i}: #{Time.now() - delete_start_time}"
}

