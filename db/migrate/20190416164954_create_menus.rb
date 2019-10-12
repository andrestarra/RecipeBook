class CreateMenus < ActiveRecord::Migration[5.2]
  def change
    create_table :menus do |t|
      t.string :name
      t.string :type_menu
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
