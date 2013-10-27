class CreatePads < ActiveRecord::Migration
  def change
    create_table :pads do |t|
      t.string :key, null: false
      t.string :revision, null: false
      t.text :content
      t.boolean :is_autosaved, null: false
      t.boolean :is_deleted, null: false

      t.index [:key, :revision, :is_deleted], unique: true
      t.index [:key, :revision, :is_autosaved, :is_deleted]

      t.timestamps
    end
  end
end
