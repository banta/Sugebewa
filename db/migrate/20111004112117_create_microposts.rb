class CreateMicroposts < ActiveRecord::Migration
  def self.up
    create_table :microposts do |t|
      t.string :content
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :microposts
  end
end
