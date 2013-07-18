class AddPhotoToPost < ActiveRecord::Migration
  def change
    rename_column :posts, :photo_url, :photo
  end
end
