class AddUserIdToTasks < ActiveRecord::Migration[5.2]
  def up
    execute 'DELETE FROM tasks;'
    add_reference :tasks, :user, null: false, index: true
  end

  def down remo
    remove_reference :tasks, :user, index: true
  end
end
