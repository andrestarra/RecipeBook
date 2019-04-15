class DropTableMenus < ActiveRecord::Migration[5.2]
  def change
    drop_table :menus
  end
end
