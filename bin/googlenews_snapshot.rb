#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

require"json"
require"open-uri"

def snapshot start_index, topic="テクノロジー"

  @topic_label={"政治"=>"p","テクノロジー"=>"t"}
  @start_propindex=0
  @url="http://ajax.googleapis.com/ajax/services/search/news?v=1.0&rsz=large&scoring=d&topic=#{@topic_label[topic]}&hl=ja&ned=jp&geo=japan&start=#{start_index}"
  @ref="http://www.my-ajax-site.com"

  #@response=JSON.parse(open(@url,"Referer"=>@ref, :proxy => "http://cache.st.ryukoku.ac.jp:8080/").read)
  @response=JSON.parse(open(@url,"Referer"=>@ref, :proxy => true).read)
end

