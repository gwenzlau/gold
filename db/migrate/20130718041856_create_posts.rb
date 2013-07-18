class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :content
      t.decimal :lat
      t.decimal :lng
      t.string :photo_url
      t.string :submitted_by

      t.timestamps
    end
  end
end
