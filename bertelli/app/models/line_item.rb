class LineItem < ActiveRecord::Base
  belongs_to :performer
  belongs_to :bucket
  attr_accessible :bucket_id, :performer_id
end
