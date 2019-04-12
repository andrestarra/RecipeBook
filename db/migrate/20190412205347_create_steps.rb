class CreateSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :steps do |t|
      t.string :operation
      t.time :schedule_time
      t.string :comment

      t.timestamps
    end
  end
end
