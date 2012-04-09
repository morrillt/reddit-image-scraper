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
  attr_accessor :photo_set
  
  def initialize(redditURL)
    
    @photo_set = []
    
    #Call up url, and get some json, then parse it
    response = RestClient.get(redditURL)
    parsedJson = JSON.parse(response)
    
    puts "checking all urls received from #{redditURL} \n\n"
    
    counter = 0
    while parsedJson['data']['children'][counter] != nil
      imagesURL =  parsedJson['data']['children'][counter]['data']['url']
      puts "Photo from reddit node #{counter} is url:#{imagesURL}\n\n"
      counter += 1
    end
    
    
    
    getPhotoStack(parsedJson)
    
    
  end 
  
  #Gets photo for each reddit data node.
  def getPhotoStack(parsedJson)
    counter = 0
    while parsedJson['data']['children'][counter] != nil
      imagesURL =  parsedJson['data']['children'][counter]['data']['url']
      
      #Following  conditional treats case where link in reddit node is a .jpg or .png
      puts "tester #{imagesURL[-4]}"
      if imagesURL[-4] == '.'
        return imagesURL 
        
      else
      biggestPhotoUrl = findBiggestPhotoUrl(imagesURL)
      puts "\n\n Photo from reddit node #{counter} from url:#{imagesURL} -  #{biggestPhotoUrl} \n\n"
      @photo_set << biggestPhotoUrl
      counter += 1
      end
    end
    

  end  
  
  # returns parsed json from reddit api / json url
  #Returns the link to the largest url on a given HTML page.
  def findBiggestPhotoUrl(imagesURL)
    # @parsedJson['data']['children'].each { |dogurl| dogurl['data']['url'] NEED TO ADD CLOSING } 
    
    #debug puts imagesURL
    
    response = RestClient.get(imagesURL)
    @doc = Nokogiri::HTML(response.body)
    
    highestPicLength = 0
    
    bestURL = 0;
    
    #debug puts @doc.inspect
    
    @doc.css("img").each do |node|
      imgurl = node['src']
      response = RestClient.get imgurl, :accept => 'image/jpeg'
     #debug puts " \n\n\n\n\n #{imgurl} \n\n"
     #debug puts "\n\n length: #{response.headers[:content_length]} \n\n"
      length = response.headers[:content_length].to_i
    
      if length > highestPicLength
        highestPicLength = length;
        bestURL = imgurl
      end
      
    end
    #debug puts bestURL
    bestURL
  end
end


herewego = RedditParser.new('http://api.reddit.com/r/dogfort.json')

















