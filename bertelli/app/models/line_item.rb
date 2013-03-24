class LineItem < ActiveRecord::Base
  belongs_to :bucket
  attr_accessible :bucket_id, :performer_id
end
