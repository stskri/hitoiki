class CreateInquiries < ActiveRecord::Migration[6.1]
  def change
    create_table :inquiries do |t|

      t.integer :user_id, null: false
      t.text :body, null: false
      t.integer :genre, null: false
      t.boolean :is_active, null: false, default: true

      t.timestamps
    end
  end
end
