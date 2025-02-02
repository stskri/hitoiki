class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|

      t.integer :user_id, null: false
      t.string :body, null: false
      t.boolean :is_public, null: false, default: true

      t.timestamps
    end
  end
end
