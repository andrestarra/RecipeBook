class CreateUtensils < ActiveRecord::Migration[5.2]
  def change
    create_table :utensils do |t|
      t.string :name

      t.timestamps
    end
  end
end
