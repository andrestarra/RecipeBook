class CreateSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :steps do |t|
      t.string :operation
      t.float :expected_minutes
      t.string :comment

      t.timestamps
    end
  end
end
