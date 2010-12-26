#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

@us=open("user_v").readlines.map{|v|v.chomp!}

$LOAD_PATH.push("..")
require"flickr_request"

@us.reject!{|v|File.exists?("dump/#{v}_social")}

TOTAL=@us.size
until @us.empty?
  ths=Array.new(16).map!{
    Thread.start { contacts_of(@us.pop) unless @us.empty? }
  }
  ths.each{|t|t.join}; ths.clear
  sleep 1
  p "#{@us.size} / #{TOTAL}"
end

