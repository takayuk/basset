#! /usr/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

require 'open-uri'
require 'rexml/document'
require 'cgi'

FLICKR_API_KEY = '462f636d0921ef211d8dbc676d1538b2'
HTTP_PROXY = 'http://cache.st.ryukoku.ac.jp:8080/'

#
# リクエストURIの生成.
#
def new_request method_name, arg_map = {}.freeze

	begin

		args = arg_map.collect{|k, v| CGI.escape(k) << '=' << CGI.escape(v)}.join('&')

		request_url = "http://www.flickr.com/services/rest/?api_key=%s&method=%s&%s" %
		[FLICKR_API_KEY, method_name, args]

		return REXML::Document.new(open(request_url, :proxy=>HTTP_PROXY))
	rescue

		STDERR.puts "LOCAL WARNINGS: #{$!}"
		return nil
	end
end


def photos_queryof tag, delay = 0.1

  @response = new_request('flickr.photos.search',
                         'has_geo'=>'1', 'tags'=>tag, 'perpage'=>'500')

  @pages = @response.elements['rsp/photos/'].attributes['pages'].to_i

  @responses = []

  for page in 1..@pages

    @response = new_request('flickr.photos.search', 'has_geo'=>'1', 'tags'=>tag, 'page'=>page.to_s, 'perpage'=>'500', 'extras'=>'date_taken,owner_name,geo,tags,views,url_o')

    @responses << @response
=begin
    open('dump.photoid/photoid.qtag-'+ARGV[0]+sprintf("%04d",page)+'.dump','w'){|f|
      f.write @response
    }
=end
    sleep delay
  end

  @responses
end


#Dir.mkdir('dump.photoid') unless Dir.exists?('dump.photoid')
#photos_queryof(ARGV[0])

=begin
photos.each_with_index{|dump,i|
  open('dump.photoid/photoid.qtag-'+ARGV[0]+sprintf("%04d",i)+'.dump','w'){|f|
    f.write dump
  }
}
=end

=begin
photos = photos_queryof(ARGV[0])
open('dump.photoid/photoid.tag-'+ARGV[0]+'.dump', 'w') {|f|

  photos.each{|photoid|
    f.puts photoid
  }
}
=end

