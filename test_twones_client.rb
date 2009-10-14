require 'twones_client'

user_credentials      =  {'username' => 'marcelcorso', 
                          'password' => 'lalala'}
service_credentials   =  {'name' => 'marcel_playground', 
                          'apikey' => '9593158c585c6e5518dc7f04b4b33cb41d09504c'}

TwonesClient.api_base_url = 'http://api.localhost.twones.com:8888/v3'
t = TwonesClient.new(service_credentials, user_credentials)

play_data = {'title' => 'Like A Diamond 33', 
              'creator' => 'Glass Ghost 99', 
              'location' => 'http://westernvinyl.com/audio/WV66_LAD.mp3',
              'link' => [{'http://twones.com/ns/jspf#pageLink' => 'http://cool_and_fancy_blog.com/glass_ghost'}]}

puts 'going to join the service ...'
t.join()
puts 'joined!'

puts 'going to play...'
t.play(play_data)
puts 'played!'



puts 'going to shout...'
t.shout(play_data, 
        'Amazing track! Makes me shiver all the time')
puts 'shouted!'



puts 'going to favorite...'
t.favorite(play_data, 
           ['new age', 'godspell', 'gabber', 'trance'])
puts 'favorited!'
