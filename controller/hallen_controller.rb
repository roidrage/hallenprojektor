#
#  hallen_controller.rb
#  hallenprojektor
#
#  Created by Pom on 20.10.08.
#  Copyright (c) 2008 agelion. All rights reserved.
#

require 'osx/cocoa'
require 'rubygems'
require 'place'
require 'notification_hub'
require 'places_controller'

class HallenController < OSX::NSWindowController
  include NotificationHub
  
  notify :update_places_menu, :when => :places_loaded
  
  ib_outlet :username_field
  ib_outlet :password_field
  
  ib_action :try_login
  
  def awakeFromNib
    setup_status_menu
    @places_controller = PlacesController.alloc.init
    @places_controller.find_all
  end
  
  def try_login
    
  end
  
  def update_places_menu(notification)
    @places_controller.places[1].each do |place|
      item = @menu_item.menu.insertItemWithTitle_action_keyEquivalent_atIndex_("#{place['place']['name']} in #{place['place']['city']}", nil, "", @menu_item.menu.numberOfItems)
      item.setTarget self
    end
  end
  
  def setup_status_menu
    @status_menu = OSX::NSMenu.alloc.init
    
    @menu_item = OSX::NSStatusBar.systemStatusBar.statusItemWithLength(OSX::NSVariableStatusItemLength)
    @menu_item.setHighlightMode true
    @menu_item.setMenu @status_menu
    @menu_item.setTarget self
    @menu_item.setTitle "HP"
  end
end
