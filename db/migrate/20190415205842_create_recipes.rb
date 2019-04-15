class CreateRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :recipes do |t|
      t.string :source
      t.string :location
      t.float :total_minutes

      t.timestamps
    end
  end
end
