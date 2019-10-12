class CreateRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :recipes do |t|
      t.string :source
      t.string :location
      t.float :total_minutes
      t.references :plate, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
