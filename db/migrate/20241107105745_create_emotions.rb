class CreateEmotions < ActiveRecord::Migration[6.1]
  def change
    create_table :emotions do |t|

      t.string :name, null: false
      t.string :color, null: false

      t.timestamps
    end
    add_index :emotions, [:name, :color], unique: true
  end
end
