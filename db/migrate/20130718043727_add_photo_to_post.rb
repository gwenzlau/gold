class AddPhotoToPost < ActiveRecord::Migration
  def change
    add_column :posts, :photo_url, :photo
  end
end
