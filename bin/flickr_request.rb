#! /usr/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-


require 'open-uri'
require 'rexml/document'
require 'cgi'


FLICKR_API_KEY = '462f636d0921ef211d8dbc676d1538b2'
HTTP_PROXY = 'http://cache.st.ryukoku.ac.jp:8080/'

$mutex=Mutex.new

#
# リクエストURIの生成.
#
def new_request(method_name, arg_map = {}.freeze)
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

def profileurl_of user_id

  return if File.exists?("dump/#{user_id}_url")

  @response = new_request("flickr.people.getInfo", "user_id"=>user_id)
  if @response.nil? || @response.elements["rsp/"].attributes["stat"]!="ok"
    open("dump/forbidden","a"){|f| f.puts user_id}
    return
  end
  open("dump/#{user_id}_url","w"){|f|
    f.puts @response.elements["rsp/person/profileurl/"].text rescue open("dump/forbidden","a"){|_f|_f.puts user_id}
  }
end

def grouppost_of user_id, groups

  begin
    @opinion=Hash.new(0)

    groups.each{|group_id|
      @response = new_request("flickr.groups.pools.getPhotos", "group_id"=>group_id,"user_id"=>user_id,"per_page"=>"500")
      if @response.nil?
        open("dump/forbidden","a"){|f| f.puts user_id}
        open("dump/#{user_id}_invalid","w"){|f| f.puts user_id}
        return
      elsif @response.elements["rsp/"].attributes["stat"]!="ok"
        #@warn="#{user_id}\t#{@response.elements["rsp/err"].attributes["msg"]}"
        open("dump/forbidden","a"){|f| f.puts user_id,group_id}
        open("dump/#{user_id}_invalid","w"){|f| f.puts user_id}
        return
      end

      @response.elements.each("rsp/photos/photo/"){|p|
        @date=p.attributes["dateadded"]
        @opinion.store(group_id,@date)
      }
    }

    @line=""
    @opinion.sort{|a,b|
      a[1]<=>b[1]
    }.each{|gid,date|
      @line+="#{gid}:#{date} "
    }

    open("dump/#{user_id}_opinion","w"){|f|
      #f.puts @response.elements["rsp/group/name/"].text rescue open("dump/forbidden","a"){|_f|_f.puts user_id}
      f.puts "#{@opinion.size} #{@line}" rescue open("dump/forbidden","a"){|_f|_f.puts user_id}
    }
  rescue
    p "invalid #{user_id}"
    open("dump/#{user_id}_invalid","w"){|f| f.puts user_id}
  end
end

def groupurl_of user_id

  #return if File.exists?("dump/#{user_id}_url")

  @response = new_request("flickr.groups.getInfo", "group_id"=>user_id)
  if @response.nil?
    open("dump/forbidden","a"){|f| f.puts user_id}
    return
  elsif @response.elements["rsp/"].attributes["stat"]!="ok"
    p "#{user_id}\t#{@response.elements["rsp/err"].attributes["msg"]}"
    open("dump/forbidden","a"){|f| f.puts user_id}
    return
  end
 
  open("dump/#{user_id}_url","w"){|f|
    f.puts @response.elements["rsp/group/name/"].text rescue open("dump/forbidden","a"){|_f|_f.puts user_id}
  }
end

def groups_of user_id

  @group_id = []

  @response = new_request('flickr.people.getPublicGroups', "user_id"=>user_id)
  if @response.nil?
    open("dump/forbidden","a"){|f| f.puts user_id}
    return
  elsif @response.elements["rsp/"].attributes["stat"]!="ok"
    p "#{user_id}\t#{@response.elements["rsp/err"].attributes["msg"]}"
    open("dump/forbidden","a"){|f| f.puts user_id}
    return
  end
 
  @response.elements.each('rsp/groups/group/') {|group|
    @group_id << group.attributes['nsid']
  }
 
  open("dump/#{user_id}_comm","w"){|f|
    f.puts "#{user_id} #{@group_id.join(" ")}" rescue open("dump/forbidden","a"){|_f|_f.puts user_id}
  }
end


