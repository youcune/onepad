class Pad < ActiveRecord::Base
  scope :active, -> { where(is_deleted: false) }

  # returns latest pad by key
  def self.find_latest(key)
    self.active
      .where(key: key, is_autosaved: false)
      .order(:revision)
      .last
  end

  # returns a pad by key and revision
  def self.find_one(key, revision)
    self.active
      .where(key: key, revision: revision)
      .first
  end

  # returns all pads by key
  def self.find_all(key)
    self.active
    .where(key: key)
    .order(:revision)
    .reverse_order
  end
end
