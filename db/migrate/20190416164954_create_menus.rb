class CreateMenus < ActiveRecord::Migration[5.2]
  def change
    create_table :menus do |t|
      t.string :name
      t.string :type_menu

      t.timestamps
    end
  end
end
