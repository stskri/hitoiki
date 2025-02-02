class CreateDraftPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :draft_posts do |t|

      t.references :user, null: false, foreign_key: true
      t.string :body
      t.boolean :is_public, null: false, default: true

      t.timestamps
    end
  end
end
