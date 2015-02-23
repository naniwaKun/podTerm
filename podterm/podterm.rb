#!/usr/bin/env ruby

require 'rss'
require "json"

def addpodcast(feeds,url)

rss = RSS::Parser.parse(url)
profile = {}

profile['url'] = url
profile['title'] = rss.channel.title.gsub(/(\s)/,"")
profile['des'] = rss.channel.description.gsub(/(\s)/,"").gsub(/<\/?[^>]*>/, "")

  urls = Array.new()
  if File.exist?(feeds) then
    File.open(feeds,"r") do |file|
      urls =  JSON.parse(file.read)
      urls.push(profile)
      urls.uniq!
    end

    File.open(feeds,"w") do |file|
      file.puts JSON.dump(urls)
    end

  else
    File.open(feeds,"w") do |file|
      urls.push(profile)
      file.puts  JSON.dump(urls)
    end
  end

end

def viewpodcast(feeds)
  profiles = Array.new()
  if File.exist?(feeds) then
    File.open(feeds,"r") do |file|
      profiles =  JSON.parse(file.read)
    end
  end

  profiles.each_with_index{|podcast , index|
    print "\e[35m"
    print "No.#{index+1}"
    puts "\e[0m"
    puts "Title:\t\t" + podcast["title"]
    	puts "Description:\t" + podcast["des"]
  }
    puts
  print "\e[35m"
  print "Type Byte Number :"  
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
    print "Not existing audio file ..."
end
puts "\e[0m"
    puts "Title:\t\t" + item.title.gsub(/(\s)/,"")
#    puts "Description:\t" + item.description.gsub(/(\s)/,"")
  }
    puts
  print "\e[35m"
  print "Type Byte Number :"  
  print "\e[0m"
  num = gets.chomp
  rss.items.reverse!
 rss.items[num.to_i - 1 ].enclosure.url
end

#main


base =  File.expand_path('~') + "/.Podterm";
feeds = base + "/feedUrl";
playlist = base + "/audioUrl";

if !File.exist?(base) then
  Dir::mkdir(base)
  if ARGV[0] == nil then
    puts 'Please run command this : $ pot "podcast feed url"'
    exit
  else
    addpodcast(feeds,ARGV[0])
  end
end


  if !File.exist?(feeds) and ARGV[0] == nil then
    puts 'Please run command this : $ pot "podcast feed url"'
    exit
  end

  if ARGV[0] != nil then
    addpodcast(feeds,ARGV[0])
    exit
  else
  url = viewpodcast(feeds)
  mp3url = viewItems(url)
  File.open(playlist,"w") do |file|
    file.puts mp3url
  end
  end


