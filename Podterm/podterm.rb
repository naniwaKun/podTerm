#!/usr/bin/env ruby

require 'rss'
require "json"

def addpodcast(filename,url)

rss = RSS::Parser.parse(url)
profile = {}

profile['url'] = url
profile['title'] = rss.channel.title.gsub(/(\s)/,"")
profile['des'] = rss.channel.description.gsub(/(\s)/,"").gsub(/<\/?[^>]*>/, "")

  urls = Array.new()
  if File.exist?(filename) then
    File.open(filename,"r") do |file|
      urls =  JSON.parse(file.read)
      urls.push(profile)
      urls.uniq!
    end

    File.open(filename,"w") do |file|
      file.puts JSON.dump(urls)
    end

  else
    File.open(filename,"w") do |file|
      urls.push(profile)
      file.puts  JSON.dump(urls)
    end
  end

end

def viewpodcast(filename)
  profiles = Array.new()
  if File.exist?(filename) then
    File.open(filename,"r") do |file|
      profiles =  JSON.parse(file.read)
    end
  end

  profiles.each_with_index{|podcast , index|
    rss = RSS::Parser.parse(podcast["url"])
    print "\e[35m"
    print "No.#{index+1}"
    puts "\e[0m"
    puts "Title:\t\t" + podcast["title"]
    	puts "Description:\t" + podcast["des"]
  }
    puts
  print "\e[35m"
  print "何番のポッドキャストを聞きますか？(半角数字のみ)："  
  print "\e[0m"
  num = gets.chomp

  profiles[num.to_i - 1 ]["url"]
end

def viewItems(url)
  rss = RSS::Parser.parse(url)
  num = rss.items.length
  rss.items.reverse!

  rss.items.each_with_index{|item , index|
    print "\e[35m"
if  (defined? (item.enclosure.url) )
    print "No.#{num - index}"
else 
    print "No.#{num - index}"
    print "\e[33m"
    print "音声ファイルがないようです。。"
end
puts "\e[0m"
    puts "Title:\t\t" + item.title.gsub(/(\s)/,"")
    puts "Description:\t" + item.description.gsub(/(\s)/,"").gsub(/<\/?[^>]*>/, "")
  }
    puts
  print "\e[35m"
  print "何番のエピソードを聞きますか？(半角数字のみ)："  
  print "\e[0m"
  num = gets.chomp
 rss.items[num.to_i - 1 ].enclosure.url
end

filename = File.expand_path('~') + "/.Podterm/urls";
tmpurl = File.expand_path('~') + "/.Podterm/mp3url";

if ARGV[0] == nil then
    url = viewpodcast(filename)
    mp3url = viewItems(url)
    File.open(tmpurl,"w") do |file|
            file.puts mp3url
    end
else
   addpodcast(filename,ARGV[0])
end


