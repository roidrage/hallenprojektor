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
  include OSX
  
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

  def place_clicked(sender)
    puts sender.representedObject
  end
  
  def update_places_menu(notification)
    places = @places_controller.places
    
    cities = places.collect do |place|
      place.city
    end.uniq
    
    cities.sort.each do |city|
      city_item = @menu_item.menu.insertItemWithTitle_action_keyEquivalent_atIndex_("#{city}", nil, "", @menu_item.menu.numberOfItems)
      places_menu = NSMenu.alloc.init
      places.find_all{|p| p.city == city}.sort{|place1, place2| place1.name <=> place2.name}.each do |place|
        place_item = places_menu.insertItemWithTitle_action_keyEquivalent_atIndex_("#{place.name}", "place_clicked:", "", places_menu.numberOfItems)
        place_item.setTarget self
        place_item.setEnabled true
        place_item.setRepresentedObject place
      end
      city_item.setTarget self
      places_menu.setAutoenablesItems false
      city_item.setSubmenu places_menu
      city_item.setEnabled true
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
