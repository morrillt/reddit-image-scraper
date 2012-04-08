#Subreddit Image Scraper by Todd Morrill
#My first Ruby Script
#
#This is a simple script that takes a subredit that is known for to be an image share subredit, and returns a list of image urls
# todo - integrate typhoeus by paul dix for multithreaded event processing



require 'rubygems'
require 'json'
require 'net/http'
require 'rest_client'
require 'nokogiri'


#Returns a json dump from subredit
def open_subredit(url)
  url = 'http://api.reddit.com/r/dogfort.json'
  
  response = RestClient.get(url)

  newobject = JSON.parse(response)

  # newobject['data']['children'].each { |dogurl| dogurl['data']['url'] NEED TO ADD CLOSING } 

  dogurl =  newobject['data']['children'][0]['data']['url']

  response = RestClient.get(dogurl)
end

open_subredit 'http://api.reddit.com/r/dogfort.json'






doc = Nokogiri::HTML(response.body)

blip = doc.css('img')




doc.css("img").each do |node|
  # node.src

  puts "looking up imgs"
  imgurl = node['src']
  
  response = RestClient.get imgurl, :accept => 'image/jpeg'
  puts " \n\n\n\n\n #{imgurl} \n\n"
  puts "\n\n length: #{response.headers[:content_length]} \n\n"
  puts response.headers.inspect
  
end




