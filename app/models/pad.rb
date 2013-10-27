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

  # save pad by key, content and is_autosaved
  def self.save(key, content, is_autosaved = false)
    # calculate revision to save
    revision = Time.now.strftime('%Y-%m%d-%H%M')

    # already exists?
    pad = self.find_one(key, revision).presence || self.new

    # automatically saved pad cannot overwrite manually did one
    return true if is_autosaved && !pad.is_autosaved

    # fill fields
    pad.key = key
    pad.revision = revision
    pad.content = content
    pad.is_autosaved = is_autosaved
    pad.is_deleted = false

    # save
    pad.save
  end

  # force to save
  def self.save!(key, content, is_autosaved = false)
    result = self.save(key, content, is_autosaved)
    raise unless result
    result
  end
end
