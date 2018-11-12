class CreateStops < ActiveRecord::Migration[4.2]
  def change
    create_table :stops do|t|
      t.belongs_to :station
      t.belongs_to :line
    end
  end


end
