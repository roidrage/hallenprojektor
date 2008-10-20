require 'osx/cocoa'
require 'notification_hub'
require 'json/pure'
require 'place'

class PlacesController < OSX::NSWindowController
  include NotificationHub
  attr_accessor :places
  
  def find_all
    LoadOperationQueue.queue_request Place.places_url, self, :on_success => :found_all
  end
  
  def found_all(data)
    set_places JSON.parser.new(data).parse
    notify_places_loaded nil
  end
  
  def set_places(places)
    @places = []
    places[1].each do |place|
      p = Place.new
      p.name = place['place']['name']
      p.city = place['place']['city']
      p.permalink = place['place']['permalink']
      @places << p
    end
  end
end