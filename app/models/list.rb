class List < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  has_many :items, -> { order('created_at DESC') }

  @total = 0
  attr_accessor :total

  def is_local?
    source.blank?
  end

  def is_external?
    !is_local?
  end

  def item_for_url(url)
    matches = items.select{|item| item.url == url}
    if matches.count > 0
      matches[0]
    else
      nil
    end
  end
end
