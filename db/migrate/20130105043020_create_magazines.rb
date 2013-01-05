class CreateMagazines < ActiveRecord::Migration
  def change
    create_table :magazines do |t|
      t.string :title
      t.text :description
      t.string :editor

      t.timestamps
    end
  end
end