def groupinfo_of group_id

  @groupinfo = []

  @response = new_request('flickr.groups.getInfo', "group_id"=>group_id)
  return ["", ""] if @response.nil?
  return ["", ""] if @response.elements["rsp/"].attributes["stat"] != "ok"

  @name=@response.elements["rsp/group/name/"].text
  @desc=@response.elements["rsp/group/description/"].text

  @name="" if @name.nil?
  @desc="" if @desc.nil?

  return [@name, @desc]
end


def photos_of user_id, target

  @method="flickr.people.getPublicPhotos".freeze
  
  @response=new_request(@method,"user_id"=>user_id,"perpage"=>"500")
  if @response.nil?
    p "Response is nil."
    open("#{target}/dump/forbidden","a"){|f| f.puts user_id}
    return
  elsif @response.elements["rsp/"].attributes["stat"]!="ok"
    p "#{user_id}\t#{@response.elements["rsp/err"].attributes["msg"]}"
    open("#{target}/dump/forbidden","a"){|f| f.puts user_id}
    return
  end
  
  @pages=@response.elements['rsp/photos/'].attributes['pages'].to_i

  @resource=Hash.new(0)
  for page in 1..@pages
    @response=new_request(@method,"user_id"=>user_id,"extras"=>"tags","page"=>page.to_s,'perpage'=>'500')
    begin
      open("#{target}/dump/#{user_id}_#{sprintf("%03d",page)}_phototag.xml","w"){|f|
        f.write @response
      }
=begin
      $mutex.lock
      @response.elements.each('rsp/photos/photo') {|rc|
        @resource.store(rc.attributes['id'],rc.attributes["tags"].split(" "))
      } unless @response.nil?
      $mutex.unlock
=end
    rescue
      p "Write error..."
      sleep 1
      retry
    end
  end
=begin
  open("#{target}/dump/#{user_id}_phototag","w"){|f|
    @resource.each{|id,tags|
      next if tags.empty?
      f.puts "#{id} #{tags.join(" ")}" rescue open("#{target}/dump/forbidden","a"){|_f|_f.puts user_id}
    }
  }
  @resource.clear
=end
end


def contacts_of user_id, target
  @response=new_request("flickr.contacts.getPublicList","user_id"=>user_id,"perpage"=>"1000")
  if @response.nil?
    open("dump/forbidden","a"){|f| f.puts user_id}
    return
  elsif @response.elements["rsp/"].attributes["stat"]!="ok"
    p "#{user_id}\t#{@response.elements["rsp/err"].attributes["msg"]}"
    open("dump/forbidden","a"){|f| f.puts user_id}
    return
  end
  
  @pages=@response.elements['rsp/contacts/'].attributes['pages'].to_i

  @contacts=[]
  for page in 1..@pages
    @response=new_request("flickr.contacts.getPublicList","user_id"=>user_id,"page"=>page.to_s,'perpage'=>'1000')
    @response.elements.each('rsp/contacts/contact') {|contact|
      @contacts << contact.attributes['nsid']
    #} unless @response.elements["rsp/contacts/contact"].nil?
    } unless @response.nil?
  end
  @contacts.uniq!
  open("#{target}/dump/#{user_id}_social","w"){|f|
    f.puts "#{user_id} #{@contacts.join(" ")}" rescue open("#{target}/dump/forbidden","a"){|_f|_f.puts user_id}
  }
end

def photos_queryof tag

  response = new_request('flickr.photos.search',
                         'has_geo'=>'1', 'tags'=>tag, 'perpage'=>'500')

  @total = response.elements['rsp/photos/'].attributes['total']

  @pages = response.elements['rsp/photos/'].attributes['pages'].to_i

  @photo_id = []

  for page in 1..@pages

    @response = new_request('flickr.photos.search', 'has_geo'=>'1', 'tags'=>tag, 'page'=>page.to_s, 'perpage'=>'500')

    @response.elements.each('rsp/photos/photo/') {|photo|

      @photo_id << photo.attributes['id']
    }

    p @photo_id.size.to_s + ' / ' + @total
  end

  @photo_id
end

