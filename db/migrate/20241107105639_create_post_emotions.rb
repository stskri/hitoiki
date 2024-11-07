class CreatePostEmotions < ActiveRecord::Migration[6.1]
  def change
    create_table :post_emotions do |t|

      t.integer :post_id, null: false
      t.integer :emotion_id, null: false
      t.string :emotion_name, null: false
      t.string :emotion_dolor, null: false

      t.timestamps
    end
  end
end
