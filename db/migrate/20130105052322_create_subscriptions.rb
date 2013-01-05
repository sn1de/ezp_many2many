class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :subscriber_id
      t.integer :magazine_id
      t.date :start
      t.integer :duration

      t.timestamps
    end
  end
end
