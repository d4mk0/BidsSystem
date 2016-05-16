class Item < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :name, :start_sum, :user_id, :min_step
  validates_numericality_of :start_sum, :min_step, greater_than: 0

  def current_sum
    start_sum
  end

  def min_stake
    current_sum + min_step
  end
end
