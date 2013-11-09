class Pad < ActiveRecord::Base
  scope :active, -> { where(is_deleted: false) }

  # validations
  validates :key, presence: true
  validates :revision, format: { with: /\A20[0-9][0-9]-[01][0-9][0-3][0-9]-[012][0-9][0-6][0-9]\Z/ }
  validates :content, length: { minimum: 1, maximum: 1024 }

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

  # smarter save
  def save
    # populate parameters
    self.key = self.key.presence || Pad.generate_key
    self.revision = self.revision.presence || Time.now.strftime('%Y-%m%d-%H%M')
    self.content = self.content.presence || ''
    self.is_autosaved = self.is_autosaved.presence || false
    self.is_deleted = self.is_deleted.presence || false

    # same revision already exists?
    pad = Pad.find_one(key, revision)

    # check if new record needed
    if pad.present?
      if is_autosaved && !pad.is_autosaved
        # automatically saved pad cannot overwrite manually did one
        return true
      else
        # destroy pad with same revision
        pad.destroy!
      end
    end

    # super save
    super
  end

  # smater save!
  def save!
    save || raise(RecordNotSaved)
  end

  private
  def self.generate_key
    # TODO キーの存在を確認する(256億あるからいい気もする)
    chars = 'abcdefghkmnoprstuxyz'
    Array.new(4){ chars.split('')[rand(chars.size)] }.join + '-' + Array.new(4){ chars.split('')[rand(chars.size)] }.join
  end
end
