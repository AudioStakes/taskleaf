class AddFinishedToTasks < ActiveRecord::Migration[5.2]
  class Task < ActiveRecord::Base
  end
  
  def up
    add_column :tasks, :finished, :boolean, null: false, default: false

    Task.find_each do |task|
      task.update!(finished: true)
    end
  end

  def down
    remove_column :tasks, :finished
  end
end
