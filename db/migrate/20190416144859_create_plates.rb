class CreatePlates < ActiveRecord::Migration[5.2]
  def change
    create_table :plates do |t|
      t.string :name
      t.string :main_ingredient
      t.string :type_plate
      t.float :price
      t.string :comment
      t.references :menu, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
