#
#  place.rb
#  hallenprojektor
#
#  Created by Pom on 20.10.08.
#  Copyright (c) 2008 agelion. All rights reserved.
#

require 'osx/cocoa'
require 'load_operation_queue'
require 'notification_hub'

class Place < OSX::NSObject
  include NotificationHub
  
  def self.places_url
    "http://hallenprojekt.de/places.json"
  end
end
