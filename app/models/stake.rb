class Stake < ActiveRecord::Base
  belongs_to :user
  belongs_to :item

  validates_presence_of :user_id, :item_id, :sum


  def self.get_chart_data
    data = Stake.group(:user_id).count
    new_data = {}
    data.each do |k,v|
      new_data[User.find(k).email] = v
    end
    User.find_each do |user|
      if new_data[user.email] == nil
        new_data[user.email] = 0
      end
    end
    new_data
  end
end
