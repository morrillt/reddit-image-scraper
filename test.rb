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


#Returns a json dump from subredit URL

class  RedditParser
  
  def initialize(url)
    
    getPhotoStack()
    findBiggestPhotoUrl
    @photoSet = []
    
  end 
  
  def getPhotoStack
    

  end  
  
  # returns parsed json from reddit api / json url
  def getJson(redditUrl)
    
  end
  
  #Returns the link to the largest url on a given HTML page.
  def findBiggestPhotoUrl
    # @parsedJson['data']['children'].each { |dogurl| dogurl['data']['url'] NEED TO ADD CLOSING } 
    parsedJson 
    
    response = RestClient.get(redditUrl)
    parsedJson = JSON.parse(response)
    
    dogurl =  parsedJson['data']['children'][0]['data']['url']
    response = RestClient.get(dogurl)
    @doc = Nokogiri::HTML(response.body)
    
    highestPicLength = 0
    @doc.css("img").each do |node|
      puts "looking up imgs"
      imgurl = node['src']
      response = RestClient.get imgurl, :accept => 'image/jpeg'
     # puts " \n\n\n\n\n #{imgurl} \n\n"
     # puts "\n\n length: #{response.headers[:content_length]} \n\n"
      length = response.headers[:content_length].to_i
      puts response.headers.inspect
    
      if length > highestPicLength
        highestPicLength = length;
        @besturl = imgurl
      end
    end
    puts @besturl
    @besturl
  end
end

  
herewego = RedditParser.new('http://api.reddit.com/r/dogfort.json')

















