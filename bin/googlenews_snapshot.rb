#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

require "json"
require 'fileutils'
require 'pp'
require 'pathname'
require 'date'


#command_part_string = '"| curl -e http://www.my-ajax-site.com'
#ajax_url_string = "http://ajax.googleapis.com/ajax/services/search/news?"
#ajax_url_propaty_string = "v=1.0&topic=p&geo=japan&ned=jp&start="
#
#ajax_url_start_propaty_index = 0　　　&ned=jp  topic=p

#command_string = command_part_string + ajax_url_string + ajax_url_propaty_string + ajax_url_start_propaty_index.to_s
#command_string =  "curl -e http://www.my-ajax-site.com 'http://ajax.googleapis.com/ajax/services/search/news?v=1.0&topic=p&geo=japan&ned=jp&start=1' > netresult.json"

#出力用ディレクトリ作成
#output_dirctory_path = Pathname.pwd + Pathname.new(ARGV[0])
#output_dirctory_path = Pathname.new("/home/hirai/spidering/googlenews/") + Pathname.new(ARGV[0])

#pp Time.now.to_s
#pp Time.now.year

#loop{
  t = Time.now
  output_directory_name = t.strftime "%Y-%m-%d-%H-%M-%S"
  output_dirctory_path = Pathname.pwd + Pathname.new(output_directory_name)
  pp output_dirctory_path

  Dir.mkdir(output_dirctory_path)

  #コマンド部
  ajax_url_start_propaty_index = 0
  command_part1_str =  "curl -e http://www.my-ajax-site.com 'http://ajax.googleapis.com/ajax/services/search/news?\
  v=1.0&rsz=large&scoring=d&topic=p&hl=ja&ned=jp&geo=japan&start="
  command_part2_str = "' > "

  #出力パス部
  output_filename_str = "GoogleNews"
  output_filename_kakuchoshi_str = ".json"

  #json_parser = JsonParser.new

  catch(:exit){
    loop{
      #リクエストするためのコマンド文字列を生成
      output_filename =  output_filename_str + ajax_url_start_propaty_index.to_s + output_filename_kakuchoshi_str
      output_file_path = output_dirctory_path + output_filename

      command_string = command_part1_str + ajax_url_start_propaty_index.to_s + command_part2_str + output_file_path.to_s

      pp output_file_path

      puts command_string

      #コマンド実行
      system(command_string)

      #JSONをパースしてステータスコードをチェックして２００以外の時Spideringを終了
      open(output_file_path, "r"){|json_file|
        p json_file

        json_hash  = JSON.parse(json_file.gets.chomp)

        puts "*****************"
        p json_hash["responseStatus"]
        p json_hash["responseDetails"]
        p json_hash["responseDetails"].class

        #エラーの場合
        if json_hash["responseStatus"] != 200 || json_hash["responseData"] == nil
          FileUtils.rm(output_file_path)
          throw :exit
        end
      }

      #ステータスコードが正常なときは次のインデックスの準備
      ajax_url_start_propaty_index += 8
    }
  }
#  sleep(1800)
#}
