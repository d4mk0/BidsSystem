class Item < ActiveRecord::Base
  belongs_to :user
  has_many :stakes

  validates_presence_of :name, :start_sum, :user_id, :min_step, :ends_at
  validates_numericality_of :start_sum, :min_step, greater_than: 0
  validate :check_ends_at

  mount_uploader :image, ItemImageUploader

  def current_sum
    if last_stake.present?
      last_stake.sum
    else
      start_sum
    end
  end

  def min_stake
    current_sum + min_step
  end

  def create_stake(sum, user)
    if sum < min_stake
      "Сумма ставки должна быть больше минимальной ставки"
    elsif user.current_balance < sum
      "Вашего баланса недостаточно для ставки. Баланс #{user.current_balance}. Ставка #{sum}"
    elsif last_stake.present? && last_stake.user == user
      "Вы не можете перебить свою ставку"
    else
      prev_stake = last_stake
      stake = stakes.create(sum: sum, user: user)
      user.update(current_balance: (user.current_balance - stake.sum), frozen_balance: (user.frozen_balance + stake.sum))
      if prev_stake.present?
        prev_stake.user.update(current_balance: (prev_stake.user.current_balance + prev_stake.sum), frozen_balance: (prev_stake.user.frozen_balance - prev_stake.sum))
      end

      stake
    end
  end

  def ends_through_in_seconds
    (ends_at - Time.now).to_i
  end

  def active?
    ends_at > Time.now
  end

  def last_stake
    stakes.order(created_at: :desc).first
  end

  def check_ends_at
    if ends_at <= Time.now
      errors.add :ends_at, "Время должно быть больше текущего"
    end
  end
end
