#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

$LOAD_PATH.push("/home/kamei/workspace/basset/bin")
require"googlenews_snapshot.rb"

@res=snapshot(start_index = 0)

require 'uri'
require"pp"
@res["responseData"]["results"].each do |v|
  @headline=v["content"].split("")
  @headline=@headline[0..@headline.size-12]
  
  @h=Hash.new(0)
  open(URI.escape(v["unescapedUrl"])).readlines.each do |line|
    next if @text.nil?
    @text=line.strip.gsub!(/<("[^"]*"|\'[^\']*\'|[^\'">])*>/,"")
    if not @text.empty?
      @text.force_encoding("UTF-8") if @text.encoding.to_s=="ASCII-8BIT"
      @h.store(@text,(@text.split("") & @headline).size)
    end
  end
  @h.sort{|a,b|b[1]<=>a[1]}.first(2).each{|k,v|
    p k
  }
  #pp v["relatedStories"]
  #pp v["content"]
  #pp v["title"] unless (v["content"] =~ /[ぁ-ん]/).nil?
  #pp v["content"] unless (v["content"] =~ /[ぁ-ん]/).nil?
  #puts ""
end

