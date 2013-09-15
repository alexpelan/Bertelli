class Performer < ActiveRecord::Base
  attr_accessible :image_url, :name, :ticket_url, :test
  belongs_to :line_item
end
