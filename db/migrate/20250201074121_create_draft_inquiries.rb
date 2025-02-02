class CreateDraftInquiries < ActiveRecord::Migration[6.1]
  def change
    create_table :draft_inquiries do |t|

      t.references :user, null: false, foreign_key: true
      t.text :body
      t.integer :genre
      t.boolean :is_active, null: false, default: true

      t.timestamps
    end
  end
end
