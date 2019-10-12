class CreateUses < ActiveRecord::Migration[5.2]
  def change
    create_table :uses do |t|
      t.integer :quantity
      t.string :measure
      t.references :step, foreign_key: true
      t.references :ingredient, foreign_key: true
      t.index %i[step_id ingredient_id], unique: true

      t.timestamps
    end
  end
end
