class AddTflColumnToLine < ActiveRecord::Migration[4.2]
  def change
    add_column :lines, :tfl_id, :string
  end
end
