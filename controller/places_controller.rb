require 'osx/cocoa'
require 'notification_hub'
require 'json/pure'

class PlacesController < OSX::NSWindowController
  include NotificationHub
  attr_accessor :places
  
  def find_all
    LoadOperationQueue.queue_request Place.places_url, self, :on_success => :found_all
  end
  
  def found_all(data)
    @places = JSON.parser.new(data).parse
    notify_places_loaded nil
  end
end