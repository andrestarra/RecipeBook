class CreateUtilities < ActiveRecord::Migration[5.2]
  def change
    create_table :utilities do |t|
      t.references :step, foreign_key: true
      t.references :utensil, foreign_key: true

      t.timestamps
    end
  end
end
