
=begin

Le fourre-tout:

{
 "playlist" : {
   "meta"          : [
     {"http://twones.com/ns/jspf#authName"    : "marcelcorso"},
     {"http://twones.com/ns/jspf#authPassword"   : "lalala"}
     {"http://twones.com/ns/jspf#metaService" : "fake_hypem"},
     {"http://twones.com/ns/jspf#metaApiKey"  : "1234" }
   ],
   "track"         : [
     {
       "location"      : "http://example.com/2.mp3",
       "identifier"    : "http://example.com/1/",
       "title"         : "Track title",
       "creator"       : "Artist name",
       "annotation"    : "Some text",
       "info"          : "http://example.com/",
       "image"         : "http://example.com/",
       "album"         : "Album name",
       "trackNum"      : 1,
       "duration"      : 0,
       "link"          : [
         {"http://twones.com/ns/jspf#pageLink" : "http://www.last.fm/listen/globaltags/late%20night%20music"}
       ],
       "meta"          : [
        {"http://twones.com/ns/jspf#playlists" : ["metal", "rock"]},
       ]
     }
   ]
 }
}

=end 


require 'net/http'
require 'uri'

require 'rubygems'
require 'json'  # gem install json


class TwonesClient 
  
  @@api_base_url = 'http://api.twones.com/v3'
  def self.api_base_url=(url)
    @@api_base_url = url
  end
  def self.api_base_url
    @@api_base_url
  end
  
  def initialize(service_credentials, user_credentials)
    @service_credentials, @user_credentials = service_credentials, user_credentials
  end  
  
  def play(track)
    post('plays', 'playlist' => {'track' => [track], 'meta' => build_meta})
  end
  
  def favorite(track, playlists = [])
    track['meta'] = [{'http://twones.com/ns/jspf#playlists' => playlists}]
    post('favorites', 'playlist' => {'track' => [track], 'meta' => build_meta})
  end
  
  def shout(track, shout)
    track['annotation'] = shout
    post('shouts', 'playlist' => {'track' => [track], 'meta' => build_meta})
  end
 
  def join()
    post('members', build_meta_flat, 'member')
  end
 
  private
  
  def build_meta
    [{"http://twones.com/ns/jspf#authName" => @user_credentials['username']},
     {"http://twones.com/ns/jspf#authPassword" => @user_credentials['password']},
     {"http://twones.com/ns/jspf#metaService" => @service_credentials['name']},
     {"http://twones.com/ns/jspf#metaApiKey" => @service_credentials['apikey']}]
  end
  
  def build_meta_flat
    {"http://twones.com/ns/jspf#authName" => @user_credentials['username'],
    "http://twones.com/ns/jspf#authPassword" => @user_credentials['password'],
    "http://twones.com/ns/jspf#metaService" => @service_credentials['name'],
    "http://twones.com/ns/jspf#metaApiKey" => @service_credentials['apikey']}
  end

  def post(collection, data, post_field = 'playlist')
    url = URI.parse(File.join(TwonesClient.api_base_url, collection))
    req = Net::HTTP::Post.new(url.path)
    req.set_form_data({post_field => data.to_json})
    res = Net::HTTP.new(url.host, url.port).start {|http| 
      http.request(req) 
    }
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      # OK
    else
      res.error!
    end    
  end
  
end
