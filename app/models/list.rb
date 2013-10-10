class List < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  has_many :items

  @total = 0
  attr_accessor :total

  def is_local?
    source.blank?
  end

  def is_external?
    !is_local?
  end
end
