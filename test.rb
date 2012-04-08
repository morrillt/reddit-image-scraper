# todo - integrate typhoeus by paul dix

def hello
  puts "hello"
end

hello

require 'rubygems'
require 'json'
require 'net/http'
require 'rest_client'
require 'nokogiri'
require 'net/http'

url = 'http://api.reddit.com/r/dogfort.json'
 
response = RestClient.get(url)

newobject = JSON.parse(response)

# newobject['data']['children'].each { |dogurl| dogurl['data']['url'] NEED TO ADD CLOSING } 

dogurl =  newobject['data']['children'][0]['data']['url']

response = RestClient.get(dogurl)

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




