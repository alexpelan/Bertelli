class LineItem < ActiveRecord::Base
  belongs_to :bucket
  belongs_to :performer
  attr_accessible :bucket_id, :performer_id
end
