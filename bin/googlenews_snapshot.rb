#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

require"json"
require"open-uri"

def snapshot start_index

  @start_propindex=0
  @url="http://ajax.googleapis.com/ajax/services/search/news?v=1.0&rsz=large&scoring=d&topic=p&hl=ja&ned=jp&geo=japan&start=#{start_index}"
  @ref="http://www.my-ajax-site.com"

  @response=JSON.parse(open(@url,"Referer"=>@ref).read)
end

