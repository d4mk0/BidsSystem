class Stake < ActiveRecord::Base
  belongs_to :user
  belongs_to :item

  validates_presence_of :user_id, :item_id, :sum
end
