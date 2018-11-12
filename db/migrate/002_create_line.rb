class CreateLine < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.string :name
      t.string :colour
    end
  end
end
